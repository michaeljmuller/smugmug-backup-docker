# SmugMug Backup Docker Image

This repository contains artifacts to build a Docker image that can be used to download all the images and videos from a 
SmugMug account.  

It's a simple docker deployment of Tommaso Visconti's [smugmug-backup](https://github.com/tommyblue/smugmug-backup) project.  I used 
Björn Gernert's [docker-smugmug-backup](https://hub.docker.com/r/bgernert/docker-smugmug-backup) as a starting point for my own 
implementation.  I built my own image because I wanted to make sure I was using the latest code (smugmug-backup seems to be 
actively maintained).

## Building

The `build.sh` script should build the image to the tag `michaeljmuller/smugmug-backup-docker`.  The script assumes 
your current working directory is the root of this project.

```
mmuller@intelmini1:~/dev/smugmug-backup-docker$ ./build.sh 
[+] Building 0.6s (15/15) FINISHED                                                                                                               docker:default
 => [internal] load .dockerignore                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                            0.0s
 => [internal] load build definition from Dockerfile                                                                                                       0.0s
 => => transferring dockerfile: 486B                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/alpine:latest                                                                                           0.5s
 => [internal] load build context                                                                                                                          0.0s
 => => transferring context: 124B                                                                                                                          0.0s
 => [ 1/10] FROM docker.io/library/alpine@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a                                          0.0s
 => CACHED [ 2/10] WORKDIR /root                                                                                                                           0.0s
 => CACHED [ 3/10] RUN apk update                                                                                                                          0.0s
 => CACHED [ 4/10] RUN apk add --no-cache git g++ go make bash                                                                                             0.0s
 => CACHED [ 5/10] RUN git clone https://github.com/tommyblue/smugmug-backup.git                                                                           0.0s
 => CACHED [ 6/10] RUN cd /root/smugmug-backup && make build                                                                                               0.0s
 => CACHED [ 7/10] COPY config.toml.template /root/config.toml.template                                                                                    0.0s
 => CACHED [ 8/10] COPY build-config-from-template.sh /root/build-config-from-template.sh                                                                  0.0s
 => CACHED [ 9/10] COPY entrypoint.sh /root/entrypoint.sh                                                                                                  0.0s
 => CACHED [10/10] RUN mkdir /root/.smgmg                                                                                                                  0.0s
 => exporting to image                                                                                                                                     0.0s
 => => exporting layers                                                                                                                                    0.0s
 => => writing image sha256:8b9b59f6f73c3ab96955081920ab8b858cedcb5c2ec24ad4895179f3792bf0f9                                                               0.0s
 => => naming to docker.io/michaeljmuller/smugmug-backup-docker                                                                                            0.0s
```

## Configuration

This image expects you to mount a volume where the images will be written.  The default path where the 
container writes the photos is `/photos`, but you can change that by setting the `SB_DESTINATION` 
environment variable.

Complete list of environment variables (see [Tommasso's README](https://github.com/tommyblue/smugmug-backup#configuration) 
for explanations):
 - SB_API_KEY
 - SB_API_SECRET
 - SB_USER_TOKEN
 - SB_USER_SECRET
 - SB_DESTINATION
 - SB_FILE_NAMES
 - SB_USE_METADATA_TIMES
 - SB_FORCE_METADATA_TIMES
 - SB_WRITE_CSV
 - SB_FORCE_VIDEO_DOWNLOAD
 - SB_CONCURRENT_ALBUMS
 - SB_CONCURRENT_DOWNLOADS

## Running

Here's sample command to use this image:

```
docker run -it \
       -e "SB_API_KEY=REDACTED" \
       -e "SB_API_SECRET=REDACTED" \
       -e "SB_USER_TOKEN=REDACTED" \
       -e "SB_USER_SECRET=REDACTED" \
       -e "SB_CONCURRENT_ALBUMS=5" \
       -e "SB_CONCURRENT_DOWNLOADS=10" \
       -v /opt/photos/smugmug:/photos \
       michaeljmuller/smugmug-backup-docker
```

FROM alpine

WORKDIR /root

VOLUME /photos

RUN apk update

RUN apk add --no-cache git g++ go make bash

RUN git clone https://github.com/tommyblue/smugmug-backup.git

RUN cd /root/smugmug-backup && make build

COPY config.toml.template /root/config.toml.template
COPY build-config-from-template.sh /root/build-config-from-template.sh
COPY entrypoint.sh /root/entrypoint.sh

RUN mkdir /root/.smgmg

CMD [ "/bin/bash", "-c", "/root/entrypoint.sh" ]
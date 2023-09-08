#!/bin/bash

# adjust the config file based on environment variables 
/root/build-config-from-template.sh /root/config.toml.template /root/.smgmg/config.toml

# run the smugmug backup
/root/smugmug-backup/smugmug-backup

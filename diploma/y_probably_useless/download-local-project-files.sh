#!/bin/bash

printf "\n*********************\n*********************\nDownloading project files (USELESS)\n*********************\n*********************\n\n"

sudo cp -r ~/Public/ ~/diploma && \
sudo chown -R $(whoami):$(whoami) ~/diploma/ && \
mv ~/diploma/* ~/ && \
rm -rf ~/diploma && \
mv ~/c_terraform/ ~/terraform && \
mv ~/c_ansible/ ~/ansible
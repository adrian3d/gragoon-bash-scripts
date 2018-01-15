#!/bin/bash

u="$USER"

wget https://dl.pstmn.io/download/latest/linux64 -O /home/$u/postman.tar.gz
tar -xzf postman.tar.gz -C /home/$u/
sudo cp -R ./Postman/* /opt/postman/
rm /home/$u/postman.tar.gz
rm -rf /home/$u/Postman

#!/bin/bash

u="$USER"

wget https://dl.pstmn.io/download/latest/linux64 -O /home/$u/postman.tar.gz
tar -xzf /home/$u/postman.tar.gz -C /home/$u/
sudo cp -R /home/$u/Postman/* /opt/postman/
rm /home/$u/postman.tar.gz
rm -rf /home/$u/Postman

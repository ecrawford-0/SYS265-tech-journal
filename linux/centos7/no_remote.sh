#!/bin/bash

sudo sed 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config > temp.txt 
sudo mv -f temp.txt /etc/ssh/sshd_config

sudo systemctl restart sshd

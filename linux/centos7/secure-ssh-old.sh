#!/bin/bash
# secure-ssh-server.sh
# author emily crawford
#
# this script will secure ssh on the server end, it will generate a public/private keys
# then upload the key to the remote repo, then this script will disable root login over ssh 

echo "what do you want to call the public key?(leave blank to be hostnme)"
read name

if [ -z $name ]; then name=$(hostname);fi
user=$(whoami)
 
# generate the key with no password and put the files in the .ssh directory
sudo ssh-keygen -t rsa -q -N "" -f /home/$user/.ssh/$name

# upload the public key to github
sudo cp /home/$user/.ssh/$name.pub ../public-keys/$name.pub
cd ../../
git add .

echo "enter the email for github"
read email
echo "enter the username for github"
read username

git config user.email $email
git config user.name $username

git commit -m "adding the public key for so users can ssh via public key on $(hostname)" 
git status
git push

# remove PermitRootLogin in sshd_conf
sudo sed 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config > temp.txt 
sudo mv -f temp.txt /etc/ssh/sshd_config

# restart the service
sudo systemctl restart sshd

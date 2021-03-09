# secure-ssh.sh
# author emily crawford
# creates a new ssh user using the $user parameter
# adds a public key from the local repo or curled from the remote repo
# removes root's ability to ssh in
echo "welcome to secure secure-ssh script, this script will only allow users to ssh into a machine with a public/private key pair, rather than a password"
echo "First a new user needs to be created, what do you want to call the new use:"
read user # get the name for the user

# add the user  
sudo useradd -m -d /home/$user -s /bin/bash $user
 
# create the home directory for the new user
sudo mkdir /home/$user/.ssh

echo " $user has been created, now generating keys"
# generate the key with no password and put the files in the .ssh directory
sudo ssh-keygen -t rsa -q -N "" -f /home/$user/.ssh/$user

# upload the public key to github
sudo cp /home/$user/.ssh/$user.pub ../public-keys/$user.pub
cd ../../
git add .

echo "enter the email for github"
read email
echo "enter the username for github"
read username

git config user.email $email
git config user.name $username

git commit -m "adding the public key for $user" 
git status
git push

# copy the public key to autorized keys folder
sudo cp /home/$user/.ssh/$user.pub /home/$user/.ssh/authorized_keys

# change permissions of .ssh file to read,write,and execute to owner of file, only 
sudo chmod 700 /home/$user/.ssh

# change the permissions of the authorized keys to be read and write for the owner only
sudo chmod 600 /home/$user/.ssh/authorized_keys

# change the owner to be for the user created
sudo chown -R $user:$user /home/$user/.ssh 



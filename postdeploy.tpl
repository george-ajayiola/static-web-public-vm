#!/bin/bash

# Variables
GIT_REPO_URL="https://github.com/george-ajayiola/static-website-hosting-nginx.git"
WEB_DIR="/var/www/html"  

sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Git if it's not installed
echo "Checking if Git is installed..."
if ! [ -x "$(command -v git)" ]; then
  sudo apt-get install git -y
fi

echo "Cloning the Git repository..."
git clone $GIT_REPO_URL /tmp/my-repo

sudo rm -f $WEB_DIR/index.nginx-debian.html

# Copy index.html and the image from the repo to the Nginx web directory
sudo cp /tmp/my-repo/index.html $WEB_DIR/
sudo cp /tmp/my-repo/download.jfif $WEB_DIR/ 

# Set appropriate permissions for the web directory
echo "Setting permissions for the web directory..."
sudo chown -R www-data:www-data $WEB_DIR
sudo chmod -R 755 $WEB_DIR
sudo systemctl restart nginx



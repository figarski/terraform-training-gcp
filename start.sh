#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
echo '<!DOCTYPE html><html><body><h1>Welcome to Hell!</h1></body></html>' | sudo tee /var/www/html/index.html
sudo systemctl start apache2
sudo systemctl enable apache2aa
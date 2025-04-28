#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

# sudo apt-get install -y postgresql postgresql-contrib

# sudo systemctl enable postgresql
# sudo systemctl start postgresql
# sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'newuser123';"
# sudo -u postgres psql -c "CREATE DATABASE mydb;"
sleep 30s
curl -sL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs

sudo apt-get install unzip -y

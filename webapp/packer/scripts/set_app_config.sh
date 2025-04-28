#!/bin/bash

# cd /tmp
# sudo mv /tmp/webapp.zip /opt/csye6225/webapp.zip
# cd /opt/csye6225
# sudo unzip webapp.zip

# sudo npm install

# sudo chown -R csye6225:csye6225 /opt
# sudo chmod +x /opt/csye6225/index.js

# cd /opt/csye6225
# Define the installation directory, source directory, and log directory
INSTALL_DIR="/opt/csye6225"
SRC_DIR="$INSTALL_DIR/src"
LOG_DIR="/var/log/csye6225"
ZIP_FILE="/tmp/webapp.zip"
APP_DIR="$INSTALL_DIR"
ENV_FILE="$APP_DIR/.env"

# Create necessary directories
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$LOG_DIR"

# Move and extract the webapp.zip into the installation directory
sudo mv "$ZIP_FILE" "$INSTALL_DIR"
cd "$INSTALL_DIR"
sudo unzip -o webapp.zip


# Set ownership and permissions for the app files, including the source folder
sudo chown -R csye6225:csye6225 "$INSTALL_DIR"
sudo chmod +x "$SRC_DIR/index.js"
ls -lrt
cd src
ls -lrt

# Ensure that the log directory is created with proper permissions
sudo chown csye6225:csye6225 "$LOG_DIR"

# Install npm dependencies in the application directory
cd "$INSTALL_DIR"
sudo npm install

# echo "DB_HOST=$DB_HOST"
# echo "DB_NAME=$DB_NAME"
# echo "DB_USER=$DB_USER"
# echo "DB_PASSWORD=$DB_PASSWORD"

#Create and populate the .env file with required environment variables
# sudo tee "$ENV_FILE" <<EOL
# DB_PORT=5432
# DB_HOST=${DB_HOST}
# DB_NAME=${DB_NAME}
# DB_USER=${DB_USER}
# DB_PASSWORD=${DB_PASSWORD}
# EOL
echo $SRC_DIR
echo "Web app setup completed successfully."

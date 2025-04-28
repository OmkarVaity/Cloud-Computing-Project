#!/bin/bash

USERNAME="csye6225"
GROUPNAME="csye6225"

if ! getent group "$GROUPNAME" > /dev/null 2>&1; then
    sudo groupadd "$GROUPNAME"
fi

if ! id "$USERNAME" > /dev/null 2>&1; then
    sudo useradd -m -g "$GROUPNAME" -s /usr/sbin/nologin "$USERNAME"
    echo "User '$USERNAME' has been created successfully."
else
    echo "User '$USERNAME' already exists."
fi
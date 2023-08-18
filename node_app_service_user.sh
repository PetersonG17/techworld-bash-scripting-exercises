#!/bin/bash

service_user=appuser

# Ensure app user is created
id -u $service_user
if [[ $? != 0  ]]
then
    echo "No service user detected for app, creating user..."
    sudo useradd $service_user --create-home
else
    echo "Service user detected, skipping service user creation..."
fi

# execute install script as another user
sudo -u $service_user bash ./node_app_log_dir.sh /home/$service_user/logs

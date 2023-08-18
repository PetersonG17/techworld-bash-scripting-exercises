#!/bin/bash

log_dir=$1
if [[ -d $log_dir ]]
then
    echo "Log directory exists: $log_dir"
else
    mkdir $log_dir
    if [[ $? != 0 ]]
    then
        echo "Invalid log directory: $log_dir"
        exit 1
    else
        echo "Created log directory at: $log_dir"
    fi
fi

echo "Updating Repositories..."

apt update -y

echo "Installing NodeJS..."

apt install nodejs -y

echo "NodeJS successfully installed."

node --version

echo "Installing npm..."

apt install npm -y

echo "NPM successfully installed"

npm --version

# Make directory for our temporary wget files
echo "Downloading node application..."

# Ensure the directory exists
temp_dir=$HOME/temp
rm -rf $temp_dir
mkdir -p $temp_dir

# Download node js app
wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz -P $temp_dir

echo "Installing node application..."

# Create app directory
app_dir=$HOME/app
rm -rf $app_dir
mkdir -p $app_dir

tar -zxvf $temp_dir/bootcamp-node-envvars-project-1.0.0.tgz -C $app_dir

# Copy app out of the package folder
cp -a $app_dir/package/. $app_dir
rm -rf $app_dir/package

# Set environment variables for the application
export APP_ENV=dev
export DB_USER=myuser 
export DB_PWD=mysecret
export LOG_DIR=$log_dir

cd $app_dir
npm install

# Clean up temp directory
echo "Cleaning up..."
rm -rf $temp_dir

# Start node application
echo "Starting node application in background..."
node server.js > $app_dir/startup.log &

sleep 1

# Determine if it started up successfully or not
cat $app_dir/startup.log | grep -Po '(successful)'
if [[ $? == 0 ]]
then
    port=$(cat $app_dir/startup.log | grep -Po '(?!port )([0-9]*)')
    echo "Application successfully running on port: $port"
else
    echo "Application startup failed."
fi




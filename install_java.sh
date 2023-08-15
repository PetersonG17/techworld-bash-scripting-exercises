#!/bin/bash

function installJava() {
    echo "Updating Repositories..."

    apt update

    echo "Installing Java..."

    apt install openjdk-11-jre-headless -y
    result=$?

    if [[ $(($result == 0)) ]]
    then
        version=$(java --version | grep -Po "(?<!^openjdk)([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ")
        major=$(echo $version | grep -Po "(^[0-9]{1,3})")

        echo "Java version $version successfully installed"
    else
        echo "Error installing Java"
    fi
}

# Check if java is installed
java --version > /dev/null
is_installed=$?

if [[ $is_installed != 0 ]]
then
    echo "Java not installed. Installing..."
    installJava
else
    echo "Java installed. Checking Version..."

    version=$(java --version | grep -Po "(?<!^openjdk)([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ")
    major=$(echo $version | grep -Po "(^[0-9]{1,3})")

    # Skip install due to version
    if [[ $(($major >= 0)) ]]
    then
        echo "Skipping install. Java version: $version is already installed."
    else
        installJava
    fi
fi

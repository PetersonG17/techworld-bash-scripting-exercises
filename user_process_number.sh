#!/bin/bash

current_user=$(whoami)

read -p "Enter the number of processes to see: " input

echo "Current processes for user: $current_user"

num_process=$(($input + 1))

echo "$(ps aux --sort -%cpu | head -n $num_process | grep "$current_user")"

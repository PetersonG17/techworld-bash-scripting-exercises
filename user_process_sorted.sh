#!/bin/bash

current_user=$(whoami)

echo "Current processes for user: $current_user"

echo "$(ps aux --sort -%cpu | grep "$current_user")"

#!/bin/bash

current_user=$(whoami)

echo "Current processes for user: $current_user"

echo "$(ps aux | grep "$current_user")"

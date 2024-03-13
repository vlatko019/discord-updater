#!/bin/bash

# URL to download the file
download_url="https://discord.com/api/download?platform=linux&format=tar.gz"

# Directory where the file will be downloaded
download_dir="/tmp"

echo "Downloading file from $download_url..."
# Download the file
# Check if download was successful
if ! wget -q "$download_url" -O "$download_dir/discord-latest.tar.gz"; then
    echo "Error: Failed to download the file."
    exit 1
fi

# Find the downloaded file in the download directory
downloaded_file=$(find "$download_dir" -maxdepth 1 -type f -name 'discord*.tar.gz' -printf '%f\n')

# Check if a file was found
if [ -z "$downloaded_file" ]; then
    echo "Error: Could not find the downloaded file or it does not contain 'discord' in its name."
    exit 1
fi

# Kill Discord processes if they are running
echo "Checking for Discord processes..."
pkill -9 -f discord

# Extract the file to /tmp directory
echo "Extracting '$downloaded_file' to /tmp"
tar -xzf "$download_dir/$downloaded_file" -C /tmp
echo "File extracted successfully."

# Copy content from extracted file to /opt/discord
sudo cp -r /tmp/Discord/* /opt/discord && echo Update complete!

# Remove temp data
sudo rm -r /tmp/Discord

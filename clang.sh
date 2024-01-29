#!/bin/bash

# -----------------------------
# script created by
#     Akari Azusagawa © 2023
# ----------------------------- 

date_=$(cat date_.txt) # updated clang version.
version="19.0.0git-$date_-release"
clang_gz="Clang-19.0.0git-$date_.tar.gz"
url="https://github.com/ZyCromerZ/Clang/releases/download/$version/$clang_gz"

output_file="$clang_gz"
destination_dir="$HOME/tc/clang-19.0.0"

if ! command -v curl &>/dev/null; then
  echo "The command 'curl' not installed. Please, install for continue."
  sudo apt update -y 
  sudo apt install curl -y
  exit 1
fi

curl -LO "$url"

if [ $? -ne 0 ]; then
  echo "The download of the archive has failed."
  exit 1
fi

mkdir -p "$destination_dir"
tar -xzf "$output_file" -C "$destination_dir"

if [ $? -eq 0 ]; then
  echo "Archive extracted with success in '$destination_dir'."
else
  echo "The extraction of the zip was failed!"
fi

#!/bin/bash

# -----------------------------
#   By Akari Nyan - © 2023
# ----------------------------- 

url="https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04.tar.xz"

output_file="clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04.tar.xz"
destination_dir="$HOME/tc/clang-17.0.5"

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

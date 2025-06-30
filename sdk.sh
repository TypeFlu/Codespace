#!/bin/bash

set -e

# Variables
ANDROID_SDK_ROOT=$HOME/Android/Sdk
CMDLINE_TOOLS_ZIP=commandlinetools-linux-latest.zip
CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip" # Always check for latest version URL
CMDLINE_TOOLS_DIR=$ANDROID_SDK_ROOT/cmdline-tools/latest

# Install dependencies
sudo apt update
sudo apt install -y wget unzip default-jdk

# Create SDK directory
mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

# Download latest command line tools
wget -O $CMDLINE_TOOLS_ZIP $CMDLINE_TOOLS_URL

# Unzip command line tools
unzip -o $CMDLINE_TOOLS_ZIP -d $ANDROID_SDK_ROOT/cmdline-tools

# Move extracted folder to 'latest' (cmdline-tools folder contains a subfolder cmdline-tools)
mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $CMDLINE_TOOLS_DIR

# Clean up zip file
rm $CMDLINE_TOOLS_ZIP

# Accept licenses and update sdkmanager
export ANDROID_SDK_ROOT
export PATH=$PATH:$CMDLINE_TOOLS_DIR/bin:$ANDROID_SDK_ROOT/platform-tools

# Create repositories.cfg to avoid warnings
mkdir -p $HOME/.android
touch $HOME/.android/repositories.cfg

# Update sdkmanager and install essential packages
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --update
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses

# Install latest platform tools, build tools, platforms, and emulator
LATEST_API=36
LATEST_BUILD_TOOLS=36.0.0

yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "build-tools;$LATEST_BUILD_TOOLS" "platforms;android-$LATEST_API" "emulator" "cmdline-tools;latest"

# Add environment variables to ~/.bashrc if not already present
if ! grep -q ANDROID_SDK_ROOT ~/.bashrc; then
  echo "" >> ~/.bashrc
  echo "# Android SDK environment variables" >> ~/.bashrc
  echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> ~/.bashrc
  echo "export PATH=\$PATH:$CMDLINE_TOOLS_DIR/bin:$ANDROID_SDK_ROOT/platform-tools" >> ~/.bashrc
fi

echo "Android command line tools installed and environment configured."
echo "Please run 'source ~/.bashrc' or restart your terminal to apply changes."

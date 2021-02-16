#!/bin/bash

#######################################################################
#
# Script to install Android emulators
# Required:
# - Android SDK Platform-tools
# - Android SDK Build-tools
# - Android versions we want to use
#
# With this script we are going to install:
# - Android SDK 29 (Android 10 - Q)
#
# Arguments:
# N/A
# 
# 16/02/2021 - V1 by Miguel
#
######################################################################


# ----------------------------------------------------------------------------
# Logging function
# ----------------------------------------------------------------------------
function log(){
  echo " `date +%Y-%m-%dT%H:%M:%S` >> ${*}"
}


#Variables
CURRENT_DIR=`pwd`

#Start time
start=`date +%s`

#Android-cli installation
log "Installing Android Command line tool"
log "Downloading..."
cd /tmp
wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
mkdir /opt/android-sdk/cmdline-tools -p
unzip /tmp/commandlinetools-linux-6858069_latest.zip -d /opt/android-sdk/cmdline-tools
cd /opt/android-sdk/cmdline-tools
mv cmdline-tools tools

#More instructions here: https://guides.codepath.com/android/installing-android-sdk-tools
#Downloading android versions
log "Installing android SDK version 29 (Android 10 - Q)..."
cd /opt/android-sdk
cmdline-tools/tools/bin/sdkmanager --update
tools/bin/sdkmanager "platforms;android-29" "build-tools;29.0.0" "extras;google;m2repository" "extras;android;m2repository"
tools/bin/sdkmanager 'system-images;android-29;google_apis;x86'
tools/bin/sdkmanager --licenses

log "Configuring variables..."
cd ~
echo 'export ANDROID_SDK_ROOT=/opt/android-sdk' >> ~/.bashrc 
echo 'export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools:$ANDROID_SDK_ROOT/tools/bin' >> ~/.bashrc 
source ~/.bashrc


#Alternatives 
#1. Using apt-get
#sudo apt install android-sdk
#2. Downloading android-sdk
#cd /tmp
#wget http://dl.google.com/android/android-sdk_r24.2-linux.tgz
#Not tested yet
#tar -xvf android-sdk_r24.2-linux.tgz -C /opt/
# Configure environment variables (ver arriba)
#echo 'export PATH=${PATH}:/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/build-tools' > ~/.bashrc
##Then execute:
#android update sdk --no-ui --filter build-tools-29.0.0,android-29,extra-android-m2repository


log "Creating android devices:"
log "Android SDK 29 (Android 10 - Q)"
#HELP
# -b: architecture (x86 o x86_64)
# -c: sd memory size
# -d: ?
# -f = --force
# -n = --name (device name)
# -k = --packages (paquetes a usar)
#Action "create avd":
# Creates a new Android Virtual Device.
#Options:
#  -a --snapshot: Place a snapshots file in the AVD, to enable persistence.
#  -c --sdcard  : Path to a shared SD card image, or size of a new sdcard for
#                 the new AVD.
#  -g --tag     : The sys-img tag to use for the AVD. The default is to
#                 auto-select if the platform has only one tag for its system
#                 images.
#  -p --path    : Directory where the new AVD will be created.
#  -k --package : Package path of the system image for this AVD (e.g.
#                 'system-images;android-19;google_apis;x86').
#  -n --name    : Name of the new AVD. [required]
#  -f --force   : Forces creation (overwrites an existing AVD)
#  -b --abi     : The ABI to use for the AVD. The default is to auto-select the
#                 ABI if the platform has only one ABI for its system images.
#  -d --device  : The optional device definition to use. Can be a device index
#                 or id.

avdmanager create avd -n android29 -k "system-images;android-29;google_apis;x86" -b x86 -c 100M -d 7 -f
# device 7 = Nexus 4 (para ver la lista de dip
# -b x86  --abi google_apis/x86_64ositivos disponibles, usa: advmanager list device"

log "Listing emulators available:"
avdmanager list avd

#To start...
log "To start-up the device, please execute:"
log "/opt/android-sdk/emulator -avd <device_name> -gpu on -no-boot-anim"


end=`date +%s`
#Execution time
runtime=$((end-start))
let min=${runtime}/60
let seg=${runtime}%60
log "Execution time: ${min}min ${seg}seg"

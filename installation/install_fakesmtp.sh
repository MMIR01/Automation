#!/bin/bash

#######################################################################
#
# Install fakeSMTP
#
# Arguments:
# N/A
# 
# More info:
# https://github.com/Nilhcem/FakeSMTP
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
INSTALLATION_PATH="/opt/FakeSMTP"
MAILS_PATH="/opt/FakeSMTP/mails"

#Start time
start=`date +%s`

#FakeSMTP requisites
log "Installing maven..."
sudo apt-get install maven
log "Installing sendmail"
sudo apt-get install sendmail

#Downloading
log "Downloading FakeSMTP from Github..."
cd /tmp
sudo rm -rf FakeSMTP
sudo git clone https://github.com/Nilhcem/FakeSMTP
cd FakeSMTP

#Using docker instead
#log "Building docker image..."
#sudo mvn package docker:build -DskipTests

#Using jar directly
log "Building jar..."
sudo mvn package -Dmaven.test.skip

log "Getting jar file..."
cd target
FAKESMTPJAR=`ls | grep "fake.*jar"`
sudo rm -rf ${INSTALLATION_PATH}
sudo mkdir -p ${INSTALLATION_PATH}
sudo mv ${FAKESMTPJAR} ${INSTALLATION_PATH}

log "Creating mails folder..."
sudo mkdir -p ${MAILS_PATH}

log "Cleaning..."
sudo rm -rf /tmp/FakeSMTP


end=`date +%s`
#Execution time
runtime=$((end-start))
let min=${runtime}/60
let seg=${runtime}%60
log "Execution time: ${min}min ${seg}seg"

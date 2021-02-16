#!/bin/bash

#######################################################################
#
# Install SmartGit
#
# Arguments:
# N/A
# 
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
INSTALLATION_FOLDER="/opt/smartgit"
CURRENT_DIR=`pwd`
USER=`whoami`
#GROUP=`groups | awk '{ printf "%10s\n", $1 }'`

#Start time
start=`date +%s`

log "Installing prerequisites..."
log "Installing git..."
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update
sudo apt-get install git -y
git --version


log "Downloading Smartgit..."
cd /tmp
wget -O smartgit_20_2_1.tar.gz https://www.syntevo.com/downloads/smartgit/smartgit-linux-20_2_1.tar.gz


#Cleaning-up just in case there is any previous installation
sudo rm -rf ${INSTALLATION_FOLDER}
sudo unlink /usr/local/bin/smartgit

log "Untar smartgit file..."
cd /tmp
sudo tar xzf smartgit_20_2_1.tar.gz
sudo mv smartgit ${INSTALLATION_FOLDER}
log "Creating links..."
sudo ln -s ${INSTALLATION_FOLDER}/bin/smartgit.sh /usr/local/bin/smartgit

log "Changing permissions..."
sudo chown ${USER} ${INSTALLATION_FOLDER} -R
sudo chown ${USER} /usr/local/bin/smartgit
sudo chmod +x ${INSTALLATION_FOLDER}/bin/smartgit.sh

log "Creating a menu item..."
cd ${INSTALLATION_FOLDER}
bin/add-menuitem.sh

log "End of the installation"

log "Cleaning up"
cd /tmp
rm smartgit_20_2_1.tar.gz

end=`date +%s`
#Execution time
runtime=$((end-start))
let min=${runtime}/60
let seg=${runtime}%60
log "Execution time: ${min}min ${seg}seg"

#!/bin/bash

#######################################################################
#
# Install Eclipse (+PHP)  as IDE
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
INSTALLATION_FOLDER="/opt/eclipse"
CURRENT_DIR=`pwd`
USER=`whoami`
#GROUP=`groups | awk '{ printf "%10s\n", $1 }'`

#Start time
start=`date +%s`


log "Downloading Eclipse + PHP plugin..."
cd /tmp
wget -O eclipsePHP2019.tar.gz https://mirrors.dotsrc.org/eclipse//technology/epp/downloads/release/2019-12/R/eclipse-php-2019-12-R-linux-gtk-x86_64.tar.gz


#Cleaning in case there is a previous version installed
sudo rm -rf ${INSTALLATION_FOLDER}
sudo mkdir -p eclipse
sudo unlink /usr/local/bin/eclipse

log "Untar eclipse file..."
cd /tmp
sudo tar xzf eclipsePHP2019.tar.gz
sudo mv eclipse ${INSTALLATION_FOLDER}
log "Creating links..."
sudo ln -s ${INSTALLATION_FOLDER}/eclipse /usr/local/bin/eclipse
log "Changing permissions..."
sudo chown ${USER} ${INSTALLATION_FOLDER} -R
sudo chown ${USER} /usr/local/bin/eclipse
sudo chmod +x ${INSTALLATION_FOLDER}/eclipse

log "End of the installation"

log "Cleaning up"
cd /tmp
rm eclipsePHP2019.tar.gz

end=`date +%s`
#Execution time
runtime=$((end-start))
let min=${runtime}/60
let seg=${runtime}%60
log "Execution time: ${min}min ${seg}seg"

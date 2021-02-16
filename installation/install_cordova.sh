#!/bin/bash

#######################################################################
#
# Cordova installation script
#
# Requisites: run install_android_emulator.sh first
#
# Arguments:
# N/A 
#
# 16/02/2021 - V1 by MMIR01
#
######################################################################


# ----------------------------------------------------------------------------
# Logging function
# ----------------------------------------------------------------------------
function log(){
  echo " `date +%Y-%m-%dT%H:%M:%S` >> ${*}"
}

# ----------------------------------------------------------------------------
# Logging function
# Function to check java version installed
#
# Return:
# 0 java installed is higher than the required
# 1 java no installed
# 2 java version is lower than required
#
# To get returned value of the function: echo $return_value
# ----------------------------------------------------------------------------
function check_java_version(){

	if type -p java; then
	    _java=java
	elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then   
	    _java="$JAVA_HOME/bin/java"
	else
	    echo "no instalado"
	    return_value=1
	fi

	if [[ "$_java" ]]; then
	    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
	    echo Version installed: "$version"
	    if [[ "$version" > $JAVA_REQUIRED ]]; then
		return_value=0
	    else
		return_value=2
	    fi
	fi
}


#Variables
CURRENT_DIR=`pwd`
JAVA_REQUIRED='1.8'

#Start time
start=`date +%s`

log "Installing requisites..."
log "Checking if Nodejs is installed:"
nodejs --version
if [ $? -eq 1 ]; then 
	log "Installing nodejs..."
	sudo printf "deb [arch=amd64] https://deb.nodesource.com/node_10.x bionic main\ndeb-src deb-src https://deb.nodesource.com/node_10.x bionic main\n" > /etc/apt/sources.list.d/nodesource.list
	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install nodejs
	log "NPM has been also installed"
	npm -version
else
	log "NodeJS is installed"
fi;

log "Checking if Git is installed:"
git --version
if [ $? -eq 1 ]; then 
	log "Installing git..."
	sudo apt-get install git 
else
	log "Git is installed"
fi;

log "Checking if Java8 is installed:"
check_java_version
if [ $return_value -ne 0 ]; then 
	log "Installing Java8..."
	log "Removing old java versions..."
	sudo apt-get purge openjdk-\*
	sudo apt-get install software-properties-common
	sudo apt autoremove
	sudo add-apt-repository ppa:ts.sch.gr/ppa
	sudo apt-get update
	sudo apt-get install oracle-java8-installer
	sudo apt-get update
	log "Java8 has been installed:"
	java --version
else
	log "Java8 is installed"
fi;

log "Checking if gradle is installed:"
gradle -v
if [ $? -eq 1 ]; then 
	log "Installing gradle..."
	sudo apt-get install gradle 
else
	log "Gradle is installed"
fi;

log "Installing Cordova"
sudo npm install -g cordova
log "Cordova has been installed"
#cordova --version


end=`date +%s`
#Execution time
runtime=$((end-start))
let min=${runtime}/60
let seg=${runtime}%60
log "Execution time: ${min}min ${seg}seg"

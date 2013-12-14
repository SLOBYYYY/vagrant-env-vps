#!/bin/bash
PROJECT_DIR=$1
PROJECT_NAME=$2

# Install essential packages from Apt
apt-get update -y

function installLocales() {
	# Generate locales
	locale-gen en_GB en_GB.UTF-8 hu_HU hu_HU.UTF-8 en_US en_US.UTF-8
	dpkg-reconfigure locales

	# Set locales
	export LANGUAGE=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
}

#source ./install-sources/smtp.sh
#source ./install-sources/jenkins.sh

source $PROJECT_DIR/provision/install-sources/svn.sh $PROJECT_DIR $PROJECT_NAME
source $PROJECT_DIR/provision/install-sources/trac.sh $PROJECT_DIR $PROJECT_NAME

installLocales

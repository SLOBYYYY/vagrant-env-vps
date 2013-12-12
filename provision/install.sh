#!/bin/bash
PROJECT_DIR=/home/vagrant/vps

# Install essential packages from Apt
apt-get update -y

function installSMTP() {
	apt-get install -y exim4-daemon-light mailutils
	cp exim4.conf /etc/exim4/update-exim4.conf.conf
	update-exim4.conf
}

function generateLocales() {
	locale-gen en_GB en_GB.UTF-8 hu_HU hu_HU.UTF-8
	dpkg-reconfigure locales
}

function setLocales() {
	export LANGUAGE=hu_HU.UTF-8
	export LANG=hu_HU.UTF-8
}

function installPostgresqlForRedmine() {
	apt-get install -y postgresql postgresql-client
	su - postgres -c "echo \"CREATE ROLE redmine LOGIN ENCRYPTED PASSWORD 'redmine' NOINHERIT VALID UNTIL 'infinity'; CREATE DATABASE redmine WITH ENCODING='UTF8' OWNER=redmine;\" | psql"
}

function installSVN() {
	apt-get install -y subversion
	# Install subversion WebDAV apache module
	apt-get install -y libapache2-svn
	# Restart apache to activate new module
	service apache2 restart
}

function createRepository() {
	mkdir -p /var/svnrepos/
	svnadmin create --fs-type fsfs /var/svnrepos/farmmixerp
	# Create group for svn users
	groupadd subversion
	addgroup root subversion
	chown -R www-data:subversion /var/svnrepos/*
	chmod -R 770 /var/svnrepos/*
}

function addSSHConnection() {
	if [ ! -d ~/.ssh/ ] 
	then
		printf "\n\n\n" | ssh-keygen -t rsa -b 2048
	fi
	cat id_rsa.pub >> ~/.ssh/authorized_keys
}

function installRuby() {
	apt-get install -y make build-essential curl
	# RVM is needed as rubygems package is for version 1.8. puma can't use that
	curl -sSL https://get.rvm.io | bash -s stable
	source /home/vagrant/.rvm/scripts/rvm
	rvm use --install 2.0.0
	shift
	gem install bundler
}

function installPuma() {
	gem install puma
}

function installRedmine() {
	wget http://www.redmine.org/releases/redmine-2.4.1.tar.gz -O /home/vagrant/redmine-2.4.1.tar.gz
	cd /home/vagrant/
	tar zxf redmine-2.4.1.tar.gz
	cd redmine-2.4.1
	cp /home/vagrant/vps/provision/database.yml ./config/
	apt-get install -y libpq-dev
	apt-get install -y libmagick++-dev
	bundle install --without development test
}

function installPython() {
	# Install python essentials
	apt-get install -y build-essential python python-dev python-setuptools python-pip
	wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | python


	# Install pip
	if ! command -v pip; then
		easy_install -U pip
	fi
}

function installPostgresqlForTrac() {
	PGSQL_VERSION=9.1
	if ! command -v psql; then
		apt-get install -y postgresql-$PGSQL_VERSION libpq-devcp $PROJECT_DIR/provision/pg_hba.conf /etc/postgresql/$PGSQL_VERSIONN/main/
		/etc/init.d/postgresql reload
	fi

	createdb -Upostgres trac
}

installPython
installPostgresqlForTrac

#!/usr/bin/env bash

PROJECT_DIR=/var/www/edufocal;

#install vendor deps
function vendor(){
	echo "----- installing dependencies ----"

	if [ -d $PROJECT_DIR/webapp ]
	then
		echo "webapp"	
		cd $PROJECT_DIR/webapp && /var/www/html/composer.phar install
	else
		echo $PROJEC
		T_DIR/webapp not found
	fi

	if [ -d $PROJECT_DIR/api ]
	then
		echo "api"
		cd $PROJECT_DIR/api && /var/www/html/composer.phar install
	else
		echo $PROJECT_DIR/api not found
	fi

}

#download database dump and load to databasee
function load_db(){
	cd $PROJECT_DIR/api && php artisan db:load
}


function grunt_install)(){
	cd $PROJECT_DIR/webapp && npm install
}

function grunt_watch(){
	cd $PROJECT_DIR/webapp && grunt watch 
}


$@
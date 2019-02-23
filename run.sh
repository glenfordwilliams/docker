#!/usr/bin/env bash

function compose_up(){
	docker-compose up
}

function compose_down(){
	docker-compose up
}

function compose_build(){
	docker-compose build
}

function install_deps(){
	docker-compose exec php bash -c "./helper.sh vendor"
}

function shell(){
	docker-compose exec php bash
}

function grunt_setup(){
	docker-compose exec  php bash -c "./helper.sh  grunt_install"
}

function grunt_watch(){
	docker-compose exec  php bash -c "./helper.sh  grunt_watch"
}

function load_db(){
	docker-compose exec  php bash -c "./helper.sh  load_db"
}


$@

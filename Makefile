.PHONY: build up down

build:
	docker-compose -p ef build
up:
	docker-compose -p ef up -d
stop:
	docker-compose -p ef stop
ps:
	docker-compose -p ef ps
down:
	docker-compose -p ef down --remove-orphans
screen:
	screen -c ./workspace/screenrc
cleanc:
	docker rm $(docker ps -a | awk '$2 ~ /ef_/ { print $1 }')
cleani:
	docker ps | awk '$2 ~ /ef_/ { print $1 }'

connect:
	docker exec -it --user=ef ef_workspace_1 bash

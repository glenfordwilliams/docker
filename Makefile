.PHONY: build up down

build:
	docker-compose -p ci build
up:
	docker-compose -p ci up -d
stop:
	docker-compose -p ci stop
ps:
	docker-compose -p ci ps
down:
	docker-compose -p ci down --remove-orphans
screen:
	screen -c ./workspace/screenrc
cleanc:
	docker rm $(docker ps -a | awk '$2 ~ /ci_/ { print $1 }')
cleani:
	ddocker ps | awk '$2 ~ /ci_/ { print $1 }'

connect:
	docker exec -it ci_workspace_1 bash

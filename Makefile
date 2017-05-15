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

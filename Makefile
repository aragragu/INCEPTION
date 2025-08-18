DOCKER_COMPOSE=srcs/docker-compose.yml
DATA_DIR=/home/aragragu/data

all: makedir up

makedir:
	mkdir -p $(DATA_DIR)/wordpress_volume
	mkdir -p $(DATA_DIR)/mariadb_volume

build:
	docker compose -f $(DOCKER_COMPOSE) build

up: build
	docker compose -f $(DOCKER_COMPOSE) up -d

logs:
	docker compose -f $(DOCKER_COMPOSE) logs

removedir:
	sudo rm -rf $(DATA_DIR)/wordpress_volume
	sudo rm -rf $(DATA_DIR)/mariadb_volume
	sudo rm -rf $(DATA_DIR)

down:
	docker compose -f $(DOCKER_COMPOSE) down -v

reboot: down up

clean: down removedir
	docker volume prune -f
	docker image prune -f

fclean: clean
	docker system prune -f

re: fclean up

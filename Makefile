DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_DIR = /home/aragragu/data

all: makedir up

makedir:
	@mkdir -p $(DATA_DIR)/wordpress_volume
	@mkdir -p $(DATA_DIR)/mariadb_volume

build:
	@docker compose -f $(DOCKER_COMPOSE) build

up: build
	@docker compose -f $(DOCKER_COMPOSE) up -d

down:
	@docker compose -f $(DOCKER_COMPOSE) down -v

stop:
	@docker compose -f $(DOCKER_COMPOSE) stop

logs:
	docker compose -f $(DOCKER_COMPOSE) logs

removedir:
	@sudo rm -rf $(DATA_DIR)/wordpress_volume
	@sudo rm -rf $(DATA_DIR)/mariadb_volume
	@sudo rm -rf $(DATA_DIR)

reboot: down up

clean: down removedir
	@docker volume prune -f
	@docker image prune -f --all

fclean: clean
	@docker system prune -af --volumes

re: fclean up
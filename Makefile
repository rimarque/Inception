NAME = inception
COMPOSE = ./srcs/docker-compose.yml
DATA_PATH ?= ~/data


all: dir up 



# Create necessary directories for MariaDB and WordPress data
dir:
	sudo mkdir -p $(DATA_PATH)
	sudo mkdir -p $(DATA_PATH)/database
	sudo mkdir -p $(DATA_PATH)/wordpress_files

up:
	docker compose -p $(NAME) -f $(COMPOSE) up --build -d

down:
	docker compose -p $(NAME) -f $(COMPOSE) down --volumes

start:
	docker compose -p $(NAME) start

stop:
	docker compose -p $(NAME) $(COMPOSE) stop

rm-image:
	docker rmi -f $$(docker images -q)

clean: down rm-image

fclean: clean
	@sudo rm -rf ~/data
	@docker system prune -a

re: fclean dir up

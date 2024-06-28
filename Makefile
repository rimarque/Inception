NAME = inception
COMPOSE = ./srcs/docker-compose.yml
VOL_PATH ?= ~/data


all: vol up 

vol:
	sudo mkdir -p $(VOL_PATH)
	sudo mkdir -p $(VOL_PATH)/database
	sudo mkdir -p $(VOL_PATH)/wordpress_files

up:
	docker compose -p $(NAME) -f $(COMPOSE) up --build -d

down:
	docker compose -p $(NAME) -f $(COMPOSE) down --volumes

start:
	docker compose -p $(NAME) start

stop:
	docker compose -p $(NAME) -f $(COMPOSE) stop

rm-image:
	docker rmi -f $$(docker images -q)

clean: down rm-image

fclean: clean
	@sudo rm -rf ~/data
	@docker system prune -a

re: fclean vol up

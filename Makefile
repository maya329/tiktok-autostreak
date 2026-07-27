.PHONY: deploy up down logs pull build restart

deploy:
	docker compose down && git pull && docker compose up -d --build && docker compose logs -f

pull:
	git pull

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down -v

restart:
	docker compose down && docker compose up -d

logs:
	docker compose logs -f

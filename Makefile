.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start
start: ## start
	set -eux && \
	docker compose stop && \
	docker compose up -d && \
	docker-compose exec mysticbbs /bin/bash -c "/mystic/scripts/boot.sh mystic"

.PHONY: install
install: ## install
	set -eux && \
	docker compose stop && \
	docker compose up -d --build --remove-orphans && \
	docker-compose exec mysticbbs /bin/bash -c "cd /mystic/installer && ./install auto /mystic/src"

.PHONY: upgrade
upgrade: ## upgrade
	set -eux && \
	docker-compose exec mysticbbs /bin/bash -c "cp /mystic/installer/upgrade /mystic/src/upgrade && cd /mystic/src && ./upgrade"

.PHONY: stop
stop: ## stop
	docker compose stop

.PHONY: down
down: ## down
	docker compose down

.PHONY: logs
logs: ## logs 
	set -eux && \
	docker compose logs -f --tail 100 mysticbbs

.PHONY: config
config: ## config
	set -eux && \
	docker compose exec mysticbbs /bin/bash -c "cd /mystic/src && ./mystic -cfg"

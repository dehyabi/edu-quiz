# ========== Configuration ==========
ENV_FILE=.env
DOCKER_COMPOSE=docker-compose

# ========== Commands ==========

# Run local Flask app (without Docker)
run-local:
	@echo "Running app locally with Flask..."
	@export $(shell cat $(ENV_FILE) | xargs) && gunicorn -w 4 -b 0.0.0.0:5000 app:app

# Build images, clean start (without delete volume)
docker-build:
	@echo "Building containers..."
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) build
	docker image prune -f
	$(DOCKER_COMPOSE) up

# Build images, clean start (without delete volume) in PRODUCTION mode (background)
docker-build-prod:
	@echo "Building containers in PRODUCTION mode (background)..."
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) build
	docker image prune -f
	$(DOCKER_COMPOSE) up -d

# Build images with no cache, clean start (without delete volume)
docker-build-clean:
	@echo "Building containers with no cache..."
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) build --no-cache
	docker image prune -f
	$(DOCKER_COMPOSE) up

# Build images with no cache, clean start (without delete volume) in PRODUCTION mode (background)
docker-build-clean-prod:
	@echo "Building containers with no cache..."
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) build --no-cache
	docker image prune -f
	$(DOCKER_COMPOSE) up -d

# Start Docker Compose (without rebuild)
docker-up:
	@echo "Starting containers..."
	$(DOCKER_COMPOSE) up

# Start Docker Compose (without rebuild) in PRODUCTION mode (background)
docker-up-prod:
	@echo "Starting containers..."
	$(DOCKER_COMPOSE) up -d

# Stop containers (without delete network & volume)
docker-stop:
	@echo "Stopping containers..."
	$(DOCKER_COMPOSE) stop

# Stop & remove containers, network (volume remains safe)
docker-down:
	@echo "Stopping and removing containers and network..."
	$(DOCKER_COMPOSE) down

# Reset total (delete all containers, volumes, networks)
reset:
	@echo "Resetting Docker Compose (remove containers & volumes)..."
	$(DOCKER_COMPOSE) down -v --remove-orphans

# View container logs
logs:
	$(DOCKER_COMPOSE) logs -f

# Remove dangling images
prune-images:
	@echo "Pruning unused Docker images..."
	docker image prune -f

# Remove all unused Docker data (⚠️ be careful)
prune-all:
	@echo "Pruning ALL unused Docker data (containers, images, networks, volumes)..."
	docker system prune -a -f --volumes

# ========== Help ==========
help:
	@echo ""
	@echo "Available commands:"
	@echo "  make run-local       			Run app locally (requires virtualenv & dependencies)"
	@echo "  make docker-up       			Start containers (no rebuild)"
	@echo "  make docker-up-prod   		Start containers (no rebuild) in PRODUCTION"
	@echo "  make docker-build    			Build & start containers (keep volumes)"
	@echo "  make docker-build-prod    		Build & start containers (keep volumes) in PRODUCTION"
	@echo "  make docker-build-clean		Clean build & start containers (no-cache, keep volumes)"
	@echo "  make docker-build-clean-prod		Clean build & start containers (no-cache, keep volumes) in PRODUCTION"
	@echo "  make docker-stop     			Stop containers"
	@echo "  make docker-down     			Stop & remove containers & network"
	@echo "  make reset           			Stop and remove all containers & volumes"
	@echo "  make logs            			Tail logs from Docker Compose"
	@echo "  make prune-images    			Remove dangling Docker images"
	@echo "  make prune-all       			Remove all unused Docker data (⚠️ irreversible)"
	@echo ""

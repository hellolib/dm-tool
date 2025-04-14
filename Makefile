# 默认版本（如果未提供 VERSION 参数）
VERSION ?= latest

# 镜像名称
IMAGE_NAME = hub.deepin.com/wuhan_udcp/dm-tool:$(VERSION)

# 构建并推送 Docker 镜像
build:
	@echo "Building Docker image $(IMAGE_NAME)..."
	docker build -t $(IMAGE_NAME) .
	@echo "Pushing Docker image $(IMAGE_NAME) to hub..."
	docker push $(IMAGE_NAME)

# 清理指定版本的本地镜像
clean:
	@echo "Removing local Docker image $(IMAGE_NAME)..."
	-docker rmi -f $(IMAGE_NAME)

# 清理所有 dm-tool 本地镜像
clean-all:
	@echo "Removing all local dm-tool images..."
	-docker rmi -f $(shell docker images -q hub.deepin.com/wuhan_udcp/dm-tool | sort -u)

# 显示帮助信息
help:
	@echo "Usage:"
	@echo "  make build VERSION=v1.0.0    # Build and push image dm-tool:v1.0.0"
	@echo "  make clean VERSION=v1.0.0    # Remove local image dm-tool:v1.0.0"
	@echo "  make clean-all               # Remove all local dm-tool images"
	@echo "  make help                    # Show this help message"

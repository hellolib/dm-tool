# 默认版本（如果未提供 VERSION 参数）
VERSION ?= latest
# 镜像名称
WEB_TOOLS_IMAGE_NAME = bigox/dm-tool:$(VERSION)
# 默认 Dockerfile
WEB_TOOLS_DOCKERFILE = Dockerfile

# 通用构建规则
define build_image
	@echo "Building Docker image $(1) using $(2)..."
	docker build -t $(1) -f $(2) .
endef

# 通用推送规则
define push_image
	@echo "Pushing Docker image $(1)..."
	docker push $(1)
endef

# 构建图形化工具 Docker 镜像（本地）
docker_local:
	$(call build_image,$(WEB_TOOLS_IMAGE_NAME),$(WEB_TOOLS_DOCKERFILE))

# 构建并推送图形化工具 Docker 镜像
docker: docker_local
	$(call push_image,$(WEB_TOOLS_IMAGE_NAME))

# 显示帮助信息
help:
	@echo "Usage:"
	@echo "  make docker_local VERSION=v1.0.0  # Build web tools image locally, VERSION defaults to 'latest' (bigox/dm-tool:v1.0.0)"
	@echo "  make docker VERSION=v1.0.0        # Build and push web tools image, VERSION defaults to 'latest' (bigox/dm-tool:v1.0.0)"
	@echo "  make help                         # Show this help message"

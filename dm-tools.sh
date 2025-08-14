#!/bin/bash

# 默认命令
COMMAND=${1:-manager}

# 设置 X11 权限
xhost +local:docker

# 运行 Docker 容器
docker run --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "./local_space:/app/tool/workspace" \
  bigox/dm-tool:latest $COMMAND

#!/bin/bash

# 默认命令
COMMAND=${1:-dts}

# 设置 X11 权限
xhost +local:docker

# 运行 Docker 容器
docker run --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "./dm-tool-workspace:/app/tool/workspace" \
  hub.deepin.com/wuhan_udcp/dm-tool:v1.0.0 $COMMAND

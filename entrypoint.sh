#!/bin/bash

# 如果没有传入工具名，提示用法
if [ -z "$1" ]; then
  echo "Usage: docker run <image-name> <tool-name> [args...]"
  exit 1
fi

TOOL="$1"
shift

EXECUTABLE="/app/tool/$TOOL"

# 检查工具是否存在并可执行
if [ ! -x "$EXECUTABLE" ]; then
  echo "Error: '$TOOL' is not found or not executable in /app/tool"
  exit 2
fi

# 执行对应工具
exec /bin/bash "$EXECUTABLE" "$@"

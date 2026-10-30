#!/usr/bin/env bash

#
# 开启严格模式
#
set -euo pipefail

#
# 设置内部变量
#
SCRIPTS_DIR_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#
# 加载公共脚本
#
source "${SCRIPTS_DIR_PATH}/share.sh"

#
# 执行项目清理（所有实例）
#
compose_clean_instances

#
# 执行项目清理（所有镜像）
#
compose_clean_images

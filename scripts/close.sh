#!/usr/bin/env bash

#
# 开启严格模式
#
set -euo pipefail

#
# 设置脚本路径
#
SCRIPTS_ROOT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#
# 加载公共脚本
#
source "${SCRIPTS_ROOT_PATH}/share.sh"

#
# 执行服务关闭
#
public_compose_close "$@"

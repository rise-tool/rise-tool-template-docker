#!/usr/bin/env bash

#
# 设置公共变量
#
# ROOT_DIR_PATH  项目根目录路径
# ENV_FILE_NAME  环境变量文件名
#
ROOT_DIR_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE_NAME=""

#
# 设置命令参数
#
# TEST_CODE  测试编号
#
TEST_CODE=""

#
# 解析命令参数
#
while [[ $# -gt 0 ]]; do
  case "$1" in
    --test-code)
      [[ $# -lt 2 || -z "${2-}" || "${2-}" == -* ]] && {
        echo "错误：参数 --test-code 未设置！" >&2
        exit 1
      }
      TEST_CODE="$2"
      shift 2
      ;;
    *)
      echo "错误：参数 $1 不支持！" >&2
      exit 1
      ;;
  esac
done

#
# 设置公共函数
#
ENV_FILE_NAME="rise-service-test-${TEST_CODE}"

compose() {
  docker compose \
    -p "${ENV_FILE_NAME}" \
    -f "${ROOT_DIR_PATH}/compose.yaml" \
    --env-file "${ROOT_DIR_PATH}/envs/${ENV_FILE_NAME}.env" \
    "$@"
}

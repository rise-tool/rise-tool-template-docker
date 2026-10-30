#!/usr/bin/env bash

#
# 设置公共路径
#
# PROJECT_ROOT_PATH  项目根目录路径
# ENVVARS_ROOT_PATH  环境变量根目录路径
# COMPOSE_YAML_PATH  Docker Compose 配置文件路径
#
PROJECT_ROOT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ENVVARS_ROOT_PATH="${PROJECT_ROOT_PATH}/envs"
COMPOSE_YAML_PATH="${PROJECT_ROOT_PATH}/compose.yaml"

#
# 设置启动参数
#
# INSTANCE_NAME  Docker Compose 实例名称
# ENV_FILE_PATH  Docker Compose 实例环境变量文件路径
#
INSTANCE_NAME="rise-service-test"
ENV_FILE_PATH=""

#
# 解析命令参数
#
parse_command_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --label)
        [[ -n "${2-}" ]] || {
          echo "错误：参数 --label 不能为空！" >&2
          exit 1
        }
        [[ "${2-}" != -* ]] || {
          echo "错误：参数 --label 值不合法！" >&2
          exit 1
        }
        INSTANCE_NAME="rise-service-test-$2"
        shift 2
        ;;
      *)
        echo "错误：参数 $1 不支持！" >&2
        exit 1
        ;;
    esac
  done

  ENV_FILE_PATH="${ENVVARS_ROOT_PATH}/${INSTANCE_NAME}.env"

  [[ -f "$ENV_FILE_PATH" ]] || {
    echo "错误：文件 ${ENV_FILE_PATH} 不存在！" >&2
    exit 1
  }
}

#
# 执行项目构建
#
compose_build() {
  docker compose -f "${COMPOSE_YAML_PATH}" build
}

#
# 设置公共函数
#
compose_share() {
  docker compose -f "${COMPOSE_YAML_PATH}" --env-file "${ENV_FILE_PATH}" "$@"
}

#
# 执行服务启动（指定实例）
#
compose_start() {
  compose_share -p "${INSTANCE_NAME}" up -d --no-build
}

#
# 执行服务关闭（指定实例）
#
compose_close() {
  compose_share -p "${INSTANCE_NAME}" stop
}

#
# 执行项目清理（所有实例）
#
compose_clean_instances() {
  local env_file instance_name

  for env_file in "$ENVVARS_ROOT_PATH"/*.env; do
    [[ -f "$env_file" ]] || continue

    instance_name="${env_file##*/}"
    instance_name="${instance_name%.env}"

    docker compose -p "$instance_name" -f "$COMPOSE_YAML_PATH" --env-file "$env_file" down --remove-orphans
  done
}

#
# 执行项目清理（所有镜像）
#
compose_clean_images() {
  local image_name image_names

  image_names="$(docker compose -f "$COMPOSE_YAML_PATH" config --images | sort -u)"

  while IFS= read -r image_name; do
    if [[ -n "$image_name" ]] &&
      docker image inspect "$image_name" >/dev/null 2>&1; then
      docker image rm "$image_name"
    fi
  done <<< "$image_names"
}

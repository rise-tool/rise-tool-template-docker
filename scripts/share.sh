#!/usr/bin/env bash

#
# 设置：公共路径
#
# PROJECT_ROOT_PATH  项目根目录路径
# ENVVARS_ROOT_PATH  环境变量根目录路径
# COMPOSE_YAML_PATH  Docker Compose 配置文件路径
#
PROJECT_ROOT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ENVVARS_ROOT_PATH="${PROJECT_ROOT_PATH}/envs"
COMPOSE_YAML_PATH="${PROJECT_ROOT_PATH}/compose.yaml"

#
# 设置：启动参数
#
# INSTANCE_NAME  Docker Compose 实例名称
# ENV_FILE_PATH  Docker Compose 实例环境变量文件路径
# COMPOSE_SHARE  Docker Compose 公共指令
#
INSTANCE_NAME="rise-service-test"
ENV_FILE_PATH=""
COMPOSE_SHARE=(docker compose -f "$COMPOSE_YAML_PATH")

#
# 设置：打印错误日志函数
#
print_error() {
  printf '%s\n' "$1" >&2
  exit 1
}

#
# 设置：解析命令参数函数
#
parse_command_args() {
  while (($#)); do
    case "$1" in
      --label)
        # 参数值为空，打印错误日志，退出程序
        [[ -n "${2-}" ]] || print_error "错误：参数 --label 不能为空！"
        # 更新 Docker Compose 实例名称
        INSTANCE_NAME="${INSTANCE_NAME}-$2"
        # 更新 Docker Compose 实例环境变量文件路径
        ENV_FILE_PATH="${ENVVARS_ROOT_PATH}/${INSTANCE_NAME}.env"
        # 环境变量文件不存在，打印错误日志，退出程序
        [[ -f "$ENV_FILE_PATH" ]] || print_error "错误：文件 ${ENV_FILE_PATH} 不存在！"
        shift 2
        ;;
      *)
        # 参数不支持，打印错误日志，退出程序
        print_error "错误：参数 $1 不支持！"
        ;;
    esac
  done
}

#
# 设置：执行项目构建函数
#
compose_build() {
  "${COMPOSE_SHARE[@]}" build
}

#
# 设置：执行服务启动函数（指定实例）
#
compose_start() {
  "${COMPOSE_SHARE[@]}" -p "${INSTANCE_NAME}" --env-file "${ENV_FILE_PATH}" up -d --no-build
}

#
# 设置：执行服务关闭函数（指定实例）
#
compose_close() {
  "${COMPOSE_SHARE[@]}" -p "${INSTANCE_NAME}" --env-file "${ENV_FILE_PATH}" stop
}

#
# 设置：执行项目清理函数
#
compose_clean() {
  local env_file_path
  local instance_name
  local image_name
  # 关闭并清理所有 Docker Compose 实例
  for env_file_path in "$ENVVARS_ROOT_PATH"/*.env; do
    # 环境变量文件不存在，跳过清理
    [[ -f "$env_file_path" ]] || continue
    # 从环境变量文件路径，截取实例名称
    instance_name="$(basename "$env_file_path" .env)"
    # 关闭实例服务，执行清理
    "${COMPOSE_SHARE[@]}" -p "$instance_name" --env-file "$env_file_path" down --remove-orphans
  done
  # 清理所有 Docker 镜像
  for image_name in $("${COMPOSE_SHARE[@]}" config --images | sort -u); do
    # 镜像不存在，跳过清理
    [[ -n "$image_name" ]] || continue
    docker image inspect "$image_name" >/dev/null 2>&1 || continue
    # 镜像存在，执行清理
    docker image rm "$image_name"
  done
}

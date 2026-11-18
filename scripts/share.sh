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
# 设置：内部函数 - 打印错误日志
#
private_print_error() {
  echo "错误：$1" >&2
}

#
# 设置：内部函数 - 校验命令参数
#
private_check_command_arg() {
  [[ -n "$2" ]] || {
    private_print_error "参数 $1 不能为空！"
    exit 1
  }
}

#
# 设置：内部函数 - 校验环境变量文件路径
#
private_check_env_file_path() {
  [[ -f "$1" ]] || {
    private_print_error "环境变量文件 $1 不存在！"
    exit 1
  }
}

#
# 设置：内部函数 - 解析命令参数（按需求自定义）
#
private_parse_command_args() {
  # 定义内部变量
  local label
  # 循环读取参数
  while (($#)); do
    case "$1" in
      --label)
        # 校验命令参数
        private_check_command_arg "$1" "$2"
        # 更新 label 变量值（转换小写）
        label="${2,,}"
        shift 2
        ;;
      *)
        # 参数不支持，打印错误日志，退出程序
        private_print_error "参数 $1 不支持！"
        exit 1
        ;;
    esac
  done
  # 更新 Docker Compose 实例名称
  INSTANCE_NAME="${INSTANCE_NAME}-${label}"
  # 更新 Docker Compose 实例环境变量文件路径
  ENV_FILE_PATH="${ENVVARS_ROOT_PATH}/${INSTANCE_NAME}.env"
  # 校验环境变量文件路径
  private_check_env_file_path "$ENV_FILE_PATH"
}

#
# 设置：外部函数 - 执行项目构建
#
public_compose_build() {
  "${COMPOSE_SHARE[@]}" build
}

#
# 设置：内部函数 - 执行服务启动
#
private_compose_start() {
  "${COMPOSE_SHARE[@]}" -p "${INSTANCE_NAME}" --env-file "${ENV_FILE_PATH}" up -d --no-build
}

#
# 设置：内部函数 - 执行服务关闭
#
private_compose_close() {
  "${COMPOSE_SHARE[@]}" -p "${INSTANCE_NAME}" --env-file "${ENV_FILE_PATH}" stop
}

#
# 设置：外部函数 - 执行服务启动（指定实例）
#
public_compose_start() {
  # 解析命令参数
  private_parse_command_args "$@"
  # 执行服务启动
  private_compose_start
}

#
# 设置：外部函数 - 执行服务关闭（指定实例）
#
public_compose_close() {
  # 解析命令参数
  private_parse_command_args "$@"
  # 执行服务关闭
  private_compose_close
}

#
# 设置：外部函数 - 执行服务重启（指定实例）
#
public_compose_rerun() {
  # 解析命令参数
  private_parse_command_args "$@"
  # 执行服务关闭
  private_compose_close
  # 执行服务启动
  private_compose_start
}

#
# 设置：内部函数 - 执行项目清理（Docker Compose 实例）
#
private_compose_clean_instances() {
  # 定义内部变量
  local env_file_path
  local instance_name
  # 关闭并清理所有 Docker Compose 实例
  for env_file_path in "$ENVVARS_ROOT_PATH"/*.env; do
    # 环境变量文件不存在，跳过清理
    [[ -f "$env_file_path" ]] || continue
    # 从环境变量文件路径，截取实例名称
    instance_name="$(basename "$env_file_path" .env)"
    # 关闭实例服务，执行清理
    "${COMPOSE_SHARE[@]}" -p "$instance_name" --env-file "$env_file_path" down --remove-orphans
  done
}

#
# 设置：内部函数 - 执行项目清理（Docker 镜像）
#
private_compose_clean_images() {
  # 定义内部变量
  local image_name
  # 清理所有 Docker 镜像
  for image_name in $("${COMPOSE_SHARE[@]}" config --images | sort -u); do
    # 镜像名不存在，跳过清理
    [[ -n "$image_name" ]] || continue
    # 镜像不存在，跳过清理
    docker image inspect "$image_name" >/dev/null 2>&1 || continue
    # 镜像存在，执行清理
    docker image rm "$image_name"
  done
}

#
# 设置：外部函数 - 执行项目清理函数
#
public_compose_clean() {
  # 执行项目清理（Docker Compose 实例）
  private_compose_clean_instances
  # 执行项目清理（Docker 镜像）
  private_compose_clean_images
}

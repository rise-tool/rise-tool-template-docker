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
# 设置：内部函数 - 抛出异常
#
private_throw_error() {
  private_print_error "$1"
  exit 1
}

#
# 设置：内部函数 - 校验命令参数
#
private_check_command_arg() {
  [[ -n "${2:-}" ]] || private_throw_error "参数 $1 不能为空！"
}

#
# 设置：内部函数 - 校验环境变量文件路径
#
private_check_env_file_path() {
  [[ -f "$1" ]] || private_throw_error "环境变量文件 $1 不存在！"
}

#
# 设置：内部函数 - 解析命令参数（按需求自定义）
#
private_parse_command_args() {
  # 定义内部变量
  local label=""
  # 循环读取参数
  while (($#)); do
    case "$1" in
      --label)
        private_check_command_arg "$1" "${2:-}"
        label="${2,,}"
        shift 2
        ;;
      *)
        private_throw_error "参数 $1 不支持！"
        ;;
    esac
  done
  # 校验命令参数
  private_check_command_arg "--label" "$label"
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
  local image_list
  local image_name
  local image_info
  # 获取所有 Docker 镜像列表
  image_list="$("${COMPOSE_SHARE[@]}" config --images | sort -u)" || private_throw_error "获取 Docker 镜像列表失败！"
  # 清理所有 Docker 镜像
  while IFS= read -r image_name; do
    # 镜像名称不存在，跳过清理
    [[ -n "$image_name" ]] || continue
    # 根据镜像名称查询镜像信息
    image_info="$(docker image ls --quiet --filter "reference=$image_name")" || private_throw_error "查询 Docker 镜像 $image_name 失败！"
    # 镜像信息不存在，跳过清理
    [[ -n "$image_info" ]] || continue
    # 镜像存在，执行清理
    docker image rm "$image_name" || private_throw_error "清理 Docker 镜像 $image_name 失败！"
  done <<< "$image_list"
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

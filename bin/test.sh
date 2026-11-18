#!/usr/bin/env bash

#
# 开启严格模式
#
set -euo pipefail

#
# 设置内部函数：打印错误日志
#
private_print_error() {
  # 定义内部变量
  local error_message="${1:-}"
  # 打印错误日志
  echo "错误：$error_message" >&2
}

#
# 设置内部函数：抛出异常
#
private_throw_error() {
  # 定义内部变量
  local error_message="${1:-}"
  # 打印错误日志
  private_print_error "$error_message"
  # 退出脚本
  exit 1
}

#
# 设置内部函数：校验文件是否存在
#
private_check_file_exists() {
  # 定义内部变量
  local file_path="${1:-}"
  # 校验文件是否存在
  [[ -f "$file_path" ]] || private_throw_error "文件 $file_path 不存在！"
}

#
# 设置内部函数：生成配置文件
#
private_generate_config_file() {
  # 定义内部变量
  local temp_config_path="/etc/test/server.conf"
  local auth_config_path="/etc/test/server-auth.conf"
  local exec_config_path="${1:-}"
  # 校验指定文件
  private_check_file_exists "$temp_config_path"
  private_check_file_exists "$auth_config_path"
  # 生成配置文件
  { cat "$temp_config_path"; printf "\n"; cat "$auth_config_path"; } > "$exec_config_path"
}

#
# 设置内部函数：启动应用
#
private_start_app() {
  # 定义内部变量
  local exec_config_path="/run/test/server.conf"
  # 设置默认权限（新建文件、目录）
  umask 077
  # 创建配置目录
  mkdir -p "$(dirname "$exec_config_path")"
  # 生成配置文件
  private_generate_config_file "$exec_config_path"
  # 执行服务启动
  exec cat "$exec_config_path"
}

#
# 启动服务
#
private_start_app "$@"

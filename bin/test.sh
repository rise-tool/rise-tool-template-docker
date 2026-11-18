#!/bin/sh

#
# 启用严格模式
#
set -eu

#
# 设置内部函数：打印错误日志
#
private_print_error() {
  echo "错误：$1" >&2
}

#
# 设置内部函数：校验环境变量
#
private_check_env() {
  [ -n "${2:-}" ] || {
    private_print_error "环境变量 $1 未设置！"
    exit 1
  }
}

#
# 设置内部函数：打印环境变量
#
private_print_env() {
  echo "$1: ${2:-}"
}

#
# 设置内部函数：打印文件内容
#
private_print_file() {
  cat "$1"
}

#
# 校验环境变量
#
private_check_env "TEST_SERVER_USER" "${TEST_SERVER_USER:-}"
private_check_env "TEST_SERVER_PASS" "${TEST_SERVER_PASS:-}"

#
# 打印环境变量
#
private_print_env "TEST_SERVER_USER" "${TEST_SERVER_USER:-}"
private_print_env "TEST_SERVER_PASS" "${TEST_SERVER_PASS:-}"

#
# 打印文件内容
#
private_print_file "/workspace/test/content.txt"

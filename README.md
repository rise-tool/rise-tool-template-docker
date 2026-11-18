# rise-tool-template-docker

这是一个 Docker Compose 通用服务的项目模板

## Configuration

### 1. 环境变量

|变量名称|变量含义|是否必须|默认值|可选值|
|:-:|:-:|:-:|:-:|:-:|
|TEST_SERVER_USER|test 服务 username|是|——|——|
|TEST_SERVER_PASS|test 服务 password|是|——|——|

### 2. 命令参数

|参数名称|参数含义|是否必须|默认值|可选值|
|:-:|:-:|:-:|:-:|:-:|
|--label|要启动的实例标签|是|——|——|

## Usage

### 1. 构建项目

```bash
sudo bash scripts/build.sh
```

### 2. 启动服务

```bash
#
# 设置环境变量
#
export TEST_SERVER_USER=NathanCong
export TEST_SERVER_PASS=12345678

#
# 例如：要启动 rise-service-test-1 实例
#
sudo -E bash scripts/start.sh --label 1
```

### 3. 关闭服务

```bash
#
# 例如：要关闭 rise-service-test-1 实例
#
sudo bash scripts/close.sh --label 1
```

### 4. 重启服务

```bash
#
# 设置环境变量
#
export TEST_SERVER_USER=NathanCong
export TEST_SERVER_PASS=12345678

#
# 例如：要重启 rise-service-test-1 实例
#
sudo -E bash scripts/rerun.sh --label 1
```

### 5. 清理项目

```bash
sudo bash scripts/clean.sh
```

## Development

### 1. 版本管理

```bash
#
# 创建版本分支
#
git checkout main
git checkout -b version/v1.0.0
git push origin version/v1.0.0

#
# 创建版本标签
#
git tag -a v1.0.0 -m "首个正式版本"

#
# 查看当前版本（可选）
#
git show v1.0.0

#
# 推送版本标签
#
git push origin v1.0.0
```

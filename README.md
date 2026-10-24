# rise-tool-template-docker

这是一个 Docker Compose 通用服务的项目模板

## Usage

### 1. 启动服务

#### 1.1 启动参数

|参数名称|参数含义|是否必须|参数值|
|---|---|:-:|---|
|--no-build|启动服务时不构建镜像|否|——|

#### 1.2 启动示例

```bash
#
# 启动服务，构建镜像
#
sudo bash scripts/start.sh

#
# 启动服务，复用镜像
#
sudo bash scripts/start.sh --no-build
```

### 2. 关闭服务

#### 2.1 关闭参数

|参数名称|参数含义|是否必须|参数值|
|---|---|:-:|---|
|--no-clean|关闭服务时执行清理|否|——|

#### 2.2 关闭示例

```bash
#
# 关闭服务，执行清理
#
sudo bash scripts/close.sh

#
# 关闭服务，保留资源
#
sudo bash scripts/close.sh --no-clean
```

### 3. 重启服务

#### 3.1 重启示例

```bash
#
# 重启服务，构建镜像
#
sudo bash scripts/close.sh \
&& sudo bash scripts/start.sh

#
# 重启服务，跳过构建 Dockerfile
#
sudo bash scripts/close.sh --no-clean \
&& sudo bash scripts/start.sh --no-build
```

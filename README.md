# rise-tool-template-docker

这是一个 Docker Compose 通用服务的项目模板

## Usage

### 1. 启动服务

#### 1.1 启动参数

|参数名称|参数含义|是否必须|默认值|可选值|
|---|---|:-:|---|---|
|--build|启动服务时构建镜像|否|——|——|

#### 1.2 启动示例

```bash
#
# 首次启动，构建镜像
#
sudo bash scripts/start.sh --build

#
# 重复启动，复用镜像
#
sudo bash scripts/start.sh
```

### 2. 关闭服务

#### 2.1 关闭参数

|参数名称|参数含义|是否必须|默认值|可选值|
|---|---|:-:|---|---|
|--clean|关闭服务时执行清理|否|——|——|

#### 2.2 关闭示例

```bash
#
# 关闭服务，执行清理
#
sudo bash scripts/close.sh --clean

#
# 关闭服务，保留资源
#
sudo bash scripts/close.sh
```

### 3. 重启服务

#### 3.1 重启示例

```bash
#
# 重启服务，重新构建
#
sudo bash scripts/close.sh --clean \
&& sudo bash scripts/start.sh --build

#
# 重启服务，跳过构建
#
sudo bash scripts/close.sh \
&& sudo bash scripts/start.sh
```

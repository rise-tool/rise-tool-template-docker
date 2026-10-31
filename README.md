# rise-tool-template-docker

这是一个 Docker Compose 通用服务的项目模板

## Usage

### 1. 项目构建

```bash
sudo bash scripts/build.sh
```

### 2. 服务启动

#### 2.1 启动参数

|参数名称|参数含义|是否必须|默认值|可选值|
|:-:|:-:|:-:|:-:|:-:|
|--label|要启动的实例标签|是|——|——|

#### 2.2 启动示例

```bash
#
# 例如：要启动 rise-service-test-1 实例
#
sudo bash scripts/start.sh --label 1
```

### 3. 服务关闭

#### 3.1 关闭参数

|参数名称|参数含义|是否必须|默认值|可选值|
|:-:|:-:|:-:|:-:|:-:|
|--label|要关闭的实例标签|是|——|——|

#### 3.2 关闭示例

```bash
#
# 例如：要关闭 rise-service-test-1 实例
#
sudo bash scripts/close.sh --label 1
```

### 4. 服务重启

#### 4.1 重启参数

|参数名称|参数含义|是否必须|默认值|可选值|
|:-:|:-:|:-:|:-:|:-:|
|--label|要重启的实例标签|是|——|——|

#### 4.2 重启示例

```bash
#
# 例如：要重启 rise-service-test-1 实例
#
sudo bash scripts/rerun.sh --label 1
```

### 5. 项目清理

```bash
sudo bash scripts/clean.sh
```

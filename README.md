# rise-tool-template-docker

这是一个 Docker Compose 通用服务的项目模板

## Scripts

### 服务启动

```bash
#
# 服务启动之前，执行 Dockerfile 构建
#
sudo bash scripts/start.sh

#
# 服务直接启动，忽略 Dockerfile 构建
#
sudo bash scripts/start.sh --no-build
```

### 服务停止

```bash
#
# 关闭服务，清理所有和服务相关的镜像
#
sudo bash scripts/close.sh

#
# 关闭服务，保留所有和服务相关的镜像
#
sudo bash scripts/close.sh --no-clean
```

### 服务重启

```bash
#
# 重新构建 Dockerfile 并启动服务
#
sudo bash scripts/close.sh && sudo bash scripts/start.sh

#
# 跳过构建 Dockerfile 并启动服务
#
sudo bash scripts/close.sh --no-clean && sudo bash scripts/start.sh --no-build
```

# Xiaozhi Client 本地构建指南

本文档介绍如何在本地构建和运行 Xiaozhi Client，而不是使用云端镜像。

## 前提条件

- 安装 [Docker](https://www.docker.com/get-started)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/)
- Git 克隆 Xiaozhi Client 仓库

## 方法一：使用自动化脚本（推荐）

我们提供了一个自动化脚本 `docker-build-local.sh`，可以帮助您轻松地构建和运行 Xiaozhi Client。

### 使用方法

1. 给脚本添加执行权限（如果尚未添加）

```bash
chmod +x docker-build-local.sh
```

2. 构建镜像

```bash
./docker-build-local.sh build
```

您可以通过环境变量指定版本号：

```bash
XIAOZHI_VERSION=1.7.0 ./docker-build-local.sh build
```

3. 启动容器

```bash
./docker-build-local.sh start
```

4. 重新构建并启动容器

```bash
./docker-build-local.sh restart
```

5. 停止并移除容器

```bash
./docker-build-local.sh stop
```

### 脚本帮助信息

```bash
./docker-build-local.sh --help
```

## 方法二：手动使用 Docker Compose

如果您想手动控制构建和运行过程，可以直接使用 Docker Compose 命令。

### 构建镜像

```bash
# 使用默认版本
docker-compose -f docker-compose.local.yml build

# 指定版本
docker-compose -f docker-compose.local.yml build --build-arg XIAOZHI_VERSION=1.7.0
```

### 启动容器

```bash
docker-compose -f docker-compose.local.yml up -d
```

### 停止并移除容器

```bash
docker-compose -f docker-compose.local.yml down
```

## 工作目录

Xiaozhi Client 的工作目录默认为 `~/xiaozhi-client`。如果该目录不存在，脚本会自动创建。您可以在该目录中存放您的配置文件和工作文件。

## 访问 Web UI

构建并启动容器后，您可以通过以下地址访问 Web UI：

```
http://localhost:9999
```

## 自定义配置

如果您需要自定义配置，可以编辑 `docker-compose.local.yml` 文件。例如，您可以修改端口映射、环境变量、资源限制等。

## 常见问题

### 1. 构建失败

如果构建失败，请检查以下几点：

- 确保您的网络连接正常
- 确保您有足够的磁盘空间
- 检查 Docker 日志以获取更详细的错误信息

### 2. 容器启动失败

如果容器启动失败，请检查以下几点：

- 确保端口 9999 和 3000 没有被其他程序占用
- 检查 Docker 日志以获取更详细的错误信息

### 3. 无法访问 Web UI

如果无法访问 Web UI，请检查以下几点：

- 确保容器正在运行（使用 `docker ps` 命令检查）
- 确保您的防火墙没有阻止端口 9999
- 尝试使用 `docker logs xiaozhi-client-local` 查看容器日志

## 高级用法

### 自定义 Dockerfile

如果您需要自定义 Dockerfile，可以创建一个新的 Dockerfile 并在 `docker-compose.local.yml` 中引用它：

```yaml
build:
  context: .
  dockerfile: Dockerfile.custom
```

### 使用开发环境

如果您需要开发环境，可以参考 `docker-compose.dev.yml` 和 `Dockerfile.dev`。
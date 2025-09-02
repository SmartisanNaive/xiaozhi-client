#!/bin/bash

# Xiaozhi Client 本地构建和启动脚本
# 使用本地Dockerfile构建镜像而不是使用云端镜像

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
CONTAINER_NAME="xiaozhi-client-local"
IMAGE_NAME="xiaozhi-client-local"
WORKSPACE_DIR="$HOME/xiaozhi-client"
WEB_PORT="9999"
HTTP_PORT="3000"

# 显示帮助信息
show_help() {
    echo -e "${BLUE}Xiaozhi Client 本地构建和启动脚本${NC}"
    echo "==========================================="
    echo ""
    echo "使用方法:"
    echo "  $0 build              # 仅构建镜像"
    echo "  $0 start              # 启动容器（如果镜像不存在会先构建）"
    echo "  $0 restart            # 重新构建并启动容器"
    echo "  $0 stop               # 停止并移除容器"
    echo "  $0 --help|-h          # 显示此帮助信息"
    echo ""
    echo "环境变量:"
    echo "  XIAOZHI_VERSION       # 指定xiaozhi-client版本号（默认使用package.json中的版本）"
    echo ""
    echo "使用示例:"
    echo "  $0 build              # 使用默认版本构建镜像"
    echo "  XIAOZHI_VERSION=1.7.0 $0 build  # 指定版本构建镜像"
    echo "  $0 start              # 启动容器"
    echo ""
}

# 检查工作目录是否存在，不存在则创建
check_workspace() {
    if [ ! -d "$WORKSPACE_DIR" ]; then
        echo -e "${YELLOW}工作目录 $WORKSPACE_DIR 不存在，正在创建...${NC}"
        mkdir -p "$WORKSPACE_DIR"
        echo -e "${GREEN}工作目录已创建${NC}"
    fi
}

# 构建镜像
build_image() {
    echo -e "${BLUE}开始构建 $IMAGE_NAME 镜像...${NC}"
    
    # 获取package.json中的版本号（如果环境变量未设置）
    if [ -z "$XIAOZHI_VERSION" ]; then
        if [ -f "package.json" ]; then
            XIAOZHI_VERSION=$(grep '"version":' package.json | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')
            echo -e "${YELLOW}从package.json获取版本号: $XIAOZHI_VERSION${NC}"
        else
            XIAOZHI_VERSION="1.6.1"
            echo -e "${YELLOW}使用默认版本号: $XIAOZHI_VERSION${NC}"
        fi
    fi
    
    # 构建镜像
    docker-compose -f docker-compose.local.yml build --build-arg XIAOZHI_VERSION=$XIAOZHI_VERSION
    
    echo -e "${GREEN}镜像构建完成${NC}"
}

# 启动容器
start_container() {
    echo -e "${BLUE}正在启动 $CONTAINER_NAME 容器...${NC}"
    
    # 检查镜像是否存在，不存在则构建
    if ! docker images | grep -q "$IMAGE_NAME"; then
        echo -e "${YELLOW}镜像不存在，先构建镜像...${NC}"
        build_image
    fi
    
    # 检查工作目录
    check_workspace
    
    # 启动容器
    docker-compose -f docker-compose.local.yml up -d
    
    echo -e "${GREEN}容器已启动${NC}"
    echo -e "${GREEN}Web UI 地址: http://localhost:$WEB_PORT${NC}"
}

# 停止并移除容器
stop_container() {
    echo -e "${BLUE}正在停止并移除 $CONTAINER_NAME 容器...${NC}"
    
    docker-compose -f docker-compose.local.yml down
    
    echo -e "${GREEN}容器已停止并移除${NC}"
}

# 重新构建并启动容器
restart_container() {
    echo -e "${BLUE}正在重新构建并启动 $CONTAINER_NAME 容器...${NC}"
    
    stop_container
    build_image
    start_container
}

# 主逻辑
case "$1" in
    build)
        build_image
        ;;
    start)
        start_container
        ;;
    stop)
        stop_container
        ;;
    restart)
        restart_container
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}未知命令: $1${NC}"
        show_help
        exit 1
        ;;
esac

exit 0
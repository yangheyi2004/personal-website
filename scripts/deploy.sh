#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}开始部署个人网站...${NC}"

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}错误：Docker未运行${NC}"
    exit 1
fi

# 构建新版本
echo -e "${YELLOW}1. 构建Docker镜像...${NC}"
docker build -t personal-website:latest .

# 停止旧容器
echo -e "${YELLOW}2. 停止旧容器...${NC}"
docker stop personal-website 2>/dev/null
docker rm personal-website 2>/dev/null

# 启动新容器
echo -e "${YELLOW}3. 启动新容器...${NC}"
docker run -d \
  --name personal-website \
  -p 8080:80 \
  --restart unless-stopped \
  personal-website:latest

# 检查部署状态
echo -e "${YELLOW}4. 检查部署状态...${NC}"
sleep 3
if curl -s http://localhost:8080 > /dev/null; then
    echo -e "${GREEN}✅ 部署成功！${NC}"
    echo -e "${GREEN}访问地址：http://localhost:8080${NC}"
    
    # 显示容器信息
    docker ps | grep personal-website
else
    echo -e "${RED}❌ 部署失败！${NC}"
    docker logs personal-website
    exit 1
fi
#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "========== 网站监控 $(date) =========="

# 检查容器状态
if docker ps | grep -q personal-website; then
    echo -e "${GREEN}✅ 容器运行中${NC}"
    
    # 显示容器详情
    docker ps --filter "name=personal-website" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo -e "${RED}❌ 容器未运行${NC}"
fi

# 检查网站可访问性
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ 网站可访问 (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${RED}❌ 网站不可访问 (HTTP $HTTP_CODE)${NC}"
fi

# 检查健康检查端点
HEALTH=$(curl -s http://localhost:8080/health)
if [ "$HEALTH" = "healthy" ]; then
    echo -e "${GREEN}✅ 健康检查通过${NC}"
else
    echo -e "${RED}❌ 健康检查失败${NC}"
fi

# 显示版本信息
VERSION=$(curl -s http://localhost:8080/version)
echo -e "${YELLOW}当前版本: $VERSION${NC}"

# 显示资源使用
echo -e "\n${YELLOW}资源使用情况：${NC}"
docker stats personal-website --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

echo "====================================="
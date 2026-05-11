# 使用nginx作为基础镜像
FROM nginx:alpine

# 添加元数据标签
LABEL maintainer="yangheyi@example.com"
LABEL version="1.6.0"
LABEL description="个人介绍网站"

# 安装curl用于健康检查
RUN apk add --no-cache curl

# 复制网站文件到nginx目录（从website/目录复制）
COPY website/ /usr/share/nginx/html/

# 复制自定义nginx配置（如果docker目录下有nginx配置）
# 如果有自定义配置，取消下面的注释
# COPY docker/nginx.conf /etc/nginx/nginx.conf

# 创建健康检查端点
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    index index.html; \
    location /container-id { \
        add_header Content-Type text/plain; \
        return 200 $hostname; \
    } \
    location /health { \
        add_header Content-Type text/plain; \
        return 200 "healthy\n"; \
    } \
    location /version { \
        add_header Content-Type text/plain; \
        return 200 "1.6.0\n"; \
    } \
}' > /etc/nginx/conf.d/default.conf

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
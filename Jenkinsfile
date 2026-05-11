pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'personal-website'
        VERSION = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('检出代码') {
            steps {
                checkout scm
            }
        }
        
        stage('查看项目结构') {
            steps {
                sh '''
                    echo "========== 项目根目录 =========="
                    pwd
                    ls -la
                    
                    echo "========== website目录内容 =========="
                    ls -la website/
                    
                    echo "========== docker目录内容 =========="
                    ls -la docker/ 2>/dev/null || echo "docker目录为空"
                    
                    echo "========== scripts目录内容 =========="
                    ls -la scripts/ 2>/dev/null || echo "scripts目录为空"
                    
                    echo "========== 查看index.html预览 =========="
                    head -20 website/index.html
                '''
            }
        }
        
        stage('构建Docker镜像') {
            steps {
                sh '''
                    echo "构建镜像: ${DOCKER_IMAGE}:${VERSION}"
                    # 构建上下文是当前目录，Dockerfile在根目录
                    docker build -t ${DOCKER_IMAGE}:${VERSION} .
                    docker tag ${DOCKER_IMAGE}:${VERSION} ${DOCKER_IMAGE}:latest
                '''
            }
        }
        
        stage('测试容器') {
            steps {
                sh '''
                    # 运行测试容器
                    docker run -d --name test-website -p 8080:80 ${DOCKER_IMAGE}:${VERSION}
                    
                    # 等待启动
                    sleep 5
                    
                    # 测试访问
                    echo "测试首页访问..."
                    curl -f http://localhost:8080 || exit 1
                    
                    echo "测试健康检查..."
                    curl -f http://localhost:8080/health || exit 1
                    
                    echo "测试版本信息..."
                    curl -f http://localhost:8080/version || exit 1
                    
                    # 清理测试容器
                    docker stop test-website
                    docker rm test-website
                '''
            }
        }
        
        stage('部署到生产') {
            steps {
                sh '''
                    # 停止旧容器
                    docker stop personal-website || true
                    docker rm personal-website || true
                    
                    # 启动新容器
                    docker run -d \
                      --name personal-website \
                      -p 8080:80 \
                      --restart unless-stopped \
                      ${DOCKER_IMAGE}:${VERSION}
                    
                    # 等待启动
                    sleep 5
                    
                    # 验证部署
                    echo "验证部署..."
                    curl -f http://localhost:8080 || exit 1
                    
                    echo "✅ 部署成功！访问地址：http://localhost:8080"
                '''
            }
        }
        
        stage('运行部署脚本') {
            when {
                // 如果scripts目录下有部署脚本，可以执行
                expression { fileExists('scripts/deploy.sh') }
            }
            steps {
                sh '''
                    chmod +x scripts/deploy.sh
                    ./scripts/deploy.sh
                '''
            }
        }
    }
    
    post {
        success {
            echo '🎉 Pipeline执行成功！'
            echo "镜像版本: ${DOCKER_IMAGE}:${VERSION}"
            echo "访问地址：http://localhost:8080"
            
            // 清理旧镜像（可选）
            sh 'docker image prune -f || true'
        }
        failure {
            echo '❌ Pipeline执行失败！'
            sh 'docker logs personal-website 2>/dev/null || true'
            sh 'docker logs test-website 2>/dev/null || true'
        }
        always {
            // 清理未使用的容器和镜像
            sh 'docker system prune -f || true'
        }
    }
}
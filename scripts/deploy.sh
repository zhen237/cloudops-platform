#!/bin/bash
# ============================================================
# 一键部署脚本 - cloudops-platform
# 用途：在远程 ECS 上部署应用 + 监控栈
# 注意：密码请通过环境变量传入，不要硬编码
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置项（请根据实际情况修改）
APP_NAME="cloudops-platform"
DOCKER_COMPOSE_FILE="docker-compose.yml"
REMOTE_USER="root"
REMOTE_HOST=""  # TODO: 填入你的 ECS 公网 IP

echo -e "${GREEN}[INFO] 开始部署 ${APP_NAME}...${NC}"

# 步骤 1: 创建远程目录
echo -e "${YELLOW}[Step 1] 创建远程目录...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p /opt/${APP_NAME}/{app,monitoring}"

# 步骤 2: 上传 docker-compose 文件
echo -e "${YELLOW}[Step 2] 上传配置文件...${NC}"
scp docker-compose.yml ${REMOTE_USER}@${REMOTE_HOST}:/opt/${APP_NAME}/app/
scp ../monitoring/prometheus/prometheus.yml ${REMOTE_USER}@${REMOTE_HOST}:/opt/${APP_NAME}/monitoring/

# 步骤 3: 启动服务
echo -e "${YELLOW}[Step 3] 启动 Docker Compose 服务...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "cd /opt/${APP_NAME}/app && docker-compose up -d"

# 步骤 4: 验证部署
echo -e "${YELLOW}[Step 4] 验证部署状态...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "docker-compose -f /opt/${APP_NAME}/app/docker-compose.yml ps"

echo -e "${GREEN}[SUCCESS] 部署完成！${NC}"
echo -e "${GREEN}[INFO] 访问地址:${NC}"
echo -e "  - Web 应用: http://${REMOTE_HOST}:5000"
echo -e "  - Prometheus: http://${REMOTE_HOST}:9090"
echo -e "  - Grafana: http://${REMOTE_HOST}:3000 (admin/admin)"

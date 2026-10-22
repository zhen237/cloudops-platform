# 云原生高可用运维平台 (cloudops-platform)

> 个人技术练习项目，非生产环境。密码/证书不进仓库。

## 项目概述

搭建一套基于阿里云的云原生高可用运维平台，覆盖：
- 云平台架构（VPC + SLB + 多ECS + RDS）
- CI/CD 自动化部署流水线（GitHub Actions + Docker）
- 云原生监控体系（Prometheus + Grafana + AlertManager）

**目标岗位**：技术支持工程师 / 运维工程师 / 售前解决方案工程师  
**技术栈**：阿里云、GitHub Actions、Docker、Ansible、Prometheus、Grafana、Flask

---

## 架构设计

```
用户请求
    │
    ▼
┌─────────────────┐
│   SLB (负载均衡) │ ← 阿里云公网SLB，80/443端口
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐ ┌───────┐
│ ECS-1 │ │ ECS-2 │ ← 多实例高可用（可横向扩展）
│ nginx │ │ nginx │
└───┬───┘ └───┬───┘
    │         │
    └────┬────┘
         ▼
┌─────────────────┐
│  RDS MySQL      │ ← 阿里云RDS，主从复制
└─────────────────┘
         ▲
         │
┌─────────────────┐
│  Prometheus     │ ← 指标采集
│  + Grafana      │ ← 可视化面板
└─────────────────┘
         ▲
         │
┌─────────────────┐
│  AlertManager   │ ← 钉钉/邮件告警
└─────────────────┘
```

---

## 目录结构

```
cloudops-platform/
├── app/                        # 应用层
│   ├── web/                    # Flask Web 应用（模拟业务系统）
│   │   ├── app.py              # 主应用入口
│   │   ├── requirements.txt    # Python 依赖
│   │   └── Dockerfile          # 容器化配置
│   ├── docker-compose.yml      # 本地开发栈
│   └── .env.example            # 环境变量模板
├── infra/                      # 基础设施层
│   └── terraform/              # 阿里云资源编排（可选，可用控制台手动创建）
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── monitoring/                 # 监控层
│   ├── prometheus/
│   │   └── prometheus.yml      # 采集配置
│   └── grafana/
│       ├── dashboards/
│       │   ├── system.json     # 系统资源面板
│       │   └── app.json        # 应用指标面板
│       └── alertmanager.yml    # 告警规则
├── scripts/                    # 运维脚本
│   ├── deploy.sh               # 一键部署脚本
│   └── monitor.sh              # 监控告警演示脚本
├── .github/
│   └── workflows/
│       └── ci-cd.yml           # GitHub Actions 流水线
├── README.md                   # 项目文档（待填充截图）
└── .gitignore
```

---

## 快速开始

### 1. 本地运行
```bash
cd app
docker-compose up -d
# 访问 http://localhost:5000
```

### 2. 云部署（阿里云）
```bash
# 申请免费额度，创建 VPC + ECS + RDS
# 上传代码到 GitHub，触发 Actions 流水线
# 或手动 SSH 到 ECS 执行 deploy.sh
```

### 3. 监控访问
```bash
# Prometheus: http://<ECS_IP>:9090
# Grafana:    http://<ECS_IP>:3000 (admin/admin)
```

---

## 面试话术要点

当被问"你做过什么项目"时：

> "我做了一个云原生高可用运维平台，包含三部分：
> 一是基于阿里云搭建 VPC + SLB + 多 ECS + RDS 的高可用架构，我手动下线一台 ECS 验证了 SLB 自动剔除和故障转移；
> 二是配置了 GitHub Actions 自动化部署流水线，从代码提交到容器部署全流程自动，单节点部署耗时从 1 小时缩短到 10 分钟；
> 三是搭建 Prometheus + Grafana 监控体系，覆盖资源指标和业务错误率，配置了告警规则。
> 这个项目让我把课堂学的网络、Linux、容器化知识串联起来，也加深了我对高可用架构的理解。"

---

## 诚实定位

- ✅ 个人技术练习项目
- ✅ 使用阿里云免费额度（新用户 1 年）
- ✅ 非生产环境，密码/证书不进仓库
- ✅ K8s 仅概念，未深入

---

## 版本记录

| 日期 | 版本 | 说明 |
|------|------|------|
| 2026-10-22 | v0.1 | 项目骨架初始化 |

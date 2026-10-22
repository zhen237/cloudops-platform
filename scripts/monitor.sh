#!/bin/bash
# ============================================================
# 监控告警演示脚本
# 用途：模拟异常场景，触发 Prometheus + AlertManager 告警
# ============================================================

set -e

echo "=== 监控告警演示脚本 ==="
echo ""

# 1. 查看当前告警规则状态
echo "[Step 1] 检查 AlertManager 状态..."
curl -s http://localhost:9093/api/v2/status | jq '.config' 2>/dev/null || echo "AlertManager 未运行，请检查 Docker 容器"

# 2. 模拟 CPU 负载过高
echo ""
echo "[Step 2] 模拟 CPU 高负载（30秒）..."
yes > /dev/null &
CPU_PID=$!
sleep 30
kill $CPU_PID 2>/dev/null
echo "CPU 负载模拟完成"

# 3. 检查 Prometheus 指标
echo ""
echo "[Step 3] 查询 CPU 指标..."
curl -s "http://localhost:9090/api/v1/query?query=cpu_usage" | jq '.' 2>/dev/null || echo "Prometheus 未运行，请检查 Docker 容器"

# 4. 触发测试告警
echo ""
echo "[Step 4] 发送测试告警..."
curl -X POST http://localhost:9093/api/v2/alerts \
  -H "Content-Type: application/json" \
  -d '[{
    "labels": {
      "alertname": "TestCPUAlert",
      "instance": "localhost:9090",
      "severity": "warning"
    },
    "annotations": {
      "summary": "测试告警：CPU 负载过高",
      "description": "这是一个测试告警，用于验证 AlertManager 配置是否正确"
    }
  }]'

echo ""
echo "=== 演示完成 ==="
echo "请检查："
echo "  1. Grafana 面板是否有 CPU 指标变化"
echo "  2. AlertManager 是否收到告警"
echo "  3. 钉钉/邮件是否收到通知（如已配置）"

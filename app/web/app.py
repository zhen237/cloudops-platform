from flask import Flask, jsonify, request
import os
import time
import random

app = Flask(__name__)

# 模拟业务数据
@app.route('/')
def index():
    return jsonify({
        "service": "cloudops-platform",
        "version": "0.1.0",
        "status": "running",
        "timestamp": int(time.time())
    })

@app.route('/api/health')
def health():
    """健康检查接口"""
    return jsonify({
        "status": "healthy",
        "uptime": int(time.time()) - start_time
    })

@app.route('/api/metrics')
def metrics():
    """模拟业务指标（供 Prometheus 采集）"""
    return jsonify({
        "requests_total": random.randint(100, 1000),
        "requests_success": random.randint(90, 99),
        "requests_error": random.randint(0, 10),
        "avg_response_time_ms": random.randint(10, 100),
        "active_users": random.randint(50, 200)
    })

@app.route('/api/simulate/slow', methods=['POST'])
def simulate_slow():
    """模拟慢响应（用于测试监控告警）"""
    delay = request.json.get('delay', 5)
    time.sleep(delay)
    return jsonify({
        "message": f"模拟慢响应 {delay} 秒",
        "actual_delay": delay
    })

@app.route('/api/simulate/error', methods=['POST'])
def simulate_error():
    """模拟错误（用于测试监控告警）"""
    error_type = request.json.get('type', '500')
    status_code = int(error_type)
    return jsonify({"error": f"模拟 {status_code} 错误"}), status_code

# 记录启动时间
start_time = int(time.time())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

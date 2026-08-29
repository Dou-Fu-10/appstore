#!/bin/bash

# 获取脚本所在目录的父目录（即应用版本目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(dirname "$SCRIPT_DIR")"

# 创建数据目录（相对于 docker-compose.yml 所在目录）
# 注意：这里的 ./data 会对应到 docker-compose.yml 中挂载的 ./data
mkdir -p ./data

# 生成 config.yaml 配置文件到 ./data 目录
cat > ./data/config.yaml << EOF
mixed-port: ${MIXED_PORT}
allow-lan: true
external-controller: 0.0.0.0:9090
secret: ${SECRET}
mode: rule

# --- 订阅配置 ---
proxy-providers:
  mysub:
    type: http
    url: "${SUB_URL}"
    path: /root/.config/mihomo/subscription.yaml
    interval: $((${SUB_INTERVAL:-6} * 3600))
    health-check:
      enable: true
      url: https://cp.cloudflare.com
      interval: 300
      timeout: 1000

# --- 代理组 ---
proxy-groups:
  - name: PROXY
    type: select
    use:
      - mysub
    proxies:
      - DIRECT
  - name: AUTO
    type: url-test
    use:
      - mysub
    health-check:
      enable: true
      url: https://cp.cloudflare.com
      interval: 300
      tolerance: 100

# --- DNS 配置 ---
dns:
  enable: true
  ipv6: true
  nameserver:
    - https://[2606:4700:4700::1111]/dns-query
    - 223.5.5.5

# --- 规则 ---
rules:
  - GEOIP,LAN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,PROXY

tun:
  enable: false
  stack: system
  auto-route: true
  auto-detect-interface: true
EOF

# 设置配置文件权限
chmod 644 ./data/config.yaml

echo "Mihomo configuration generated successfully at ./data/config.yaml"
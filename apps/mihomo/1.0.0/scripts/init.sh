#!/bin/bash

# ============================================================
# 从 .env 文件加载变量并生成 Mihomo 配置
# ============================================================

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(dirname "$SCRIPT_DIR")"

# 切换到应用目录（.env 文件所在位置）
cd "$APP_DIR"

# --- 1. 加载 .env 文件 ---
load_env() {
    if [ -f ".env" ]; then
        echo "[INFO] 正在加载 .env 文件..."
        # 逐行读取 .env，跳过注释和空行，导出变量
        while IFS='=' read -r key value; do
            # 跳过注释行和空行
            [[ -z "$key" || "$key" =~ ^# ]] && continue
            # 去除变量名和值的首尾空格
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            # 去除可能的引号
            value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
            # 导出为环境变量
            export "$key=$value"
        done < ".env"
        echo "[INFO] .env 文件加载完成"
    else
        echo "[WARN] 未找到 .env 文件，将使用默认值"
    fi
}

# --- 2. 执行加载 ---
load_env

# --- 3. 设置变量（使用 .env 中的值，若不存在则使用默认值） ---
MIXED_PORT=${MIXED_PORT:-7890}
SECRET=${SECRET:-$(openssl rand -hex 16 2>/dev/null || echo "default-secret-123")}
SUB_URL=${SUB_URL:-"https://example.com/subscribe"}
SUB_INTERVAL=${SUB_INTERVAL:-6}
CONTAINER_NAME=${CONTAINER_NAME:-"mihomo"}

# 打印关键变量（便于调试，注意隐藏密码）
echo "[INFO] MIXED_PORT: $MIXED_PORT"
echo "[INFO] SUB_URL: $SUB_URL"
echo "[INFO] SUB_INTERVAL: $SUB_INTERVAL 小时"
echo "[INFO] CONTAINER_NAME: $CONTAINER_NAME"

# --- 4. 创建数据目录 ---
mkdir -p ./data

# --- 5. 生成 config.yaml ---
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
    interval: $((${SUB_INTERVAL} * 3600))
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

# --- 6. 设置配置文件权限 ---
chmod 644 ./data/config.yaml

# --- 7. 🔥 额外：从国内镜像预下载 GeoIP 文件（可选）---
echo "[INFO] 正在尝试下载 GeoIP 文件..."
GEOIP_URL="https://raw.gitmirror.com/MetaCubeX/meta-rules-dat/release/geoip.metadb"
if curl -Lfso "./data/geoip.metadb" "$GEOIP_URL" --connect-timeout 10 --max-time 30 2>/dev/null; then
    echo "[INFO] ✅ GeoIP 文件下载成功"
    chmod 644 ./data/geoip.metadb
else
    echo "[WARN] ⚠️ GeoIP 文件下载失败，容器启动时会自动尝试下载"
fi

echo "[INFO] ✅ Mihomo 配置文件生成完成: ./data/config.yaml"
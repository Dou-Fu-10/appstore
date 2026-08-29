# Mihomo

基于 Mihomo（Clash Meta）的代理客户端，支持订阅管理、策略组和规则分流。

---

## 🚀 安装

1. 填写以下参数：
   - **订阅链接**：你的代理订阅地址
   - **代理端口**：默认 `7890`
   - **面板端口**：默认 `9090`
   - **面板密码**：自定义
   - **更新间隔**：订阅自动更新小时数

2. 点击确认，等待部署完成

---

## 🧭 使用

- **Web 面板**：`http://服务器IP:面板端口/ui`
- **代理地址**：`http://服务器IP:代理端口`
- **查看日志**：`docker logs -f mihomo`

---

## ❓ 常见问题

**启动失败，日志显示 `Can't find MMDB`**  
服务器无法访问 GitHub，安装脚本已内置国内镜像自动下载，如仍失败请手动执行：

```bash
cd /opt/1panel/apps/mihomo/你的容器名/data/
wget -O https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb
docker restart 你的容器名
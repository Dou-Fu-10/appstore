# MetaTube

MetaTube 是一款元数据刮削器，可从 JavDB、Aviation、FANZA 等多个来源刮削影视元数据。

---

## 🚀 部署

### 环境变量配置

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `PORT_HTTP` | 服务端口 | `8080` |
| `META_DB_USER` | 数据库用户名 | `metatube` |
| `META_DB_PASS` | 数据库密码 | `metatube` |
| `META_DB_HOST` | 数据库主机 | `postgres` |
| `META_DB_PORT` | 数据库端口 | `5432` |
| `META_DB_NAME` | 数据库名 | `metatube` |
| `HTTP_PROXY` | HTTP 代理（可选） | 空 |
| `HTTPS_PROXY` | HTTPS 代理（可选） | 空 |
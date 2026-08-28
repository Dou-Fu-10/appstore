```markdown
# 🚀 AppStore

可扩展的容器化应用仓库，用于托管和分发自建应用包。

## 📦 仓库结构

```
appstore/
└── apps/                    # 所有应用存放目录
    └── {app-key}/           # 每个应用独立文件夹（应用唯一标识）
        ├── logo.png         # 应用图标
        ├── manifest.yml     # 应用元数据
        ├── README.md        # 应用说明文档
        └── {version}/       # 版本号目录（如 1.0.0）
            ├── manifest.yml # 版本参数配置
            ├── docker-compose.yml
            └── scripts/     # 生命周期脚本（可选）
```

## 🚀 使用方式

### 方式一：自动同步

```bash
curl -L https://github.com/doufu/appstore/archive/main.zip -o appstore.zip
unzip -o appstore.zip
cp -rf appstore-main/apps/* /目标应用目录/
rm -rf appstore-main appstore.zip
```

### 方式二：手动部署

```bash
git clone https://github.com/doufu/appstore.git
cp -rf appstore/apps/* /目标应用目录/
```

## 🛠️ 应用开发

每个应用需遵循标准目录结构，包含图标、元数据声明、版本配置及编排文件。

## 📄 许可证

[MIT License](./LICENSE)

## 🤝 贡献

欢迎提交 Pull Request 或通过 Issues 反馈问题。

[Issues](https://github.com/doufu/appstore/issues)


---
AIGC:
    Label: "1"
    ContentProducer: 001191440300708461136T1XGW3
    ProduceID: ffe33bb7b05fc28ffd56f1f50821df6e_52a9b0a1c6c811f1b45c525400cd780f
    ReservedCode1: 0Q9zFwnId7MwlC92qF6YlblgAs2tvgn6ccxDfZIS8M1+4FcR0WL6QKvjCXr0EzPomFXBbQdCyEgAWNnEn6KIoB+zfBGyaR+oeikPZ3Rl33uGEbk78S74sPP5uSOnxjmZPe3MirtD/Q8XedMal5BUj3mewTXGCqtMglDJBFmoXAmIge2VGFxU+gIRa4g=
    ContentPropagator: 001191440300708461136T1XGW3
    PropagateID: ffe33bb7b05fc28ffd56f1f50821df6e_52a9b0a1c6c811f1b45c525400cd780f
    ReservedCode2: 0Q9zFwnId7MwlC92qF6YlblgAs2tvgn6ccxDfZIS8M1+4FcR0WL6QKvjCXr0EzPomFXBbQdCyEgAWNnEn6KIoB+zfBGyaR+oeikPZ3Rl33uGEbk78S74sPP5uSOnxjmZPe3MirtD/Q8XedMal5BUj3mewTXGCqtMglDJBFmoXAmIge2VGFxU+gIRa4g=
---

# Back4App AWS 免费代理部署包

基于开源方案 **hupan0210/nlbw-vps** 的思路：利用 Back4App 容器引擎的免费托管，白嫖 AWS 原生 IP 出口；容器内运行 sing-box，提供 VLESS + WebSocket 入站，经 direct 出站访问目标站点。

- 免费：Back4App 免费层 + AWS 原生 IP，无需自购服务器
- 入口：`https://<你的应用>.b4a.run:443`（Back4App 自动分配域名）
- 传输：VLESS over WebSocket + TLS，可过常规 CDN/防火墙场景

## 目录结构

```
back4app-aws-proxy/
├── Dockerfile    # alpine + sing-box 1.14.3 (linux-amd64)
└── config.json   # sing-box VLESS+WS 入站配置（uuid 可自定义）
```

## 部署步骤

1. **注册 Back4App**：打开 <https://www.back4app.com> 注册账号（免费）。
2. **创建 App**：Dashboard → 新建 App（如 `free-proxy`），选择 Back4App Containers 模块。
3. **推送仓库**：将本目录（含 `Dockerfile` 与 `config.json`）推送到你的 GitHub 仓库。
4. **关联并部署**：Back4App → Containers → 关联该 GitHub 仓库 → 选择自动构建（Auto Deploy）。平台会自动拉取代码、构建镜像并部署。
5. **获取域名**：构建成功后，Back4App 自动生成对外域名，形如 `xxx.b4a.run`（该域名解析到 AWS 原生 IP）。
6. **自定义 UUID（推荐）**：本地执行 `uuidgen` 生成新 UUID，替换 `config.json` 中 `users[0].uuid`，推送后重新部署，避免使用默认 UUID。

## 客户端 VLESS 链接模板

将下方模板中的 `UUID` 与 `域名` 替换后，即可导入 Clash / V2rayN / Shadowrocket 等客户端：

```
vless://UUID@域名:443?encryption=none&security=tls&type=ws&host=域名&path=%2fchat&sni=域名
```

示例（假想）：

```
vless://1030C4E4-63BD-477F-A5CD-E136FFF66DE4@free-proxy-abc.b4a.run:443?encryption=none&security=tls&type=ws&host=free-proxy-abc.b4a.run&path=%2fchat&sni=free-proxy-abc.b4a.run
```

## cron-job.org 每 15 分钟保活（防 60 分钟休眠）

Back4App 免费容器在闲置约 60 分钟后会进入休眠，休眠后首个请求需冷启动（较慢）。通过定时请求可保持容器常驻：

1. 打开 <https://cron-job.org> 注册账号（免费）。
2. 新建定时任务（Create Cron Job）：
   - URL：`https://<你的应用>.b4a.run/chat`（也可用根路径）
   - 执行周期：**Every 15 minutes**
3. 保存并启用。此后每 15 分钟一次请求，容器不会进入休眠，冷启动延迟基本消除。

## 免责声明

- 本部署包仅供技术学习与合法用途，请勿用于任何违反所在地法律法规的活动。
- 使用者须自行遵守 Back4App 与 AWS 的服务条款；免费层存在资源限制与休眠机制，稳定性请自行评估。
- 免费代理存在被限流、关停或滥用封号的风险，由此造成的损失由使用者自行承担。
- 请勿在未经授权的情况下使用他人网络资源或开展任何恶意行为。
*（内容由AI生成，仅供参考）*

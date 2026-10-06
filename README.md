# aliyun-cli-ops-scripts

阿里云 CLI 日常运维脚本集：把控制台里点来点去的操作变成一条命令。

面向个人开发者与小团队运维：不需要记 API 参数，不需要开控制台，装好 CLI 后拿来即跑。全部脚本带中文注释，逐一可独立使用。

## 快速开始

```bash
git clone https://github.com/lizs-eng/aliyun-cli-ops-scripts.git
cd aliyun-cli-ops-scripts

# 安装 aliyun CLI（Linux 官方脚本，macOS 用 brew install aliyun-cli）
curl -fsSL https://aliyuncli.alicdn.com/install.sh | bash

# 配置凭证（建议 RAM 子账号 + 只读授权起步）
aliyun configure set --profile default --mode AK \
  --access-key-id <你的AK> --access-key-secret <你的SK> \
  --region cn-hangzhou

# 试跑：列出实例
./scripts/ecs/ecs_list.sh cn-hangzhou
```

依赖：`jq`（脚本解析 JSON 用）。多账号/多地域/最小权限说明见完整版手册。

## 免费样章（本仓库）

| 脚本 | 用途 |
|---|---|
| `scripts/ecs/ecs_list.sh` | 实例清单：名称/IP/状态/到期时间一张表 |
| `scripts/ecs/ecs_batch_start.sh` | 批量开机（自动跳过运行中） |
| `scripts/ecs/ecs_batch_stop.sh` | 批量关机（带二次确认） |
| `scripts/ecs/ecs_disk_check.sh` | 云助手批量查磁盘使用率 |
| `scripts/oss/oss_upload.sh` | 目录打包备份到 OSS，按日期归档 |

## 完整版（¥29.9）

在免费样章之上追加 9 个脚本 + 3 份手册：

- **ECS**：到期巡检（输出可直贴钉钉）、一键快照保命、SSH 白名单自助恢复
- **OSS**：最新备份取回、临时签名 URL
- **CDN**：URL/目录刷新、昨日流量账单速查
- **域名**：全量到期巡检（<30 天告警）
- **通知**：钉钉机器人通知封装
- **手册**：安装配置 / CRON 定时模板 / 常见报错速查表

→ 完整版与更多作品：[面包多小店](https://mbd.pub/o/engineer)

## 校准与许可

- 脚本按 2026-10 的 aliyun CLI 行为编写；CLI 参数为 PascalCase（`--InstanceId`）
- 需要 `jq`；macOS 的 base64 差异见各脚本头部注释
- 许可：MIT（见 LICENSE）

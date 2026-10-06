#!/usr/bin/env bash
# 目录备份到 OSS：本地目录打包上传，按日期归档
# 用法：./oss_upload.sh 桶名 本地目录 [oss目标前缀，默认 backup/]
# 示例：./oss_upload.sh my-backup /etc/nginx          → oss://my-backup/backup/2026-10-07-nginx.tar.gz
set -euo pipefail

BUCKET="$1"; SRC="$2"; PREFIX="${3:-backup}"
[ -d "$SRC" ] || { echo "目录不存在: $SRC"; exit 1; }

SRC_NAME=$(basename "$SRC")
STAMP=$(date +%F)
TAR="/tmp/${STAMP}-${SRC_NAME}.tar.gz"

echo "打包 $SRC ..."
tar -czf "$TAR" -C "$(dirname "$SRC")" "$SRC_NAME"

echo "上传到 oss://$BUCKET/$PREFIX/"
aliyun oss cp "$TAR" "oss://$BUCKET/$PREFIX/" --meta Cache-Control:no-cache

SIZE=$(du -h "$TAR" | cut -f1)
echo "完成：oss://$BUCKET/$PREFIX/${STAMP}-${SRC_NAME}.tar.gz ($SIZE)"
rm -f "$TAR"

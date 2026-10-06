#!/usr/bin/env bash
# 批量关机：正常关机（不强制断电），带二次确认
# 用法：./ecs_batch_stop.sh 地域ID 实例ID1 实例ID2 ...
set -euo pipefail

REGION="$1"; shift
[ $# -ge 1 ] || { echo "用法: $0 地域ID 实例ID..."; exit 1; }

echo "即将关机以下实例：$*"
read -r -p "确认请输入 yes: " ok
[ "$ok" = "yes" ] || { echo "已取消"; exit 0; }

for id in "$@"; do
  echo "[关机] $id ..."
  aliyun ecs StopInstance --RegionId "$REGION" --InstanceId "$id" --ForceStop false > /dev/null
done
echo "已下发关机指令"

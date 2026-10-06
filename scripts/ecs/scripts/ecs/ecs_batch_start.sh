#!/usr/bin/env bash
# 批量开机：按实例 ID 列表逐台启动，跳过运行中的机器
# 用法：./ecs_batch_start.sh 地域ID 实例ID1 实例ID2 ...
set -euo pipefail

REGION="$1"; shift
[ $# -ge 1 ] || { echo "用法: $0 地域ID 实例ID..."; exit 1; }

for id in "$@"; do
  status=$(aliyun ecs DescribeInstances --RegionId "$REGION" \
    --InstanceIds "[\"$id\"]" | jq -r '.Instances.Instance[0].Status')
  if [ "$status" = "Running" ]; then
    echo "[跳过] $id 已在运行"
    continue
  fi
  echo "[开机] $id ..."
  aliyun ecs StartInstance --RegionId "$REGION" --InstanceId "$id" > /dev/null
done
echo "完成。状态同步需几秒，可用 ./ecs_list.sh $REGION 复查"

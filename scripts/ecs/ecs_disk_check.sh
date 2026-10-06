#!/usr/bin/env bash
# 批量查磁盘使用率：通过云助手在多台实例上同时执行 df 命令
# 用法：./ecs_disk_check.sh 地域ID 实例ID...
# 说明：云助手需要在实例内预装（公共镜像默认自带）
set -euo pipefail

REGION="$1"; shift
[ $# -ge 1 ] || { echo "用法: $0 地域ID 实例ID..."; exit 1; }

CONTENT='df -h | grep -E "^/dev" | sort -k5 -r'
# CommandContent 传 base64 更稳，避免引号转义问题
B64=$(printf '%s' "$CONTENT" | base64 -w0)

resp=$(aliyun ecs RunCommand --RegionId "$REGION" \
  --Type RunShellScript \
  --Name "disk-check-$(date +%s)" \
  --CommandContent "$B64" \
  --ContentEncoding Base64 \
  $(for id in "$@"; do echo -n "--InstanceId.$id "; done) \
  --Timeout 60)

invoke_id=$(echo "$resp" | jq -r '.InvokeId')
echo "命令已下发，InvokeId=$invoke_id"
echo "等待 8 秒后查询结果..."
sleep 8

aliyun ecs DescribeInvocations --RegionId "$REGION" --InvokeId "$invoke_id" \
  | jq -r '.Invocations.Invocation[0].InvocationResults[]?
      | [.InstanceId, (.Output // "无输出" | @base64d | gsub("\n"; " ")), (.ErrorResponse // "-")]
      | @tsv' | column -t -s $'\t'

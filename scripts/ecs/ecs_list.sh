#!/usr/bin/env bash
# ECS 实例清单：一次看清 名称 / 内外网 IP / 状态 / 到期时间
# 依赖：aliyun CLI（已 configure）、jq
# 用法：./ecs_list.sh [地域ID，默认 cn-hangzhou]
set -euo pipefail

REGION="${1:-cn-hangzhou}"

aliyun ecs DescribeInstances --RegionId "$REGION" --PageSize 100 \
  | jq -r '.Instances.Instance[] |
      [.InstanceName, .InstanceId, .VpcAttributes.PrivateIpAddress.IpAddress[0] // "-",
       .PublicIpAddress.IpAddress[0] // "-", .Status, .ExpiredTime]
      | @tsv' \
  | column -t -s $'\t'

#!/bin/bash
set -e
echo ECS_CLUSTER=${ecs_cluster_name} > /etc/ecs/ecs.config

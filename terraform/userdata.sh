#!/bin/bash

set -euo pipefail

dnf update -y
dnf install -y git docker awscli

systemctl enable --now docker

cd /opt

git clone https://github.com/jaspreetsingh-dev/pulse_ci

cd /opt/pulse_ci

export DB_HOST=$(aws ssm get-parameter \
  --name "/${project_name}/db-host" \
  --query "Parameter.Value" \
  --output text)

export DB_NAME=$(aws ssm get-parameter \
  --name "/${project_name}/db-name" \
  --query "Parameter.Value" \
  --output text)

export DB_USER=$(aws ssm get-parameter \
  --name "/${project_name}/db-user" \
  --query "Parameter.Value" \
  --output text)

export DB_PORT=$(aws ssm get-parameter \
  --name "/${project_name}/db-port" \
  --query "Parameter.Value" \
  --output text)

export DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id "${rds_secret_arn}" \
  --query "SecretString" \
  --output text | python3 -c 'import sys, json; print(json.load(sys.stdin)["password"])')

docker build -t pulse-ci .

docker run -d \
  --name pulse-ci \
  --restart unless-stopped \
  -p 80:80 \
  --log-driver=awslogs \
  --log-opt awslogs-region="${region}" \
  --log-opt awslogs-group="/pulse-ci/application" \
  --log-opt awslogs-create-group="false" \
  --log-opt awslogs-stream="ec2-${HOSTNAME}" \
  -e DB_HOST="$DB_HOST" \
  -e DB_NAME="$DB_NAME" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e DB_PORT="$DB_PORT" \
  pulse-ci
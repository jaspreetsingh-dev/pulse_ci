#!/bin/bash

set -euo pipefail

dnf update -y
dnf install -y git python3 python3-pip awscli

git clone https://github.com/jaspreetsingh-dev/pulse-ci.git

cd pulse-ci

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt

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

python3 backend/app.py
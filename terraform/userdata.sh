#!/bin/bash

set -euo pipefail

dnf update -y
dnf install -y git python3 python3-pip awscli

cd /opt

git clone https://github.com/jaspreetsingh-dev/pulse_ci

cd /opt/pulse_ci

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

cat <<EOF > /etc/systemd/system/pulse-ci.service
[Unit]
Description=Pulse CI
After=network.target

[Service]
User=root
WorkingDirectory=/opt/pulse_ci/backend
Environment="DB_HOST=$${DB_HOST}"
Environment="DB_NAME=$${DB_NAME}"
Environment="DB_USER=$${DB_USER}"
Environment="DB_PASSWORD=$${DB_PASSWORD}"
Environment="DB_PORT=$${DB_PORT}"
ExecStart=/opt/pulse_ci/venv/bin/gunicorn --bind 0.0.0.0:80 app:app
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable pulse-ci
systemctl start pulse-ci
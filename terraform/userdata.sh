#!/bin/bash

dnf update -y
dnf install -y git python3 python3-pip

git clone https://github.com/jaspreetsingh-dev/pulse-ci.git

cd pulse-ci

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt

python3 backend/app.py
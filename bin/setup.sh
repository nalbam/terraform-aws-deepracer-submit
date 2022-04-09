#!/usr/bin/env bash

# Log everything we do.
set -x
exec >/var/log/user-data.log 2>&1

cat <<EOF | tee -a /etc/motd
#########################################################

# deepracer-submit

tail -f -n 1000 /var/log/user-data.log

#########################################################
EOF

amazon-linux-extras install -y mate-desktop1.x
amazon-linux-extras install -y epel

yum install -y git jq chromium chromedriver

pip3 install pytest selenium xvfbwrapper slacker

runuser -l ec2-user -c "aws configure set default.region ${region}"
runuser -l ec2-user -c "aws configure set default.output json"

runuser -l ec2-user -c "cd ~ && git clone https://github.com/nalbam/deepracer-submit.git"

runuser -l ec2-user -c "curl -fsSL -o ~/run.sh https://raw.githubusercontent.com/nalbam/terraform-aws-deepracer-submit/main/bin/run.sh"
runuser -l ec2-user -c "bash ~/run.sh init"

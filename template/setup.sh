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

apt-get update

apt-get install -y git vim tmux nmon xvfb jq chromium-browser chromium-codecs-ffmpeg chromium-chromedriver

pip3 install pytest selenium xvfbwrapper slacker

runuser -l ubuntu -c "cd ~ && git clone https://github.com/nalbam/deepracer-submit.git"

runuser -l ubuntu -c "curl -fsSL -o ~/run.sh https://raw.githubusercontent.com/nalbam/terraform-aws-deepracer-submit/main/template/run.sh"
runuser -l ubuntu -c "bash ~/run.sh"

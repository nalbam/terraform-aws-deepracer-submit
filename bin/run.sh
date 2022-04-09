#!/usr/bin/env bash

CMD=${1}

ACCOUNT_ID=$(aws sts get-caller-identity | jq .Account -r)

_usage() {
  cat <<EOF
================================================================================
 Usage: $(basename $0) {init|backup|restore}
================================================================================
EOF
}

_backup() {
  echo "backup"
}

_restore() {
  echo "restore"
}

_init() {
  pushd ~/deepracer-submit

  # get aws ssm parameter store
  export DR_USERNO=$(aws ssm get-parameter --name /dr-submit/userno --with-decryption | jq .Parameter.Value -r)
  export DR_USERNAME=$(aws ssm get-parameter --name /dr-submit/username --with-decryption | jq .Parameter.Value -r)
  export DR_PASSWORD=$(aws ssm get-parameter --name /dr-submit/password --with-decryption | jq .Parameter.Value -r)

  export DR_TARGET_URL=$(aws ssm get-parameter --name /dr-submit/target_url --with-decryption | jq .Parameter.Value -r)

  export DR_SLACK_TOKEN=$(aws ssm get-parameter --name /dr-submit/slack_token --with-decryption | jq .Parameter.Value -r)
  export DR_SLACK_CHANNEL=$(aws ssm get-parameter --name /dr-submit/slack_channel --with-decryption | jq .Parameter.Value -r)

  # config
  cat <<EOF >config/deepracer.sh
#!/bin/bash

export DR_USERNO="$DR_USERNO"
export DR_USERNAME="$DR_USERNAME"
export DR_PASSWORD="$DR_PASSWORD"

export DR_TARGET_URL="$DR_TARGET_URL"

export DR_SLACK_TOKEN="$DR_SLACK_TOKEN"
export DR_SLACK_CHANNEL="$DR_SLACK_CHANNEL"
EOF

  # crontab
  cat <<EOF >config/crontab.sh
10,20,30,40,50 * * * * ~/deepracer-submit/submit.sh tt > /tmp/submit-tt.log 2>&1
EOF

  crontab config/crontab.sh

  # send slack
  if [ ! -z ${DR_SLACK_TOKEN} ]; then
    curl -sL opspresso.github.io/tools/slack.sh | bash -s -- \
      --token="${DR_SLACK_TOKEN}" --username="deepracer-submit" \
      --color="good" --title="deepracer-submit" "\`started\`"
  fi

  popd
}

case ${CMD} in
i | init)
  _init
  ;;
b | backup)
  _backup
  ;;
r | restore)
  _restore
  ;;
*)
  _usage
  ;;
esac

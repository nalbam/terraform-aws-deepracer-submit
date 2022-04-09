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
  export USERNO=$(aws ssm get-parameter --name /dr-submit/userno --with-decryption | jq .Parameter.Value -r)
  export USERNAME=$(aws ssm get-parameter --name /dr-submit/username --with-decryption | jq .Parameter.Value -r)
  export PASSWORD=$(aws ssm get-parameter --name /dr-submit/password --with-decryption | jq .Parameter.Value -r)

  export TARGET_URL=$(aws ssm get-parameter --name /dr-submit/target_url --with-decryption | jq .Parameter.Value -r)

  export SLACK_TOKEN=$(aws ssm get-parameter --name /dr-submit/slack_token --with-decryption | jq .Parameter.Value -r)
  export SLACK_CHANNEL=$(aws ssm get-parameter --name /dr-submit/slack_channel --with-decryption | jq .Parameter.Value -r)

  cat <<EOF >>config/deepracer.sh
#!/bin/bash

export USERNO="$USERNO"
export USERNAME="$USERNAME"
export PASSWORD="$PASSWORD"

export TARGET_URL="$TARGET_URL"

export SLACK_TOKEN="$SLACK_TOKEN"
export SLACK_CHANNEL="$SLACK_CHANNEL"
EOF

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

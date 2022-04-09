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

  USERNO="123456789012"
  USERNAME="username"
  PASSWORD="password"

  TARGET_URL="https://nalbam.com/deepracer/submit.json"

  SLACK_TOKEN="xoxb-1111-2222-xxxx"
  SLACK_CHANNAL="#sandbox"

  echo "#!/bin/bash" > config/deepracer.sh
  echo "USERNO=\"$USERNO\"" >> config/deepracer.sh
  echo "USERNAME=\"$USERNAME\"" >> config/deepracer.sh
  echo "PASSWORD=\"$PASSWORD\"" >> config/deepracer.sh
  echo "TARGET_URL=\"$TARGET_URL\"" >> config/deepracer.sh
  echo "SLACK_TOKEN=\"$SLACK_TOKEN\"" >> config/deepracer.sh
  echo "SLACK_CHANNAL=\"$SLACK_CHANNAL\"" >> config/deepracer.sh

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

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

  if [ ! -f config/deepracer.sh ]; then
    cp config/deepracer.sample.sh config/deepracer.sh
  fi

  USERNO="123456789012"
  USERNAME="username"
  PASSWORD="password"

  TARGET_URL="https://nalbam.com/deepracer/submit.json"

  SLACK_TOKEN="xoxb-1111-2222-xxxx"
  SLACK_CHANNAL="#sandbox"

  sed -i "s/\(^USERNO=\)\(.*\)/\1$USERNO/" config/deepracer.sh
  sed -i "s/\(^USERNAME=\)\(.*\)/\1$USERNAME/" config/deepracer.sh
  sed -i "s/\(^PASSWORD=\)\(.*\)/\1$PASSWORD/" config/deepracer.sh

  sed -i "s/\(^TARGET_URL=\)\(.*\)/\1$TARGET_URL/" config/deepracer.sh

  sed -i "s/\(^SLACK_TOKEN=\)\(.*\)/\1$SLACK_TOKEN/" config/deepracer.sh
  sed -i "s/\(^SLACK_CHANNAL=\)\(.*\)/\1$SLACK_CHANNAL/" config/deepracer.sh

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

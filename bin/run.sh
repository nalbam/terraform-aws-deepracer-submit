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
  pushd ~

  git clone https://github.com/nalbam/deepracer-submit.git

  popd

  pushd ~/deepracer-submit

  # get aws ssm parameter store
  aws ssm get-parameter --name "/dr-submit/config" --with-decryption | jq .Parameter.Value -r >config/deepracer.json
  aws ssm get-parameter --name "/dr-submit/crontab" --with-decryption | jq .Parameter.Value -r >config/crontab.sh

  # crontab
  crontab config/crontab.sh

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

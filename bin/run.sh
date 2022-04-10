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
  aws ssm get-parameter --name "/dr-submit/config" --with-decryption | jq .Parameter.Value -r \
    > config/deepracer.json
  aws ssm get-parameter --name "/dr-submit/crontab" --with-decryption | jq .Parameter.Value -r \
    > config/crontab.sh

  # crontab
  crontab config/crontab.sh

  # # send slack
  # if [ ! -z ${DR_SLACK_TOKEN} ]; then
  #   curl -sL opspresso.github.io/tools/slack.sh | bash -s -- \
  #     --token="${DR_SLACK_TOKEN}" --username="deepracer-submit" \
  #     --color="good" --title="deepracer-submit" "\`started\`"
  # fi

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

# terraform-aws-deepracer-submit

## config

```bash
export USERNO="$(aws sts get-caller-identity | jq .Account -r)"
export USERNAME="username"
export PASSWORD="password"

export TARGET_URL="https://nalbam.com/deepracer/submit.json"

export SLACK_TOKEN="xoxb-1111-2222-xxxx"
export SLACK_CHANNEL="#sandbox"

# put aws ssm parameter store
aws ssm put-parameter --name /dr-submit/userno --value "${USERNO}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name /dr-submit/username --value "${USERNAME}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name /dr-submit/password --value "${PASSWORD}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name /dr-submit/target_url --value "${TARGET_URL}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name /dr-submit/slack_token --value "${SLACK_TOKEN}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name /dr-submit/slack_channel --value "${SLACK_CHANNEL}" --type SecureString --overwrite | jq .
```

## replace

> 이 쉘을 실행하면, 테라폼 백엔드의 버켓을 aws account id 를 포함하는 문자로 변경하고, 버켓이 없다면 버켓을 생성 합니다.

```bash
./replace.sh

# ACCOUNT_ID = 123456789012
# REGION = ap-northeast-2
# BUCKET = terraform-workshop-123456789012
```

## terraform apply

```bash
terraform apply

# ...

Outputs:

public_ip = "54.69.00.00"
```

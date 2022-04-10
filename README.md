# terraform-aws-deepracer-submit

* <https://github.com/nalbam/deepracer-submit>

> spot 인스턴스를 황용하여 자동으로 deepracer model 을 submit 해줍니다.

## config

```bash
aws configure set default.region ap-northeast-2
aws configure set default.output json

export USERNO="$(aws sts get-caller-identity | jq .Account -r)"
export USERNAME="username"
export PASSWORD="password"

cat <<EOF > /tmp/deepracer.json
{
  "userno": "${USERNO}",
  "username": "${USERNAME}",
  "password": "${PASSWORD}",
  "slack": {
    "token": "",
    "channel": "#sandbox"
  },
  "leaderboards": [
    {
      "name": "pro",
      "arn": "league/arn%3Aaws%3Adeepracer%3A%3A%3Aleaderboard%2F9f6ca6de-ecfa-467a-a7d9-c899a811a206",
      "models": [
        "my-model-01",
        "my-model-02"
      ]
    }
  ]
}
EOF

cat <<EOF > /tmp/crontab.sh
10,20,30,40,50 * * * * /home/ec2-user/deepracer-submit/submit.py -t pro > /tmp/submit.log 2>&1
EOF

# put aws ssm parameter store
aws ssm put-parameter --name "/dr-submit/config" --type SecureString --overwrite --value file:///tmp/deepracer.json | jq .
aws ssm put-parameter --name "/dr-submit/crontab" --type SecureString --overwrite --value file:///tmp/crontab.sh | jq .

# get aws ssm parameter store
aws ssm get-parameter --name "/dr-submit/config" --with-decryption | jq .Parameter.Value -r
aws ssm get-parameter --name "/dr-submit/crontab" --with-decryption | jq .Parameter.Value -r
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

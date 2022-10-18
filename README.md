# terraform-aws-deepracer-submit

* <https://github.com/nalbam/deepracer-submit>

> Automatically submit deepracer model using spot instance.

## config

> Save the environment variable json in AWS SSM.

```bash
aws configure set default.region ap-northeast-2
aws configure set default.output json

export USERNO="$(aws sts get-caller-identity | jq .Account -r)"
export USERNAME="username"
export PASSWORD="password"

export SLACK_TOKEN="" # xoxb-xxx

cat <<EOF > /tmp/deepracer.json
{
  "userno": "${USERNO}",
  "username": "${USERNAME}",
  "password": "${PASSWORD}",
  "slack": {
    "token": "${SLACK_TOKEN}",
    "channel": "#sandbox"
  },
  "races": [
    {
      "name": "open",
      "arn": "league/arn%3Aaws%3Adeepracer%3A%3A%3Aleaderboard%2F3cd3f5fa-a1e8-434a-a099-e15ba5b426c4",
      "models": [
        "my-model-01",
        "my-model-02"
      ]
    },
    {
      "name": "pro",
      "arn": "league/arn%3Aaws%3Adeepracer%3A%3A%3Aleaderboard%2Fe5eedeec-7a74-411d-a83e-895666b36af7",
      "models": [
        "my-model-01",
        "my-model-02"
      ]
    }
  ]
}
EOF

cat <<EOF > /tmp/crontab.sh
*/10 * * * * /home/ec2-user/deepracer-submit/submit.py -t pro > /tmp/submit.log 2>&1
0 * * * * bash /home/ec2-user/run.sh restore
EOF

# put aws ssm parameter store
aws ssm put-parameter --name "/dr-submit/config" --type SecureString --overwrite --value file:///tmp/deepracer.json | jq .
aws ssm put-parameter --name "/dr-submit/crontab" --type SecureString --overwrite --value file:///tmp/crontab.sh | jq .

# get aws ssm parameter store
aws ssm get-parameter --name "/dr-submit/config" --with-decryption | jq .Parameter.Value -r
aws ssm get-parameter --name "/dr-submit/crontab" --with-decryption | jq .Parameter.Value -r
```

## replace

> Create bucket and dynamodb for Terraform backend.

```bash
./replace.sh

# ACCOUNT_ID = 123456789012
# REGION = ap-northeast-2
# BUCKET = terraform-workshop-123456789012
```

## terraform apply

> Create a Spot Instance with AutoscalingGroup.

```bash
# start
terraform apply

# ...

Outputs:

public_ip = "54.69.00.00"

# stop
terraform apply -var desired=0
```

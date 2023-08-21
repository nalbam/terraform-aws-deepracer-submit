# terraform-aws-deepracer-submit

* <https://github.com/nalbam/deepracer-submit>

> Automatically submit deepracer model using spot instance.

## clone

```bash
git clone https://github.com/nalbam/terraform-aws-deepracer-submit
```

## config

> Save the environment variable json in AWS SSM.

```bash
aws configure set default.region us-east-1
aws configure set default.output json

export AWS_RESION=$(aws configure get default.region)
export ACCOUNT_ID=$(aws sts get-caller-identity | jq .Account -r)

echo "AWS_RESION: ${AWS_RESION}"
echo "ACCOUNT_ID: ${ACCOUNT_ID}"

# export DR_USERNAME="username"
# export DR_PASSWORD="password"
# export SLACK_TOKEN="xoxb-xxx-xxx-xxx"

# aws ssm put-parameter --name "/dr-submit/username" --value "${DR_USERNAME}" --type SecureString --overwrite | jq .
# aws ssm put-parameter --name "/dr-submit/password" --value "${DR_PASSWORD}" --type SecureString --overwrite | jq .
# aws ssm put-parameter --name "/dr-submit/slack_token" --value "${SLACK_TOKEN}" --type SecureString --overwrite | jq .

export DR_USERNAME="$(aws ssm get-parameter --name "/dr-submit/username" --with-decryption | jq .Parameter.Value -r)"
export DR_PASSWORD="$(aws ssm get-parameter --name "/dr-submit/password" --with-decryption | jq .Parameter.Value -r)"
export SLACK_TOKEN="$(aws ssm get-parameter --name "/dr-submit/slack_token" --with-decryption | jq .Parameter.Value -r)"

cat <<EOF > /tmp/deepracer.json
{
  "userno": "${ACCOUNT_ID}",
  "username": "${USERNAME}",
  "password": "${PASSWORD}",
  "slack": {
    "token": "${SLACK_TOKEN}",
    "channel": "sandbox"
  },
  "races": [
    {
      "name": "pro",
      "arn": "league/arn%3Aaws%3Adeepracer%3A%3A%3Aleaderboard%2Fe5eedeec-7a74-411d-a83e-895666b36af7",
      "models": [
        "DR-2204-PRO-D-5", "DR-2210-PRO-C-2", "DR-2210-PRO-C-3"
      ]
    },
    {
      "name": "comm",
      "arn": "competition/arn%3Aaws%3Adeepracer%3A%3A493717844238%3Aleaderboard%2F05dd1efc-4ada-48b2-9cbb-441d2a6ac4e4",
      "models": [
        "DR-22-CHAMP-C-2", "DR-22-CHAMP-C-3"
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

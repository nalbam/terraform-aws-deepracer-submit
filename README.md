# terraform-aws-deepracer-submit

## replace

> 이 쉘을 실행하면, 테라폼 백엔드의 버켓을 aws account id 를 포함하는 문자로 변경하고, 버켓이 없다면 버켓을 생성 합니다.

```bash
./replace.sh

# ACCOUNT_ID = 123456789012
# REGION = us-west-2
# BUCKET = terraform-workshop-123456789012
```

## terraform apply

```bash
terraform apply

# ...

Outputs:

public_ip = "54.69.00.00"
```

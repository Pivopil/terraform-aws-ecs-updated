# Pre install S3 bucket for Terraform remote state adn dynamoDb state lock

```shell script
export AWS_PROFILE="main-dev"
export AWS_DEFAULT_REGION="us-east-1"
export TF_VAR_bucket_state_name="terraform-remote-state-storage-s3"
export TF_VAR_state_lock_name="terraform-remote-state-lock"

terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

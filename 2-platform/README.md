# Create ECS and ECR

```shell script
### From Step 0
export AWS_PROFILE="main-dev"
export AWS_DEFAULT_REGION="us-east-1"
export TF_VAR_bucket_state_name="terraform-remote-state-storage-s3"
export TF_VAR_state_lock_name="terraform-remote-state-lock"



terraform init \
    -backend-config="bucket=$TF_VAR_bucket_state_name" \
    -backend-config="dynamodb_table=$TF_VAR_state_lock_name" \
    -backend-config="key=PROD/platform.tfstate"

terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

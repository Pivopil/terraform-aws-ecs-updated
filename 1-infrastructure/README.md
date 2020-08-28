# Create VPC

```shell script
## From step 0
export AWS_PROFILE="main-dev"
export AWS_DEFAULT_REGION="us-east-1"
export TF_VAR_bucket_state_name="terraform-remote-state-storage-s3"
export TF_VAR_state_lock_name="terraform-remote-state-lock"

## Added Sidrs
export TF_VAR_vpc_cidr="10.0.0.0/16"

terraform init \
    -backend-config="bucket=$TF_VAR_bucket_state_name" \
    -backend-config="dynamodb_table=$TF_VAR_state_lock_name" \
    -backend-config="key=PROD/infrastructure.tfstate"

terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

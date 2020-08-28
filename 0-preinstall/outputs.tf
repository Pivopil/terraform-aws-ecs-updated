output "bucket_name" {
  value = aws_s3_bucket.terraform_state_storage_s3.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.dynamodb_terraform_state_lock.id
}




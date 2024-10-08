output "terraform_state_bucket_name" {
    value = aws_s3_bucket.tf_state.id
}

output "terraform_state_bucket_arn" {
    value = aws_s3_bucket.tf_state.arn
}

output "tf_state_lock_db_name" {
    value = aws_dynamodb_table.tf_state_lock_db.id
}

output "tf_state_lock_db_arn" {
    value = aws_dynamodb_table.tf_state_lock_db.arn
}
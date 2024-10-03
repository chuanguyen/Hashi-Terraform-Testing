resource "aws_dynamodb_table" "tf_state_lock_db_prod" {
  name = "tf_state_lock_prod"
  hash_key = "LockID"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
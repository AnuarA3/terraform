output "s3_bucket_arn" {
    value = aws_s3_bucket.terraform-state-bucket.arn
    description = "The arn of the s3 bucket"
}
output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform-locks-db.name
    description = "The name of the DynamoDB table"
}

output "unique_bucket_name" {
    value = random_pet.bucket_name.id
    description = "ID of the S3 bucket"
}
output "s3_bucket" {
    value = aws_s3_bucket.infoj-source-bucket.id
}
output "s3_bucket_object" {
    value = aws_s3_bucket_object.eb_bucket_obj.id
}
resource "aws_s3_bucket" "infoj-source-bucket" {
    bucket = "infoj-source-bucket"
    tags = {
      "name" = "prod"
      "env" = "prod"
    }
}

resource "aws_s3_bucket_object" "eb_bucket_obj" {
  bucket = aws_s3_bucket.infoj-source-bucket.id
  key = "beanstalk/app.zip"
  source = "/home/vipul/projects/EBS-1/app.zip"
}
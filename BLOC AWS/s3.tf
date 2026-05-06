# Get current AWS account ID for unique bucket naming
data "aws_caller_identity" "current" {}

# Create an S3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-bucket-${data.aws_caller_identity.current.account_id}"
}

# Allow public access policy on this bucket
resource "aws_s3_bucket_public_access_block" "demo_bucket" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow public read access on the bucket objects
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.demo_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = ["${aws_s3_bucket.demo_bucket.arn}/*"]
      }
    ]
  })
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "demo_bucket_versioning" {
  bucket = aws_s3_bucket.demo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Upload a file to the bucket
resource "aws_s3_object" "demo_object" {
  bucket = aws_s3_bucket.demo_bucket.id
  key    = "hello-world.txt"
  source = "./test-file.txt"
  etag   = filemd5("./test-file.txt")
}
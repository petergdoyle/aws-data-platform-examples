

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "${var.bucket_name}"
  force_destroy = true
}  

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "pb" {
  bucket = aws_s3_bucket.s3-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership]
  bucket = aws_s3_bucket.s3-bucket.id
  acl    = "private"
}

resource "aws_s3_object" "folder1" {
  bucket = aws_s3_bucket.s3-bucket.bucket
  key    = "results/"
  source = "/dev/null"
  acl    = "private"
}

resource "aws_s3_object" "folder2" {
  bucket = aws_s3_bucket.s3-bucket.bucket
  key    = "uploads/"
  source = "/dev/null"
  acl    = "private"
}



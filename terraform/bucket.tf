# Create the backup bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "backups"
}
# resource "random_string" "bucket_name" {
#   length           = 32
#   special          = false
#   lower = true
#   upper = false
# }
resource "aws_s3_bucket" "my_bucket" {
  #bucket = random_string.bucket_name.result
  bucket = var.bucket_name
  tags = {
    UserUuid        = var.UserUuid
  }
}

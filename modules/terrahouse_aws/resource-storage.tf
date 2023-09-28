resource "aws_s3_bucket" "website_bucket" {
  #bucket = random_string.bucket_name.result
  bucket = var.bucket_name
  tags = {
    UserUuid        = var.UserUuid
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"  # Change to your desired index file
  source       = var.index_html_filepath  # Local path to your index.html file
  content_type = "text/html"
  etag = filemd5(var.index_html_filepath)
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"  # Change to your desired error file
  source       = var.error_html_filepath  # Local path to your error.html file
  content_type = "text/html"
  etag = filemd5(var.error_html_filepath)
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  #policy = data.aws_iam_policy_document.bucket_policy_oac.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [{
        "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" = "Allow",
        "Principal" = {
            "Service" = "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource"=  "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}/*",
        "Condition" = {
            "StringEquals" = {
                "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
            }
        }
    }]
  })
}
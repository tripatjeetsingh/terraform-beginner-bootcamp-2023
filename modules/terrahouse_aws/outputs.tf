output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
  sensitive = true
}
output "static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
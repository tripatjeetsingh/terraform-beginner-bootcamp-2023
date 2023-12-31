output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}
output "static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
variable "UserUuid" {
  type        = string
  description = "UserUuid of the bootcamper"
}
variable "bucket_name" {
  type = string
}
variable "index_html_filepath" {
  type = string
}
variable "error_html_filepath" {
  type = string
}
variable "assets_filepath" {
  type = string
}
variable "content_version" {
  type = number
}
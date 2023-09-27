variable "UserUuid" {
  type = string
  description = "UserUuid of the bootcamper"
}
variable "bucket_name" {
  type = string
}
variable "index_html_filepath" {
  type = string
  description = "The file path for index.html"
  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The provided path for index.html does not exist"
  }
}
variable "error_html_filepath" {
  type = string
  description = "The file path for error.html"
  validation {
    condition = fileexists(var.error_html_filepath)
    error_message = "The provided path for error.html does not exist"
  }
}
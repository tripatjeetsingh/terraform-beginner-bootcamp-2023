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
variable "content_version" {
  description = "The content version. Should be a positive integer starting at 1"
  type = number
  validation {
    condition = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The content_version must be a positive integer starting at 1."
  }
  
}
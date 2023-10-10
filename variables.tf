variable "teacherseat_user_uuid" {
  type        = string
  description = "UserUuid of the bootcamper"
}
variable "terratowns_access_token" {
  type = string
}
variable "bucket_name" {
  type = string
}
# variable "recipe_public_path" {
#   type = string
# }
# variable "mario_public_path" {
#   type = string
# }

variable "mario" {
  type = object({
    public_path = string
    content_version = number 
  })
}
variable "mushroom_pasta" {
  type = object({
    public_path = string
    content_version = number 
  })
}

# variable "index_html_filepath" {
#   type = string
# }
# variable "error_html_filepath" {
#   type = string
# }
# variable "assets_filepath" {
#   type = string
# }
# variable "mario_content_version" {
#   type = number
# }
# variable "mushroom_pasta_content_version" {
#   type = number
# }
variable "terratowns_endpoint" {
  type = string
}
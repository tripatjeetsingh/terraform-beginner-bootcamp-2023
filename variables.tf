variable "teacherseat_user_uuid" {
  type        = string
  description = "UserUuid of the bootcamper"
}
variable "terratowns_access_token" {
  type = string
}
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
variable "terratowns_endpoint" {
  type = string
}
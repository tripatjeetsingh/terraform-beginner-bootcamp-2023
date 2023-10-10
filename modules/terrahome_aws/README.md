## Terraform AWS

```
module "home_mario" {
  source              = "./modules/terrahome_aws"
  teacherseat_user_uuid            = var.teacherseat_user_uuid
  bucket_name         = var.bucket_name
  public_path         = var.mario_public_path
  #index_html_filepath = var.index_html_filepath
  #error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  #assets_filepath     = var.assets_filepath
}
```

The public directory expects the following:
-   index.html
-   error.html
-   assets

All top level files and assets will be copied but not any sub-directories.
# Terraform Beginner Bootcamp 2023 - Week 1

## Table of Contents
- [Root Module Structure](#root-module-structure)
- [Terraform and Input Variables](#terraform-and-input-variables)
  * [Terraform Cloud Variables](#terraform-cloud-variables)
  * [Loading Terraform Variables](#loading-terraform-variables)
    + [-var flag](#-var-flag)
    + [--var-file flag](#--var-file-flag)
    + [terraform.tfvars](#terraformtfvars)
    + [auto.tfvars](#autotfvars)
  * [Variable Definition Precedence](#variable-definition-precedence)
- [Dealing with configuration drift](#dealing-with-configuration-drift)
- [What happens if you lose your state file?](#what-happens-if-you-lose-your-state-file)
  * [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
  * [Fix Manual Configuration](#fix-manual-configuration)
- [Fix using Terraform Refresh](#fix-using-terraform-refresh)
- [Terraform Modules](#terraform-modules)
  * [Terraform Module Structure](#terraform-module-structure)
  * [Passing Input Variables](#passing-input-variables)
  * [Terraform Module Sources](#terraform-module-sources)
- [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
- [working with Files in Terraform](#working-with-files-in-terraform)
  * [Filemd5](#filemd5)
  * [Fileexists function](#fileexists-function)
  * [Path Variables](#path-variables)
- [Terraform Locals](#terraform-locals)
- [Terraform Data Source](#terraform-data-source)
- [Working with JSON](#working-with-json)
  * [Changing the Lifecycle of Resoruces](#changing-the-lifecycle-of-resoruces)
- [Terraform Data](#terraform-data)
- [Terraform Provisioners](#terraform-provisioners)
  * [Local-exec](#local-exec)
  * [Remote-exec](#remote-exec)
- [For_Each Expressions](#for-each-expressions)


## Root Module Structure 

The root module structure is as follows:
```
-  PROJECT_ROOT
    -  main.tf  - stores everything else
    -  variables.tf  - stores the structure of inputs variables
    -  providers.tf  - define required providers and their configuration
    -  outputs.tf - stores the outputs
    -  terraform.tfvars  - the data of variables we want to load into the project
    -  README.md - required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables


### Terraform Cloud Variables

In terraform we can set two kind of varilables:

-   Environment variables - that you would set in your bash terminal eg. AWS credentials 
-   Terraform variables - that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not visible on the UI.

### Loading Terraform Variables

#### -var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform <plan/apply> -var UserUuid="my-user-id"`

#### --var-file flag
We can use the `--var-file` flag to set an input variable from the tfvar file eg. `terraform <plan/apply> --var-file terraform.tfvars`

#### terraform.tfvars

This is the default file to load in terraform variables in bulk

#### auto.tfvars

- TO DO

### Variable Definition Precedence

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

1.  Environment variables
2.  The **terraform.tfvars** file, if present.
3.  The **terraform.tfvars.json** file, if present.
4.  Any ***.auto.tfvars** or ***.auto.tfvars.json** files, processed in lexical order of their filenames.
4.  Any `-var` and `-var-file` options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace)


[Terraform Input Variable Documentation](https://developer.hashicorp.com/terraform/language/values/variables)


## Dealing with configuration drift

## What happens if you lose your state file

If you lose your state file, you most likely have to tear down all your cloud infrastructure manually. 

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import. 

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resources manually through clickOps. 

If we run Terraform plan it will attempt to put our infrastructure back into the expected state fixing configuration drift. 

## Fix using Terraform Refresh


```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place the module in the module directory when locally developing modules but you can name it whatever you like. 


### Passing Input Variables

We can pass input variables to our module.

The module has to declare the terraform variables in its own variables.tf 

```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  UserUuid = var.UserUuid
  bucket_name = var.bucket_name
}
```

### Terraform Module Sources

Using the source we can import the module from various places eg.

-   locally
-   Github
-   Terraform Registry


```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)


## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that may be deprecated. Often affecting providers.

## working with Files in Terraform

### Filemd5

[filemd5 Function Documentation](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Fileexists function

This is a built-in terraform function to check the existence of a file.

```
  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The provided path for index.html does not exist"
  }
```
[Fileexists Function Documentation](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Path Variables

In Terraform there is a special variable called `path` that allows us to reference local paths:

- path.module - Gets the path for the current module
- path.root - Gets the path for the root module

[Special Path Variables](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"  # Change to your desired index file
  source       = "${path.root}/public/index.html"  # Local path to your index.html file
  content_type = "text/html"
}
```

## Terraform Locals

Locals allow us to define local variabled. 

It can be very useful when we need to transform data into another format and have it referenced as a variable.

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Source

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing it. 

```
data "aws_caller_identity" "current" {}
```

[Data Sources Documentation](https://developer.hashicorp.com/terraform/language/data-sources)


## Working with JSON

`jsonencode` encodes a given value to a string using JSON syntax.

We used jsonencode to create a json inline policy for the s3 bucket.

```
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


### Changing the Lifecycle of Resoruces

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

The terraform_data resource is useful for storing values which need to follow a manage resource lifecycle, and for triggering provisioners when there is no other logical managed resource in which to place them.

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

```
resource "terraform_data" "replacement" {
  input = var.revision
}
```

[Terraform_data resource documentation](https://developer.hashicorp.com/terraform/language/resources/terraform-data)


## Terraform Provisioners

Provisioners allow you to execute commands on compute instances eg. AWS CLI commands

They are not recommended for use by HashiCorp because configuration management tool such as Ansible are a better fit, but the functionality exists.

### Local-exec

This will execute a command on the machine running terraform commands eg. plan apply

```
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
```

[local-exec documentation](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec 

This will execute commands on a machine which you target. You will need to provide credentials such ssh to get into the machine. 

```
  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
```

[remote-exec documentation](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)


## For Each Expressions

If a resource or module block includes a for_each argument whose value is a map or a set of strings, Terraform creates one instance for each member of that map or set.

This is mostly useful when you sare creating multiples of cloud resources and you wan to reduce the amount of repetitive terraform code.

```
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
```

[For_Each expression documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

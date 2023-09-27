# Terraform Beginner Bootcamp 2023 - Week 1

## Table of Contents

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

## What happens if you lose your state file?

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

In Terraform there is a special variable called `path` that allows us to reference local paths:

- path.module - Gets the path for the current module
- path.root - Gets the path for the root module

[Special Path Variables](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)
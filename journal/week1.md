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
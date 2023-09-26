# Terraform Beginner Bootcamp 2023

## Semantics Versioning :mage:

This project is going to utilize semantics versioning for its tagging
[semver.org](https://semver.org) 

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backwards compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations for Linux Distribution
This project is build against Ubuntu. Please consider checking your Linux distribution and change according to your distribution needs. 
[How to check OS version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:
```sh
$ cat /etc/os-release'

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Considerations with the terraform CLI changes 
The terraform CLI installation instructions have changed due to gpg keyring changes so we needed to refer to the latest terraform install cli instructions documentation and change the scripting for install

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Refactoring into Bash Scripts
While fixing the terraform CLI gpg deprecation issues we notice that bash scripts steps were a considerable amount more code. So we decided to create a basg script to install the Terraform CLI.

This bash script is located at: [./bin/install_terraform_cli](./bin/install_terraform_cli)

-   This will keep the GitPod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
-   This allow us an easier to debug and execute manually terraform CLI install
-   This will allow better portability for other projects that need to install Terraform CLI.


#### Shebang
A shebang is the character sequence consisting of the characters number sign and exclamation mark (#!) at the beginning of a script. It tells the bash script what program will interpret the script.eg. `#!/bin/bash`

Chatgpt recommended this format for bash `#!/usr/bin/env bash` 

-   For portability for different OS distrubtions 
-   Will search user's PATH for the bash executable

[Shebang documentation](https://en.wikipedia.org/wiki/Shebang_(Unix))

### Execution Considerations
When executing bash scripts, we can use the `./` shorthand notation to execute the bash script. 

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it. 

eg. `source ./bin/install_terraform_cli`

### Linux Permissions Consideration
In order to make our bash scripts executable, we need to change linux permissions for the fix to be executable at the user mode.
```
chmod u+x ./bin/install_terraform_cli
```
Alternatively:
```sh
chmod 744 ./bin/install_terraform_cli
```
[chmod documentation](https://en.wikipedia.org/wiki/Chmod)

### Github Lifecycle (Before, Init, Command)
We need to be careful when using init because it will not run when we restart an existing workspace. 

[GitPod Prebuild and New Workspaces](https://www.gitpod.io/docs/configure/workspaces/tasks)

### Working with Env Vars

#### env command
We can list out all environment variables (Env Vars) using the `env` commands

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars
In the tyerminal we can set using `export HELLO='world'`

On the terminal we can unset using `export HELLO`

We can set env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```
Within a bash script we can set env without writing export eg.
```sh
#! usr/bin/env bash
HELLO='world'
echo $HELLO
```

#### Printing Vars
We can print env vars using echo eg. `echo $HELLO`

#### Scoping of Env Vars
When you open up new bash terminal in vscode, it will not be aware of the env vars that you have set in another window. 

If you want Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in GitPod
We can persist env vars into gitpod by storing them in gitpod secrets storage.
```
gp env HELLP='world'
```
All future workspaces launched will set the env var for all bash terminals opened in those workspaces.
 
You can also set env vars in the `.gitpod.yml` but this can only store non-sensetive information.

### AWS CLI Installation

AWS CLI is installed for this project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if your AWS credentials is configured correctly by running the following AWS CLI commands: 
```sh
aws sts get-caller-identity
```
If it is successful you should see a json payload that looks like this:

```json
$ aws sts get-caller-identity
{
    "UserId": "AIDA5H2QG87KKN98CTLTA",
    "Account": "87348413872798",
    "Arn": "arn:aws:iam::87348413872798:user/terraform-beginner-bootcamp"
}
```

We will need to generate AWS credentials from IAM user in order to use the AWS CLI.

[Creating an IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

[Managing access keys for IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)


## Terraform Basics 

### Terraform Registry

Terraform sources their provider and modules from the terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

-   **Providers** in terraform is a plugin that enables interaction with an APIs. They tell Terraform which services it needs to interact with.
-   **Modules** in terraform is a collection of standard configurations. Terraform modules encapsulates group of resources dedicated to one task, reducing the amount of code you have to develop for similar infrastructure components.

[Terraform random provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

### Terraform Console

We can see a list of all the terraform commands by simply typing `terraform`

#### Terraform Init
After writing your Terraform code, the `terraform init` command is the first command you should use to initialize the working directory by downloading the binaries for the terraform providers. The terraform init command performs the following steps:

-   Backend Initialization
-   Plugin Installation

[Terraform init command](https://developer.hashicorp.com/terraform/cli/commands/init)

#### Terraform Plan
The `terraform plan` command reports on changes to infrastructure, but it does not apply any of the proposed changes. Instead, it creates a reviewable execution plan, which you can use to confirm that the proposed changes are expected.

The terraform plan command does the following things:

-   Ensures the state is up to date by reading the current state of any infrastructure.
-   Proposes a series of changes that will be made to the infrastructure.

The `plan`` can be saved to a file, which can be applied later.

[Terraform plan command](https://developer.hashicorp.com/terraform/cli/commands/plan)

#### Terraform Apply
The `terraform apply` command executes the actions proposed in a terraform plan. It is used to deploy your infrastructure. Typically apply should be run after `terraform init` and `terraform plan`. It creates or updates infrastructure depending on the configuration files. By default, a plan will be generated first and will need to be approved before it is applied. 

You can use `terraform apply -auto-approve` to apply changes without having to interactively type ‘yes’ to the plan.

[Terraform apply command](https://developer.hashicorp.com/terraform/cli/commands/apply)

While creating a S3 bucket using terraform, we encountered the 'InvalidBucketName' error. Upon reviewing the documentation, the Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-). We then added the additional bucket parameters `lower=true` and `upper=false` to the terraform s3 resource definition to resolve the issue.
```sh
aws_s3_bucket.my_bucket: Creating...
╷
│ Error: creating Amazon S3 (Simple Storage) Bucket (n7dSngRCtL5sygZx): InvalidBucketName: The specified bucket is not valid.
│       status code: 400, request id: QJEF7J7PC8NFC6X1, host id: hz/cWSGYqjX7tUVKZhJBqEemAC401W4kCPArubjeY1+L1abgot+zvQ9usHA=
│ 
│   with aws_s3_bucket.my_bucket,
│   on main.tf line 23, in resource "aws_s3_bucket" "my_bucket":
│   23: resource "aws_s3_bucket" "my_bucket" {
│ 
╵
```
[S3 Bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)
[Terraform Resource: S3 bucket documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

#### Terraform Destroy

The `Terraform destroy` command is a command that destroys/terminates resources managed by your current Terraform project by deleting infrastructure resources present in the state file. 

You can use `terraform destroy -auto-approve` to destroy changes without having to interactively type ‘yes’.

[Terraform destroy command](https://developer.hashicorp.com/terraform/cli/commands/destroy)


#### Terraform Lock Files
`.terraform.loc.hcl` lock file is designed to record the exact package versions used to satisfy each provider requirement in your configuration. This ensures that every member of your team uses the same provider versions, avoiding inconsistencies and potential bugs.

The terraform Lock file **should be commited** to your version control system (VSC) eg. GitHub

#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure. 

This file **should not be commited** to your version control system (VSC) eg. GitHub

This file can contain sensetive data. If you lose this file, you lose the state of your infrastructure. 

`.terraform.tf.state.backup` stores the previous state. 

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers downloaded during the initialization of terraform using the command `terraform init`.

## Issues with Terraform Cloud Login and GitPod workspace

When attempting to run `terraform login` it will launch bash a wiswig view to generate a token. However, it does not work expected in GitPod VSCODE in the browser. You must select `P` for print and then select `q` to quit the print option, it then prompts to enter the API token. After you enter the API token, you will then see a message `Retrieved token for user xxxxxxxxxx`. 

```sh
Generate a token using your browser, and copy-paste it into this prompt.

Terraform will store the token in plain text in the following file
for use by subsequent commands:
    /home/gitpod/.terraform.d/credentials.tfrc.json

Token for app.terraform.io:
  Enter a value: 

Retrieved token for user xxxxxxxxxx

---------------------------------------------------------------------------------

                                          -                                
                                          -----                           -
                                          ---------                      --
                                          ---------  -                -----
                                           ---------  ------        -------
                                             -------  ---------  ----------
                                                ----  ---------- ----------
                                                  --  ---------- ----------
   Welcome to Terraform Cloud!                     -  ---------- -------
                                                      ---  ----- ---
   Documentation: terraform.io/docs/cloud             --------   -
                                                      ----------
                                                      ----------
                                                       ---------
                                                           -----
                                                               -


   New to TFC? Follow these steps to instantly apply an example configuration:

   $ git clone https://github.com/hashicorp/tfc-getting-started.git
   $ cd tfc-getting-started
   $ scripts/setup.sh
```

[Terraform Cloud Login from the CLI Documentation](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login)

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
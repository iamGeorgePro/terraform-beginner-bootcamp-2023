Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root structure module is as follows:

```
PROJECT_ROOT
|
├── main.tf             # Core configuration file. Used to define and manage your infrastructure as code
├── variables.tf        # stores the structure of input variables
├── terraform.tfvars    # the data of variables we want to load into our Terraform project
├── providers.tf        # defines required providers and their configurations
├── output.tf           # stores our outputs
└── README.md           # required for root modules
```
- NB: ascii directory files

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


## Terraform and Input Variables 
### Terraform Cloud Variables

In Terraform we can set two kinds of variables:
- Environment Variables - those you would set in your bash terminal. eg. AWS credentials
- Terraform Variables - those you would normally set in your tfvars file

We can set Terraform cloud variables to be sensitive so that they are not visibley shown in the UI.

### Loading Terraform Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or overide a variable in the tfvars file. 
eg. `$ terraform -var user-uuid="my_user-uuid"`


## terraform tfvars 

This is the default file to load variables in bulk. 

### auto.tfvars

In Terraform, auto.tfvars is a special filename that Terraform automatically loads when you run commands like terraform apply or terraform plan. This file is used to provide default values for input variables defined in your Terraform configuration.

### order of operation of terraform variables

In Terraform, variable values are determined following a specific order of operation:

**Variable Declarations:** Variables are initially defined in the variable block within your Terraform configuration files. These declarations specify the variable name, type, and optional default value.

**Variable Overrides:** Variable values can be overridden using various methods, including command-line flags (-var), variable files (-var-file), environment variables (TF_VAR_variable_name), and interactive input. These methods allow users to customize variable values.

**HCL Configuration:** If a variable is not explicitly overridden using the methods mentioned above, Terraform will use the default value specified in the variable block within the configuration files.

**Variable Defaults:** If no default value is provided in the variable block and the variable is not overridden through any other means, Terraform considers the variable as undefined. In such cases, Terraform may prompt users for the value during execution or raise an error for required variables.

This order of operation allows Terraform to handle variables flexibly, accommodating different scenarios and environments by providing default values and allowing users to customize them as needed.

## Dealing With Configuration Drift

Terraform import can be used to recover from situations where the state file is lost, but it may not work for all cloud resources.
Storing the state file in a reliable location, like Terraform Cloud, is a best practice to avoid state file loss.
Configuration drift can occur when resources are manually modified outside of Terraform, but Terraform can detect and correct such drift when running `terraform plan`.
In cases of manual configuration changes, Terraform can attempt to bring the infrastructure back to the expected state.
The use of the `random` provider for resource naming may not be suitable for all scenarios and can lead to issues when correcting configuration drift.

## What happens if we lose our state file?

If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through ClickOps. 

If we run Terraform plan is with attempt to put our infrstraucture back into the expected state fixing Configuration Drift


## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)


### Considerations when using Terraform to manage different types of resources

In this bootcamp, we are using Terraform for all three types of management:
- Infrastructure (resources management)
- Configurations
- Files

Please note that Terraform is optimised and made for infrastructure management. Therefore, managing files (uploading and downloading) using terraform is not the best practice, all the more so in production environment although Terraform does offer the capabilities to perform such tasks.

### Working with Files in Terraform 

#### [Fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists) function
This is a built in terraform function to check the existance of a file.

```
condition = fileexists(var.error_html_filepath)
```

#### [Filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)


#### Path variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- `path.module` = get the path for the current module
- `path.root` = get the path for the root module

```sh
resource "aws_s3_object" "index_html" {
    bucket = aws_s3_bucket.website_bucket.bucket
    key = "index.html"
    source = var.index_html_filepath
    etag = filemd5("${path.root}/public/index.html")
}
```

<br>

## Resources 
- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Import](https://developer.hashicorp.com/terraform/cli/import)
- [S3 bucket import](registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)
- [Terraform Import](registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#import)
- [Modules](developer.hashicorp.com/terraform/language/modules/develop/structure)
- [Module sources](developer.hashicorp.com/terraform/language/modules/sources)
- [Resource: aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)
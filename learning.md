# Terraform Learning Steps

These are the next practical steps to improve Terraform skill using this Databricks project.

## 1. Add Outputs

Create an `outputs.tf` file and expose useful values such as:

- the Databricks job ID
- the Databricks job URL
- the notebook path

This teaches how to surface important resource attributes after `terraform apply`.

## 2. Make the Schedule Configurable

Move the hard-coded job schedule out of `jobs.tf` and into variables.

Examples:

- `job_timezone`
- `job_cron_expression`

This teaches when to use variables for external configuration.

## 3. Use Locals for Repeated Values

You repeat the same warehouse ID and repo path pattern in multiple places.

Create a `locals.tf` file and define values such as:

- a base repo path
- common naming values

This teaches how to reduce repetition and make Terraform easier to maintain.

## 4. Learn Terraform State Commands

Practice these commands and understand what each does:

- `terraform state list`
- `terraform state show databricks_job.cleaning`
- `terraform state rm ...`
- `terraform import ...`

This teaches how Terraform tracks real infrastructure.

## 5. Add Another Small Resource

Create one more simple Databricks resource in Terraform, such as:

- another notebook
- another scheduled job

This teaches how to extend a Terraform stack without turning it messy.

## 6. Practice Safe Change Workflow

Use this workflow every time:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

This builds the habit of reviewing infrastructure changes before applying them.

## 7. Compare Terraform and Manual UI Changes

Try changing something in the Databricks UI, then run:

```bash
terraform plan
```

Observe how Terraform detects drift.

This teaches one of the most important Terraform concepts: state drift.

## Common Terraform Commands

These are the main commands you should know at this stage.

### `terraform init`

Initializes the Terraform project.

What it does:

- downloads provider plugins
- prepares the working directory
- reads backend configuration

Use it:

- the first time you open a Terraform project
- after changing providers
- after changing backend configuration

### `terraform fmt`

Formats Terraform files.

What it does:

- fixes spacing and indentation
- makes Terraform code easier to read

Use it:

- before `plan`
- before committing code

### `terraform validate`

Checks whether the Terraform configuration is valid.

What it does:

- checks Terraform syntax
- checks internal references
- catches obvious configuration mistakes

Use it:

- after editing `.tf` files
- before `plan`

### `terraform plan`

Shows what Terraform will do before making changes.

What it does:

- compares Terraform code with real infrastructure and state
- shows what will be created, updated, or destroyed

Use it:

- every time before `apply`

### `terraform apply`

Applies the Terraform changes.

What it does:

- creates new resources
- updates existing resources
- deletes resources if needed

Use it:

- after reviewing the output of `terraform plan`

### `terraform destroy`

Removes everything Terraform manages in the current configuration.

What it does:

- destroys managed resources
- updates Terraform state

Use it:

- when you want to tear down an environment
- when practicing full create/destroy lifecycle

### `terraform output`

Shows output values from Terraform.

What it does:

- prints values defined in `outputs.tf`
- helps you quickly find useful resource information

Example:

```bash
terraform output
terraform output cleaning_job_url
```

### `terraform state list`

Lists all resources currently tracked in Terraform state.

What it does:

- shows what Terraform believes it manages

Use it:

- when debugging state problems
- when checking what resources are under Terraform control

### `terraform state show <resource>`

Shows details for one resource in Terraform state.

Example:

```bash
terraform state show databricks_job.cleaning
```

What it does:

- prints stored attributes for a managed resource

### `terraform state rm <resource>`

Removes a resource from Terraform state without deleting it in the real platform.

Example:

```bash
terraform state rm databricks_notebook.sharded_notebook
```

What it does:

- tells Terraform to stop managing a resource
- does not delete the resource from Databricks or another provider

### `terraform import <resource> <id>`

Imports an existing resource into Terraform state.

Example:

```bash
terraform import databricks_notebook.example /Users/me/example
```

What it does:

- brings an existing resource under Terraform management
- connects real infrastructure to a Terraform resource block

### `terraform show`

Displays the current Terraform state or a saved plan in readable form.

What it does:

- shows what Terraform knows about the infrastructure

### `terraform providers`

Shows which providers the project uses.

What it does:

- lists providers required by the configuration

## Recommended Beginner Workflow

Use this sequence most of the time:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

Why this order:

- `fmt` keeps code clean
- `validate` catches obvious config mistakes
- `plan` shows what will happen
- `apply` makes the approved changes

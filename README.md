# terraformDatabricks

This Terraform project creates:

- a Databricks job named `Cleaning`
- a notebook at `/Shared/terraform-notebooks/hello_world`

It uses an existing Databricks SQL warehouse instead of creating a new one. This is useful for Databricks Free Edition, where you may be limited to a single warehouse.

## Required environment variables

Export these variables before running Terraform:

```bash
export TF_VAR_databricks_host="https://your-workspace.cloud.databricks.com"
export TF_VAR_databricks_token="your-databricks-token"
export TF_VAR_warehouse_id="05307b4c85514246"
```

## Terraform workflow

Run:

```bash
terraform init
terraform plan
terraform apply
```

## Job schedule

The `Cleaning` job is configured in Terraform to run automatically every day at `09:00` in the `Europe/Helsinki` time zone.

If you want a different schedule, update the `schedule` block in `jobs.tf`.

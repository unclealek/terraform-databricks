output "cleaning_job_id" {
  description = "Databricks job ID for the Cleaning job"
  value       = databricks_job.cleaning.id
}

output "cleaning_job_url" {
  description = "Databricks job URL for the Cleaning job"
  value       = databricks_job.cleaning.url
}

resource "databricks_job" "cleaning" {
  name = local.cleaning_job_name

  schedule {
    quartz_cron_expression = var.job_cron_expression
    timezone_id            = var.job_timezone
    pause_status           = "UNPAUSED"
  }

  # Task 1 - No dependencies, runs first
  task {
    task_key = "drop_truncate"

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/dropStage.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 2 - Runs after drop_truncate, uses serverless
  task {
    task_key = "Data_Generation_and_Ingest_Append"
    depends_on {
      task_key = "drop_truncate"
    }

    spark_python_task {
      python_file = "${local.repo_base_path}/generate_sparkConvert_Append.py"
    }

    environment_key = local.python_env_key
  }

  # Task 3 - Runs after Data_Generation_and_Ingest_Append
  task {
    task_key = "bronze_transformation"
    depends_on {
      task_key = "Data_Generation_and_Ingest_Append"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/bronze_transformation.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 4 - Runs after bronze_transformation
  task {
    task_key = "cleaned_bronze_view"
    depends_on {
      task_key = "bronze_transformation"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/cleaned_bronze_view.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 5 - Runs after cleaned_bronze_view
  task {
    task_key = "base-rating_enforcement"
    depends_on {
      task_key = "cleaned_bronze_view"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/base_rating.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 6 - Runs after base-rating_enforcement
  task {
    task_key = "deduplicate"
    depends_on {
      task_key = "base-rating_enforcement"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/deduplicate.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 7 - Runs after deduplicate
  task {
    task_key = "updateEmail"
    depends_on {
      task_key = "deduplicate"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/updateEmail1.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 8 - Runs after updateEmail
  task {
    task_key = "NameValidate"
    depends_on {
      task_key = "updateEmail"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/updateName.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 9 - Runs after NameValidate (reject path)
  task {
    task_key = "rejectTable"
    depends_on {
      task_key = "NameValidate"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/reject_table.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 10 - Runs after NameValidate (silver path)
  task {
    task_key = "silverTable"
    depends_on {
      task_key = "NameValidate"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/silverTable.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Task 11 - Runs after silverTable, last task
  task {
    task_key = "regionMapping"
    depends_on {
      task_key = "silverTable"
    }

    sql_task {
      warehouse_id = var.warehouse_id
      file {
        path   = "${local.repo_base_path}/regionMapping.sql"
        source = "WORKSPACE"
      }
    }
  }

  # Serverless environment for Task 2
  environment {
    environment_key = "Data_Generation_and_Ingest_Append_environment"
    spec {
      dependencies        = ["faker"]
      environment_version = "4"
    }
  }

  queue {
    enabled = true
  }
}

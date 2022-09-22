variable "driver" {
  ## set the `NOMAD_VAR_driver` environment variable to override
  type    = string
  default = "raw_exec"
  validation {
    condition     = var.driver == "raw_exec" || var.driver == "exec"
    error_message = "Invalid value for driver; valid values are: raw_exec, exec."
  }
}

job "multiregion-dispatch" {
  datacenters = ["dc1", "dc2", "dc3"]
  type        = "batch"

  multiregion {

    region "east" {
      count       = 1
      datacenters = ["dc1"]
    }

    region "west" {
      count       = 1
      datacenters = ["dc2"]
    }

    region "north" {
      count       = 1
      datacenters = ["dc3"]
    }

  }

  parameterized {
    meta_required = ["customer_email", "customer_name"]
    meta_optional = ["rep_name", "rep_email", "rep_title", "product_name"]
  }

  meta {
    rep_name  = "BabbageCorp"
    rep_email = "hello@mechanicalcomputing.com"
  }

  group "renderer" {
    task "output" {
      driver = var.driver

      config {
        command = "cat"
        args    = ["local/out.txt"]
      }

      template {
        destination = "local/out.txt"

        ## The HCL2 `file` function allows you to split out the template
        ## into its own file. When you issue the `nomad job run` command,
        ## the HCL2 engine inserts the files contents directly in place
        ## before the job is submitted to Nomad.

        data = <<EOT
${file("./templates/email.tmpl")}
EOT
      }
    }
  }
}

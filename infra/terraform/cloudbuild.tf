resource "google_cloudbuild_trigger" "build-golang-branches" {
  project        = "mm-cloudbuild"
  description    = "Build cgrates branch"
  included_files = ["*/**"]
  trigger_template {
    branch_name = ".*"
    repo_name   = "github_masmovil_cgrates"
    dir         = "./"
  }
  filename = "cloudbuild.yaml"
}

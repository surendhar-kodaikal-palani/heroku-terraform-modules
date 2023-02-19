variable "single_app_name" {
  type        = string
  description = "Name of the single app"
  default = ""
}

variable "single_app_region" {
  type        = string
  description = "Heroku region for the app"
  default = "us"
}

variable "single_app_stack" {
  type        = string
  description = "Heroku stack for the app"
  default = "heroku-20"
}

variable "single_app_buildpacks" {
  type        = list(string)
  description = "List of Heroku buildpacks for the app"
  default = []
}

variable "single_app_enable_private_space" {
  type        = bool
  description = "Enable a Heroku private space for the app"
  default = false
}

variable "single_app_space" {
  type        = string
  description = "Heroku private space for the app"
  default = ""
}

variable "single_app_internal_routing" {
  type        = bool
  description = "Enable internal routing for the app in the Heroku private space"
  default = false
}

variable "single_app_acm" {
  type        = bool
  description = "Enable automatic certificate management (ACM) for the app"
  default = false
}

variable "single_app_organization" {
  type        = map(object({
    locked   = bool
    personal = bool
  }))
  description = "Map of Heroku app organizations for the app"
  default = {}
}

variable "single_app_config_vars" {
  type        = map(string)
  description = "Map of Heroku app config vars for the app"
  default = {}
}

variable "single_app_sensitive_config_vars" {
  type        = map(string)
  description = "Map of Heroku app sensitive config vars for the app"
  default = {}
}

############### BUILD ###############
variable "checksum" {
  type        = string
  description = "The SHA256 checksum of the build source. This value is used for validation and should match the SHA256 checksum of the build source."
}

variable "path" {
  type        = string
  description = "The path to the build source directory."
}

variable "repo_url" {
  type        = string
  description = "The URL of the build source repository."
}

variable "version" {
  type        = string
  description = "The version of the build source."
  default = "main"
}

variable "buildpacks" {
  type        = list(string)
  default     = []
  description = "A list of buildpack URLs to be used for building the app."
}

######

variable "buildpack_provided_description" {
  type    = string
  default = null
}

variable "checksum" {
  type = string
}

variable "commit" {
  type    = string
  default = null
}

variable "commit_description" {
  type    = string
  default = null
}

variable "file_path" {
  type    = string
  default = null
}

variable "file_url" {
  type    = string
  default = null
}

variable "process_types" {
  type = map(string)
}

variable "slug_stack" {
  type    = string
  default = null
}

variable "pipeline_name" {
  type        = string
  description = "The name of the Heroku pipeline"
}

variable "owner_type" {
  type        = string
  description = "The type of the pipeline owner. Can be either 'team' or 'user'"
  default     = "team"
}

variable "stage" {
  type        = string
  description = "The pipeline stage to which the Heroku app should be coupled"
}

variable "pipeline_stage" {
  type        = string
  description = "The name of the pipeline stage to which the Heroku app should be coupled"
}

variable "app_release_description" {
  type        = string
  description = "The description of the Heroku app release"
}

variable "fomation_type" {
  type        = string
  description = "The type of the Heroku app formation"
}

variable "fomation_quantity" {
  type        = number
  description = "The number of dynos to run for the Heroku app formation"
  default     = 1
}

variable "formation_size" {
  type        = string
  description = "The size of the dynos to run for the Heroku app formation"
}
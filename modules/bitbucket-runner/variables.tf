variable "tenant_name" {
  description = "The name of the tenant"
  type = string
}

variable "tenant_id" {
  description = "The id of the tenant"
  type = string
}

variable "name" {
  description = "The name of the Helm release"
  type = string
  default = "bitbucket-runner"
}

variable "image" {
  description = "The image to use for the runner"
  type = string
  default = "docker-public.packages.atlassian.com/sox/atlassian/bitbucket-pipelines-runner"
}

variable "docker_image" {
  default = "docker:20.10.7-dind"
  type = string
  description = "The docker image to use for the runners dind sidecar"
}

variable "auth" {
  type = object({
    ACCOUNT_UUID = string
    REPOSITORY_UUID = string
    RUNNER_UUID = string
    OAUTH_CLIENT_ID = string
    OAUTH_CLIENT_SECRET = string
  })
}

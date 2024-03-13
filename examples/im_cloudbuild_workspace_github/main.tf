/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "im_workspace" {
  source = "../../modules/im_cloudbuild_workspace"

  project_id    = var.project_id
  deployment_id = "im-example-github-deployment"

  tf_repo_type           = "GITHUB"
  im_deployment_repo_uri = var.repository_url
  im_deployment_ref      = "test-fix-detect-deployment"
  infra_manager_sa_roles = ["roles/compute.networkAdmin"]
  tf_cloudbuilder        = "hashicorp/terraform:1.2.3"

  // Found in the URL of your Cloud Build GitHub app configuration settings
  // https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen#connecting_a_github_host_programmatically
  github_app_installation_id = "47590865"

  github_personal_access_token = var.im_github_pat
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "2.6.0"
  project_id   = var.project_id
  network_name = "my-example-custom-network"

  subnets = [
    {
      subnet_name   = "example-subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = "example-subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "example-subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}

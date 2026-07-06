# Project Journal

## Project Principles

1. Build in layers.
2. Every artifact must earn its place.
3. Make the smallest possible change.
4. Commit only working states.
5. Understand before automating.

---

# Layer 0 - Project Foundation

**Date:** 2026-07-06

## Goal

Create a clean project foundation for building Cisco Modeling Labs on AWS using Terraform.

## Accomplishments

- Created the GitHub repository.
- Established the initial project structure.
- Created and activated a Python virtual environment.
- Configured Git and pushed the initial repository.
- Verified Terraform installation.
- Verified AWS CLI installation.
- Verified AWS authentication using the `cml_terraform` IAM user.

## Layer 1 - Terraform Foundation

### Goal

Teach Terraform how to identify itself and communicate with AWS.

### Artifacts Earned

#### versions.tf

Purpose:

- Define the required Terraform version.
- Define the AWS provider and provider version.

#### providers.tf

Purpose:

- Configure the AWS provider.
- Specify the deployment region.

#### variables.tf

Purpose:

- Define user-configurable input variables.
- Introduce the concept of reusable configuration.

#### .terraform.lock.hcl

Purpose:

- Lock provider versions for consistent deployments.

Reason it was earned:

- Generated automatically after the first successful `terraform init`.

## Commands Executed

```bash
terraform init
terraform validate
```

## Results

- Terraform initialized successfully.
- AWS provider downloaded successfully.
- Configuration validated successfully.

## Lessons Learned

- Terraform operates on the current working directory.
- `terraform init` downloads providers and prepares the working directory.
- `terraform validate` checks configuration correctness before planning or applying changes.
- Provider versions are recorded in `.terraform.lock.hcl` and should be committed.
- The `.terraform` directory is local cache and should not be committed.

## Questions

- Why do Terraform data sources exist?
- When should `main.tf` be introduced?
- When do outputs become useful?

## Next Layer

Teach Terraform how to query AWS without creating infrastructure.

## If I had to teach this today...

Terraform needs three things before it can do anything:

1. Which version of Terraform the project supports.
2. Which provider it should use.
3. Any input variables needed by that provider.

Until those exist, Terraform doesn't know enough to build infrastructure.
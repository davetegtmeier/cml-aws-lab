# Project Journal

## 2026-07-06

### Goal

Create the project foundation.

### What I accomplished

- Created the GitHub repository.
- Initialized Git.
- Connected the local repository to GitHub.
- Created a Python virtual environment.
- Verified Terraform and AWS CLI are installed.
- Verified AWS authentication with the cml_terraform IAM user.

### What I learned

Terraform does not need AWS credentials defined in the provider block when the AWS CLI is already configured. It automatically uses the configured profile and credentials.

### Questions

- Why does Terraform separate providers from resources?
- When should I create outputs.tf?
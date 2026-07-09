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

---

# Layer 1 - Terraform Foundation

## Why

Terraform cannot create infrastructure until it knows:

- Which Terraform version this project supports.
- Which providers it needs.
- Which inputs are available.

---

## Goal

Initialize Terraform and validate the configuration.

---

## Artifacts

### versions.tf

Terraform needs this file to know which Terraform and provider versions this project supports.

### providers.tf

Terraform needs this file to know which cloud provider to communicate with.

### variables.tf

Terraform needs this file so configuration values can be reused instead of hard-coded.

### .terraform.lock.hcl

Terraform generated this file to ensure everyone uses the same provider versions.

---

## Validation

- `terraform init`
- `terraform validate`

---

## Lessons Learned

- Terraform works from the current directory.
- `terraform init` prepares the project.
- `terraform validate` verifies configuration before planning.
- `.terraform/` is local state and should not be committed.
- `.terraform.lock.hcl` should be committed.

---

## 🎓 If I Had to Teach This Today...

Terraform needs three things before it can do anything:

1. Which version of Terraform the project supports.
2. Which provider it should use.
3. Any input variables needed by that provider.

Until those exist, Terraform doesn't know enough to build infrastructure.

---

## Ready for Next Layer?

Yes.

Terraform now knows what it is.

Next, it needs to learn who it is talking to.

# Layer 2 - Discovery

## Why

Before Terraform can build infrastructure, we need to verify that it can communicate with AWS and discover information about the environment.

This layer introduces the concepts of discovery, API interactions, and Terraform outputs.

---

## Goal

Verify that Terraform can communicate with AWS by reading information through AWS APIs and displaying the returned values.

---

## Artifacts 

### main.tf

Defines Terraform's intent.

Intent can be either:

- Discover existing infrastructure (data sources)
- Declare new infrastructure (resources)

### outputs.tf
Defines what Terraform tells us or returns as a value.

## How are the files connected?

| File           | Question it answers                                 |
| -------------- | --------------------------------------------------- |
| `providers.tf` | **Who am I talking to, and how do I authenticate?** |
| `main.tf`      | **What do I want Terraform to do or discover?**     |
| `outputs.tf`   | **What do I want to see?**                          |
| `variables.tf` | **What should be configurable?**                    |

--- 

## 🎓 If I Had to Teach This Today...
Terraform building is more about defining the intent rather than performing each step individually.

1. `main.tf` defines Terraform's intent.
   - Discovery - Read information from existing infrastructure using data sources.
   - Declaration - Create or manage infrastructure using resources.
2. `outputs.tf` defines the information that I want Terraform to display after completing its work.
3. We use terraform to define the intent of what we want, but Terraform knows the order of operations ("Terraform doesn't need me to tell it the order. It needs me to tell it the relationships.")
4. Permissions are granted to AWS API actions, not to the AWS CLI or Terraform itself.  If it works in the CLI, Terraform can usually perform the same action.
5. The AWS CLI and Terraform don't perform work directly—they make AWS API requests on my behalf.
6. Terraform is a dependency language, not a scripting language.
> I describe the relationships between resources, and Terraform determines the order in which they are created.

When I started this layer, I thought Terraform executed commands. By the end of the layer, I understood that Terraform describes intent and relationships, while the provider performs the AWS API calls.

# Layer 3 - Declaration

## Why

"We didn't come this far just to sightsee—we came to build something."

Before Terraform can build infrastructure, we declare our intent by defining resources.

---

## Goal

Build the foundational infrastructure for a reusable network automation lab.

---

## Artifacts 

### terraform.tfstate

Terraform code describes the desired state.

The state file remembers the current managed state.

    Terraform compares:
    
    Desired State (.tf files)
    
    ↓
    
    Terraform State (terraform.tfstate)
    
    ↓
    
    Actual Infrastructure (AWS)
    
    ↓
    
    Determine the minimum changes required

to determine what changes are required.

### design.md

Captures the design as we go forward with the project.

--- 

## Updates

### main.tf

```
resource "aws_vpc" "lab" {
  cidr_block           = "10.224.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "network-lab"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}
```

--- 

## Commands

| Command              | Question it answers                            |
| -------------------- | ---------------------------------------------- |
| `terraform validate` | **Is my configuration internally consistent?** |
| `terraform plan`     | **What is Terraform going to do?**             |
| `terraform apply`    | **Go do it.**                                  |
| `terraform destroy`  | **Remove everything Terraform created.**       |

--- 

## 🎓 If I Had to Teach This Today...
Terraform is a language for describing infrastructure intent. Once I describe the desired state, Terraform determines the steps necessary to reconcile the infrastructure with that intent.

1. **Terraform is declarative** - Terraform does not execute a list of commands.  It compares the desired configuration with the current infrastructure and determines the minimum changes required to make them match.
2. **Relationships are everything** - Terraform builds a dependency graph from references.  Because of those relationships:
   - Terraform determines execution order.
   - Terraform knows when resources depend on one another.
   - Removing a referenced object requires updating everything that depends on it.
3. **Data discovers. Resources declare.**

   | Purpose                                  | Syntax                    |
   | ---------------------------------------- | ------------------------- |
   | Discover existing infrastructure         | `data.aws_vpc.current.id` |
   | Declare infrastructure Terraform manages | `aws_vpc.lab.id`          |

4. **Terraform manages lifecycle.**
    Desired State
    
    ↓
    
    Terraform State
    
    ↓
    
    Actual Infrastructure
    
    ↓
    
    Compare
    
    ↓
    
    Plan
    
    ↓
    
    Apply

   - If all three agree: No changes
   - If they differ, Terraform calculates the smallest set of changes required to reconcile them.

## 💡 Biggest Insight Today

- Terraform is not the goal.
- Terraform is another engineering tool.
- The concepts I'm learning—intent, relationships, desired state, and lifecycle management—apply far beyond AWS.
- They apply to any system I may build in the future.

I stopped thinking about Terraform as "creating infrastructure" and started thinking about it as "describing intent."

- Terraform is another engineering tool in my toolbox.
- The goal is not to become a Terraform expert.
- The goal is to understand the concepts well enough that I can apply them to any engineering problem.

## Engineering Workflow

## Engineering Workflow

When developing Terraform projects, follow the same disciplined workflow you would use for a production network change.

Before committing code:

- Format the Terraform configuration.
- Validate the configuration.
- Review the execution plan.
- Verify the Git changes.
- Commit and push.

```bash
terraform fmt
terraform validate
terraform plan
git status
git add .
git commit -m "<message>"
git push
```

> **Goal:** Every commit should contain Terraform code that is formatted, valid, and reviewed before it is committed.
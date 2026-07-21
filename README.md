# CML AWS Lab

Build and manage a Cisco Modeling Labs (CML) environment in AWS using Terraform while learning cloud infrastructure from first principles.

This repository intentionally favors understanding over speed. Every layer is built only after understanding the engineering problem it solves.

## Project Goals

This repository began as a way to deploy Cisco Modeling Labs in AWS so that I could spin up a lab environment when needed and destroy it when I was finished to minimize cloud costs.

As the project evolved, it became much more than a CML deployment. It is now my hands-on learning journey through AWS infrastructure, Infrastructure as Code (Terraform), and eventually network automation.

The long-term goal is to use this environment as the foundation for larger automation projects, including ForgeSpan and network configuration automation.

---

## Learning Philosophy

This repository is not intended to be the fastest way to deploy Cisco Modeling Labs.

Rather than following tutorials that focus on syntax, this project is organized around understanding **why** each AWS component exists and how the infrastructure fits together.

Every layer answers a specific engineering question.

| Layer | Engineering Question |
|--------|----------------------|
| VPC | Where does my network live? |
| Subnet | Where do my devices live? |
| Internet Gateway | How does traffic reach the Internet? |
| Route Table | How are packets forwarded? |
| EC2 | What workload am I running? |
| Security | Who is allowed to communicate? |
| SSH Keys | How is identity established? |

Every file, directory, Terraform resource, and script must answer one question:

> **Have we earned this yet?**

---

## Current Progress

- ✅ Build custom VPC
- ✅ Create public subnet
- ✅ Deploy Internet Gateway
- ✅ Configure Route Table
- ✅ Associate Route Table with Subnet
- ✅ Discover latest Amazon Linux AMI
- ✅ Deploy Amazon Linux EC2 instance
- ✅ Configure Security Group
- ✅ Restrict SSH access to home IP
- ✅ Authenticate using SSH key pair
- ✅ Validate end-to-end connectivity
- ✅ Practice targeted resource destruction

---

## Current Architecture

```text
                 MacBook
                    │
            Private SSH Key
                    │
                    ▼
                 Internet
                    │
                    ▼
           Internet Gateway
                    │
                    ▼
             Public Route Table
                    │
                    ▼
              Public Subnet
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
     Security Group      Linux EC2
                               ▲
                               │
                        AWS Key Pair
```

---

## Roadmap

### Infrastructure

- Build reusable AWS foundation
- Deploy Cisco Modeling Labs
- Add persistent storage
- Reduce operating costs through lifecycle management

### Automation

- Build ForgeSpan network model
- Discover network configurations
- Build Source of Truth
- Generate standardized network configurations
- Introduce Ansible automation
- Explore CI/CD workflows

---

## Repository Structure

```text
terraform/   Infrastructure as Code
docs/        Engineering journal and roadmap
scripts/     Helper scripts and utilities
```

---

## Journal

The `docs` directory contains a daily engineering journal documenting:

- Why each component exists
- Design decisions
- Terraform resources
- AWS relationships
- Lessons learned
- Diagrams
- Commit history

## Beyond This Repository

Once the AWS foundation is complete, this project will become the platform for building ForgeSpan, a fictional enterprise network used to explore discovery, source-of-truth, configuration generation, and network automation.
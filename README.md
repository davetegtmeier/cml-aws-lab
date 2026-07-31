# CML AWS Lab

Build, operate, and destroy a Cisco Modeling Labs (CML) environment in AWS while learning cloud engineering from first principles.

This repository intentionally favors **understanding over speed**. Every resource, script, and abstraction is introduced only after understanding the engineering problem it solves.

---

# Project Goals

This project began with a simple objective:

> Build a Cisco Modeling Labs server in AWS that can be created when needed and destroyed when finished to minimize cloud costs.

As the project evolved, it became something much larger.

Rather than simply deploying CML, this repository documents the complete engineering process of building cloud infrastructure, automating application deployment, and learning Infrastructure as Code one concept at a time.

The end goal is not simply a working CML server.

The end goal is understanding.

---

# Learning Philosophy

There are many tutorials that show **what** to type.

This repository attempts to answer **why**.

Every layer begins with an engineering problem rather than a Terraform feature.

Questions such as:

- Where does my network live?
- How does traffic reach the Internet?
- What makes infrastructure persistent?
- How does software install itself after an EC2 instance boots?
- How should cloud infrastructure be destroyed safely?

Only after understanding the problem do we implement the solution.

One guiding principle has emerged throughout the project:

> **Have I earned this yet?**

Variables...

Modules...

Locals...

Reusable abstractions...

They are introduced only after repetition demonstrates why they are useful.

---

# Engineering Roadmap

| Layer | Engineering Problem |
|--------|---------------------|
| 1 | Where does my network live? |
| 2 | Where do my devices live? |
| 3 | How does traffic reach the Internet? |
| 4 | How are packets forwarded? |
| 5 | What workload am I running? |
| 6 | Who is allowed to communicate? |
| 7 | How is identity established? |
| 8 | How do I preserve data beyond the life of an EC2 instance? |
| 9 | How do I automate infrastructure creation with Terraform? |
| 10 | How do I automatically install Cisco Modeling Labs? |
| 11 | How do I transform a blank Ubuntu server into a working CML controller? |
| 12 | How do I safely destroy and rebuild cloud infrastructure? |
| 13 | How do I improve code without changing its behavior? |
| 14 | How do I make Terraform configurable? |
| 15 | When is a Terraform module actually worth creating? |
| 16 | How can this lab evolve without requiring a redesign? |

---

# Current Progress

## Infrastructure

- ✅ Custom VPC
- ✅ Public Subnet
- ✅ Internet Gateway
- ✅ Route Table
- ✅ Route Table Association
- ✅ Security Groups
- ✅ SSH Key Management
- ✅ IAM Roles
- ✅ Amazon S3 Artifact Repository
- ✅ Ubuntu EC2 Controller
- ✅ Nested Virtualization
- ✅ Persistent Storage Design

## Cisco Modeling Labs

- ✅ Installation workflow designed
- ✅ User Data bootstrap process
- ✅ Automated installation script
- ✅ Network configuration
- ✅ Initial configuration generation

## Remaining Work

- ⏳ First deployment
- ⏳ Reference platform installation
- ⏳ Smart Licensing
- ⏳ Lifecycle management
- ⏳ Refactoring
- ⏳ Variables
- ⏳ Modules

---

# Repository Structure

```text
terraform/
    Infrastructure as Code

scripts/
    Installation and helper scripts

templates/
    cloud-init templates

docs/
    Engineering journal
    Roadmap
    Architecture diagrams
```

---

# Engineering Journal

The `docs` directory is the heart of this project.

Rather than documenting only the finished solution, it documents the learning process.

Each layer records:

- Why the problem exists
- Design decisions
- Terraform resources
- AWS relationships
- Linux concepts
- Diagrams
- Lessons learned
- Refactoring opportunities

The goal is to tell the story from:

> "Once upon a time, I couldn't spell Terraform or AWS..."

to

> "...I built a complete cloud lab that I understand from top to bottom."

---

# Design Principles

Throughout this project I try to follow a few simple principles.

- Build first.
- Understand second.
- Refactor third.
- Generalize last.

Infrastructure should be temporary.

Data should be intentional.

Abstractions are earned—not assumed.

---

# Version 1

Version 1 is intentionally not perfect.

It favors readability over elegance and understanding over optimization.

Duplicate code will remain until there is enough repetition to justify refactoring.

The history of the repository is part of the project.

It documents not only what was built, but how I learned to build it.

Future versions will introduce:

- Locals
- Variables
- Modules
- Refactoring
- CI/CD

only after Version 1 is complete.
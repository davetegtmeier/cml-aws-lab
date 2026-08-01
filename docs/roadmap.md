# Terraform & Infrastructure Engineering Roadmap

> **Project Goal**
>
> Build a complete cloud-based network engineering lab while learning the engineering principles behind AWS, Terraform, Python, and network automation.
>
> The objective is **not** to memorize Terraform syntax.
>
> The objective is to learn how to design, build, discover, and automate infrastructure.

---

# Guiding Principles

Throughout this project we will follow a few simple rules.

- Learn the **engineering problem** before the implementation.
- Understand the **relationships** before writing Terraform.
- Memorize **concepts**, not syntax.
- Use the documentation as a reference, not something to memorize.
- Build one layer at a time.
- Refactor only after we've earned it.

---

# Completed Layers

- [x] Layer 1 - Foundation
- [x] Layer 2 - Discovery
- [x] Layer 3 - Declaration
- [x] Layer 4 - Connectivity
- [x] Layer 5 - Compute
- [x] Layer 6 - Security
- [x] Layer 7 – Platform Requirements
- [x] Layer 8 - Identity
- [x] Layer 9 – Persistent State
- [x] Layer 10 – Cisco Modeling Labs Installation
- [x] Layer 11 – Preparing for First Boot

---

# Upcoming Layers

---

# Layer 12 – First Boot

## Engineering Problem

> **How do I automatically transform a blank Ubuntu server into a working Cisco Modeling Labs controller?**

By this point we have built the AWS infrastructure.

Now we need to prove that our automation actually works.

### Goals

- Launch the EC2 instance.
- Observe cloud-init during first boot.
- Troubleshoot installation issues.
- Verify CML services.
- Verify reference platform installation.
- Register the Smart License manually.
- Successfully log into Cisco Modeling Labs.
- Document the deployment process.

---

# Layer 13 – Infrastructure Lifecycle

## Engineering Problem

> **How do I safely destroy and rebuild my lab without losing important data?**

Cloud infrastructure should be disposable.

The goal is to preserve only what has long-term value while allowing everything else to be recreated from code.

### Goals

- Understand ephemeral vs. persistent infrastructure.
- Preserve artifacts in S3.
- Gracefully deregister the Smart License.
- Destroy and recreate the lab.
- Verify a complete rebuild from Terraform.
- Minimize AWS costs by destroying the lab when not in use.
- Understand Terraform state after create and destroy.

> Infrastructure should be temporary.
>
> Data should be intentional.

---

# Layer 14 – Refactoring

## Engineering Problem

> **How do I improve my code without changing what it does?**

Now that the lab works, improve readability and reduce duplication while preserving the existing behavior.

### Topics

- Local values
- Common tags
- Common naming
- Reduce duplication
- Improve comments
- Organize files
- Standardize variables
- Improve readability

> Make it work first.
>
> Then make it cleaner.

---

# Layer 15 – Configuration

## Engineering Problem

> **How do I separate configuration from implementation?**

Only after understanding the infrastructure should we introduce configuration.

### Topics

- Variables
- tfvars
- Outputs
- Input validation
- Environment-specific values
- Dynamic values

> Configuration is not abstraction.
>
> It simply allows the same design to be reused with different values.

---

# Layer 16 – Terraform Modules

## Engineering Problem

> **When is a module actually worth creating?**

Modules should remove duplication—not hide understanding.

By this point we have enough repeated patterns to justify creating reusable building blocks.

### Topics

- Module design
- Inputs and outputs
- Reusable networking
- Reusable EC2 deployment
- Shared conventions
- Versioning
- Module boundaries

> Modules are earned after repetition becomes obvious.

---

# Layer 17 – Future Enhancements

## Engineering Problem

> **How can this lab evolve without requiring a redesign?**

The core lab is complete.

Now we can begin expanding it based on real needs rather than anticipated ones.

### Possible Enhancements

- EVE-NG deployment
- Shared image repository
- Elastic IP
- Route 53 DNS
- VPN access
- Multiple AWS regions
- Multiple lab environments
- CI/CD deployment
- GitHub Actions
- Automated backups
- Monitoring and alerting
- Cost reporting
- GitHub Actions
- CI/CD deployment
- Automated testing

> Solve today's problems today.
>
> Tomorrow's problems will reveal themselves when they're ready.

# Layer 18 – Python Integration

## Engineering Problem

> How does Python complement Terraform?

### Topics

- Calling Terraform from Python
- Reading Terraform outputs
- Using boto3
- Generating configuration
- Automating operational tasks

---

# Parallel Project – Documentation

## journal.md

The journal captures:

- Why we built something
- What we built
- Relationships discovered
- Biggest insight
- If I had to teach this today

This is written for **Future David**.

---

# Parallel Project – Legacy Lab

Rather than immediately deleting the original AWS/CML lab:

- Discover it
- Understand it
- Repair it if worthwhile
- Compare it to the Terraform-built lab
- Then retire it

---

# Engineering Philosophy

Every lesson begins with the same questions.

1. What engineering problem are we solving?
2. What relationships exist?
3. How do we model those relationships?
4. Where does the documentation explain the implementation?
5. How do we validate that our design matches reality?

Only then do we write Terraform.

---

# Vision

By the end of this project I want to be able to:

- Design AWS infrastructure intentionally.
- Build and destroy environments reproducibly.
- Deploy Cisco Modeling Labs in AWS.
- Understand and use Terraform confidently.
- Build ForgeSpan as a discovery-first network engineering platform.
- Apply these principles to any infrastructure platform in the future.

> **Terraform is not the goal.**
>
> **Understanding infrastructure is the goal. Terraform is one of the tools used to describe it.**
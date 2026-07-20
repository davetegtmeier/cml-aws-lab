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
- [x] Layer 5 - Compute (In Progress)

---

# Upcoming Layers

---

# Layer 6 – Security

## Engineering Problem

> **How do I safely allow access to my server?**

Now that the server exists, we need to decide who is allowed to communicate with it.

### Concepts

- Security Groups
- Inbound Rules
- Outbound Rules
- Stateful Firewalls
- SSH
- ICMP

### Relationships

```
VPC
│
├── Security Group
│
└── EC2
      │
      └── Uses Security Group
```

---

# Layer 7 – Identity

## Engineering Problem

> **How does my server authenticate without storing credentials?**

### Concepts

- IAM
- Roles
- Instance Profiles
- Temporary Credentials

### Goal

Understand why EC2 instances assume an IAM role instead of storing AWS keys.

---

# Layer 8 – Persistent Storage

## Engineering Problem

> **How should my infrastructure persist data?**

### Concepts

- S3
- Object Storage
- IAM Permissions
- CML Images

### Desired Architecture

```
Terraform

↓

EC2

↓

IAM Role

↓

S3 Bucket

↓

CML Images
```

---

# Layer 9 – Cisco Modeling Labs

## Engineering Problem

> **How do I create a reproducible network lab?**

By this point we should already understand:

- Networking
- Compute
- Security
- Identity
- Storage

CML simply becomes another application running on EC2.

### Goals

- Deploy CML
- Preserve images
- Destroy and recreate the environment at will

---

# Layer 10 – Terraform Engineering

## Engineering Problem

> **How do I make my Terraform reusable?**

### Topics

- Variables
- Locals
- Outputs
- Modules
- Remote State
- Workspaces
- Tag Reuse
- Refactoring

> Modules are earned after we've built enough infrastructure to recognize repetition.

---

# Layer 11 – ForgeSpan

## Engineering Problem

> **How do I understand a network before I automate it?**

ForgeSpan begins with discovery—not configuration generation.

## Phase 1 – Discovery

```
Running Configurations

↓

Parser

↓

Relationships

↓

Source of Truth
```

Example:

```
configs/

ALLEGHENY-CORE-01.txt

ALLEGHENY-BORDER-01.txt

HARPER-BORDER-01.txt
```

---

## Phase 2 – Validation

```
Expected

↓

Actual

↓

Report
```

Examples:

- Which Route Maps reference this Prefix List?
- Which Prefix Lists are orphaned?
- Which Route Maps reference nonexistent objects?
- Which interface descriptions violate standards?

---

## Phase 3 – Generation

```
Source of Truth

↓

Jinja2

↓

Configuration
```

Automation becomes the final step—not the first.

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
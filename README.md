# Cisco CML Deployment for AWS

> **Current Layer:** Layer 3 – Networking

## Overview

This repository is a learning project that documents the incremental design and deployment of Cisco Modeling Labs on AWS using Terraform. Rather than starting from a complete template, the project grows organically, introducing each artifact only when it solves a real problem.

## Why This Repository Exists

This repository is not intended to be the fastest way to deploy Cisco Modeling Labs.

It is intended to be the best way for me to learn Terraform, AWS, and Infrastructure as Code by building one layer at a time.

Every artifact is intentionally introduced only when it solves a real problem.

The goal is not only to build a working environment, but to understand why every file, directory, and Terraform resource exists.

## Design Philosophy

This repository is intentionally built one layer at a time.

Every file, directory, Terraform resource, and script must answer one question:

> **Have we earned this yet?**

Artifacts are introduced only when they solve a real problem. The objective is not only to build a working Cisco Modeling Labs deployment, but to understand why each component exists.

## Current Status

Current Layer: **Layer 1 – Terraform Foundation**

Completed

- Terraform initialized
- AWS provider configured
- Configuration validated

Next Objective

Teach Terraform how to query AWS without creating infrastructure.

## Learning Roadmap

### Layer 0 - Project Foundation
- [x] Repository created
- [x] Git configured
- [x] Python virtual environment
- [x] Terraform installed
- [x] AWS CLI configured

### Layer 1 - Terraform Foundation
- [x] Initialize Terraform
- [x] Configure AWS provider
- [x] Validate configuration

### Layer 2 - AWS Identity
- [x] Query current AWS account
- [x] Introduce data sources

### Layer 3 - Networking
- [ ] Define subnet
- [ ] Design VPC

### Layer 4 - First Resource
- [ ] Deploy EC2 instance
- [ ] Destroy EC2 instance



## Repository Evolution

| Layer | Objective | Status |
|--------|-----------|--------|
| 0 | Project Foundation | ✅ |
| 1 | Terraform Foundation | ✅ |
| 2 | AWS Identity | ✅ |
| 3 | Networking | 🚧 |
| 4 | First EC2 Instance | ⏳ |
| 5 | Cisco Modeling Labs | ⏳ |
| 6 | Automation | ⏳ |

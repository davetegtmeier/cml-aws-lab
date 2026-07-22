# Project Journal

## Project Principles

1. Build in layers.
2. Every artifact must earn its place.
3. Make the smallest possible change.
4. Commit only working states.
5. Understand before automating.

---

# Layer 0 - Project Foundation

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

---

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

---

# Layer 3 - Declaration

## Why

> "We didn't come this far just to sightsee—we came to build something."

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

---

# Layer 4 - Connectivity

## Why

> "Let's make sure it is reachable"

We need to make our VPC reachable to the outside world, so we will be able to connect to whatever is in there.

---

## Goal

Complete the foundational network by creating the resources and relationships that allow workloads inside the VPC to communicate with the Internet.

---

## Artifacts 

No new Terraform artifacts were introduced.

This layer reinforced that Terraform projects grow by extending existing files with additional resources and relationships rather than creating new files for every feature.

--- 

## Updates

### main.tf

```
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.224.1.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name        = "network-lab-public-subnet"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name        = "network-lab-public-igw"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  tags = {
    Name        = "network-lab-public-rt"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

--- 

## 🎓 If I Had to Teach This Today...
Today was a reinforcement of the lessions from yesterday, we create the subnet, internet gateway, route table and accosiated it to the subnet.  

```
VPC
│
├── Internet Gateway
│
├── Public Route Table
│      │
│      └── 0.0.0.0/0 → Internet Gateway
│
├── Public Subnet
│      │
│      └── Associated with Public Route Table
│
└── EC2 (future)
       │
       └── Lives in Public Subnet
```

- Use data when Terraform is reading infrastructure it does not manage. Use resource when Terraform creates and manages the infrastructure. Relationships are built by referencing those resources.

  | Who owns it?          | Terraform Reference       |
  | --------------------- | ------------------------- |
  | Terraform             | `aws_vpc.lab.id`          |
  | Already exists in AWS | `data.aws_vpc.current.id` |


- I would also say that as an engineer you should define how you want things to look rather than letting Terraform decide. 
- Tag things. Don't tag relationships.  We put tags on the subnet, route table, internet gateway, but did not tag the route_table_association since that was a relationship but not a thing.

---

## 💡 Biggest Insight Today

Infrastructure is made up of two things:

- Objects (VPCs, Subnets, Route Tables, Internet Gateways)
- Relationships (Associations and References)

Terraform isn't just creating objects—it is describing how those objects relate to one another.

Once the relationships are defined, Terraform automatically determines the order of operations.

I stopped seeing AWS as a collection of icons in the console and started seeing it as a connected network that I designed.

---

# Layer 5 - Compute

---

## Why

> "I have a network. How do I place a computer on it?"

Now that our network infrastructure exists, we need to place a server into that network. An EC2 instance is simply a computer that lives inside our VPC.

---

## Goal

Build an Amazon Linux EC2 instance and place it into our public subnet.

> Note: This lesson focuses on compute and placement. Security Groups and access control will be added in the next layer.

---

## Artifacts 

### Amazon Machine Image (AMI)

Before an EC2 instance can be created, we must determine which operating system image it should boot from.

Rather than hardcoding an AMI ID, we discover the latest Amazon-owned Amazon Linux 2023 image using a Terraform data source.

We requested:

- The most recent image
- Published by Amazon
- From the Amazon Linux 2023 family
- Using the Hardware Virtual Machine (HVM) virtualization type

Terraform then uses the returned AMI ID when creating the EC2 instance.

### EC2 Instance

For this lab we selected:

- Instance type: t3.small
- Public subnet
- Automatically assign a public IPv4 address

Security Groups will be added in the next layer.

--- 

## Updates

### main.tf

```
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "linux" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  # Security group relationship still to be added.
}
```

--- 

## 🎓 If I Had to Teach This Today...
Today reinforced the difference between discovery and declaration.

The EC2 instance is something Terraform will create, but the operating system image already exists. Rather than hardcoding an AMI ID, Terraform discovers the latest Amazon Linux image and then uses its ID when building the server.

The important lesson wasn't memorizing the aws_ami data source.

It was learning how to determine what information is required and then using the documentation to discover it.

Documentation used:

- Terraform Registry - AWS Provider - `aws_instance`
- Terraform Registry - AWS Provider - `aws_ami` data source

---

## 💡 Biggest Insight Today

Today I realized that I don't need to memorize Terraform syntax or every available argument.

Instead, I should understand:

- What engineering problem I'm solving
- What relationships are required
- Which Terraform resource represents that relationship
- Where the documentation lives when I need the implementation details

Terraform isn't asking me to memorize syntax.

It's asking me to describe a system.

---

# Layer 6 – Security

## Why

> "I have a server on the Internet. Who is allowed to talk to it?"

We created an EC2 instance, but by default there is no way to securely connect to it. We need to define a security policy that controls who is allowed to communicate with the server and how we will authenticate.

---

## Goal

Create the security policy that allows secure SSH access to the EC2 instance while denying all unnecessary inbound traffic.

---

## Artifacts

- Security Group
- Ingress Rule
- Egress Rule
- AWS Key Pair
- Targeted Destroy

> Targeted destroy allows us to destroy only the EC2 instance while preserving the network infrastructure we have already built.

---

## Updates

```hcl
resource "aws_instance" "linux" {
  key_name = aws_key_pair.djt.key_name

  vpc_security_group_ids = [
    aws_security_group.linux.id
  ]

  tags = {
    Name        = "network-lab-linux"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "linux" {
  name        = "network-lab-linux"
  description = "Security group for the network lab Linux instance"
  vpc_id      = aws_vpc.lab.id

  tags = {
    Name        = "network-lab-linux-sg"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "linux_ssh" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow SSH from DJT public IP"

  cidr_ipv4 = "my public IP address"
  from_port = 22
  to_port   = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.linux.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound IPv4 traffic"
}

resource "aws_key_pair" "djt" {
  key_name   = "network-lab-djt"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))

  tags = {
    Name        = "network-lab-djt-key"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}
```

---

## 🎓 If I Had to Teach This Today...

Creating an EC2 instance is only part of the solution. We also need to define **who is allowed to communicate with it** and **how they prove their identity**.

The Security Group acts as a firewall attached to the EC2 instance. Individual ingress and egress rules define the traffic that is permitted.

Our security policy is intentionally simple:

- Allow SSH (TCP/22) **only** from my public IP address.
- Allow all outbound IPv4 traffic so the server can reach the Internet for updates and package downloads.

### Network Flow

```text
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
          ┌──────────┴──────────┐
          ▼                     ▼
     Security Group         Linux EC2
          │
          ▼
     SSH from Home
```

### Dependency Graph

```text
                 VPC
                  │
     ┌────────────┴────────────┐
     │                         │
 Public Subnet          Security Group
     │                         │
     │              ┌──────────┴─────────┐
     │              │                    │
     │         SSH Rule           Egress Rule
     │
     └──────────────┐
                    │
                Linux EC2
```

### SSH Trust Relationship

AWS stores the **public key** while the **private key remains on my Mac**.

```text
MacBook
    │
Private SSH Key
    │
SSH
    │
Public Key
    │
AWS Key Pair
    │
Linux EC2
```

Terraform does **not** manage the private key. It simply uploads the public key and associates it with the EC2 instance during creation.

After applying these changes I was able to successfully SSH into the server using:

```bash
ssh ec2-user@<public-ip>
```

---

## Targeted Destroy

A normal destroy removes **every** resource managed by Terraform:

```bash
terraform destroy
```

For this lab I only want to remove the EC2 instance while preserving the VPC and networking infrastructure that we have already built.

To accomplish this I can use a **targeted destroy**:

```bash
terraform plan -destroy -target=aws_instance.linux
terraform destroy -target=aws_instance.linux
```

Terraform provides the following warning when using `-target`:

> **Warning: Resource targeting is in effect**
>
> You are creating a plan with the `-target` option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
>
> The `-target` option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests using it as part of an error message.

### My Takeaway

Targeted destroy is an excellent learning and troubleshooting tool, but it intentionally leaves the deployed infrastructure different from the full Terraform configuration.

After any targeted operation, I should always run:

```bash
terraform plan
```

Terraform will report that the EC2 instance is missing from the deployed infrastructure even though it is still defined in the Terraform configuration.

Running:

```bash
terraform apply
```

will recreate only the Linux instance.

While targeted operations are extremely useful for learning and recovery, they are **not** the normal Terraform workflow. The preferred workflow is to allow Terraform to evaluate the **entire dependency graph** so that the deployed infrastructure always matches the declared configuration.

---

## 💡 Biggest Insight Today

A successful Terraform **plan** does not guarantee the cloud provider will accept every value.

Terraform validates the configuration and builds an execution plan, but AWS is still the final authority. During `terraform apply`, AWS rejected my Security Group rule because the description contained an apostrophe (`'`), even though the Terraform configuration itself was valid.

After correcting the description, Terraform did **not** recreate the resources that had already been created successfully. Instead, it created only the missing Security Group rule.

This reinforced an important lesson:

- `terraform validate` verifies the Terraform configuration.
- `terraform plan` previews the intended changes.
- `terraform apply` is where AWS performs its own service-specific validation.

The provider API is always the final authority.

--- 

# Layer 7 – Platform Requirements

## Why

> "What does Cisco Modeling Labs need from the infrastructure we've built?"

We now understand how to build the AWS infrastructure. The next step is to understand what Cisco Modeling Labs (CML) requires from that infrastructure so we can deploy a working lab environment.

Rather than blindly following Cisco's deployment guide, we want to understand **why** each component exists and what engineering problem it solves.

---

## Goal

```text
CML Version 1 Platform

Instance family: m7i
Instance size:   m7i.2xlarge
vCPU:            8
Memory:          32 GiB
Virtualization:  Nested virtualization enabled
Lifecycle:       Disposable and replaceable through Terraform
```

---

## Artifacts

- Cisco cloud-cml deployment documentation
- AWS Identity and Access Management (IAM)
- S3 bucket (installation media)
- EBS storage (persistent disk)
- EC2 IAM Role
- CML Reference Platform images
- CML installation package

---

## Updates

No Terraform changes were made today.

Instead, the focus shifted from **building infrastructure** to **understanding the platform requirements** needed to deploy Cisco Modeling Labs.

We also decided that the goal is no longer to learn every AWS service in isolation. Instead, we will learn each AWS service as it becomes necessary to complete the CML deployment.

---

## 🎓 If I Had to Teach This Today...

One of the biggest lessons today was that AWS services are not entirely new technologies. They are cloud implementations of infrastructure concepts I have already worked with throughout my career.

| AWS | Traditional Infrastructure |
|------|----------------------------|
| EC2 | Server |
| EBS | Hard drive |
| S3 | Installation media / software repository |
| IAM User | Administrator account |
| IAM Role | Service account |
| Security Group | Stateful firewall |

Thinking in terms of familiar infrastructure made the cloud architecture much easier to understand.

### Installation Media vs Storage

The analogy that clicked best was thinking of S3 as installation media.

```
             S3
              │
Copies installation files
              │
              ▼
          EBS Volume
              │
        CML Installed
              │
              ▼
          CML Runs
```

S3 is used to deliver the software.

EBS is where the software is installed and where CML stores its configuration, labs, and data while running.

---

### Identity

IAM also became much easier to understand once I stopped thinking about policies and started thinking about **identities**.

Instead of asking:

> "What permissions do I need?"

The better question is:

> "Who is trying to do something?"

| Identity | Responsibility |
|----------|----------------|
| David / Terraform | Build AWS infrastructure |
| David / Terraform | Upload CML software |
| David / Terraform | Upload Reference Platform images |
| EC2 | Download CML software |
| EC2 | Download Reference Platform images |
| EC2 | Run CML |
| CML | Store labs and configurations on EBS |

Permissions simply describe what each identity is allowed to do.

---

### Nested Virtualization

One of the more difficult concepts today was nested virtualization.

Cisco Modeling Labs runs virtual routers.

Those routers are virtual machines managed by KVM.

```
AWS EC2
    │
Linux / CML
    │
KVM
    │
IOS-XE Virtual Machines
```

Historically, Cisco required bare-metal AWS instances because AWS only exposed CPU virtualization extensions (Intel VT-x / EPT) on bare-metal hardware.

Today, some AWS Nitro instance families expose those same virtualization extensions without requiring bare metal.

The important requirement is **nested virtualization**, not necessarily a bare-metal instance.

---

## 💡 Biggest Insight Today

Today's biggest realization was that I don't have to become an AWS expert before deploying CML.

I already understand servers, storage, networking, users, permissions, and firewalls.

AWS simply provides cloud implementations of those same infrastructure building blocks.

Rather than learning every AWS service independently, I can continue building the CML platform and learn each new service only when it becomes necessary.

That keeps the project moving while still building a solid understanding of the underlying architecture.

> **Messy and functional beats elegant and abandoned.**

---

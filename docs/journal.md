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

# Layer 8 – Identity

## Why

> "Once my infrastructure exists, how does it prove its identity to AWS?"

Creating an EC2 instance is only part of the deployment. The running server still needs to interact with AWS services such as Amazon S3 and Systems Manager (SSM). Rather than embedding usernames, passwords, or API keys on the server, AWS provides the instance with its own identity.

---

## Goal

Understand how AWS Identity and Access Management (IAM) allows both Terraform and a running EC2 instance to authenticate and perform only the tasks they are authorized to perform.

---

## Artifacts

- IAM User
- IAM Role
- IAM Policies
- Instance Profile
- Principle of Least Privilege
- IAM Trust Relationship

---

## Updates

Discovered the existing IAM configuration created during my original CML deployment.

```
IAM User
--------
cml_terraform

Permissions:
- AmazonEC2FullAccess
- cml-s3-access
- pass-role

Purpose:
Build AWS infrastructure.
```

```
IAM Role
--------
cml_controller

Permissions:
- AmazonSSMManagedInstanceCore
- cml-s3-read

Purpose:
Operate the running CML server.
```

The EC2 instance receives its identity by attaching an Instance Profile, which contains the IAM Role.

---

## 🎓 If I Had to Teach This Today...

When deploying infrastructure there are actually two separate identities involved.

## Identity #1 - Terraform

```
IAM User

cml_terraform
```

This identity represents **me** (or more accurately, Terraform acting on my behalf).

Its responsibility is to build infrastructure.

It requires permissions such as:

- Create EC2 instances
- Create VPCs
- Create Security Groups
- Create IAM Roles
- Upload CML software to Amazon S3
- Attach IAM Roles to EC2 instances (`iam:PassRole`)

Once Terraform finishes creating the infrastructure, this identity is no longer involved.

```
David
   │
   ▼
Terraform
   │
Creates AWS Infrastructure
```

---

## Identity #2 - The EC2 Instance

Once the EC2 instance has been created, Terraform exits.

The server still needs to interact with AWS.

For example, it needs to:

- Download the Cisco Modeling Labs installation files
- Download the Cisco reference platform images
- Use AWS Systems Manager (SSM)

The EC2 instance should **not** continue using my credentials.

Instead, AWS gives the instance its own identity by attaching an IAM Role.

```
EC2 Instance
      │
Instance Profile
      │
IAM Role
      │
Policies
```

In this deployment the EC2 instance assumes the following role:

```
cml_controller
```

---

### Why Two Identities?

The two identities have completely different responsibilities.

| Identity | Purpose |
|----------|---------|
| `cml_terraform` | Build AWS infrastructure |
| `cml_controller` | Operate the running CML server |

Terraform needs permission to create infrastructure.

The running server only needs permission to perform its own job.

This follows the **Principle of Least Privilege**:

> Every identity should have only the permissions required to perform its function.

---

### What About the Instance Profile?

One concept that initially confused me was the Instance Profile.

Terraform does **not** attach an IAM Role directly to an EC2 instance.

Instead, AWS attaches an **Instance Profile**, which contains the IAM Role.

```
EC2 Instance
      │
Instance Profile
      │
IAM Role
      │
Permissions
```

The Instance Profile acts as the bridge between the EC2 instance and its IAM Role.

---

### Trust Relationships

Every IAM Role also contains a **Trust Relationship**.

Rather than defining *what* the role is allowed to do, the Trust Relationship defines **who is allowed to assume the role**.

For the `cml_controller` role:

```
Principal:
    ec2.amazonaws.com

Action:
    sts:AssumeRole
```

This tells AWS:

> Only EC2 instances are allowed to assume this role.

Once assumed, the permissions attached to the role determine what the instance may access.

---

### The Complete Flow

```
                David
                   │
                   ▼
         IAM User (cml_terraform)
                   │
          Creates Infrastructure
                   │
                   ▼
              EC2 Instance
                   │
     Attach Instance Profile
                   │
                   ▼
        IAM Role (cml_controller)
                   │
                   ▼
           Read Objects from S3
                   │
                   ▼
      Install and Run Cisco CML
```

Another way to visualize the relationship:

```
                     David
                cml_terraform
                      │
                      │ Creates AWS infrastructure
                      │ Uploads software
                      │
        +-------------+-------------+
        |                           |
        ▼                           ▼
   EC2 Instance               Amazon S3
        │
        │ "Here is your identity"
        ▼
  Instance Profile
        │
        ▼
     IAM Role
        │
        ▼
   Read Objects from S3
```

---

### Simple Mental Model

```
IAM User  = Builder

IAM Role  = Running Workload
```

Users build infrastructure.

Roles operate infrastructure.

---

## 💡 Biggest Insight Today

Before today, IAM felt like a collection of AWS-specific security objects.

The breakthrough came when I realized they solve the same problem we've always solved in traditional IT.

A physical server should not use my administrator account to access network resources.

Instead, it should have its own identity with only the permissions required to perform its job.

AWS implements the same idea through IAM Roles.

Once Terraform has finished creating the infrastructure, the EC2 instance needs its own identity to access AWS services such as Amazon S3 and Systems Manager (SSM).

Rather than storing usernames, passwords, or API keys on the server, AWS allows the EC2 instance to **assume an IAM Role**, giving it temporary credentials with only the permissions it requires.

The best way for me to think about it is:

> Terraform builds the infrastructure.

> The IAM Role operates the infrastructure.

Understanding *why* two identities exist made the entire IAM model much easier to understand.

# Layer 9 - Persistent State

## Why

> "Infrastructure should be disposable. Data should not be."

The goal is to make the EC2 instance temporary while preserving everything that has long-term value. If I destroy the server tomorrow, I should be able to rebuild it with a single `terraform apply` without losing software, images, or lab definitions.

---

## Goal

- Design persistent storage for the network lab.
- Create an S3 artifact repository managed by Terraform.
- Store CML software and reference platform images outside of the EC2 instance.
- Build the infrastructure required for a future CML controller.
- Better understand how Terraform interacts with AWS IAM.

---

## Artifacts

In main.tf

### CML Controller

Defines the EC2 instance that will host Cisco Modeling Labs. The
instance is configured for nested virtualization and serves as the
foundation for the lab environment.

```
resource "aws_instance" "cml_controller" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "m8i.2xlarge"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  key_name             = aws_key_pair.djt.key_name
  iam_instance_profile = "cml_controller"
  ebs_optimized        = true

  vpc_security_group_ids = [
    aws_security_group.linux.id
  ]

  cpu_options {
    nested_virtualization = "enabled"
  }

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }

  # We still need to supply Cisco's CML installation instructions here.
  # user_data_base64 = ...

  tags = {
    Name        = "network-lab-cml-controller"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}
```

### CML HTTPS Access

```
resource "aws_vpc_security_group_ingress_rule" "cml_controller_https" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow HTTPS from DJT public IP"

  cidr_ipv4   = "96.236.133.102/32"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
```

### S3 Artifact Repository

Defines the persistent storage location for software packages,
reference platform images, and future lab artifacts.

```
resource "aws_s3_bucket" "network_lab_artifacts" {
  bucket = "network-lab-artifacts-058264426456"

  tags = {
    Name        = "network-lab-artifacts"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "network_lab_artifacts" {
  bucket = aws_s3_bucket.network_lab_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "network_lab_artifacts" {
  bucket = aws_s3_bucket.network_lab_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "network_lab_artifacts" {
  bucket = aws_s3_bucket.network_lab_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

### S3 Bucket Planned Layout

```text
s3://network-lab-artifacts-058264426456/

├── cml/
│   ├── software/
│   │   └── 2.9.0/
│   └── refplat/
│       └── 2.9.0/
│
├── eve-ng/
│   ├── software/
│   └── images/
│
├── shared/
│   └── qemu-images/
│
└── terraform-state/
```

### Terraform

Created:

- S3 Bucket
- Versioning
- Server-side Encryption
- Public Access Block

Updated IAM policies to allow Terraform to fully manage the bucket while preserving the original CML bucket configuration.

Built the initial Terraform definition for the CML controller including:

- Ubuntu 24.04
- m8i.2xlarge
- Nested Virtualization
- 100 GB encrypted GP3 volume
- HTTPS access
- IAM Instance Profile

Terraform now validates successfully and produces a clean execution plan.

---

## Updates

```text
✓ Designed persistent storage architecture

✓ Created reusable S3 artifact repository

✓ Uploaded:
  - CML installation package
  - Reference platform images

✓ Enabled:
  - Versioning
  - Server-side encryption
  - Public access blocking

✓ Expanded IAM permissions instead of replacing the original policy

✓ Learned how Terraform continuously reads AWS resources, requiring many GET/List permissions in addition to Create/Delete.

✓ Built a Terraform definition for the future CML controller.

Remaining:

- Build cloud-init bootstrap process
- Install CML automatically
- Download artifacts from S3 during provisioning
```

---

## 🎓 If I Had to Teach This Today...

Terraform isn't simply a deployment tool.

It is constantly comparing the desired infrastructure with the existing infrastructure.

That means Terraform performs many read operations before making changes. Because of this, IAM policies require significantly more permissions than I originally expected. Every time Terraform attempted to inspect a bucket property, AWS required another `GetBucket...` permission.

I also learned that dependencies flow in one direction.

An EC2 instance depends on a Security Group.

A Security Group does **not** depend on an EC2 instance.

Removing the EC2 instance simply leaves the Security Group unused.

Finally, I realized there is value in understanding the architecture before automating it. Cisco's Terraform project is extremely powerful, but I learned much more by rebuilding the infrastructure myself one layer at a time.

---

## 💡 Biggest Insight Today

I originally wanted to "deploy Cisco Modeling Labs."

By the end of the day, I realized my actual goal is much larger.

I want to understand how cloud infrastructure is built—not simply reproduce someone else's Terraform.

Today I intentionally stepped away from Cisco's deployment framework because I hadn't yet earned the abstractions it was using. Rebuilding the environment from first principles made the design significantly easier to understand.

The infrastructure is now in place.

Tomorrow's focus is no longer AWS networking or storage.

Tomorrow is about teaching an EC2 instance how to become a Cisco Modeling Labs server.

---

# Layer 10 – Cisco Modeling Labs Installation

## Why

> "Let's install the software we need."

With the AWS infrastructure complete and persistent storage in place, the next step is to transform a blank Ubuntu EC2 instance into a Cisco Modeling Labs controller.

Rather than blindly following Cisco's deployment framework, the goal of this layer is to understand the installation process well enough to build it ourselves. Cisco's DevNet project will serve as a reference implementation, but every piece we include should solve a problem we understand.

---

## Goal

Build an installation process that automatically provisions Cisco Modeling Labs on a newly created EC2 instance.

Objectives:

- Study Cisco's deployment process and understand each step.
- Build an installation script specific to this project.
- Keep the implementation simple and readable.
- Introduce abstractions only after they have been earned.

Desired installation flow:

1. Install prerequisites.
2. Install the AWS CLI.
3. Download the CML installation package from S3.
4. Extract the package.
5. Install the Debian packages.
6. Generate the CML configuration.
7. Configure networking.
8. Run the initial setup.
9. Clean up temporary files.

> Copy behavior only after understanding why it exists.

---

## Artifacts

### Planned Repository Structure

```text
templates/
    cloud-init.yaml

scripts/
    install-cml.sh
    install-refplats.sh
    configure-license.sh
```

### Installation Flow

```text
Terraform
        │
        ▼
AWS creates EC2
        │
        ▼
Ubuntu boots
        │
        ▼
cloud-init executes user_data
        │
        ▼
install-cml.sh
        │
        ├── Install prerequisites
        ├── Install AWS CLI
        ├── Download CML package
        ├── Extract package
        ├── Install Debian packages
        ├── Generate virl2-base-config.yml
        ├── Run interface_fix.py
        ├── Run CML initial setup
        └── Clean up
```

---

## What I Learned

### Cisco's Deployment Framework

Cisco's installer is built around cloud-init.

```
cloud-config.txt
        │
        ├── Writes files into /provision/
        │
        ├── cml.sh
        ├── common.sh
        ├── vars.sh
        ├── license.py
        ├── interface_fix.py
        └── ...
        │
        ▼
Executes /provision/cml.sh
```

Rather than reproducing Cisco's framework, I identified the pieces that solved real problems for my environment.

---

### Understanding copyfile()

`copyfile()` is simply a wrapper around the cloud storage copy operation.

For AWS it ultimately executes:

```bash
aws s3 cp ...
```

The function copies either individual files or directories from S3 into the EC2 instance.

For this project I chose to eliminate the abstraction and call the AWS CLI directly since this deployment only targets AWS.

---

### Linux Concepts

New Linux concepts learned during this layer:

- `set -e` immediately stops a shell script if any command fails.
- `/tmp` is a standard Linux temporary directory and already exists.
- `mkdir -p` safely creates directories only when needed.
- `tar` extracts an archive.
- `apt-get update` refreshes Ubuntu's package catalog.
- `apt-get install` installs packages from repositories or local `.deb` files.
- `.deb` packages are Ubuntu's native installation packages.

---

### User Data

One of the biggest concepts I learned was EC2 User Data.

Terraform does **not** log into Ubuntu and execute commands.

Instead, Terraform tells AWS:

> "Create this virtual machine. When it boots for the first time, hand it this script."

Ubuntu's cloud-init service executes that script automatically during first boot.

```text
terraform apply
        │
        ▼
AWS API creates EC2
        │
        ▼
Ubuntu boots
        │
        ▼
cloud-init starts
        │
        ▼
cloud-init executes user_data
        │
        ▼
install-cml.sh
        │
        ▼
Server becomes a CML controller
```

This also explained the Terraform configuration:

```hcl
user_data = file("${path.module}/scripts/install-cml.sh")
```

Terraform reads the shell script from disk and sends it to AWS as the instance's User Data.

Because the script is plain text, `user_data` is sufficient.

`user_data_base64` is only necessary when supplying already encoded content, as Cisco's deployment does.

---

### cloud-init

Ubuntu automatically executes User Data as the root user.

That means installation commands such as:

```bash
apt-get install
mkdir -p /provision
```

do not require `sudo`.

When troubleshooting, the primary log is:

```text
/var/log/cloud-init-output.log
```

Useful commands:

```bash
sudo tail -f /var/log/cloud-init-output.log

cloud-init status

cloud-init status --wait
```

---

### Terraform Behavior

Terraform identifies resources by their **resource address**, not by their attributes.

Renaming a resource causes Terraform to destroy the existing resource and create a new one even if the resulting infrastructure is functionally identical.

Watching Terraform correctly predict the destruction of the original security group rule and creation of four new rules (Home SSH, Camp SSH, Home HTTPS, Camp HTTPS) reinforced how Terraform compares configuration to state rather than simply modifying resources.

---

### Installation Phases

At this point the project naturally separates into phases.

```text
Phase 1 - Infrastructure      ✅

Terraform
VPC
Subnet
Internet Gateway
Route Table
Security Group
IAM
S3
EC2

Phase 2 - Operating System    ✅

Ubuntu
cloud-init
AWS CLI
NetworkManager
Docker Repository

Phase 3 - CML Installation    ✅

Download package
Extract package
Install packages
Generate configuration
interface_fix.py
Initial setup

Phase 4 - Lab Content         ⏳

Reference platforms
Images
Import

Phase 5 - Licensing           ⏳

Register Smart License

Phase 6 - Lifecycle           ⏳

Graceful shutdown
Deregister
terraform destroy
```

---

## 🎓 If I Had to Teach This Today...

Terraform creates infrastructure.

Cloud-init configures the operating system.

My installation script installs and configures Cisco Modeling Labs.

Each layer has a different responsibility.

The biggest lesson from this layer was understanding how those responsibilities fit together to automatically transform a blank Ubuntu server into an application server.

---

## 💡 Biggest Insight Today

This project stopped being about Terraform.

Terraform simply creates the infrastructure.

The real work happens after the operating system boots.

Cloud-init, shell scripting, Linux package management, networking, and application configuration all work together to complete the deployment.

Understanding those layers—and the responsibility of each one—is far more valuable than simply getting a server running.
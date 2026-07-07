## Network Design Decisions

### VPC

CIDR: 10.2224.0.0/16

Why?

Avoid overlap with existing home and lab networks while leaving plenty of room for future expansion.

### Public Subnet

CIDR: 10.224.1.0/24

Why?

Host the CML EC2 instance during the learning phase.

Future phases may introduce private subnets and NAT gateways, but they are intentionally out of scope for the initial build.

10.224.0.0/16

├── 10.224.1.0/24   Public Servers
├── 10.224.2.0/24   Future Private Servers
├── 10.224.3.0/24   Future Management
└── Remaining space reserved
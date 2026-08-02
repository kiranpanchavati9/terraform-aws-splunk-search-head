# terraform-aws-splunk-search-head

Terraform configuration for deploying Splunk Enterprise search heads on AWS behind an Application Load Balancer.

## Architecture

```
                        Internet
                            │
                  ┌─────────▼─────────┐
                  │  Application LB   │  :80 → target group :8000
                  │  sticky sessions  │  idle timeout 600s
                  └─────────┬─────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼────┐         ┌────▼────┐         ┌────▼────┐
   │  SH-1   │         │  SH-2   │         │  SH-3   │   Auto Scaling Group
   │us-east-1a│        │us-east-1b│        │us-east-1c│  min = max = desired = 3
   └─────────┘         └─────────┘         └─────────┘
   Splunk Web :8000, dedicated EBS volume mounted at /opt/splunk
```

## Modules

| Module | Purpose |
|---|---|
| `modules/Launch-Template` | AMI, instance type, IMDSv2, root and Splunk data volumes, user data |
| `modules/Auto-Scaling-Group` | Fixed-size group across three AZs, maintenance policy, termination lifecycle hook |
| `modules/Application-Load-Balancer` | Internet-facing ALB, target group, health checks, session stickiness |
| `modules/Security` | Reusable security group module — CIDR, security-group, and self-referencing rules |
| `modules/IAM` | Instance role and profile with Systems Manager access |

Root configuration wires the modules together. Module outputs feed the next module's inputs, which establishes creation order: IAM and security groups first, then the launch template, then the ASG and ALB.

## Layout

```
.
├── main.tf                     # module composition
├── variables.tf                # root variable declarations
├── outputs.tf                  # ALB DNS name
├── terraform.tfvars            # environment values
├── splunk-search-head.sh       # user data: install and start Splunk
└── modules/
    ├── Launch-Template/
    ├── Auto-Scaling-Group/
    ├── Application-Load-Balancer/
    ├── Security/
    └── IAM/
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

The ALB DNS name is returned as an output:

```bash
terraform output alb_dns_name
```

## Configuration

Set in `terraform.tfvars`:

| Variable | Description |
|---|---|
| `image_id` | Base AMI for the search heads |
| `instance_type` | Instance size — search heads are CPU-bound |
| `key_name` | EC2 key pair |
| `vpc_id` | Target VPC |
| `vpc_zone_identifier` | Three subnets, one per availability zone |
| `desired_capacity` | Cluster size — must be odd |
| `root_volume_size` | Root volume in GB |
| `splunk_volume_size` | Dedicated Splunk data volume in GB |
| `allowed_cidrs` | CIDRs permitted to reach the ALB |
| `admin_cidrs` | CIDRs permitted SSH and management access |
| `health_check_type` | `EC2` or `ELB` |

## Design notes

**The Auto Scaling Group is fixed-size, not elastic.** Search head cluster members require explicit captain bootstrapping and must leave the cluster gracefully. `min_size`, `max_size`, and `desired_capacity` are set to the same odd number — three, five, or seven — so the group self-heals without attempting to scale on demand.

**Availability zone placement is owned by the ASG.** Subnets are passed via `vpc_zone_identifier`; the launch template contains no placement configuration. A launch template `placement` block would override the group's zone distribution and concentrate every member in a single AZ.

**Session affinity is required.** Splunk Web maintains server-side session state. Without `lb_cookie` stickiness on the target group, requests distribute across members and users are logged out mid-search.

**The load balancer idle timeout is raised to 600 seconds.** The 60-second default terminates long-running searches and report generation.

**Health checks target the login endpoint.** `/en-US/account/login` returns 200 without authentication. The management port, 8089, requires credentials and is unsuitable for health checking.

**Splunk has a dedicated EBS volume.** The base AMI uses LVM with a small root logical volume, so additional root capacity is not available to the filesystem. A separate volume is attached, discovered by block-device probe in user data, formatted, and mounted at `/opt/splunk`.

**A termination lifecycle hook is configured.** It reserves a window for a departing member to run `splunk offline` so the captain can hand off cleanly. Automation for that step is not yet in place.

## Ports

| Port | Service | Exposed via ALB |
|---|---|---|
| 8000 | Splunk Web | Yes |
| 8089 | splunkd management / REST | No |
| 8191 | KV Store | No — cluster members only |
| 9887 | Cluster replication | No — cluster members only |

## Prerequisites

- Terraform >= 1.5, AWS provider >= 5.0
- A VPC with subnets in at least three availability zones
- An EC2 key pair
- Splunk Enterprise licence

## Roadmap

- Remote state on S3 with DynamoDB locking
- Admin password sourced from SSM Parameter Store rather than user data
- HTTPS listener with an ACM certificate
- Search head cluster bootstrap: captain election and deployer integration
- ALB access logging

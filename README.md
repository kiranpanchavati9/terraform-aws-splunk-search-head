# Splunk Search Head Infrastructure

Terraform project to set up an AWS Application Load Balancer (ALB), Launch Template, and Auto Scaling Group (ASG) for Splunk Search Heads.

## Features
* **Application Load Balancer (ALB):** Listens on HTTPS (443) and forwards to Splunk Web UI (8000) with sticky sessions enabled.
* **Auto Scaling Group (ASG):** Manages Splunk Search Head instances across private subnets.
* **Launch Template:** Standardized EC2 setup running Splunk bootstrapping scripts.
* **Security Groups:** Enforces strict port-level security between ALB and EC2 instances.

---

##  Repository Structure

```text
├── README.md
├── main.tf                 # Root Terraform orchestrator
├── variables.tf            # Input variables
├── outputs.tf              # ALB DNS name & ASG details
├── terraform.tfvars.example# Variables template
│
├── modules/
│   ├── alb/                # ALB, Target Group (8000), Listener (443)
│   ├── asg/                # Launch Template & ASG configuration
│   └── security/           # Security Groups (ALB & EC2)
│
└── scripts/
    └── user_data.sh        # Splunk EC2 bootstrap script

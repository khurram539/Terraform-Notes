# AWS Cross-Account VPC Peering with DNS Resolution (Terraform)

## 📌 Overview

This guide documents the step-by-step process to establish a **cross-account VPC peering connection** between two AWS accounts using Terraform, including:

* VPC Peering (Requester + Accepter)
* Route Table Configuration
* Security Group Updates
* DNS Resolution Across VPCs
* Route 53 Considerations (optional)

---

## 🏗️ Architecture

### Account 1 (Requester)

* Account ID: `163544304364`
* VPC: `vpc-0f238901bc3467b62`
* CIDR: `172.31.0.0/16`
* Route Table: `rtb-049c4395cbe56a7bb`
* Security Group: `sg-039aa170f6aac3f1a`

### Account 2 (Accepter)

* Account ID: `396913703931`
* VPC: `vpc-05b44d48e309cf3b7`
* CIDR: `10.90.0.0/20`
* Route Table: `rtb-015eb11135a1e84ca`
* Security Group: `sg-06ea0865e92179e23`

---

## 🔑 Step 1: Configure AWS CLI Profiles

```bash
aws configure --profile 163544304364
aws configure --profile 396913703931
```

Verify:

```bash
aws sts get-caller-identity --profile 163544304364
aws sts get-caller-identity --profile 396913703931
```

---

## 🌐 Step 2: Enable VPC DNS Settings (Required)

```bash
# Account 1
aws ec2 modify-vpc-attribute \
  --vpc-id vpc-0f238901bc3467b62 \
  --enable-dns-hostnames \
  --profile 163544304364

aws ec2 modify-vpc-attribute \
  --vpc-id vpc-0f238901bc3467b62 \
  --enable-dns-support \
  --profile 163544304364

# Account 2
aws ec2 modify-vpc-attribute \
  --vpc-id vpc-05b44d48e309cf3b7 \
  --enable-dns-hostnames \
  --profile 396913703931

aws ec2 modify-vpc-attribute \
  --vpc-id vpc-05b44d48e309cf3b7 \
  --enable-dns-support \
  --profile 396913703931
```

---

## 📦 Step 3: Terraform Configuration

### Providers

```hcl
provider "aws" {
  alias   = "account1"
  region  = "us-east-1"
  profile = "163544304364"
}

provider "aws" {
  alias   = "account2"
  region  = "us-east-1"
  profile = "396913703931"
}
```

---

### VPC Peering

```hcl
resource "aws_vpc_peering_connection" "peer" {
  provider      = aws.account1
  vpc_id        = "vpc-0f238901bc3467b62"
  peer_vpc_id   = "vpc-05b44d48e309cf3b7"
  peer_owner_id = "396913703931"
}
```

---

### Accept Peering

```hcl
resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  provider                  = aws.account2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}
```

---

### Enable DNS Resolution

```hcl
resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.account1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.peer_accept]
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.account2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.peer_accept]
}
```

---

### Routes

```hcl
resource "aws_route" "account1_to_account2" {
  provider                  = aws.account1
  route_table_id            = "rtb-049c4395cbe56a7bb"
  destination_cidr_block    = "10.90.0.0/20"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "account2_to_account1" {
  provider                  = aws.account2
  route_table_id            = "rtb-015eb11135a1e84ca"
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
```

---

### Security Groups

```hcl
resource "aws_security_group_rule" "account1_ingress" {
  provider          = aws.account1
  type              = "ingress"
  security_group_id = "sg-039aa170f6aac3f1a"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["10.90.0.0/20"]
}

resource "aws_security_group_rule" "account2_ingress" {
  provider          = aws.account2
  type              = "ingress"
  security_group_id = "sg-06ea0865e92179e23"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["172.31.0.0/16"]
}
```

---

## 🚀 Step 4: Deploy

```bash
terraform init
terraform plan
terraform apply
```

---

## ✅ Step 5: Validation

### Check Peering Status

```bash
aws ec2 describe-vpc-peering-connections \
  --vpc-peering-connection-ids <pcx-id>
```

Expected:

```
Status: active
```

---

### Verify DNS Resolution

```bash
aws ec2 describe-vpc-peering-connections \
  --vpc-peering-connection-ids <pcx-id> \
  --query "VpcPeeringConnections[].RequesterVpcInfo.PeeringOptions"
```

Expected:

```
AllowDnsResolutionFromRemoteVpc: true
```

---

## 🧪 Step 6: Testing

### If EC2 exists:

```bash
nslookup ip-10-90-x-x.ec2.internal
ping <private-ip>
```

---

## 🌍 Optional: Route 53 Cross-Account DNS

### Authorize VPC (Account 2)

```bash
aws route53 create-vpc-association-authorization \
  --hosted-zone-id <ZONE_ID> \
  --vpc VPCRegion=us-east-1,VPCId=vpc-0f238901bc3467b62
```

### Associate VPC (Account 1)

```bash
aws route53 associate-vpc-with-hosted-zone \
  --hosted-zone-id <ZONE_ID> \
  --vpc VPCRegion=us-east-1,VPCId=vpc-0f238901bc3467b62
```

---

## ⚠️ Common Issues & Fixes

| Issue                 | Fix                        |
| --------------------- | -------------------------- |
| Profile not found     | Configure AWS CLI profiles |
| Peering not active    | Add `depends_on`           |
| DNS error             | Enable VPC DNS settings    |
| Cannot resolve domain | Use Route 53 association   |

---

## 🧠 Key Learnings

* VPC peering requires **manual DNS enablement**
* Terraform needs **dependency handling for AWS timing**
* Route 53 private zones require **explicit cross-account association**
* AWS DNS is **not a traditional server** (uses internal resolver)

---

## 🎯 Outcome

You now have:

* Cross-account VPC connectivity
* Bidirectional routing
* Security configuration
* DNS resolution across VPCs

---

## 🚀 Next Steps

* Convert into Terraform module
* Integrate with EKS or microservices
* Implement Transit Gateway for scalability
* Use Route 53 for service discovery

---

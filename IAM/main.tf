provider "aws" {
    region = "us-east-1"
  
}

resource "aws_iam_user" "myUser" {
    name = "KK"
      
}

resource "aws_iam_policy" "customPolicy" {
    name = "GlacierEFS"
  

    
    policy = <<EOF
{    
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:DescribeBackupPolicy",
                "elasticfilesystem:DeleteAccessPoint",
                "glacier:AbortMultipartUpload",
                "glacier:GetVaultAccessPolicy",
                "elasticfilesystem:PutAccountPreferences",
                "elasticfilesystem:CreateFileSystem",
                "elasticfilesystem:ListTagsForResource",
                "glacier:CreateVault",
                "glacier:DescribeVault",
                "elasticfilesystem:DeleteReplicationConfiguration",
                "elasticfilesystem:ClientWrite",
                "glacier:GetVaultNotifications",
                "glacier:DescribeJob",
                "elasticfilesystem:CreateReplicationConfiguration",
                "glacier:DeleteVaultNotifications",
                "glacier:GetDataRetrievalPolicy",
                "elasticfilesystem:DescribeLifecycleConfiguration",
                "elasticfilesystem:ClientMount",
                "glacier:InitiateMultipartUpload",
                "elasticfilesystem:DescribeFileSystemPolicy",
                "elasticfilesystem:PutLifecycleConfiguration",
                "glacier:PurchaseProvisionedCapacity",
                "glacier:UploadArchive",
                "elasticfilesystem:DeleteMountTarget",
                "elasticfilesystem:CreateAccessPoint",
                "elasticfilesystem:ModifyMountTargetSecurityGroups",
                "elasticfilesystem:DescribeMountTargets",
                "glacier:InitiateJob",
                "elasticfilesystem:Restore",
                "glacier:DeleteVault",
                "glacier:DeleteArchive",
                "glacier:GetJobOutput",
                "elasticfilesystem:DescribeTags",
                "elasticfilesystem:CreateMountTarget",
                "glacier:SetVaultNotifications",
                "glacier:CompleteMultipartUpload",
                "glacier:UploadMultipartPart",
                "elasticfilesystem:Backup",
                "elasticfilesystem:PutBackupPolicy",
                "elasticfilesystem:ClientRootAccess",
                "glacier:GetVaultLock",
                "elasticfilesystem:DeleteFileSystem",
                "elasticfilesystem:DescribeMountTargetSecurityGroups",
                "elasticfilesystem:UpdateFileSystem"
            ],
            "Resource": "*"
        }
    ]
}

EOF 
}

resource "aws_iam_user_policy_attachment" "policyBind" {
    name = "attachment"
    users = [aws_iam_user.MyUser.name]
    policy_arn = aws_iam_policy.custompolicy.arn

}
  
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "iam:*User*",
        "iam:*Group*",
        "iam:*LoginProfile*",
        "iam:*AccessKey*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": "iam:*Role*",
      "Resource": [
        "arn:aws:iam::*:role/aws-service-role/organizations.amazonaws.com",
        "arn:aws:iam::*:role/OrganizationsAccountAccessRole",
        "arn:aws:iam::*:role/aws-service-role/sso.amazonaws.com",
        "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/*"
      ]
    },
    {
      "Effect": "Deny",
      "Action": [
        "iam:CreateRole",
        "iam:UpdateRole",
        "iam:UpdateRoleDescription",
        "iam:DeleteRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:UpdateAssumeRolePolicy",
        "iam:DetachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:CreateServiceLinkedRole",
        "iam:DeleteServiceLinkedRole",
        "iam:PutRolePermissionsBoundary",
        "iam:DeleteRolePermissionsBoundary",
        "iam:TagRole",
        "iam:UntagRole"
      ],
      "NotResource": [
        "arn:aws:iam::*:role/Customer*",
        "arn:aws:iam::*:role/Test*",
        "arn:aws:iam::*:role/aws-service-role/*"
      ]
    },
    {
      "Effect": "Deny",
      "Action": [
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:UpdateAssumeRolePolicy",
        "iam:DetachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:PutRolePermissionsBoundary"
      ],
      "Resource": [
        "arn:aws:iam::*:role/Customer*",
        "arn:aws:iam::*:role/Test*"
      ],
      "Condition": {
        "StringNotLike": {
          "iam:PermissionsBoundary": "arn:aws:iam::*:policy/permissionboundary"
        }
      }
    },
    {
      "Effect": "Deny",
      "Action": "iam:DeleteRolePermissionsBoundary",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "iam:PermissionsBoundary": "arn:aws:iam::*:policy/permissionboundary"
        }
      }
    },
    {
      "Effect": "Deny",
      "Action": [
        "iam:CreatePolicyVersion",
        "iam:SetDefaultPolicyVersion",
        "iam:TagPolicy",
        "iam:DeletePolicyVersion",
        "iam:DeletePolicy",
        "iam:UntagPolicy"
      ],
      "Resource": "arn:aws:iam::*:policy/permissionboundary"
    }
  ]
}

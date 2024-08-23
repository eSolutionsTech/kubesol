# Velero

Velero is a backup system for Kubernetes, storing the backups in a remote S3 bucket (or equivalent). See https://velero.io

Below we are describing step by step how to setup an AWS S3 bucket and use it in our setup.

## Install velero cli on the local machine:

Download the latest official release’s tarball for your client platform.
<https://github.com/vmware-tanzu/velero/releases>

Extract the tarball:
```
tar -xvf <RELEASE-TARBALL-NAME>.tar.gz
```

Move velero binary in yout PATH (/usr/local/bin)

## Create an aws S3 bucket:

- Connect to the AWS Management Console and open CloudShell:

```
aws s3api create-bucket \
    --bucket <bucket name> \
    --region <aws region> 
    --create-bucket-configuration LocationConstraint=<aws region>
```

- NOTE: us-east-1 does not support a LocationConstraint. If your region is us-east-1, omit the bucket configuration:

```
aws s3api create-bucket \
    --bucket <bucket name> \
    --region <aws region>
```

## Create IAM user and policy using AWS cli:

- Create the IAM user:
```
aws iam create-user --user-name velero
```

- Attach policies to give velero the necessary permissions:
```
cat > velero-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}"
            ]
        }
    ]
}
EOF
```

```
aws iam put-user-policy \
  --user-name velero \
  --policy-name velero \
  --policy-document file://velero-policy.json
```

- Create an access key for the user:
```
aws iam create-access-key --user-name velero
```

The result should look like:
```
{
  "AccessKey": {
        "UserName": "velero",
        "Status": "Active",
        "CreateDate": "2017-07-31T22:24:41.576Z",
        "SecretAccessKey": <AWS_SECRET_ACCESS_KEY>,
        "AccessKeyId": <AWS_ACCESS_KEY_ID>
  }
}
```

## Modifify in kubesol-v1/ansible/files/velero/values-velero.yaml file the following parameters with the values from the previous step:

- bucket: <bucket_name>
- region: <aws_region>
- SecretAccessKey: <AWS_SECRET_ACCESS_KEY>
- AccessKeyId: <AWS_ACCESS_KEY_ID>


## Install velero operator:
```
ansible-playbook 480-velero.yaml
```

## Create a backup
```
velero backup create <backup name> --include-namespaces <namespace name>
```
- list the default velero backup location
```
velero backup-location get
```
- list available backups
```
velero get backup
```


## Restore a backup; in case of data loss restore from existing backups
```
velero restore create --from-backup <backup name>
```


- For more information about how to schedule a backup visit:
https://velero.io/docs/v1.13/backup-reference/

- For more information about how to take snapshots of a volume:
https://velero.io/docs/v1.13/locations/


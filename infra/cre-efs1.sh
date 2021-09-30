CLUSTER="ekshsm"
VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=eksctl-ekshsm-cluster/VPC --query "Vpcs[].VpcId" | jq -r .[])
subnet=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=eksctl-ekshsm-cluster/SubnetPrivateEUWEST2A --query "Subnets[].SubnetId" | jq -r .[])
echo $subnet
echo $VPC_ID
CIDR_BLOCK=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID --query "Vpcs[].CidrBlock" --output text)
echo $CIDR_BLOCK
MOUNT_TARGET_GROUP_NAME="eks-efs-group"
MOUNT_TARGET_GROUP_DESC="NFS access to EFS from EKS worker nodes"
MOUNT_TARGET_GROUP_ID=$(aws ec2 create-security-group --group-name $MOUNT_TARGET_GROUP_NAME --description "$MOUNT_TARGET_GROUP_DESC" --vpc-id $VPC_ID | jq --raw-output '.GroupId')
aws ec2 authorize-security-group-ingress --group-id $MOUNT_TARGET_GROUP_ID --protocol tcp --port 2049 --cidr $CIDR_BLOCK
FILE_SYSTEM_ID=$(aws efs create-file-system | jq --raw-output '.FileSystemId')
# FileSystemId": "fs-8b3cfd7b",
aws efs describe-file-systems --file-system-id $FILE_SYSTEM_ID
echo "creating mount target in " $subnet
echo "wait for EFS state"
sleep 60
aws efs create-mount-target --file-system-id $FILE_SYSTEM_ID --subnet-id $subnet --security-groups $MOUNT_TARGET_GROUP_ID
aws efs describe-mount-targets --file-system-id $FILE_SYSTEM_ID | jq --raw-output '.MountTargets[].LifeCycleState'
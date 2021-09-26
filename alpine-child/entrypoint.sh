#!/bin/sh
###
#The values for the SSM parameters have been removed for security 
###

# Install cloudhsm client and JCE Provider downloaded in the base image, this is done here as a volume needs to first be attached.

echo "install"
mount | grep hsm
ls *.rpm
#yum install -y ./cloudhsm-client-latest.el8.x86_64.rpm && yum install -y ./cloudhsm-client-jce-latest.el8.x86_64.rpm

# Cleanup - remove installation files
# rm -rf cloudhsm-client-latest.el8.x86_64.rpm && rm -rf cloudhsm-client-jce-latest.el8.x86_64.rpm

# Get HSM IP via awcli, credentials for AWS cli attached via a k8s service role.
echo "ls /opt/cloudhsm"
ls /opt/cloudhsm
vpc1=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=eksctl-ekshsm-cluster/VPC --query "Vpcs[].VpcId" | jq -r .[])
cid=$(aws cloudhsmv2 describe-clusters --filters vpcIds=$vpc1 --query "Clusters[].ClusterId" | jq -r .[])
HSM_IP=$(aws cloudhsmv2 describe-clusters --filters clusterIds=$cid --query "Clusters[].Hsms[].EniIp" | jq -r .[])
echo "vpc1=$vpc1"
echo "HSMIP=$HSM_IP"

echo "nmap check on $HSM_IP"
nmap ${HSM_IP} -Pn -p 2225

echo "# Configure CloudHSM Client"

/opt/cloudhsm/bin/configure -a "${HSM_IP}"

echo "# Download CloudHSM CA" 
aws --region=eu-west-2 ssm get-parameter --name "hsm-customerca-crt" --with-decryption --output text --query Parameter.Value --no-verify-ssl > /opt/cloudhsm/etc/customerCA.crt
echo "ls /opt/cloudhsm/etc"
ls /opt/cloudhsm/etc
export HSM_USER="admin"
export HSM_PASSWORD=$(aws --region=eu-west-2 ssm get-parameter --name "hsmpw" --with-decryption --output text --query Parameter.Value)
echo "HSM_PASSWORD=$HSM_PASSWORD"
echo "# Start CloudHSM as a daemon"
/cloudhsm/startdaemon.sh


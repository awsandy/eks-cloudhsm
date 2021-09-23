vpc1=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=eksctl-ekshsm-cluster/VPC --query "Vpcs[].VpcId" | jq -r .[])
sub1=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=eksctl-ekshsm-cluster/SubnetPrivateEUWEST2A --query "Subnets[].SubnetId" | jq -r .[])
echo $sub1
echo $vpc1
cid=$(aws cloudhsmv2 describe-clusters --filters vpcIds=$vpc1 --query "Clusters[].ClusterId" | jq -r .[])
if [ -z ${cid} ]; then 
    echo "cid is unset - create cluster"
    aws cloudhsmv2 create-cluster --hsm-type hsm1.medium --subnet-ids $sub1
else 
    echo "cid is set to '$cid'"
fi



sleep 5
cst=$(aws cloudhsmv2 describe-clusters --filters vpcIds=$vpc1 --query "Clusters[].State" | jq -r .[])
echo $cst
while [ "$cst" != "UNINITIALIZED" ]; do
    echo "waiting $cst"
    sleep 10
    cst=$(aws cloudhsmv2 describe-clusters --filters vpcIds=$vpc1 --query "Clusters[].State" | jq -r .[])
    echo $cst
done
echo $cst
cid=$(aws cloudhsmv2 describe-clusters --filters vpcIds=$vpc1 --query "Clusters[].ClusterId" | jq -r .[])

#aws cloudhsmv2 create-hsm –cluster-id <CLUSTER ID> –availability-zone <AVAILABILITY ZONE>


# get the cluster CSR
aws cloudhsmv2 describe-clusters --filters clusterIds=$cid --query "Clusters[].Certificates.ClusterCsr" | jq -r .[] > ClusterCsr.csr

echo "exit"
#aws cloudhsmv2 
 
PASS1="passw1"
# Create a private key
openssl genrsa -aes256 -passout pass:$PASS1 -out customerCA.key 2048
# use private key to create a self signed certificate customerCA.crt
openssl req -new -x509 -passin pass:$PASS1 -days 3652 -key customerCA.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=Acme Root CA" -out customerCA.crt

# sign the cluster CSR
openssl x509 -req -passin pass:$PASS1 -days 3652 -in ClusterCsr.csr \
                              -CA customerCA.crt \
                              -CAkey customerCA.key \
                              -CAcreateserial \
                              -out CustomerHsmCertificate.crt

aws cloudhsmv2 initialize-cluster --cluster-id $cid \
                                    --signed-cert file://CustomerHsmCertificate.crt \
                                    --trust-anchor file://customerCA.crt

cst=$(aws cloudhsmv2 describe-clusters --filters clusterIds=$cid --query "Clusters[].State" | jq -r .[])
echo $cst
while [ "$cst" != "INITIALIZED" ]; do
    echo "waiting $cst"
    sleep 10
    cst=$(aws cloudhsmv2 describe-clusters --filters clusterIds=$cid --query "Clusters[].State" | jq -r .[])
done
echo $cst

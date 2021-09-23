export AWS_REGION=eu-west-2
aws configure set region eu-west-2
#aws cloudformation delete-stack --stack-name eksctl-ateksf1-addon-iamserviceaccount-kube-system-aws-node
#aws cloudformation delete-stack --stack-name eksctl-ateksf1-nodegroup-podsched-1
##aws cloudformation delete-stack --stack-name eksctl-ateksf1-addon-iamserviceaccount-kube-system-aws-load-balancer-controller
aws cloudformation delete-stack --stack-name eksctl-ekshsm-cluster
aws sts get-caller-identity
eksctl create cluster -f ekshsm.yaml 

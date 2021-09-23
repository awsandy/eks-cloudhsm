aws cloudformation delete-stack --stack-name eksctl-ekshsm-nodegroup-ng-1
aws cloudformation wait stack-delete-complete
aws cloudformation delete-stack --stack-name eksctl-ekshsm-cluster

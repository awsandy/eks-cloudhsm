kubectl delete -f pod-efs.yaml
cd ../cloudhsm-sidecar-base
./push-ecr.sh
cd ../efs-sidecar-child
./push-ecr.sh
cd ../efs-test-app
./push-ecr.sh
cd ../manifests
kubectl apply -f pod-efs.yaml
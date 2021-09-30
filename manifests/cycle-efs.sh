kubectl delete -f pod.yaml
cd ../cloudhsm-sidecar-base
./push-ecr.sh
cd ../cloudhsm-sidecar-child
./push-ecr.sh
cd ../cloudhsm-test-app
./push-ecr.sh
cd ../manifests
kubectl apply -f pod.yaml
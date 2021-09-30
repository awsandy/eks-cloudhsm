kubectl delete -f pod.yaml
cd ../alpine-base
./push-ecr.sh
cd ../alpine-child
./push-ecr.sh
kubectl apply -f pod.yaml
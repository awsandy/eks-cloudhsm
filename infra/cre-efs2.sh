#wget https://eksworkshop.com/beginner/190_efs/efs.files/efs-pvc.yaml 
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.0"
kubectl get pods -n kube-system
mkdir efs
cd efs
wget https://eksworkshop.com/beginner/190_efs/efs.files/efs-pvc.yaml 
sed -i "s/EFS_VOLUME_ID/$FILE_SYSTEM_ID/g" efs-pvc.yaml
kubectl apply -f efs-pvc.yaml
kubectl get pvc -n storage
kubectl get pv


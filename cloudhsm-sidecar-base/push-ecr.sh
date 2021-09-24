export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION="eu-west-2"
imn=$(pwd | rev | cut -f1 -d'/' | rev)
echo $imn
docker build . -t $imn
exit
aws ecr describe-repositories --repository-names $imn &> /dev/null 
if [ $? != 0 ];then
    echo "$imn doesn't exist - create"
    aws ecr create-repository --repository-name $imn
fi
echo "login for ecr"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
docker tag $imn $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$imn
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$imn

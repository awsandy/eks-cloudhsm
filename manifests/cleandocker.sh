for i in `docker image ls | grep hsm | awk '{print $3}'` ; do
docker image rm $i  --force
done

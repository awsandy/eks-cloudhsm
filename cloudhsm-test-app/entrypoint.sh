#!/bin/sh

#The below variables have been removed for security
export HSM_USER=$(aws --region=eu-west-2 ssm get-parameter --name "hsmcuuser" --with-decryption --output text --query Parameter.Value  --no-verify-ssl  )
export HSM_PASSWORD=$(aws --region=eu-west-2 ssm get-parameter --name "hsmcupw" --with-decryption --output text --query Parameter.Value  --no-verify-ssl  )
export S3_BUCKET=""
export KEYSTORE_PASSWORD=$(aws --region=eu-west-2 ssm get-parameter --name "hsmcupw" --with-decryption --output text --query Parameter.Value  --no-verify-ssl  )
#####

function connect_cloudhsm(){
    while [ ! "$(pgrep cloudhsm)" ]
    do
        echo "Waiting for cloudhsm agent to start"
    done

    # Get process ID or cloudHSM client
    PID=$(pgrep cloudhsm)

    ln -s /proc/$PID/root/usr/lib64 /opt/lib64
    
    # Link cloudhsm directory and library path of cloudhsm container

    check=$(ls /opt/lib64 > /dev/null 2>&1)
    retval=$?

    while [ $retval -ne 0 ]
    do
        echo "Attempting to create symlink /proc/$PID/root/usr/lib64 -> /opt/lib64"
        ln -s /proc/$PID/root/usr/lib64 /opt/lib64
        check=$(ls /opt/lib64 > /dev/null 2>&1)
        retval=$?
        sleep 5
    done


    #Write credentials to properties file in application classpath
cat << EOF > /opt/cloudhsm/java/HsmCredentials.properties
HSM_PARTITION = PARTITION_1
HSM_USER = ${HSM_USER}
HSM_PASSWORD = ${HSM_PASSWORD}
EOF
# TODO: Permissions for Credentials file ?

unset HSM_USER
unset HSM_PASSWORD
}

connect_cloudhsm

echo "security.provider.13=com.cavium.provider.CaviumProvider" >> $JAVA_HOME/conf/security/java.security
aws s3 cp s3://$S3_BUCKET/hsm-keystore.p12 .
keytool -list -v -keystore /hsm-keystore.p12 -storepass "$KEYSTORE_PASSWORD" -storetype CLOUDHSM -J-classpath '-J/opt/cloudhsm/java/*' -J-Djava.library.path=/opt/cloudhsm/lib

tail -f /dev/null
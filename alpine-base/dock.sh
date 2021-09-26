
# Create working directory /cloudhsm

apk add sudo

adduser -D -s /bin/sh cloudhsm
#echo "$NEWUSER ALL=(ALL) ALL" > /etc/sudoers.d/$NEWUSER && chmod 0440 /etc/sudoers.d/$NEWUSER


#useradd -s /usr/bin/sh cloudhsm
cd /cloudhsm

# Set defaults for java, awscli and cloudhsm
AWS_DEFAULT_REGION=eu-west-2
LD_LIBRARY_PATH=/opt/cloudhsm/lib
HSM_PARTITION=PARTITION_1
JAVA_HOME="/usr/bin"

apk add rpm
# Install dependencies
apk add wget unzip which jq nmap curl

apk add openjdk11
rm -rf /var/cache/apk/*
# Download CloudHSM Client and JCE Provider, these will be installed at time as they need to reside on a volume created by k8s so they can be shared.
wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-latest.el8.x86_64.rpm
wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-jce-latest.el8.x86_64.rpm

# Download dependencies of both cloudHSM packages, and install them with rpm at build time, then the actual packages installed at time so they install to the volume
# mkdir /var/tmp/cloudhsm-client && yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-client cloudhsm-client-latest.el8.x86_64.rpm && rpm -ivh /var/tmp/cloudhsm-client/*.rpm && rm -rf /var/tmp/cloudhsm-client

##
#  test on cloud9
#yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-client cloudhsm-client-latest.el8.x86_64.rpm
#apk add libedit
apk add ncurses-libs
apk add json-c
#apk add openssl-dev




# mkdir /var/tmp/cloudhsm-JCE && yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-JCE cloudhsm-client-jce-latest.el8.x86_64.rpm && rpm -ivh /var/tmp/cloudhsm-JCE/*.rpm && rm -rf /var/tmp/cloudhsm-JCE
# yum install -y ./cloudhsm-client-latest.el8.x86_64.rpm && yum install -y ./cloudhsm-client-jce-latest.el8.x86_64.rpm

# Install AWS Cli so parameters can be pulled from paramstore
pwd
apk --no-cache add binutils curl 
GLIBC_VER="2.34-r0"
curl -sL https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub 
curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk 
curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-bin-2.34-r0.apk 
apk add --allow-untrusted --no-cache glibc-2.34-r0.apk glibc-bin-2.34-r0.apk 
curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip -q awscliv2.zip 
aws/install 
rm -rf awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples 
apk --no-cache del binutils curl 
rm glibc-2.34-r0.apk 
rm glibc-bin-2.34-r0.apk 
rm -rf /var/cache/apk/*



#awsv2 --version   # Just to make sure its installed alright
ln -s $(which awscliv2) /usr/bin/aws
aws --version

wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-3.4.0-1.el8.x86_64.rpm

#rpm -ivh cloudhsm-client-3.4.0-1.el8.x86_64.rpm
#rpm -ivh cloudhsm-client-3.4.0-1.el8.x86_64.rpm --nodeps

apk add libarchive-tools
bsdtar -xvf ../cloudhsm-client-3.4.0-1.el8.x86_64.rpm
./cloudhsm.sh

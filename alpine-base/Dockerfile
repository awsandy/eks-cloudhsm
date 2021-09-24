FROM alpine
# Create working directory /cloudhsm

RUN apk add sudo
RUN NEWUSER='cloudhsm'
RUN adduser -D -s /bin/sh cloudhsm
#RUN echo "$NEWUSER ALL=(ALL) ALL" > /etc/sudoers.d/$NEWUSER && chmod 0440 /etc/sudoers.d/$NEWUSER


#RUN useradd -s /usr/bin/sh cloudhsm
WORKDIR /cloudhsm

# Set defaults for java, awscli and cloudhsm
ENV AWS_DEFAULT_REGION=eu-west-2
ENV LD_LIBRARY_PATH=/opt/cloudhsm/lib
ENV HSM_PARTITION=PARTITION_1
ENV JAVA_HOME="/usr/bin"

RUN apk add rpm
# Install dependencies
RUN apk add wget unzip which jq nmap curl

RUN apk add openjdk11
RUN rm -rf /var/cache/apk/*
# Download CloudHSM Client and JCE Provider, these will be installed at run time as they need to reside on a volume created by k8s so they can be shared.
RUN wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-latest.el8.x86_64.rpm
RUN wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-jce-latest.el8.x86_64.rpm

# Download dependencies of both cloudHSM packages, and install them with rpm at build time, then the actual packages installed at run time so they install to the volume
# RUN mkdir /var/tmp/cloudhsm-client && yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-client cloudhsm-client-latest.el8.x86_64.rpm && rpm -ivh /var/tmp/cloudhsm-client/*.rpm && rm -rf /var/tmp/cloudhsm-client
RUN mkdir /var/tmp/cloudhsm-client
##
#  test on cloud9
#RUN yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-client cloudhsm-client-latest.el8.x86_64.rpm
RUN rpm -ivh /var/tmp/cloudhsm-client/*.rpm


# RUN mkdir /var/tmp/cloudhsm-JCE && yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-JCE cloudhsm-client-jce-latest.el8.x86_64.rpm && rpm -ivh /var/tmp/cloudhsm-JCE/*.rpm && rm -rf /var/tmp/cloudhsm-JCE
# RUN yum install -y ./cloudhsm-client-latest.el8.x86_64.rpm && yum install -y ./cloudhsm-client-jce-latest.el8.x86_64.rpm

# Install AWS Cli so parameters can be pulled from paramstore

RUN apk --no-cache add binutils curl 
RUN GLIBC_VER="2.34-r0"
RUN curl -sL https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub 
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk 
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-bin-2.34-r0.apk 
RUN apk add --allow-untrusted --no-cache glibc-2.34-r0.apk glibc-bin-2.34-r0.apk 
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
RUN unzip -q awscliv2.zip 
RUN aws/install 
RUN rm -rf awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples 
RUN apk --no-cache del binutils curl 
RUN rm glibc-2.34-r0.apk 
RUN rm glibc-bin-2.34-r0.apk 
RUN rm -rf /var/cache/apk/*

#RUN awsv2 --version   # Just to make sure its installed alright
RUN ln -s $(which awscliv2) /usr/bin/aws
RUN aws --version



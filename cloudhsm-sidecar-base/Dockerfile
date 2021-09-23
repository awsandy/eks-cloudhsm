FROM centos:8
# Create working directory /cloudhsm
RUN useradd -s /usr/bin/sh cloudhsm
WORKDIR /cloudhsm

# Set defaults for java, awscli and cloudhsm
ENV AWS_DEFAULT_REGION=eu-west-2
ENV LD_LIBRARY_PATH=/opt/cloudhsm/lib
ENV HSM_PARTITION=PARTITION_1
ENV JAVA_HOME="/usr/bin"

# Install dependencies
RUN yum install -y wget unzip java-11-openjdk which

# Download CloudHSM Client and JCE Provider, these will be installed at run time as they need to reside on a volume created by k8s so they can be shared.
RUN wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-latest.el8.x86_64.rpm
RUN wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL8/cloudhsm-client-jce-latest.el8.x86_64.rpm

# Download dependencies of both cloudHSM packages, and install them with rpm at build time, then the actual packages installed at run time so they install to the volume
RUN mkdir /var/tmp/cloudhsm-client && yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-client cloudhsm-client-latest.el8.x86_64.rpm && rpm -ivh /var/tmp/cloudhsm-client/*.rpm && rm -rf /var/tmp/cloudhsm-client
# RUN mkdir /var/tmp/cloudhsm-JCE && yum install -y --downloadonly  --downloaddir=/var/tmp/cloudhsm-JCE cloudhsm-client-jce-latest.el8.x86_64.rpm && rpm -ivh /var/tmp/cloudhsm-JCE/*.rpm && rm -rf /var/tmp/cloudhsm-JCE
# RUN yum install -y ./cloudhsm-client-latest.el8.x86_64.rpm && yum install -y ./cloudhsm-client-jce-latest.el8.x86_64.rpm

# Install AWS Cli so parameters can be pulled from paramstore
RUN curl -k "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

# Cleanup - Remove installation files
RUN rm -rf awscliv2.zip && rm -rf aws/ 


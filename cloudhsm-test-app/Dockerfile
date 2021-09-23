FROM centos:8

ENV JAVA_HOME="/usr/lib/jvm/jre"
ENV LD_LIBRARY_PATH="/opt/lib64:/opt/cloudhsm/lib:$LD_LIBRARY_PATH"
ENV AWS_DEFAULT_REGION=eu-west-2
RUN yum install -y wget unzip java-11-openjdk-devel which lsof
RUN wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-client-jce-latest.el7.x86_64.rpm
RUN yum install -y ./cloudhsm-client-jce-latest.el7.x86_64.rpm
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
RUN curl -k "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN rm -rf awscliv2.zip && rm -rf aws/ 
ENTRYPOINT ["sh", "entrypoint.sh"]
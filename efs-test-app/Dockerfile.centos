FROM centos:8

ENV JAVA_HOME="/usr/lib/jvm/jre"
ENV LD_LIBRARY_PATH="/opt/lib64:/opt/cloudhsm/lib:$LD_LIBRARY_PATH"
ENV AWS_DEFAULT_REGION=eu-west-2
RUN yum install -y wget unzip java-11-openjdk-devel which lsof
COPY entrypoint.sh .
COPY my_keystore.store .
RUN chmod +x entrypoint.sh
RUN curl -k "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip -qq awscliv2.zip && ./aws/install
RUN rm -rf awscliv2.zip && rm -rf aws/ 
ENTRYPOINT ["sh", "entrypoint.sh"]
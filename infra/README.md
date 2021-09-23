
https://aws.amazon.com/blogs/security/how-to-clone-an-aws-cloudhsm-cluster-across-regions/


https://docs.aws.amazon.com/cloudhsm/latest/userguide/initialize-cluster.html#sign-csr



Create EKS cluster
Pop a Cloud9 on the subnet zone 1a - instance profile

ports 2223-2225   inbound cloudhsm-cluster-clusterID-sg allow from cloud9 and vice versa
cloudhsm-cluster-clusterID-sg - allow all to cloud9 sg


wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL6/cloudhsm-client-latest.el6.x86_64.rpm

sudo yum install -y ./cloudhsm-client-latest.el6.x86_64.rpm

hsmip=$(aws cloudhsmv2 describe-clusters --query "Clusters[].Hsms[].EniIp" | jq -r .[])

sudo /opt/cloudhsm/bin/configure -a $hsmip
<output>
Updating server config in /opt/cloudhsm/etc/cloudhsm_client.cfg
Updating server config in /opt/cloudhsm/etc/cloudhsm_mgmt_util.cfg


/opt/cloudhsm/bin/cloudhsm_mgmt_util /opt/cloudhsm/etc/cloudhsm_mgmt_util.cfg
<output>
Ignoring E2E enable flag in the configuration file

Connecting to the server(s), it may take time
depending on the server(s) load, please wait...

Connecting to server '192.168.125.125': hostname '192.168.125.125', port 2225...
Connected to server '192.168.125.125': hostname '192.168.125.125', port 2225.
/opt/cloudhsm/etc/customerCA.crt,
partition owner certificate not exist at given path
Server 0(192.168.125.125) is in unencrypted mode now...
running in limited commands mode
Error: partition owner certificate doesn't exist at given path.
Failed to create client ssl ctx
E2E Session failed: E2E setup failed
Enabling E2E failed
aws-cloudhsm> 


Note:
The command to enable_e2e looks for the certificate “customerCA.crt” in the /opt/cloudhsm/etc/ directory.

aws-cloudhsm> enable_e2e
E2E enabled on server 0(192.168.125.125)

aws-cloudhsm>loginHSM PRECO admin password
loginHSM success on server 0(192.168.125.125)

changePswd PRECO admin <newpw>   ea!

aws-cloudhsm>logout
logoutHSM success on server 0(192.168.125.125)

aws-cloudhsm>listUsers
Users on server 0(192.168.125.125):
Number of users found:2

    User Id             User Type       User Name                          MofnPubKey    LoginFailureCnt         2FA
         1              CO              admin                                    NO               0               NO
         2              AU              app_user                                 NO               0               NO

aws-cloudhsm>loginHSM CO admin <newpw>
loginHSM success on server 0(192.168.125.125)
aws-cloudhsm> createUser CU andyt fl1*****p 


-----------------

 

sudo systemctl status cloudhsm-client

sudo systemctl start cloudhsm-client

/opt/cloudhsm/bin/key_mgmt_util
Command: loginHSM -u CU -s andyt -p fl1****p

Command: genSymKey -t 31 -s 32 -l aes256 -nex


        Cfm3GenerateSymmetricKey returned: 0x00 : HSM Return: SUCCESS

        Symmetric Key Created.  Key Handle: 6

        Cluster Status:
        Node id 0 status: 0x00000000 : HSM Return: SUCCESS

Command: exit


Put HSM on 1a private

------


export HSM_PARTITION=PARTITION_1
export HSM_USER=$(aws --region=eu-west-2 ssm get-parameter --name "hsmcuuser" --with-decryption --output text --query Parameter.Value  --no-verify-ssl  )
export HSM_PASSWORD=$(aws --region=eu-west-2 ssm get-parameter --name "hsmcupw" --with-decryption --output text --query Parameter.Value  --no-verify-ssl  )


wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-client-jce-latest.el7.x86_64.rpm
sudo yum install ./cloudhsm-client-jce-latest.el7.x86_64.rpm

sudo mkdir -p /usr/java/packages/lib
sudo ln -s /opt/cloudhsm/lib/libcaviumjca.so /usr/java/packages/lib/libcaviumjca.so


java -classpath "/opt/cloudhsm/java/*" org.junit.runner.JUnitCore TestBasicFunctionality
<output>
JUnit version 4.11
.2021-09-23 13:36:46,583 DEBUG [main] TestBasicFunctionality (TestBasicFunctionality.java:33) - Adding provider.
2021-09-23 13:36:46,688 DEBUG [main] TestBasicFunctionality (TestBasicFunctionality.java:42) - Logging in.
2021-09-23 13:36:46,689 INFO  [main] cfm2.LoginManager (LoginManager.java:238) - Looking for credentials in HsmCredentials.properties
2021-09-23 13:36:46,691 INFO  [main] cfm2.LoginManager (LoginManager.java:256) - Looking for credentials in System.properties
2021-09-23 13:36:46,694 INFO  [main] cfm2.LoginManager (LoginManager.java:264) - Looking for credentials in System.env
2021-09-23 13:36:46,771 DEBUG [main] TestBasicFunctionality (TestBasicFunctionality.java:54) - Generating AES Key with key size 256.
2021-09-23 13:36:46,799 DEBUG [main] TestBasicFunctionality (TestBasicFunctionality.java:63) - Encrypting with AES Key.
2021-09-23 13:36:46,808 DEBUG [main] TestBasicFunctionality (TestBasicFunctionality.java:84) - Deleting AES Key.
2021-09-23 13:36:46,809 DEBUG [main] TestBasicFunctionality (TestBasicFunctionality.java:92) - Logging out.



keytool -genseckey -alias my_secret -keyalg aes -storepass $HSM_PASSWORD \
        -keysize 256 -keystore my_keystore.store \
        -storetype CLOUDHSM -J-classpath '-J/opt/cloudhsm/java/*' \
        -J-Djava.library.path=/opt/cloudhsm/lib/






Command: findKey 
(see numner of keys going up)


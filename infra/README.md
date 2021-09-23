
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

changePswd PRECO admin <newpw>

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


keytool -list  -storepass $HSM_PASSWORD\
	-keystore my_keystore.store \
	-storetype CLOUDHSM -J-classpath '-J/opt/cloudhsm/java/*' \
	-J-Djava.library.path=/opt/cloudhsm/lib/

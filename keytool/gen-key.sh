keytool -genseckey -alias my_secret -keyalg aes -storepass $HSM_PASSWORD \
	-keysize 256 -keystore my_keystore.store \
	-storetype CLOUDHSM -J-classpath '-J/opt/cloudhsm/java/*' \
	-J-Djava.library.path=/opt/cloudhsm/lib/

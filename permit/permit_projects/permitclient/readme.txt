rolesclient configuration

The roleclient web application needs config.properties files directory specified by WSETCDIR environment variable.

The config.properties files has the following list of properties:

KeyStore.File -- Java KeyStore file path with application certificate for roles	/usr/local/etc/map/ws/keystore/rolesapp-test.mit.edu.jks
TrustStore.File	-- TrustStore File path 	/usr/local/etc/map/ws/keystore/serverTrustStore.jks
KeyStore.Password	-- password for keystore
TrustStore.Password	--  password for TrustStore 
server			-- Server name for rolesws webs ervice 
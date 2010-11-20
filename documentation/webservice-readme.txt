Author: bskinner
LastUpdated: 04-27-2010

=====================
General Configuration
=====================
The production and development environments are currently using RHEL 5.2
(Tikanga). The minimum requirements for the perMIT webservice is:
    Java 1.5 JRE
    Tomcat 6.0.18
    Subversion 1.5 or higher

    
Existing Servers:
    ws-dev.mit.edu - permitws deployment
    groups-dev1.mit.edu - permitclient deployment


Maven Projects:
    permit_projects/permitlibrary:
        Touchstone and Certificate Library
    
    permit_projects/PermitService:
        Permit Spring/Hibernate Layer
    
    permit_projects/permitws:
        Permit webservice
    
    permit_projects/permitclient:
        Permit Web UI Client
    

Tomcat user/group: www:www
SSH: www@<server> (Ask AMIT to add your MIT ID)


======================================
Setting up the development environment
======================================
The various Java webservice projects are Maven-based and should work with any
IDE that support Maven integration but the developers on the project primarily
use NetBeans and these instructions are geared towards it.

1: Request a static IP and DN assignment:
    http://ist.mit.edu/services/network/ip-request
    
2: Once you obtain your IP, request an X509 server certificate:
    https://wikis.mit.edu/confluence/display/devtools/How+to+acquire+and+verify+a+M.I.T.+x509+Server+Certificate
    
3: Download and install the Java SE 6 JDK (http://java.sun.com)
    3a: Make sure that the Java binaries are in your PATH
    3b: Create a trusted server store using the instruction at:
        https://wikis.mit.edu/confluence/display/devtools/How+to+create+a+Trusted+Server+Java+keystore
    3c: Create a java keystore containing your server certificate (obtained in
        step 2) using the instructions at:
        https://wikis.mit.edu/confluence/display/devtools/How+to+create+a+Server+Certificate+Java+keystore
        
4: Download and install Maven (http://maven.apache.org/)
    4a: Make sure that the Maven binaries are in your PATH
    
5: Download and install Subversion (http://subversion.apache.org/packages.html)
    5a: Make sure that the Subversion binaries are in your PATH
    
6: Download and install NetBeans, make sure the option to install Tomcat is
    enabled and the installation of Glassfish is disabled

7: Decide on where your MIT Webservice configuration folder will go
    (for example: C:\was on Windows or /usr/etc/was on a *NIX system). Remember
    this path, you will need it later
    7a: Once you create the webservice configuration directory, create a global
        environment variable called WSETCDIR and set it to the path you decided
        on in the previous step.
        
    7b: Create the following directories:
        ${WSETCDIR}/containers
        ${WSETCDIR}/containers/default
        ${WSETCDIR}/containers/misc
        ${WSETCDIR}/containers/moira
        ${WSETCDIR}/containers/permit
        ${WSETCDIR}/containers/permit/permitws
        ${WSETCDIR}/containers/roles
        ${WSETCDIR}/containers/roles/rolesws
        ${WSETCDIR}/jmx
        ${WSETCDIR}/keystore
        ${WSETCDIR}/krb
        ${WSETCDIR}/lib
        ${WSETCDIR}/logs
        
    7c: Create the following files (they should be empty at this point):
        ${WSETCDIR}/config.properties
        ${WSETCDIR}/mastermanagement.properties
        ${WSETCDIR}/webserviceConfig.properties
        ${WSETCDIR}/containers/permit/permitws/allowedLocations.properties
        ${WSETCDIR}/containers/roles/rolesws/allowedLocations.properties
        ${WSETCDIR}/logs/permitws.log
    
    7d: Copy the "serverTrustStore.jks" you created to:
        ${WSETCDIR}/keystore/serverTrustStore.jks
    
    7d: Copy your server certificate keystore to:
        ${WSETCDIR}/keystore/
        
8: You should launch NetBeans and get the Tomcat installation working
    8a: Once NetBeans has launched, click on the "Servers" tab, Click the "+"
        next to "Server", you should see your Tomcat installation. If you don't
        see it, rerun the NetBeans installer and ensure that you installed it.
    8b: Right click the "Apache Tomcat" server and select "Start". You should
        now see several logs appear and eventually a line like "INFO: Server
        startup in [\d]+ ms" should appear. At this point try connecting to
        "http://localhost:8084" and see if you can connect to the server. If
        that works, go back to NetBeans, right click the server again and select
        "Stop".
    8c: Now that you know your server is working, right-click "Apache Tomcat"
        and select "Edit server.xml"
    8d: Look for the commented out section that defines an SSL HTTP/1.1
        Connector. It should look something like this:
            <!--
            <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
            ...
            -->
        Right below this section insert the following block. Be sure to change
        the values for "keystoreFile", "keystorePass" and "truststoreFile" to
        your server keystore path, password and server trust store path,
        respectively:
            <Connector SSLEnabled="true"
                    acceptCount="100"
                    className="org.apache.catalina.connector.http.HttpConnector"
                    clientAuth="true"
                    disableUploadTimeout="true"
                    enableLookups="true"
                    maxHttpHeaderSize="8192"
                    maxSpareThreads="75"
                    maxThreads="150"
                    minSpareThreads="25"
                    port="8443"
                    scheme="https"
                    secure="true"
                    sslProtocol="TLS"
                    keystoreFile="/path/to/domain.jks"
                    keystorePass="MyKeystorePassword"
                    truststoreFile="/path/to/serverTrustStore.jks"
                    truststorePass="changeit"/>
                    
    8e: Right click the "Apache Tomcat" server and select "Start". Once the
        server starts, try connecting to "https://localhost:8443". If that
        works, go back to NetBeans, right click the server again and select
        "Stop".
        
9: Now decide on where your working directory will be. Ideally this should be
    inside your home directory. Once you have decided on where the code will be
    stored, open up a terminal and checkout the code:
        svn co ssh+svn://your-kerberos-id@svn.mit.edu/permit/permit_projects \
            /path/to/working/dir
        
10: Once the checkout completes you should reopen NetBeans and open each of the
    projects. There will be errors and missing dependencies. In most of the
    cases the errors will simply be relating to missing JAR files; the projects
    contain the proper versioning information for these files so just let
    NetBeans download them for you. The proper build order is:
    
    permitlibrary   ->  permitService   -> permitclient
                                        -> permitws
    
[04/29/2010]
To Be Completed...


==================
Known build issues
==================
    permitlibrary:
        No serious errors
        
    PermitService:
        Without modifications, this build will fail due to failed tests.
        1) To force maven to skip the tests:
              a) Right click the "PermitService" project
              b) Go to "Custom" and select "Goals..."
              c) In the "Goals:" field type "install"
              d) Make sure "Skip Tests" is checked off
              e) Check off "Remember as:" and fill in a name (ie:
                  "Build (Skip Tests)")
              f) Press "OK". The compilation should be reattempted and it
                  should succeed. To rebuild the project, go to the "Custom"
                  menu and select your custom goal.
                
    permitws:
        Will not build without modifications.
        
        1) There are two dependency elements for permitservice-1.0.jar in the "pom.xml"
            On a case-insensitive FS the project will properly handle both
            but on a case-sensitive FS (ie: HFS+-CS, ext*) maven will blow
            up. To fix this find the entry for
            "edu.mit.ista.permitservice:permitservice:1.0:jar" and delete
            it. The entry for "edu.mit.ista.permitservice:permitService:1.0:jar"
            (notice the capitalization!) should still remain.
        
        2) In "src/main/resources/log4j.properties", change "${WSETCDIR}" to
            "${env.WSETCDIR}"

    permitclient:
        Will not deploy without modifications.
        
        1) The "META-INF/context.xml" Context element has incorrect case. The path
            attribute should be '/permitclient', not '/permitClient'
        
        2) In "permitclient.java":
            The value of the below system properties are NOT respected (actually,
            the system properties are overwritten) and required to be in a file
            called "config.properties" in $WSETCDIR. The below mappings are in
            the form: Java Property => Config File Property.
                javax.net.ssl.keyStore              => KeyStore.File
                javax.net.ssl.keyStorePassword      => KeyStore.Password
                javax.net.ssl.trustStore            => TrustStore.File
                javax.net.ssl.trustStorePassword    => TrustStore.Password
            
        3) Maven will query the wsdl description at ws-dev.mit.edu by default.
            You can change this to point to your local deployment by changing
            the value of the "service.wsdl" element in the "pom.xml" file.
            Your local host MUST have a valid KeyStore entry in the
            "config.properties" file otherwise the WSDL query will abort.
            
        4) The "client.keystore" element in the "pom.xml" points to a fixed path.
            Replace the text of the "client.keystore" element with:
                ${env.WSETCDIR}/keystore/mapping.app.mit.edu
    
        5) The "server.truststore" element in the "pom.xml" points to a fixed path.
            Replace the text of the "server.truststore" element with:
                ${env.WSETCDIR}/keystore/serverTrustStore.jks
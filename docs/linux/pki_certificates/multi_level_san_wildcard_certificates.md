# multi_level_SAN_wildcard_certificates

# Multi-Level Subdomain (SANs) Wildcard SSL Certificate Management with EasyRSA

## Overview

In some circumstacnes it's desirable to match multiple levels of wildcards in an SSL certificate.  One example is limiting the amount of 'internal' certificates to manage for multiple evnironment tiers such as dev,qa,stage,test,etc. Whose domain names are in the format n.foo.com, where n is a numeric identifier of the tier), where having a certificate which matches something like web1.dev.foo.com and also web1.qa.foo.com would be needed.

The method to do this is with the subjectAltName extension (which is an alias within the certificate for the subject of the certificate, abbreviated SAN) for each subdomain which we want to wildcard.

One caveat is that if SANs are in use they must also contain the commonName (CN) as an alternate name, since the browser will ignore the CN in that case (in this example, a SAN for *.foo.com and foo.com would be added).



## Create/Update OpenSSL Configuration File

SANs are added to the certificate when the certificate signing request is created.  The safest way to do this is to create a copy of EasyRSAs openssl.cnf file.  This allows you to build certificates that do NOT contain SANs by default.

> EasyRSA uses the same OpenSSL configuration file (cnf) for both request generation and signing

In order to determine the current openssl configuration file used by EasyRSA switch to the user that manages your certficiates and view the $KEY_CONFIG variable 

````
echo $KEY_CONFIG
/home/ca/openssl-1.0.0.cnf
````

Now create a copy of this openssl configuration file.  I suggest giving it a name that describes the top level domain you'll be creating a wildcard for.  For example openssl-*.foo.com.cnf

````
cp /home/ca/openssl-1.0.0.cnf openssl-*.foo.com.cnf
````

### Update OpenSSL Settings for Certificate Request Generation (CSR)

Uncomment or Add the line containing **req_extensions = v3\_req** to allow the extentions to be added to the certificate request CSR.

````
req_extensions = v3_req # The extensions to add to a certificate request
````

Next in the **[v3_req]** section, add the SANs sectional reference (**subjectAltName = @alt_names**).  You can also add them inline if desired

````
[ v3_req ]

# Extensions to add to a certificate request

basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
````

Then add the setion **[alt_names]** in the file

> Note that in the DNS.n lines, the n enumerates the entry number starting at 1.

````
[ v3_req ]

# Extensions to add to a certificate request

basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ alt_names ]

DNS.1 = foo.com
DNS.2 = *.foo.com
DNS.3 = *.dev.foo.com
DNS.4 = *.qa.foo.com
````

### Update OpenSSL Settings for Certificate Creation/Signing

Uncomment or Add the line containing **copy_extensions = copy**. This line ensures that the v3 extension sections for subjectAltNames are copied from the CSR into the newly minted certificate. The reason that this is commented out by default is that it introduces a security risk.  For example if a certificate request contains a basicConstraints extension with CA:TRUE and the copy_extensions value is set to copyall and the user does not spot this when the certificate is displayed then this will hand the requester a valid CA certificate.

````
[ CA_default ]

dir             = $ENV::KEY_DIR         # Where 
...
...
...
RANDFILE        = $dir/.rand            # private random number file

x509_extensions = usr_cert              # The extentions to add to the cert
copy_extensions = copy                  # https://www.openssl.org/docs/apps/ca.html#WARNINGS
````

## Build and Sign Wildcard Certificate/Key

Before building and/or signing a certificate request we need to point EasyRSA to use the custom OpenSSL configuration file we created.  The eaiest way to do this is to export a new **KEY_CONFIG** parameter set by the **vars** file
 
````
export KEY_CONFIG=/home/ca/openssl-*.foo.com.cnf
```` 

Verify the parameter is correctly set

````
echo $KEY_CONFIG
/home/ca/openssl-1.0.0.cnf
````

When creating a wildcard certificate for the first time you can use the **build-key-server** script bundled with EasyRSA

````
$ ./build-key-server *.foo.com-server
Generating a 2048 bit RSA private key
...................+++
.........................................................................+++
writing new private key to '*.foo.com-server.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [US]:
State or Province Name (full name) [NY]:
Locality Name (eg, city) [Metropolis]:
Organization Name (eg, company) [LexCorp]:
Organizational Unit Name (eg, section) [Weapons Manufacturing]:
Common Name (eg, your name or your server's hostname) [*.foo.com-server]:*.foo.com
Name []:*.foo.com-server
Email Address [root@ca.example.dev]:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
Using configuration from /home/ca/openssl-*.foo.com.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'US'
stateOrProvinceName   :PRINTABLE:'NY'
localityName          :PRINTABLE:'Metropolis'
organizationName      :PRINTABLE:'LexCorp'
organizationalUnitName:PRINTABLE:'Weapons Manufacturing'
commonName            :T61STRING:'*.foo.com'
name                  :T61STRING:'*.foo.com-server'
emailAddress          :IA5STRING:'root@ca.example.dev'
Certificate is to be certified until Jun 21 13:15:42 2025 GMT (3650 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
````

## "Update"/Build New Wildcard Certificate

If you need to add or remove SANs from the wildcard certificate a new certificate Signing Request and Certifcate must be built.  This new Singing Request and Certificate will still use the original key.

Update the OpenSSL configuration file (cnf) to add or remove the needed SANs

> Note that in the DNS.n lines, the n enumerates the entry number starting at 1.

````
vim openssl-\*.foo.com.cnf
````

Before a new Singing Request and Certificate can be built/generated we must revoke the old certificate.  This can be accomplished using the **revoke-full** script bundled with EasyRSA

````
./revoke-full \*.foo.com-server
Using configuration from /home/ca/openssl-*.foo.com.cnf
Revoking Certificate 14.
Data Base Updated
Using configuration from /home/ca/openssl-*.foo.com.cnf
*.foo.com-server.crt: C = US, ST = NY, L = Metropolis, O = LexCorp, OU = Weapons Manufacturing, CN = *.foo.com, name = *.foo.com-server, emailAddress = root@ca.example.dev
error 23 at 0 depth lookup:certificate revoked
````

After the old certificate is revoke a new Signing Request must be generated using the current Key. This can be accomplished by calling the openssl command directly to build a new signing request

````
openssl req -new -key keys/\*.foo.com-server.key -out keys/\*.foo.com-server.csr -config openssl-\*.foo.com.cnf

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [US]:
State or Province Name (full name) [NY]:
Locality Name (eg, city) [Metropolis]:
Organization Name (eg, company) [LexCorp]:
Organizational Unit Name (eg, section) [Weapons Manufacturing]:
Common Name (eg, your name or your server's hostname) [CHANGEME]:*.foo.com
Name []:*.foo.com-server
Email Address [root@ca.example.dev]:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
````

Next build/generate and sign the certificate from the signing request.  This can be accomplished using the **sign-req** script bundled with EasyRSA

````
./sign-req *.foo.com-server
Using configuration from /home/ca/openssl-*.foo.com.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'US'
stateOrProvinceName   :PRINTABLE:'NY'
localityName          :PRINTABLE:'Metropolis'
organizationName      :PRINTABLE:'LexCorp'
organizationalUnitName:PRINTABLE:'Weapons Manufacturing'
commonName            :T61STRING:'*.foo.com'
name                  :T61STRING:'*.foo.com-server'
emailAddress          :IA5STRING:'root@ca.example.dev'
Certificate is to be certified until Jun 21 13:31:50 2025 GMT (3650 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
````


# Create LDAP Authorization For A Website

Create Virtual Host for you site

Navigate to Virtual host .conf file

````bash
cd /etc/httpd/conf.d/x.conf
````

Edit the virutal host .conf file

````
vi /etc/httpd/conf.d/x.conf

<Location />     <--This is the location on the website that you want to password protect
      AuthName "MKI REPO"    <--This is the name that shows up on the pop up asking for password
      AuthType Basic      <-- This is the authentication type
      AuthBasicProvider ldap     <-- This is the authentication provider (ldap)
      AuthzLDAPAuthoritative Off    <-- Not sure 
      AuthLDAPBindDN uid=svnldapuser,ou=Users,dc=mkisystems,dc=com   <-- This is the user that binds and searches ldap db
      AuthLDAPBindPassword <`d5E>Q0RnA(c;eM=q72              <-- This is the users password for ldap auth
      AuthLDAPURL ldap://127.0.0.1/ou=Users,dc=mkisystems,dc=com     <-- This is the ldap db to connect to
      AuthLDAPGroupAttribute memberUid   <-- this is the attribute that is searched for
      AuthLDAPGroupAttributeIsDN off  <-- Not sure
      Require ldap-group cn=SVN,ou=Groups,dc=mkisystems,dc=com  <-- This is the group in which members but be a part of to Auth
</Location>
````


# Creating an ACL to monitor IP traffic only and block or allow IP traffic

When you create an access list you must give the list a number to identify it. If you create use numbers 1-99 you will be creating an standard access list which limits what you can block. Usually when you use a standard ACL you just one to block traffic from one network/host to another. Extended access list use numbers between 100-199 and a range in the 2000's which i can't find the exact range:

Examples: Environment setup Washington DC office network: 192.168.100.0/24 New York City Office network: 192.168.200.0/25 Washington DC SIP Server- 192.168.100.50

Lets allow port 80 traffic to any host from washington dc access-list 101 permit tcp 192.168.100.0 0.0.0.255 any eq 80

````
101=Access-list number
tcp=traffic protocol  
192.168.100.0- Network
0.0.0.255- Wildcard for network subnet
any= any destination
eq 80- Destination port equals 80
````

Allow SIP traffic from New York to DC SIP server access-list 102 permit udp 192.168.200.0 0.0.0.63 host 192.168.100.50 eq 5060 log-input

````
102- Access-list number
udp- protocol type
192.168.200.0- source network
0.0.0.63- wildcard notation for /25 network
host- traffic is going to a specific ip address
eq 5060- Destination port equals 5060
log-input- will log every time rule is meet. Very useful command for troubleshooting.
````

Note! If CBAC is not allowed you must allow the return traffic as well otherwise your traffic will be blocked````

How To Apply ACL
----------------
 1. Enable mode
 1. Configure terminal
 1. Go into interface config mode
 1. IP access-group <ACLnumber> in/out -no ip access-group <ACLnumber> in/out will remove the ACL

Start to finish example: allowing sip traffic from New york to Washington DC server using interface ethernet 0/0

````
login in to cisco router
enable
configure terminal
access-list 102 permit udp 192.168.200.0 0.0.0.63 host 192.168.100.50 eq 5060 log-input
int eth 0/0
ip access-group 102 in
end
````

Lessons learned
---------------

 * I find it much easier to use a text file to edit ACL's then to do them directly on the router.
 * Once you hit enter the ACL is applied. You can and probably will inadvertently disconnect your connection. At that point you can either console into the router, or power off and power on
 * From enable prompt, enter “reload in <minute time>” Tells the router to power off and power on after “x” amount of minutes. Useful if you are working off site, and after hours
 * Allow yourself more than one point of entry into the router, or utilize the “reload in” command
 * Access-list read top to bottom. Once the packet meets a rule it no longer processing the remaining rules.



# DIG Information

## Response Header Values

**Flags:**

* AA = Authoritative Answer

* TC = Truncation

* RD = Recursion Desired (set in a query and copied into the response if recursion is supported)

* RA = Recursion Available (if set, denotes recursive query support is available)

* AD = Authenticated Data (for DNSSEC only; indicates that the data was authenticated)

* CD = Checking Disabled (DNSSEC only; disables checking at the receiving server)

**Response code:**

* 0 = NOERR, no error

* 1 = FORMERR, format error (unable to understand the query)

* 2 = SERVFAIL, name server problem

* 3= NXDOMAIN, domain name does not exist

* 4 = NOTIMPL, not implemented

* 5 = REFUSED (e.g., refused zone transfer requests)


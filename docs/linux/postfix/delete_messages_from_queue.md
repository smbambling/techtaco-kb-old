# Delete messages from Postfix queue

## Queue Element Variables

  - $1 = Queue Message ID
  - $2 = Message Size
  - $3 = Arrival Time Day
  - $4 = Arrival Time Month
  - $5 = Arrival Time Date
  - $6 = Arrival Time Time
  - $7 = Sender Address
  - $8 = Recipient Address

## Delete by recipient address

```shell
mailq | tail -n +2 | head -n -2 | grep -v '^ *(' | awk 'BEGIN { RS = "" } { if ($8 == "recipient@example.com") print $1 }'
| sudo postsuper -d -
```

## Delete by sender address

```shell
mailq | tail -n +2 | head -n -2 | grep -v '^ *(' | awk 'BEGIN { RS = "" } { if ($7 == "sender@example.com") print $1 }'
| sudo postsuper -d -
```

## References
  - https://www.frontline.ro/en/blog/delete-messages-from-postfix-queue-by-sender-address-and-recipient-domain

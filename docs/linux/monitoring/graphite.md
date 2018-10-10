# Graphite

Overview
--------

Graphite does two things:

 * Store numeric time-series data
 * Render graphs of data on demand

However Graphite does NOT collect any data for you.  You will need to install a seperate tool taht knows how to send data to graphite.


Graphite Architecture
---------------------


 1. **graphite webapp**: A Django webapp that renders graphs on-demand using Cairo
 1. **carbon**: Twisted daemon that listens for time-series data
 1. **whisper**: Simple database library for storing time-series data (similar in design to RRD) 

Graphite WebApp
---------------

This is where you can desing graphs that plot your data.  Allows you to save graph properties and layout in seperate dashboards for machine or application.

Carbon
------

Carbon is a collection of one or more daemons that make up the storage backend for Graphite.  Carbon daemons are responsible for handling data that is sent over by other processes that collect and transmit statistics. 

There are several Carbon daemons each that handle the recieving of data in a different way.

 * carbon-cache
 * carbon-relay
 * carbon-aggregator

**Carbon-Cache**: Listens for data on a port and writes that data to disk as it arrives, in an efficient way. This daemon stores data in RAM and then flushes it to disk after a predetermined period of time.

Note! Carbon-Cache only handles the data receiving and flushing procedures. It does not handle the actual storage mechanisms

Multiple instanaces of the Carbon-Cache daemon can be run at once as your number of inbound statistics grows.  These can be balanced by Carbon-Relay or Carbon-Aggregator

**Carbon-Relay**: Used for replication or sharding.  Either sends requrest to ALL backend daemons for redundancy or shards data across differnet Carbon-Cache instances to spread the load across multiple storage locations.

**Carbon-Aggregator**: Buffer data and then dump it to a Carbon-Cache instance for processing.

Whisper
------

Whisper is a database library used to store information that is processed via Carbon.  
Whisper allows for higher resolution (seconds per point) of recent data to degrade into lower resolutions for long-term retention of historical data.

Protocols
---------

There are three different protocols that can be used to send data to Graphite.

**Plain Text** is the most straightforward protocol supported by Carbon. 
The data sent must be in the following format: <metric path> <metric value> <metric timestamp>. 

On Unix, the nc program can be used to create a socket and send data to Carbon (by default, ‘plaintext’ runs on port 2003):
```bash
PORT=2003
SERVER=graphite.your.org
echo "local.random.diceroll 4 `date +%s`" | nc -q0 ${SERVER} ${PORT}
```

**[Pickle](https://docs.python.org/3/library/pickle.html)** is more effcient then plain text and supports sending batches of metrics to Carbon. The general idea is that the pickled data forms a list of multi-level tuples

**[AMQP](http://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol)** Messaging lets you handle large load os data more gracefully.   



References
----------

https://graphite.readthedocs.org/en/latest/overview.html
https://www.digitalocean.com/community/tutorials/an-introduction-to-tracking-statistics-with-graphite-statsd-and-collectd
https://wiki.icinga.org/display/howtos/graphite



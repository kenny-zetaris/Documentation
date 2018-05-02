########################################
Quick Start Guide for Zetaris Lightning
########################################


This document articulates all Lightning SQLs when building a virtual data lake, and running queries on top of that. The traditional approaches to data integration were using ETL where data is moving into a single platform, normally DW database. But it would incur side effects such as data duplication, extra processing for ETL, and of course extra h/w and s/w for a D/W as well as licensing. During these ETLs, the data structured need to be harmonized, data types resolved and relational modeling involving resolving entities and relationships across the enterprise. And then the enterprise can commence analytical processing. The whole idea is that enterprise need to move the data into a single platform in order to have an insight. But this approach is valid when building limited and static amount of data sources.
Lightning is shining where Query Federation is in place for the dynamic and unlimited data source.  Instead of moving data, Lightning ingests only meta data for the external data sources through Schema Store. Lightning provides various commands to ingest/manage meta data, accessing Schema Store. Also these are provided through  RESTful API.
All the way through this document, a user can understand identifying data source need to be registered, ingesting/accessing meta data, and running query as well as how to improve query performance.

Register data source
=====================

To build a virtual data lake, a user need to identify data base to be connected. Lightning supports all JDBC compliant DB, all know NoSQL, RestAPI, CSV, JSON file.

Register master data source
----------------------------

A user need to provide JDBC driver class, url and connectivity credentials including extra parameters database need.

Syntax:
^^^^^^^^
::
   
   CREATE DATASOURCE ORCL [DESCRIBE BY ["Oracle for Product Master"] OPTIONS (
   jdbcdriver "com.oracle.OracleDriver",
   jdbcurl "jdbc:oracle:thin@oracle-master:1521:orcl",
   username "scott",
   password "tiger",
   [key "value"]*)


``Real-world example`` showing a connection to Oracle on port 1521 of a localhost with a database name of orcl with user name scott and password tiger.
::
     
     CREATE DATASOURCE ORACLE DESCRIBE BY "Oracle for Product Master" OPTIONS (
     jdbcdriver "com.oracle.OracleDriver",
     jdbcurl "jdbc:oracle:thin@localhost:1521:orcl",
     username "scott",
     password "tiger")


Add slave nodes for the registered data source (Option for cluster based database)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

If the registered database supports cluster base computing such as MPP, then a user can register slave nodes so that Lightning can directly query to slave nodes rather than running it through the master node.
::
   
    ADD SLAVE DATASOURCE TO ORCL OPTIONS (
    jdbcdriver "com.oracle.OracleDriver",
    jdbcurl "jdbc:oracle:thin@oracle-slave1;1521:orcl",
    username "scott",
    password "tiger",
    [key "value"])*

::
    
     ADD SLAVE DATASOURCE TO ORCL OPTIONS (
     jdbcdriver "com.oracle.OracleDriver",
     jdbcurl "jdbc:oracle:thin@oracle-slave2;1521:orcl",
     username "scott",
     password "tiger",
     [key "value"])*

::
     
     ADD SLAVE DATASOURCE TO ORCL OPTIONS (
     jdbcdriver "com.oracle.OracleDriver",
     jdbcurl "jdbc:oracle:thin@oracle-slave3;1521:orcl",
     username "scott",
     password "tiger",
     [key "value"])*



The above example shows registering 1 master node(oracle-master) and 3 slave nodes(oracle-slave1, oracle-slave2, and oracle-slave3).

ORCL is alias for the target data source which will be decided by a user when creating data source.

Register Mongo DB
++++++++++++++++++++

For MongoDB, the below 5 parameters(host, port, db name, user name and password) must be provided.

::
   
    CREATE DATASOURCE MONGO DESCRIBE BY "MongoDB" OPTIONS ( 
    lightning.datasource.mongodb.host "localhost", 
    lightning.datasource.mongodb.port "27017", 
    lightning.datasource.mongodb.database "lightning-demo", 
    lightning.datasource.mongodb.username "", 
    lightning.datasource.mongodb.password "" 
    ) 



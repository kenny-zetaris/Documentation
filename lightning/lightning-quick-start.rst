########################################
Quick Start Guide For Zetaris Lightning
########################################


This document articulates all Lightning SQLs when building a virtual data lake, and running queries on top of that. The traditional approaches to data integration were using ETL where data is moving into a single platform, normally DW database. But it would incur side effects such as data duplication, extra processing for ETL, and of course extra h/w and s/w for a D/W as well as licensing. During these ETLs, the data structured need to be harmonized, data types resolved and relational modeling involving resolving entities and relationships across the enterprise. And then the enterprise can commence analytical processing. The whole idea is that enterprise need to move the data into a single platform in order to have an insight. But this approach is valid when building limited and static amount of data sources.

Lightning is shining where Query Federation is in place for the dynamic and unlimited data source.  Instead of moving data, Lightning ingests only meta data for the external data sources through Schema Store. Lightning provides various commands to ingest/manage meta data, accessing Schema Store. Also these are provided through  RESTful API.

All the way through this document, a user can understand identifying data source need to be registered, ingesting/accessing meta data, and running query as well as how to improve query performance.

Register Data Source
=====================

To build a virtual data lake, a user need to identify data base to be connected. Lightning supports all JDBC compliant DB, all know NoSQL, RestAPI, CSV, JSON file.

Register Master Data Source
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

Register Cassandra
+++++++++++++++++++

For Cassandra, there is only on parameter for Lightning, which is key space for this connection. the other parameters start with "spark.cassandra" prefix, which is actually provided for Spark Cassandra connector(https://github.com/datastax/spark-cassandra-connector). ::

      CREATE DATASOURCE CSNDR DESCRIBE BY "Cassandra" OPTIONS ( 
      spark.cassandra.connection.host "localhost", 
      spark.cassandra.connection. port "9042", 
      spark.cassandra.auth.username "cassandra", 
      spark.cassandra.auth. password "cassandra", 
      lightning. datasource .cassandra.keyspace "lightning_demo" 
      ) 

Register RESTful API
+++++++++++++++++++++

For RESTful API, need to provide url. The actual end point will be provided when registering table
::

       CREATE REST DATASOURCE SAFC DESCRIBE BY "Sales Forces" OPTIONS ( url "http://localhost:9998") 

Ingest meta data
=================

Once the data source is registered, then a user need to ingest meta data such as table, column and all constrains. A user can ingest meta data for all data sources except RESTful API.

Ingest all tables from the data source
---------------------------------------
::
     
       REGISTER DATASOURCE TABLES FROM ORCL; 

This command will connect to ORCL data base, and ingest all metadata(tables, columns and all constraints) into Schema Store

Ingest a table from the data source
------------------------------------
::

     REGISTER DATASOURCE TABLE USER [USER_ALIAS] FROM ORCL

This will register "USER" table only

Ingest a RESTful Service
------------------------

For the RESTful service when returns JSON format, a user need to provide end point, HTTP method, encoding type as well as schema.::

     REGISTER REST DATASOURCE TABLE SAFC_USERS FROM SAFC SCHEMA ( 
     uid Long, 
     gender String, 
     age Integer , 
     job String, 
     ts String) 
     OPTIONS ( 
     endpoint "/example/users", 
     method "GET", 
     requesttype "URLENCODED" 
     ); 

Other parameter for the API call, such as security key, can be provided in OPTIONS field. 

Manage Schema Store
====================

Lightning provides various commands to manage meta data in the schema store. Also, these will be provided via RESTful service.

Data Source
------------

(Show Data Source)

This command shows the data sources registered in the schema store::

    SHOW DATASOURCES 

(Drop Data Source)

This command drop the registered data source as well as all tables under that.::
   
    DROP DATASOURCE ORCL 

(Describe Data Source)::
 
     DESCRIBE DATASOURCE ORCL

(Describe Slave Data Source)::
 
    DESCRIBE SLAVE DATASOURCE ORCL

Table
-------

(Describe data source table)::
    
    DESC ORCL.USERS 

(Show all tables)::
     
     SHOW TABLES

(Show data source tables)::
    
    SHOW DATASOURCE TABLES ORCL 

(Drop Table)::

     DROP TABLE ORCL.USERS

View
-----

Lightning supports view wich is query definition across all data sources

(Create Data Source View)
^^^^^^^^^^^^^^^^^^^^^^^^^^
::
      
     CREATE DATASOURCE VIEW TEEN_AGER FROM ORCL  AS 
     SELECT * FROM USERS WHERE AGE >= 13 AND AGE < 20 
     the TEEN_AGER view belongs to ORCL data source. 
     (Create Pure Virtual View) 
     This view can define on top of schema store, which means that query definion can run across all data sources. 
     CREATE DATASOURCE VIEW TOP10_MOVIES_FOR_TEENS AS 
     SELECT movies_from_oracle.title, user_rating. count , user_rating. min , user_rating. max , user_rating. avg 
     FROM ( 
     SELECT iid, count ( * ) count , min (pref) min , max (pref) max , avg (pref) avg 
     FROM TRDT.ratings ratings_from_teradata, PGRS.users users_from_postgres 
     WHERE users_from_postgres.age >= 13 AND users_from_postgres.age < 20 
     AND ratings_from_teradata.uid = users_from_postgres.uid 
     GROUP BY ratings_from_teradata.iid 
     ORDER BY avg DESC 
     LIMIT 20 
     ) AS user_rating, ORCL.movies movies_from_oracle 
     WHERE movies_from_oracle.iid = user_rating.iid 
     This view can be queried like normal table : 
     SELECT * FROM TOP10_MOVIES_FOR_TEENS 
     It belongs to "Schema Store View" 

(Drop View)
^^^^^^^^^^^^
::
     
     DROP VIEW ORCL.TEEN_AGER; 

Run Query
==========

Lightning supports SQL2003. Also, it can run all 99 TPC-DS queries. As long as a data source registered into schema store, query can across all data sources.

For example the following query run join query across three different data sources(Teradata ↔ Oracle ↔ Cassandra),::

     SELECT  users_from_cassandra.age, users_from_cassandra.gender, movies_from_oracle.title title, ratings_from_teradata.pref, ratings_from_teradata.ts 
     FROM TRDT.ratings ratings_from_teradata, ORCL.movies movies_from_oracle, CSNDR.users users_from_cassandra 
     WHERE users_from_postgres.gender = 'F' 
     AND ratings_from_teradata.uid = users_from_postgres.uid 
     AND movies_from_oracle.iid = ratings_from_teradata.iid 

Materialization and Cache
==========================

For some reasons, for example query performance, all data source tables or views can be materialized by leveraging Zetaris Fusion DB. Also, Lightning support Cache capabilities where a user can load all data into main memory.

(Materialization) 
----------------------

For example the following query materialize all data from RESTful Service to USER_FOR_COPY table in fusion db.::

     INSERT INTO FUSIONDB.USERS_FOR_COPY 
     SELECT uid, gender, age, job , ts FROM SAFC.SAFC_USERS 

(Cache/Uncache)
----------------

A user can load all data into main memory by leverging cache capability and also, uncache it anytime.
::
     
     CACHE TABLE pref; 
     CACHE TABLE ORCL.movies; 

The pref, ORCL.moves table are chaned now, and the following query performs a lot better : 
::
     
     SELECT movies_from_oracle.title, hdfs_pref. count , hdfs_pref. min , hdfs_pref. max , hdfs_pref. avg 
     FROM ( 
     SELECT iid, count ( * ) count , min (pref) min , max (pref) max , avg (pref) avg 
     FROM pref 
     GROUP BY iid 
     ) AS hdfs_pref, ORCL.movies movies_from_oracle 
     WHERE movies_from_oracle.iid = hdfs_pref.iid 
     These tables uncached any time 
     UNCACHE TABLE pref 
     UNCACHE TABLE ORCL.movies 

Statistics
===========

Lighting come up with CBO(Cose Based Optimizer) to reduce data shuffling across cluster. To do this, Lighting keeps statistics for the data source. There are two types of statistics, the one is table level statistics and the other is column level statistics.

(Table level statistics)
-------------------------

::
     
     ANALYZE DATASOURCE TABLE ORCL.MOVIES 
     This command generate statistics such as size in bytes, cardinality for the table, and these are browsed by the following command : 
     SHOW DATASOURCE TABLE STATISTICS ORCL.MOVIES 

(Column level statistics)
--------------------------

::
      
     ANALYZE DATASOURCE TABLE ORCL.MOVIES COMPUTE STATISTICS FOR COLUMNS (IID, TITLE) 
     This command generate statistics such as cardinality, number of null, min, max, average value, and these are browsed by the following commabd : 
     SHOW DATASOURCE COLUMN STATISTICS ORCL.MOVIES; 

Partitioning
=============

Query performance can be improved by partitioning table. What partitioning means here is that all records are splitted into multiple partitions and these are processed independently in each worker node.
::
       
     CREATE DATASOURCE PARTITION ON ORCL.USERS OPTIONS ( 
     COLUMN "UID", 
     COUNT "2", 
     LOWERBOUND "1", 
     UPPERBOUND "6040") 
     This command makes two partitions based on the "UID" column. lower/upper bound provides boundary value for the partition. This partition can be removed by : 
     DROP DATASOURCE PARTITION ON ORCL.USERS 

Import CSV file
================

Lighting supports CSV file and running query on top of it. A CSV can be imported by either :

(Hive syntax)
--------------
::
     
     CREATE EXTERNAL TABLE pref (uid INT, iid INT, pref FLOAT, ts STRING)
     ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
     LOCATION 'csv directory'

With the syntax, a user can import other file format than csv(tsv for example). But this doesn't support :

1.  Header
    CSV header must be got rid of.
2.  LOCATION must be directory. Create a directory, and place csv file there
3.  For directory in s3 bucket, csv directory looks like “s3n://mys3bucket/perf/”

 OR

(Lightning Syntax)
-------------------

::
       
     CREATE TABLE pref
     USING com.databricks.spark.csv
     OPTIONS (path "file path", header "true", inferSchema "true")

With this syntax, user can do :

1.  infer schema
2.  support header
3.  support a single file
4.  ``file path`` in Amazon s3 looks like ``s3n://mys3bucket/perf/pref.csv``




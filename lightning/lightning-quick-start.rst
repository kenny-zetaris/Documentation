########################################
Quick Start Guide For Zetaris Lightning
########################################


This document articulates all Lightning SQLs when building a virtual data lake, and running queries on top of that. The traditional approaches to data integration were using ETL where data is moving into a single platform, normally DW database. But it would incur side effects such as data duplication, extra processing for ETL, and of course extra h/w and s/w for a D/W as well as licensing. During these ETLs, the data structured need to be harmonized, data types resolved and relational modeling involving resolving entities and relationships across the enterprise. And then the enterprise can commence analytical processing. The whole idea is that enterprise need to move the data into a single platform in order to have an insight. But this approach is valid when building limited and static amount of data sources.

Lightning is shining where Query Federation is in place for the dynamic and unlimited data source.  Instead of moving data, Lightning ingests only meta data for the external data sources through Schema Store. Lightning provides various commands to ingest/manage meta data, accessing Schema Store. Also these are provided through  RESTful API.

All the way through this document, a user can understand identifying data source need to be registered, ingesting/accessing meta data, and running query as well as how to improve query performance.

Register Logical Datasources
=============================

To build a virtual data lake, a user need to identify data base to be connected. Lightning supports all JDBC compliant DB, all know NoSQL, RestAPI, CSV, JSON file.

Register Clustered Databases
----------------------------

Register Master Datasources
^^^^^^^^^^^^^^^^^^^^^^^^^^^

A user need to provide JDBC driver class, url and connectivity credentials including extra parameters database need.

**Syntax:**

.. highlight:: sql

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


Add Slave Nodes
^^^^^^^^^^^^^^^

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

\*ORCL is alias for the target data source which will be decided by a user when creating data source.
\*If schema is provided, Lightning will only ingest metadata from that schema
\*If schema_prepended_table is set to true, schema will be prepended to the table name as there may be same tables using the same name across different schemas. 
For example, role table in zetaris_bi schema will be named zetaris_bi__role

Register RDBMS Datasource
-------------------------

MS SQL Server
^^^^^^^^^^^^^^
.. highlight:: sql

::

    CREATE DATASOURCE MSSQL DESCRIBE BY "MSSQL-2017-linux " OPTIONS (
      jdbcdriver "com.microsoft.sqlserver.jdbc.SQLServerDriver",
      jdbcurl "jdbc:sqlserver://localhost:1433 ",
      databaseName "DemoData",
      username "scott" ,
      password "tiger",
      schema “dbo”
    )

My SQL
^^^^^^

::

    CREATE DATASOURCE MY_SQL DESCRIBE BY "MySQL " OPTIONS (
      jdbcdriver "com.mysql.jdbc.Driver",
      jdbcurl "jdbc:mysql://127.0.0.1/test_db?",
      username "scott" ,
    password "tiger
    )
    (IBM DB2)
    CREATE DATASOURCE DB2_DB2INST1 DESCRIBE BY "DB2 Sample DB Schema " OPTIONS (
      jdbcdriver "com.ibm.db2.jcc.DB2Driver",
      jdbcurl "jdbc:db2://127.0.0.1:50000/db_name",
      username "db2inst1" ,
      password "db2inst1-pwd",
      schema "DB2INST1",
      schema_prepended_table "true"
    )

Green Plum
^^^^^^^^^^

::

    CREATE DATASOURCE GREEN_PLUM  DESCRIBE  BY  "GREEN_PLUM " OPTIONS (
      jdbcdriver "org.postgresql.Driver",
      jdbcurl "jdbc:postgresql://localhost:5432/postgres",
      username "gpadmin" ,
      password "pivotal",
      schema "public"
    )

Teradata
^^^^^^^^

::

    CREATE DATASOURCE TERA_DATA DESCRIBE BY "TERA_DATA " OPTIONS (
      jdbcdriver "com.teradata.jdbc.TeraDriver",
      jdbcurl "jdbc:teradata://10.128.87.16/DBS_PORT=1025",
      username "dbc" ,
      password "dbc",
      schema "dbcmngr"
    )

Amazon Aurora
^^^^^^^^^^^^^

::
    
    CREATE DATASOURCE AWS_AURORA DESCRIBE BY "AWS_AURORA " OPTIONS (
      jdbcdriver "com.mysql.jdbc.Driver",
      jdbcurl "jdbc:mysql://zet-aurora-cluster.cluster-ckh4ncwbhsty.ap-southeast-2.rds.amazonaws.com/your_db?",
      username "your_db_account_name" ,
      password "your_db_account_password""
    )

Amazon Redshift
^^^^^^^^^^^^^^^

::

    CREATE DATASOURCE REDSHIFT DESCRIBE BY "AWS RedShift" OPTIONS (
      jdbcdriver "com.amazon.redshift.jdbc.Driver",
      jdbcurl "jdbc:redshift://zetaris.cyzoanxzdpje.ap-southeast-2.redshift.amazonaws.com:5439/your_db_name",
      username "your_db_account_name",
      password "your_db_account_password"
    )

Register NOSQL Datasource
-------------------------

Register Mongo DB
^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^

For Cassandra, there is only on parameter for Lightning, which is key space for this connection. the other parameters start with "spark.cassandra" prefix, which is actually provided for Spark Cassandra connector(https://github.com/datastax/spark-cassandra-connector). ::

      CREATE DATASOURCE CSNDR DESCRIBE BY "Cassandra" OPTIONS ( 
      spark.cassandra.connection.host "localhost", 
      spark.cassandra.connection. port "9042", 
      spark.cassandra.auth.username "cassandra", 
      spark.cassandra.auth. password "cassandra", 
      lightning. datasource .cassandra.keyspace "lightning_demo" 
      ) 


Register Amazon DynamoDB
^^^^^^^^^^^^^^^^^^^^^^^^

::

    CREATE DATASOURCE AWS_DYNAMODB DESCRIBE BY "AWS DynamoDB" OPTIONS (
      accessKeyId "Your_aws_accessKeyId",
      secretKey "Your_aws_SecretAccessKey" ,
      region "ap-southeast-2"
    )



Create Physical Datasources
============================

These are datasources based on physical files residing on on-prem filestore (Local filesystem,nfs filesystem), or cloud filestores like S3 and Azure Blob.
One need to first create a lightning database and then register the respective files under this namespace .
.. highlight:: sql

::

    CREATE LIGHTNING DATABASE AWS_S3 DESCRIBE BY "AWS S3 bucket" OPTIONS (
    [key "value"]
    )

Ingest file from local filesystem
----------------------------------

::

    CREATE LIGHTNING FILESTORE TABLE pref FROM HR FORMAT (CSV | JSON)
    OPTIONS (path "file path", header "true", inferSchema "true", [key value pair]);


Ingest RESTful Service
------------------------

For the RESTful service when returns JSON format, a user need to provide end point, HTTP method, encoding type as well as schema.::
::

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

Ingest file from S3
-------------------

::
    
    CREATE LIGHTNING FILESTORE  TABLE customer FROM TPCH_S3 FORMAT CSV(JSON) OPTIONS (
      PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/customer.csv",
      inferSchema "true",
      AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
      AWSSECRETACCESSKEY "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"
    )

Ingest file from azure Blob
---------------------------

::

    CREATE  LIGHTNING  FILESTORE  TABLE customer FROM TPCH_AZBLB FORMAT CSV(JSON) OPTIONS (
      PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/customer.csv",
      inferSchema "true",
      fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
    )

Key name for security key depends on Azure Blob container, refer to Azure Blob service.


Ingest Metadata
================
Once a data source is registered in Lightning it will ingest all table, column and constraints metadata.

Ingest all tables from the data source
---------------------------------------
.. highlight:: sql

::

    REGISTER DATASOURCE TABLES FROM ORCL

This command will connect to ORCL database, and ingest all metadata(tables, columns, foreign key, index and all other constraints) into Schema Store

Ingest a table from the data source
------------------------------------

::

    REGISTER DATASOURCE TABLE "USER" [USER_ALIAS] FROM ORCL

This will register "USER" table as USER_ALIAS if alias is provided.

Update Schema
--------------
When changes were made to the target data source, a user can reflect them using update schema command:

::
    
    UPDATE DATASOURCE SCHEMA ORCL

Update description and materialised table for each relation in a data source
----------------------------------------------------------------------------


Manage Schema Store
====================

Lightning provides various commands to manage meta data in the schema store. Also, these will be provided via RESTful service.

Datasource
------------

Show Datasource
^^^^^^^^^^^^^^^^^^
This command shows the data sources registered in the schema store::
.. highlight:: sql

::

    SHOW DATASOURCES 

Drop Datasource
^^^^^^^^^^^^^^^^
This command drop the registered data source as well as all tables under that.::
   
    DROP DATASOURCE ORCL 

Describe Datasource
^^^^^^^^^^^^^^^^^^^^
::
    
    DESCRIBE DATASOURCE ORCL

Describe Slave Datasource
^^^^^^^^^^^^^^^^^^^^^^^^^^

::
    
    DESCRIBE SLAVE DATASOURCE ORCL

Table
-------

Describe data source table
^^^^^^^^^^^^^^^^^^^^^^^^^^
.. highlight:: sql

::
    
    DESC ORCL.USERS 

Show all tables
^^^^^^^^^^^^^^^
::
    
    SHOW TABLES

Show data source tables
^^^^^^^^^^^^^^^^^^^^^^^
::
    
    SHOW DATASOURCE TABLES ORCL 

Drop Table
^^^^^^^^^^
::
    
    DROP TABLE ORCL.USERS

View
-----

Lightning supports the view capability with query definition on a single data source or across multiple data sources

Create Data Source View
^^^^^^^^^^^^^^^^^^^^^^^^
.. highlight:: sql

::
      
     CREATE DATASOURCE VIEW TEEN_AGER FROM ORCL  AS 
     SELECT * FROM USERS WHERE AGE >= 13 AND AGE < 20 
     
the TEEN_AGER view belongs to ORCL data source. 
With this capability a user can create a view with DBMS native query, which is really handy :

::
    
    CREATE DATASOURCE VIEW SALARY_RANK FROM ORCL AS
      SELECT department_id, last_name, salary, RANK() OVER (PARTITION BY department_id ORDER BY salary) RANK
      FROM employees
      WHERE department_id = 60
      ORDER BY RANK, last_name
    SELECT * FROM ORCL.SALARY_RANK will produce :

    DEPARTMENT_ID LAST_NAME                     SALARY       RANK
    ------------- ------------------------- ---------- ----------
               60 Lorentz                         4200          1
               60 Austin                          4800          2
               60 Pataballa                       4800          2
               60 Ernst                           6000          4
               60 Hunold                          9000          5

Also, those views can be join with other tables in other data sources.

Create Schema Store View
^^^^^^^^^^^^^^^^^^^^^^^^
This view can across different data sources.

::
    
    CREATE DATASOURCE VIEW TOP10_MOVIES_FOR_TEENS AS
      SELECT movies_from_oracle.title, user_rating.count, user_rating.min, user_rating.max, user_rating.avg
      FROM(
        SELECT iid, count(*) count, min(pref) min, max(pref) max, avg(pref) avg
        FROM TRDT.ratings ratings_from_teradata, PGRS.users users_from_postgres
        WHERE users_from_postgres.age >=13AND users_from_postgres.age <20
        AND ratings_from_teradata.uid = users_from_postgres.uid
        GROUP BY ratings_from_teradata.iid
        ORDER BY avg DESC
        LIMIT20
    ) AS user_rating, ORCL.movies movies_from_oracle
    WHERE movies_from_oracle.iid = user_rating.iid

This view can be queried like normal table :

::
    
    SELECT*FROM TOP10_MOVIES_FOR_TEENS

Drop View
^^^^^^^^^^
::
     
     DROP VIEW ORCL.TEEN_AGER; 

Run Query
==========

Lightning supports SQL2003. Also, it can run all 99 TPC-DS queries. As long as a data source registered into schema store, query can across all data sources.

For example the following query run join query across three different data sources(Teradata ↔ Oracle ↔ Cassandra),

::

     SELECT  users_from_cassandra.age, users_from_cassandra.gender, movies_from_oracle.title title, ratings_from_teradata.pref, ratings_from_teradata.ts 
     FROM TRDT.ratings ratings_from_teradata, ORCL.movies movies_from_oracle, CSNDR.users users_from_cassandra 
     WHERE users_from_postgres.gender = 'F' 
     AND ratings_from_teradata.uid = users_from_postgres.uid 
     AND movies_from_oracle.iid = ratings_from_teradata.iid 

Materialization and Cache
==========================

For some reasons, for example query performance, all data source tables or views can be materialized by leveraging Zetaris Fusion DB. Also, Lightning support Cache capabilities where a user can load all data into main memory.

Materialization
----------------

For example the following query materialize all data from RESTful Service to USER_FOR_COPY table in fusion db.::

     INSERT INTO FUSIONDB.USERS_FOR_COPY 
     SELECT uid, gender, age, job , ts FROM SAFC.SAFC_USERS 

Cache/Uncache
---------------

A user can load all data into main memory by leverging cache capability and also, uncache it anytime.

.. highlight:: sql

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

Table level statistics
-----------------------
.. highlight:: sql

::
     
     ANALYZE DATASOURCE TABLE ORCL.MOVIES 
     This command generate statistics such as size in bytes, cardinality for the table, and these are browsed by the following command : 
     SHOW DATASOURCE TABLE STATISTICS ORCL.MOVIES 

Column level statistics
------------------------
.. highlight:: sql

::
      
     ANALYZE DATASOURCE TABLE ORCL.MOVIES COMPUTE STATISTICS FOR COLUMNS (IID, TITLE) 
This command generate statistics such as cardinality, number of null, min, max, average value, and these are browsed by the following commabd : 
::
    
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

Hive syntax
------------
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

Lightning Syntax
-----------------
.. highlight:: sql

::
       
     CREATE TABLE pref
     USING com.databricks.spark.csv
     OPTIONS (path "file path", header "true", inferSchema "true")

With this syntax, user can do :

1.  infer schema
2.  support header
3.  support a single file
4.  ``file path`` in Amazon s3 looks like ``s3n://mys3bucket/perf/pref.csv``


Access Control
==============

User Management
----------------

Only admin user or users in "admin" role can add/drop user.


Add user
^^^^^^^^

1. level : admin | general
2. password doesnt allow white spaces
.. highlight:: sql

::
    
    ADD USER WITH (  
    email 'someone@zetaris.com',  
    name 'someone',  
    level 'general',  
    password '1234567'
    )

Update user password
^^^^^^^^^^^^^^^^^^^^

::

    UPDATE USER user_id SET PASSWORD 'new_password'


Describe user
^^^^^^^^^^^^^

::

    DESCRIBE USER user_id

Delete user
^^^^^^^^^^^

::

    DROP USER user_id

Show users
^^^^^^^^^^
::

    SHOW USERS


Role Based Access(RBA) control
------------------------------

The Lightning provides Role Based Access which limits a users to access a specific set of data. 
This is applied at data source level or table level in each data source. Only admin users or equivalents can run these commands


**Privileges**

- SELECT privilege - Give read access to the data source or relation
- INSERT privilege - Give insert access to the data source or relation
- CACHE privileges - Give cache access to a relation : (UN)CACHE DATASOURCE TABLE

**Predefined Roles**

Role is case insensitive
- admin
- none
- all
- default

Create Role
^^^^^^^^^^^^^

::

    CREATE ROLE role_name [DESCRIBE BY "this is blah~~~"]

Drop Role
^^^^^^^^^^^

::

    DROP ROLE role_name;

Show Roles
^^^^^^^^^^

::

    SHOW ROLES

Assign an User a Role
^^^^^^^^^^^^^^^^^^^^^^

::

    ASSIGN USER user_name [, user_name] ...TO ROLE role_name

Revoke User from Role
^^^^^^^^^^^^^^^^^^^^^^

::

    REVOKE USER user_name[, user_name] ...FROM ROLE role_name

Show Role Assigned to user
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Show all roles granted to the user

::

    SHOW ROLE ASSIGNED TO USER user_name


Show Role Assigned to user
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Show all users granted to the role

::
    
    SHOW USER ASSIGNED TO ROLE role_name


Grant
^^^^^
Granted user with GRANT OPTIONS can grant same privilege on the table.
::

    GRANT SELECT | INSERT | CACHEON table_or_view_nameTO principal_spec [,principal_spec] ...[WITH GRANT OPTION]

Revoke
^^^^^^^^^^

::

    REVOKE SELECT(INSERT | CACHE) ON table_or_view_name FROM principal_spec [,principal_spec] ...

Show Grant
^^^^^^^^^^

- Wild card can be only used in table field. for example, ORCL.\* is allowed but \*.\* or \*.movies were not allowed.

::

    SHOW GRANT[principal_specification] ON(ALL | [TABLE] table_or_view_name)
    principal_specification: USER user | ROLE roleIt will display :
    table_identifier        | principal_name  | principal_type  | privilege  | grant_option  |   grant_time                      | grantor 
    +------------------------+----------------------+--------------------+-------------+------------------+----------------------------------+----------+
    ORCL.movies         | ashutosh            | USER              | DELETE  | false              | 2018-05-07 11:44:12.301 | thejas   
    ORCL.movies         | ashutosh            | USER              | INSERT   | false              | 2018-05-07 11:44:12.301 | thejas   
    ORCL.ratings          | ashutosh            | ROLE              | SELECT  | false              | 2018-05-07 11:44:12.301 | thejas 






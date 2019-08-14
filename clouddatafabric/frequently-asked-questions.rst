###########################
Frequently Asked Questions
###########################

Where is my data stored?
=========================

The only data stored in the Cloud Fabric is data that is cached by the user. 
The Cloud Data Fabric provides the ability to query the data whilst leaving the data in place.
Only query specific data is ever transferred to the Cloud Data Fabric to generate a result.
Data that is stored in Azure or Amazon storage or databases is readily accessible. Any database that is accessible over the internet can also be accessed.
Data can be cached in memory to improve performance if the response of the source database or storage is slow.
Reference on how to cache and uncache data can be found in Zetaris Cloud Data Fabric SQL Guide - ver 2.1.0


My query stops running after 2 seconds
=======================================


The Zetaris Cloud Data Fabric allows users to run a short query on data sources as a way of validating connectivity. 
Any SQL operation which is more involved needs to occur from within a Virtual Data Warehouse or Virtual DataMart - a construct that is specifically designed for complex or involved data operations.  

Information on setting up your virtual data source can be found in Cloud Data Fabric Quick-Start Guide
=======================================================================================================


Connecting to test data sources
--------------------------------
To allow the testing of the Cloud Data Fabric a number of data sets have been created.


Three different databases in Azure and AWS, along with BLOB and s3 bucket files have been created.


Access to these requires the definition of the metadata within the cloud data fabric which is achieved by:

1. Creating the data source, and Registering the data source for databases.
2. Creating Databases for s3 and BLOB files
3. Once the data sources have been defined the data can then be queried using the SQL editor.



The following commands should be executed within the SQL Editor on the Schema Store View page 
of the GUI to define and register the desired data sources;


AWS Datasources
^^^^^^^^^^^^^^^
**AWS_RDSH Datasource:**

::
    
      CREATE DATASOURCE AWS_RDSH DESCRIBE BY "AWS_RDSH" OPTIONS (

          jdbcdriver "com.amazon.redshift.jdbc.Driver",
          jdbcurl "jdbc:postgresql://zetaris.cyzoanxzdpje.ap-southeast-2.redshift.amazonaws.com:5439/zetredshift",
          username "aws_test_data" ,
          password "Tcph_Data_1"
      );
      REGISTER DATASOURCE TABLES FROM AWS_RDSH;


**AWS_ORCL Datasource:**

::

      CREATE DATASOURCE AWS_ORCL DESCRIBE BY "AWS_ORCL" OPTIONS (
          jdbcdriver "com.amazon.redshift.jdbc.Driver",
          jdbcurl "jdbc:postgresql://zetaris.cyzoanxzdpje.ap-southeast-2.redshift.amazonaws.com:5439/zetredshift",
          username "aws_test_data" ,
          password "Tcph_Data_1"
      );
      REGISTER DATASOURCE TABLES FROM AWS_ORCL;

Azure Datasources
^^^^^^^^^^^^^^^^^^
**AZURE_MSSQL Datasource:**


::

      CREATE DATASOURCE AZURE_MSSQL DESCRIBE BY "AZURE_MSSQL" OPTIONS (
          jdbcdriver "com.microsoft.sqlserver.jdbc.SQLServerDriver",
          jdbcurl "jdbc:sqlserver://microsoftsqlserver.database.windows.net:1433 ",
          databaseName "DemoData",
          username "adminnew" ,
          password "WarehouseZet123",
          schema "tpch1"
      );
      REGISTER DATASOURCE TABLES FROM AZURE_MSSQL;

AZURE_POSTGRES Datasource:
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

      CREATE DATASOURCE AZURE_POSTGRES DESCRIBE BY "TPCH set in Azure PostgreSQL " OPTIONS (
      jdbcdriver "org.postgresql.Driver",
      jdbcurl "jdbc:postgresql://postgresql-testdata-server.postgres.database.azure.com:5432/testdb",
      username "testdb_admin@postgresql-testdata-server" ,
      password "aGVsbG90ZXN0ZGIK",
      schema "tpch_db"
      );
      REGISTER DATASOURCE TABLES FROM AZURE_POSTGRES;


Azure BLOB
^^^^^^^^^^^
**TPCH_AZBLB Databases:**

::
    
     CREATE LIGHTNING DATABASE TPCH_AZBLB DESCRIBE BY "TPCH Data set in Azure blob";

     CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/customer.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

     CREATE LIGHTNING FILESTORE TABLE line FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/line.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

     CREATE LIGHTNING FILESTORE TABLE nation FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/nation.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

     CREATE LIGHTNING FILESTORE TABLE orders FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/orders.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

     CREATE LIGHTNING FILESTORE TABLE partsupp FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/partsupp.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

     CREATE LIGHTNING FILESTORE TABLE part FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/part.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

     CREATE LIGHTNING FILESTORE TABLE region FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/region.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );


      CREATE LIGHTNING FILESTORE TABLE supplier FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/supplier.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );



AWS S3
^^^^^^^
**TPCH_S3 Databases:**

::

      CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_S3 FORMAT CSV OPTIONS (
          PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/customer.csv",
          inferSchema "true",
          AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
          AWSSECRETACCESSKEY "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"
      );

      CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_S3 FORMAT CSV OPTIONS (
          PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/line.csv",
          inferSchema "true",
          AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
          AWSSECRETACCESSKEY "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"
      );

      CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_S3 FORMAT CSV OPTIONS (
          PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/nation.csv",
          inferSchema "true",
          AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
          AWSSECRETACCESSKEY "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"
      );

      CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_S3 FORMAT CSV OPTIONS (
          PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/orders.csv",
          inferSchema "true",
          AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
           AWSSECRETACCESSKEY "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"
      );

      CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_S3 FORMAT CSV OPTIONS (
          PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/partsupp.csv",
          inferSchema "true",
          AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
           AWSSECRETACCESSKEY "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"
      );

      CREATE LIGHTNING FILESTORE TABLE customer FROM TPCH_S3 FORMAT CSV OPTIONS (
          PATH "s3n://zetaris-lightning-test/csv-data/tpc-h/part.csv",
          inferSchema "true",
          AWSACCESSKEYID "AKIAITGIWHBIPE3NU5GA",
           AWSSECRETACCESSKEY "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"

      );

      CREATE LIGHTNING FILESTORE TABLE region FROM TPCH_AZBLB FORMAT CSV OPTIONS (
          PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/region.csv",
          inferSchema "true",
          fs.azure.account.key.zettesstorage.blob.core.windows.net "bHLzau36KlZ6cYnSrvPzSJVniBDtu819nHTR/+hRyDZEVScQ3wuesst9P5/I7vqG+4czeimuHSrPe2ZtK+b+BQ=="
      );

Can I increase the performance of my queries?
==============================================

No data is stored within the Cloud Data Fabric.
Every query will interrogate the source system to generate a result.
In some cases the one or more source system can have a very slow response time, causing the Cloud Data Fabric to wait for sufficient data to be received before other data source information can be referenced.
For slow responsive source systems it is useful to cache the data, so that the response is much quicker. Instead of referencing the table, view or file in the source systems, the cached copy can be used.
Reference on how to cache and uncache data can be found in the SQL Guide : Zetaris Cloud Data Fabric SQL Guide - ver 2.1.0


Cloud Data Fabric GUI vs Connecting using JDBC
================================================

The Cloud Data Fabric GUI is accessed using a URL of the form: http://betatestmedium-ui.6049b280cf1be6f1afc01bea29cacf61.datafabric.zetaris.com/lightning-gui/login
Only the username and password is required to gain access to the necessary warehouse.


Access the Cloud Data Fabric with JDBC requires the JDBC driver to be downloaded and configured within the tool being used.
Instructions on downloading and configuring the driver can be found here

Once the driver is installed the URL must be provided along with the username and password. 
The URL is of the form: jdbc:zetaris:clouddatafabric@betatestsmall.6049b280cf1be6f1afc01bea29cacf61.datafabric.zetaris.com/RestClient=http

The system has stopped running what do I do?
=============================================

Send an email to support(support@zetaris.com) if any of the following scenarios occur;
You are unable to get  a login screen in your browser when you access the login URL http://ui.datafabric.zetaris.com/lightning-gui/login
You are unable to connect to any of your virtual data sources through our tools that were previously available
The User Interface seems hung due to long running query, try stopping the query by clicking stop button, if this does not rectify the issue contact support

I’ve asked the chat-bot a question how long does it take to respond?
====================================================================

Typically Zetaris will respond to your enquiry within one hour


If the chat-bot is not working how do I contact support?
=======================================================

Zetaris provide a support email as a backup process to our chat-bot.
Please direct any questions to support@zetaris.com and maybe let us know that we have a problem (smile)

I built a data fabric but I can’t see it, where do I find it?
==============================================================

After creating a new data source, it will appear in the Logical Data Sources panel of the Fabric Builder Tab of the Fabric U, shown below.
image2018-11-1_14-10-52.png
If the data source which has been created is not visible, refresh the display by clicking the reload  icon next to the Data Sources
Please refer to the Quick Start Guide for more detailed information 

How do I get back back to my Data Warehouse once I have built it?
==================================================================

Once you have built a Data Warehouse in the Warehouse Builder tab of the Cloud Data Fabric UI, you can refresh the view by clicking the Data Warehouse Builder icon   to see your newly created data warehouse running.
Refer to Section 6 of the Cloud Data Fabric -Quick Start Guide for detailed information on connecting to your new data warehouse 

How do I connect my tools to a Virtual Data Warehouse or Data Mart?
====================================================================

Business Intelligence tools that support JDBC can be connected to the Cloud Data Fabric.
The following steps should be followed:
1. The JDBC driver must be downloaded from here
2. The BI tool must be configured to use the JDBC driver, full instructions are available here

Can I connect to my data without using the data fabric builder?
================================================================

The unique features of the Cloud Data Fabric enables data within different databases or storage to be queried and accessed concurrently either through a direct SQL query defined in the fabric or through the creation of a virtual Data Warehouse or Data Mart built to service the  needs of the users.
Existing tools are unable to query data from different systems in a single query, but firstly require the data to be collocated (through some transformation or copy process) in the one environment or database to achieve the same functionality that the Cloud Data Fabric can provide very quickly and securely.

Is my data safe and secure?
============================

The Zetaris Cloud Data Fabric does not hold any of your data but instead uses the metadata (information about the data) from connected data sources, ensuring that any security defined in the data sources is maintained.
All data source metadata are kept in the Data Fabric Schema Store which is highly secure in terms of both data at rest and data in motion
The Cloud Data Fabric uses the Schema Store to perform highly secure queries that are executed at the source with only the query results returned to the Data Fabric.
All queries executed from the within the Cloud Data Fabric use connections that are secured by SSL and HTTPS protocols and will benefit from this level of secure communications.

How do I secure my data in the the fabric?
===========================================

The following article explains how data is secured by the data fabric through the inherent lack of data movement associated with the technology

Is my data safe and secure?
============================

Further role based security can be applied to every Virtual Data Warehouse or Data Mart that is created from the data sources defined in the Cloud Data Fabric, 
ensuring that a narrow band of access to any information is maintained. 

What is the difference between beta and post beta?
===================================================

With your feedback we expect that:

- Every feature will be more stable and more polished
- We will have more product features
- Our billing system will be up and running and we will switch to a production billing mode.
- If you have been a Beta tester there are significant discounts over the published retail price.


What will happen to my data once the beta finishes?
====================================================

Zetaris will inform you as the Beta close date approaches and will provide you with some options for our continued use of the platform
If the data is important to you, Zetaris expect that you make arrangement to transfer this data
If you have been using test data that is not important, Zetaris expect that you delete this data prior to the deadline date.
Should you choose to continue using our service, your data will be saved and available for you to access in your account. 

What should I expect from any functions labelled as Beta?
==========================================================

There are a few functions within the Cloud Data Fabric labelled as Beta. This simply means they are our newer functionalities and haven't been as rigorously tested.
We expect all our functions to be working proficiently however we encourage our users to give us feedback should you find any problems.

When is the Cloud Data Fabric Beta platform available?
=======================================================

At present, access to the platform is between 9am and 6pm from Monday to Friday, excluding public holiday

What are Push Type and Pull Type Data Sources?
================================================

A Push type data source is an implementation of the cloud data fabric within an organisation environment typically behind their firewall. Event Hubs are employed to send data from within the organisations firewall to the Cloud Data Fabric, so that it may be combined with the other data sources. 

A Pull type data source defines the connection between the source storage or database, registering the metadata of the objects within that source. The source is either available within the cloud or a database open to the internet.

Can I work with other users?
=============================

Yes. You can set up users after you set up an account for them. As the administrator, you can create their role within your account and give them access to any virtual Warehouses and DataMarts. 
Refer to item 8 in the Quick Start Guide for more information on how to add users.

Do users I've added have to be a part of Beta?
===============================================

Users that you add to your account do not need to be a part of the Beta program. They will however need a username and password in order to access the Zetaris Cloud Data Fabric which you will have to create for them as the administrator. 
Refer to item 8 in the Quick Start Guide for further information on how to add a user.

Do I need an Azure account?
============================

You do not need an Azure account to use Zetaris Cloud Data Fabric.
However you will need an account to store any data. You can create a free account here. 

How do I create an Azure account?
===================================

You can create a free Azure account here


Can I change my password?
==========================

Administrators can change their password in the top right corner of any screen where their user ID is shown. Select from the drop-down menu "Change Password".

image2019-4-29_16-21-53.png

Refer to section 2 of the Quick Start Guide for further information

What do I do if I forget my password?
======================================

If you forget your password send us an email at support@zetaris.com. We will send you an email with a password reset link. The link will be valid for 24 hours.



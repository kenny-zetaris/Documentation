####################################
Cloud Data Fabric Quick-Start Guide
####################################

Welcome to the Zetaris Cloud Data Fabric Quick-Start Guide!
The traditional approaches to data integration where the use of ETL ( Extract-Translate-Load) or ELT ( Extract-Load-Translate) are the principal data movement methods is no longer a sustainable approach.
Data comes in all shapes, all velocities and different levels of structure and the platform used to manage this level of activity needs to be able to cope with modern business demands placed on it.
Traditional methods are simply not fast enough to keep pace with the business and the market that drives business.
This document will provide you a fundamental functional understanding of the Zetaris Cloud Data Fabric so you can explore the capabilities of the platform and begin to understand the potential business benefits that can be quickly implemented, tested and productionised. 

**Accessing the Cloud Data Fabric User Interface**
All users access their own Cloud Data Fabric through  http://ui.datafabric.zetaris.com/lightning-gui/login
where you can input your specific username and password

 .. figure::  img/image001.png
   :align:   center


**Cloud Data Fabric User Interface Tabs**
Once successfully logged into the user interface, you will see your options at the top of the page. Here is a break down of the functions stored in the top Menu.

 .. figure::  img/image002.png
   :align:   center

 

Listed from left to right they are:

1.	Data Fabric Builder
2.	Schema Store View
3.	Data Catalog
4.	Query Builder
5.	Virtual Data Mart
6.	Warehouse Builder
7.	Topological View
8.	User Management


Data Fabric Builder
===================

Data fabric builder lets you create data fabrics which are a combination of data sources consisting of different database or files.
IN the below example:

•	The left panel displays all the available databases and data sources that have been defined.
•	Database can be added by simply clicking on small green button as shown in image
 
 .. figure::  img/image003.png
   :align:   center


Schema Store View
==================

Schema Store is where query can be constructed and run using different virtual data source tables to compose unique databases, data marts and views which are defined within the cloud data fabric.

 .. figure::  img/image004.png
   :align:   center


-	The left panel of the User interface is known as the Schema Browser and displays all the databases, data sources, data marts and views that are available for use in any query. Any new databases or data marts created will be added to these panels.
-	The main panel to the right, the SQL Editor is where all SQL queries are written with the results displayed immediately below in the Results panel.
-	The Result panel has two tabs. Result, where output of a query will be shown and History, where the query history run on a particular query sheet will be shown
-	The top right corner of the interface has the the following buttons, from left to right

 .. figure::  img/image005.png
   :align:   center

-
   - Plus Button - adds an additional User Interface tab
   - File open button - opens any previously saves SQL queries
   - Save Button - allows Save or Save-As of any new or edited SQL queries
   - Max Result - sets the maximum number of results to be returned by a query
   - Play Button - executes any SQL code that has been highlighted in the SQL Editor
   - Stop Button - stops SQL query execution
   - Format Button - arranges SQL Code in the Editor window into a human-readable format

The user panel, also located in the top right corner of the user interface allows you to change your password as well as logout

 .. figure::  img/image006.png
   :align:   center

 
-	The bottom of the results window will show a fail result message when a query has been unsuccessful. 
Clicking the Red triangle in the bottom right corner the Result panel will display any errors relevant to the current failure result.

 .. figure::  img/image007.png
   :align:   center
 

Data Catalog
=============

Data catalog tab allows you to browse the existing defined data sources and look at the tables associated with these.

**Adding a Physical Data Source**
Database tables can be created from Azure BLOB storage, Amazon s3 Buckets or an API end point
There are 2 mechanisms available:

-	Data Fabric Builder, or
- 	SQL Editor on the Schema Store View tab

Data Fabric Builder
-------------------

Database Creation
^^^^^^^^^^^^^^^^^^
A database needs to be created before any tables can be assigned to that database.
A name and description are required along with any additional parameters.

 .. figure::  img/image008.png
   :align:   center
 
 .. figure::  img/image009.png
   :align:   center

 
The created database appears under the Physical Data Sources and Data Bases section:

 .. figure::  img/image010.png
   :align:   center
 
Table Creation
^^^^^^^^^^^^^^^
Once the database to which the tables are to be assigned has been created, the “+” addition sign can be pressed to create the table.
The table can either be a File Store table (Azure BLOB or AWS s3 bucket) or an API end point
File Store

 .. figure::  img/image011.png
   :align:   center
 
The necessary credentials need to be supplied including:

- Name which the table will be called, which does not need to be the same to that of the file within Azure or AWS
- Path of the file
- Access Key Name
- Access Key Value

The default parameters can be altered if a header is not available

 .. figure::  img/image012.png
   :align:   center
 
Before the table is created a preview of the records is provided.

 .. figure::  img/image013.png
   :align:   center
 
The tables are available as soon as they are created.

 .. figure::  img/image014.png
   :align:   center
 
SQL Editor on the Schema Store View tab
----------------------------------------

The same process is required when creating the tables and database using the command line interface.

Database Creation
^^^^^^^^^^^^^^^^^^

::

   CREATE LIGHTNING DATABASE TEST_DATABASE DESCRIBE BY " TEST_DATABASE";

Table Creation
^^^^^^^^^^^^^^^

::

   CREATE LIGHTNING FILESTORE TABLE customer FROM TEST_DATABASE  FORMAT CSV OPTIONS (
             PATH "wasb://zettest-storage-container@zettesstorage.blob.core.windows.net/customer.csv",
             inferSchema "true",
             fs.azure.account.key.zettesstorage.blob.core.windows.net "XXXXXXXXXXXXXXXXXXXXXXCVCHJHVJLBJCGJHCVJLKNKJVKJHBLKMLKBHBNKLJMKL");

Adding a Data Source
^^^^^^^^^^^^^^^^^^^^^
- Data sources can be added by clicking on the small green button next to data source as shown in image below

 .. figure::  img/image015.png
   :align:   center

- A pop-up will appear to guide you through the data source setup process
- In step 1, Pull type is the default data source type, click next

 .. figure::  img/image016.png
   :align:   center
 

- Complete the Data Source Information page including Database Type, Data Source Name, 
Description (Optional),JDBC Driver Class,JDBC URL, Username/Password and Schema type followed by clicking next

 .. figure::  img/image017.png
   :align:   center
  

- Now select all the tables in the data source which you would like included as part of the virtual data source and click next

 .. figure::  img/image018.png
   :align:   center
 
- A summary of all the database and driver parameters along with the selected tables will be shown.
To accept these changes and create the virtual data source, click the register button

 .. figure::  img/image019.png
   :align:   center
 




Query Builder
==============

This tab is used for inter-active query builds through a drag and drop method, which auto-generates the SQL statements.

 .. figure::  img/image019.png
   :align:   center
 
-	The left-most panel is the Schema Browser which displays all available databases, data sources, data mart and views which can be used by query builder.
-	The main panel is the Query Builder canvas where tables and views can dragged and joined. 
-	The right-most panel displays the selected columns along with any predicates and group by / order by clauses 
  - Selected Columns will contain any columns that are dragged from the Schema Browser that you wish to use as part of your query.
  - Predicates defines the column on which you want to apply where clauses or filters ie; "where employee_num <1000"
  - Group By let you group results on the the basis of particular column allowing you to filter out data. it is very similar to where clause 
but also allowing aggregation count comparison
  - Order By allows you to order your data in descending or ascending order for a particular column you selected.
-	The SQL and Result panel below the Schema Browser canvas is where the SQL is shown along with results of your query 
  - SQL Tab display a dynamic view of the auto-generated SQL built form your selections
  - Result Tab displays the query result once the execute button has been clicked
  - Queries can be saved at any time by clicking the Save Icon described in section 2

Virtual Datamart
=================

The Data Mart is a subset of the Virtual Data Warehouse and is usually oriented to a specific business line or team. 
Whereas the data warehouse may contain a wide set of data, the Virtual Data Mart can be quickly created to a single department or user requirement. Virtual data mart lets you create different data mart within a data ware house by combing several tables, views etc.

-  on the left hand side panel you can see all the available data bases, data sources and all the data mart already created.
-  in the middle is where you can drag different table and view to create a datamart. You will be allowed to drag table and view only after you click "create" button on the right and it will ask you for datamart name and description. To complete, click create button.

Warehouse Builder
==================

To allow end users to gain access to the data, a warehouse needs to be created and configured.
The warehouse builder provides the flexibility to create the following type of warehouses:

- small
-	medium, and
-	large warehouse.

Each of these warehouses assigned different amounts of CPU and memory to enable queries to be executed.
The type of warehouse used will depend upon the data to be processed and the execution response time required.
In order to create a warehouse and allocate the necessary data the Create icon should be used:

 .. figure::  img/image021.png
   :align:   center
 
A name comprising of alphanumeric characters only must be provided and the size of the Warehouse (small, medium or large) needs to be selected:

 .. figure::  img/image022.png
   :align:   center
 

Users and roles must be associated with the warehouse:

 .. figure::  img/image023.png
   :align:   center
 
S3 or Blob data (represented as databases) and data sources can be associated with the warehouse:

 .. figure::  img/image024.png
   :align:   center
 
Data Marts can also be associated with the warehouse:

 .. figure::  img/image025.png
   :align:   center
 
A review of the configuration of the warehouse can be undertaken, before the “Create” icon is selected:

 .. figure::  img/image026.png
   :align:   center
 
Once the warehouse is created it will be placed into the PENDING state, before changing to a RUNNING state.

 .. figure::  img/image027.png
   :align:   center

 .. figure::  img/image028.png
   :align:   center

 
After being created the warehouse can be:

- 	Stopped,
-	Resumed, or
-	Deleted
If changes are required to the warehouse this can be done using the tabs at the bottom of the screen to Assign new or Revoke existing data, users or roles:

 .. figure::  img/image029.png
   :align:   center
 
Once the warehouse is configured there are two methods of accessing the warehouse:

-	Web GUI, or
-	JDBC access from a third party business intelligence tool such as DBeaver, DBVisualiser, Tableau 2018+

 .. figure::  img/image030.png
   :align:   center
 
Clicking on the icon next to the warehouse will open another window, enabling the user to login, if they have been provided with access to that warehouse.

 .. figure::  img/image031.png
   :align:   center
 
To access using a third party requires:

-	Download of the Cloud Data Fabric JDBC driver and configuring the tool
-	Copying the URL from the second icon next to the warehouse GUI

 .. figure::  img/image032.png
   :align:   center
 
An example of the URL for this betatestmedium warehouse is:
jdbc:zetaris:clouddatafabric@betatestmedium.6049b280cf1be6f1afc01bea29cacf61.datafabric.zetaris.com/RestClient=http

Topological View
=====================

The topological view provides the data that the Cloud Data Fabric has access to. The data can be queried by the customer administrator and allocated to warehouse for end users to query.
The below topological view indicates that the Cloud Data Fabric has access to Zetaris Fusiondb, Postgres, oracle, Teradata, SAFC, Cassandra.

 .. figure::  img/image033.png
   :align:   center
 

User Management
================

The User Management allows the management of different users and roles.

 .. figure::  img/image034.png
   :align:   center
 


Users and Roles can be added using the left hand side panel

 .. figure::  img/image035.png
   :align:   center
 
 .. figure::  img/image036.png
   :align:   center
 

The top right hand side panel allows the addition or removal of either:
•	a user to/from a user
•	a role to/from a role

 .. figure::  img/image037.png
   :align:   center
 

The bottom right hand side panel allows the addition or removal of:
•	data warehouses to from the user or role

 .. figure::  img/image038.png
   :align:   center
 

























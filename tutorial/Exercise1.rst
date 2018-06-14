############
Exercise 1
############

This is an introduction to the zetaris platform. It introduces to the user the different components:
  - Lightning
  - Alchemist
  - Fusion

Before you start the exercise make sure that you got the **Platform VM** up and running.Follow the instructions under `Download and Go start guide <../Platform-VM/index.html>`_ to get it through.

This exercise is split into 3 parts:

- Creating and Loading the table into FusionDB
   - Querying the table

- Creating and Loading table into Lightning
   - Querying the table

- Visualizng the data in Alchemist
   - Importing Lightning views into Alchemist

.. note:: Browse the code for this exercise at files_. The same files can also be located under /srv/zetaris/docs/html/files in the respective containers.

.. _files: ./files/exercise1


Creating and Loading table into FusionDB
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Loading data into DB
  Before you run the load queries, you need to load the data dumps into the VM. If you are using the platform-VM it has the data files already present under ``/srv/zetaris/docs/files/exercise1`` .
  Once can also use SSH or your favorite ftp tools to move data into the VM. Refer to `Quick start guide <../Platform-VM/02quick-start.html>`_ for more details on how to connetc to VM.

     - SSH
     - SFTP clients – Filezilla, CyberDuck

Connect from external tools
  To run the load scripts in FusionDB , one could use any of the SQL editors and connect to the fusiondb using JDBC/ODBC drivers. Refer to the `Quick start guide <../fusion/fusion-quick-start.html>`_ for more details on how to connnect.

    - DBVisualizer
    - Other tools


Preparing the data
  The data and schema used in this exercise , conforms with the TPCH and schema and the queries comprehensively look into the 100% TPCH support.For preparing the data the associated script also include a set of index and constrainst that need to be created. Refer to the `load script <./files/exercise1/scripts/fusion/create-table.sql>`_

  .. figure::  img/img1.png
   :align:   center

Querying the Data
  To display the query capability of Fusion DB the attached `script <./files/exercise1/scripts/fusion/query-table.sql>`_ contain all the 22 querys of TPCH and associated desciptions. To get a grasp of the capability of FusionDB one could go through each of those querys.

Querying from Lightning GUI
  FusionDB is by default intergrated and virtualized via Lightning. Hence one can always use the Lightning GUI to query FusionDB.

Performance parameters in VM
  The default VM that get shipped used 8GB of RAM and our of that 2.5 GB of RAM is dedicated to Fusion. If a user allocate more RAM to the VM before the product initialization then Fusion would be configured more RAM respectively.

    - 615 MB Shared Buffer  -1/4 of available RAM
    - 1231 MB effective cache - 1/2 RAM


Creating and Loading table into Lightning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lightning enables you to directly create tables under it without having to go through a database/datasource. In here we will see how we create the same TPCH tables in Lightning and use lightning to query them.

Familiarising Lightning & Lightning GUI
  The only 100% supported GUI for lightning is the Lightnign GUI. The lightning GUI comes with 2 main views.

  	- Schema Store View
  	- Topological view
  We would be using Schema store view and the associated sql editor through out this tutorial.

Creating and Registering Lightning tables
  To create tables under lightning , run the `load table scrpts <./files/exercise1/scripts/lightning/create-table.sql>`_ . Before you create the table also make sure that the data files are present. The platformVM by default ships the data files. Hence you just need to execute the scripts in Lighning GUI.


Query
  Refer the `query table scripts <./files/exercise1/scripts/lightning/create-table.sql>`_, which contains all the 22 TPCH queries equivalent to the Relational World. The user could go through each of those queries and see how they difference from a tradional MPP query (to the one that is used in FusionDB)

     - Inter Hive ZMPP queries
    Apart from directly querying the lightning tables , Using lightning you can also run queries that join the Fusion and Lightning tables. Refer the samples at -

Performance Parameters in VM
   The system resources allocated for lightning in the platform VM is bare minimium to run queries. Here the amount of RAM allocated for lightning is 4GB.

     - LGHT_THREAD=2
     - LGHT_EXEC_MEM=400m
     - LGHT_DRIV_MEM=3692m
     - -Xmx3692m

Visualizing the data in Alchemist
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Creating a Basic report from Fusion

- Creating a Basic Report from Lightning

     - Performance Parameters
     - -Xms512m -Xmx2048m

########################################
Concepts
########################################

*What is a Data Fabric*

A data fabric is the zetaris way of stitching together diverse, disparate datasources and datasets across different plaforms (cloud, onpremise, edge etc) . The main components in a Fabric are :

*Physcial Datasources*

Are Non-Relational datasources based on physical files like csv,json or  based on external RESTful API's.

*Logical Datasources*

Logical datasources are traditional relational datasources.One can connect any remote database as a ogical datasource.

*Data Fabric Builder*

Is where we register all datasources and build data fabric



*What is a Schema store*

It is the repository of all relational schemas within datasources. It also enabe us to build relational logical views and datamarts on top of exsisting objects.

*Schema Browser*

Help you to navigate the schema store. Different objects within a schema store are :

*Databases*

Are databases build in lightning under the physcial datasource in data fabrics.

*Datasources*

Are the registered logical datasources in the data fabric

*Data Marts*

Data marts are the virtualised equivalent physical datamarts, where no physical copy is made for setting them up.

*Views*

Just like nomral views, with the adon that you can create create views across different datasource and cache them.







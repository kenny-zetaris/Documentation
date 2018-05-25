-- Create table

CREATE  TABLE customer
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/customer.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE lineitem
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/lineitem.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE nation
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/nation.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE orders
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/orders.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE part
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/part.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE partsupp
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/partsupp.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE region
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/region.tbl",delimiter '|', header "true", inferSchema "true");

CREATE  TABLE supplier
USING com.databricks.spark.csv
OPTIONS (path "/srv/zetaris/docs/html/tutorial/files/exercise1/data/lightning/supplier.tbl",delimiter '|', header "true", inferSchema "true");
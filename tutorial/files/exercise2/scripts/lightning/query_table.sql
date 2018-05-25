
-- Create Datasource

CREATE DATASOURCE POSTGRES_LOCAL 
DESCRIBE BY "PostgreSQL" 
options(
jdbcdriver "org.postgresql.Driver",
jdbcurl "jdbc:postgresql://172.16.113.1:5432/dg",
username "markczernkowski",
password "postgres",
schema_prepended_table "true");


-- Register Tables

REGISTER 
DATASOURCE TABLES 
FROM POSTGRES_LOCAL;


-- check data.
select a.* 
from POSTGRES_LOCAL.mcr_data a;


-- show all tables.
show tables 
in default;

-- Register external postgres datasource

CREATE DATASOURCE POSTGRES 
DESCRIBE BY "PostgreSQL" 
options(
jdbcdriver "org.postgresql.Driver",
jdbcurl "jdbc:postgresql://172.16.113.197:5432/postgres",
username "postgres",
password "zetaris123",
schema_prepended_table "true");

-- Register tables from postgres datasource

REGISTER 
DATASOURCE TABLES 
FROM POSTGRES 
drop table postgres.data1;

-- query 1

select b.* 
from POSTGRES.z_d__poa_centroid_sla_lga b

inner join

POSTGRES_LOCAL.abs__mcr_data a

on b.poa_name 
=cast(a.post 
as varchar(10));
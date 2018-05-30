
/*----------------LOCAL POSTGRES----------------------*/
/*----------------LOCAL POSTGRES----------------------*/
/*----------------LOCAL POSTGRES----------------------*/
/*----------------LOCAL POSTGRES----------------------*/
/*----------------LOCAL POSTGRES----------------------*/

REGISTER DATASOURCE TABLES FROM POSTGRES_LOCAL;

CREATE DATASOURCE POSTGRES_LOCAL DESCRIBE BY "PostgreSQL" options(
    jdbcdriver "org.postgresql.Driver",
jdbcurl "jdbc:postgresql://172.16.113.1:5432/dg",
username "markczernkowski",
password "postgres",
schema_prepended_table "true");

Drop datasource postgres_local;


REGISTER DATASOURCE TABLES FROM POSTGRES_LOCAL;

show DATASOURCE TABLES  POSTGRES_LOCAL;


/*----------------FUSIONDB----------------------*/
/*----------------FUSIONDB----------------------*/
/*----------------FUSIONDB----------------------*/
/*----------------FUSIONDB----------------------*/
/*----------------FUSIONDB----------------------*/


DROP DATASOURCE FUSIONDB;

CREATE DATASOURCE FusionDB DESCRIBE BY "PostgreSQL" options(
    jdbcdriver "org.postgresql.Driver",
jdbcurl "jdbc:postgresql://172.16.113.196:20004/postgres",
username "zetaris",
password "zetaris!23",
schema_prepended_table "true");

REGISTER DATASOURCE TABLES FROM FusionDB;

show DATASOURCE TABLES  FUSIONDB;


/*----------------MySQL----------------------*/
/*----------------MySQL----------------------*/
/*----------------MySQL----------------------*/
/*----------------MySQL----------------------*/
/*----------------MySQL----------------------*/

DROP DATASOURCE MYSQL;


CREATE DATASOURCE MYSQL DESCRIBE BY "Mysql database" OPTIONS (
jdbcdriver "com.mysql.jdbc.Driver",
 jdbcurl "jdbc:mysql://172.16.113.197:3306/dg",
username "root", password "vssvss",
schema_prepended_table "true");

REGISTER DATASOURCE TABLES FROM MYSQL;

show DATASOURCE TABLES  MYSQL;


/*---------------QUERIES--------------------*/
/*---------------QUERIES--------------------*/
/*---------------QUERIES--------------------*/
/*---------------QUERIES--------------------*/
/*---------------QUERIES--------------------*/
SELECT
--    COUNT(*),
--    a.City,
--    b.latitude,
--    b.longitude,
--    b.sla_code11
;


select b.* from MYSQL.poa_centroid_sla_lga b;



select b.*
FROM
    MYSQL.poa_centroid_sla_lga b
;INNER JOIN
    POSTGRES_LOCAL.abs__mcr_data a
ON
    b.poa_name =CAST(a.post AS VARCHAR(10))
;INNER JOIN
    FUSIONDB.merchant__dim_postcode_new c
ON
    a.post=c.postcode
WHERE
    c.state='VIC'
GROUP BY
    2,3,4,5;








/*---------------CREATE VIEWS--------------------*/
/*---------------CREATE VIEWS--------------------*/
/*---------------CREATE VIEWS--------------------*/
/*---------------CREATE VIEWS--------------------*/
/*---------------CREATE VIEWS--------------------*/


CREATE DATASOURCE VIEW DG_VIEW_ALL AS
select 
gid
,poa_code
,poa_name
,sla_code11
,lga_code
,longitude
,latitude
,first_name
,last_name
,company_name
,address
,city
,post
,phone1
,phone2
,email
,web
,c.state
,c.postcode_name
,c.dscrptn
,c.multi_sbrb
,c.postcode
 from
FUSIONDB.merchant__dim_postcode_new c
left outer join
POSTGRES_LOCAL.abs__mcr_data a
on a.post=c.postcode
left outer join
mysql.poa_centroid_sla_lga b
on b.poa_name =cast(a.post as varchar(10))
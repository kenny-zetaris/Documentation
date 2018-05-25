CREATE TABLE supplier (
	s_suppkey  INTEGER,
	s_name CHAR(25),
	s_address VARCHAR(40),
	s_nationkey INTEGER,
	s_phone CHAR(15),
	s_acctbal REAL,
	s_comment VARCHAR(101))
	DISTRIBUTE BY REPLICATION;

CREATE TABLE part (
	p_partkey INTEGER,
	p_name VARCHAR(55),
	p_mfgr CHAR(25),
	p_brand CHAR(10),
	p_type VARCHAR(25),
	p_size INTEGER,
	p_container CHAR(10),
	p_retailprice REAL,
	p_comment VARCHAR(23))
	DISTRIBUTE BY HASH (p_partkey);

CREATE TABLE partsupp (
	ps_partkey INTEGER,
	ps_suppkey INTEGER,
	ps_availqty INTEGER,
	ps_supplycost REAL,
	ps_comment VARCHAR(199))
	DISTRIBUTE BY HASH (ps_partkey);


CREATE TABLE customer (
	c_custkey INTEGER,
	c_name VARCHAR(25),
	c_address VARCHAR(40),
	c_nationkey INTEGER,
	c_phone CHAR(15),
	c_acctbal REAL,
	c_mktsegment CHAR(10),
	c_comment VARCHAR(117))
	DISTRIBUTE BY REPLICATION;

CREATE TABLE orders (
	o_orderkey BIGINT,
	o_custkey INTEGER,
	o_orderstatus CHAR(1),
	o_totalprice REAL,
	o_orderdate DATE,
	o_orderpriority CHAR(15),
	o_clerk CHAR(15),
	o_shippriority INTEGER,
	o_comment VARCHAR(79))
	DISTRIBUTE BY HASH (o_orderkey);

CREATE TABLE lineitem (
	l_orderkey BIGINT,
	l_partkey INTEGER,
	l_suppkey INTEGER,
	l_linenumber INTEGER,
	l_quantity REAL,
	l_extendedprice REAL,
	l_discount REAL,
	l_tax REAL,
	l_returnflag CHAR(1),
	l_linestatus CHAR(1),
	l_shipdate DATE,
	l_commitdate DATE,
	l_receiptdate DATE,
	l_shipinstruct CHAR(25),
	l_shipmode CHAR(10),
	l_comment VARCHAR(44))
	DISTRIBUTE BY HASH (l_orderkey);

CREATE TABLE nation (
	n_nationkey INTEGER,
	n_name CHAR(25),
	n_regionkey INTEGER,
	n_comment VARCHAR(152)) DISTRIBUTE BY REPLICATION;

CREATE TABLE region (
	r_regionkey INTEGER,
	r_name CHAR(25),
	r_comment VARCHAR(152)) DISTRIBUTE BY REPLICATION;



COPY part FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/part.tbl' WITH DELIMITER AS '|';
COPY partsupp FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/partsupp.tbl' WITH DELIMITER AS '|';
COPY customer FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/customer.tbl' WITH DELIMITER AS '|';
COPY orders FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/orders.tbl' WITH DELIMITER AS '|';
COPY lineitem FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/lineitem.tbl' WITH DELIMITER AS '|';
COPY nation FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/nation.tbl' WITH DELIMITER AS '|';
COPY region FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/region.tbl' WITH DELIMITER AS '|';
COPY supplier FROM '/srv/zetaris/docs/html/tutorial/files/exercise1/data/fusion/supplier.tbl' WITH DELIMITER AS '|';

CREATE UNIQUE INDEX pk_supplier
ON supplier (s_suppkey)
WITH (fillfactor = 100);

CREATE INDEX supplier_s_suppkey_idx_like
ON supplier (s_suppkey)
WITH (fillfactor = 100)
WHERE s_comment LIKE '%Customer%Complaints%';

CREATE INDEX supplier_s_nationkey_s_suppkey_idx
ON supplier (s_nationkey, s_suppkey)
WITH (fillfactor = 100);

VACUUM ANALYZE supplier;

CREATE INDEX part_p_type_p_partkey_idx
ON part(p_type, p_partkey)
WITH (fillfactor = 100);

CREATE INDEX part_p_container_p_brand_p_partkey_idx
ON part(p_container, p_brand, p_partkey)
WITH (fillfactor = 100);

CREATE INDEX part_ios_test1
ON part
USING btree (p_size, p_partkey, p_brand, p_type)
WITH (fillfactor = 100);

CREATE INDEX part_p_size_idx ON part USING BRIN (p_size);

CREATE INDEX part_p_name_idx
ON part(p_name);


VACUUM ANALYZE part;

CREATE UNIQUE INDEX pk_partsupp
ON partsupp (ps_partkey, ps_suppkey)
WITH (fillfactor = 100);

CREATE INDEX partsupp_ps_suppkey_idx
ON partsupp (ps_suppkey)
WITH (fillfactor = 100);

CREATE UNIQUE INDEX pk_customer
ON customer (c_custkey)
WITH (fillfactor = 100);

CREATE INDEX customer_c_nationkey_c_custkey_idx
ON customer (c_nationkey, c_custkey)
WITH (fillfactor = 100);

CREATE INDEX customer_ios_test1
ON customer (substring(c_phone from 1 for 2), c_acctbal, c_custkey)
WITH (fillfactor = 100);

CREATE INDEX customer_c_mktsegment_c_custkey_idx
ON customer (c_mktsegment, c_custkey)
WITH (fillfactor = 100);

VACUUM ANALYZE customer;

CREATE UNIQUE INDEX pk_orders
ON orders (o_orderkey)
WITH (fillfactor = 100);

CREATE INDEX orders_o_orderkey_o_orderdate_idx
ON orders (o_orderkey, o_orderdate)
WITH (fillfactor = 100);

CREATE INDEX orders_o_custkey_idx
ON orders (o_custkey)
WITH (fillfactor = 100);

CREATE INDEX orders_o_orderdate_idx
ON orders USING BRIN (o_orderdate);

VACUUM ANALYZE orders;

CREATE UNIQUE INDEX pk_lineitem
ON lineitem (l_orderkey, l_linenumber)
WITH (fillfactor = 100);

CREATE INDEX lineitem_l_partkey_l_quantity_l_shipmode_idx
ON lineitem (l_partkey, l_quantity, l_shipmode)
WITH (fillfactor = 100);

CREATE INDEX lineitem_l_orderkey_idx_l_returnflag
ON lineitem (l_orderkey)
WITH (fillfactor = 100)
WHERE l_returnflag = 'R';

CREATE INDEX lineitem_l_orderkey_idx_part1
ON lineitem (l_orderkey, l_suppkey)
WITH (fillfactor = 100)
WHERE l_commitdate < l_receiptdate;

CREATE INDEX lineitem_l_orderkey_idx_part2
ON lineitem (l_orderkey)
WITH (fillfactor = 100)
WHERE l_commitdate < l_receiptdate
  AND l_shipdate < l_commitdate;

CREATE INDEX line_item_l_orderkey_l_suppkey_idx
ON lineitem (l_orderkey, l_suppkey)
WITH (fillfactor = 100);

CREATE INDEX lineitem_l_partkey_l_suppkey_l_shipdate_l_quantity_idx
ON lineitem (l_partkey, l_suppkey, l_shipdate, l_quantity)
WITH (fillfactor = 100);

CREATE INDEX lineitem_l_shipdate_idx ON lineitem USING BRIN (l_shipdate);

CREATE INDEX lineitem_l_receiptdate_idx ON lineitem USING BRIN (l_receiptdate);

VACUUM ANALYZE lineitem;

CREATE UNIQUE INDEX pk_nation ON nation (n_nationkey) WITH (fillfactor = 100);

VACUUM ANALYZE nation;

CREATE UNIQUE INDEX pk_region ON region (r_regionkey) WITH (fillfactor = 100);

VACUUM ANALYZE region;


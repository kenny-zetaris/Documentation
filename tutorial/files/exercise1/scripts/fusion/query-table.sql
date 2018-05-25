-- Query 1

-- The Pricing Summary Report Query provides a summary pricing report for all lineitems shipped as of a given date.
-- The date is within 60 - 120 days of the greatest ship date contained in the database. The query lists totals for
-- extended price, discounted extended price, discounted extended price plus tax, average quantity, average extended
-- price, and average discount. These aggregates are grouped by RETURNFLAG and LINESTATUS, and listed in
-- ascending order of RETURNFLAG and LINESTATUS.

select
	l_returnflag,
	l_linestatus,
	sum(l_quantity) as sum_qty,
	sum(l_extendedprice) as sum_base_price,
	sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
	sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
	avg(l_quantity) as avg_qty,
	avg(l_extendedprice) as avg_price,
	avg(l_discount) as avg_disc,
	count(*) as count_order
from
	lineitem
where
	l_shipdate <= date '1998-12-01' - interval '90 days'
group by
	l_returnflag,
	l_linestatus
order by
	l_returnflag,
	l_linestatus;

-- Query 2--

-- Minimum Cost Supplier Query
-- The Minimum Cost Supplier Query finds, in a given region, for each part of a certain type and size, the supplier who
-- can supply it at minimum cost. If several suppliers in that region offer the desired part type and size at the same
-- (minimum) cost, the query lists the parts from suppliers with the 100 highest account balances. For each supplier,
-- the query lists the suppliers account balance, name and nation; the parts number and manufacturer; the suppliers
-- address, phone number and comment information."

select
	s_acctbal,
	s_name,
	n_name,
	p_partkey,
	p_mfgr,
	s_address,
	s_phone,
	s_comment
from
	part,
	supplier,
	partsupp,
	nation,
	region
where
	p_partkey = ps_partkey
	and s_suppkey = ps_suppkey
	and p_size = 15
	and p_type like '%STEEL'
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'EUROPE'
	and ps_supplycost = (
		select
			min(ps_supplycost)
		from
			partsupp,
			supplier,
			nation,
			region
		where
			p_partkey = ps_partkey
			and s_suppkey = ps_suppkey
			and s_nationkey = n_nationkey
			and n_regionkey = r_regionkey
			and r_name = 'EUROPE'
	)
order by
	s_acctbal desc,
	n_name,
	s_name,
	p_partkey
LIMIT 100;

-- Query 3

-- The Shipping Priority Query retrieves the shipping priority and potential revenue, defined as the sum of
-- l_extendedprice * (1-l_discount), of the orders having the largest revenue among those that had not been shipped as
-- of a given date. Orders are listed in decreasing order of revenue. If more than 10 unshipped orders exist, only the 10
-- orders with the largest revenue are listed.

select
	l_orderkey,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	o_orderdate,
	o_shippriority
from
	customer,
	orders,
	lineitem
where
	c_mktsegment = 'HOUSEHOLD'
	and c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate < date '1995-03-24'
	and l_shipdate > date '1995-03-24'
group by
	l_orderkey,
	o_orderdate,
	o_shippriority
order by
	revenue desc,
	o_orderdate
LIMIT 10;

-- Query 4

-- The Order Priority Checking Query counts the number of orders ordered in a given quarter of a given year in which
-- at least one lineitem was received by the customer later than its committed date. The query lists the count of such
-- orders for each order priority sorted in ascending priority order.

select
	o_orderpriority,
	count(*) as order_count
from
	orders
where
	o_orderdate >= date '1996-09-01'
	and o_orderdate < cast(date '1996-09-01' + interval '3 month' as date)
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;


-- Query 5

-- The Local Supplier Volume Query lists for each nation in a region the revenue volume that resulted from lineitem
-- transactions in which the customer ordering parts and the supplier filling them were both within that nation. The
-- query is run in order to determine whether to institute local distribution centers in a given region. The query considers
-- only parts ordered in a given year. The query displays the nations and revenue volume in descending order by
-- revenue. Revenue volume for all qualifying lineitems in a particular nation is defined as sum(l_extendedprice * (1 -
-- l_discount)).

select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	customer,
	orders,
	lineitem,
	supplier,
	nation,
	region
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and l_suppkey = s_suppkey
	and c_nationkey = s_nationkey
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'AFRICA'
	and o_orderdate >= date '1997-01-01'
	and o_orderdate < date '1997-01-01' + interval '1 year'
group by
	n_name
order by
	revenue desc;


-- Query 6

-- The Forecasting Revenue Change Query considers all the lineitems shipped in a given year with discounts between
-- DISCOUNT-0.01 and DISCOUNT+0.01. The query lists the amount by which the total revenue would have
-- increased if these discounts had been eliminated for lineitems with l_quantity less than quantity. Note that the
-- potential revenue increase is equal to the sum of [l_extendedprice * l_discount] for all lineitems with discounts and
-- quantities in the qualifying range.

select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= date '1997-01-01'
	and l_shipdate < cast(date '1997-01-01' + interval '1 year' as date)
	and l_discount between 0.08 - 0.01 and 0.08 + 0.01
	and l_quantity < 24;

-- Query 7

-- The Volume Shipping Query finds, for two given nations, the gross discounted revenues derived from lineitems in
-- which parts were shipped from a supplier in either nation to a customer in the other nation during 1995 and 1996.
-- The query lists the supplier nation, the customer nation, the year, and the revenue from shipments that took place in
-- that year. The query orders the answer by Supplier nation, Customer nation, and year (all ascending).

select
	supp_nation,
	cust_nation,
	l_year,
	sum(volume) as revenue
from
	(
		select
			n1.n_name as supp_nation,
			n2.n_name as cust_nation,
			extract(year from l_shipdate) as l_year,
			l_extendedprice * (1 - l_discount) as volume
		from
			supplier,
			lineitem,
			orders,
			customer,
			nation n1,
			nation n2
		where
			s_suppkey = l_suppkey
			and o_orderkey = l_orderkey
			and c_custkey = o_custkey
			and s_nationkey = n1.n_nationkey
			and c_nationkey = n2.n_nationkey
			and (
				(n1.n_name = 'VIETNAM' and n2.n_name = 'CANADA')
				or (n1.n_name = 'CANADA' and n2.n_name = 'VIETNAM')
			)
			and l_shipdate between date '1995-01-01' and date '1996-12-31'
	) as shipping
group by
	supp_nation,
	cust_nation,
	l_year
order by
	supp_nation,
	cust_nation,
	l_year;


-- Query 8

-- The market share for a given nation within a given region is defined as the fraction of the revenue, the sum of
-- [l_extendedprice * (1-l_discount)], from the products of a specified type in that region that was supplied by suppliers
-- from the given nation. The query determines this for the years 1995 and 1996 presented in this order.

select
	o_year,
	sum(case
		when nation = 'CANADA' then volume
		else 0
	end) / sum(volume) as mkt_share
from
	(
		select
			extract(year from o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) as volume,
			n2.n_name as nation
		from
			part,
			supplier,
			lineitem,
			orders,
			customer,
			nation n1,
			nation n2,
			region
		where
			p_partkey = l_partkey
			and s_suppkey = l_suppkey
			and l_orderkey = o_orderkey
			and o_custkey = c_custkey
			and c_nationkey = n1.n_nationkey
			and n1.n_regionkey = r_regionkey
			and r_name = 'AMERICA'
			and s_nationkey = n2.n_nationkey
			and o_orderdate between date '1995-01-01' and date '1996-12-31'
			and p_type = 'LARGE PLATED TIN'
	) as all_nations
group by
	o_year
order by
	o_year;


-- Query 9

-- The Product Type Profit Measure Query finds, for each nation and each year, the profit for all parts ordered in that
-- year that contain a specified substring in their names and that were filled by a supplier in that nation. The profit is
-- defined as the sum of [(l_extendedprice*(1-l_discount)) - (ps_supplycost * l_quantity)] for all lineitems describing
-- parts in the specified line. The query lists the nations in ascending alphabetical order and, for each nation, the year
-- and profit in descending order by year (most recent first).

select
	nation,
	o_year,
	sum(amount) as sum_profit
from
	(
		select
			n_name as nation,
			extract(year from o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
		from
			part,
			supplier,
			lineitem,
			partsupp,
			orders,
			nation
		where
			s_suppkey = l_suppkey
			and ps_suppkey = l_suppkey
			and ps_partkey = l_partkey
			and p_partkey = l_partkey
			and o_orderkey = l_orderkey
			and s_nationkey = n_nationkey
			and p_name like '%mint%'
	) as profit
group by
	nation,
	o_year
order by
	nation,
	o_year desc;

-- Query 10

-- The Returned Item Reporting Query finds the top 20 customers, in terms of their effect on lost revenue for a given
-- quarter, who have returned parts. The query considers only parts that were ordered in the specified quarter. The
-- query lists the customer's name, address, nation, phone number, account balance, comment information and revenue
-- lost. The customers are listed in descending order of lost revenue. Revenue lost is defined as
-- sum(l_extendedprice*(1-l_discount)) for all qualifying lineitems.

select
	c_custkey,
	c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal,
	n_name,
	c_address,
	c_phone,
	c_comment
from
	customer,
	orders,
	lineitem,
	nation
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= date '1993-02-01'
	and o_orderdate < cast(date '1993-02-01' + interval '3 month' as date)
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey,
	c_name,
	c_acctbal,
	c_phone,
	n_name,
	c_address,
	c_comment
order by
	revenue desc
LIMIT 20;

-- Query 11

-- The Important Stock Identification Query finds, from scanning the available stock of suppliers in a given nation, all
-- the parts that represent a significant percentage of the total value of all available parts. The query displays the part
-- number and the value of those parts in descending order of value.

select
	ps_partkey,
	sum(ps_supplycost * ps_availqty) as value
from
	partsupp,
	supplier,
	nation
where
	ps_suppkey = s_suppkey
	and s_nationkey = n_nationkey
	and n_name = 'INDIA'
group by
	ps_partkey having
		sum(ps_supplycost * ps_availqty) > (
			select
				sum(ps_supplycost * ps_availqty) * 0.0000002000
			from
				partsupp,
				supplier,
				nation
			where
				ps_suppkey = s_suppkey
				and s_nationkey = n_nationkey
				and n_name = 'INDIA'
		)
order by
	value desc;

-- Query 12

-- The Shipping Modes and Order Priority Query counts, by ship mode, for lineitems actually received by customers in
-- a given year, the number of lineitems belonging to orders for which the l_receiptdate exceeds the l_commitdate for
-- two different specified ship modes. Only lineitems that were actually shipped before the l_commitdate are considered.
-- The late lineitems are partitioned into two groups, those with priority URGENT or HIGH, and those with a
-- priority other than URGENT or HIGH.

select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT'
			or o_orderpriority = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT'
			and o_orderpriority <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	orders,
	lineitem
where
	o_orderkey = l_orderkey
	and l_shipmode in ('FOB', 'TRUCK')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= date '1997-01-01'
	and l_receiptdate < date '1997-01-01' + interval '1 year'
group by
	l_shipmode
order by
	l_shipmode;

-- Query 13

-- This query determines the distribution of customers by the number of orders they have made, including customers
-- who have no record of orders, past or present. It counts and reports how many customers have no orders, how many
-- have 1, 2, 3, etc. A check is made to ensure that the orders counted do not fall into one of several special categories
-- of orders. Special categories are identified in the order comment column by looking for a particular pattern.

select
	c_count,
	count(*) as custdist
from
	(
		select
			c_custkey,
			count(o_orderkey)
		from
			customer left outer join orders on
				c_custkey = o_custkey
				and o_comment not like '%unusual%deposits%'
		group by
			c_custkey
	) as c_orders (c_custkey, c_count)
group by
	c_count
order by
	custdist desc,
	c_count desc;
	

-- Query 14

-- The Promotion Effect Query determines what percentage of the revenue in a given year and month was derived from
-- promotional parts. The query considers only parts actually shipped in that month and gives the percentage. Revenue
-- is defined as (l_extendedprice * (1-l_discount)).

select
	100.00 * sum(case
		when p_type like 'PROMO%'
			then l_extendedprice * (1 - l_discount)
		else 0
	end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
	lineitem,
	part
where
	l_partkey = p_partkey
	and l_shipdate >= date '1997-02-01'
	and l_shipdate < cast(date '1997-02-01' + interval '1 month' as date);
	

-- Query 15

-- The Top Supplier Query finds the supplier who contributed the most to the overall revenue for parts shipped during
-- a given quarter of a given year. In case of a tie, the query lists all suppliers whose contribution was equal to the
-- maximum, presented in supplier number order.

BEGIN;
create or replace view revenue0 (supplier_no, total_revenue) as 
	select
		l_suppkey,
		sum(l_extendedprice * (1 - l_discount))
	from
		lineitem
	where
		l_shipdate >= '1997-02-01'
		and l_shipdate < date'1997-02-01' + interval '90 days'
	group by
		l_suppkey;		

select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue0
where
	s_suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue0
	)
order by
	s_suppkey;
	
drop view revenue0;	
COMMIT;

-- Query 16

-- The Parts/Supplier Relationship Query counts the number of suppliers who can supply parts that satisfy a particular
-- customer's requirements. The customer is interested in parts of eight different sizes as long as they are not of a given
-- type, not of a given brand, and not from a supplier who has had complaints registered at the Better Business Bureau.
-- Results must be presented in descending count and ascending brand, type, and size.

select
	p_brand,
	p_type,
	p_size,
	count(distinct ps_suppkey) as supplier_cnt
from
	partsupp,
	part
where
	p_partkey = ps_partkey
	and p_brand <> 'Brand#23'
	and p_type not like 'MEDIUM BRUSHED%'
	and p_size in (3, 32, 8, 20, 29, 37, 45, 36)
	and ps_suppkey not in (
		select
			s_suppkey
		from
			supplier
		where
			s_comment like '%Customer%Complaints%'
	)
group by
	p_brand,
	p_type,
	p_size
order by
	supplier_cnt desc,
	p_brand,
	p_type,
	p_size;


-- Query 17

-- This query determines how much average yearly revenue would be lost if orders were no longer filled for small
-- quantities of certain parts. This may reduce overhead expenses by concentrating sales on larger shipments.

-- The Small-Quantity-Order Revenue Query considers parts of a given brand and with a given container type and
-- determines the average lineitem quantity of such parts ordered for all orders (past and pending) in the 7-year database.
-- What would be the average yearly gross (undiscounted) loss in revenue if orders for these parts with a quantity
-- of less than 20% of this average were no longer taken?

select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
	lineitem,
	part
where
	p_partkey = l_partkey
	and p_brand = 'Brand#33'
	and p_container = 'SM BOX'
	and l_quantity < (
		select
			0.2 * avg(l_quantity)
		from
			lineitem
		where
			l_partkey = p_partkey
	);


-- Query 18

-- The Large Volume Customer Query finds a list of the top 100 customers who have ever placed large quantity orders.
-- The query lists the customer name, customer key, the order key, date and total price and the quantity for the order.

select
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice,
	sum(l_quantity)
from
	customer,
	orders,
	lineitem
where
	o_orderkey in (
		select
			l_orderkey
		from
			lineitem
		group by
			l_orderkey having
				sum(l_quantity) > 313
	)
	and c_custkey = o_custkey
	and o_orderkey = l_orderkey
group by
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice
order by
	o_totalprice desc,
	o_orderdate
LIMIT 100;

-- Query 19

-- The Discounted Revenue query finds the gross discounted revenue for all orders for three different types of parts
-- that were shipped by air and delivered in person. Parts are selected based on the combination of specific brands, a
-- list of containers, and a range of sizes.

select
	sum(l_extendedprice* (1 - l_discount)) as revenue
from
	lineitem,
	part
where
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#14'
		and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
		and l_quantity >= 9 and l_quantity <= 9+10
		and p_size between 1 and 5
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	)
	or
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#12'
		and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
		and l_quantity >= 17 and l_quantity <= 17+10
		and p_size between 1 and 10
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	)
	or
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#34'
		and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
		and l_quantity >= 30 and l_quantity <= 30+10
		and p_size between 1 and 15
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	);

-- Query 20

-- The Potential Part Promotion query identifies suppliers who have an excess of a given part available; an excess is
-- defined to be more than 50% of the parts like the given part that the supplier shipped in a given year for a given
-- nation. Only parts whose names share a certain naming convention are considered.

select
	s_name,
	s_address
from
	supplier,
	nation
where
	s_suppkey in (
		select
			ps_suppkey
		from
			partsupp
		where
			ps_partkey in (
				select
					p_partkey
				from
					part
				where
					p_name like 'olive%'
			)
			and ps_availqty > (
				select
					0.5 * sum(l_quantity)
				from
					lineitem
				where
					l_partkey = ps_partkey
					and l_suppkey = ps_suppkey
					and l_shipdate >= '1993-01-01'
					and l_shipdate < cast(date '1993-01-01' + interval '1 year' as date)
			)
	)
	and s_nationkey = n_nationkey
	and n_name = 'INDIA'
order by
	s_name;


-- Query 21

-- The Suppliers Who Kept Orders Waiting query identifies suppliers, for a given nation, whose product was part of a
-- multi-supplier order (with current status of 'F') where they were the only supplier who failed to meet the committed
-- delivery date.

select
	s_name,
	count(*) as numwait
from
	supplier,
	lineitem l1,
	orders,
	nation
where
	s_suppkey = l1.l_suppkey
	and o_orderkey = l1.l_orderkey
	and o_orderstatus = 'F'
	and l1.l_receiptdate > l1.l_commitdate
	and exists (
		select
			*
		from
			lineitem l2
		where
			l2.l_orderkey = l1.l_orderkey
			and l2.l_suppkey <> l1.l_suppkey
	)
	and not exists (
		select
			*
		from
			lineitem l3
		where
			l3.l_orderkey = l1.l_orderkey
			and l3.l_suppkey <> l1.l_suppkey
			and l3.l_receiptdate > l3.l_commitdate
	)
	and s_nationkey = n_nationkey
	and n_name = 'CANADA'
group by
	s_name
order by
	numwait desc,
	s_name
LIMIT 100;

-- Query 22

-- This query counts how many customers within a specific range of country codes have not placed orders for 7 years
-- but who have a greater than average “positive” account balance. It also reflects the magnitude of that balance.
-- Country code is defined as the first two characters of c_phone.

select
	cntrycode,
	count(*) as numcust,
	sum(c_acctbal) as totacctbal
from
	(
		select
			substr(c_phone, 1, 2) as cntrycode,
			c_acctbal
		from
			customer
		where
			substr(c_phone, 1, 2) in
				('18', '23', '28', '32', '12', '33', '20')
			and c_acctbal > (
				select
					avg(c_acctbal)
				from
					customer
				where
					c_acctbal > 0.00
					and substr(c_phone, 1, 2) in
						('18', '23', '28', '32', '12', '33', '20')
			)
			and not exists (
				select
					*
				from
					orders
				where
					o_custkey = c_custkey
			)
	) as vip
group by
	cntrycode
order by
	cntrycode;



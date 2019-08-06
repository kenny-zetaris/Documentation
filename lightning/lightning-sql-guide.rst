#############################
Lightning SQL Reference Guide
#############################

This guide provides a reference for SQL Language Manual and a set of example use cases.
For information on Spark SQL, see the Apache Spark Spark SQL, DataFrames, and Datasets Guide.
For information on Hive Language Manual, see the Hive Manual

.. highlight:: sql

SELECT
-------

::
	
	  SELECT [hints, ...] [\* |DISTINCT] named_expression[, named_expression, ...]
	  FROM relation[, relation, ...]
	  [lateral_view[, lateral_view, ...]]
	  [WHERE boolean_expression]
	  [aggregation [HAVING boolean_expression]]
	  [WINDOW named_window[, WINDOW named_window, ...]]
	  [LIMIT num_rows]


	named_expression:
	  : expression [AS alias]

	relation:
	  | join_relation
	  | (table_name|query|relation) [sample] [AS alias]
	  : VALUES (expressions)[, (expressions), ...]
	        [AS (column_name[, column_name, ...])]

	expressions:
	  : expression[, expression, ...]

Output data from one or more relations.

A relation refers to any source of input data. It could be the contents of an existing table (or view), the joined result of two existing tables, or a subquery (the result of another SELECT statement).




\* (ALL)
^^^^^^^^^^^
Select all matching rows from the relation. Enabled by default.

DISTINCT
^^^^^^^^^
Select all matching rows from the relation then remove duplicate

WHERE
^^^^^^^
Filter rows by predicate.

*Like Operator*: used to match text values against a pattern using wildcards. If the search expression can be matched to the pattern expression, the LIKE operator will return true, which is 1.

There are two wildcards used in conjunction with the LIKE operator −

-	The percent sign (%)
-	The underscore (_)

::

	SELECT FROM table_name
	WHERE column LIKE 'XXXX%'


	SELECT FROM table_name
	WHERE column LIKE '%XXXX%'


	SELECT FROM table_name
	WHERE column LIKE 'XXXX_'


GROUP BY (Aggregate Functions)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
It is used in collaboration with the SELECT statement to group together those rows in a table that have identical data. This is done to eliminate redundancy in the output and/or compute aggregates that apply to these groups.
The GROUP BY clause follows the WHERE clause in a SELECT statement and precedes the ORDER BY clause.

::
	
	SELECT column-list
	FROM table_name
	WHERE [ conditions ]
	GROUP BY column1, column2....columnN
	ORDER BY column1, column2....columnN


*Common Aggregate Functions*

+--------------------+-------------------------------------------------------------------------------+
| Aggregate Function | Description                                                                   |
+====================+===============================================================================+
| COUNT()            | Returns the number of rows containing non-NULL values in the specified field. |
+--------------------+-------------------------------------------------------------------------------+
| SUM()	             | Returns the sum of the non-NULL values in the specified field.                |
+--------------------+-------------------------------------------------------------------------------+
| AVG()	             | Returns the average of the non-NULL values in the specified field.            |
+--------------------+-------------------------------------------------------------------------------+
| MAX()	             | Returns the maximum of the non-NULL values in the specified field.            |
+--------------------+-------------------------------------------------------------------------------+
| MIN()	             | Returns the minimum of the non-NULL values in the specified field.            |
+--------------------+-------------------------------------------------------------------------------+

HAVING
^^^^^^^
Filter grouped result by predicate.


ORDER BY
^^^^^^^^^
	Impose total ordering on a set of expressions. Default sort direction is ascending.

WINDOW
^^^^^^^
	Assign an identifier to a window specification. Insert a link here for further information on WINDOW Function.

LIMIT
^^^^^
	Limit the number of rows returned.

VALUES
^^^^^^
	Explicitly specify values instead of reading them from a relation.

COMMON TABLE EXPRESSIONS (CTE)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A common table expression is a temporary result set which you can reference within another SQL statement including SELECT, INSERT, UPDATE OR DELETE
Common Table Expressions are temporary in the sense that they only exist during the execution of the query.
The following shows the syntax of creating a CTE:

::

	WITH cte_name (column_list) AS (
    CTE_query_definition 
	)
	[SELECT STATEMENT]:[INSERT SATEMENT]:[UPDATE SATEMENT]:[DELETE SATEMENT];


e.g:

::

	with cte as'
	(SELECT * from ipl.individu)
	SELECT count(*) from cte

In this syntax

- First, specify the name of the CTE following by an optional column list.
- Second, inside the body of  WITH clause, specify a query that returns a result set. If you do not explicitly specify the column list after the CTE name, the select list of the cte query definition will become the column list of the CTE.
- Third, use the CTE like a table or view in the statement which can be a SELECT, INSERT, UPDATE OR DELETE

Common Table Expressions or CTEs are typically used to simplify complex joins and subqueries.

SAMPLING
--------
::
	
	SAMPLE:
	| TABLESAMPLE ((integer_expression | decimal_expression) PERCENT): TABLESAMPLE (integer_expression ROWS)

Sample the input data. This can be expressed in terms of either a percentage (must be between 0 and 1 00) or a fixed number of input rows

**eg**
::
	
	SELECT * FROM ipl.individu TABLESAMPLE (3 ROWS)
	SELECT * FROM ipl.individu TABLESAMPLE (25 PERCENT)

JOIN
----
::
	
	join_relation:
	    | relation join_type JOIN relation (ON boolean_expression | USING (column_name[, column_name, ...]))
	    : relation NATURAL join_type JOIN relation
	join_type:
	    | INNER
	    | (LEFT|RIGHT) SEMI
	    | (LEFT|RIGHT|FULL) [OUTER]
	    : [LEFT] ANTI

INNER JOIN
^^^^^^^^^^^
Select all rows from both relations where there is match.

OUTER JOIN
^^^^^^^^^^^
Select all rows from both relations, filling with null values on the side that does not have a match.

SEMI JOIN
^^^^^^^^^^
Select only rows from the side of the SEMI JOIN where there is a match. If one row matches multiple rows, only the first match is returned.

LEFT ANTI JOIN
^^^^^^^^^^^^^^^
Select only rows from the left side that match no rows on the right side.
**eg**
::
	
	SELECT a.game_id, 
	                a.venue,
	                b.game_id,
	                b.venue
	from bbl.bbl01cs a 
	inner join bbl.bbl02cs b
	on a.competition=b.competition

	SELECT a.game_id, 
	                a.venue,
	                b.game_id,
	                b.venue
	from bbl.bbl01cs a 
	left join bbl.bbl02cs b
	on a.venue=b.venue

Joining multiple data sources
::
	
	SELECT a.game_id as wbbl_game_id
           , a.competition
           , b.game_id
           , b.competition
           FROM wbbl.wbbl01c a
           inner join
           bbl.bbl01cs b
           on a.game_id=b.game_id
           group by 1,2,3,4
           limit 10



LATERAL VIEW
------------

::

	SELECT  a.game_id as wbbl_game_id
	        , a.competition
	        , b.game_id
	        , b.competition
	        FROM wbbl.wbbl01c a
	        inner join
	        bbl.bbl01cs b
	        on a.game_id=b.game_id
	        group by 1,2,3,4
	        limit 10

::
	
	lateral_view:
	    : LATERAL VIEW [OUTER] function_name (expressions)
	          table_name [AS (column_name[, column_name, ...])]

Generate zero or more output rows for each input row using a table-generating function. The most common built-in function used with LATERAL VIEW is explode.

LATERAL VIEW OUTER
^^^^^^^^^^^^^^^^^^^
Generate a row with null values even when the function returned zero rows.
**eg:**
::‰

	SELECT * FROM bbl.bbl01cs LATERAL VIEW explode(Array(1, 2, 3)) my_view

AGGREGATION
-------------
::

	aggregation:
	    : GROUP BY expressions [(WITH ROLLUP | WITH CUBE | GROUPING SETS (expressions))]

Group by a set of expressions using one or more aggregate functions. Common built-in aggregate functions include count, avg, min, max, and sum.

ROLLUP
^^^^^^
Create a grouping set at each hierarchical level of the specified expressions. For instance, For instance, GROUP BY a, b, c WITH ROLLUP is equivalent to GROUP BY a, b, c GROUPING SETS ((a, b, c), (a, b), (a), ()). The total number of grouping sets will be N + 1, where N is the number of group expressions.

CUBE
^^^^^
Create a grouping set for each possible combination of set of the specified expressions. For instance, GROUP BY a, b, c WITH CUBE is equivalent to GROUP BY a, b, c GROUPING SETS ((a, b, c), (a, b), (b, c), (a, c), (a), (b), (c), ()). The total number of grouping sets will be 2^N, where N is the number of group expressions.

GROUPING SETS
^^^^^^^^^^^^^^
Perform a group by for each subset of the group expressions specified in the grouping sets. For instance, GROUP BY x, y GROUPING SETS (x, y) is equivalent to the result of GROUP BY x unioned with that of GROUP BY y.
5.4

**eg**
::
	
	SELECT venue, COUNT(*) AS num_matches FROM wbbl.wbbl01c GROUP BY venue

	SELECT venue, AVG(batsman_runs) AS avg_runs FROM wbbl.wbbl01c GROUP BY venue

	SELECT venue, fixture, batsman_name FROM wbbl.wbbl01c GROUP BY venue, fixture, batsman_name WITH ROLLUP

	SELECT venue, fixture, AVG(batsman_runs)  FROM wbbl.wbbl01c GROUP BY venue, fixture   GROUPING SETS (venue, fixture)



WINDOW FUNCTION
---------------
::

	window_expression:
	 : expression OVER window_spec
	named_window:
	: window_identifier AS window_spec
	window_spec: 
	| window_identifier
	: ((PARTITION|DISTRIBUTE) BY expressions
	 [(ORDER|SORT) BY sort_expressions] [window_frame])
	window_frame:
	| (RANGE|ROWS) frame_bound
	: (RANGE|ROWS) BETWEEN frame_bound AND frame_bound
	frame_bound:
	| CURRENT ROW
	 | UNBOUNDED (PRECEDING|FOLLOWING)
	  : expression (PRECEDING|FOLLOWING)

Compute a result over a range of input rows. A windowed expression is specified using the OVER keyword, which is followed by either an identifier to the window (defined using the WINDOW keyword) or the specification of a window.

PARTITION BY
^^^^^^^^^^^^^
Specify which rows will be in the same partition, aliased by DISTRIBUTE BY.

ORDER BY
^^^^^^^^^
Specify how rows within a window partition are ordered, aliased by SORT BY.

RANGE BOUND
^^^^^^^^^^^^
Express the size of the window in terms of a value range for the expression.

ROWS bound
^^^^^^^^^^^
Express the size of the window in terms of the number of rows before and/or after the current row.

CURRENT ROW
^^^^^^^^^^^^
Use the current row as a bound.

UNBOUNDED
^^^^^^^^^
Use negative infinity as the lower bound or infinity as the upper bound.

PRECEDING
^^^^^^^^^
If used with a RANGE bound, this defines the lower bound of the value range. If used with a ROWS bound, this determines the number of rows before the current row to keep in the window.

FOLLOWING
^^^^^^^^^^
If used with a RANGE bound, this defines the upper bound of the value range. If used with a ROWS bound, this determines the number of rows after the current row to keep in the window.

**eg:**

HINTS
------
::

	hints:
	: /*+ hint[, hint, ...] */
	hint:
	: hintName [(expression[, expression, ...])]

Hints can be used to help execute a query better. For example, you can hint that a table is small enough to be broadcast, which would speed up joins. You add one or more hints to a SELECT statement inside /\*+ ... \*/ comment blocks. Multiple hints can be specified inside the same comment block, in which case the hints are separated by commas, and there can be multiple such comment blocks. A hint has a name (for example, BROADCAST) and accepts 0 or more parameters.

**eg:**

DATASOURCE VIEW
----------------
View is virtual table based on the result-set of an SQL statement.
A view contains rows and columns, just like a real table. The fields in a view are fields from one or more real tables in the database. Using Zetaris Data Fabric, tables/views from multiple data sources can be used to create a new view. 
You can add SQL functions, WHERE, and JOIN statements to a view and present the data as if the data were coming from one single table.
::

	CREATE VIEW [OR ALTER] schema_name.view_name [(column_list)]
	AS
	    select_statement;

In this syntax:

- First, specify the name of the view after the CREATE VIEW keywords. The schema_name is the name of the schema to which the view belongs.
- Second, specify a SELECT statement (select_statement) that defines the view after the AS keyword. The SELECT statement can refer to one or more tables.

If you don’t explicitly specify a list of columns for the view, SQL Server will use the column list derived from the SELECT statement.

In case you want to redefine the view e.g., adding more columns to it or removing some columns from it, you can use the OR ALTER keywords after the CREATE VIEW keywords.

**eg:**

CAST OPERATOR
--------------
There are many cases that you want to convert a value of one data type into another. PostgreSQL provides you with the CAST operator that allows you to do this.

The following illustrates the syntax of type CAST:
::

	CAST ( expression AS target_type );

In this syntax:

•	First, specify an expression that can be a constant, a table column, an expression that evaluates to a value.
•	Then, specify the target data type to which you want to convert the result of the expression.

**eg:**
::
	
	SELECT

	   CAST ('100' AS INTEGER);

If the expression cannot be converted to the target type, PostgreSQL will raise an error. See the following example:
::

	SELECT
	   CAST ('10C' AS INTEGER);
	[Err] ERROR:  invalid input syntax for integer:

	SELECT
	   CAST ('2015-01-01' AS DATE),
	   CAST ('01-OCT-2015' AS DATE);



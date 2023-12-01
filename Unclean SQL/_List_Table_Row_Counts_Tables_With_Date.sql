;with cte as (
SELECT sc.name, ta.name TableName, SUM(pa.rows) RowCnt
 FROM sys.tables ta
 INNER JOIN sys.partitions pa ON pa.OBJECT_ID = ta.OBJECT_ID
 INNER JOIN sys.schemas sc  ON ta.schema_id = sc.schema_id
 WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
 GROUP BY sc.name,ta.name
), cte2  as (
select c.TableName,c.RowCnt from cte c
inner join ( SELECT distinct
	SchemaName = c.table_schema, TableName = c.table_name 
	FROM information_schema.columns c
	INNER JOIN information_schema.tables t
		ON c.table_name = t.table_name AND c.table_schema = t.table_schema AND t.table_type = 'BASE TABLE'
	where data_type not in ( 'bigint','bit','char','decimal','float','int','numeric','nvarchar','smallint','text','tinyint','uniqueidentifier','varchar','xml') ) t 
		on c.tablename=t.tablename
)
select TableName,Rowcnt from cte2
order by TableName
--Finds Unused Indexes
use dba
Declare @SQL nvarchar(4000), @dbname varchar(256) 
Set nocount on

IF OBJECT_ID('tmpListAllUnUsedIndexes') is not null 
	Begin
		DROP TABLE dba.dbo.tmpListAllUnUsedIndexes;
	End
	
create table dba.dbo.tmpListAllUnUsedIndexes ( DBname nVarChar(512), IndexName nVarChar(512), Index_ID int, Reads bigint, Writes bigint, Rows bigint, Reads_Per_Write decimal(38,15), Drop_StateMent varchar(max))

--Declare and open cursor pointing to all historical DB's
DECLARE DB_Cursor CURSOR FAST_FORWARD FOR

select name from sys.databases
where name not in('master', 'tempdb', 'msdb','model','distribution','dba', 'SystemDataCollection')

OPEN DB_Cursor

FETCH NEXT FROM DB_Cursor INTO @dbname

WHILE @@FETCH_STATUS = 0
	BEGIN
	
		set @sql='use ['+@dbname+'];		
		SELECT o.name, indexname=i.name, i.index_id  , reads=user_seeks + user_scans + user_lookups  , writes =  user_updates  
			, rows = (SELECT SUM(p.rows) FROM sys.partitions p WHERE p.index_id = s.index_id AND s.object_id = p.object_id)
			, CASE
		WHEN s.user_updates < 1 THEN 100
		ELSE 1.00 * (s.user_seeks + s.user_scans + s.user_lookups) / s.user_updates
		END AS reads_per_write
		, ''DROP INDEX '' + QUOTENAME(i.name)
		+ '' ON '' + QUOTENAME(c.name) + ''.'' + QUOTENAME(OBJECT_NAME(s.object_id)) as ''drop statement''
		FROM sys.dm_db_index_usage_stats s 
			INNER JOIN sys.indexes i ON i.index_id = s.index_id AND s.object_id = i.object_id  
			INNER JOIN sys.objects o on s.object_id = o.object_id
			INNER JOIN sys.schemas c on o.schema_id = c.schema_id
		WHERE OBJECTPROPERTY(s.object_id,''IsUserTable'') = 1 AND s.database_id = DB_ID() AND i.type_desc = ''nonclustered'' AND i.is_primary_key = 0
			AND i.is_unique_constraint = 0 AND (SELECT SUM(p.rows) FROM sys.partitions p WHERE p.index_id = s.index_id AND s.object_id = p.object_id) > 10000
		ORDER BY indexname'
		
		insert tmpListAllUnUsedIndexes( DBname, IndexName, Index_ID, Reads, Writes, Rows, Reads_Per_Write, Drop_StateMent ) exec sp_sqlexec @sql
		FETCH NEXT FROM DB_Cursor INTO @dbname

	End
CLOSE DB_Cursor
DEALLOCATE DB_Cursor

select * from tmpListAllUnUsedIndexes
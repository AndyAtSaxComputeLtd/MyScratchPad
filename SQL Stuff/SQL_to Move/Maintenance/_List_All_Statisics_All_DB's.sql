-- Lists and Deletes(commented out) All Statsisics 
use dba
--lists all triggers all databases
Set nocount on
declare @SQL nvarchar(max)
--Check Work Table exist
IF object_id('dba.dbo.Statistics_List') IS NOT NULL DROP TABLE dba.dbo.Statistics_List;
CREATE TABLE dba.[dbo].[Statistics_List]( [DBname] [nvarchar](512) NULL, ColumnName [nvarchar](512) NULL, [TableName] [nvarchar](512) NULL, [StatisticsName] [nvarchar](512) NULL) ON [PRIMARY]

set @SQL='use [?];
;with cte as (
	SELECT ''?'' as DBname, OBJECT_NAME(s.[object_id]) AS TableName,
		c.name AS ColumnName,
		s.name AS StatName,
		s.auto_created
	FROM sys.stats s JOIN sys.stats_columns sc 
		ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
	JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
	WHERE OBJECTPROPERTY(s.OBJECT_ID,''IsUserTable'') = 1
		
	)
	Select [DBname], [TableName], [ColumnName],[StatName] from cte;'

Insert into dba.dbo.Statistics_List ( DBName, TableName, ColumnName, StatisticsName)  
exec sp_MSForeachdb @SQL

-- Setup Cursor to delete Stats
-- Setup cursor to SELECT all databases to work
Declare @DBName varchar(256), 
	@TableName  varchar(256), 
	@ColumnName  varchar(256), 
	@StatisticsName	varchar(256)

DECLARE A_Cursor CURSOR FAST_FORWARD FOR

select DBName, TableName, ColumnName, StatisticsName from  dba.dbo.Statistics_List
	where 1=1
		and (TableName = 'ImageInfo' and ColumnName = 'Image' -- Auto Stats on Image Column
			and StatisticsName like '_WA_Sys_%') --AutoStatistics Name 

OPEN A_Cursor

FETCH NEXT FROM A_Cursor INTO @dbname, @TableName,@ColumnName , @StatisticsName

--Loop through all tenants
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = 'USE [' + @DBName + ']; drop statistics ' + @TableName +'.' + @StatisticsName
		print @sql
		-- exec sp_executesql @SQL
		FETCH NEXT FROM A_Cursor INTO @dbname, @TableName,@ColumnName , @StatisticsName
	END 
CLOSE A_Cursor
DEALLOCATE A_Cursor

	

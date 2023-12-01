--lists all long running updates
declare @SQL nvarchar(max)

IF object_id('dba.dbo.tmpStatiscsList') IS NOT NULL DROP TABLE dba.dbo.tmpStatiscsList;
create table dba.dbo.tmpStatiscsList (DBName VarChar(512), TableName VarChar(512), ColumnName VarChar(512), StatName VarChar(512),AutoCreated int	, UserCreated int)

set @SQL='
;with cte (DBName, TableName, ColumnName, StatName,AutoCreated, UserCreated) as (
	SELECT ''?'' as DBname,
		OBJECT_NAME(s.[object_id]) AS TableName,
		c.name AS ColumnName,
		s.name AS StatName,
		s.auto_created,
		s.user_created
	FROM sys.stats s JOIN sys.stats_columns sc ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
	JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
	WHERE OBJECTPROPERTY(s.OBJECT_ID,''IsUserTable'') = 1
	AND (s.auto_created = 1 OR s.user_created = 1) )

Select DBName, TableName, ColumnName, StatName,AutoCreated, UserCreated from cte '

Print @SQL

Insert into dba.dbo.tmpStatiscsList ( DBName, TableName, ColumnName, StatName,AutoCreated, UserCreated)  exec sp_MSForeachdb @SQL

select ID, DatabaseName,SchemaName,ObjectName as TableName,
		StatisticsName,ColumnName as Stats_on_Column,
		DATEDIFF(MINUTE,StartTime,EndTime) as [Time(mins)],AutoCreated, UserCreated
	from dba.dbo.CommandLog cl
	left join dba.dbo.tmpStatiscsList SL  
		on cl.DatabaseName = SL.DBName 
		and cl.ObjectName = SL.TableName 
		and cl.StatisticsName = SL.StatName
	where 
		StatisticsName is not null  
		and DATEDIFF(MINUTE,StartTime,EndTime) > 10
	order by [Time(mins)] desc

--Remove entriess from log to clear alarm.	
--delete from  dba.dbo.CommandLog
--	where 
--		StatisticsName is not null  
--		and DATEDIFF(MINUTE,StartTime,EndTime) > 10



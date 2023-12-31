IF OBJECT_ID('tempdb..#top10dbs') IS NOT NULL DROP TABLE #top10dbs
CREATE TABLE  #top10dbs (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))

Declare @Name nvarchar(4000)
DECLARE @SQL NVARCHAR(4000);
SET NOCOUNT ON

DECLARE a_cursor CURSOR FAST_FORWARD FOR

select name
	from sys.databases sid

OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @Name
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL='USE ['+@Name+'];SELECT '''+@Name+''' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM ['+@Name+'].sys.database_files'
		INSERT INTO #top10dbs
		exec sp_executesql @sql
		FETCH NEXT FROM a_cursor INTO @Name
	END 
CLOSE a_cursor
DEALLOCATE a_cursor

;with cte as (
select 	Dbname 
	,Filename 
	,Type 
	,Filepath 
	,TotalSize_MB 
	,Space_Used_MB 
	,TotalSize_MB - Space_Used_MB as Remaining_MB
	,Autogrow_Value 
	,Max_Size 
	, cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) as PrecentageRemaining 
from #top10dbs
)
select 'USE '+QUOTENAME(dbname)+'; DBCC SHRINKDATABASE(N'''+dbname+''', 21 )', DBname, Filename, Type, Filepath, TotalSize_MB, Space_Used_MB, Remaining_MB, Autogrow_Value,Max_Size, PrecentageRemaining from cte 
where 1=1
	and Dbname  not in ('msdb','master','tempdb','distribution','model')
	and TYPE = 'rows'
	--And Space_Used_MB < 100
	--and cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) > 30
	--and Dbname = 'dba'
	and PrecentageRemaining > 20 and TotalSize_MB >600 and TotalSize_MB < 24320
order by TotalSize_MB
--PrecentageRemaining desc, TotalSize_MB desc


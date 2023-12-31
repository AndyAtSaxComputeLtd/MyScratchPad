DECLARE @SQL VARCHAR(8000);
SET NOCOUNT ON
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'
IF OBJECT_ID('tempdb..#top10dbs') IS NOT NULL DROP TABLE #top10dbs
CREATE TABLE  #top10dbs (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))
INSERT INTO #top10dbs

EXEC sp_msforeachdb @SQL

-- delete logs from optimize lists 
delete from #top10dbs where Type = 'log' or [totalsize_mb] < 5000
-- remove db's which have low space remaining
delete  from #top10dbs where dbname in (SELECT Dbname  from #top10dbs where cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) < 30 )
--Remove system dbs
delete  from #top10dbs where dbname in ('msdb','master','tempdb','model','distribution','tempdb')
--remove empty DBs
--delete  from #top10dbs where dbname in (SELECT Dbname  from #top10dbs where cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) > 98)

select dbname, filename from #top10dbs 	Order by [DBName]

Declare @DBname nvarchar(512), @FileName nvarchar(512)

DECLARE a_cursor CURSOR FAST_FORWARD FOR

SELECT [DBname], [FileName] 
	FROM #top10dbs
	Order by [DBName]

OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @DBname, @FileName

WHILE @@FETCH_STATUS = 0
	BEGIN
		--set @sql = 'use ['+@DBName+']; DBCC SHRINKFILE (N'''+@FileName+''' , 0, TRUNCATEONLY)'
		--print @sql
		----EXEC sp_msforeachdb @SQL
		--set @sql = 'use ['+@DBName+']; DBCC SHRINKFILE (N'''+@FileName+''' , 5000000)'
		--print @sql
		----EXEC sp_msforeachdb @SQL
		print @sql
		set @sql = 'use ['+@DBName+']; DBCC SHRINKDATABASE(N'''+@DBname+''', 20 )'
		--EXEC sp_msforeachdb @SQL
		FETCH NEXT FROM a_cursor INTO @DBname, @FileName
	END 
CLOSE a_cursor
DEALLOCATE a_cursor





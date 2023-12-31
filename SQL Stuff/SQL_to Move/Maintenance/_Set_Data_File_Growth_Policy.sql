--Procedure to select and alter data files autogrow values and max sizes

DECLARE @SQL NVARCHAR(4000);
SET NOCOUNT ON
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'

IF object_id('tempdb..##Fdetails') IS NOT NULL  DROP TABLE ##Fdetails
CREATE TABLE  ##Fdetails (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))

IF object_id('tempdb..#SQL_ALTER_DB') IS NOT NULL DROP TABLE #SQL_ALTER_DB
CREATE TABLE  #SQL_ALTER_DB (SQL varchar(max))

--list all databases and spaces
INSERT INTO ##Fdetails
EXEC sp_msforeachdb @SQL

--list dynamic sql for databases >1GB
insert into #SQL_ALTER_DB (SQL)
SELECT 'use [master]; ALTER DATABASE [' + dbname + '] MODIFY FILE ( NAME = N'''+filename+''', MAXSIZE = 100000MB);ALTER DATABASE [' + dbname + '] MODIFY FILE ( NAME = N'''+filename+''', FILEGROWTH = 400MB )' as SQL
	FROM ##Fdetails where 
		DBname in( SELECT Dbname from ##Fdetails where type = 'rows' and TotalSize_MB >= 1000) and 
		type = 'rows' and dbname not in ('tempdb','master','msdb','model','systemadministrator')  

--list dynamic sql for databases <1GB
insert into #SQL_ALTER_DB (SQL)
SELECT 'use [master]; ALTER DATABASE [' + dbname + '] MODIFY FILE ( NAME = N'''+filename+''', MAXSIZE = 100000MB);ALTER DATABASE [' + dbname + '] MODIFY FILE ( NAME = N'''+filename+''', FILEGROWTH = 200MB )' as SQL
	FROM ##Fdetails where 
		DBname in( SELECT Dbname from ##Fdetails where type = 'rows' and TotalSize_MB < 1000) and 
		type = 'rows' and dbname not in ('tempdb','master','msdb','model','systemadministrator')  

select * from #sql_alter_db
While ( select count(SQL) from #SQL_ALTER_DB ) > 0	
begin	
	select top 1 @SQL=SQL from #SQL_ALTER_DB order by sql
	print @SQL
	exec sp_executesql @SQL
	delete from #SQL_ALTER_DB where sql=@SQL
end

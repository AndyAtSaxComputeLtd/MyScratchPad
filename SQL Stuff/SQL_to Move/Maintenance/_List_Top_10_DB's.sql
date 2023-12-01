--list top 10 databases on this server
DECLARE @SQL VARCHAR(8000);
SET NOCOUNT ON
SET @SQL='USE [?];
SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] 
FROM [?].sys.database_files'

IF OBJECT_ID('dba.dbo.Top10DBs') IS NULL CREATE TABLE  dba.dbo.Top10DBs (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))
	
Truncate TABLE dba.dbo.Top10DBs

INSERT INTO dba.dbo.Top10DBs
EXEC sp_msforeachdb @SQL

-- remove system databases from list
delete from dba.dbo.Top10DBs where DBName in (
	'master', 'tempdb', 'model', 'msdb', 'dba', 'SystemDataCollection', 
	'distribution','SystemAdministrator','Capacity','CapacityMonitor')
	
-- remove logs from list
Delete from dba.dbo.Top10DBs where type = 'log'  

-- keep top 10 DB's
Delete from dba.dbo.Top10DBs  where DBName NOT IN (SELECT TOP 10 Dbname FROM dba.dbo.Top10DBs  order by TotalSize_MB desc )

DECLARE @SQL VARCHAR(8000);
SET NOCOUNT ON
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'
IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##Fdetails') DROP TABLE ##Fdetails
CREATE TABLE  ##Fdetails (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))
INSERT INTO ##Fdetails
EXEC sp_msforeachdb @SQL

;with CTE (Name, FileName, Type, FilePath, MaxSize_MB, TotalSize_MB, Space_Used_MB, Remaining_MB, AutoGrowValue, PercentageRemaining) as (
SELECT Dbname ,Filename ,Type,Filepath,Max_Size ,TotalSize_MB ,Space_Used_MB, TotalSize_MB - Space_Used_MB as [Remaining_MB],Autogrow_Value ,
    cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) as Percentage
FROM ##Fdetails )

Select cte.* 
--into dba.dbo.dblog2502
from CTE cte

join sys.databases sysdb on sysdb.name = cte.name
join sys.database_mirroring dm on sysdb.database_id = dm.database_id

where type = 'log' and mirroring_state_desc is not null
-- and 
--Name in ('msdb','tempdb','master','model')
--name like 'exp%'
ORDER BY --remaining_mb desc
TotalSize_MB desc

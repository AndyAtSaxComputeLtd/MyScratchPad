--
--Check disk sizes and backup status for large logs
--
DECLARE @SQL VARCHAR(8000);
SET NOCOUNT ON
SET @SQL='USE [?]
SELECT ''?'' [Dbname],[name] [Filename],left(physical_name,1), type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value], CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'

IF object_id('tempdb..#Fdetails') IS NOT NULL DROP TABLE #Fdetails
IF object_id('tempdb..#tbl_xp_fixeddrives') IS NOT NULL DROP TABLE #tbl_xp_fixeddrives
IF object_id('dba.dbo.BackupStatusTable') IS NOT NULL DROP TABLE [dba].[dbo].[BackupStatusTable];

CREATE TABLE #tbl_xp_fixeddrives (Drive varchar(2) NOT NULL,[MB free] int NOT NULL)
CREATE TABLE  #Fdetails (Dbname VARCHAR(50),Filename VARCHAR(50),Drive varchar(2),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))

-- get free space - all driver
INSERT INTO #tbl_xp_fixeddrives(Drive, [MB free])
EXEC master.sys.xp_fixeddrives

-- Get backup status
SELECT d.name, d.recovery_model_desc, MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date], MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date], MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) AS [last_log_backup_date]
INTO [dba].[dbo].[BackupStatusTable] FROM sys.databases d
LEFT JOIN msdb.dbo.backupset bs ON bs.database_name = d.name
GROUP BY d.name, d.recovery_model_desc

INSERT INTO #Fdetails
EXEC sp_msforeachdb @SQL

SELECT top 20 Dbname ,Filename ,Filepath,[MB Free]/1024 as [Disk Free GB], Max_Size as [DB Max Size] ,TotalSize_MB as [DB Total Size], TotalSize_MB - Space_Used_MB as [DB Remaining MB], last_full_backup_date, last_log_backup_date FROM #Fdetails fd

left outer join #tbl_xp_fixeddrives dr on fd.Drive = dr.Drive
left outer join [dba].[dbo].[BackupStatusTable] bk on fd.dbname = bk.name

where type='log'  
order by TotalSize_MB desc

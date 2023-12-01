DECLARE @SQL NVARCHAR(max),  @Counter INT
SET NOCOUNT ON
SET @Counter =1
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'
IF object_id('dba.dbo.DB_Log') IS NULL CREATE TABLE dba.dbo.DB_Log ( ID INT, DB_LOG VARChar(max), TS DateTime default GetDate() ) ;
IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##Fdetails') DROP TABLE ##Fdetails
IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##Fdetails3') DROP TABLE ##Fdetails3
IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##Fdetails2') DROP TABLE ##Fdetails2
CREATE TABLE  ##Fdetails (ID INT Identity(1,1),Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))
CREATE TABLE  ##Fdetails3 (ID INT Identity(1,1),Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))

INSERT INTO ##Fdetails
EXEC sp_msforeachdb @SQL

CREATE TABLE  ##Fdetails2 (ID INT Identity(1,1),Dbname VARCHAR(50),Filename VARCHAR(50), SQLRUN NVARCHAR(2048))

Insert INTO ##FDetails2(Dbname,Filename, SQLRUN ) 
	select DBname, Filename, 'use ['+dbname+'];DBCC SHRINKFILE (N'''+Filename+''','+cast(cast(Space_Used_MB*1.2 as INT) AS varchar(10))+')'
from ##Fdetails WHERE type = 'LOG' and TotalSize_MB > 500 and Dbname <> 'tempdb'

select * from ##Fdetails2

WHILE @Counter <= (SELECT COUNT(*) FROM ##Fdetails2)
	BEGIN
		SELECT @SQL = SQLRUN FROM ##Fdetails2 WHERE ID = @Counter;
		PRINT @SQL;
		Insert into dba.dbo.DB_Log ( DB_LOG) Select @SQL;
		exec sp_ExecuteSQL @SQL
		SET @Counter = @Counter + 1	
	END
	
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'
INSERT INTO ##Fdetails3
	EXEC sp_msforeachdb @SQL;
	
Select DBname,Filename, TotalSize_MB, Space_Used_MB from ##FDetails WHERE type = 'LOG' and TotalSize_MB > 500 ORDER BY DBname;
Select DBname,Filename, TotalSize_MB, Space_Used_MB  from ##FDetails3 WHERE type = 'LOG' and TotalSize_MB > 500 ORDER BY DBname;



	




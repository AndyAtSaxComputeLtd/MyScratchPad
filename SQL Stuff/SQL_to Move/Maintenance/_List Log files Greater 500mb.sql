DECLARE @SQL VARCHAR(8000)
SET NOCOUNT ON
SET @SQL='USE [?]
SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'
IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##Fdetails') DROP TABLE ##Fdetails
CREATE TABLE  ##Fdetails (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))
INSERT INTO ##Fdetails
EXEC sp_msforeachdb @SQL
SELECT Dbname ,Filename ,Type,Filepath,Max_Size ,TotalSize_MB ,Space_Used_MB, TotalSize_MB - Space_Used_MB as [Remaining_MB],Autogrow_Value FROM ##Fdetails  
Where Type='LOG' and TotalSize_MB >500
ORDER BY 
TotalSize_MB DEsc
--Dbname

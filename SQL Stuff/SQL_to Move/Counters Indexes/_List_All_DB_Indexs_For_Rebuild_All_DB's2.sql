DECLARE @Counter		INT
DECLARE @Index_Counter	INT
DECLARE @MAXCOUNT		INT
DECLARE @DB_Name		NVARChar(max)
DECLARE @Index_Name		NVARCHAR(max)
DECLARE @Table_Name		NVARCHAR(max)
DECLARE @SQLRUN			NVARChar(max)
DECLARE @DB_Number		INT

SET NOCOUNT ON
Print 'Setting up'
IF object_id('tempdb..#DB_List') IS NOT NULL DROP TABLE #DB_List;
IF object_id('dba.dbo.Index_List') IS NOT NULL DROP TABLE dba.dbo.Index_List;
IF object_id('dba.dbo.Index_List2') IS NOT NULL DROP TABLE dba.dbo.Index_List2;
IF object_id('dba.dbo.Index_Rebuild') IS NOT NULL DROP TABLE dba.dbo.Index_Rebuild;       
IF object_id('dba.dbo.Index_Reorg') IS NOT NULL DROP TABLE dba.dbo.Index_Reorg;
    
IF object_id('dba.dbo.DB_Log') IS  NULL CREATE TABLE dba.dbo.DB_Log ( ID INT Identity(1,1), DB_LOG VARChar(MAX), TS DateTime default GetDate() );

IF object_id('dba.dbo.Index_History') IS  NULL CREATE TABLE dba.dbo.Index_History (ID INT, TS DateTime default GetDate(),DBname VARChar(max),Index_Name VARChar(max), Table_Name VARChar(max), PercentFrag INT,page_count INT,Index_type_desc VARChar(100) );

CREATE TABLE #DB_List ( ID INT Identity(1,1), DBname VARChar(max)  )
CREATE TABLE dba.dbo.Index_List (ID INT Identity(1,1), TS DateTime default GetDate(),DBname VARChar(max),Index_Name VARChar(max), Table_Name VARChar(max), PercentFrag INT,page_count INT,Index_type_desc VARChar(100))
CREATE TABLE dba.dbo.Index_Rebuild (ID INT Identity(1,1), TS DateTime default GetDate(),DBname VARChar(max),Index_Name VARChar(max), Table_Name VARChar(max), PercentFrag INT,page_count INT,Index_type_desc VARChar(100))
CREATE TABLE dba.dbo.Index_Reorg (ID INT Identity(1,1), TS DateTime default GetDate(),DBname VARChar(max),Index_Name VARChar(max), Table_Name VARChar(max), PercentFrag INT,page_count INT,Index_type_desc VARChar(100))


print 'Getting list of DBs'		
print getdate()	
-- Get List of Databases - exclude system db's
INSERT INTO #DB_List( DBname )
	select name from sys.databases
		where name not in ('distribution','master','model','msdb','tempdb' )	
			
Delete from #DB_List
	where DBname in ('distribution','master','model','msdb','tempdb')
	--,	'BtinfonetHistorical','apj_psl_emchistorical','apj-psl-emcHistorical','cnhcanhistorical','geoservicesHistorical','ImighdHistorical','SystemAdministrator') or DBname like 'apj%'
			
Print 'Looking up Fragmentation all DBs'
-- Set up loop for DB

SET @Counter = 1
WHILE @Counter <= (SELECT COUNT(*) FROM #DB_List)
	BEGIN
		SELECT @DB_Name = DBname FROM #DB_List WHERE ID = @Counter;
		--exec ('use '+@DB_Name)
		Insert into dba.dbo.DB_log (DB_LOG) Select @DB_Name
		-- Create temp table listing index name and table name for index rebuild
		--Look up DB_Number as DB_ID() doesnt always work
		select @db_Number = Database_id from sys.databases where name = @DB_Name
		set @SQLRUN = 'use [' + @DB_Name + ']; INSERT INTO dba.dbo.Index_List 
			(DBName,[Index_Name], Table_Name,PercentFrag,page_count,Index_type_desc) 
				select '+''''+@DB_Name+''''+', i.name, t.name, avg_fragmentation_in_percent,page_count,Index_type_desc  
					FROM sys.dm_db_index_physical_stats ('+cast(@DB_Number as varchar(100))+', NULL, NULL, NULL , ''Limited'') s 
						inner join  sys.tables t on s.object_id=t.object_id 
						inner join  sys.indexes i on s.index_id = i.index_id and s.object_id=i.object_id;'
		print @SQLRUN
		exec sp_ExecuteSQL @SQLRUN
		SET @Counter = @Counter + 1	
	END

INSERT INTO [dba].[dbo].[Index_History] (ID, TS, DBname, Index_Name, Table_Name, PercentFrag, page_count,Index_type_desc)
	Select ID, TS, DBname, Index_Name, Table_Name, PercentFrag, page_count,Index_type_desc
		FROM [dba].[dbo].[Index_List]
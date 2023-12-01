--
-- Fix List issues with multipleDatabase Tables
-- Inspect every Database for a give table
-- and Complete a Task on it.
-- Written By Andy Hollings 31/5/2013
--

USE [dba]
GO

-- Setup Enviroment / Workspace
Declare @Counter int, @TotalCount int, @DB_Name varchar(512), @SQLRUN nvarchar(4000);

IF object_id('dba.dbo.tmp_Tables_Need_Work') IS NOT NULL DROP TABLE dba.dbo.tmp_Tables_Need_Work;
CREATE TABLE dba.dbo.tmp_Tables_Need_Work (ID INT Identity(1,1), [DB_name] VARChar(1024) )

IF object_id('dba.dbo.tmpAllTables') IS NOT NULL DROP TABLE dba.dbo.tmpAllTables;
CREATE TABLE dba.dbo.tmpAllTables ( [DB_Name] [varchar](256) ,	[Table_Name] [varchar](256) )

IF object_id('dba.dbo.tmpTableRowCount') IS NOT NULL DROP TABLE dba.dbo.tmpTableRowCount;
CREATE TABLE dba.dbo.tmpTableRowCount ( [DB_Name] [varchar](256) ,	[RowCount] int )

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

--
-- List all Databases including systems
--

exec sp_MSforeachdb 'use [?]; 

insert dba.dbo.tmpAllTables ([DB_Name], Table_Name)
Select ''?'' as [DB_Name] ,name from sys.tables '

--
-- Search for a given table name
--

insert into dba.dbo.tmp_Tables_Need_Work ( [DB_name] )
select [DB_NAME] from dba.dbo.tmpAllTables where Table_Name like 'AgentsStateChanges'

--
-- Do Work on the specified Table
--
SET @Counter = 1
SELECT @Totalcount=COUNT(*) FROM dba.dbo.tmp_Tables_Need_Work
WHILE @Counter <= @TotalCount
	BEGIN
		Select @DB_Name = [DB_name] FROM dba.dbo.tmp_Tables_Need_Work WHERE ID = @Counter;
		-- Dynamic Quere or Table Modifications go here
		set @SQLRUN = 
			'insert into  dba.dbo.tmpTableRowCount ([DB_Name],[RowCOunt]) 
			Select ' + CHAR(39)+ @DB_Name + CHAR(39) + ', count(tenant_id) from [' + @DB_Name + '].dbo.AgentsStateChanges 
			where StateEndTime is null'
		print @SQLRUN
		exec sp_ExecuteSQL @SQLRUN
		SET @Counter = @Counter + 1	
	END

--Ouput Results
Select * from dba.dbo.tmpTableRowCount where [ROWCOUNT] >0
order by [DB_Name]

-- Cleanup
drop table dba.dbo.tmpTableRowCount
drop table dba.dbo.tmp_Tables_Need_Work
drop table dba.dbo.tmpAllTables








--lists all tables all databases

declare @SQL nvarchar(max)
IF object_id('dba.dbo.tmpListTables') IS NOT NULL DROP TABLE dba.dbo.tmpListTables
create table dba.dbo.tmpListTables (DBName VarChar(512), TableName VarChar(512))

set @SQL='use [?];
	if ''?'' <> ''master'' and ''?'' <> ''msdb'' and ''?'' <> ''tempdb'' and ''?'' <> ''systemdatacollection''
		and ''?'' <> ''distribution'' and ''?'' <> ''dba''
		Begin
			;with cte as (select ''[?]'' as [DBname],name as [TableName] from sys.tables )
				Select [DBname],[TableName] from cte;
		End'

Print @SQL

Insert into dba.dbo.tmpListTables ( DBName, TableName )  exec sp_MSForeachdb @SQL

select * from dba.dbo.tmpListTables where TableName like '%BT_AgentSummary%'

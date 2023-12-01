declare @SQL nvarchar(max)

IF object_id('dba.dbo.tmpListAllIndexes') IS NOT NULL DROP TABLE dba.dbo.tmpListAllIndexes;
create table dba.dbo.tmpListAllIndexes ( DBname nVarChar(512), SchemaName nVarChar(512), TableName nVarChar(512), IndexName nVarChar(512))

set @SQL='use [?];print ''?'';
;With CTE (DBname, SchemaName,TableName,IndexName) as (
SELECT ''?'' as [DBname],
  schema_name(schema_id) as SchemaName, OBJECT_NAME(si.object_id) as TableName, si.name as IndexName
FROM sys.indexes as si
LEFT JOIN sys.objects as so on so.object_id=si.object_id
WHERE index_id>0 -- omit the default heap
  and OBJECTPROPERTY(si.object_id,''IsMsShipped'')=0 -- omit system tables
  and not (schema_name(schema_id)=''dbo'' and OBJECT_NAME(si.object_id)=''sysdiagrams''))
Select DBname, SchemaName, TableName, IndexName from cte '

Insert into dba.dbo.tmpListAllIndexes (DBname, SchemaName, TableName, IndexName)  exec sp_MSForeachdb @SQL

--
--List all indexes
select DBname, TableName, IndexName from dba.dbo.tmpListAllIndexes
where 1=1
	and (TableName = 'AgentConfiguration'
	and IndexName='IX_ACAgentGlobal_ID')

--Find tables without an index
;with cte as (select DBname, TableName from dba.dbo.tmpListAllIndexes
where 1=1 and TableName = 'AgentConfiguration'
	)
select * from cte
except
select DBname, TableName  from dba.dbo.tmpListAllIndexes
where 1=1
	and (TableName = 'AgentConfiguration'
	and IndexName='IX_ACAgentGlobal_ID')



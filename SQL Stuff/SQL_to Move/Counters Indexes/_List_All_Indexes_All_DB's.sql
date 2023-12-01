declare @SQL nvarchar(max)

IF object_id('dba.dbo.tmpListAllIndexes') IS NOT NULL DROP TABLE dba.dbo.tmpListAllIndexes;
create table dba.dbo.tmpListAllIndexes ( DBname nVarChar(512), SchemaName nVarChar(512), TableName nVarChar(512), IndexName nVarChar(512), fill_factor int, is_hypothetical bit,is_padded bit ,is_disabled bit)

set @SQL='use [?];print ''?'';
;With CTE (DBname, SchemaName,TableName,IndexName, fill_factor, is_hypothetical,is_padded,is_disabled) as (
SELECT ''?'' as [DBname],
  schema_name(schema_id) as SchemaName, OBJECT_NAME(si.object_id) as TableName, si.name as IndexName, fill_factor, is_hypothetical,is_padded,is_disabled
FROM sys.indexes as si
LEFT JOIN sys.objects as so on so.object_id=si.object_id
WHERE index_id>0 -- omit the default heap
  and ''?'' <>''tempdb''
  and OBJECTPROPERTY(si.object_id,''IsMsShipped'')=0 -- omit system tables
  and not (schema_name(schema_id)=''dbo'' and OBJECT_NAME(si.object_id)=''sysdiagrams''))
Select DBname, SchemaName, TableName, IndexName , fill_factor, is_hypothetical,is_padded,is_disabled from cte '

Insert into dba.dbo.tmpListAllIndexes (DBname, SchemaName, TableName, IndexName, fill_factor, is_hypothetical,is_padded,is_disabled)  exec sp_MSForeachdb @SQL

--
--List all indexes
select DBname, SchemaName, TableName, IndexName, fill_factor, is_hypothetical,is_padded,is_disabled from dba.dbo.tmpListAllIndexes
--where 1=1
--	and  fill_factor<>95
--	and IndexName<>'PK_dbaLogs'
order by DBname,SCHEMANAME, TableName,IndexName

select 'ALTER INDEX ['+IndexName+'] ON ['+DBname+'].['+SchemaName+'].['+TableName+'] REBUILD PARTITION = ALL WITH ( FILLFACTOR = 95, PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = ON, SORT_IN_TEMPDB = OFF )'
from dba.dbo.tmpListAllIndexes
where 1=1
	and  fill_factor<>95
	and IndexName<>'PK_dbaLogs' and indexname <>'PK_tbl_BinaryFileUpload'
	and IndexName<>'PK_ScheduleHistory'and indexname <>  'PK_tbl_Activities'
--and dbname = 'auditlogs'
order by DBname,SCHEMANAME, TableName,IndexName

select DBname,SCHEMANAME, TableName, COUNT(*) from dba.dbo.tmpListAllIndexes
where DBname like 'CloudContactCRM%'
group by DBname,SCHEMANAME, TableName
order by TableName,DBname



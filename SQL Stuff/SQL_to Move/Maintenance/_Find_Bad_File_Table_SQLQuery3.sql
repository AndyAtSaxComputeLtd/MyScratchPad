SET NOCOUNT ON
DECLARE @AllTables table (DBname varchar(256), schemaname varchar(256), tablename varchar(256), tableobj int)
INSERT INTO @AllTables (DBname,schemaname,tablename,tableobj)
    EXEC sp_msforeachdb 'select ''?'', s.name,t.name,t.object_id from [?].sys.tables t inner join sys.schemas s on t.schema_id=s.schema_id'
SET NOCOUNT OFF


select * from @AllTables where tablename='BT_AgentSummary'


SELECT
    si.name as IndexName, si.object_id
  
FROM sys.indexes as si
LEFT JOIN sys.objects as so on so.object_id=si.object_id
WHERE index_id>0 -- omit the default heap
  and OBJECTPROPERTY(si.object_id,'IsMsShipped')=0 -- omit system tables
  and not (schema_name(schema_id)='dbo' and OBJECT_NAME(si.object_id)='sysdiagrams')
  and OBJECT_NAME(si.object_id)='BT_AgentSummary'

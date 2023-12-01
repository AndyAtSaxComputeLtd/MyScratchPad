;With CTE (SchemaName,TableName,IndexName) as (
SELECT
  schema_name(schema_id) as SchemaName, OBJECT_NAME(si.object_id) as TableName, si.name as IndexName
FROM sys.indexes as si
LEFT JOIN sys.objects as so on so.object_id=si.object_id
WHERE index_id>0 -- omit the default heap
  and OBJECTPROPERTY(si.object_id,'IsMsShipped')=0 -- omit system tables
  and not (schema_name(schema_id)='dbo' and OBJECT_NAME(si.object_id)='sysdiagrams'))

Select SchemaName,TableName,IndexName from cte 
where IndexName like '%BTDBA%'
ORDER BY SchemaName,TableName,IndexName

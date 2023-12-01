--Script to generate drops from all column store indexes
SELECT  'drop index '+QUOTENAME(OBJECT_NAME(object_id))+' on '+ QUOTENAME(name)
 FROM sys.indexes
WHERE type_desc LIKE '%COLUMNSTORE%'
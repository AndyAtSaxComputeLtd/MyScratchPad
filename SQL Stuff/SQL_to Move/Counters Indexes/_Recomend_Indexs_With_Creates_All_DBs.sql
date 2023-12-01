--10,000,000 is high
with cte as (
SELECT 
[Impact] = CAST((avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) as INT), 
[Table] = [statement],
	[CreateIndexStatement] = 'CREATE NONCLUSTERED INDEX ix_BTDBA'
	+ sys.objects.name COLLATE DATABASE_DEFAULT+ '_'
	+ REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns,'')+ISNULL(mid.inequality_columns,''), '[', ''), ']',''), ', ','_')
	+ ' ON ' + [statement] + ' ( ' + IsNull(mid.equality_columns, '') + 
CASE WHEN mid.inequality_columns IS NULL THEN '' 
ELSE
	CASE WHEN mid.equality_columns IS NULL THEN '' 
	ELSE ',' END
+ mid.inequality_columns END + ' ) ' + 
CASE WHEN mid.included_columns IS NULL THEN '' 
ELSE 'INCLUDE (' + mid.included_columns + ')' END 
+ ' with (pad_index=on, fillfactor=97,online=on);'
, mid.equality_columns, mid.inequality_columns, mid.included_columns
FROM sys.dm_db_missing_index_group_stats AS migs
INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle
INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID
WHERE  (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) > 100000

and 

(migs.group_handle IN (SELECT TOP (500) group_handle
FROM sys.dm_db_missing_index_group_stats WITH (nolock)
ORDER BY( avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC)) 
--AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable') = 1
)
select * from cte
order by 1 desc


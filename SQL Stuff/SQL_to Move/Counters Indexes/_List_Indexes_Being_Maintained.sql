;with cte as ( select distinct 'Rebuild' as Action, DatabaseName, SchemaName, ObjectName,IndexName from dba.dbo.CommandLog 

where commandtype <> 'UPDATE_STATISTICS' 
	and CommandType <> 'DBCC_CHECKDB'
	and Command like '%rebuild%'

union
select distinct 'ReOrg' as Action, DatabaseName, SchemaName, ObjectName,IndexName from dba.dbo.CommandLog 

where commandtype <> 'UPDATE_STATISTICS' 
	and CommandType <> 'DBCC_CHECKDB'
	and Command like '%ReOrg%'
	)
Select * from cte
order by Action, DatabaseName, SchemaName, ObjectName,IndexName
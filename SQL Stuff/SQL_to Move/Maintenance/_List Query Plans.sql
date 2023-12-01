--sp_recompile  @objname = 'AgentsStateChanges'

use usgcshistorical

SELECT object_name(es.objectid),UseCounts, Cacheobjtype, Objtype, TEXT, query_plan
FROM sys.dm_exec_cached_plans  ec
CROSS APPLY sys.dm_exec_sql_text(plan_handle) es
CROSS APPLY sys.dm_exec_query_plan(plan_handle) ep

where 1=1
	and text like '%UPDATE BT_AgentLoginOut WITH %' 
	and es.dbid=db_id('usgcshistorical')



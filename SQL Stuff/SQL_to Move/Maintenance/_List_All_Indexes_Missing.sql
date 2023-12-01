--List All Missing indexes
SELECT 
		id.statement,		
		id.equality_columns as [Equality Columns],
        id.inequality_columns as [Inequality Columns],
        id.included_columns as [Included Columns],
        cast(gs.avg_total_user_cost * gs.avg_user_impact * ( gs.user_seeks + gs.user_scans )as int) AS Impact,
        cast(gs.avg_total_user_cost as numeric(10,2)) as [Average Total Cost],
        cast(gs.avg_user_impact as int) as [% Reduction of Cost],
        gs.user_seeks + gs.user_scans as [Missed Opportunities]
       
FROM sys.dm_db_missing_index_group_stats AS gs
JOIN sys.dm_db_missing_index_groups AS ig ON gs.group_handle = ig.index_group_handle
JOIN sys.dm_db_missing_index_details AS id ON ig.index_handle = id.index_handle
--where id.statement like '%steria%'
order by Impact desc
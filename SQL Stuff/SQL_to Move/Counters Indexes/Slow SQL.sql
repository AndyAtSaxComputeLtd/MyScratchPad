with cte as (
SELECT  creation_time 
        ,last_execution_time
        ,total_physical_reads
        ,total_logical_reads 
        ,total_logical_writes
        , execution_count
        , total_worker_time/1000 as total_worker_time
        , total_elapsed_time/1000 as total_elapsed_time
        , total_elapsed_time/1000 / execution_count avg_elapsed_time
        ,SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
         ((CASE statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END
            - qs.statement_start_offset)/2) + 1) AS statement_text
         ,plan_handle
         
         
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st)
select * from cte 
where creation_time > '18 jun 2014 14:29:00'
	--and statement_text not like 'insert%'
	and statement_text not like 'update%'
	and avg_elapsed_time > 2000
ORDER BY execution_count DESC;





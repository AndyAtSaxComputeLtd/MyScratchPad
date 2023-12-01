--List SQL Processes
SELECT s.spid, db_name(s.dbid) as DBname, s.blocked, s.cpu, s.physical_io, s.last_batch, s.status, s.hostname, s.hostprocess, s.cmd, s.kpid, CONVERT(smallint, s.waittype) as waittype, s.waittime, s.lastwaittype, s.waitresource, s.uid, s.memusage, s.login_time, s.ecid, s.open_tran, s.sid, s.program_name, s.nt_domain, s.nt_username, s.net_address, s.net_library, s.loginame, CONVERT(varchar(64), s.context_info), s.sql_handle, [eqp].[query_plan], s.stmt_start, s.stmt_end, s.request_id, r.plan_handle, [obj] = QUOTENAME(OBJECT_SCHEMA_NAME(t.objectid, t.[dbid])) + '.' + QUOTENAME(OBJECT_NAME(t.objectid, t.[dbid])), t.[text]
FROM master..sysprocesses AS s LEFT OUTER JOIN sys.dm_exec_sessions es ON es.session_id = s.spid LEFT OUTER JOIN sys.dm_exec_requests r ON r.session_id = s.spid 
	OUTER APPLY sys.dm_exec_sql_text(s.[sql_handle]) AS t
	Outer Apply sys.dm_exec_query_plan ([r].[plan_handle]) [eqp]
where es.is_user_process = 1
order by blocked desc ,spid asc
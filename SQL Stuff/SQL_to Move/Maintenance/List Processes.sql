DECLARE @handle binary(200)
SELECT @handle = sql_handle FROM master..sysprocesses WHERE spid = 1212
SELECT [text] FROM ::fn_get_sql(@handle)

SELECT 
	s.spid, 
	db_name(s.dbid) as DBname, 
	s.blocked,
	s.cpu, 
	s.physical_io, 
	
	s.last_batch, 	
	s.status, 
	s.hostname, 
	s.hostprocess, 
	s.cmd, 
	s.kpid, 
	CONVERT(smallint, s.waittype) as waittype, 
	s.waittime, 
	s.lastwaittype, 
	s.waitresource, 
	s.uid, 
	s.memusage, 
	s.login_time, 
	s.ecid, 
	s.open_tran, 
	s.sid, 
	s.program_name, 
	s.nt_domain, 
	s.nt_username, 
	s.net_address, 
	s.net_library, 
	s.loginame, 
	CONVERT(varchar(64), s.context_info), 
	s.sql_handle, 
	s.stmt_start, 
	s.stmt_end, 
	s.request_id,	
	r.plan_handle,
	[obj] = QUOTENAME(OBJECT_SCHEMA_NAME(t.objectid, t.[dbid])) + '.' + QUOTENAME(OBJECT_NAME(t.objectid, t.[dbid])), 
	t.[text]
FROM master..sysprocesses AS s
	LEFT OUTER JOIN sys.dm_exec_sessions es ON es.session_id = s.spid
	LEFT OUTER JOIN sys.dm_exec_requests r ON r.session_id = s.spid
	OUTER APPLY sys.dm_exec_sql_text(s.[sql_handle]) AS t
Order by blocked,SPID desc

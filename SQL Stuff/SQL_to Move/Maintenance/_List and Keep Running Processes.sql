use dba

IF OBJECT_ID('dba.dbo.spids') IS NULL 
	Begin
		CREATE TABLE [dbo].[spids](
			[TimeStamp] datetime,
			[spid] [smallint] NOT NULL,
			[DBname] [nvarchar](128) NULL,
			[blocked] [smallint] NOT NULL,
			[cpu] [int] NOT NULL,
			[physical_io] [bigint] NOT NULL,
			[last_batch] [datetime] NOT NULL,
			[status] [nchar](30) NOT NULL,
			[hostname] [nchar](128) NOT NULL,
			[hostprocess] [nchar](10) NOT NULL,
			[cmd] [nchar](16) NOT NULL,
			[kpid] [smallint] NOT NULL,
			[waittype] [smallint] NULL,
			[waittime] [bigint] NOT NULL,
			[lastwaittype] [nchar](32) NOT NULL,
			[waitresource] [nchar](256) NOT NULL,
			[uid] [smallint] NULL,
			[memusage] [int] NOT NULL,
			[login_time] [datetime] NOT NULL,
			[ecid] [smallint] NOT NULL,
			[open_tran] [smallint] NOT NULL,
			[sid] [binary](86) NOT NULL,
			[program_name] [nchar](128) NOT NULL,
			[nt_domain] [nchar](128) NOT NULL,
			[nt_username] [nchar](128) NOT NULL,
			[net_address] [nchar](12) NOT NULL,
			[net_library] [nchar](12) NOT NULL,
			[loginame] [nchar](128) NOT NULL
		) ON [PRIMARY] 
		SET ANSI_PADDING ON
		ALTER TABLE [dbo].[spids] ADD [ContextInfo] [varchar](64) NULL
		SET ANSI_PADDING OFF
		ALTER TABLE [dbo].[spids] ADD [sql_handle] [binary](20) NOT NULL
		ALTER TABLE [dbo].[spids] ADD [query_plan] [xml] NULL
		ALTER TABLE [dbo].[spids] ADD [stmt_start] [int] NOT NULL
		ALTER TABLE [dbo].[spids] ADD [stmt_end] [int] NOT NULL
		ALTER TABLE [dbo].[spids] ADD [request_id] [int] NOT NULL
		SET ANSI_PADDING ON
		ALTER TABLE [dbo].[spids] ADD [plan_handle] [varbinary](64) NULL
		ALTER TABLE [dbo].[spids] ADD [obj] [nvarchar](517) NULL
		ALTER TABLE [dbo].[spids] ADD [text] [nvarchar](max) NULL
		SET ANSI_PADDING OFF
	End

-- Select running processes and inster them into a table for keeps

insert into dbo.spids ( TimeStamp, spid, DBname, blocked, cpu, physical_io, last_batch, status, hostname, hostprocess, cmd, kpid, waittype, waittime, lastwaittype, waitresource, uid, memusage, login_time, ecid, open_tran, sid, program_name, nt_domain, nt_username, net_address, net_library, loginame, ContextInfo, sql_handle, query_plan, stmt_start, stmt_end, request_id, plan_handle, obj, text )
SELECT getdate(), s.spid, db_name(s.dbid) as DBname, s.blocked,s.cpu, s.physical_io, s.last_batch, s.status, s.hostname, s.hostprocess, s.cmd, s.kpid, CONVERT(smallint, s.waittype) as waittype, s.waittime, s.lastwaittype, s.waitresource, s.uid, s.memusage, s.login_time, s.ecid, s.open_tran, s.sid, s.program_name, s.nt_domain, s.nt_username, s.net_address, s.net_library, s.loginame, CONVERT(varchar(64), s.context_info) as ContextInfo, s.sql_handle, [eqp].[query_plan],  s.stmt_start, s.stmt_end, s.request_id,r.plan_handle,[obj] = QUOTENAME(OBJECT_SCHEMA_NAME(t.objectid, t.[dbid])) + '.' + QUOTENAME(OBJECT_NAME(t.objectid, t.[dbid])), t.[text]
	FROM master..sysprocesses AS s LEFT OUTER JOIN sys.dm_exec_sessions es ON es.session_id = s.spid LEFT OUTER JOIN sys.dm_exec_requests r ON r.session_id = s.spid 
	OUTER APPLY sys.dm_exec_sql_text(s.[sql_handle]) AS t
	Outer Apply sys.dm_exec_query_plan ([r].[plan_handle]) [eqp]
	where es.is_user_process = 1 and db_name(s.dbid)= 'expmccrecording2'
	order by blocked desc ,spid asc

select * from dbo.spids order by timestamp asc, blocked desc ,spid asc

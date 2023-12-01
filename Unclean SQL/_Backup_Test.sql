IF object_id('tempdb..#failed_backups') is not NULL DROP TABLE #failed_backups

--get list of all failed backups in skyscape
;WITH failed_backups AS (
SELECT cte.*
FROM [server1].msdb.dbo.log_shipping_primary_databases ls WITH (NOLOCK) 
RIGHT JOIN (
	SELECT 'SS1-DTA-RPT-1' as Server,
		d.name,
		d.create_date,
		d.recovery_model_desc,   
		MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
		MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
		Case
			WHEN d.recovery_model_desc <> 'Simple' THEN MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) 
			ELSE NULL
			END AS [last_log_backup_date]
		FROM [server1].master.sys.databases d WITH (NOLOCK)
		LEFT JOIN [server1].msdb.dbo.backupset bs WITH (NOLOCK) 
			ON bs.database_name = d.name 
		WHERE d.name <>'tempdb'	AND d.state_desc <>'RESTORING'
		GROUP BY d.name, d.recovery_model_desc,create_date ) cte
	ON ls.primary_database = cte.name
WHERE 
	--Full Backups Every Week Diff & Backups Every Day
	( cte.last_full_backup_date < DATEADD(dd,-7,GETDATE())
		and cte.last_diff_backup_date < DATEADD(dd,-1,GETDATE()) 
		AND cte.last_diff_backup_date IS NOT null )
	--Full Backups every day
	OR ( cte.last_full_backup_date < DATEADD(dd,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	--Log Shipped Databases Every 30 mins
	OR (cte.last_log_backup_date < DATEADD(minute,-30,GETDATE()) AND ls.backup_retention_period > 0)
UNION ALL
	SELECT cte.*
	FROM [server].msdb.dbo.log_shipping_primary_databases ls WITH (NOLOCK) 
	RIGHT JOIN (
		SELECT 'SS1-DTA-RPT-2' as Server,
			d.name,
			d.create_date,
			d.recovery_model_desc,   
			MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
			MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
			Case
				WHEN d.recovery_model_desc <> 'Simple' THEN MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) 
				ELSE NULL
				END AS [last_log_backup_date]
			FROM [server].master.sys.databases d WITH (NOLOCK)
			LEFT JOIN [server].msdb.dbo.backupset bs WITH (NOLOCK) 
				ON bs.database_name = d.name 
			WHERE d.name <>'tempdb'	AND d.state_desc <>'RESTORING'
			GROUP BY d.name, d.recovery_model_desc,create_date ) cte
		ON ls.primary_database = cte.name
WHERE 
	--Full Backups Every Week Diff & Backups Every Day
	( cte.last_full_backup_date < DATEADD(dd,-7,GETDATE())
		and cte.last_diff_backup_date < DATEADD(dd,-1,GETDATE()) 
		AND cte.last_diff_backup_date IS NOT null )
	--Full Backups every day
	OR ( cte.last_full_backup_date < DATEADD(dd,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	--Log Shipped Databases Every 30 mins
	OR (cte.last_log_backup_date < DATEADD(minute,-30,GETDATE()) AND ls.backup_retention_period > 0)
UNION ALL
	SELECT cte.*
	FROM [server2].msdb.dbo.log_shipping_primary_databases ls WITH (NOLOCK) 
	RIGHT JOIN (
		SELECT 'SS2-DTA-RPT-1' as Server,
			d.name,
			d.create_date,
			d.recovery_model_desc,   
			MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
			MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
			Case
				WHEN d.recovery_model_desc <> 'Simple' THEN MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) 
				ELSE NULL
				END AS [last_log_backup_date]
			FROM [server2].master.sys.databases d WITH (NOLOCK)
			LEFT JOIN [server2].msdb.dbo.backupset bs WITH (NOLOCK) 
				ON bs.database_name = d.name 
			WHERE d.name <>'tempdb'	AND d.state_desc <>'RESTORING'
			GROUP BY d.name, d.recovery_model_desc,create_date ) cte
		ON ls.primary_database = cte.name
WHERE 
	--Full Backups Every Week Diff & Backups Every Day
	( cte.last_full_backup_date < DATEADD(dd,-7,GETDATE())
		and cte.last_diff_backup_date < DATEADD(dd,-1,GETDATE()) 
		AND cte.last_diff_backup_date IS NOT null )
	--Full Backups every day
	OR ( cte.last_full_backup_date < DATEADD(dd,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	--Log Shipped Databases Every 30 mins
	OR (cte.last_log_backup_date < DATEADD(minute,-30,GETDATE()) AND ls.backup_retention_period > 0)
UNION ALL
	SELECT cte.*
	FROM [server2].msdb.dbo.log_shipping_primary_databases ls WITH (NOLOCK) 
	RIGHT JOIN (
		SELECT 'SS2-DTA-RPT-2' as Server,
			d.name,
			d.create_date,
			d.recovery_model_desc,   
			MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
			MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
			Case
				WHEN d.recovery_model_desc <> 'Simple' THEN MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) 
				ELSE NULL
				END AS [last_log_backup_date]
			FROM [server2].master.sys.databases d WITH (NOLOCK)
			LEFT JOIN [server2].msdb.dbo.backupset bs WITH (NOLOCK) 
				ON bs.database_name = d.name 
			WHERE d.name <>'tempdb'	AND d.state_desc <>'RESTORING'
			GROUP BY d.name, d.recovery_model_desc,create_date ) cte
		ON ls.primary_database = cte.name
WHERE 
	--Full Backups Every Week Diff & Backups Every Day
	( cte.last_full_backup_date < DATEADD(dd,-7,GETDATE())
		and cte.last_diff_backup_date < DATEADD(dd,-1,GETDATE()) 
		AND cte.last_diff_backup_date IS NOT null )
	--Full Backups every day
	OR ( cte.last_full_backup_date < DATEADD(dd,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	--Log Shipped Databases Every 30 mins
	OR (cte.last_log_backup_date < DATEADD(minute,-30,GETDATE()) AND ls.backup_retention_period > 0)
UNION ALL
	SELECT cte.*
	FROM [server2].msdb.dbo.log_shipping_primary_databases ls WITH (NOLOCK) 
	RIGHT JOIN (
		SELECT 'SS1-DTA-SEC-1' as Server,
			d.name,
			d.create_date,
			d.recovery_model_desc,   
			MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
			MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
			Case
				WHEN d.recovery_model_desc <> 'Simple' THEN MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) 
				ELSE NULL
				END AS [last_log_backup_date]
			FROM [server2].master.sys.databases d WITH (NOLOCK)
			LEFT JOIN [server2].msdb.dbo.backupset bs WITH (NOLOCK) 
				ON bs.database_name = d.name
			WHERE d.name <>'tempdb'	AND d.state_desc <>'RESTORING'
			GROUP BY d.name, d.recovery_model_desc,create_date ) cte
		ON ls.primary_database = cte.name
WHERE 
	--Full Backups Every Week Diff & Backups Every Day
	( cte.last_full_backup_date < DATEADD(dd,-7,GETDATE())
		and cte.last_diff_backup_date < DATEADD(dd,-1,GETDATE()) 
		AND cte.last_diff_backup_date IS NOT null )
	--Full Backups every day
	OR ( cte.last_full_backup_date < DATEADD(dd,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	--Log Shipped Databases Every 30 mins
	OR (cte.last_log_backup_date < DATEADD(minute,-30,GETDATE()) AND ls.backup_retention_period > 0)
UNION ALL
	SELECT cte.*
	FROM [server1].msdb.dbo.log_shipping_primary_databases ls WITH (NOLOCK) 
	RIGHT JOIN (
		SELECT 'SS2-DTA-SEC-1' as Server,
			d.name,
			d.create_date,
			d.recovery_model_desc,   
			MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
			MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
			Case
				WHEN d.recovery_model_desc <> 'Simple' THEN MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) 
				ELSE NULL
				END AS [last_log_backup_date]
			FROM [server1].master.sys.databases d WITH (NOLOCK)
			LEFT JOIN [server1].msdb.dbo.backupset bs WITH (NOLOCK) 
				ON bs.database_name = d.name
			WHERE d.name <>'tempdb'	AND d.state_desc <>'RESTORING'
			GROUP BY d.name, d.recovery_model_desc,create_date ) cte
		ON ls.primary_database = cte.name
WHERE 
	--Full Backups Every Week Diff & Backups Every Day
	( cte.last_full_backup_date < DATEADD(dd,-7,GETDATE())
		and cte.last_diff_backup_date < DATEADD(dd,-1,GETDATE()) 
		AND cte.last_diff_backup_date IS NOT null )
	--Full Backups every day
	--OR ( cte.last_full_backup_date < DATEADD(dd,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	OR ( cte.last_full_backup_date < DATEADD(hh,-1,GETDATE()) and cte.last_diff_backup_date IS NULL )
	--Log Shipped Databases Every 30 mins
	OR (cte.last_log_backup_date < DATEADD(minute,-30,GETDATE()) AND ls.backup_retention_period > 0)
)
SELECT *
into #failed_backups
FROM failed_backups

IF @@RowCount > 0
	BEGIN
		declare @HTMLbody varchar(max),@body varchar(max), @TO Nvarchar(4000)
	
		SELECT TOP 1 @TO=email_address FROM msdb.[dbo].[sysoperators]
			WHERE name='DBA_Notifications'
	
		SET @HTMLbody = cast( (
	
		SELECT td = Server + '</td><td>' +
		NAME + '</td><td>' +
		create_date + '</td><td>' +
		recovery_model_desc+ '</td><td>' +
		last_full_backup_date+ '</td><td>' +
		last_diff_backup_date+ '</td><td>' +
		last_log_backup_date
		from (
			  select Server,
					name,
					ISNULL(CONVERT (varchar(30) ,create_date,113 ),'') AS create_date,
					recovery_model_desc,
					ISNULL(CONVERT (varchar(30) ,last_full_backup_date,113),'') AS last_full_backup_date,
					ISNULL(CONVERT (varchar(30) ,last_diff_backup_date,113 ),'') AS last_diff_backup_date,
					ISNULL(CONVERT (varchar(30) ,last_log_backup_date,113 ),'') AS last_log_backup_date
			  from #failed_backups
			  ) as d
		for xml path( 'tr' ), type ) as varchar(max) )

		set @HTMLbody = '<table cellpadding="2" cellspacing="2" border="1">'
				  + '<tr><th>Server Name</th><th>Database Name</th><th>Create Date</th><th>Recovery Model</th><th>Last Full Backup</th><th>Last Diff Backup</th><th>Last Log Backup</th></tr>'
				  + replace( replace( @HTMLbody, '&lt;', '<' ), '&gt;', '>' )
				  + '</table>'

		set @body = '<P>Some Databases are missing backups, a list of them is below.</P>' + @HTMLBody +
		'<P>This Notification has been sent by SQL Agent Job _Admin - Monitor SkyScape Backups ' + @@ServerName +'</P>';

		EXEC msdb.dbo.sp_send_dbmail
			@recipients=@TO,
			@body=@Body,
			@from_address='ReportingServices@.co.uk',
			@body_format=html,
			@subject = 'SkyScape Backups Missed !'
		PRINT 'Data Found Report Sent'
	END


DECLARE @tableHTML  NVARCHAR(MAX), @count_flag int ;

set @count_flag = 0;

--Count for Large Log Files

SELECT @count_flag = count (*) 
FROM sys.[databases] AS db
	LEFT OUTER JOIN sys.[master_files] AS dbf ON [db].[database_id] = [dbf].[database_id]
	LEFT OUTER JOIN (SELECT database_id,max(last_user_update) AS [Last User Update], ISNULL(ISNULL(max(last_user_update),max([last_user_seek])),max([last_user_lookup])) AS [Last User Event]
FROM sys.[dm_db_index_usage_stats] GROUP BY database_id) AS ss ON ss.[database_id] = db.[database_id]

where dbf.[physical_name] like '%.ldf'
--and (dbf.size*8)/1024 > 500

--If there are Large Logs Create HTML Table

IF @count_flag > 0
BEGIN

	SET @tableHTML =
		N'<H1>Top 20 Log file list – Produced By SQL Agent AH Test_Mail</H1>' +
		N'<table border="1">' +
		N'<tr><th>Dababase Name</th><th>Logical Name</th>' +
		N'<th>Filename</th><th>Size</th></tr>' +
     

	CAST ( ( SELECT top 20 
		td = db.name ,'', 
		td = dbf.[name] ,'', 
		td =(dbf.size*8)/1024 ,'', 
		td = dbf.[physical_name] ,''

	FROM sys.[databases] AS db
		LEFT OUTER JOIN sys.[master_files] AS dbf ON [db].[database_id] = [dbf].[database_id]
		LEFT OUTER JOIN (SELECT database_id,max(last_user_update) AS [Last User Update], ISNULL(ISNULL(max(last_user_update),max([last_user_seek])),max([last_user_lookup])) AS [Last User Event]
	FROM sys.[dm_db_index_usage_stats] GROUP BY database_id) AS ss ON ss.[database_id] = db.[database_id]

	WHERE dbf.[physical_name] like '%.ldf' and (dbf.size*8)/1024 > 500
	ORDER BY dbf.[size]desc

              
	FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) ) + N'</table>' ;
	
	DECLARE @EmailAddress varchar(100)
	select top 1 @EmailAddress=email_address from msdb.dbo.sysoperators where name='btdba'
	
	EXEC msdb.dbo.sp_send_dbmail @recipients=@EmailAddress,
		@subject = 'DB Log Health',
		@body = @tableHTML,
		@body_format = 'HTML' ;
END

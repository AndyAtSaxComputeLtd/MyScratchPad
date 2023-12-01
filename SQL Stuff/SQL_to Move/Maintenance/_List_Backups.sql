;with cte (Server, name, create_date, recovery_model_desc, last_full_backup_date, last_diff_backup_date, last_log_backup_date) as (
SELECT 'LDSQAH\HST' as Server,
    d.name,
    d.create_date,
    d.recovery_model_desc,   
    MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
    MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
    MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) AS [last_log_backup_date]
FROM [ldsqah\hst].master.sys.databases d
LEFT JOIN [ldsqah\hst].msdb.dbo.backupset bs ON bs.database_name = d.name
Where d.name <>'tempdb'
GROUP BY d.name, d.recovery_model_desc,create_date
union
SELECT 'LDSQAC\CRM' as Server,
    d.name,
    d.create_date,
    d.recovery_model_desc,
    MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
    MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
    MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) AS [last_log_backup_date]
FROM [ldsqac\crm].master.sys.databases d
LEFT JOIN [ldsqac\crm].msdb.dbo.backupset bs ON bs.database_name = d.name
Where d.name <>'tempdb'
GROUP BY d.name, d.recovery_model_desc,create_date
union
SELECT 'LDSQAR\REC' as Server,
    d.name,
    d.create_date,
    d.recovery_model_desc,
    MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
    MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
    MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) AS [last_log_backup_date]
FROM [ldsqar\rec].master.sys.databases d
LEFT JOIN [ldsqar\rec].msdb.dbo.backupset bs ON bs.database_name = d.name
Where d.name <>'tempdb'
GROUP BY d.name, d.recovery_model_desc,create_date
union
SELECT 'LDSQBC\CCU' as Server,
    d.name,
    d.create_date,
    d.recovery_model_desc,
    MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
    MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
    MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) AS [last_log_backup_date]
FROM [LDSQBC\CCU].master.sys.databases d
LEFT JOIN [LDSQBC\CCU].msdb.dbo.backupset bs ON bs.database_name = d.name
Where d.name <>'tempdb'
GROUP BY d.name, d.recovery_model_desc,create_date
union
SELECT 'LDSQBA\CAN' as Server,
    d.name,
    d.create_date,
    d.recovery_model_desc,
    MAX(CASE bs.type WHEN 'D' THEN backup_finish_date ELSE NULL END) AS [last_full_backup_date],
    MAX(CASE bs.type WHEN 'I' THEN backup_finish_date ELSE NULL END) AS [last_diff_backup_date],
    MAX(CASE bs.type WHEN 'L' THEN backup_finish_date ELSE NULL END) AS [last_log_backup_date]
FROM [LDSQBA\CAN].master.sys.databases d
LEFT JOIN [LDSQBA\CAN].msdb.dbo.backupset bs ON bs.database_name = d.name
Where d.name <>'tempdb'
GROUP BY d.name, d.recovery_model_desc,create_date
)
 
select * from cte
Where name <>'tempdb' and
 
(          
            ([recovery_model_desc]='FULL' and
                        convert(datetime,create_date) < dateadd(dd,-7,getutcdate()) and
                        (           [last_log_backup_date] is NULL   or
                                    [last_full_backup_date] is NULL or
                                    [last_log_backup_date] < dateadd(dd,-1,getdate()) or
                                    [last_full_backup_date] < dateadd(dd,-1,getdate())
                        )
            )
            or
            ([recovery_model_desc]='SIMPLE' and
                        convert(datetime,create_date) < dateadd(dd,-7,getutcdate()) and
                        (           [last_full_backup_date] is NULL or
                                    [last_full_backup_date] < dateadd(dd,-1,getdate())
                        )
            )
)
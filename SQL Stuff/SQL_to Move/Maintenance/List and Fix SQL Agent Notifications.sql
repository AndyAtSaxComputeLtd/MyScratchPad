select sj.name, notify_level_email, so.name 
	from msdb.dbo.sysjobs sj 
	left join msdb.dbo.sysoperators so on sj.notify_email_operator_id = so.id
	where 
		sj.name not in  ('_SQL Waits Data Collecttion','_List and Keep Running Processes','_AH_Test_Mail','Expedia Sales Tracking Transfer')
		and so.name <> 'DBMail'
		or notify_level_email <> 2
		and notify_level_email <>3

--Fix

declare @opid int

select @opid=ID from msdb.dbo.sysoperators where name = 'DBMail'

update msdb.dbo.sysjobs
	set	notify_level_email=2,
		notify_email_operator_id=@opid
	where name not in  ('_SQL Waits Data Collecttion','_List and Keep Running Processes','_AH_Test_Mail','Expedia Sales Tracking Transfer')
		and  notify_email_operator_id <> @opid
		or notify_level_email <> 2
		and notify_level_email <>3
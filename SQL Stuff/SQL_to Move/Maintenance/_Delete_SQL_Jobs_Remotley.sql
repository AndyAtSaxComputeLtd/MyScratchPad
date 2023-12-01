;With CTE as (
select 'ldsqac\crm' as server, name from [ldsqac\crm].msdb.dbo.sysjobs 
union all
select 'ldsqah\hst' as server, name from [ldsqah\hst].msdb.dbo.sysjobs 
union all
select 'ldsqar\rec' as server, name from [ldsqar\rec].msdb.dbo.sysjobs 
union all
select 'ldsqba\can' as server, name from [ldsqba\can].msdb.dbo.sysjobs 
union all
select 'ldsqbc\ccu' as server, name from [ldsqbc\ccu].msdb.dbo.sysjobs 
union all
select 'ldsqfd\pds' as server, name from [ldsqfd\pds].msdb.dbo.sysjobs 
union all
select 'ldsqfw\wfm' as server, name from [ldsqfw\wfm].msdb.dbo.sysjobs)

Select server, name, 
	'exec [' + server + '].msdb.[dbo].sp_delete_job @job_name = ''' + name + CHAR(39) as delete_SQL
from CTE
where name like ('_Check_Long_Running_Maintenance_Plans')
order by name

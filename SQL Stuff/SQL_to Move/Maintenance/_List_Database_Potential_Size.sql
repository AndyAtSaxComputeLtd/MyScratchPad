--exec msdb.dbo.sp_start_job  @job_name='_Check_Database_Retentions'

;With CTE as (select dbname,CurrentDays,RecordCount,Size_K/1024 as Size_MB, 
		RecordCount/(CurrentDays)*RetentionDays as PotenialRecords,
		cast((Size_K/CurrentDays*RetentionDays/1024)*1.2 as int) as PotentialSizeMB,
		(Size_K/CurrentDays*RetentionDays/1024) - (Size_K/1024) as GrowthRequiredMB 
from dba.dbo.IPmonMonitorRetentions (nolock)
where RetentionDays > CurrentDays and RecordCount<>0 and CurrentDays<>0)
select * from CTE 
where GrowthRequiredMB >50
order by dbname

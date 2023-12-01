--Extract Slow SQL from trace table and convert to SQL
select * 
into dba.dbo.SlowSQL2
from dba.dbo.SlowSQL

select  '--'+CONVERT(varchar(40), isnull(endtime,GETUTCDATE()), 20) +Char(13) + 
		'--'+ cast (Duration as varchar(20))+CHAR(13) +
		'use '+quotename(DatabaseName)+';'+char(13)+
		cast(TextData as varchar(max)) as sql
into dba.dbo.SlowSQL3
from dba.dbo.SlowSQL2
where TextData is not null

select * from dba.dbo.SlowSQL3

declare @cmd varchar(4000)
set @cmd = 'bcp "select sql from dba.dbo.SlowSQL3" queryout "\\ldsl01\cculogs\SlowSQL\SlowSQL.sql" -T -c -S LDSQAC'
print @cmd
EXEC master..XP_CMDSHELL @cmd
drop table dba.dbo.SlowSQL2
drop table dba.dbo.SlowSQL3
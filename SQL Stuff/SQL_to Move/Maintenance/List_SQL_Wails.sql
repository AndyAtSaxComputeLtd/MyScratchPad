select * from dba.dbo.SQL_Waits
where DateRun <= GETDATE() 
and DateRun >= DATEADD(HOUR,-1, getdate())
order by DateRun desc

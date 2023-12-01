use msdb;
declare @thedate datetime;

set @thedate = dateadd(dd,-30,getdate())
EXEC sp_delete_backuphistory @oldest_date = @thedate
EXEC msdb.dbo.sp_purge_jobhistory  @oldest_date=@thedate
EXEC msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @thedate
EXEC msdb..sp_maintplan_delete_log null,null,@thedate
go
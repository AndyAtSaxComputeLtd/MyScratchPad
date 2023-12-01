--Change SQL Agent Jobs to SA
select * from msdb.dbo.sysjobs where owner_sid <> 0x1
update msdb.dbo.sysjobs
set owner_sid =0x1
where owner_sid <> 0x1
--
-- Set Databases to Full Logging
--
declare @dbname nvarchar(max), @sqlrun nvarchar(max),@count int, @MaxCount int;
set nocount on;

--Check and create objects
IF object_id('tempDB..#DBList') IS NOT NULL DROP TABLE #dblist
create table #dblist (ID INT Identity(1,1),dbname nvarchar(256))

--List all user databases
insert #dblist (dbname)
select name  from master.sys.databases where name not in ('master','model','tempdb','distribution','msdb')
	and is_published = 0
	and is_subscribed = 0
	and is_merge_published = 0
	and is_distributor = 0
	and recovery_model_desc = 'Bulk_Logged'
	and database_id not in (select database_id from sys.database_mirroring where mirroring_state_desc is not null)
order by name

Select * from #DBlist

set @count=1;
select @MaxCount=max(ID) from #dblist

while @count <= @MaxCount 
begin
	select @dbname= dbname from #dblist where @count = ID
	set @sqlrun = 'alter database [' + @dbname + '] SET RECOVERY Full WITH NO_WAIT'
	print @sqlrun
	exec sp_ExecuteSQL @sqlrun
	delete from #dblist where @Count = ID	
	Set @Count=@Count+1
end
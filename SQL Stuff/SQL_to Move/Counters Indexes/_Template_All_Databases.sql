--Checks the retention Period for tables with dates

Declare @SQL nvarchar(4000), @DBnameIN varchar(256) 
Set nocount on
Set Deadlock_priority high

truncate table dba.dbo.tmpRetentionCheck

--Declare and open cursor pointing to all historical DB's
DECLARE db_cursor CURSOR FAST_FORWARD FOR

select dbname from [ldsqbc\ccu].cosmocall61.dbo.siDataBases where DBType_ID=1 order by dbname

OPEN db_cursor

FETCH NEXT FROM db_cursor INTO @dbnameIN

WHILE @@FETCH_STATUS = 0
	BEGIN
		

		FETCH NEXT FROM db_cursor INTO @dbnameIN
	End
CLOSE db_cursor
DEALLOCATE db_cursor

delete from dba.dbo.tmpRetentionCheck where RetentionDays is null
delete from dba.dbo.tmpRetentionCheck where RetentionDays = '-1' and [RowCount] = '0'

select tr.dbname,tablename, tr.RetentionDays, ir.RetentionDays as TargetRetentionDays, [RowCount] from dba.dbo.tmpRetentionCheck tr
	inner join dba.dbo.IPmonMonitorRetentions IR on ir.dbname = tr.dbname
	where tr.RetentionDays > ir.RetentionDays + 1
	
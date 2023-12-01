use dba
set nocount on
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmpSPlist]') AND type in (N'U')) DROP TABLE [dbo].[tmpSPlist]
CREATE TABLE [dbo].[tmpSPlist](	[DBName] [varchar](256) NULL,	SPname [varchar](256) NULL) ON [PRIMARY]

Declare @SQL nvarchar(4000), @Name nvarchar(4000)

DECLARE a_cursor CURSOR FAST_FORWARD FOR

select dbname
	from [ldsqbc\ccu].cosmocall61.dbo.siDataBases sid
	inner join sys.databases d on d.name = sid.dbname
	where DBType_ID=1 	

OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @Name
WHILE @@FETCH_STATUS = 0
	BEGIN
		set @SQL='use ['+@Name+']; 
			insert dba.dbo.tmpSPlist (DBName, SPname)
			Select '''+@Name+''' as DBName ,name FROM SYS.OBJECTS WHERE type in (''P'',''TF'',''FN'',''V'') '
		--print @SQL
		exec sp_executesql @sql
		FETCH NEXT FROM a_cursor INTO @Name
	END 
CLOSE a_cursor
DEALLOCATE a_cursor

SELECT dbname FROM [dba].[dbo].[IPmonMonitorRetentions] 
except
select DBName from dba.dbo.tmpSPlist 
where SPname like '%vw_btdba_GetDependents%'


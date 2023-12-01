
--lists all databases who have excessive images per call
-- Second half fixes - note Manual Process
declare @SQL nvarchar(max)

IF object_id('dba.dbo.IPmonImageInfo') IS NOT NULL DROP TABLE dba.dbo.IPmonImageInfo;
CREATE TABLE dba.dbo.IPmonImageInfo(DBname nvarchar(512), CallID varbinary (16), CountCallID int)

set @SQL='
if ''?'' <> ''master'' and ''?'' <> ''tempdb'' and ''?'' <> ''msdb'' and ''?'' <> ''model''
	and ''?'' <> ''dba'' and ''?'' <> ''Capacity'' and ''?'' <> ''CapacityMonitor_D''
	begin
		;with cte (CallID, CountCallID) as (
			select callid, count(CallID) as CountCallid from [?].dbo.ImageInfo 
			where callID<>0x0000000000000000
			group by CallID
			having count(callid) >100)

		Select ''?'' as DBname, CallID, CountCallID from cte
	end'

Insert into dba.dbo.IPmonImageInfo (DBname, CallID, CountCallID) exec sp_MSForeachdb @SQL

select * from dba.dbo.IPmonImageInfo


--Fix Databases
use sthomesRecording                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                	

--create TempTable
if OBJECT_ID('tempdb..#tmplist') is not null begin drop table #tmplist end

--Find Calls and Length of Images
SELECT datalength(Image) as [length], RowID, PRCallInfoID as CallInfoRowID
	INTO #tmplist
	FROM imageinfo where callid in ( 0x1B519DE59FA90237 )

--Delete Actual Recordings from list to be removed DO NOT combine this with the Select
Delete from #tmplist where [length] is not null

--Remove Images
delete from imageinfo where rowid in ( select RowID from #tmplist )


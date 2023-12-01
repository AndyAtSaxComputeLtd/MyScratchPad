--lists all databases who have callinfo rows without images
declare @SQL nvarchar(max)

IF object_id('dba.dbo.IPmonCallInfo') IS NOT NULL Begin DROP TABLE dba.dbo.IPmonCallInfo end;
CREATE TABLE dba.dbo.IPmonCallInfo(DBname nvarchar(512), RowID uniqueidentifier, CallID varbinary (16))

set @SQL='
if ''?'' <> ''master'' and ''?'' <> ''tempdb'' and ''?'' <> ''msdb'' and ''?'' <> ''model''
	and ''?'' <> ''dba'' and ''?'' <> ''Capacity'' and ''?'' <> ''CapacityMonitor_D''
	begin
		SELECT ''?'' as DBname, ci.rowid, ci.CallID from [?].dbo.CallInfo ci 
		left join [?].dbo.ImageInfo ii on ii.PRCallInfoID = ci.RowID
		where ii.RowID is null
	end'

Insert into dba.dbo.IPmonCallInfo (DBname, RowID, CallID) exec sp_MSForeachdb @SQL

----Manual Fix Databases
--Select * from dba.dbo.IPmonCallInfo 
--	where DBname like ('steriaRecording1%')

--use steriaRecording1
--delete from CallInfo where RowID in (Select RowID from dba.dbo.IPmonCallInfo where
--										DBname = 'steriaRecording1')
										
--use ASRomaRecording
--select * from CallInfo where CallID = 0x1BF27F9D0E1602E4
--select * from ImageInfo where CallID = 0x1BF27F9D0E1602E4
--select * from Voicemail where CallID = 0x1BF27F9D0E1602E4

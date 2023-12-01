--lists all triggers all databases
declare @SQL nvarchar(max)

IF object_id('dba.dbo.IPmonCheckTriggers') IS NOT NULL DROP TABLE dba.dbo.IPmonCheckTriggers;
create table dba.dbo.IPmonCheckTriggers (DBName VarChar(512), [TriggerName] VarChar(512), [TableName] VarChar(512), [Enabled] VarChar(20))

set @SQL='use [?];
;with cte as (
	select ''?'' as [DBname], str.name as [TriggerName], object_name(parent_obj) as [TableName], 
		case is_disabled 
			when 0 then ''Enabled''
			when 1 then ''Disabled''
		End as [Enabled]		
	from sys.triggers str
	inner join sysobjects so on so.id=str.object_id
	)
Select [DBname], [TriggerName], [TableName],[Enabled] from cte;'

Print @SQL

Insert into dba.dbo.IPmonCheckTriggers ( DBName, TriggerName, TableName, [Enabled])  exec sp_MSForeachdb @SQL

--select 'drop trigger ['+triggername+'] on ['+DBName+'].dbo.['+TableName+']' from dba.dbo.IPmonCheckTriggers
--where TriggerName like '%BT_UpdateAgentStates%' and 
--DBName not in (
--'AcadiaHistorical',
--'APWHistorical',
--'ASOCHistorical',
--'BTConfHistorical',
--'CATLOGHistorical',
--'CNHCANHistorical',
--'CNHCAPHistorical',
--'CNHCORHistorical',
--'EmeaRoutingHistorical',
--'ONSHistorical')
--order by 1


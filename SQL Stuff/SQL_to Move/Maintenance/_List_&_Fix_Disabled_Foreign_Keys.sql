--List and fix all disabled 
use master
declare @SQLCMD nvarchar(max)
IF object_id('tempDB..#DBList') IS NOT NULL DROP TABLE #DBList;
CREATE TABLE #DBList ( SQLRUN nvarchar(max) );

SET @SQLCMD = '
use [?];
INSERT INTO #DBList(SQLRUN)
SELECT ''alter table [?].['' + s.name + ''].['' + o.name + ''] CHECK CONSTRAINT ['' + i.name + '']''
from sys.foreign_keys i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_disabled = 1  AND i.is_not_for_replication = 0
and  i.name  not in 
(
''FK_spServerStorage_spDTRServers'',
''FK_spServerStorage_spMCS'',
''FK_spServerStorage_spRTPRelayServers'',
''FK_spServerStorage_spChatServers'')'

Print  @SQLCMD
EXEC sp_MSForEachDB @SQLCMD
Select * from dba.dbo.DisabledForeignKeys
Select * from #DBList
union
select 'EXEC MSDB.dbo.sp_start_job @Job_Name = ''_BTDBA_Check_Foreign_Keys'''

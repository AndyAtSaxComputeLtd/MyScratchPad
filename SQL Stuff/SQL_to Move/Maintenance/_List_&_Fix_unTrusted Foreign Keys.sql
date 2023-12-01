--Script to list code to fix untrusted Foreign Keys
use master
declare @SQLCMD nvarchar(max)
IF object_id('tempDB..#DBList2') IS NOT NULL DROP TABLE #DBList2;
CREATE TABLE #DBList2 ( SQLRUN nvarchar(max) );

SET @SQLCMD = '
use [?];
INSERT INTO #DBList2(SQLRUN)
SELECT ''alter table [?].['' + s.name + ''].['' + o.name + ''] WITH CHECK CHECK CONSTRAINT ['' + i.name + '']'' AS keyname
from sys.foreign_keys i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_disabled = 0 and i.is_not_trusted = 1 AND i.is_not_for_replication = 0'

EXEC sp_MSForEachDB @SQLCMD

Select SQLRUN from #DBList2
union
select 'DBA_Check_Foreign_Keys'


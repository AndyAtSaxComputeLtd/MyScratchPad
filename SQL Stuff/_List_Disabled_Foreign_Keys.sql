--List all disabled 
declare @SQLCMD nvarchar(max)
IF object_id('dba.dbo.DisabledForeignKeys') IS NOT NULL DROP TABLE dba.dbo.DisabledForeignKeys;
CREATE TABLE dba.dbo.DisabledForeignKeys ( ID INT Identity(1,1), DBNAME nvarchar(max),INDEXNAME nvarchar(max) );

SET @SQLCMD = '
use ?;
INSERT INTO dba.dbo.DisabledForeignKeys (DBNAME, INDEXNAME)
SELECT "?",''['' + s.name + ''].['' + o.name + ''].['' + i.name + '']'' AS keyname
from sys.foreign_keys i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_disabled = 1  AND i.is_not_for_replication = 0'

EXEC sp_MSForEachDB @SQLCMD
Select * from dba.dbo.DisabledForeignKeys

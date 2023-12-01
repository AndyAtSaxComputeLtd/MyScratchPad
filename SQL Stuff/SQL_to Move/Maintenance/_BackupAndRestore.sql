--BACKUP DATABASE expmccCRM TO DISK = 'v:\expmcccrm.bak' WITH INIT,copy_only;


RESTORE HEADERONLY 
FROM DISK = 'v:\expmcccrm.bak' 
WITH NOUNLOAD;

RESTORE FILELISTONLY 
FROM DISK = 'v:\expmcccrm.bak' 
WITH NOUNLOAD;

RESTORE DATABASE [expmccCRM_dba] 
--Change
FROM  DISK = 'v:\expmcccrm.bak'
WITH  replace,

MOVE N'expmccCRM' TO N'v:\ccudb\expmccCRM_dba.mdf',
MOVE N'expmccCRM_log' TO N'w:\cculog\expmccCRM_dba_log.ldf'

GO


--v:\ccudb\expmccCRM_dba.mdf
--w:\ccudb\expmccCRM_dba_log.ldf
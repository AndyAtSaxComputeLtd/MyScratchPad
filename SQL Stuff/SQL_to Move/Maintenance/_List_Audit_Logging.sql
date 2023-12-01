use dba
SELECT * FROM sys.fn_get_audit_file ('\\ldsqah\F$\MSSQL10_50.HST\MSSQL\DATA\DB_Audit_*.sqlaudit',default,default)
where  1=1 and 
action_id not in ('CR','AL','VDST')
and event_time > '2014-08-18 06:20:00'

SELECT DATEDIFF(hh,min(event_time),getUTCdate()) FROM sys.fn_get_audit_file ('\\ldsqah\F$\MSSQL10_50.HST\MSSQL\DATA\Server_Audit_*.sqlaudit',default,default)

SELECT 50000/cast(DATEDIFF(hh,min(event_time),getUTCdate())  as Int) * (24*31)
FROM sys.fn_get_audit_file ('\\ldsqah\F$\MSSQL10_50.HST\MSSQL\DATA\Server_Audit_*.sqlaudit',default,default)

SELECT * FROM sys.fn_get_audit_file ('\\ldsqah\F$\MSSQL10_50.HST\MSSQL\DATA\Login_Audit_*.sqlaudit',default,default)

SELECT 50000/cast(DATEDIFF(hh,min(event_time),getUTCdate())  as Int) * (24*31)
FROM sys.fn_get_audit_file ('\\ldsqah\F$\MSSQL10_50.HST\MSSQL\DATA\DBCC_Audit_*.sqlaudit',default,default)

SELECT 50000/cast(DATEDIFF(hh,min(event_time),getUTCdate())  as Int) * (24*31)
FROM sys.fn_get_audit_file ('\\ldsqah\F$\MSSQL10_50.HST\MSSQL\DATA\DBCC_Audit_*.sqlaudit',default,default)

where  1=1 and 
action_id not in ('CR','AL','VDST')
and event_time > '2014-08-18 06:20:00'


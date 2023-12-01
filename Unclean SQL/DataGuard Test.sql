--On Primrary
ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';

SELECT sequence#, first_time, next_time
FROM   v$archived_log
ORDER BY sequence#;

ALTER SYSTEM SWITCH LOGFILE;


--one Standby
ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';
SELECT sequence#, first_time, next_time, applied
FROM   v$archived_log
ORDER BY sequence#;



select * from dba_data_files;
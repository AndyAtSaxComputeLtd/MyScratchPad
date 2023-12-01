SELECT log_mode FROM v$database;
--
SHUTDOWN IMMEDIATE;
--
STARTUP MOUNT;
--
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

ALTER DATABASE FORCE LOGGING;

show parameter db_name;
show parameter db_unique_name;

ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(orcl,orcl_sdby)';

ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=orcl_sdby NOAFFIRM ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=orcl_sdby';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE;

ALTER SYSTEM SET LOG_ARCHIVE_FORMAT='%t_%s_%r.arc' SCOPE=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_MAX_PROCESSES=30;
ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE SCOPE=spfile;

ALTER SYSTEM SET FAL_SERVER=oracle2;
ALTER SYSTEM SET DB_FILE_NAME_CONVERT='orcl_sdby','orcl' SCOPE=SPFILE;
ALTER SYSTEM SET LOG_FILE_NAME_CONVERT='orcl_sdby','orcl'  SCOPE=SPFILE;
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO;

/*
Service Setup

Entries for the primary and standby databases are needed in the "$ORACLE_HOME/network/admin/tnsnames.ora" files on both servers. You can create these using the Network Configuration Utility (netca) or manually. The following entries were used during this setup.

DB11G =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ol5-112-dga1)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = DB11G.WORLD)
    )
  )

DB11G_STBY =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = ol5-112-dga2)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = DB11G.WORLD)
    )
  )
  */
  
/*
  $ rman target=/

RMAN> BACKUP DATABASE PLUS ARCHIVELOG;
*/

ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/tmp/orcl_sdby.ctl';
CREATE PFILE='/tmp/initorcl_sdby.ora' FROM SPFILE;

/*
Amend the PFILE making the entries relevant for the standby database. I'm making a replica of the original server, so in my case I only had to amend the following parameters.

*.db_unique_name='DB11G_STBY'
*.fal_server='DB11G'
*.log_archive_dest_2='SERVICE=db11g ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=DB11G'

*/

/*

mkdir -p /u01/app/oracle/oradata/orcl
mkdir -p /u01/app/oracle/flash_recovery_area/orcl
mkdir -p /u01/app/oracle/admin/orcl/adump

*/

/*

$ # Standby controlfile to all locations.
scp oracle1:/tmp/orcle_sdby.ctl /u01/app/oracle/oradata/orcl/control01.ctl
cp /u01/app/oracle/oradata/orcl/control01.ctl /u01/app/oracle/flash_recovery_area/orcl/control02.ctl
/u01/app/oracle/flash_recovery_area/orcl

# Archivelogs and backups
scp -r oracle1:/u01/app/oracle/fast_recovery_area/orcl/archivelog /u01/app/oracle/fast_recovery_area/orcl
scp -r oracle1:/u01/app/oracle/fast_recovery_area/orcl/backupset /u01/app/oracle/fast_recovery_area/orcl

# Parameter file.
scp oracle1:/tmp/initorcl_sdby.ora /tmp/initorcl_sdby.ora.ora

# Remote login password file.
scp oracle1:$ORACLE_HOME/dbs/orapworcl $ORACLE_HOME/dbs

*/
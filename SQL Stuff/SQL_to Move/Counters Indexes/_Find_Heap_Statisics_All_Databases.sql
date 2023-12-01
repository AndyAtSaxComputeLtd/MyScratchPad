--Find Heaped Statisics All Dbs
use dba
Declare @SQL nvarchar(4000), @dbname varchar(256) 
Set nocount on

IF OBJECT_ID('tmpListAllHeaps') is not null 
	Begin
		DROP TABLE dba.dbo.tmpListAllHeaps;
	End
	
create table dba.dbo.tmpListAllHeaps ( DBname nVarChar(512), TableName nVarChar(512),leaf_insert_count bigint, leaf_update_count bigint,leaf_delete_count bigint ,forwarded_fetch_count bigint)

--Declare and open cursor pointing to all historical DB's
DECLARE DB_Cursor CURSOR FAST_FORWARD FOR

select name from sys.databases
where name not in('master', 'tempdb', 'msdb','model','distribution','dba', 'SystemDataCollection')

OPEN DB_Cursor

FETCH NEXT FROM DB_Cursor INTO @dbname

WHILE @@FETCH_STATUS = 0
	BEGIN
	
		set @sql='use ['+@dbname+'];
		select db_name(io.database_id),object_name(io.object_id),leaf_insert_count,leaf_update_count,leaf_delete_count,forwarded_fetch_count
		from sys.dm_db_index_operational_stats ( DB_ID ('''+@dbname+'''), null,null,null) io
			inner join sys.indexes si on si.object_id = io.object_id and io.index_id=si.index_id
		where 1=1 
			and object_name(io.object_id) not in (''sysallocunits'',''sysbinobjs'',''syscerts'',''sysclsobjs'',''syscolpars'',''sysfiles1'',''sysguidrefs'',''sysidxstats'',''sysiscols'',''sysmultiobjrefs'',''sysnsobjs'',''sysobjkeycrypts'',''sysobjvalues'',''sysowners'',''syspriorities'',''sysprufiles'',''sysqnames'',''sysremsvcbinds'',''sysrowsets'',''sysrscols'',''sysrts'',''sysscalartypes'',''sysschobjs'',''syssingleobjrefs'',''syssqlguides'',''systypedsubobjs'',''sysxmlcomponent'',''sysxmlplacement'',''sysxprops'')
 			and si.type_desc=''HEAP''
			and (forwarded_fetch_count<>0 or leaf_delete_count<>0);'	
		insert into dba.dbo.tmpListAllHeaps ( DBname, TableName, leaf_insert_count, leaf_update_count, leaf_delete_count, forwarded_fetch_count) exec sp_sqlexec @sql
	FETCH NEXT FROM DB_Cursor INTO @dbname

	End
CLOSE DB_Cursor
DEALLOCATE DB_Cursor


select * from dba.dbo.tmpListAllHeaps
order by forwarded_fetch_count desc,DBname, TableName
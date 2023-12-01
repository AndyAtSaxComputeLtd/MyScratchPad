use expmcccrm
select db_name(io.database_id),object_name(io.object_id),leaf_insert_count,leaf_update_count,leaf_delete_count,forwarded_fetch_count,*
from sys.dm_db_index_operational_stats ( DB_ID ('expmcccrm'), null,null,null) io
	inner join sys.indexes si on si.object_id = io.object_id and io.index_id=si.index_id
where 1=1 
	and object_name(io.object_id) not in ('sysallocunits','sysbinobjs','syscerts','sysclsobjs','syscolpars','sysfiles1','sysguidrefs','sysidxstats','sysiscols','sysmultiobjrefs','sysnsobjs','sysobjkeycrypts','sysobjvalues','sysowners','syspriorities','sysprufiles','sysqnames','sysremsvcbinds','sysrowsets','sysrscols','sysrts','sysscalartypes','sysschobjs','syssingleobjrefs','syssqlguides','systypedsubobjs','sysxmlcomponent','sysxmlplacement','sysxprops')
 	and si.type_desc='HEAP'
	and (forwarded_fetch_count<>0 or leaf_delete_count<>0)



select t.name, c.name, *
from sys.tables t (nolock)
	inner join sys.columns c on t.object_id=c.object_id
where 1=1
	and c.system_type_id=61

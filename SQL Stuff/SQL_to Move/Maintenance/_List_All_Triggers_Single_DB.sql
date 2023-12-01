;With cte as (
	select str.name, object_name(parent_obj) as object, 
		case is_disabled 
			when 0 then 'Enabled' 
			when 1 then 'Disabled'
		End as [Enabled ?]		
	from sys.triggers str
	inner join sysobjects so on so.id=str.object_id
	)
Select * from cte;


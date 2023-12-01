-- List Partitions

select --object_schema_name(i.object_id) as [schema],
    distinct object_name(i.object_id) as [object]
	--,
 --   i.name as [index],
 --   s.name as [partition_scheme]
    from sys.indexes i
    join sys.partition_schemes s on i.data_space_id = s.data_space_id
order by 1
--,2,3,4

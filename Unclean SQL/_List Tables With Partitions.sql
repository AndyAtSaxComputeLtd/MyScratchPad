-- List Tables With Partitions
select distinct object_schema_name(i.object_id) as [schema],
     object_name(i.object_id) as [object]
    from sys.indexes i
    join sys.partition_schemes s on i.data_space_id = s.data_space_id
order by 1,2

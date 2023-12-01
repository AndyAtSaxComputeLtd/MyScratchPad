--List Compression settings for current DB
  select o.object_id, 
      S.name as [schema], 
      o.name as [Object], 
      I.index_id as Ix_id, 
      I.name as IxName, 
      I.type_desc as IxType, 
      P.partition_number as P_No, 
      P.data_compression_desc as Compression
    from sys.schemas as S
      join sys.objects as O
        on S.schema_id = O.schema_id 
      join sys.indexes as I
        on o.object_id = I.object_id 
      join sys.partitions as P
        on I.object_id = P.object_id
        and I.index_id= p.index_id
     where O.TYPE = 'U'
     order by [schema], [object], i.index_id
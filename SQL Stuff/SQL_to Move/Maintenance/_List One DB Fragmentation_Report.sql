use [expmccrecording2]

SELECT i.name AS IndexName,t.name as TableName,
Index_type_desc,
 round(avg_fragmentation_in_percent,1) AS PercentFragment,
 fragment_count AS TotalFrags,
  round(avg_fragment_size_in_pages,1) AS PagesPerFrag,
  page_count AS NumPages Into #Percentages

FROM sys.dm_db_index_physical_stats(DB_ID('expmccrecording2'), NULL, NULL, NULL , 'Limited') s
	inner join  sys.tables t on s.object_id=t.object_id
	inner join  sys.indexes i on s.index_id = i.index_id and s.object_id=i.object_id

--where [avg_fragmentation_in_percent] > 10 and index_type_desc <> ----'HEAP'
--order by s.index_type_desc, PercentFragment

Select * from #percentages
order by 2,1

SELECT
Table_Name = object_name(object_id),
Total_Rows = SUM(st.row_count)
FROM sys.dm_db_partition_stats st
where object_name(object_id) in (select TableName from #percentages)
GROUP BY object_name(object_id)
HAVING SUM(st.row_count) > 30000
ORDER BY 2,object_name(object_id) desc

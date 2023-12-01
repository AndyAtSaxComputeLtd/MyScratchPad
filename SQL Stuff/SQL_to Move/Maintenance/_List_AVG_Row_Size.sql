-- List Table Row Size and Row counts
declare @mydb int
set @mydb = db_id()
IF object_id('tempdb..#myspace') IS NOT NULL DROP TABLE #myspace;
select
	s.name,
	object_name(DDIPS.[object_id]) as tablename
, DDIPS.index_type_desc
, I.name as Index_name
, DDIPS.page_count
, DDIPS.record_count as row_count
, DDIPS.avg_record_size_in_bytes
, DDIPS.record_count * avg_record_size_in_bytes as dataspace
, DDIPS.page_count * 8192 as pagespace
, DDIPS.avg_page_space_used_in_percent
into #myspace
from sys.dm_db_index_physical_stats (@mydb,null,null,null,'sampled') as DDIPS
	INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
	INNER JOIN sys.schemas S on T.schema_id = S.schema_id
	INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
where DDIPS.index_id = 1
	and record_count > 1000

select distinct
	*
from #myspace
order by 6 desc


declare @SQL nvarchar(max)
IF object_id('dba.dbo.tmpListAllTablesWithCounts') IS NOT NULL DROP TABLE dba.dbo.tmpListAllTablesWithCounts
CREATE TABLE dba.[dbo].[tmpListAllTablesWithCounts]([DBName] [varchar](512) NULL,[TableName] [varchar](512) NULL,[Rows] [bigint] NULL,[Reserved_KB] [bigint] NULL,[Data_KB] [bigint] NULL,[Index_KB] [bigint] NULL,[Unused_KB] [bigint] NULL)
truncate table dba.dbo.tmpListAllTablesWithCounts

set @SQL='use [?];
	if ''?'' <> ''master'' and ''?'' <> ''msdb'' and ''?'' <> ''tempdb'' and ''?'' <> ''systemdatacollection''
		and ''?'' <> ''distribution'' and ''?'' <> ''dba'' and ''?'' <> ''model''
		Begin
			with cte as (
			select TableName=object_schema_name(object_id) + ''.'' + object_name(object_id)
			, rows=sum(case when index_id < 2 then row_count else 0 end)
			, reserved_kb=8*sum(reserved_page_count)
			, data_kb=8*sum( case 
				 when index_id<2 then in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count 
				 else lob_used_page_count + row_overflow_used_page_count 
				end )
			, index_kb=8*(sum(used_page_count) 
				- sum( case 
					   when index_id<2 then in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count 
					else lob_used_page_count + row_overflow_used_page_count 
					end )
				 )    
			, unused_kb=8*sum(reserved_page_count-used_page_count)
			from sys.dm_db_partition_stats
			where object_id > 1024
			group by object_id)

			select db_name() as DBname, TableName, Rows, Reserved_KB, Data_KB, Index_KB, Unused_KB from cte order by DBname, TableName
		End'

Print @SQL

Insert into dba.dbo.tmpListAllTablesWithCounts ( DBName, TableName, Rows, Reserved_KB, Data_KB, Index_KB, Unused_KB )  exec sp_MSForeachdb @SQL




;with cte as (
select top 1000 DBName, TableName, Rows
from dba.dbo.tmpListAllTablesWithCounts 
where rows > 3000000 order by Rows desc)
select * from cte
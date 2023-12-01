use steriaHistorical
DECLARE
@objname NVARCHAR(776),
@id INT,
@dbname sysname
SELECT
@objname = 'dbo.StreamSummary',
@dbname = ISNULL(PARSENAME(@objname, 3),DB_NAME()),
@id = OBJECT_ID(@objname)
SELECT
i.*,
CASE
WHEN ps.usedpages > ps.pages THEN (ps.usedpages - ps.pages)
ELSE 0
END * 8 indexsize
FROM sys.indexes i
INNER JOIN (
SELECT
OBJECT_ID,
index_id,
SUM (used_page_count) usedpages,
SUM (
CASE
WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
ELSE lob_used_page_count + row_overflow_used_page_count
END
)pages
FROM sys.dm_db_partition_stats
WHERE OBJECT_ID = @id
GROUP BY OBJECT_ID, index_id
) ps ON i.index_id = ps.index_id
WHERE i.OBJECT_ID = @id
GO
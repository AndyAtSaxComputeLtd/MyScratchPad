use expmccCRM
--exec expmccCRM.[dbo].[collect_index_stats] @Clear  = 0

SET NOCOUNT ON
DECLARE @BeginTime DATETIME, @EndTime DATETIME, @DB VARCHAR(10), @DBID INT 

SET @DB = COALESCE(CAST(@DBID AS VARCHAR(10)),'%')

SELECT  @BeginTime = MIN([capturetime]), @EndTime = MAX([capturetime])
    FROM [dba].[dbo].[RunningIndexStats]

SELECT CONVERT(varchar(50),@BeginTime,120) AS [Start Time], 
CONVERT(varchar(50),@EndTime,120) AS [End Time]
    ,CONVERT(varchar(50),@EndTime - @BeginTime,108) AS [Duration (hh:mm:ss)]

SELECT fs.dbname, fs.tablename, fs.indexname, 
	fs.TotalReads-b.TotalReads as Reads,
	fs.inserts-b.inserts as inserts
FROM [dba].[dbo].[RunningIndexStats] AS fs INNER JOIN 
(SELECT * FROM [dba].[dbo].[RunningIndexStats] AS b WHERE  b.[capturetime] = @BeginTime) AS b
 ON (fs.[dbname] = b.[DBname] and fs.tablename = b.tablename and fs.indexname = b.indexname)
WHERE fs.[capturetime] = @EndTime 




    



--select * FROM [tempdb].[dbo].[file_stats]
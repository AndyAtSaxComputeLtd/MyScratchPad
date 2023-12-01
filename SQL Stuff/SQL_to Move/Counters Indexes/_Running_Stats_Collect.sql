use dba
exec [dbo].[collect_index_stats] @Clear  = 0

SET NOCOUNT ON
DECLARE @BeginTime DATETIME, @EndTime DATETIME, @DB VARCHAR(10), @DBID INT 

SET @DB = COALESCE(CAST(@DBID AS VARCHAR(10)),'%')

SELECT  @BeginTime = MIN([capture_time]), @EndTime = MAX([capture_time])
    FROM [tempdb].[dbo].[file_stats]

SELECT CONVERT(varchar(50),@BeginTime,120) AS [Start Time], 
CONVERT(varchar(50),@EndTime,120) AS [End Time]
    ,CONVERT(varchar(50),@EndTime - @BeginTime,108) AS [Duration (hh:mm:ss)]

;with cte as (SELECT fs.[database_id] AS [Database ID]
       , fs.[file_id] AS [File ID]
       , (fs.[num_of_reads] - a.[num_of_reads]) AS [NumberReads]
       , CONVERT(VARCHAR(20),CAST(((fs.[num_of_bytes_read] - a.[num_of_bytes_read]) / 
1048576.0) AS MONEY),1)  AS [MBs Read]
       , (fs.[io_stall_read_ms] - a.[io_stall_read_ms]) AS [IoStallReadMS]
       , (fs.[num_of_writes] - a.[num_of_writes]) AS [NumberWrites]
       , CONVERT(VARCHAR(20),CAST(((fs.[num_of_bytes_written] - a.[num_of_bytes_written]) / 
1048576.0) AS MONEY),1) AS [MBs Written]
       , (fs.[io_stall_write_ms] - a.[io_stall_write_ms]) AS [IoStallWriteMS]
       , (fs.[io_stall] - a.[io_stall]) AS [IoStallMS]
       , CONVERT(VARCHAR(20),CAST((fs.[size_on_disk_bytes] / 1048576.0) AS MONEY),1) AS 
[MBsOnDisk]
       , (SELECT c.[name] FROM [master].[sys].[databases] AS c WHERE c.[database_id] = 
fs.[database_id]) AS [DB Name]
       , (SELECT RIGHT(d.[physical_name],CHARINDEX('\',REVERSE(d.[physical_name]))-1) 
            FROM [master].[sys].[master_files] AS d 
                WHERE d.[file_id] = fs.[file_id] AND d.[database_id] = fs.[database_id]) AS [File Name]
       ,fs.[capture_time] AS [Last Sample]
FROM [tempdb].[dbo].[file_stats] AS fs INNER JOIN (SELECT 
b.[database_id],b.[file_id],b.[num_of_reads],b.[num_of_bytes_read],b.[io_stall_read_ms]
                                        
,b.[num_of_writes],b.[num_of_bytes_written],b.[io_stall_write_ms],b.[io_stall]
                                    FROM [tempdb].[dbo].[file_stats] AS b
                                        WHERE  b.[capture_time] = @BeginTime) AS a
                    ON (fs.[database_id] = a.[database_id] AND fs.[file_id] = a.[file_id])
WHERE fs.[capture_time] = @EndTime AND CAST(fs.[database_id] AS VARCHAR(10)) LIKE 
@DB
    
)
select [NumberReads]+NumberWrites as NumberIOs, * from cte 
where [File Name] like '%.mdf' and (NumberReads<>0 or NumberWrites<>0 )
order by NumberIOs desc

--select * FROM [tempdb].[dbo].[file_stats]
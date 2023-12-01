--must be run be run inside the database you which to view

Declare @Clear INT = 0

IF OBJECT_ID(N'[DBA].[dbo].[RunningIndexStats]',N'U') IS NULL	
	Begin	
		create table DBA.dbo.RunningIndexStats ( CaptureTime datetime, DBname nVarChar(512),TableName nVarChar(512), IndexName nVarChar(512), Index_ID int, UserScans bigint, UserSeeks bigint, TotalReads bigint, Inserts bigint, Rows bigint, readsPERinsert decimal(38,15), DropStateMent varchar(max))
		Create Clustered Index ixdba_CaptureTime on DBA.dbo.RunningIndexStats (CaptureTime ASC) with (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		ALTER TABLE DBA.dbo.RunningIndexStats  ADD  CONSTRAINT [DF_RunningIndexStats] DEFAULT (getutcdate()) FOR [CaptureTime]
	End
	
IF @Clear = 1
BEGIN
    drop Index ixdba_CaptureTime on DBA.dbo.RunningIndexStats;
    TRUNCATE TABLE [DBA].[dbo].[RunningIndexStats];
    Create Clustered Index ixdba_CaptureTime on DBA.dbo.RunningIndexStats (CaptureTime ASC) with (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY];
END

Insert into [DBA].[dbo].[RunningIndexStats] ( DBname, TableName, IndexName, Index_ID, UserScans, UserSeeks, TotalReads, Inserts, Rows, readsPERinsert, DropStateMent)
SELECT DB_name() as DBname, o.name, indexname=i.name, i.Index_ID,user_scans as UserScans,user_seeks as UserSeeks , TotalReads=user_seeks + user_scans + user_lookups , user_updates as Inserts  
	, (SELECT SUM(p.rows) 
FROM sys.partitions p WHERE p.index_id = s.index_id AND s.object_id = p.object_id) as Rows
	, CASE
WHEN s.user_updates < 1 THEN 100
ELSE 1.00 * (s.user_seeks + s.user_scans + s.user_lookups) / s.user_updates
END AS readsPERinsert
, 'DROP INDEX ' + QUOTENAME(i.name)
+ ' ON ' + QUOTENAME(c.name) + '.' + QUOTENAME(OBJECT_NAME(s.object_id)) as 'drop statement'
FROM sys.dm_db_index_usage_stats s 
	INNER JOIN sys.indexes i ON i.index_id = s.index_id AND s.object_id = i.object_id  
	INNER JOIN sys.objects o on s.object_id = o.object_id
	INNER JOIN sys.schemas c on o.schema_id = c.schema_id
WHERE OBJECTPROPERTY(s.object_id,'IsUserTable') = 1 AND s.database_id = DB_ID() AND i.type_desc = 'nonclustered' AND i.is_primary_key = 0
	AND i.is_unique_constraint = 0 AND (SELECT SUM(p.rows) FROM sys.partitions p WHERE p.index_id = s.index_id AND s.object_id = p.object_id) > 1000
ORDER BY indexname;

delete from DBA.dbo.RunningIndexStats where capturetime < dateadd(dd,0-30,getutcdate())


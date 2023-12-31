use Auditlogs;
ALTER TABLE [dbo].[dbaLogs] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)

USE [Auditlogs]
ALTER TABLE dbo.tbl_PacketsLog REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)

EXECUTE dba.dbo.IndexOptimize @Databases = 'Auditlogs',
	@FragmentationLow = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
	@FragmentationMedium = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
	@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
	@FragmentationLevel1 = 5,
	@FragmentationLevel2 = 30,
	@UpdateStatistics = 'ALL',
	@FillFactor = 95,@PadIndex = 'Y',
	@LogToTable = 'Y',
	@Execute = 'Y',
	@Indexes = 'ALL_INDEXES',
	@OnlyModifiedStatistics='Y'
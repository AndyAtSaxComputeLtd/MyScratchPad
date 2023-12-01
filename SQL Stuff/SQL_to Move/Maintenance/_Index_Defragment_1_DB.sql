--wnHistorical
alter database [wnHistorical] SET RECOVERY Bulk_Logged WITH NO_WAIT
EXECUTE dba.dbo.IndexOptimize @Databases = 'wnHistorical',@FragmentationLow = NULL,@FragmentationMedium = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',@FragmentationLevel1 = 5,@FragmentationLevel2 = 30,@UpdateStatistics = 'ALL',@FillFactor = 95,@PadIndex = 'Y',@LogToTable = 'Y',@Execute = 'Y',@Indexes = 'ALL_INDEXES',@OnlyModifiedStatistics='Y'
alter database [wnHistorical] SET RECOVERY Full WITH NO_WAIT
 
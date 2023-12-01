--Check DB Autogrow and Space Availabilty before running this.
use steriaHistorical_dba
exec sp_helpfile
dbcc showfilesTATS (1)

ALTER TABLE  dbo.AgentsStateChanges REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MediaCallInfo REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.StreamSummary REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgAgentConnected REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgWrapUp REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgScriptCompleted REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgHangUp REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.LicensesInfo REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MediaData_VCS REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.CallData REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgCallHangUp REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgRing REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.Skills REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.CallQueueHistory REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.MsgCallArrival	 REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)
ALTER TABLE  dbo.CallQueueSkills REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = page)

EXECUTE dba.dbo.IndexOptimize @Databases = 'steriaHistorical_dba',
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
	
use steriaHistorical_dba
exec ap_helpfile
break;

DBCC SHRINKDatabase (N'steriaHistorical_data' , 1)
DBCC SHRINKDatabase (N'steriaHistorical_dba' , 20)
dbcc showfilesTATS (1)

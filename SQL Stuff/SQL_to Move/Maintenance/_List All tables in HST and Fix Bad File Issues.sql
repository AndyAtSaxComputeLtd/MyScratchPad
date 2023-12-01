USE [dba]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TableList]') AND type in (N'U')) DROP TABLE [dbo].[TableList]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
CREATE TABLE [dbo].[TableList](	[DB_Name] [varchar](256) NULL,	[Table_Name] [varchar](256) NULL) ON [PRIMARY]

SET ANSI_PADDING OFF
exec sp_MSforeachdb 'use [?]; 
insert dba.dbo.tablelist (DB_Name, Table_Name)
Select ''?'' as DB_Name ,name from sys.tables '

select distinct 

'use ['+DB_Name+']; 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[BT_AgentSummary]'') AND name = N''BT_AgentSummary_TQH_KEY'') 
	Begin
		ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT [BT_AgentSummary_TQH_KEY]
		ALTER TABLE BT_AgentSummary WITH NOCHECK
		 ADD CONSTRAINT  BT_AgentSummary_AT_KEY
		PRIMARY KEY NONCLUSTERED (Agent_ID, Timeslice) 
		 
		CREATE CLUSTERED INDEX IX_BT_AgentSummary_AT ON BT_AgentSummary
		(Agent_ID ASC, Timeslice ASC) WITH FILLFACTOR=70
	End'

 from dba.dbo.tablelist where Table_Name like 'BT_AgentSummary'




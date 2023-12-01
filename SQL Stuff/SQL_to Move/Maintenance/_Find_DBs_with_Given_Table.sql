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

select distinct DB_Name
 from dba.dbo.TableList where Table_Name like 'BT_AgentSummary'




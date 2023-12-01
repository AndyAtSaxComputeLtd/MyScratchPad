--Fix BT_AgenTSummary Table Shema to prevent bad files

Use wnHistorical

SET NOCOUNT ON
declare @cname nvarchar(64)
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__Logge__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying LoggedInTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [LoggedInTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [LoggedInTime]
END
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__NotAv__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying NotAvailableTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [NotAvailableTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [NotAvailableTime]
END
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__Avail__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying AvailableTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [AvailableTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [AvailableTime]
END
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__RingT__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying RingTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [RingTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [RingTime]
END
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__InCal__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying InCallTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [InCallTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [InCallTime]
END
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__OnHol__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying OnHoldTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [OnHoldTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [OnHoldTime]
END
 
SET @cname=NULL
SELECT @cname=Name FROM dbo.sysobjects WHERE Name like N'DF__BT_AgentS__WrapU__%' AND type = 'D'
IF @cname is NOT NULL
BEGIN
PRINT 'Modifying WrapUpTime'
EXEC ('ALTER TABLE [dbo].[BT_AgentSummary] DROP CONSTRAINT ' + @cname)
ALTER TABLE [dbo].[BT_AgentSummary] ALTER COLUMN [WrapUpTime] int
ALTER TABLE [dbo].[BT_AgentSummary] ADD  DEFAULT ((0)) FOR [WrapUpTime]
END
 
GO

use dba

Declare @DB nvarchar(4000), @SQL1 nvarchar(4000), @SQL2 nvarchar(4000), @SQL3 nvarchar(4000)

DECLARE a_cursor CURSOR FAST_FORWARD FOR

select distinct DBName from sp_list
where SPName='BT_AgentRingNotAnsweredCount_ccu6_sp'
order by DBName

OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @DB

WHILE @@FETCH_STATUS = 0
	BEGIN
		print @DB
		SET @DB = 'use '+QUOTENAME(@DB)+'; '

		set @SQL1=@DB+'
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[AgentsStateChanges]'') AND name = N''IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp'')
DROP INDEX [IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp] ON [dbo].[AgentsStateChanges] WITH ( ONLINE = OFF )


CREATE NONCLUSTERED INDEX [IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp] ON [dbo].[AgentsStateChanges] 
(
	[State_ID] ASC,
	[StateEndTime] ASC
)
INCLUDE ( [Msg_ID],
[AgentGlobal_ID],
[TimeStamp]) WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 97) ON [PRIMARY]

'
print @sql1
set @SQL2=@DB+'
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[tOnlineProfiles]'') AND name = N''IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp_2'')
DROP INDEX [IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp_2] ON [dbo].[tOnlineProfiles] WITH ( ONLINE = OFF )


CREATE NONCLUSTERED INDEX [IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp_2] ON [dbo].[tOnlineProfiles] 
(
	[Type] ASC
)
INCLUDE ( [Profile_ID],
[Type_ID]) WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 97) ON [PRIMARY]

'
print @SQL2
set @SQL3=@DB+'
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[tOnlineProfiles]'') AND name = N''IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp_3'')
DROP INDEX [IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp_3] ON [dbo].[tOnlineProfiles] WITH ( ONLINE = OFF )


CREATE NONCLUSTERED INDEX [IX_BTDBA_BT_AgentRingNotAnsweredCount_ccu6_sp_3] ON [dbo].[tOnlineProfiles] 
(
	[Profile_ID] ASC,
	[Type] ASC
)
INCLUDE ( [Type_ID]) WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 97) ON [PRIMARY]

'
print @SQL3
		exec sp_executesql @SQL1
		exec sp_executesql @SQL2
		exec sp_executesql @SQL3
		FETCH NEXT FROM a_cursor INTO @DB
	END 
CLOSE a_cursor
DEALLOCATE a_cursor
use [SystemAdministrator]
go

CREATE CLUSTERED INDEX [_dta_index_AgentsStateChanges_c_8_2089058478__K1_K6_K7_K4] ON [dbo].[AgentsStateChanges] 
(
	[Msg_ID] ASC,
	[TimeStamp] ASC,
	[State_ID] ASC,
	[Agent_ID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_2089058478_6_1_7_4] ON [dbo].[AgentsStateChanges]([TimeStamp], [Msg_ID], [State_ID], [Agent_ID])
go

CREATE STATISTICS [_dta_stat_2105058535_6_7_2_1] ON [dbo].[LicensesInfo]([BeginningTime], [EndTime], [LicenseType_ID], [License_ID])
go

CREATE STATISTICS [_dta_stat_2137058649_1_11_3_4] ON [dbo].[StreamFlowSummary]([Record_ID], [OfferedTime], [Stream_ID], [Tenant_ID])
go

CREATE STATISTICS [_dta_stat_2137058649_1_3_4_15_11_12_13] ON [dbo].[StreamFlowSummary]([Record_ID], [Stream_ID], [Tenant_ID], [TenantName], [OfferedTime], [FinalTime], [StreamType_ID])
go


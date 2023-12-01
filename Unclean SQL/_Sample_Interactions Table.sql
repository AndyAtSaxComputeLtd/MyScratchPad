use InformQA
set IDENTITY_INSERT [Interactions_DBA] on
insert [dbo].[Interactions_DBA] ([File_ID], Interaction_ID, Transaction_ID, Interaction_Type, Billing_Ref, Billing_Content, Billing_Quantity, Application, Interaction_Submitted, Interaction_Start, Interaction_Finish, Interface_, Interface_Customer, Timeperiod_ID, Durationperiod_ID, Interaction_Detail, StatusCode, StatusText, LatencyPeriod_ID, Interaction_Date, Interaction_time, Duration_Sec, Latency_Sec, XMLProcessed, InsertedDate)
select [File_ID], Interaction_ID, Transaction_ID, Interaction_Type, Billing_Ref, Billing_Content, Billing_Quantity, Application, Interaction_Submitted, Interaction_Start, Interaction_Finish, Interface_, Interface_Customer, Timeperiod_ID, Durationperiod_ID, Interaction_Detail, StatusCode, StatusText, LatencyPeriod_ID, Interaction_Date, Interaction_time, Duration_Sec, Latency_Sec, XMLProcessed, InsertedDate
from [dbo].[Interactions] TABLESAMPLE (10000 ROWS)
set IDENTITY_INSERT [Interactions_DBA] off
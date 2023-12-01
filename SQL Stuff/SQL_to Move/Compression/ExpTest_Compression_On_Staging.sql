exec sp_estimate_data_compression_savings 'dbo','AgentsStateChanges',null,null,'page'
exec sp_estimate_data_compression_savings 'dbo','MediaCallInfo',null,null,'page'		--yes
exec sp_estimate_data_compression_savings 'dbo','StreamSummary',null,null,'page'		--yes
exec sp_estimate_data_compression_savings 'dbo','MsgAgentConnected',null,null,'page'	--yes
exec sp_estimate_data_compression_savings 'dbo','MsgWrapUp',null,null,'page'			--yes
exec sp_estimate_data_compression_savings 'dbo','MsgScriptCompleted',null,null,'page'	--yes
exec sp_estimate_data_compression_savings 'dbo','MsgHangUp',null,null,'page'			--yes
exec sp_estimate_data_compression_savings 'dbo','LicensesInfo',null,null,'page'			--yes
exec sp_estimate_data_compression_savings 'dbo','MediaData_VCS',null,null,'page'		--yes
exec sp_estimate_data_compression_savings 'dbo','CallData',null,null,'page'				--yes
exec sp_estimate_data_compression_savings 'dbo','MsgCallHangUp',null,null,'page'		--yes
exec sp_estimate_data_compression_savings 'dbo','MsgRing',null,null,'page'				--yes
exec sp_estimate_data_compression_savings 'dbo','Skills',null,null,'page'				--yes
exec sp_estimate_data_compression_savings 'dbo','CallQueueHistory',null,null,'page'		--yes
exec sp_estimate_data_compression_savings 'dbo','MsgCallArrival',null,null,'page'		--yes
exec sp_estimate_data_compression_savings 'dbo','CallQueueSkills',null,null,'page'		--yes

--exec sp_estimate_data_compression_savings 'dbo','BT_AgentSummary',null,null,'page'		--Per Tenant
--exec sp_estimate_data_compression_savings 'dbo','MsgCallOut',null,null,'row'			--no
--exec sp_estimate_data_compression_savings 'dbo','MsgCallAccepted',null,null,'row'		--no
--exec sp_estimate_data_compression_savings 'dbo','MsgStreamOffered',null,null,'page'		--no
--exec sp_estimate_data_compression_savings 'dbo','AgentLicenseInfo',null,null,'page'		--no
--exec sp_estimate_data_compression_savings 'dbo','BT_QueueingPreaggregate_Table',null,null,'page' --Per Tenant
--exec sp_estimate_data_compression_savings 'dbo','MsgCallRefusal',null,null,'page'		--no
--exec sp_estimate_data_compression_savings 'dbo','AgentConfiguration',null,null,'page'	--no
--exec sp_estimate_data_compression_savings 'dbo','ConferenceParticipant',null,null,'page' --no
--exec sp_estimate_data_compression_savings 'dbo','BT_AgentLoginOut',null,null,'page'		 --Per Tenant
--exec sp_estimate_data_compression_savings 'dbo','MsgConference',null,null,'page'		--no
--exec sp_estimate_data_compression_savings 'dbo','MsgConferenceCallInfo',null,null,'page' --no
--exec sp_estimate_data_compression_savings 'dbo','MsgBridge',null,null,'page'			--no






--('dbo.AgentsStateChanges',
--'dbo.MediaCallInfo',
--'dbo.StreamSummary',
--'dbo.MsgAgentConnected',
--'dbo.MsgWrapUp',
--'dbo.MsgScriptCompleted',
--'dbo.MsgHangUp',
--'dbo.LicensesInfo',		
--'dbo.MediaData_VCS',	
--'dbo.CallData',	
--'dbo.MsgCallHangUp',
--'dbo.MsgRing',	
--'dbo.Skills',			
--'dbo.CallQueueHistory',
--'dbo.MsgCallArrival',	
--'dbo.CallQueueSkills')
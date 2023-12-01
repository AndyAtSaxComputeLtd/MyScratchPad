select * from vw_ExecutionLog
where 1=1 
--and Status <> 'rsSuccess'
and ItemPath='/APW/Event Audit Trail/Call History - Today'
--and itempath <> '/GSKCONSUMER/scheduler/Abandoned Calls - Last 7 Days'

order by TimeStart desc 



--dFrom=02/03/2015 00:00:00&dTo=02/03/2015 00:00:00&tenantId=510&dnisFilter=""&groupFilter=-1&agentFilter=-1&TimeZone=2&exportCsv=False
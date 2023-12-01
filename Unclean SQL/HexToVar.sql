select ss.call_id as HEX, ac.rec_id , ac.call_id as VARCHAR
from dbo.streamsummary ss with (NOLOCK)
left outer join [ldsq1f].[NCCRM].[dbo].[cc_activity] ac with (NOLOCK)
on master.dbo.fn_varbintohexstr(ss.call_id) = ac.call_id
where ss.offeredtime  >= '2011-06-21 11:00:00'


--------------- APdepackG activity to call_id ---------------
select ac.start_date, ac.rec_id ,   ss.call_id 
from dbo.streamsummary ss with (NOLOCK)
left outer join [ldsq1f].[apdepackgCRM].[dbo].[cc_activity] ac with (NOLOCK)
on master.dbo.fn_varbintohexstr(ss.call_id) = ac.call_id
where ss.offeredtime  >= '2011-07-14 10:00:00'
and ss.offeredtime  <= '2011-07-14 12:00:00'
and ac.rec_id in ('04YFG')

------------------ Pauls query -----------------

select ac.rec_id , ac.status, ac.wrap_code, ac.cli, ss.*  from dbo.streamsummary ss with (NOLOCK)
left outer join [ldsq1f].[NuffwellCRM].[dbo].[cc_activity] ac with (NOLOCK)
on master.dbo.fn_varbintohexstr(ss.call_id) = ac.call_id
where ss.offeredtime  >= '2012-04-02 00:00:01'
and ac.rec_id in ('09KUW','09IRP')

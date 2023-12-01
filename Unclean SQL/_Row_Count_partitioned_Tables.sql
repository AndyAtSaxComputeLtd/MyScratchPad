
select count(*) from [dbo].[Billing] with (nolock)
where interaction_start > dateadd(month,-3,getUTCdate())

select count(*) from [dbo].InteractionEvents_Converted with (nolock)
where eventtime > dateadd(month,-3,getUTCdate())

select count(*) from [dbo].InteractionEvents_Engaged with (nolock)
where eventtime > dateadd(month,-3,getUTCdate())

select count(*) from [dbo].InteractionEvents_Responded with (nolock)
where eventtime > dateadd(month,-3,getUTCdate())

select count(*) from [dbo].InteractionEvents_SOA with (nolock)
where eventtime > dateadd(month,-3,getUTCdate())

select count(*) from [dbo].Interactions with (nolock)
where interaction_date > dateadd(month,-3,getUTCdate())
--list mail items
USE msdb ;
GO
select * from dbo.sysmail_event_log l
left JOIN dbo.sysmail_faileditems as items
    ON items.mailitem_id = l.mailitem_id
where  1=1 
	and (description<> 'DatabaseMail process is shutting down' 
	and description <> 'DatabaseMail process is started')
order by log_date desc




GO

select * from dbo.sysmail_log 
order by log_date desc

select * from dbo.sysmail_mailitems
order by mailitem_id desc
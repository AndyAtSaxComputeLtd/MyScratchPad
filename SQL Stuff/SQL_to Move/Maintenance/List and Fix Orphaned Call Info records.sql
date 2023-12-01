truncate table dba.dbo.TmpOrphanedCalls
exec sp_msforeachdb 'use [?]; 
	insert into dba.dbo.TmpOrphanedCalls ([DB_Name], [RowID],[CallStartTimeStamp], ci, ii)
	select ''?'', ci.[RowID],CallStartTimeStamp, ci.callid, ii.callid 
	From [?].dbo.CallInfo ci
	Left Join [?].dbo.ImageInfo ii on ci.RowID = ii.PRCallInfoID
	where ii.CallID is null'
	
Select distinct [DB_NAME] from dba.dbo.TmpOrphanedCalls order by 1

select [DB_NAME], count(ci) as count
	from dba.dbo.TmpOrphanedCalls
	group by DB_Name
	order by 1 desc

--- to view and delete
select ci.[RowID], ci.CallID,ii.CallID
	From dbo.CallInfo ci
	Left Join dbo.ImageInfo ii on ci.RowID = ii.PRCallInfoID
	where ii.CallID is null
	
delete from callinfo where rowID in (select ci.[RowID] 
	From dbo.CallInfo ci
	Left Join dbo.ImageInfo ii on ci.RowID = ii.PRCallInfoID
	where ii.CallID is null	)
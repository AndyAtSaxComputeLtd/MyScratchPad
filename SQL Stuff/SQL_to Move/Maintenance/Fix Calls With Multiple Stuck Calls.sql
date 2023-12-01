
use slssRecording
                                                                                                                                                                                                                                                 
drop table dba.dbo.RowsToDelete
select RowID, callid, DATALENGTH(image) as Length
	into dba.dbo.RowsToDelete
	from dbo.ImageInfo
	where CallID in (select callid  from ImageInfo group by callid Having count(callid) >= 255) 

--List tartget calls
Select distinct callid from dba.dbo.RowsToDelete
select * from 	dba.dbo.RowsToDelete
--remove rows with data
delete from dba.dbo.RowsToDelete
	where Length is not null

--list target rows
select ii.RowID,ii.CallID from ImageInfo ii
	inner join dba.dbo.RowsToDelete rd on rd.RowID=ii.RowID
	
delete from imageinfo where RowID in (select RowID from dba.dbo.RowsToDelete)

select RowID, CallID, CallIDChar, PRCallInfoID, ImageTimeStamp, ImageFileName, ImageExt, ImageMimeType, MessageType, MessageID
	from imageinfo where callid in (select distinct callid from dba.dbo.RowsToDelete)





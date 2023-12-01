IF object_id('dba.dbo.syslog') IS NOT NULL  DROP TABLE dba.dbo.syslog
CREATE TABLE  dba.dbo.syslog (Timestamp datetime, ProcessInfo nvarchar(20),text nvarchar(max))
insert into dba.dbo.syslog (timestamp,Processinfo,Text) exec sys.xp_readerrorlog 

Select * from dba.dbo.syslog 
where Text not like '%backup%' and text not like '%backed%' and text not like '%I/O was resumed%' and text not like 'Setting database option RECOVERY%' 

order by timestamp desc

--truncate table dba.dbo.syslog

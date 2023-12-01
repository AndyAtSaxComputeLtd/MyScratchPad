use dba
--setup work area
IF object_id('dba.dbo.syslog') IS NOT NULL Begin DROP TABLE dba.dbo.syslog CREATE TABLE  dba.dbo.syslog (Timestamp datetime, ProcessInfo nvarchar(20),text nvarchar(max)) end
 
CREATE CLUSTERED INDEX [IX_BTDBA_TimeStamp] ON [dbo].[syslog] ([Timestamp] ASC) WITH (PAD_INDEX  = ON, FillFactor = 70, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
 
--Import the logfile
Insert into dba.dbo.syslog (timestamp,Processinfo,Text) exec sys.xp_readerrorlog 1,0
 
--Select pertinant errors from the logs
select * from dba.dbo.syslog
where text like '%because of insufficient disk space in filegroup%'
or text like '%is full. To find out why space in the log cannot%'
order by timestamp

--xp_readerrorlog  has four parameters
--1.EXEC Xp_readerrorlog 0

--here 0 stands for file number where latest file has 0 number and subsequent rolled over file has incremented  number. So this will display current errorlog file while incremented number will subsequent show rolled over file for 


--2.EXEC Xp_readerrorlog    0,   1
--here secound parameter has two values 
--1. error log
--2 agent log 

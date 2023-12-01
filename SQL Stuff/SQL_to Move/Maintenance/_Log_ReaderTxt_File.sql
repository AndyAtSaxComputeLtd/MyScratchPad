
use dba
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TxtFileReader]') AND type in (N'U')) drop table TxtFileReader

create table TxtFileReader (Text varchar(max))

BULK INSERT dba.dbo.TxtFileReader from '\\ldan03\d$\syslogd\lgsv.txt'


select right (Text,(len(text)-63)) from TxtFileReader where Text like '%DBQuery::errorHandler: command=INSERT%'
order by 1


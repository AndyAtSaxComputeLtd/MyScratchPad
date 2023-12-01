use dba
declare @SQL nvarchar(max)

IF object_id('dba.dbo.tmpSP_List') IS NOT NULL DROP TABLE dba.dbo.tmpSP_List;
create table dba.dbo.tmpSP_List (ID int identity (1,1), DBName varchar(256), SchemaName varchar(256), SPName varchar(256), Created datetime, Modified datetime, Timestamp datetime )

set @SQL='use [?];DECLARE @tab char(1)=char(9), @CR char(1)=CHAR(13),@LF char(1)=char(10);
;with cte as (
	SELECT ''?'' as DBname, Schema_Name(SCHEMA_ID) as SchemaName, Name as SPName, create_date as Created, modify_date as Modified, getUTCdate() as TimeStamp
FROM SYS.PROCEDURES
WHERE type=''p'' AND  type_desc=''SQL_STORED_PROCEDURE''and Is_MS_Shipped = 0)
 Select DBName, SchemaName, SPName, Created, Modified, Timestamp from CTE' 

Insert into dba.dbo.tmpSP_List ( DBName, SchemaName, SPName, Created, Modified, Timestamp )  exec sp_MSForeachdb @SQL

select * from dba.dbo.tmpSP_List 
where 1=1
	-- and SPName like '%DeleteMe%'
	
order by SPName

--Delete a SP from Every DB
--Declare @Col1 nvarchar(4000)
--DECLARE a_cursor CURSOR FAST_FORWARD FOR

--select 'use ['+DBName+']; drop procedure ['+SchemaName+'].['+SPName+']' as col1 from dba.dbo.tmpSP_List 
--where 1=1
--	and SPName like '%DeleteMe%'
--order by SPName

--OPEN a_cursor
--FETCH NEXT FROM a_cursor INTO @col1
--WHILE @@FETCH_STATUS = 0
--	BEGIN
--			print @col1
--			--exec sp_executesql @col1
--			FETCH NEXT FROM a_cursor INTO @col1
--	END 
--CLOSE a_cursor
--DEALLOCATE a_cursor








declare @SQL nvarchar(max)

IF object_id('dba.dbo.SP_List') IS NOT NULL DROP TABLE dba.dbo.SP_List;
create table dba.dbo.SP_List (DBName varchar(256), SchemaName varchar(256), SPName varchar(256), MD5 binary(16), Created datetime, Modified datetime, Timestamp datetime )

set @SQL='use [?];
;with cte as (
	SELECT ROUTINE_CATALOG as DBname, ROUTINE_SCHEMA as SchemaName, ROUTINE_NAME as SPName, 
    HASHBYTES(''MD5'', ROUTINE_DEFINITION) as MD5, CREATED, LAST_ALTERED as Modified, getUTCdate() as TimeStamp
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_TYPE = ''PROCEDURE''
    AND OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME), ''IsMSShipped'') = 0 )
 Select DBName, SchemaName, SPName, MD5, Created, Modified, Timestamp from CTE' 

Print @SQL

Insert into dba.dbo.SP_List ( DBName, SchemaName, SPName, MD5, Created, Modified, Timestamp )  exec sp_MSForeachdb @SQL

select DBName, SchemaName, SPName, MD5, Created, Modified, Timestamp, DATALENGTH(MD5) from dba.dbo.SP_List
where SPName = 'GroupPerformance'



DECLARE @SQL NVARCHAR(4000), @ShrinkDBname sysname, @ShrinkFileName nvarchar(256);
SET NOCOUNT ON
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'

IF object_id('tempdb..#vlfcounts') IS NOT NULL  DROP TABLE #vlfcounts
IF object_id('tempdb..#Fdetails') IS NOT NULL  DROP TABLE #Fdetails
IF object_id('tempdb..#DBtoShrink') IS NOT NULL  DROP TABLE #DBtoShrink

CREATE TABLE  #Fdetails (Dbname VARCHAR(100),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size VARCHAR(30))
create table #vlfcounts (dbname VARCHAR(100), vlfcount int) 

--variables to hold each 'iteration' 
declare @query varchar(100)
declare @dbname sysname 
declare @vlfs int 
 
--table variable used to 'loop' over databases 
declare @databases table (dbname sysname) 
insert into @databases 
--only choose online databases 
select name from sys.databases where state = 0 
 
--table varioable to capture DBCC loginfo output 
declare @dbccloginfo table 
( 
    fileid tinyint, 
    file_size bigint, 
    start_offset bigint, 
    fseqno int, 
    [status] tinyint, 
    parity tinyint, 
    create_lsn numeric(25,0) 
) 
 
while exists(select top 1 dbname from @databases) 
begin 
 
    set @dbname = (select top 1 dbname from @databases) 
    set @query = 'dbcc loginfo (' + '''' + @dbname + ''') with no_infomsgs ' 
 
    insert into @dbccloginfo 
    exec (@query) 
 
    set @vlfs = @@rowcount 
 
    insert #vlfcounts 
    values(@dbname, @vlfs) 
 
    delete from @databases where dbname = @dbname 
 
end 
 
----output the full list 

INSERT INTO #Fdetails
EXEC sp_msforeachdb @SQL


SELECT fd.Dbname ,Filename into #DBtoShrink FROM #Fdetails  fd
left outer join #vlfcounts vc on fd.Dbname=vc.dbname
where type = 'log' and vc.vlfcount > '200' and fd.dbname not in ('tempdb','master','msdb','model','systemadministrator') 


while (select count (*) from #DBtoShrink) > 0
begin

	Select top 1 @ShrinkDBname = dbname, @ShrinkFileName = Filename from #DBtoShrink order by Filename;
	delete from #DBtoShrink where dbname = @ShrinkDBname;
	set @SQL='use ['+@ShrinkDBname+']; DBCC SHRINKFILE ('''+@Shrinkfilename+''',1)'
	exec sp_executeSQL @SQL
	print @SQL
end





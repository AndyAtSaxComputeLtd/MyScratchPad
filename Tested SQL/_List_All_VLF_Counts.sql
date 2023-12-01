--List Virtual Logfiles in all databases.
--This number should be less than 200
--to improve backup performance

--variables to hold each 'iteration' 
declare @dbname sysname
declare @query varchar(100)
declare @vlfs int

--table variable used to 'loop' over databases 
declare @databases table (dbname sysname)
insert into @databases
--only choose online databases 
select name
from sys.databases
where state = 0

--table variable to hold results 
declare @vlfcounts table 
    (dbname sysname,
    vlfcount int)

--table varioable to capture DBCC loginfo output 
declare @dbccloginfo table 
(
    recoveryUnitID int,
    fileid tinyint,
    file_size bigint,
    start_offset bigint,
    fseqno int,
    [status] tinyint,
    parity tinyint,
    create_lsn numeric(25,0) 
)

while exists(select top 1
    dbname
from @databases ) 
begin

    set @dbname = (select top 1
        dbname
    from @databases)
    set @query = 'dbcc loginfo (' + '''' + @dbname + ''') '

    insert into @dbccloginfo

    exec (@query)

    set @vlfs = @@rowcount

    insert @vlfcounts
    values(@dbname, @vlfs)

    delete from @databases where dbname = @dbname

end

--output the full list 
select dbname, vlfcount
from @vlfcounts
where vlfcount > 0
order by vlfcount desc
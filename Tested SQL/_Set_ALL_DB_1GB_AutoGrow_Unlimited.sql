--Script to Set All Databases 1GB AutoGrow - No Size Limit for Log and data files

-- NB uncomment line 47 if you want it to do it.
IF OBJECT_ID('tempdb..#DBlist') IS NOT NULL DROP TABLE #DBlist
CREATE TABLE  #DBlist (Dbname VARCHAR(50),Filename VARCHAR(50))

Declare @Name nvarchar(4000)
DECLARE @SQL NVARCHAR(4000);
SET NOCOUNT ON

DECLARE a_cursor CURSOR FAST_FORWARD FOR

select name
	from sys.databases sid
	where state = 0 -- database online


OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @Name
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL='USE ['+@Name+'];SELECT '''+@Name+''' [Dbname],[name] [Filename] FROM ['+@Name+'].sys.database_files'
		INSERT INTO #DBlist
		exec sp_executesql @sql
		FETCH NEXT FROM a_cursor INTO @Name
	END 
CLOSE a_cursor
DEALLOCATE a_cursor

select * from #dblist

Declare @FileName varchar(255);

DECLARE a_cursor CURSOR FAST_FORWARD FOR
	select DBName, Filename from #DBlist 
	--where DBname='Admin'
	order by Dbname

OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @Name, @FileName
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL='USE [master];	ALTER DATABASE '+QUOTENAME(@name)+' MODIFY FILE ( NAME = N'''+@Filename+''', MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )'
		print @SQL
		-- exec sp_executesql @sql
		FETCH NEXT FROM a_cursor INTO @Name, @Filename
	END 
CLOSE a_cursor
DEALLOCATE a_cursor
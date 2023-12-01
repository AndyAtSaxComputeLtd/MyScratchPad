--Script to list all database file sizes on one server

-- uncomment line 48 for it to do it.
IF OBJECT_ID('tempdb..#DBlist') IS NOT NULL DROP TABLE #DBlist
CREATE TABLE  #DBlist (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10))

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
		SET @SQL='USE ['+@Name+'];SELECT '''+@Name+''' [Dbname],[name] [Filename],Type_desc FROM ['+@Name+'].sys.database_files'
		INSERT INTO #DBlist
		exec sp_executesql @sql
		FETCH NEXT FROM a_cursor INTO @Name
	END 
CLOSE a_cursor
DEALLOCATE a_cursor

Declare @FileName varchar(255), @Type varchar(20);

DECLARE a_cursor CURSOR FAST_FORWARD FOR
	select DBName, Filename,Type from #DBlist 
	where 1=1
	-- and DBname='DBA'
	-- and type='LOG'
	--and type='ROWS'
	order by Dbname

OPEN a_cursor

FETCH NEXT FROM a_cursor INTO @Name, @FileName, @Type
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL='USE '+quotename(@Name)+'; DBCC SHRINKFILE (N'''+@FileName+''' , 0)' --reorg and shrink
		--SET @SQL='USE '+quotename(@Name)+'; DBCC SHRINKFILE (N'''+@FileName+''' , 0, TruncateOnly)' --shrinkonly
		print @SQL
		-- exec sp_executesql @sql
		FETCH NEXT FROM a_cursor INTO @Name, @Filename, @Type
	END 
CLOSE a_cursor
DEALLOCATE a_cursor
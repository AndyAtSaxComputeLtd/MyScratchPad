DECLARE @SQL NVARCHAR(4000), @Totalfixed int,@MaxSizeMB int, @AutoGrowMB varchar(30), @RemainingMB Int, @PercentageRemaining int, @Pointer int, @Grow_KB int
Declare @MailSubject NVARCHAR(4000), @Body1 NVARCHAR(4000), @tableHTML1 NVARCHAR(max), @tableHTML NVARCHAR(max), @email varchar(max), @GrowSize int, @GrowP_KB int, @AutoG_KB int

SET NOCOUNT ON
SET @SQL='USE [?];SELECT ''?'' [Dbname],[name] [Filename],type_desc [Type],physical_name [FilePath],CONVERT(INT,[size]/128.0) [TotalSize_MB],CONVERT(INT,FILEPROPERTY(name, ''SpaceUsed''))/128.0 AS [Space_Used_MB],CASE is_percent_growth WHEN 1 THEN CONVERT(VARCHAR(5),growth)+''%'' ELSE CONVERT(VARCHAR(20),(growth/128))+'' MB'' END [Autogrow_Value] ,CASE max_size WHEN -1 THEN CASE growth WHEN 0 THEN CONVERT(VARCHAR(30),''Restricted'') ELSE CONVERT(VARCHAR(30),''Unlimited'') END ELSE CONVERT(VARCHAR(25),max_size/128) END [Max_Size] FROM [?].sys.database_files'
Set @Email='platforma@dba.bt.com'

IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##Fdetails') DROP TABLE ##Fdetails
IF EXISTS(SELECT 1 FROM tempdb..sysobjects WHERE name='##FdetailsLow') DROP TABLE ##FdetailsLow
CREATE TABLE  ##Fdetails (Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Autogrow_Value VARCHAR(15),Max_Size varchar(30))
CREATE TABLE  ##FdetailsLow (ID int Identity (1,1), Dbname VARCHAR(50),Filename VARCHAR(50),Type VARCHAR(10),Filepath VARCHAR(2000),TotalSize_MB INT,Space_Used_MB INT,Remaining_MB int ,Autogrow_Value VARCHAR(15),Max_Size varchar(30), PercentageRemaining int,GrowP_KB int, AutoG_KB INT)

INSERT INTO ##Fdetails
EXEC sp_msforeachdb @SQL

SELECT Dbname ,Filename ,Type,Max_Size ,TotalSize_MB ,Space_Used_MB, TotalSize_MB - Space_Used_MB as [Remaining_MB],Autogrow_Value ,
    cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) as Percentage
FROM ##Fdetails order by percentage

Insert into ##FdetailsLow (
	Dbname, 
	Filename, 
	Type,  
	TotalSize_MB, 
	Space_Used_MB,
	Remaining_MB, 
	Autogrow_Value, 
	Max_Size, 
	PercentageRemaining,
	GrowP_KB,
	AutoG_KB)
SELECT 
	Dbname, 
	Filename, 
	Type,  
	TotalSize_MB, 
	Space_Used_MB, 
	TotalSize_MB - Space_Used_MB as [Remaining_MB],
	AutoGrow_Value,
	Max_Size,
    cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) as PercentageRemaining,
    cast((((20 - (TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100) * TotalSize_MB / 100) + TotalSize_MB)*1024 as int ),
    case AutoGrow_Value
		when '100 MB' then ( 100 + TotalSize_MB ) * 1024
		when '200 MB' then ( 200 + TotalSize_MB ) * 1024
		when '400 MB' then ( 400 + TotalSize_MB ) * 1024
		else ( 100 + TotalSize_MB ) * 1024	end as Grow_KB
	
FROM ##Fdetails

where type = 'rows' and cast(((TotalSize_MB - Space_Used_MB)  / (TotalSize_MB+.001) * 100 ) as int ) <= 15
	and DBName not in ('msdb','tempdb','master','model', 'distribution')
order by DBName

Select * from ##FdetailsLow

if @email is not null and (select count (*) from ##FDetailsLow) > 0
	Begin
		Set @MailSubject = 'Databases Auto Grow SQL Agent Job Report' 
		Set @Body1 = 'The databases below have been grown automatically to 20% free space or by the autogrow amount, whichever is the larger - this email is for information only, no action is required'	
		SET @tableHTML1 =
				N'<H1>Databases with low space remaining</H1>' +
				N'<table border="1">' +
				N'<tr>' +
					N'<th>Name</th>' +
					N'<th>Percentage Remaining</th>' +
				N'</tr>' +
				
		CAST ( ( Select 
			td = DBname, '', 
			td = PercentageRemaining, ''
			from ##FdetailsLow 
			order by DBName
			FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) ) + N'</table>' ;
		If @tableHTML1 is null set @tableHTML1 = ' ' 
		Set @tableHTML = @Body1 + @tableHTML1 
		EXEC msdb.dbo.sp_send_dbmail @recipients=@email,
			@subject = @MailSubject,
			@body = @tableHTML,
			@body_format = 'HTML' ;
	END

Set @Pointer = 1
WHILE @Pointer <= (select count (*) from ##FDetailsLow)
	BEGIN
		select @GrowP_KB = GrowP_KB, @AutoG_KB = AutoG_KB  from ##FDetailsLow where ID = @Pointer
		Set @GrowSize = @GrowP_KB
		If @AutoG_KB > @GrowP_KB Set @GrowSize = @AutoG_KB
		
		Select @SQL = 'use [master]; ALTER DATABASE [' + Dbname + '] MODIFY FILE ( NAME = N''' + Filename +''', Size = ' + cast(@GrowSize as varchar(30)) + 'KB)' from ##FDetailsLow where ID = @Pointer
		-- Exec sp_executeSQL @SQL
		print @SQL
		INSERT INTO dba.dbo.DB_Log (DB_LOG) SELECT @SQL	
		SET @Pointer = @Pointer + 1	
	END	
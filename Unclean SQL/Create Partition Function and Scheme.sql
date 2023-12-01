/*Partitioning*/

--Database: MyPartDB
--Table:	[dbo].[Interactions]
--Partition on: [EntryDate]
--Min Date:	'2011-08-03 08:30:15.000'

/*******************************************
TODO:
  - Create FileGroups and files - written - run in dev (additional FGs will be created dynamically by sliding window script)
  - Create Partion Function - written - run in dev 
  - Create Partition Scheme - written - run in dev 
*******************************************/

ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion012013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion012013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion012013.ndf') TO FILEGROUP fgInteractionsDatePartion012013
ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion022013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion022013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion022013.ndf') TO FILEGROUP fgInteractionsDatePartion022013
ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion032013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion032013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion032013.ndf') TO FILEGROUP fgInteractionsDatePartion032013
ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion042013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion042013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion014013.ndf') TO FILEGROUP fgInteractionsDatePartion042013
ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion052013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion052013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion052013.ndf') TO FILEGROUP fgInteractionsDatePartion052013
ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion062013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion062013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion062013.ndf') TO FILEGROUP fgInteractionsDatePartion062013
ALTER DATABASE [MyPartDB] ADD FILEGROUP [fgInteractionsDatePartion072013]
ALTER DATABASE [MyPartDB] ADD FILE (NAME = fgInteractionsDatePartion072013, SIZE = 1024MB, FILEGROWTH = 1024MB,MAXSIZE = UNLIMITED, FILENAME = 'S:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\MyPartDB_fgInteractionsDatePartion072013.ndf') TO FILEGROUP fgInteractionsDatePartion072013

CREATE PARTITION FUNCTION pfMonthlySmallDate (smalldatetime)
AS RANGE RIGHT 
FOR VALUES ( '2009-01-01' --<  2009-01-01 [PRIMARY]
			,'2010-01-01' -->= 2009-01-01 and <2010-01-01 [PRIMARY]
			,'2011-01-01' -->= 2010-01-01 and <2011-01-01 [PRIMARY]
			,'2012-01-01' -->= 2011-01-01 and <2012-01-01 [PRIMARY]
			,'2013-01-01' -->= 2012-01-01 and <2013-01-01 [PRIMARY]
			,'2013-02-01' -->= 2013-01-01 and <2013-02-01 [fgInteractionsDatePartion012013]
			,'2013-03-01' -->= 2013-02-01 and <2013-03-01 [fgInteractionsDatePartion022013]
			,'2013-04-01' -->= 2013-02-01 and <2013-04-01 [fgInteractionsDatePartion032013]
			,'2013-05-01' -->= 2013-04-01 and <2013-05-01 [fgInteractionsDatePartion042013]
			,'2013-06-01' -->= 2013-05-01 and <2013-06-01 [fgInteractionsDatePartion052013]
			,'2013-07-01' -->= 2013-06-01 and <2013-07-01 [fgInteractionsDatePartion062013]
		   )

CREATE PARTITION SCHEME psInteractionsMonthlyDate
AS PARTITION pfMonthlySmallDate
TO ([PRIMARY],[Primary],[PRIMARY],[Primary],[PRIMARY],[fgInteractionsDatePartion012013],[fgInteractionsDatePartion022013],[fgInteractionsDatePartion032013],[fgInteractionsDatePartion042013],[fgInteractionsDatePartion052013],[fgInteractionsDatePartion062013],[fgInteractionsDatePartion072013])



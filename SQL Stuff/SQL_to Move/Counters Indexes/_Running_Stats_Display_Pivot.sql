--display index stats pivot table
use dba

SET NOCOUNT ON
DECLARE @BeginTime DATETIME, @EndTime DATETIME, @DB VARCHAR(10), @DBID INT 

Declare @StartDate int, @FinishDate int;
Declare @StartSTR nvarchar(max), @FinishSTR nvarchar(max), @StartDatePart varchar(20);
Declare @DBname varchar(256) ='Auditlogs'

set nocount on
set @StartDatePart = '03 Feb 2014'
Set @StartSTR  = @StartDatePart + ' 00:00';
Set @FinishSTR = DATEADD(day, 1, @StartSTR);
Set @FinishSTR = DATEADD(minute, 5, @FinishSTR);

Select 'Index Read Counts'
--Take only todays records	
;with cte4 as (
	SELECT ROW_NUMBER() OVER (PARTITION BY fs.dbname,fs.tablename,fs.indexname ORDER BY fs.CaptureTime) as Row, fs.captureTime, fs.dbname,fs.tablename,fs.indexname,fs.Totalreads,fs.inserts
		FROM [dba].[dbo].[RunningIndexStats] fs
		Where fs.CaptureTIme >=dateadd(minute, 0-90, @StartSTR) and fs.CaptureTIme <=@FinishSTR 
			and (@DBname=fs.DBname or @DBname = 'All')
),
--Self Join and subtract to find the difference
cte5 as (
select a.captureTime, a.dbname, a.tablename, a.indexname, 
	a.Totalreads - b.Totalreads as Diff_TotalReads 
	from cte4 a
	Left Join  
		(SELECT Row, captureTime, dbname, tablename, indexname, Totalreads, inserts FROM cte4) AS b 
	ON a.[dbname] = b.[DBname] and a.tablename = b.tablename and a.indexname = b.indexname and a.row = b.row +1
	--This Where clause drops the 23:00 record from previous Day
	where a.Totalreads - b.Totalreads is not null 
),
--Create Headers for Pivot
cte2 as (
SELECT @StartDatePart as [Date], dbname, tablename, IndexName, [0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23] from 
	( select DATENAME(hh,CaptureTime) as DateRun,dbname, tablename, indexname, Diff_TotalReads 
		from cte5 ) w
--Pivot on hour across the entire day
pivot (max(Diff_TotalReads) for DateRun in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])) p
)
Select Date,dbname,tablename, IndexName,
	isnull([1],0) as [01], isnull([2],0) as [02], isnull([3],0) as [03], isnull([4],0) as [04], isnull([5],0) as [05], isnull([6],0) as [06],
	isnull([7],0) as [07], isnull([8],0) as [08], isnull([9],0) as [09], isnull([10],0) as [10], isnull([11],0) as [11], isnull([12],0) as [12],
	isnull([13],0) as [13], isnull([14],0) as [14], isnull([15],0) as [15], isnull([16],0) as [16], isnull([17],0) as [17], isnull([18],0) as [18],
	isnull([19],0) as [19], isnull([20],0) as [20], isnull([21],0) as [21], isnull([22],0) as [22], isnull([23],0) as [23], isnull([0],0) as [24]
from cte2;

--Inserts Table next
select 'Index Update Counts due to Inserts'
--Take only todays records	
;with cte4 as (
	SELECT ROW_NUMBER() OVER (PARTITION BY fs.dbname,fs.tablename,fs.indexname ORDER BY fs.CaptureTime) as Row, fs.captureTime, fs.dbname,fs.tablename,fs.indexname,fs.Totalreads,fs.inserts
		FROM [dba].[dbo].[RunningIndexStats] fs
		Where fs.CaptureTIme >=dateadd(minute, 0-90, @StartSTR) and fs.CaptureTIme <=@FinishSTR 
		and (@DBname=fs.DBname or @DBname = 'All')
),
--Self Join and subtract to find the difference
cte5 as (
select a.captureTime, a.dbname, a.tablename, a.indexname, 
	a.inserts - b.inserts as Diff_inserts 
	from cte4 a
	Left Join  
		(SELECT Row, captureTime, dbname, tablename, indexname, Totalreads, inserts FROM cte4) AS b 
	ON a.[dbname] = b.[DBname] and a.tablename = b.tablename and a.indexname = b.indexname and a.row = b.row +1
	--This Where clause drops the 23:00 record from previous Day
	where a.inserts - b.inserts is not null 
),
--Create Headers for Pivot
cte2 as (
SELECT @StartDatePart as [Date], dbname, tablename, IndexName, [0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23] from 
	( select DATENAME(hh,CaptureTime) as DateRun,dbname, tablename, indexname, Diff_inserts 
		from cte5 ) w
--Pivot on hour across the entire day
pivot (max(Diff_inserts) for DateRun in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])) p
)
Select Date,dbname,tablename, IndexName,
	isnull([1],0) as [01], isnull([2],0) as [02], isnull([3],0) as [03], isnull([4],0) as [04], isnull([5],0) as [05], isnull([6],0) as [06],
	isnull([7],0) as [07], isnull([8],0) as [08], isnull([9],0) as [09], isnull([10],0) as [10], isnull([11],0) as [11], isnull([12],0) as [12],
	isnull([13],0) as [13], isnull([14],0) as [14], isnull([15],0) as [15], isnull([16],0) as [16], isnull([17],0) as [17], isnull([18],0) as [18],
	isnull([19],0) as [19], isnull([20],0) as [20], isnull([21],0) as [21], isnull([22],0) as [22], isnull([23],0) as [23], isnull([0],0) as [24]
from cte2;
USE dba;
GO

Declare @StartDate int, @FinishDate int;
Declare @StartSTR nvarchar(max), @FinishSTR nvarchar(max);

Set @StartDate = 13;
Set @FinishDate = 13;

While @StartDate <= @FinishDate
Begin
	Set @StartSTR = '2013-09-' + cast(@StartDate as nvarchar(2)) + ' 00:00'
	Set @FinishSTR = '2013-09-' + cast(@StartDate as nvarchar(2)) + ' 23:59'
	;with cte as (
	SELECT '2012-10-' + cast(@StartDate as nvarchar(2)) as Date,WaitType, 
		IsNULL([0],0) as [0], IsNULL([1],0) as [1], IsNULL([2],0) as [2], IsNULL([3],0) as [3], IsNULL([4],0) as [4],
		IsNULL([5],0) as [5], IsNULL([6],0) as [6], IsNULL([7],0) as [7], IsNULL([8],0) as [8], IsNULL([9],0) as [9],
		IsNULL([10],0) as [10], IsNULL([11],0) as [11], IsNULL([12],0) as [12], IsNULL([13],0) as [13], IsNULL([14],0) as [14],
		IsNULL([15],0) as [15], IsNULL([16],0) as [16], IsNULL([17],0) as [17], IsNULL([18],0) as [18], IsNULL([19],0) as [19],
		IsNULL([20],0) as [20], IsNULL([21],0) as [21], IsNULL([22],0) as [22], IsNULL([23],0) as [23]
	from 
		(Select 
			WaitType,
			DATENAME(hh,DateRun) as DateRun, 
			cast(Total_Wait_S as Int) as Total_Wait_S
		From dbo.SQL_Waits where DateRun >= @StartSTR and DateRun <= @FinishSTR
		) w
	pivot (sum (total_wait_s) for DateRun in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])) p)
	select Date, WaitType, 
		[1] as [01], [2] as [02], [3] as [03], [4] as [04], [5] as [05], [6] as [06], [7] as [07],[8] as [08], [9] as [09],
		[10],[11],[12],[13],[14],[15],[16],
		[17],[18],[19],[20],[21],[22],[23], [0] as [24]
	from cte;
	Set @StartDate = @StartDate + 1
END
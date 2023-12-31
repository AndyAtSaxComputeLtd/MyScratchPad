USE [DBA]
GO
/****** Object:  StoredProcedure [dbo].[sp_viewIndexUsage]    Script Date: 11/07/2023 13:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE [dbo].[sp_viewFileStalls]
	@StartDatePart datetime = '2023-11-07',
	@DB varchar(256) = 'All',	-- use all for all,
	@file varchar(4) = 'both'   -- mdf for MDF, ldf for MDF, both for both
AS
BEGIN

	SET NOCOUNT ON;

	Declare @StartSTR datetime, @StartSTR datetime;

	Set @StartSTR  = cast(@StartDatePart + ' 00:00' as datetime)
	Set @StartSTR = DATEADD(day, 1, @StartSTR);
	Set @StartSTR = DATEADD(minute, 5, @StartSTR);


	--Take only todays records	 - IO Stalls
	;with
		cte4
		as
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY fs.[DBname]+ ' \ ' + fs.[filename] ORDER BY fs.CaptureTime) as Row,
				fs.captureTime, fs.[DBname]+ ' \ ' + fs.[filename] as [Object], fs.[io_stall]

			FROM [DBA].[dbo].[RunningFileStats] fs
			Where fs.CaptureTime >=dateadd(minute, 0-90, @StartSTR) and fs.CaptureTime <=@StartSTR
				and (dbname=@DB or @DB = 'All')
				and ((@file='mdf' and filename like '%mdf%') or (@file='ldf' and filename like '%ldf%') or @file='both')
		)
--Self Join and subtract to find the difference
,
		cte5
		as
		(
			select a.row, a.CaptureTime, a.object, (a.[io_stall]-b.[io_stall]) /1000 as [Diff_TotalIOStall]

			from cte4 a
				Left Join
				(SELECT row, CaptureTime, object, [io_stall]
				FROM cte4) AS b
				ON a.object = b.object and a.row = b.row + 1
			--This Where clause drops the 23:00 record from previous Day
			where a.[io_stall] - b.[io_stall] is not null
		)

--Create Headers for Pivot
,
		cte2
		as
		(
			SELECT @StartDatePart as [Date], object, [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23]
			from
				( select DATENAME(hh,CaptureTime) as DateRun, object, [Diff_TotalIOStall]
				from cte5 ) w
		
--Pivot on hour across the entire day
pivot (max([Diff_TotalIOStall]) for DateRun in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])) p
		)
	Select rtrim(left(Date,11)) as Date, Object,
		isnull([1],0) as [01], isnull([2],0) as [02], isnull([3],0) as [03], isnull([4],0) as [04], isnull([5],0) as [05], isnull([6],0) as [06],
		isnull([7],0) as [07], isnull([8],0) as [08], isnull([9],0) as [09], isnull([10],0) as [10], isnull([11],0) as [11], isnull([12],0) as [12],
		isnull([13],0) as [13], isnull([14],0) as [14], isnull([15],0) as [15], isnull([16],0) as [16], isnull([17],0) as [17], isnull([18],0) as [18],
		isnull([19],0) as [19], isnull([20],0) as [20], isnull([21],0) as [21], isnull([22],0) as [22], isnull([23],0) as [23], isnull([0],0) as [24]
	from cte2
	order by Date, Object

END
go


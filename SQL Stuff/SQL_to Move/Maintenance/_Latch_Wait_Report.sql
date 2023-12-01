With [Latches] AS
	(Select
		[latch_class],
		[wait_time_ms] /1000 as [WaitS],
		[waiting_requests_count] as [WaitCount],
		100.0 * [Wait_time_MS] / sum([Wait_time_ms]) over() as [Percentage],
		Row_Number() over (Order by [Wait_Time_ms] DESC) AS [RowNum]
	From sys.dm_os_latch_stats
	WHERE [latch_class] NOT IN ('BUFFER')
	)

Select 
	w1.[latch_class] as [LatchClass],
	CAST ([w1].[waits] AS DECIMAL(14,2)) as [Wait_S],
	[w1].[WaitCount] as [WaitCount],
	CAST ([W1].[PERCENTAGE] AS DECIMAL(14,2)) as [Percentage],
	CAST ((cast([w1].[WaitS] as decimal(14,4)) / [w1].[WaitCount]) as DECIMAL (14,4)) as [AvgWait_S]
	FROM [LATCHES] as [W1]
	Inner Join  [Latches] as [W2]
		on W2.[RowNum] <= [w1].[RowNum]
Group By [W1].[RowNum], [w1].[latch_class],
	[w1].[waits], [w1].[waitcount], [w1].[percentage]
Having 
	SUM ([W2].[percentage]) - [w1].[percentage] < 95 --percentage

		
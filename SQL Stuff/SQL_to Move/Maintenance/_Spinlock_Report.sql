
IF EXISTS (Select * from [tempdb].[sys].[objects] 
	where [name] = N'##TempSpinLockStats1')
	drop table [##TempSpinLockStats1];
IF EXISTS (Select * from [tempdb].[sys].[objects] 
	where [name] = N'##TempSpinLockStats2')
	drop table [##TempSpinLockStats2];	
--Baseline
Select * into [##TempSpinLockStats1] from sys.dm_os_spinlock_stats 
	where [collisions] > 0
	order by [name];
GO

-- Now run workload

BEGIN
    WAITFOR DELAY '01:00';
END
--Capture updated Stats
Select * into [##TempSpinLockStats2] from sys.dm_os_spinlock_stats 
	where [collisions] > 0
	order by [name];

--Diff the results
Select '***' as [NEW],
	[ts2].[name] as [Spinlock],
	[ts2].[collisions] as [DiffCollisions],
	[ts2].[Spins] as [DiffSpins],
	[ts2].[Spins_per_collision] as [SpinsPerCollision],
	[ts2].[Sleep_time] as [DiffsSleepTime],
	[ts2].[backoffs] as [DiffBackoffs]
FROM [##TempSpinLockStats2] [TS2]

LEFT OUTER JOIN [##TempSpinLockStats1] [ts1]
	on [ts1].[name] = [ts2].[name]
Where [ts1].[name] IS NULL
UNION
SELECT
	'' AS [NEW],
	[ts2].[name] as [Spinlock],
	[ts2].[collisions] - [ts1].[collisions] as [DiffCollisions],
	[ts2].[Spins] - [ts1].[Spins] as [DiffSpins],
	CASE ([ts2].[Spins] - [ts1].[Spins]) WHEN 0 THEN 0
		ELSE ([ts2].[Spins] - [ts1].[Spins] / [ts2].[collisions] - [ts1].[collisions]) END
		AS [SpinsPerCollision],
		
	[ts2].[Sleep_time] - [ts1].[Sleep_time] as [DiffsSleepTime],
	[ts2].[backoffs] - [ts1].[backoffs] as [DiffBackoffs]
FROM [##TempSpinLockStats2] [TS2]
LEFT OUTER JOIN [##TempSpinLockStats1] [ts1]
	on [ts1].[name] = [ts2].[name]
Where [ts1].[name] IS NOT NULL AND
	[ts2].[collisions] - [ts1].[collisions] >0
ORDER BY [NEW] DESC, [Spinlock] ASC;
GO	

	
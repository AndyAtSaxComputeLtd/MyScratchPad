;with cte as (
	SELECT [Date], [0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23] from 
		(
			select  db_name() as DBName, 
					cast(datepart(yy,Created_Date) as varchar(4)) + '/' +  
					cast(datepart(MM,Created_Date) as varchar(2)) + '/' +  
					cast(datepart(DD,Created_Date) as varchar(2)) as Date,
					datepart(HH,Created_Date) as Hour , count(*) as Count
			from tbl_Activities
			group by datepart(yy,Created_Date),datepart(MM,Created_Date),datepart(DD,Created_Date),datepart(HH,Created_Date)
			--order by datepart(yy,Created_Date) desc ,datepart(MM,Created_Date) desc ,datepart(DD,Created_Date) desc,datepart(HH,Created_Date)
		) W
	pivot (max([Count]) for [Hour] in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])) p
	)
Select [Date],
	isnull([1],0) as [01], isnull([2],0) as [02], isnull([3],0) as [03], isnull([4],0) as [04], isnull([5],0) as [05], isnull([6],0) as [06],
	isnull([7],0) as [07], isnull([8],0) as [08], isnull([9],0) as [09], isnull([10],0) as [10], isnull([11],0) as [11], isnull([12],0) as [12],
	isnull([13],0) as [13], isnull([14],0) as [14], isnull([15],0) as [15], isnull([16],0) as [16], isnull([17],0) as [17], isnull([18],0) as [18],
	isnull([19],0) as [19], isnull([20],0) as [20], isnull([21],0) as [21], isnull([22],0) as [22], isnull([23],0) as [23], isnull([0],0) as [24]
from cte
order by cast(Date as datetime) desc

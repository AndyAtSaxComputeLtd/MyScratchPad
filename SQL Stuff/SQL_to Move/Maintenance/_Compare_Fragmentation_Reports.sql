Declare @FirstStartDate datetime, @FirstEndDate datetime;
Declare @SecondStartDate datetime, @SecondEndDate datetime;
Declare @FirstDate nvarchar(20), @SecondDate nvarchar(20);

Set @FirstDate = '27 OCT 2012'
Set @SecondDate = '27 OCT 012'

Set @FirstStartDate  = Cast((@FirstDate + ' 06:00:00') as datetime)
Set @FirstEndDate    = Cast((@FirstDate + ' 07:00:00') as datetime)
Set @SecondStartDate = Cast((@SecondDate + ' 07:01:00') as datetime)
Set @SecondEndDate   = Cast((@SecondDate  + ' 23:15:59')as datetime)

IF object_id('tempdb..#Index_History1') IS NOT NULL DROP TABLE #Index_History1;
IF object_id('tempdb..#Index_History2') IS NOT NULL DROP TABLE #Index_History2;

Select TS, DBname, Index_Name, Table_Name, PercentFrag, page_count, Index_type_desc
	INTO #Index_History1 FROM [dba].[dbo].[index_history] 
	WHERE TS >= @FirstStartDate and TS <= @FirstEndDate

Select TS,DBname, Index_Name, Table_Name, PercentFrag, page_count, Index_type_desc
	INTO #Index_History2 FROM [dba].[dbo].[index_history] 
	WHERE TS >= @SecondStartDate and TS <= @SecondEndDate
	
Select 'First Runtime ' , datediff(mi,min(TS),max(TS)) from #Index_History1
Select 'Second Runtime ', datediff(mi,min(TS),max(TS)) from #Index_History2
select 'First  Indexes Optimised', count (TS) from #Index_History1 WHERE PercentFrag >10 and Index_type_desc<>'HEAP' and page_count > 10
select 'Second Indexes Optimised', count (TS) from #Index_History2 WHERE PercentFrag >10 and Index_type_desc<>'HEAP' and page_count > 10

select A.DBname, A.Table_Name, A.Index_Name,
	A.PercentFrag as [Orig_%], B.PercentFrag as [new_%], B.PercentFrag - A.PercentFrag as Shift, b.Page_Count
	from #Index_History1 A
	inner JOIN #Index_History2 B
		on  A.DBname = B.DBname and
			A.Index_name = B.Index_Name and
			A.Table_Name = B.Table_Name

Where A.PercentFrag >10 -- and B.PercentFrag >10 
and A.Index_type_desc<>'HEAP' and b.page_count > 10
and B.PercentFrag >10
order by Index_Name,B.PercentFrag  desc, DBName
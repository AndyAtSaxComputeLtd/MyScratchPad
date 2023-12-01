--Calculate Current Retention Period
--truncate table dba.dbo.Recording_Rretentions

DECLARE @Counter		INT
DECLARE @DBName		NVARChar(max)
DECLARE @SQLRUN			NVARChar(max)


IF object_id('tempdb..#DBnames') IS NOT NULL DROP TABLE #DBnames;
CREATE TABLE #dbnames ( ID INT Identity(1,1), DBname VarChar(256)  )

--Insert where not exists


Select DBname 
	into #dbnames
	from [ldsqbc\ccu].cosmocall61.dbo.sidatabases
	where DBserver='ccu_rec_records' and DBType_ID = 2



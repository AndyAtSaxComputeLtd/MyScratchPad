with CTE1 as (SELECT o.name AS [U_Table_Name], x.name AS [U_Index_Name],
       U.partition_number AS [U_Partition],
       U.index_id AS [U_Index_ID], x.type_desc AS [U_Index_Type],
       U.leaf_update_count * 100.0 /
           (U.range_scan_count + U.leaf_insert_count
            + U.leaf_delete_count + U.leaf_update_count
            + U.leaf_page_merge_count + U.singleton_lookup_count
           ) AS [Percent_Update]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) U
JOIN sys.objects o ON o.object_id = U.object_id
JOIN sys.indexes x ON x.object_id = U.object_id AND x.index_id = U.index_id

WHERE (U.range_scan_count + U.leaf_insert_count
       + U.leaf_delete_count + leaf_update_count
       + U.leaf_page_merge_count + U.singleton_lookup_count) != 0
AND objectproperty(U.object_id,'IsUserTable') = 1)
, CTE2 as (
Select U_Table_Name as TableName, U_Index_Name as IndexName, U_Index_Type as IndexType, cast(isnull(Percent_Update,0) as decimal (5,2)) as PercentUpdate, cast(isnull(S_Percent_Scan,0) as decimal(5,1)) as PercentScan
from CTE1 as U
LEFT join (SELECT o.name AS [S_Table_Name], x.name AS [S_Index_Name],
       S.partition_number AS [S_Partition],
       S.index_id AS [S_Index_ID], x.type_desc AS [S_Index_Type],
       S.range_scan_count * 100.0 /
           (S.range_scan_count + S.leaf_insert_count
            + S.leaf_delete_count + S.leaf_update_count
            + S.leaf_page_merge_count + S.singleton_lookup_count
           ) AS [S_Percent_Scan]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) S
JOIN sys.objects o ON o.object_id = S.object_id
JOIN sys.indexes x ON x.object_id = S.object_id AND x.index_id = S.index_id
WHERE (S.range_scan_count + S.leaf_insert_count
       + S.leaf_delete_count + leaf_update_count
       + S.leaf_page_merge_count + S.singleton_lookup_count) != 0
AND objectproperty(S.object_id,'IsUserTable') = 1) AS S ON U_Table_Name = S_Table_Name  and U_Index_Name = S_Index_Name)

Select * into #CompressTest
	from CTE2
	where TableName in ('AgentsStateChanges','MediaCallInfo','StreamSummary','MsgAgentConnected','MsgWrapUp','MsgScriptCompleted','MsgHangUp','LicensesInfo','MediaData_VCS','CallData','MsgCallHangUp','MsgRing','Skills','CallQueueHistory','MsgCallArrival	','CallQueueSkills')

delete from #CompressTest
where CAST(PercentUpdate as Int) = 0 and CAST(Percentscan as Int) = 0 

Alter Table #CompressTest add S_Decision_H varchar(100)
Alter Table #CompressTest add U_Decision_H varchar(100)
Alter Table #CompressTest add S_Decision_L varchar(100)
Alter Table #CompressTest add U_Decision_L varchar(100)

update #CompressTest
set S_Decision_H = 'Page' 
where PercentScan >70

update #CompressTest
set U_Decision_L = 'Page' 
where PercentUpdate <30

update #CompressTest
set S_Decision_L = 'row' 
where PercentScan <30

update #CompressTest
set U_Decision_H = 'Row' 
where PercentUpdate >70

Select * from #CompressTest

Drop Table #CompressTest




--_List All Indexes
WITH CTE (TableName, IndexName) AS (
    SELECT 
        st.name AS TableName, 
        si.name AS IndexName
    FROM 
        sys.indexes AS si
    LEFT JOIN 
        sys.objects AS so ON so.object_id = si.object_id
    LEFT JOIN 
        sys.tables AS st ON so.object_id = st.object_id
    WHERE 
        index_id > 0 -- omit the default heap
        AND so.Is_Ms_Shipped = 0 -- omit system tables
        AND st.name <> 'sysdiagrams'
)

SELECT 
    cte.TableName, 
    cte.IndexName
FROM 
    cte
LEFT JOIN (
    SELECT 
        name AS indexname,
        OBJECT_NAME(object_id) AS tablename
    FROM 
        sys.indexes 
    WHERE 
        type_desc LIKE '%COLUMNSTORE%'
) cs ON cs.tablename = cte.tablename AND cs.indexname = cte.IndexName
WHERE 
    cs.indexname IS NULL AND cs.tablename IS null
ORDER BY 
    cte.TableName, 
    cte.IndexName
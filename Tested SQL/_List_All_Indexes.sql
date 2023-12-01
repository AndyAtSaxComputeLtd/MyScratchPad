--_List All Indexes
;WITH CTE (SchemaName, TableName, IndexName) AS (
    SELECT
        schema_name(schema_id) AS SchemaName, 
        OBJECT_NAME(si.object_id) AS TableName, 
        si.name AS IndexName
    FROM 
        sys.indexes AS si
    LEFT JOIN 
        sys.objects AS so ON so.object_id = si.object_id
    WHERE 
        index_id > 0 -- omit the default heap
        AND OBJECTPROPERTY(si.object_id, 'IsMsShipped') = 0 -- omit system tables
        AND NOT (schema_name(schema_id) = 'dbo' AND OBJECT_NAME(si.object_id) = 'sysdiagrams')
)

SELECT 
    SchemaName,
    TableName,
    IndexName
FROM 
    cte 
ORDER BY 
    SchemaName,
    TableName,
    IndexName
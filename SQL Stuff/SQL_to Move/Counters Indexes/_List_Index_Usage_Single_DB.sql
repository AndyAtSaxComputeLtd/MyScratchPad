use usgcsHistorical
;with cte as (
SELECT PVT.TABLENAME, PVT.INDEXNAME, PVT.INDEX_ID, [1] AS COL1, [2] AS COL2, [3] AS COL3, 
       [4] AS COL4,  [5] AS COL5, [6] AS COL6, [7] AS COL7, B.USER_SEEKS, 
       B.USER_SCANS, B.USER_LOOKUPS 
FROM   (SELECT A.NAME AS TABLENAME, 
               A.OBJECT_ID, 
               B.NAME AS INDEXNAME, 
               B.INDEX_ID, 
               D.NAME AS COLUMNNAME, 
               C.KEY_ORDINAL 
        FROM   SYS.OBJECTS A 
               INNER JOIN SYS.INDEXES B 
                 ON A.OBJECT_ID = B.OBJECT_ID 
               INNER JOIN SYS.INDEX_COLUMNS C 
                 ON B.OBJECT_ID = C.OBJECT_ID 
                    AND B.INDEX_ID = C.INDEX_ID 
               INNER JOIN SYS.COLUMNS D 
                 ON C.OBJECT_ID = D.OBJECT_ID 
                    AND C.COLUMN_ID = D.COLUMN_ID 
        WHERE  A.TYPE <> 'S') P 
       PIVOT 
       (MIN(COLUMNNAME) 
        FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT 
       INNER JOIN SYS.DM_DB_INDEX_USAGE_STATS B 
         ON PVT.OBJECT_ID = B.OBJECT_ID 
            AND PVT.INDEX_ID = B.INDEX_ID 
            AND B.DATABASE_ID = DB_ID() 
UNION  
SELECT TABLENAME, INDEXNAME, INDEX_ID, [1] AS COL1, [2] AS COL2, [3] AS COL3, 
       [4] AS COL4, [5] AS COL5, [6] AS COL6, [7] AS COL7, 0, 0, 0 
FROM   (SELECT A.NAME AS TABLENAME, 
               A.OBJECT_ID, 
               B.NAME AS INDEXNAME, 
               B.INDEX_ID, 
               D.NAME AS COLUMNNAME, 
               C.KEY_ORDINAL 
        FROM   SYS.OBJECTS A 
               INNER JOIN SYS.INDEXES B 
                 ON A.OBJECT_ID = B.OBJECT_ID 
               INNER JOIN SYS.INDEX_COLUMNS C 
                 ON B.OBJECT_ID = C.OBJECT_ID 
                    AND B.INDEX_ID = C.INDEX_ID 
               INNER JOIN SYS.COLUMNS D 
                 ON C.OBJECT_ID = D.OBJECT_ID 
                    AND C.COLUMN_ID = D.COLUMN_ID 
        WHERE  A.TYPE <> 'S') P 
       PIVOT 
       (MIN(COLUMNNAME) 
        FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT 
WHERE  NOT EXISTS (SELECT OBJECT_ID, 
                          INDEX_ID 
                   FROM   SYS.DM_DB_INDEX_USAGE_STATS B 
                   WHERE  DATABASE_ID = DB_ID(DB_NAME()) 
                          AND PVT.OBJECT_ID = B.OBJECT_ID 
                          AND PVT.INDEX_ID = B.INDEX_ID) )
select * from cte   
where 1=1
	--and user_lookups = 0 and user_scans = 0 and user_seeks = 0                      
	and TABLENAME not in ('sysarticlecolumns', 'sysarticleupdates', 'syscommittab', 'syscommittab', 'sysdiagrams', 'sysdiagrams', 'syspublications', 'sysreplservers', 'systranschemas')
	
ORDER BY TABLENAME, INDEX_ID;
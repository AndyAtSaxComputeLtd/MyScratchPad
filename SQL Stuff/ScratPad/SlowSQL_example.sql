SELECT
    GETUTCDATE() as __ingestion_time__,
    [Obj_Id],
    [Obj_HL],
    [Obj_SubHL],
    [Obj_WC],
    [Obj_BL],
    [Obj_AU],
    [NPTRSE_TS]
FROM
    (
                SELECT oa.*, n.NPTRSE_TS
    FROM [NLASQL].[dbo].[Obj_Articles] oa
        LEFT join [NLASQL].[dbo].[Objs] o on oa.Obj_Id = o.Obj_ID
        LEFT join [NLASQL].[dbo].[NPTRSE] n on o.NPTRSE_ID = n.NPTRSE_ID
            ) base

WHERE ([Obj_Id] > 191880506)
    OR ([NPTRSE_TS] >= '2023-11-01 00:00:00.000' AND [NPTRSE_TS] < '2023-11-09 00:00:00.000')
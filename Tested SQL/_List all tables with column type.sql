

SELECT distinct
   SchemaName = c.table_schema,
         TableName = c.table_name
         --ColumnName = c.column_name,
         --DataType = data_type
FROM     information_schema.columns c
         INNER JOIN information_schema.tables t
           ON c.table_name = t.table_name
              AND c.table_schema = t.table_schema
              AND t.table_type = 'BASE TABLE'
			  where data_type not in (
'bigint',
'bit',
'char',
'decimal',
'float',
'int',
'numeric',
'nvarchar',
'smallint',
'text',
'tinyint',
'uniqueidentifier',
'varchar',
'xml'
)
ORDER BY SchemaName,
         TableName
         --ColumnName
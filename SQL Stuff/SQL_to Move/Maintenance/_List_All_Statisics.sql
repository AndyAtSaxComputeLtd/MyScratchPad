--lists all statistics in one db
;with cte (TableName, ColumnName, StatName,AutoCreated, UserCreated) as (
	SELECT 	OBJECT_NAME(s.[object_id]) AS TableName,
		c.name AS ColumnName,
		s.name AS StatName,
		s.auto_created,
		s.user_created
	FROM sys.stats s JOIN sys.stats_columns sc ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
	JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
	WHERE OBJECTPROPERTY(s.OBJECT_ID,'IsUserTable') = 1
	AND (s.auto_created = 1 OR s.user_created = 1) )

Select TableName, ColumnName, StatName,AutoCreated, UserCreated from cte
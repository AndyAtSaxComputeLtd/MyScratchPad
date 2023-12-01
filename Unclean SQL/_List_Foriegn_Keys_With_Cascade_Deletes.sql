DECLARE @t NVARCHAR(128)
SET @t = 'My_Table_Name'

SELECT p.name, fk.delete_referential_action_desc, t.name
FROM sys.foreign_keys fk
INNER JOIN sys.objects t ON fk.parent_object_id = t.object_id
INNER JOIN sys.objects p ON fk.referenced_object_id = p.object_id
--WHERE p.name = @t
ORDER BY 1, 3
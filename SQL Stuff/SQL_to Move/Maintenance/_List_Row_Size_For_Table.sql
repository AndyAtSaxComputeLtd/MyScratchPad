--Lists Row Size foir Tables

select OBJECT_NAME(syscolumns.[id]) as [tablename],
SUM(syscolumns.length) as [rowsize]
from syscolumns
join sysobjects on syscolumns.id = sysobjects.id
where sysobjects.xtype='u'
group by OBJECT_NAME(syscolumns.id)

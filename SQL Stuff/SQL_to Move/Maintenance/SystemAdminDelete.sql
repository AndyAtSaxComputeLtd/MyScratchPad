use systemadministrator


print 'ServersAvailability'
DELETE FROM ServersAvailability  WHERE timestamp   < dateadd(d,-310,getdate())
go
print 'Streamflowsummary'
DELETE FROM Streamflowsummary  WHERE offeredtime   < dateadd(d,-310,getdate())
go
print 'TrunksConfiguration'
DELETE FROM TrunksConfiguration  WHERE timestamp   < dateadd(d,-310,getdate())
go
print 'tUpgradeIDsTranslation'
DELETE FROM tUpgradeIDsTranslation WHERE timestamp < dateadd(d,-310,getdate())
go
print 'VCSConfiguration'
DELETE FROM VCSConfiguration  WHERE timestamp      < dateadd(d,-310,getdate())
go
print 'agentsStateChanges'
DELETE FROM agentsStateChanges  WHERE timestamp    < dateadd(d,-310,getdate())
go
print 'LicensesInfo'
DELETE FROM LicensesInfo WHERE BeginningTime       < dateadd(d,-310,getdate())
go

--Set Link User Access All Databases
--USE [AdobeHistorical];CREATE USER [LinkUser] FOR LOGIN [LinkUser];EXEC sp_addrolemember N'db_datareader', N'LinkUser';EXEC sp_addrolemember N'db_datawriter', N'LinkUser'
EXEC sp_MSforeachdb 'IF ''?''  NOT IN (''tempdb'',''model'',''master'',''msdb'',''distribution'',''tempdb'',''SystemDataCollection'')
BEGIN
       USE [?]
       CREATE USER [LinkUser] FOR LOGIN [LinkUser]
       EXEC sp_addrolemember N''db_datareader'', N''LinkUser''
       EXEC sp_addrolemember N''db_datawriter'', N''LinkUser''
       
END'





-- Checking for Locked Pages in Memory (LPIM)
-- Glenn Berry
-- SQLskills.com


-- Windows version information 
SELECT windows_release, windows_service_pack_level, 
       windows_sku, os_language_version
FROM sys.dm_os_windows_info WITH (NOLOCK) OPTION (RECOMPILE);

-- Gives you major OS version, Service Pack, Edition, and language info for the operating system 
-- 6.3 is either Windows 8.1 or Windows Server 2012 R2
-- 6.2 is either Windows 8 or Windows Server 2012
-- 6.1 is either Windows 7 or Windows Server 2008 R2
-- 6.0 is either Windows Vista or Windows Server 2008


-- SQL Server Process Address space info 
-- (shows whether locked pages is enabled, among other things)
SELECT physical_memory_in_use_kb/1024 AS [SQL Server Memory Usage (MB)], 
       locked_page_allocations_kb
FROM sys.dm_os_process_memory WITH (NOLOCK) OPTION (RECOMPILE);


-- Get max server memory (MB) value for instance  
SELECT name, value, value_in_use, minimum, maximum, 
       [description], is_dynamic, is_advanced
FROM sys.configurations WITH (NOLOCK)
WHERE name = N'max server memory (MB)' OPTION (RECOMPILE);


-- SQL Server Services information 
SELECT servicename, process_id, startup_type_desc, status_desc, 
last_startup_time, service_account, is_clustered, cluster_nodename, [filename]
FROM sys.dm_server_services WITH (NOLOCK) OPTION (RECOMPILE);

-- GLENN2012\SQLServiceAccount


-- Set max server memory to 26624 (26GB)
EXEC sys.sp_configure 'show advanced options', 1;  
GO
RECONFIGURE WITH OVERRIDE;
EXEC sys.sp_configure 'max server memory (MB)', 26624;
GO
RECONFIGURE WITH OVERRIDE;
GO


-- Get max server memory (MB) value for instance  
SELECT name, value, value_in_use, minimum, maximum, [description], is_dynamic, is_advanced
FROM sys.configurations WITH (NOLOCK)
WHERE name = N'max server memory (MB)' OPTION (RECOMPILE);


-- SQL Server Process Address space info 
-- (shows whether locked pages is enabled, among other things)
SELECT physical_memory_in_use_kb/1024 AS [SQL Server Memory Usage (MB)], 
       locked_page_allocations_kb
FROM sys.dm_os_process_memory WITH (NOLOCK) OPTION (RECOMPILE);





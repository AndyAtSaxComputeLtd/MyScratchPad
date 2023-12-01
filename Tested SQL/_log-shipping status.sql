
SELECT *
FROM msdb.dbo.log_shipping_primary_databases;

SELECT *
FROM msdb.dbo.log_shipping_secondary;

SELECT *
FROM msdb.dbo.log_shipping_monitor_history_detail;

SELECT *
FROM msdb.dbo.log_shipping_monitor_secondary
WHERE secondary_database = 'YourDatabaseName';

SELECT *
FROM msdb.dbo.log_shipping_monitor_alert
WHERE alert_type NOT LIKE 'Informational%';


SELECT ls.primary_server, ls.primary_database, backup_source_directory, backup_destination_directory, ls.last_copied_file, last_restored_date, last_restored_date_utc, last_restored_latency, lhd.message
	FROM msdb.dbo.log_shipping_secondary ls
	join msdb.dbo.log_shipping_monitor_secondary lsm on ls.secondary_id = lsm.secondary_id
	join msdb.dbo.log_shipping_monitor_history_detail lhd on ls.secondary_id = lhd.agent_id
	order by ls.primary_server, ls.primary_database, lhd.log_time_utc

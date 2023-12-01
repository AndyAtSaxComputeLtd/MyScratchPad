--Query 3 Subscription Query--This code is from: http://www.sqlservercentral.com/Forums/Topic1131922-150-1.aspx#bm1132607 

SELECT 
       U.username, 
       CAT.[name]AS RptName, 
       CAT.[path],        
       sub.lastruntime, 
       sub.laststatus, 
       LEFT(Cast( sjsch.next_run_date AS CHAR(8)), 4) 
       + '-' 
       + Substring(Cast( sjsch.next_run_date AS CHAR(8)), 5, 2) 
       + '-' 
       + RIGHT(Cast( sjsch.next_run_date AS CHAR(8)), 2) 
       + ' ' + CASE WHEN Len(Cast( sjsch.next_run_time AS VARCHAR(6))) = 5 THEN '0' 
       + LEFT 
       (Cast( sjsch.next_run_time AS VARCHAR(6)), 1) ELSE 
       LEFT(Cast( sjsch.next_run_time AS 
       VARCHAR(6)), 2) END + ':' + CASE WHEN Len(Cast( sjsch.next_run_time AS 
       VARCHAR(6))) 
       = 5 THEN Substring(Cast( sjsch.next_run_time AS VARCHAR(6)), 2, 2) ELSE 
       Substring( 
       Cast( sjsch.next_run_time AS VARCHAR(6)), 3, 2) END + ':00.000' AS 
       NextRunTime, 
       CASE 
         WHEN job.[enabled] = 1 THEN 'Enabled' 
         ELSE 'Disabled' 
       END AS JobStatus 
       , 
       sub.modifieddate, 
       sub.description, 
       sub.parameters, 

       CASE SCH.recurrencetype WHEN 1 THEN 'Once' WHEN 3 THEN CASE 
       SCH.daysinterval 
       WHEN 1 THEN 'Every day' ELSE 'Every other ' + Cast(SCH.daysinterval AS 
       VARCHAR) 
       + ' day.' END WHEN 4 THEN CASE SCH.daysofweek WHEN 1 THEN 'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Sunday' WHEN 2 THEN 
       'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Monday' WHEN 4 THEN 
       'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Tuesday' WHEN 8 THEN 
       'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Wednesday' WHEN 16 THEN 
       'Every ' 
       + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Thursday' WHEN 32 THEN 
       'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Friday' WHEN 64 THEN 
       'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + ' week on Saturday' WHEN 42 THEN 
       'Every ' + 
       Cast(SCH.weeksinterval AS VARCHAR) + 
       ' week on Monday, Wednesday, and Friday' 
       WHEN 62 THEN 'Every ' 
       + Cast(SCH.weeksinterval AS VARCHAR) + 
       ' week on Monday, Tuesday, Wednesday, Thursday and Friday' WHEN 126 THEN 
       'Every ' + Cast(SCH.weeksinterval AS VARCHAR) + 
       ' week from Monday to Saturday' 
       WHEN 127 THEN 'Every ' + Cast(SCH.weeksinterval AS VARCHAR) + 
       ' week on every day' END WHEN 5 THEN CASE SCH.daysofmonth WHEN 1 THEN 
       'Day ' + 
       '1' + ' of each month' WHEN 2 THEN 'Day ' + '2' + ' of each month'WHEN 4 
       THEN 
       'Day ' + '3' + ' of each month' WHEN 8 THEN 'Day ' + '4' + 
       ' of each month' WHEN 
       16 THEN 'Day ' + '5' + ' of each month' WHEN 32 THEN 'Day ' + '6' + 
       ' of each month' WHEN 64 THEN 'Day ' + '7' + ' of each month' WHEN 128 
       THEN 
       'Day ' + '8' + ' of each month' WHEN 256 THEN 'Day ' + '9'+ 
       ' of each month' 
       WHEN 512 THEN 'Day ' + '10' + ' of each month' WHEN 1024 THEN 'Day ' + 
       '11' + 
       ' of each month' WHEN 2048 THEN 'Day ' + '12' + ' of each month' WHEN 
       4096 THEN 
       'Day ' + '13' + ' of each month' WHEN 8192 THEN 'Day ' + '14' + 
       ' of each month' 
       WHEN 16384 THEN 'Day ' + '15' + ' of each month' WHEN 32768 THEN 'Day ' + 
       '16' + 
       ' of each month' WHEN 65536 THEN 'Day ' + '17' + ' of each month' WHEN 
       131072 
       THEN 'Day ' + '18' + ' of each month' WHEN 262144 THEN 'Day ' + '19' + 
       ' of each month' WHEN 524288 THEN 'Day ' + '20' + ' of each month' WHEN 
       1048576 
       THEN 'Day ' + '21' + ' of each month'WHEN 2097152 THEN 'Day ' + '22' + 
       ' of each month' WHEN 4194304 THEN 'Day ' + '23' + ' of each month' WHEN 
       8388608 
       THEN 'Day ' + '24' + ' of each month'WHEN 16777216 THEN 'Day ' + '25' + 
       ' of each month' WHEN 33554432 THEN 'Day ' + '26' + ' of each month' WHEN 
       67108864 THEN 'Day ' + '27' + ' of each month'WHEN 134217728 THEN 'Day ' 
       + '28' 
       + ' of each month' WHEN 268435456 THEN 'Day ' + '29' + ' of each month' 
       WHEN 
       536870912 THEN 'Day ' + '30' +' of each month' WHEN 1073741824 THEN 
       'Day ' + 
       '31' + ' of each month' END WHEN 6 THEN 'The ' + CASE SCH.monthlyweek 
       WHEN 1 
       THEN 'first' WHEN 2 THEN 'second' WHEN 3 THEN 'third' WHEN 4 THEN 
       'fourth' WHEN 
       5 THEN 'last' ELSE 'UNKNOWN' END + ' week of each month on ' + CASE 
       SCH.daysofweek WHEN 2 THEN 'Monday' WHEN 4 THEN 'Tuesday' ELSE 'Unknown' 
       END 
       ELSE 'Unknown' 
       END + ' at ' 
       + Ltrim(RIGHT(CONVERT(VARCHAR, SCH.startdate, 100), 7)) AS 
       'ScheduleDetails',
       SCH.recurrencetype,
       sub.SubscriptionID as SubscriptionID, 
       CAT.itemid										as [Catalogue_ID],		
       REP_SCH.scheduleid							    AS [SQLJobID]
             
FROM   dbo.catalog AS cat 
       INNER JOIN dbo.subscriptions AS sub 
               ON CAT.itemid = sub.report_oid 
       INNER JOIN dbo.reportschedule AS REP_SCH
               ON CAT.itemid = REP_SCH.reportid 
                  AND sub.subscriptionid = REP_SCH.subscriptionid 
       INNER JOIN msdb.dbo.sysjobs AS job 
               ON Cast(REP_SCH.scheduleid AS VARCHAR(36)) = job.[name] 
       INNER JOIN msdb.dbo.sysjobschedules AS sjsch 
               ON job.job_id =  sjsch.job_id 
       INNER JOIN dbo.users U 
               ON U.userid = sub.ownerid 
       INNER JOIN dbo.schedule AS SCH 
               ON REP_SCH.scheduleid = SCH.scheduleid 
       
Where 1=1
ORDER  BY LastRunTime desc, 
          rptname 
          
         
 
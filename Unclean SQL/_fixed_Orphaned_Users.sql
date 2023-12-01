DECLARE @Username VARCHAR(100),
        @cmd      VARCHAR(100)

DECLARE userlogin_cursor CURSOR FAST_FORWARD FOR
  SELECT username = name
  FROM   sysusers
  WHERE  issqluser = 1
     AND (sid IS NOT NULL
          AND sid <> 0x01)
     AND Suser_sname(sid) IS NULL
	 AND name <>'guest'
  ORDER  BY name
  FOR READ ONLY

OPEN userlogin_cursor
FETCH NEXT FROM userlogin_cursor INTO @Username

WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @cmd = 'use msdb; EXEC sp_change_users_login ''Auto_Fix'', '''+@Username+''''
      PRINT @cmd
      FETCH NEXT FROM userlogin_cursor INTO @Username
  END

CLOSE userlogin_cursor
DEALLOCATE userlogin_cursor 
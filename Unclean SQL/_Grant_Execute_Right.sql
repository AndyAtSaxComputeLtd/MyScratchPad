/* CREATE A NEW ROLE */
CREATE ROLE db_executor

/* GRANT EXECUTE TO THE ROLE */
GRANT EXECUTE TO db_executor

USE [Services_SEPA]
GO
ALTER ROLE [db_executor] ADD MEMBER [alexandray]
GO

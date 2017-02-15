SELECT name, physical_name AS CurrentLocation
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');

USE master;
GO
ALTER DATABASE tempdb 
MODIFY FILE (NAME = tempdev, FILENAME = 'C:\mdf\tempdb.mdf');
GO
ALTER DATABASE tempdb 
MODIFY FILE (NAME = templog, FILENAME = 'D:\ldf\templog.ldf');
GO


SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID('msdb');
GO

USE master;
GO
ALTER DATABASE msdb 
MODIFY FILE (NAME = MSDBData, FILENAME = 'D:\mdf\MSDBData.mdf');
GO
ALTER DATABASE msdb 
MODIFY FILE (NAME = MSDBLog, FILENAME = 'D:\ldf\MSDBLog.ldf');
GO

USE master;
GO
ALTER DATABASE model 
MODIFY FILE (NAME = modeldev, FILENAME = 'D:\mdf\model.mdf');
GO
ALTER DATABASE model 
MODIFY FILE (NAME = modellog, FILENAME = 'D:\ldf\modellog.ldf');
GO
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\ffc_PushNewsClubs.vbs'
EXEC xp_cmdshell @param, no_output

EXEC usp_push 'b672da841b89d65eee03ebbceaba48f5c1ba8e54b298db3b3f1695865858ff54', 'test from sql'
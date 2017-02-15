
DECLARE @club_id int, @division int, @series int, @title varchar(250)

SET @club_id = 15;
SET @division = 16;
SET @series = 345;

SET @title = 'League 1st division ' + CAST(@division AS VARCHAR) + ' series ' + CAST(@series AS VARCHAR);
INSERT INTO dbo.trophy VALUES (@club_id, 4, @title, GETDATE());
--INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), @club_id, 4, @title, GETDATE());
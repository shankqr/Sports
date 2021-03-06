USE [football]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trplayer_detete]
   ON  [dbo].[player]
   AFTER DELETE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;

DECLARE @player_id int, @player_name varchar(100), @player_value int, 
@club_id int, @club_name varchar(100), @club_division int, @club_series int

SELECT @player_id = player_id FROM deleted;
SELECT @player_name = player_name FROM deleted;
SELECT @player_value = player_value FROM deleted;
SELECT @club_id = club_id FROM deleted;
SET @club_name = (SELECT club_name FROM club WHERE club_id=@club_id);
SET @club_division = (SELECT division FROM club WHERE club_id=@club_id);
SET @club_series = (SELECT series FROM club WHERE club_id=@club_id);

INSERT INTO dbo.news VALUES (getdate(), 1, 1, @player_name+' has reached the age of 40 and retired from playing', 'All Players will retire when they reach 40. Players age will increase by 1 for every league season.', '', 0, @club_id, 0, 0, 0)

END

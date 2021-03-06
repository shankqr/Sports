USE [baseball]
GO
/****** Object:  Trigger [dbo].[trmatch_played]    Script Date: 2/7/2013 4:43:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trmatch_played]
   ON  [dbo].[match]
   AFTER UPDATE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;
IF UPDATE(match_played)
BEGIN
DECLARE @match_id int, @match_played int, @match_type_id int, @club_home int, @club_away int, @division int, @series int, @challenge_win int, @challenge_lose int
DECLARE @spectators int, @stadium_overflow int, @stadium_capacity int, @average_ticket int, @ticket_sales int
SELECT @match_id = match_id FROM inserted;
SELECT @match_played = match_played FROM inserted;
SET @match_type_id = ISNULL((SELECT match_type_id FROM inserted), 0);
SET @club_home = ISNULL((SELECT club_home FROM inserted), 0);
SET @club_away = ISNULL((SELECT club_away FROM inserted), 0);
SET @division = ISNULL((SELECT division FROM inserted), 0);
SET @series = ISNULL((SELECT series FROM inserted), 0);
SET @challenge_win = ISNULL((SELECT challenge_win FROM inserted), 0);
SET @challenge_lose = ISNULL((SELECT challenge_lose FROM inserted), 0);

IF (@match_played = 1)
BEGIN
DECLARE @away_uid varchar(100), @home_uid varchar(100), @home_lastlogin datetime, @home_totalplayers int, @away_lastlogin datetime, @away_totalplayers int

SET @home_uid = (SELECT [uid] FROM club WHERE club_id=@club_home);
SET @home_lastlogin = (SELECT last_login FROM club WHERE club_id=@club_home);
SET @home_totalplayers = (SELECT COUNT(*) FROM player WHERE club_id=@club_home);

SET @away_uid = (SELECT [uid] FROM club WHERE club_id=@club_away);
SET @away_lastlogin = (SELECT last_login FROM club WHERE club_id=@club_away);
SET @away_totalplayers = (SELECT COUNT(*) FROM player WHERE club_id=@club_away);

IF (@home_uid = '0' AND @away_uid = '0')
BEGIN
DECLARE @hscore int, @ascore int, @cwinner int, @closer int

SET @hscore = dbo.fx_generateRandomNumber(newID(), 0, 3);
SET @ascore = dbo.fx_generateRandomNumber(newID(), 0, 3);

IF (@hscore > @ascore)
BEGIN
	SET @cwinner = @club_home;
	SET @closer = @club_away;
END

IF (@ascore > @hscore)
BEGIN
	SET @cwinner = @club_away;
	SET @closer = @club_home;
END

IF (@ascore = @hscore)
BEGIN
	SET @hscore = @hscore + 1;
	SET @cwinner = @club_home;
	SET @closer = @club_away;
END

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

END

ELSE IF (@home_uid != '0' AND @away_uid = '0')
BEGIN

SET @ascore = dbo.fx_generateRandomNumber(newID(), 0, 2);
SET @hscore = @ascore + dbo.fx_generateRandomNumber(newID(), 1, 3);

SET @cwinner = @club_home;
SET @closer = @club_away;

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

-- Calculate the ticket_sales for this match
SET @spectators =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)), 0);
SET @stadium_overflow =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)-(SELECT stadium_capacity FROM club WHERE club_id=@club_home)), 0);
SET @stadium_capacity = ISNULL((SELECT stadium_capacity FROM club WHERE club_id=@club_home), 500);
SET @average_ticket = ISNULL((SELECT average_ticket FROM club WHERE club_id=@club_home), 1);

IF(@stadium_overflow > 0)
	SET @ticket_sales = @average_ticket * @stadium_capacity;
ELSE
	SET @ticket_sales = @average_ticket * @spectators;

SET @ticket_sales = @ticket_sales / 3;

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales*2,
revenue_total = revenue_total + (@ticket_sales*2),
balance = balance + (@ticket_sales*2),
fan_members = fan_members+1, 
fan_mood = fan_mood+1, 
undefeated_counter = undefeated_counter+1,
teamspirit = teamspirit+1, 
confidence = confidence+1
WHERE dbo.club.club_id=@club_home

END
ELSE IF (@home_uid = '0' AND @away_uid != '0')
BEGIN
SET @hscore = dbo.fx_generateRandomNumber(newID(), 0, 2);
SET @ascore = @hscore + dbo.fx_generateRandomNumber(newID(), 1, 3);

SET @cwinner = @club_away;
SET @closer = @club_home;

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

SET @ticket_sales = dbo.fx_generateRandomNumber(newID(), 100, 500);

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales,
revenue_total = revenue_total + @ticket_sales,
balance = balance + @ticket_sales,
fan_members = fan_members+1, 
fan_mood = fan_mood+1, 
undefeated_counter = undefeated_counter+1,
teamspirit = teamspirit+1, 
confidence = confidence+1
WHERE dbo.club.club_id=@club_away
END
ELSE IF ((@home_totalplayers > 8 AND @away_totalplayers < 7) OR (@home_lastlogin > GETDATE()-60 AND @away_lastlogin < GETDATE()-60))
BEGIN

SET @ascore = dbo.fx_generateRandomNumber(newID(), 0, 1);
SET @hscore = @ascore + dbo.fx_generateRandomNumber(newID(), 1, 4);

SET @cwinner = @club_home;
SET @closer = @club_away;

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

IF(@match_type_id = 1)
BEGIN
-- Calculate the ticket_sales for this match
SET @spectators =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)), 0);
SET @stadium_overflow =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)-(SELECT stadium_capacity FROM club WHERE club_id=@club_home)), 0);
SET @stadium_capacity = ISNULL((SELECT stadium_capacity FROM club WHERE club_id=@club_home), 500);
SET @average_ticket = ISNULL((SELECT average_ticket FROM club WHERE club_id=@club_home), 1);

IF(@stadium_overflow > 0)
	SET @ticket_sales = @average_ticket * @stadium_capacity;
ELSE
	SET @ticket_sales = @average_ticket * @spectators;

SET @ticket_sales = @ticket_sales / 3;

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales*2,
revenue_total = revenue_total + (@ticket_sales*2),
balance = balance + (@ticket_sales*2),
fan_members = fan_members+1, 
fan_mood = fan_mood+1, 
undefeated_counter = undefeated_counter+1,
teamspirit = teamspirit+1, 
confidence = confidence+1
WHERE dbo.club.club_id=@club_home

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales,
revenue_total = revenue_total + @ticket_sales,
balance = balance + @ticket_sales 
WHERE dbo.club.club_id=@club_away
END
END
ELSE IF ((@home_totalplayers < 7 AND @away_totalplayers > 8) OR (@home_lastlogin < GETDATE()-60 AND @away_lastlogin > GETDATE()-60))
BEGIN
SET @hscore = dbo.fx_generateRandomNumber(newID(), 0, 1);
SET @ascore = @hscore + dbo.fx_generateRandomNumber(newID(), 1, 4);

SET @cwinner = @club_away;
SET @closer = @club_home;

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

IF(@match_type_id = 1)
BEGIN
-- Calculate the ticket_sales for this match
SET @spectators =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)), 0);
SET @stadium_overflow =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)-(SELECT stadium_capacity FROM club WHERE club_id=@club_home)), 0);
SET @stadium_capacity = ISNULL((SELECT stadium_capacity FROM club WHERE club_id=@club_home), 500);
SET @average_ticket = ISNULL((SELECT average_ticket FROM club WHERE club_id=@club_home), 1);

IF(@stadium_overflow > 0)
	SET @ticket_sales = @average_ticket * @stadium_capacity;
ELSE
	SET @ticket_sales = @average_ticket * @spectators;

SET @ticket_sales = @ticket_sales / 3;

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales,
revenue_total = revenue_total + @ticket_sales,
balance = balance + @ticket_sales,
fan_members = fan_members+1, 
fan_mood = fan_mood+1, 
undefeated_counter = undefeated_counter+1,
teamspirit = teamspirit+1, 
confidence = confidence+1
WHERE dbo.club.club_id=@club_away

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales*2,
revenue_total = revenue_total + (@ticket_sales*2),
balance = balance + (@ticket_sales*2) 
WHERE dbo.club.club_id=@club_home
END
END

ELSE
BEGIN
-- Calculate the ticket_sales for this match
SET @spectators =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)), 0);
SET @stadium_overflow =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)-(SELECT stadium_capacity FROM club WHERE club_id=@club_home)), 0);
SET @stadium_capacity = ISNULL((SELECT stadium_capacity FROM club WHERE club_id=@club_home), 500);
SET @average_ticket = ISNULL((SELECT average_ticket FROM club WHERE club_id=@club_home), 1);

IF(@stadium_overflow > 0)
	SET @ticket_sales = @average_ticket * @stadium_capacity;
ELSE
	SET @ticket_sales = @average_ticket * @spectators;
	
-- Friendly is 1/10 the sales of league or cup
IF(@match_type_id = 3)
BEGIN
	SET @ticket_sales = @ticket_sales / 10;
	
	--ACHIEVEMENT 15
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_away AND achievement_type_id=15)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@club_away, 15, 0)
	END
END

-- Divide income to two clubs
SET @ticket_sales = @ticket_sales / 3;

-- Declare players
DECLARE
@h_gk int, @h_rb int, @h_lb int, @h_cd1 int, @h_cd2 int, @h_im1 int, @h_fw1 int, @h_fw2 int, @h_fw3 int, 
@a_gk int, @a_rb int, @a_lb int, @a_cd1 int, @a_cd2 int, @a_im1 int, @a_fw1 int, @a_fw2 int, @a_fw3 int

SET @h_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_home), 0); -- Catcher (C), Keeper
SET @h_rb = ISNULL((SELECT rb FROM club WHERE club_id=@club_home), 0); -- Right Fielder (RF), Passing, Attack
SET @h_lb = ISNULL((SELECT lb FROM club WHERE club_id=@club_home), 0); -- Left Fielder (LF), Passing, Attack
SET @h_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_home), 0); -- Center Fielder (CF), Defend, Passing
SET @h_cd2 = ISNULL((SELECT cd2 FROM club WHERE club_id=@club_home), 0); -- Short Stop (SS) - Passing, Defend
SET @h_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_home), 0); -- Pitcher (P) - Playmaking
SET @h_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_home), 0); -- First Baseman (1B) - Attack
SET @h_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_home), 0); -- Second Baseman (2B) - Defend
SET @h_fw3 = ISNULL((SELECT fw3 FROM club WHERE club_id=@club_home), 0); -- Third Baseman (3B) - Passing

SET @h_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@h_gk AND club_id=@club_home), 0);
SET @h_rb = ISNULL((SELECT player_id FROM player WHERE player_id=@h_rb AND club_id=@club_home), 0);
SET @h_lb = ISNULL((SELECT player_id FROM player WHERE player_id=@h_lb AND club_id=@club_home), 0);
SET @h_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd1 AND club_id=@club_home), 0);
SET @h_cd2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd2 AND club_id=@club_home), 0);
SET @h_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im1 AND club_id=@club_home), 0);
SET @h_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw1 AND club_id=@club_home), 0);
SET @h_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw2 AND club_id=@club_home), 0);
SET @h_fw3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw3 AND club_id=@club_home), 0);

SET @a_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_away), 0);
SET @a_rb = ISNULL((SELECT rb FROM club WHERE club_id=@club_away), 0);
SET @a_lb = ISNULL((SELECT lb FROM club WHERE club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_away), 0);
SET @a_cd2 = ISNULL((SELECT cd2 FROM club WHERE club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_away), 0);
SET @a_fw3 = ISNULL((SELECT fw3 FROM club WHERE club_id=@club_away), 0);

SET @a_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@a_gk AND club_id=@club_away), 0);
SET @a_rb = ISNULL((SELECT player_id FROM player WHERE player_id=@a_rb AND club_id=@club_away), 0);
SET @a_lb = ISNULL((SELECT player_id FROM player WHERE player_id=@a_lb AND club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd1 AND club_id=@club_away), 0);
SET @a_cd2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd2 AND club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im1 AND club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw1 AND club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw2 AND club_id=@club_away), 0);
SET @a_fw3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw3 AND club_id=@club_away), 0);

-- Process score result
DECLARE
@home_tactic int, @away_tactic int, 
@home_score int, @away_score int, 
@home_score_diff int, @away_score_diff int,
@home_possession int, @away_possession int, 
@club_winner int, @club_loser int, 

@home_gk float, 
@home_rb float, 
@home_lb float, 
@home_cd1 float, 
@home_cd2 float, 
@home_im1 float, 
@home_fw1 float, 
@home_fw2 float, 
@home_fw3 float, 
@home_total_d float, @home_total_a float,
@home_keeper float, @home_defend float, @home_playmaking float, 
@home_passing float, @home_attack float, @home_fitness float,

@away_gk float, 
@away_rb float, 
@away_lb float, 
@away_cd1 float, 
@away_cd2 float, 
@away_im1 float, 
@away_fw1 float, 
@away_fw2 float, 
@away_fw3 float, 
@away_total_d float, @away_total_a float,
@away_keeper float, @away_defend float, @away_playmaking float, 
@away_passing float, @away_attack float, @away_fitness float

-- Home points
SET @home_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_home), 0);

-- Catcher (C)
SET @home_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @h_gk), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_gk), 0);
SET @home_gk = @home_keeper *(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_gk

-- Right Fielder (RF)
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_rb), 0);
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_rb), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_rb), 0);
SET @home_rb = ((@home_passing*0.7)+(@home_attack*0.3))*(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_rb

-- Left Fielder (LF)
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_lb), 0);
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_lb), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_lb), 0);
SET @home_lb = ((@home_passing*0.7)+(@home_attack*0.3))*(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_lb

-- Center Fielder (CF)
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd1), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd1), 0);
SET @home_cd1 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_cd1

-- Short Stop (SS)
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd2), 0);
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd2), 0);
SET @home_cd2 = ((@home_passing*0.7)+(@home_defend*0.3))*(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_cd2

-- Pitcher (P)
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im1), 0);
SET @home_im1 = @home_playmaking *(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_im1

-- First Baseman (1B)
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw1), 0);
SET @home_fw1 = @home_attack *(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_fw1

-- Second Baseman (2B)
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_fw2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw2), 0);
SET @home_fw2 = @home_defend *(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_fw2

-- Third Baseman (3B)
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_fw3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw3), 0);
SET @home_fw3 = @home_passing *(@home_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@h_fw3

SET @home_total_d = @home_gk + @home_rb + @home_lb + @home_cd1 + @home_im1;
SET @home_total_a = @home_cd2 + @home_fw1 + @home_fw2 + @home_fw3 + @home_tactic;

-- Away points
SET @away_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_away), 0);

-- Catcher (C)
SET @away_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @a_gk), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_gk), 0);
SET @away_gk = @away_keeper *(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_gk

-- Right Fielder (RF)
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_rb), 0);
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_rb), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_rb), 0);
SET @away_rb = ((@away_passing*0.7)+(@away_attack*0.3))*(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_rb

-- Left Fielder (LF)
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_lb), 0);
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_lb), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_lb), 0);
SET @away_lb = ((@away_passing*0.7)+(@away_attack*0.3))*(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_lb

-- Center Fielder (CF)
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd1), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd1), 0);
SET @away_cd1 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_cd1

-- Short Stop (SS)
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd2), 0);
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd2), 0);
SET @away_cd2 = ((@away_passing*0.7)+(@away_defend*0.3))*(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_cd2

-- Pitcher (P)
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im1), 0);
SET @away_im1 = @away_playmaking *(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_im1

-- First Baseman (1B)
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw1), 0);
SET @away_fw1 = @away_attack *(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_fw1

-- Second Baseman (2B)
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_fw2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw2), 0);
SET @away_fw2 = @away_defend *(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_fw2

-- Third Baseman (3B)
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_fw3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw3), 0);
SET @away_fw3 = @away_passing *(@away_fitness/200);
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 2) WHERE player_id=@a_fw3

SET @away_total_d = @away_gk + @away_rb + @away_lb + @away_cd1 + @away_im1;
SET @away_total_a = @away_cd2 + @away_fw1 + @away_fw2 + @away_fw3 + @away_tactic;


-- Points summary
DECLARE @home_teamspirit int, @away_teamspirit int, @home_confidence int, @away_confidence int
SET @home_teamspirit = ISNULL((SELECT teamspirit FROM club WHERE club_id=@club_home), 100);
SET @home_confidence = ISNULL((SELECT confidence FROM club WHERE club_id=@club_home), 100);
SET @away_teamspirit = ISNULL((SELECT teamspirit FROM club WHERE club_id=@club_away), 100);
SET @away_confidence = ISNULL((SELECT confidence FROM club WHERE club_id=@club_away), 100);
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

IF (@away_total_d < 1)
BEGIN
	SET @away_total_d = 1;
END

IF (@home_total_d < 1)
BEGIN
	SET @home_total_d = 1;
END

SET @home_score = (@home_total_a / @away_total_d);
SET @away_score = (@away_total_a / @home_total_d);

IF (@home_score < 0)
BEGIN
	SET @home_score = 0;
END

IF (@away_score < 0)
BEGIN
	SET @away_score = 0;
END

IF ((@home_teamspirit+@home_confidence)>(@away_teamspirit+@away_confidence))
BEGIN
	SET @home_score = @home_score+1;
END

IF ((@away_teamspirit+@away_confidence)>(@home_teamspirit+@home_confidence))
BEGIN
	SET @away_score = @away_score+1;
END

SET @home_score = @home_score + dbo.fx_generateRandomNumber(newID(), 0, 3);
SET @away_score = @away_score + dbo.fx_generateRandomNumber(newID(), 0, 3);

IF (@home_uid = '1')
BEGIN
	SET @home_score = @home_score + dbo.fx_generateRandomNumber(newID(), 2, 4);
END

IF (@away_uid = '1')
BEGIN
	SET @away_score = @away_score + dbo.fx_generateRandomNumber(newID(), 2, 4);
END

-- Declare club level
DECLARE
@h_level int, @a_level int, @h_xp int, @a_xp int, @h_leveldif int, @a_leveldif int

SET @h_xp = ISNULL((SELECT xp FROM club WHERE club_id=@club_home), 0);
SET @a_xp = ISNULL((SELECT xp FROM club WHERE club_id=@club_away), 0);
SET @h_level = sqrt(@h_xp/10) + 1;
SET @a_level = sqrt(@a_xp/10) + 1;
SET @h_leveldif = 0;
SET @a_leveldif = 0;

IF (@h_level > @a_level)
BEGIN
	SET @home_score = @home_score+1;
	SET @a_leveldif = @h_level - @a_level;
END

IF (@a_level > @h_level)
BEGIN
	SET @away_score = @away_score+1;
	SET @h_leveldif = @a_level - @h_level;
END
---------------------------
	
IF (@home_score > 5)
BEGIN
	SET @home_score = dbo.fx_generateRandomNumber(newID(), 5, 7);
END

IF (@away_score > 5)
BEGIN
	SET @away_score = dbo.fx_generateRandomNumber(newID(), 5, 7);
END

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Advantage to Home team if it is a Draw
IF (@home_score = @away_score)
BEGIN
	SET @home_score = @home_score + 1;
END

SET @home_score_diff = @home_score - @away_score;
SET @away_score_diff = @away_score - @home_score;
SET @home_possession = @home_total_a;
SET @away_possession = @away_total_a;

IF (@home_score > @away_score)
BEGIN
SET @club_winner = @club_home;
SET @club_loser = @club_away;
END
ELSE
BEGIN
SET @club_winner = @club_away;
SET @club_loser = @club_home;
END

UPDATE dbo.match
SET 
weather_id = dbo.fx_generateRandomNumber(newID(), 1, 3),
spectators=@spectators,
stadium_overflow=@stadium_overflow,
home_formation=(SELECT formation FROM club WHERE club_id=match.club_home),
away_formation=(SELECT formation FROM club WHERE club_id=match.club_away),
home_tactic=@home_tactic,
home_teamspirit=@home_teamspirit,
home_confidence=@home_confidence,
away_tactic=@away_tactic,
away_teamspirit=@away_teamspirit,
away_confidence=@away_confidence,
match_datetime=GETDATE(),
ticket_sales = @ticket_sales,
home_score = @home_score, 
away_score = @away_score, 
home_possession = @home_possession, 
away_possession = @away_possession, 
home_score_different = @home_score_diff, 
away_score_different = @away_score_diff,
club_winner = @club_winner, 
club_loser = @club_loser
WHERE match_id=@match_id

-- Challenge money update if friendly match
IF(@match_type_id = 3)
BEGIN
DECLARE @bal int
IF (@home_score > @away_score)
BEGIN
SET @bal = ISNULL((SELECT balance FROM club WHERE club_id=@club_away), 0);
IF (@bal>0)
BEGIN
-- Update finance for club home
UPDATE dbo.club
SET 
fan_members = fan_members + 1,
xp = xp + @h_leveldif,
revenue_others = @challenge_lose,
revenue_total = revenue_total + @challenge_lose,
balance = balance + @challenge_lose
WHERE dbo.club.club_id=@club_home
-- Update finance for club away
UPDATE dbo.club
SET 
xp = xp + @a_leveldif,
expenses_others = @challenge_lose,
expenses_total = expenses_total + @challenge_lose,
balance = balance - @challenge_lose
WHERE dbo.club.club_id=@club_away
END
END

IF (@away_score > @home_score)
BEGIN
SET @bal = ISNULL((SELECT balance FROM club WHERE club_id=@club_home), 0);
IF (@bal>0)
BEGIN
-- Update finance for club away
UPDATE dbo.club
SET 
fan_members = fan_members + 1,
xp = xp + @a_leveldif,
revenue_others = @challenge_win,
revenue_total = revenue_total + @challenge_win,
balance = balance + @challenge_win
WHERE dbo.club.club_id=@club_away
-- Update finance for club home
UPDATE dbo.club
SET 
xp = xp + @h_leveldif,
expenses_others = @challenge_win,
expenses_total = expenses_total + @challenge_win,
balance = balance - @challenge_win
WHERE dbo.club.club_id=@club_home
END
END
END

IF(@match_type_id != 3) -- Not a frienldy match
BEGIN
-- Club Home updates
DECLARE @fan_members int, @fan_mood int, @fan_expectation int, @undefeated_counter int,
@undefeated_counter_away int,@managers int, @physiotherapists int

SELECT @fan_members = fan_members FROM club WHERE club_id=@club_home;
SELECT @fan_mood = fan_mood FROM club WHERE club_id=@club_home;
SELECT @fan_expectation = fan_expectation FROM club WHERE club_id=@club_home;
SELECT @undefeated_counter = undefeated_counter FROM club WHERE club_id=@club_home;

IF (@home_score_diff > 0)
BEGIN
SET @fan_expectation = 0;
SET @fan_members = @fan_members + @home_score_diff*25;
SET @home_confidence = @home_confidence + 10;
SET @undefeated_counter = @undefeated_counter + 1;
IF(@undefeated_counter IS NOT NULL AND @undefeated_counter > 0)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Your team is now undefeated for '+cast(@undefeated_counter as varchar)+' competitive games', 'Fans are excited with your performance.', '', 0, @club_home, 0, 0, 0)
END
END

IF (@home_score_diff = 0)
BEGIN
SET @fan_expectation = 1;
SET @fan_members = @fan_members + 10;
END

IF (@home_score_diff < 0)
BEGIN
SET @fan_expectation = 2;
SET @fan_members = @fan_members + @home_score_diff;
SET @home_confidence = @home_confidence - 10;
SET @undefeated_counter = 0;
END

SET @fan_mood = @fan_mood + @home_score_diff;
SET @home_teamspirit = @home_teamspirit + @home_score_diff;
	
IF (@fan_mood < 10)
	SET @fan_mood = 10;
	
IF (@fan_mood > 200)
	SET @fan_mood = 200;
	
IF (@home_confidence < 20)
	SET @home_confidence = 20;
	
IF (@home_teamspirit < 20)
	SET @home_teamspirit = 20;
	
IF (@home_confidence > 200)
	SET @home_confidence = 200;
	
IF (@home_teamspirit > 200)
	SET @home_teamspirit = 200;

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales*2,
revenue_total = revenue_total + (@ticket_sales*2),
balance = balance + (@ticket_sales*2),
fan_members = @fan_members, 
fan_mood = @fan_mood, 
fan_expectation = @fan_expectation, 
undefeated_counter = @undefeated_counter,
teamspirit = @home_teamspirit, 
confidence = @home_confidence
WHERE dbo.club.club_id=@club_home

-- Club Away updates
SELECT @fan_members = fan_members FROM club WHERE club_id=@club_away;
SELECT @fan_mood = fan_mood FROM club WHERE club_id=@club_away;
SELECT @fan_expectation = fan_expectation FROM club WHERE club_id=@club_away;
SELECT @undefeated_counter_away = undefeated_counter FROM club WHERE club_id=@club_away;

IF (@away_score_diff > 0)
BEGIN
SET @fan_expectation = 0;
SET @fan_members = @fan_members + @away_score_diff*25;
SET @away_confidence = @away_confidence + 10;
SET @undefeated_counter_away = @undefeated_counter_away + 1;
IF(@undefeated_counter_away IS NOT NULL AND @undefeated_counter_away > 0)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Your team is now undefeated for '+cast(@undefeated_counter_away as varchar)+' competitive games', 'Fans are excited with your performance.', '', 0, @club_away, 0, 0, 0)
END
END

IF (@away_score_diff = 0)
BEGIN
SET @fan_expectation = 1;
SET @fan_members = @fan_members + 10;
END

IF (@away_score_diff < 0)
BEGIN
SET @fan_expectation = 2;
SET @fan_members = @fan_members + @away_score_diff;
SET @away_confidence = @away_confidence - 10;
SET @undefeated_counter_away = 0;
END

SET @fan_mood = @fan_mood + @away_score_diff;
SET @away_teamspirit = @away_teamspirit + @away_score_diff;
	
IF (@fan_mood < 10)
	SET @fan_mood = 10;
	
IF (@fan_mood > 200)
	SET @fan_mood = 200;
	
IF (@away_confidence < 20)
	SET @away_confidence = 20;
	
IF (@away_teamspirit < 20)
	SET @away_teamspirit = 20;
	
IF (@away_confidence > 200)
	SET @away_confidence = 200;
	
IF (@away_teamspirit > 200)
	SET @away_teamspirit = 200;

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales,
revenue_total = revenue_total + @ticket_sales,
balance = balance + @ticket_sales,
fan_members = @fan_members, 
fan_mood = @fan_mood, 
fan_expectation = @fan_expectation, 
undefeated_counter = @undefeated_counter_away,
teamspirit = @away_teamspirit, 
confidence = @away_confidence
WHERE dbo.club.club_id=@club_away

END -- If not equals to friendly match

-- News results
DECLARE @news_marque varchar(1000), @news varchar(2000), @news_money varchar(1100), @news_result varchar(1000), 
@headline varchar(500), @home_name varchar(100), @away_name varchar(100)

SELECT @home_name = club_name FROM club WHERE club_id=@club_home;
SELECT @away_name = club_name FROM club WHERE club_id=@club_away;

SET @headline = @home_name+' '+CAST(@home_score AS varchar(12)) +'-'+ CAST(@away_score AS varchar(12))+' '+@away_name;
SET @news_money = '';
IF @stadium_overflow > 0
BEGIN
	SET @news_money = 'There were only '+CAST(@stadium_capacity AS varchar(12))
	+' seats available in '+@home_name+', '
	+CAST(@stadium_overflow AS varchar(12))+' angry fans did not get to see the match live. ';
END

SET @news_marque = '';
IF(@match_type_id != 3)
BEGIN
SET @news_money = @news_money+'Average ticket price was $'+CAST(@average_ticket AS varchar(12));
SET @news_money = @news_money+', total sales were divided two third(2/3) to home club and one third(1/3) to away club. ';--, each received $'+CAST(@ticket_sales AS varchar(12))+' and $'+CAST(@ticket_sales AS varchar(12))+'. ';
SET @news_marque = '. Ticket sales amounted to $'+CAST((@ticket_sales*3) AS varchar(12));
END
ELSE
BEGIN
IF(@h_leveldif > 0)
BEGIN
	SET @news_money = @news_money+@home_name+' gained '+CAST(@h_leveldif AS varchar(12))+'XP for playing with a higher Level club with a difference of '+CAST(@h_leveldif AS varchar(12))+' Levels between them. ';
END
IF(@a_leveldif > 0)
BEGIN
	SET @news_money = @news_money+@away_name+' gained '+CAST(@a_leveldif AS varchar(12))+'XP for playing with a higher Level club with a difference of '+CAST(@a_leveldif AS varchar(12))+' Levels between them. ';
END
END

SET @news_result = 'The game ends with ';

IF (@home_score_diff > 0)
BEGIN
	SET @news_result = @news_result + @home_name + ' beating ' + @away_name + ' ' + CAST(@home_score AS varchar(12))+' - '+CAST(@away_score AS varchar(12));
	IF(@match_type_id = 3)
	BEGIN
	SET @news_marque = '. ' + @home_name + ' gained 1 Fans and won the bet for $'+CAST(@challenge_lose AS varchar(12));
	END
END

IF (@home_score_diff < 0)
BEGIN
	SET @news_result = @news_result + @away_name + ' beating ' + @home_name + ' ' + CAST(@away_score AS varchar(12))+' - '+CAST(@home_score AS varchar(12));
	IF(@match_type_id = 3)
	BEGIN
	SET @news_marque = '. ' + @away_name + ' gained 1 Fans and won the bet for $'+CAST(@challenge_win AS varchar(12));
	END
END

IF (@home_score_diff = 0)
BEGIN
	SET @news_result = @news_result + 'a draw ' + CAST(@away_score AS varchar(12)) + ' - ' + CAST(@home_score AS varchar(12));
END

SET @news = @news_money+@news_result;

IF (@match_type_id = 1) -- League Match
BEGIN
	SET @headline='(LEAGUE) '+@headline+@news_marque;
END

IF (@match_type_id = 2) -- Cup Match
BEGIN
	SET @headline='(CUP) '+@headline+@news_marque;
END

IF (@match_type_id = 3) -- Friendly Match
BEGIN
	SET @headline='(FRIENDLY) '+@headline+@news_marque;
END

IF (@headline is not null)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_home, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_away, 0, 0, 0)
END

-- Match Highlights
DECLARE @match_minute int, @highlight_type_id int, @highlight varchar(1000), 
@player_id int, @player_name varchar(50), @pos_random int, @midfield_random int, @wing_random int, @counter int
-- Clear Match Highlights Table first
DELETE FROM dbo.match_highlight WHERE match_id=@match_id
-- Introduction
SET @highlight_type_id = 0;
SET @match_minute = 0;
SET @player_id = 0;
SET @highlight = 'A crowd of '+CAST(@spectators AS varchar(12))+' lines up at '+@home_name+' stadium. ';
SET @highlight = @highlight+@news_money;
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)

-- Results
SET @highlight_type_id = 0;
SET @match_minute = 0;
SET @player_id = 0;
SET @highlight = 'This was a great game played by both sides. ';
SET @highlight = @highlight+@news_result;
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)

END
END
END
END

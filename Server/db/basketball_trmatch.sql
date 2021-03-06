USE [basketball]
GO
/****** Object:  Trigger [dbo].[trmatch_played]    Script Date: 2/7/2013 4:42:43 AM ******/
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

SET @hscore = dbo.fx_generateRandomNumber(newID(), 45, 75);
SET @ascore = dbo.fx_generateRandomNumber(newID(), 50, 70);

IF (@ascore = @hscore)
BEGIN
	SET @hscore = @hscore + dbo.fx_generateRandomNumber(newID(), 2, 6);
END

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

SET @ascore = dbo.fx_generateRandomNumber(newID(), 10, 20);
SET @hscore = @ascore + dbo.fx_generateRandomNumber(newID(), 35, 65);

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
SET @hscore = dbo.fx_generateRandomNumber(newID(), 10, 20);
SET @ascore = @hscore + dbo.fx_generateRandomNumber(newID(), 35, 65);

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
ELSE IF ((@home_totalplayers > 4 AND @away_totalplayers < 4) OR (@home_lastlogin > GETDATE()-60 AND @away_lastlogin < GETDATE()-60))
BEGIN

SET @ascore = dbo.fx_generateRandomNumber(newID(), 0, 10);
SET @hscore = @ascore + dbo.fx_generateRandomNumber(newID(), 35, 65);

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
ELSE IF ((@home_totalplayers < 4 AND @away_totalplayers > 4) OR (@home_lastlogin < GETDATE()-60 AND @away_lastlogin > GETDATE()-60))
BEGIN
SET @hscore = dbo.fx_generateRandomNumber(newID(), 0, 10);
SET @ascore = @hscore + dbo.fx_generateRandomNumber(newID(), 35, 65);

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
@h_gk int, @h_rb int, @h_lb int, @h_rw int, @h_lw int, 
@h_cd1 int, @h_cd2 int, @h_cd3 int, @h_im1 int, @h_im2 int, @h_im3 int, @h_fw1 int, @h_fw2 int, @h_fw3 int, 
@a_gk int, @a_rb int, @a_lb int, @a_rw int, @a_lw int, 
@a_cd1 int, @a_cd2 int, @a_cd3 int, @a_im1 int, @a_im2 int, @a_im3 int, @a_fw1 int, @a_fw2 int, @a_fw3 int

SET @h_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_home), 0);
SET @h_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_home), 0);
SET @h_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_home), 0);
SET @h_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_home), 0);
SET @h_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_home), 0);

SET @h_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@h_gk AND club_id=@club_home), 0);
SET @h_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd1 AND club_id=@club_home), 0);
SET @h_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im1 AND club_id=@club_home), 0);
SET @h_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw1 AND club_id=@club_home), 0);
SET @h_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw2 AND club_id=@club_home), 0);

SET @a_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_away), 0);

SET @a_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@a_gk AND club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd1 AND club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im1 AND club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw1 AND club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw2 AND club_id=@club_away), 0);

-- Process score result
DECLARE
@wGK_D float, @wGK_A float, @wWB_D float, @wWB_A float, @wCD_D float, 
@wCD_A float, @wW_D float, @wW_A float, @wM_D float, @wM_A float, @wF_D float, @wF_A float,
@home_tactic int, @away_tactic int, 
@home_score int, @away_score int, 
@home_score_diff int, @away_score_diff int,
@home_possession int, @away_possession int, 
@club_winner int, @club_loser int, 

@home_gk float, @home_gk_d float, @home_gk_a float,
@home_rb float, @home_rb_d float, @home_rb_a float,
@home_lb float, @home_lb_d float, @home_lb_a float,
@home_cd1 float, @home_cd1_d float, @home_cd1_a float,
@home_cd2 float, @home_cd2_d float, @home_cd2_a float,
@home_cd3 float, @home_cd3_d float, @home_cd3_a float,
@home_im1 float, @home_im1_d float, @home_im1_a float,
@home_im2 float, @home_im2_d float, @home_im2_a float,
@home_im3 float, @home_im3_d float, @home_im3_a float,
@home_rw float, @home_rw_d float, @home_rw_a float,
@home_lw float, @home_lw_d float, @home_lw_a float,
@home_fw1 float, @home_fw1_d float, @home_fw1_a float,
@home_fw2 float, @home_fw2_d float, @home_fw2_a float,
@home_fw3 float, @home_fw3_d float, @home_fw3_a float,
@home_total_d float, @home_total_a float,

@home_keeper float, @home_defend float, @home_playmaking float, 
@home_passing float, @home_attack float, @home_fitness float,

@away_gk float, @away_gk_d float, @away_gk_a float,
@away_rb float, @away_rb_d float, @away_rb_a float,
@away_lb float, @away_lb_d float, @away_lb_a float,
@away_cd1 float, @away_cd1_d float, @away_cd1_a float,
@away_cd2 float, @away_cd2_d float, @away_cd2_a float,
@away_cd3 float, @away_cd3_d float, @away_cd3_a float,
@away_im1 float, @away_im1_d float, @away_im1_a float,
@away_im2 float, @away_im2_d float, @away_im2_a float,
@away_im3 float, @away_im3_d float, @away_im3_a float,
@away_rw float, @away_rw_d float, @away_rw_a float,
@away_lw float, @away_lw_d float, @away_lw_a float,
@away_fw1 float, @away_fw1_d float, @away_fw1_a float,
@away_fw2 float, @away_fw2_d float, @away_fw2_a float,
@away_fw3 float, @away_fw3_d float, @away_fw3_a float,
@away_total_d float, @away_total_a float,

@away_keeper float, @away_defend float, @away_playmaking float, 
@away_passing float, @away_attack float, @away_fitness float

-- Home points
SET @home_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_home), 0);

IF @home_tactic = 0 -- Normal
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 1 -- Man to Man
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.075;
SET @wM_D = 0.075;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.025;
SET @wM_A = 0.025;
SET @wF_A = 0.1;
END

IF @home_tactic = 2 -- Defending
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 3 -- Zone 2-3
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.075;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0.05;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 4 -- Zone 1-2-2
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 5 -- Zone 1-3-1
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.1;
SET @wM_A = 0.125;
SET @wF_A = 0.075;
END

IF @home_tactic = 6 -- Attacking
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.2;
SET @wM_A = 0.05;
SET @wF_A = 0.05;
END

IF @home_tactic = 7 -- Baseline 3
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0.025;
SET @wGK_A = 0;
SET @wCD_A = 0.05;
SET @wW_A = 0.075;
SET @wM_A = 0.1;
SET @wF_A = 0.075;
END

IF @home_tactic = 8 -- Bluestack
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.15;
END

IF @home_tactic = 9 -- Clock
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.15;
END

IF @home_tactic = 10 -- Five Out
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 11 -- Give & Go
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.075;
SET @wM_D = 0.075;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.025;
SET @wM_A = 0.025;
SET @wF_A = 0.1;
END

IF @home_tactic = 12 -- Isolation
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 13 -- Postup
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.075;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0.05;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 14 -- Triagle
BEGIN
SET @wGK_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

-- PG
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_gk), 0);
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_gk), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_gk), 0);
SET @home_gk = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);

-- SG
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd1), 0);
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_cd1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd1), 0);
SET @home_cd1 = ((@home_playmaking*0.7)+(@home_defend*0.3))*(@home_fitness/200);

-- CTR
SET @home_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @h_im1), 0);
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_im1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im1), 0);
SET @home_im1 = ((@home_keeper*0.7)+(@home_attack*0.3))*(@home_fitness/200);

-- PF
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw1), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_fw1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw1), 0);
SET @home_fw1 = ((@home_attack*0.7)+(@home_passing*0.3))*(@home_fitness/200);

-- SF
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_fw2), 0);
SET @home_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @h_fw2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw2), 0);
SET @home_fw2 = ((@home_playmaking*0.7)+(@home_keeper*0.3))*(@home_fitness/200);


SET @home_total_a = @home_gk + @home_cd1 + @home_im1 + @home_fw1 + @home_fw2 + @home_tactic;

-- Away points
SET @away_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_away), 0);

-- PG
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_gk), 0);
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_gk), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_gk), 0);
SET @away_gk = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);

-- SG
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd1), 0);
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_cd1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd1), 0);
SET @away_cd1 = ((@away_playmaking*0.7)+(@away_defend*0.3))*(@away_fitness/200);

-- CTR
SET @away_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @a_im1), 0);
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_im1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im1), 0);
SET @away_im1 = ((@away_keeper*0.7)+(@away_attack*0.3))*(@away_fitness/200);

-- PF
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw1), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_fw1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw1), 0);
SET @away_fw1 = ((@away_attack*0.7)+(@away_passing*0.3))*(@away_fitness/200);

-- SF
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_fw2), 0);
SET @away_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @a_fw2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw2), 0);
SET @away_fw2 = ((@away_playmaking*0.7)+(@away_keeper*0.3))*(@away_fitness/200);

SET @away_total_a = @away_gk + @away_cd1 + @away_im1 + @away_fw1 + @away_fw2 + @away_tactic;

-- Points summary
DECLARE @home_teamspirit int, @away_teamspirit int, @home_confidence int, @away_confidence int
SET @home_teamspirit = ISNULL((SELECT teamspirit FROM club WHERE club_id=@club_home), 100);
SET @home_confidence = ISNULL((SELECT confidence FROM club WHERE club_id=@club_home), 100);
SET @away_teamspirit = ISNULL((SELECT teamspirit FROM club WHERE club_id=@club_away), 100);
SET @away_confidence = ISNULL((SELECT confidence FROM club WHERE club_id=@club_away), 100);
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

SET @home_score = (@home_total_a);
SET @away_score = (@away_total_a);

IF (@home_score < 1)
BEGIN
	SET @home_score = 30;
END

IF (@away_score < 1)
BEGIN
	SET @away_score = 30;
END

IF ((@home_teamspirit+@home_confidence)>(@away_teamspirit+@away_confidence))
BEGIN
	SET @home_score = @home_score+3;
END

IF ((@away_teamspirit+@away_confidence)>(@home_teamspirit+@home_confidence))
BEGIN
	SET @away_score = @away_score+3;
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
	SET @home_score = @home_score+3;
	SET @a_leveldif = @h_level - @a_level;
END

IF (@a_level > @h_level)
BEGIN
	SET @away_score = @away_score+3;
	SET @h_leveldif = @a_level - @h_level;
END
---------------------------
	
IF (@home_score > 100)
BEGIN
	SET @home_score = dbo.fx_generateRandomNumber(newID(), 90, 99);
END

IF (@away_score > 100)
BEGIN
	SET @away_score = dbo.fx_generateRandomNumber(newID(), 90, 99);
END

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

SET @home_score_diff = @home_score - @away_score;
SET @away_score_diff = @away_score - @home_score;
SET @home_possession = @home_total_a;
SET @away_possession = @away_total_a;

IF (@ascore = @hscore)
BEGIN
	SET @hscore = @hscore + dbo.fx_generateRandomNumber(newID(), 2, 6);
END

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

SET @headline = @home_name+' '+CAST(@home_score AS varchar(12)) +' : '+ CAST(@away_score AS varchar(12))+' '+@away_name;
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
SET @highlight = 'A crowd of '+CAST(@spectators AS varchar(12))+' lines up at '+@home_name+' arena. ';
SET @highlight = @highlight+@news_money;
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
-- Goals scored home
SET @counter = @home_score;
SET @highlight_type_id = 1;
WHILE @counter > 0
BEGIN
SET @player_id = 0;
SET @match_minute = dbo.fx_generateRandomNumber(newID(), 1, 60);
SET @pos_random = dbo.fx_generateRandomNumber(newID(), 1, 8);

IF @pos_random < 5
BEGIN
	IF @h_fw1 > 0
		SET @player_id = @h_fw1;
	ELSE
		IF @h_fw2 > 0
			SET @player_id = @h_fw2;
		ELSE
			IF @h_cd1 > 0
				SET @player_id = @h_rw;
			ELSE
				IF @h_im1 > 0
					SET @player_id = @h_lw;
	
	SET @counter=@counter-2;
END

IF (@pos_random = 5 OR @pos_random = 6)
BEGIN
	IF @h_cd1 > 0
		SET @player_id = @h_cd1;
	ELSE
		IF @h_fw2 > 0
			SET @player_id = @h_fw2;
		ELSE
			IF @h_im1 > 0
				SET @player_id = @h_im1;
			ELSE
				IF @h_fw1 > 0
					SET @player_id = @h_fw1;
					
	SET @counter=@counter-2;
END

IF @pos_random = 7
BEGIN
	IF @h_im1 > 0
		SET @player_id = @h_im1;
	ELSE
		IF @h_gk > 0
			SET @player_id = @h_gk;
		ELSE
			IF @h_cd1 > 0
				SET @player_id = @h_cd1;
			ELSE
				IF @h_fw2 > 0
					SET @player_id = @h_fw2;
					
	SET @counter=@counter-2;
END

IF @pos_random = 8
BEGIN
	IF @h_cd1 > 0
		SET @player_id = @h_cd1;
	ELSE
		IF @h_im1 > 0
			SET @player_id = @h_im1;
		ELSE
			IF @h_gk > 0
				SET @player_id = @h_gk;
			ELSE
				IF @h_fw2 > 0
					SET @player_id = @h_fw2;
					
	SET @counter=@counter-3;
END

SELECT @player_name = player_name FROM player WHERE player_id=@player_id;
SET @highlight = 'After '+CAST(@match_minute AS varchar(12))+' minutes, '+@player_name+' scored for '+@home_name+'.';
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 1) WHERE player_id=@player_id AND fitness>50;
END

-- Goals scored away
SET @counter = @away_score;
SET @highlight_type_id = 2;
WHILE @counter > 0
BEGIN
SET @player_id = 0;
SET @match_minute = dbo.fx_generateRandomNumber(newID(), 1, 60);
SET @pos_random = dbo.fx_generateRandomNumber(newID(), 1, 8);

IF @pos_random < 5
BEGIN
	IF @a_fw1 > 0
		SET @player_id = @a_fw1;
	ELSE
		IF @a_fw2 > 0
			SET @player_id = @a_fw2;
		ELSE
			IF @a_cd1 > 0
				SET @player_id = @a_rw;
			ELSE
				IF @a_im1 > 0
					SET @player_id = @a_lw;
	
	SET @counter=@counter-2;
END

IF (@pos_random = 5 OR @pos_random = 6)
BEGIN
	IF @a_cd1 > 0
		SET @player_id = @a_cd1;
	ELSE
		IF @a_fw2 > 0
			SET @player_id = @a_fw2;
		ELSE
			IF @a_im1 > 0
				SET @player_id = @a_im1;
			ELSE
				IF @a_fw1 > 0
					SET @player_id = @a_fw1;
					
	SET @counter=@counter-2;
END

IF @pos_random = 7
BEGIN
	IF @a_im1 > 0
		SET @player_id = @a_im1;
	ELSE
		IF @a_gk > 0
			SET @player_id = @a_gk;
		ELSE
			IF @a_cd1 > 0
				SET @player_id = @a_cd1;
			ELSE
				IF @a_fw2 > 0
					SET @player_id = @a_fw2;
					
	SET @counter=@counter-2;
END

IF @pos_random = 8
BEGIN
	IF @a_cd1 > 0
		SET @player_id = @a_cd1;
	ELSE
		IF @a_im1 > 0
			SET @player_id = @a_im1;
		ELSE
			IF @a_gk > 0
				SET @player_id = @a_gk;
			ELSE
				IF @a_fw2 > 0
					SET @player_id = @a_fw2;
					
	SET @counter=@counter-3;
END

SELECT @player_name = player_name FROM player WHERE player_id=@player_id;
SET @highlight = 'After '+CAST(@match_minute AS varchar(12))+' minutes, '+@player_name+' scored for '+@away_name+'.';
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 0, 1) WHERE player_id=@player_id AND fitness>50;
END

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

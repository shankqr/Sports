USE [football]
GO
/****** Object:  Trigger [dbo].[trmatch_played]    Script Date: 2/4/2014 5:25:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trmatch_played] ON [dbo].[match]
WITH EXECUTE AS CALLER
AFTER UPDATE
NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;
IF UPDATE(match_played)
BEGIN
DECLARE @match_id int, @match_played int, @match_type_id int, @club_home int, @club_away int, @division int, @series int, @challenge_win int, @challenge_lose int
DECLARE @spectators int, @stadium_overflow int, @stadium_capacity int, @average_ticket int, @ticket_sales int
DECLARE @hscore int, @ascore int, @cwinner int, @closer int
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
DECLARE @away_uid varchar(100), @home_uid varchar(100)

SET @home_uid = (SELECT [uid] FROM club WHERE club_id=@club_home);
SET @away_uid = (SELECT [uid] FROM club WHERE club_id=@club_away);

IF (@home_uid = '0' AND @away_uid = '0')
BEGIN

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
	SET @cwinner = 0;
	SET @closer = 0;
END

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
match_datetime = GETUTCDATE(),
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

-- Calculate the ticket_sales for this match
SET @spectators =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)), 0);
SET @stadium_overflow =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)-(SELECT stadium_capacity FROM club WHERE club_id=@club_home)), 0);
SET @stadium_capacity = ISNULL((SELECT stadium_capacity FROM club WHERE club_id=@club_home), 500);
SET @average_ticket = ISNULL((SELECT average_ticket FROM club WHERE club_id=@club_home), 1);

IF(@stadium_overflow > 0)
	SET @ticket_sales = @average_ticket * @stadium_capacity;
ELSE
	SET @ticket_sales = @average_ticket * @spectators;

UPDATE dbo.match
SET 
weather_id = dbo.fx_generateRandomNumber(newID(), 1, 3),
spectators = @spectators,
stadium_overflow = @stadium_overflow,
ticket_sales = @ticket_sales,
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
match_datetime = GETUTCDATE(),
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

SET @ticket_sales = 1000 + (@ticket_sales / 2);

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales,
balance = balance + @ticket_sales,
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

SET @ticket_sales = dbo.fx_generateRandomNumber(newID(), 1500, 3000);

UPDATE dbo.match
SET 
weather_id = dbo.fx_generateRandomNumber(newID(), 1, 3),
ticket_sales = @ticket_sales,
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
match_datetime = GETUTCDATE(),
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

SET @ticket_sales = 1000 + (@ticket_sales / 2);

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales,
balance = balance + @ticket_sales,
fan_members = fan_members+1, 
fan_mood = fan_mood+1, 
undefeated_counter = undefeated_counter+1,
teamspirit = teamspirit+1, 
confidence = confidence+1
WHERE dbo.club.club_id=@club_away
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

-- Each team receives half
SET @ticket_sales = 1000 + (@ticket_sales / 2);
	

IF(@match_type_id = 3)
BEGIN
	--ACHIEVEMENT 15
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_away AND achievement_type_id=15)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@club_away, 15, 0)
	END
END

-- Declare players
DECLARE
@h_gk int, @h_rb int, @h_lb int, @h_rw int, @h_lw int, 
@h_cd1 int, @h_cd2 int, @h_cd3 int, @h_im1 int, @h_im2 int, @h_im3 int, @h_fw1 int, @h_fw2 int, @h_fw3 int, 
@a_gk int, @a_rb int, @a_lb int, @a_rw int, @a_lw int, 
@a_cd1 int, @a_cd2 int, @a_cd3 int, @a_im1 int, @a_im2 int, @a_im3 int, @a_fw1 int, @a_fw2 int, @a_fw3 int

SET @h_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_home), 0);
SET @h_rb = ISNULL((SELECT rb FROM club WHERE club_id=@club_home), 0);
SET @h_lb = ISNULL((SELECT lb FROM club WHERE club_id=@club_home), 0);
SET @h_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_home), 0);
SET @h_cd2 = ISNULL((SELECT cd2 FROM club WHERE club_id=@club_home), 0);
SET @h_cd3 = ISNULL((SELECT cd3 FROM club WHERE club_id=@club_home), 0);
SET @h_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_home), 0);
SET @h_im2 = ISNULL((SELECT im2 FROM club WHERE club_id=@club_home), 0);
SET @h_im3 = ISNULL((SELECT im3 FROM club WHERE club_id=@club_home), 0);
SET @h_rw = ISNULL((SELECT rw FROM club WHERE club_id=@club_home), 0);
SET @h_lw = ISNULL((SELECT lw FROM club WHERE club_id=@club_home), 0);
SET @h_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_home), 0);
SET @h_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_home), 0);
SET @h_fw3 = ISNULL((SELECT fw3 FROM club WHERE club_id=@club_home), 0);

SET @h_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@h_gk AND club_id=@club_home AND card_red=0), 0);
SET @h_rb = ISNULL((SELECT player_id FROM player WHERE player_id=@h_rb AND club_id=@club_home AND card_red=0), 0);
SET @h_lb = ISNULL((SELECT player_id FROM player WHERE player_id=@h_lb AND club_id=@club_home AND card_red=0), 0);
SET @h_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd1 AND club_id=@club_home AND card_red=0), 0);
SET @h_cd2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd2 AND club_id=@club_home AND card_red=0), 0);
SET @h_cd3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd3 AND club_id=@club_home AND card_red=0), 0);
SET @h_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im1 AND club_id=@club_home AND card_red=0), 0);
SET @h_im2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im2 AND club_id=@club_home AND card_red=0), 0);
SET @h_im3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im3 AND club_id=@club_home AND card_red=0), 0);
SET @h_rw = ISNULL((SELECT player_id FROM player WHERE player_id=@h_rw AND club_id=@club_home AND card_red=0), 0);
SET @h_lw = ISNULL((SELECT player_id FROM player WHERE player_id=@h_lw AND club_id=@club_home AND card_red=0), 0);
SET @h_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw1 AND club_id=@club_home AND card_red=0), 0);
SET @h_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw2 AND club_id=@club_home AND card_red=0), 0);
SET @h_fw3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw3 AND club_id=@club_home AND card_red=0), 0);

SET @a_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_away), 0);
SET @a_rb = ISNULL((SELECT rb FROM club WHERE club_id=@club_away), 0);
SET @a_lb = ISNULL((SELECT lb FROM club WHERE club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_away), 0);
SET @a_cd2 = ISNULL((SELECT cd2 FROM club WHERE club_id=@club_away), 0);
SET @a_cd3 = ISNULL((SELECT cd3 FROM club WHERE club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_away), 0);
SET @a_im2 = ISNULL((SELECT im2 FROM club WHERE club_id=@club_away), 0);
SET @a_im3 = ISNULL((SELECT im3 FROM club WHERE club_id=@club_away), 0);
SET @a_rw = ISNULL((SELECT rw FROM club WHERE club_id=@club_away), 0);
SET @a_lw = ISNULL((SELECT lw FROM club WHERE club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_away), 0);
SET @a_fw3 = ISNULL((SELECT fw3 FROM club WHERE club_id=@club_away), 0);

SET @a_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@a_gk AND club_id=@club_away AND card_red=0), 0);
SET @a_rb = ISNULL((SELECT player_id FROM player WHERE player_id=@a_rb AND club_id=@club_away AND card_red=0), 0);
SET @a_lb = ISNULL((SELECT player_id FROM player WHERE player_id=@a_lb AND club_id=@club_away AND card_red=0), 0);
SET @a_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd1 AND club_id=@club_away AND card_red=0), 0);
SET @a_cd2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd2 AND club_id=@club_away AND card_red=0), 0);
SET @a_cd3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd3 AND club_id=@club_away AND card_red=0), 0);
SET @a_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im1 AND club_id=@club_away AND card_red=0), 0);
SET @a_im2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im2 AND club_id=@club_away AND card_red=0), 0);
SET @a_im3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im3 AND club_id=@club_away AND card_red=0), 0);
SET @a_rw = ISNULL((SELECT player_id FROM player WHERE player_id=@a_rw AND club_id=@club_away AND card_red=0), 0);
SET @a_lw = ISNULL((SELECT player_id FROM player WHERE player_id=@a_lw AND club_id=@club_away AND card_red=0), 0);
SET @a_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw1 AND club_id=@club_away AND card_red=0), 0);
SET @a_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw2 AND club_id=@club_away AND card_red=0), 0);
SET @a_fw3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw3 AND club_id=@club_away AND card_red=0), 0);

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
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 1 -- Defending
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.075;
SET @wM_D = 0.075;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.025;
SET @wM_A = 0.025;
SET @wF_A = 0.1;
END

IF @home_tactic = 2 -- Attacking
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 3 -- Pressing
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.075;
SET @wCD_D = 0.075;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 4 -- Counter Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.075;
SET @wCD_A = 0.075;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 5 -- Middle Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.1;
SET @wM_A = 0.125;
SET @wF_A = 0.075;
END

IF @home_tactic = 6 -- Wings Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.2;
SET @wM_A = 0.05;
SET @wF_A = 0.05;
END

IF @home_tactic = 7 -- Play Creatively
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0.025;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.075;
SET @wM_A = 0.1;
SET @wF_A = 0.075;
END

IF @home_tactic = 8 -- Long Shots
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.15;
END

-- GK
SET @home_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @h_gk), 0);
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_gk), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_gk), 0);
SET @home_gk = @home_keeper *(@home_fitness/200);
SET @home_gk_d = @home_gk * @wGK_D;
SET @home_gk_a = @home_gk * @wGK_A;
-- DR
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_rb), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_rb), 0);
SET @home_rb = @home_defend*(@home_fitness/200);
SET @home_rb_d = @home_rb * @wWB_D;
SET @home_rb_a = @home_rb * @wWB_A;
-- DL
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_lb), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_lb), 0);
SET @home_lb = @home_defend*(@home_fitness/200);
SET @home_lb_d = @home_lb * @wWB_D;
SET @home_lb_a = @home_lb * @wWB_A;
-- DC 1
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd1), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd1), 0);
SET @home_cd1 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_cd1_d = @home_cd1 * @wCD_D;
SET @home_cd1_a = @home_cd1 * @wCD_A;
-- DC 2
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd2), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd2), 0);
SET @home_cd2 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_cd2_d = @home_cd2 * @wCD_D;
SET @home_cd2_a = @home_cd2 * @wCD_A;
-- DC 3
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd3), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd3), 0);
SET @home_cd3 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_cd3_d = @home_cd3 * @wCD_D;
SET @home_cd3_a = @home_cd3 * @wCD_A;
-- MC 1
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im1), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_im1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im1), 0);
SET @home_im1 = ((@home_playmaking*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_im1_d = @home_im1 * @wM_D;
SET @home_im1_a = @home_im1 * @wM_A;
-- MC 2
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im2), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_im2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im2), 0);
SET @home_im2 = ((@home_playmaking*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_im2_d = @home_im2 * @wM_D;
SET @home_im2_a = @home_im2 * @wM_A;
-- MC 3
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im3), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_im3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im3), 0);
SET @home_im3 = ((@home_playmaking*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_im3_d = @home_im3 * @wM_D;
SET @home_im3_a = @home_im3 * @wM_A;
-- MR
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_rw), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_rw), 0);
SET @home_rw = @home_passing *(@home_fitness/200);
SET @home_rw_d = @home_rw * @wW_D;
SET @home_rw_a = @home_rw * @wW_A;
-- ML
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_lw), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_lw), 0);
SET @home_lw = @home_passing *(@home_fitness/200);
SET @home_lw_d = @home_lw * @wW_D;
SET @home_lw_a = @home_lw * @wW_A;
-- SC 1
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw1), 0);
SET @home_fw1 = @home_attack *(@home_fitness/200);
SET @home_fw1_d = @home_fw1 * @wF_D;
SET @home_fw1_a = @home_fw1 * @wF_A;
-- SC 2
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw2), 0);
SET @home_fw2 = @home_attack *(@home_fitness/200);
SET @home_fw2_d = @home_fw2 * @wF_D;
SET @home_fw2_a = @home_fw2 * @wF_A;
-- SC 3
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw3), 0);
SET @home_fw3 = @home_attack *(@home_fitness/200);
SET @home_fw3_d = @home_fw3 * @wF_D;
SET @home_fw3_a = @home_fw3 * @wF_A;

SET @home_total_d = @home_gk_d + @home_rb_d + @home_lb_d + @home_cd1_d + @home_cd2_d + @home_cd3_d + @home_im1_d + @home_im2_d + @home_im3_d + @home_rw_d + @home_lw_d + @home_fw1_d + @home_fw2_d + @home_fw3_d;
SET @home_total_a = @home_gk_a + @home_rb_a + @home_lb_a + @home_cd1_a + @home_cd2_a + @home_cd3_a + @home_im1_a+ @home_im2_a + @home_im3_a + @home_rw_a + @home_lw_a + @home_fw1_a + @home_fw2_a + @home_fw3_a;

-- Away points
SET @away_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_away), 0);

IF @away_tactic = 0 -- Normal
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @away_tactic = 1 -- Defending
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.075;
SET @wM_D = 0.075;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.025;
SET @wM_A = 0.025;
SET @wF_A = 0.1;
END

IF @away_tactic = 2 -- Attacking
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @away_tactic = 3 -- Pressing
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.075;
SET @wCD_D = 0.075;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @away_tactic = 4 -- Counter Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.075;
SET @wCD_A = 0.075;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @away_tactic = 5 -- Middle Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.1;
SET @wM_A = 0.125;
SET @wF_A = 0.075;
END

IF @away_tactic = 6 -- Wings Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.2;
SET @wM_A = 0.05;
SET @wF_A = 0.05;
END

IF @away_tactic = 7 -- Play Creatively
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0.025;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.075;
SET @wM_A = 0.1;
SET @wF_A = 0.075;
END

IF @away_tactic = 8 -- Long Shots
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.15;
END

-- GK
SET @away_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @a_gk), 0);
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_gk), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_gk), 0);
SET @away_gk = @away_keeper *(@away_fitness/200);
SET @away_gk_d = @away_gk * @wGK_D;
SET @away_gk_a = @away_gk * @wGK_A;
-- DR
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_rb), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_rb), 0);
SET @away_rb = @away_defend*(@away_fitness/200);
SET @away_rb_d = @away_rb * @wWB_D;
SET @away_rb_a = @away_rb * @wWB_A;
-- DL
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_lb), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_lb), 0);
SET @away_lb = @away_defend*(@away_fitness/200);
SET @away_lb_d = @away_lb * @wWB_D;
SET @away_lb_a = @away_lb * @wWB_A;
-- DC 1
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd1), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd1), 0);
SET @away_cd1 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_cd1_d = @away_cd1 * @wCD_D;
SET @away_cd1_a = @away_cd1 * @wCD_A;
-- DC 2
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd2), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd2), 0);
SET @away_cd2 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_cd2_d = @away_cd2 * @wCD_D;
SET @away_cd2_a = @away_cd2 * @wCD_A;
-- DC 3
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd3), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd3), 0);
SET @away_cd3 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_cd3_d = @away_cd3 * @wCD_D;
SET @away_cd3_a = @away_cd3 * @wCD_A;
-- MC 1
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im1), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_im1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im1), 0);
SET @away_im1 = ((@away_playmaking*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_im1_d = @away_im1 * @wM_D;
SET @away_im1_a = @away_im1 * @wM_A;
-- MC 2
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im2), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_im2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im2), 0);
SET @away_im2 = ((@away_playmaking*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_im2_d = @away_im2 * @wM_D;
SET @away_im2_a = @away_im2 * @wM_A;
-- MC 3
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im3), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_im3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im3), 0);
SET @away_im3 = ((@away_playmaking*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_im3_d = @away_im3 * @wM_D;
SET @away_im3_a = @away_im3 * @wM_A;
-- MR
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_rw), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_rw), 0);
SET @away_rw = @away_passing *(@away_fitness/200);
SET @away_rw_d = @away_rw * @wW_D;
SET @away_rw_a = @away_rw * @wW_A;
-- ML
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_lw), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_lw), 0);
SET @away_lw = @away_passing *(@away_fitness/200);
SET @away_lw_d = @away_lw * @wW_D;
SET @away_lw_a = @away_lw * @wW_A;
-- SC 1
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw1), 0);
SET @away_fw1 = @away_attack *(@away_fitness/200);
SET @away_fw1_d = @away_fw1 * @wF_D;
SET @away_fw1_a = @away_fw1 * @wF_A;
-- SC 2
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw2), 0);
SET @away_fw2 = @away_attack *(@away_fitness/200);
SET @away_fw2_d = @away_fw2 * @wF_D;
SET @away_fw2_a = @away_fw2 * @wF_A;
-- SC 3
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw3), 0);
SET @away_fw3 = @away_attack *(@away_fitness/200);
SET @away_fw3_d = @away_fw3 * @wF_D;
SET @away_fw3_a = @away_fw3 * @wF_A;

SET @away_total_d = @away_gk_d + @away_rb_d + @away_lb_d + @away_cd1_d + @away_cd2_d + @away_cd3_d + @away_im1_d + @away_im2_d + @away_im3_d + @away_rw_d + @away_lw_d + @away_fw1_d + @away_fw2_d + @away_fw3_d;
SET @away_total_a = @away_gk_a + @away_rb_a + @away_lb_a + @away_cd1_a + @away_cd2_a + @away_cd3_a + @away_im1_a+ @away_im2_a + @away_im3_a + @away_rw_a + @away_lw_a + @away_fw1_a + @away_fw2_a + @away_fw3_a;

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

-- Cup advantage to Home team if it is a Draw
IF ((@match_type_id = 2) OR (@match_type_id > 1000))
BEGIN
	IF (@home_score = @away_score)
	BEGIN
		SET @home_score = @home_score + 1;
	END
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

IF (@home_score = @away_score)
BEGIN
SET @club_winner = 0;
SET @club_loser = 0;
END

UPDATE dbo.match
SET 
weather_id = dbo.fx_generateRandomNumber(newID(), 1, 3),
spectators = @spectators,
stadium_overflow = @stadium_overflow,
home_formation = (SELECT formation FROM club WHERE club_id=match.club_home),
away_formation = (SELECT formation FROM club WHERE club_id=match.club_away),
home_tactic = @home_tactic,
home_teamspirit = @home_teamspirit,
home_confidence = @home_confidence,
away_tactic = @away_tactic,
away_teamspirit = @away_teamspirit,
away_confidence = @away_confidence,
match_datetime = GETUTCDATE(),
ticket_sales = @ticket_sales,
home_score = @home_score, 
away_score = @away_score, 
home_possession = @home_possession, 
away_possession = @away_possession, 
home_score_different = @home_score_diff, 
away_score_different = @away_score_diff,
club_winner = @club_winner, 
club_loser = @club_loser
WHERE match_id = @match_id

-- Challenge money update if friendly match
IF(@match_type_id = 3)
BEGIN
DECLARE @bal int
IF (@home_score > @away_score)
BEGIN
SET @bal = ISNULL((SELECT balance FROM club WHERE club_id=@club_away), 0);
IF (@bal>0)
BEGIN
-- Update finance and xp gain for club home
UPDATE dbo.club
SET 
fan_members = fan_members + 10,
xp = xp + @h_leveldif,
revenue_others = @challenge_lose,
balance = balance + @challenge_lose
WHERE dbo.club.club_id=@club_home
-- Update finance and xp gain for club away
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
fan_members = fan_members + 10,
xp = xp + @a_leveldif,
revenue_others = @challenge_win,
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

DECLARE @home_name varchar(100), @away_name varchar(100), @mr_news_home varchar(1000), @mr_news_away varchar(1000)
SELECT @home_name = club_name FROM club WHERE club_id=@club_home;
SELECT @away_name = club_name FROM club WHERE club_id=@club_away;
SET @mr_news_home = '';
SET @mr_news_away = '';

IF(@match_type_id != 3) -- Not a frienldy match
BEGIN

--Clear all red cards for all players from home and away
UPDATE player SET card_red=0 WHERE club_id=@club_home OR club_id=@club_away;

-- Select a random home and away player
DECLARE @random_pos_home int, @random_player_home int, @random_pos_away int, @random_player_away int

SET @random_pos_home = dbo.fx_generateRandomNumber(newID(), 1, 14);

IF @random_pos_home = 1
	SET @random_player_home = @h_gk;

IF @random_pos_home = 2
	SET @random_player_home = @h_rb;

IF @random_pos_home = 3
	SET @random_player_home = @h_lb;

IF @random_pos_home = 4
	SET @random_player_home = @h_cd1;

IF @random_pos_home = 5
	SET @random_player_home = @h_cd2;

IF @random_pos_home = 6
	SET @random_player_home = @h_cd3;

IF @random_pos_home = 7
	SET @random_player_home = @h_im1;

IF @random_pos_home = 8
	SET @random_player_home = @h_im2;

IF @random_pos_home = 9
	SET @random_player_home = @h_im3;

IF @random_pos_home = 10
	SET @random_player_home = @h_rw;

IF @random_pos_home = 11
	SET @random_player_home = @h_lw;

IF @random_pos_home = 12
	SET @random_player_home = @h_fw1;

IF @random_pos_home = 13
	SET @random_player_home = @h_fw2;

IF @random_pos_home = 14
	SET @random_player_home = @h_fw3;


SET @random_pos_away = dbo.fx_generateRandomNumber(newID(), 1, 14);

IF @random_pos_away = 1
	SET @random_player_away = @a_gk;

IF @random_pos_away = 2
	SET @random_player_away = @a_rb;

IF @random_pos_away = 3
	SET @random_player_away = @a_lb;

IF @random_pos_away = 4
	SET @random_player_away = @a_cd1;

IF @random_pos_away = 5
	SET @random_player_away = @a_cd2;

IF @random_pos_away = 6
	SET @random_player_away = @a_cd3;

IF @random_pos_away = 7
	SET @random_player_away = @a_im1;

IF @random_pos_away = 8
	SET @random_player_away = @a_im2;

IF @random_pos_away = 9
	SET @random_player_away = @a_im3;

IF @random_pos_away = 10
	SET @random_player_away = @a_rw;

IF @random_pos_away = 11
	SET @random_player_away = @a_lw;

IF @random_pos_away = 12
	SET @random_player_away = @a_fw1;

IF @random_pos_away = 13
	SET @random_player_away = @a_fw2;

IF @random_pos_away = 14
	SET @random_player_away = @a_fw3;


DECLARE @p_name varchar(50), @p_pos varchar(50), @card_y int, @random_event int, @random_skill int, @random_injury int, @injury_name varchar(500), @p_news varchar(1000)

IF @random_player_home > 0
BEGIN

SELECT @p_name = player_name FROM player WHERE player_id=@random_player_home;
SELECT @p_pos = position FROM player WHERE player_id=@random_player_home;

IF @p_pos = 'All'
	SET @p_pos = 'Player';

SET @random_event = dbo.fx_generateRandomNumber(newID(), 1, 4);

-- Yellow card. If already have 1 then banned for next match
IF @random_event = 1
BEGIN

SET @card_y = ISNULL((SELECT card_yellow FROM player WHERE player_id=@random_player_home), 0);

IF @card_y = 0
BEGIN
UPDATE player SET card_yellow=1 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' received a yellow card after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' received a yellow card.';
EXECUTE usp_SendMailNews @club_home, @p_news
END
ELSE
BEGIN
UPDATE player SET card_yellow=0, card_red=1 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' received a red card and has been banned for 1 league/cup match after reaching the yellow cards limit in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' received a red card and has been banned for 1 league/cup match after reaching the yellow cards limit.';
EXECUTE usp_SendMailNews @club_home, @p_news
END

END

-- Red card banned for next match
IF @random_event = 2
BEGIN
UPDATE player SET card_yellow=0, card_red=1 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' received a red card and has been banned for 1 league/cup match after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' received a red card and has been banned for 1 league/cup match.';
EXECUTE usp_SendMailNews @club_home, @p_news
END

-- Level up a skill
IF @random_event = 3
BEGIN

SET @random_skill = dbo.fx_generateRandomNumber(newID(), 1, 4);

IF @random_skill = 1
BEGIN
UPDATE player SET defend=defend+2 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Defend skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' leveled up his Defend skills.';
END

IF @random_skill = 2
BEGIN
UPDATE player SET playmaking=playmaking+2 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Playmaking skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' leveled up his Playmaking skills.';
END

IF @random_skill = 3
BEGIN
UPDATE player SET attack=attack+2 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Attack skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' leveled up his Attack skills.';
END

IF @random_skill = 4
BEGIN
UPDATE player SET passing=passing+2 WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Passing skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' leveled up his Passing skills.';
END

EXECUTE usp_SendMailNews @club_home, @p_news

END

-- Got injured
IF @random_event = 4
BEGIN

SET @random_injury = dbo.fx_generateRandomNumber(newID(), 1, 5);
IF @random_injury = 1
	SET @injury_name = 'Knee Cartilage Tear';
IF @random_injury = 2
	SET @injury_name = 'Hamstring Strain';
IF @random_injury = 3
	SET @injury_name = 'Sprained Ankle';
IF @random_injury = 4
	SET @injury_name = 'Hernia';
IF @random_injury = 5
	SET @injury_name = 'Anterior Cruciate Ligament';

UPDATE player SET player_condition=2, player_condition_days=@random_pos_away WHERE player_id=@random_player_home;
SET @p_news = @p_pos + ' ' + @p_name + ' will be out of action for about ' + CAST(@random_pos_away AS varchar(12)) + ' day(s) after he suffered a ' + @injury_name + ' in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @home_name + ' will be out of action for about ' + CAST(@random_pos_away AS varchar(12)) + ' day(s) as he suffered a ' + @injury_name + ' in this match';
EXECUTE usp_SendMailNews @club_home, @p_news
END

END

IF @random_player_away > 0
BEGIN

SELECT @p_name = player_name FROM player WHERE player_id=@random_player_away;
SELECT @p_pos = position FROM player WHERE player_id=@random_player_away;

IF @p_pos = 'All'
	SET @p_pos = 'Player';

SET @random_event = dbo.fx_generateRandomNumber(newID(), 1, 4);

-- Yellow card. If already have 1 then banned for next match
IF @random_event = 1
BEGIN

SET @card_y = ISNULL((SELECT card_yellow FROM player WHERE player_id=@random_player_away), 0);

IF @card_y = 0
BEGIN
UPDATE player SET card_yellow=1 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' received a yellow card after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' received a yellow card.';
EXECUTE usp_SendMailNews @club_away, @p_news
END
ELSE
BEGIN
UPDATE player SET card_yellow=0, card_red=1 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' received a red card and has been banned for 1 league/cup match after reaching the yellow cards limit in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' received a red card and has been banned for 1 league/cup match after reaching the yellow cards limit.';
EXECUTE usp_SendMailNews @club_away, @p_news
END

END

-- Red card banned for next match
IF @random_event = 2
BEGIN
UPDATE player SET card_yellow=0, card_red=1 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' received a red card and has been banned for 1 league/cup match after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' received a red card and has been banned for 1 league/cup match.';
EXECUTE usp_SendMailNews @club_away, @p_news
END

-- Level up a skill
IF @random_event = 3
BEGIN

SET @random_skill = dbo.fx_generateRandomNumber(newID(), 1, 4);

IF @random_skill = 1
BEGIN
UPDATE player SET defend=defend+2 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Defend skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' leveled up his Defend skills.';
END

IF @random_skill = 2
BEGIN
UPDATE player SET playmaking=playmaking+2 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Playmaking skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' leveled up his Playmaking skills.';
END

IF @random_skill = 3
BEGIN
UPDATE player SET attack=attack+2 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Attack skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' leveled up his Attack skills.';
END

IF @random_skill = 4
BEGIN
UPDATE player SET passing=passing+2 WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' leveled up his Passing skills after being sent off in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' leveled up his Passing skills.';
END

EXECUTE usp_SendMailNews @club_away, @p_news

END

-- Got injured
IF @random_event = 4
BEGIN

SET @random_injury = dbo.fx_generateRandomNumber(newID(), 1, 5);
IF @random_injury = 1
	SET @injury_name = 'Knee Cartilage Tear';
IF @random_injury = 2
	SET @injury_name = 'Hamstring Strain';
IF @random_injury = 3
	SET @injury_name = 'Sprained Ankle';
IF @random_injury = 4
	SET @injury_name = 'Hernia';
IF @random_injury = 5
	SET @injury_name = 'Anterior Cruciate Ligament';

UPDATE player SET player_condition=2, player_condition_days=@random_pos_away WHERE player_id=@random_player_away;
SET @p_news = @p_pos + ' ' + @p_name + ' will be out of action for about ' + CAST(@random_pos_home AS varchar(12)) + ' day(s) after he suffered a ' + @injury_name + ' in ' + @home_name + ' match againts ' + @away_name;
SET @mr_news_home = @p_pos + ' ' + @p_name + ' from ' + @away_name + ' will be out of action for about ' + CAST(@random_pos_away AS varchar(12)) + ' day(s) as he suffered a ' + @injury_name + ' in this match';
EXECUTE usp_SendMailNews @club_away, @p_news
END

END

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

IF (@undefeated_counter is null)
BEGIN
SET @undefeated_counter = 0;
END

SET @undefeated_counter = @undefeated_counter + 1;
IF(@undefeated_counter IS NOT NULL)
BEGIN
INSERT INTO dbo.news VALUES (GETUTCDATE(), 0, 1, 'Your team is now undefeated for '+cast(@undefeated_counter as varchar(9))+' competitive games', 'Fans are excited with your performance.', '', 0, @club_home, 0, 0, 0)
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
revenue_stadium = @ticket_sales,
balance = balance + @ticket_sales,
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

IF (@undefeated_counter_away is null)
BEGIN
SET @undefeated_counter_away = 0;
END

SET @undefeated_counter_away = @undefeated_counter_away + 1;
IF(@undefeated_counter_away IS NOT NULL)
BEGIN
INSERT INTO dbo.news VALUES (GETUTCDATE(), 0, 1, 'Your team is now undefeated for '+cast(@undefeated_counter_away as varchar(9))+' competitive games', 'Fans are excited with your performance.', '', 0, @club_away, 0, 0, 0)
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
@headline varchar(500)

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
SET @news_money = @news_money+', each received $'+CAST((@ticket_sales) AS varchar(12))+'. ';
SET @news_marque = '. Ticket sales amounted to $'+CAST((@ticket_sales*2) AS varchar(12));
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
	SET @news_marque = '. ' + @home_name + ' gained 10 Fans and won the bet for $'+CAST(@challenge_lose AS varchar(12));
	END
END

IF (@home_score_diff < 0)
BEGIN
	SET @news_result = @news_result + @away_name + ' beating ' + @home_name + ' ' + CAST(@away_score AS varchar(12))+' - '+CAST(@home_score AS varchar(12));
	IF(@match_type_id = 3)
	BEGIN
	SET @news_marque = '. ' + @away_name + ' gained 10 Fans and won the bet for $'+CAST(@challenge_win AS varchar(12));
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

IF ((@match_type_id = 2) OR (@match_type_id > 1000)) -- Cup Match
BEGIN
	SET @headline='(CUP) '+@headline+@news_marque;
END

IF (@match_type_id = 3) -- Friendly Match
BEGIN
	SET @headline='(FRIENDLY) '+@headline+@news_marque;
END

IF (@headline is not null)
BEGIN
INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @headline, @news, '', 0, @club_home, 0, 0, 0)
INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @headline, @news, '', 0, @club_away, 0, 0, 0)
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
SET @highlight = @highlight+@news_money+@mr_news_home+@mr_news_away;
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
-- Goals scored home
SET @counter = @home_score;
SET @highlight_type_id = 1;
WHILE @counter > 0
BEGIN
SET @player_id = 0;
SET @match_minute = dbo.fx_generateRandomNumber(newID(), 1, 90);
SET @pos_random = dbo.fx_generateRandomNumber(newID(), 1, 6);

IF @pos_random = 1
BEGIN
	IF @h_fw1 > 0
		SET @player_id = @h_fw1;
	ELSE
	BEGIN
		IF @h_fw2 > 0
			SET @player_id = @h_fw2;
		ELSE
			IF @h_fw3 > 0
				SET @player_id = @h_fw3;
	END
END

IF @pos_random = 2
BEGIN
	IF @h_fw2 > 0
		SET @player_id = @h_fw2;
	ELSE
	BEGIN
		IF @h_fw3 > 0
			SET @player_id = @h_fw3;
		ELSE
			IF @h_fw1 > 0
				SET @player_id = @h_fw1;
	END
END

IF @pos_random = 3
BEGIN
	IF @h_fw3 > 0
		SET @player_id = @h_fw3;
	ELSE
	BEGIN
		IF @h_fw1 > 0
			SET @player_id = @h_fw1;
		ELSE
			IF @h_fw2 > 0
				SET @player_id = @h_fw2;
	END
END

IF @pos_random = 4 -- im scored
BEGIN
	IF @h_im1 > 0
		SET @player_id = @h_im1;
	ELSE
	BEGIN
		IF @h_im2 > 0
			SET @player_id = @h_im2;
		ELSE
			IF @h_im3 > 0
				SET @player_id = @h_im3;
	END
END

IF @pos_random = 5 -- wing scored
BEGIN
	IF @h_rw > 0
		SET @player_id = @h_rw;
	ELSE
		IF @h_lw > 0
			SET @player_id = @h_lw;
END

IF @pos_random = 6 -- wing scored
BEGIN
	IF @h_lw > 0
		SET @player_id = @h_lw;
	ELSE
		IF @h_rw > 0
			SET @player_id = @h_rw;
END

IF @player_id = 0
BEGIN
SET @player_id = @h_rb;
END

SELECT @player_name = player_name FROM player WHERE player_id=@player_id;
SET @highlight = 'After '+CAST(@match_minute AS varchar(12))+' minutes, '+@player_name+' scored a goal for '+@home_name+'.';
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 2, 5) WHERE player_id=@player_id AND fitness>50;
SET @counter=@counter-1;
END

-- Goals scored away
SET @counter = @away_score;
SET @highlight_type_id = 2;
WHILE @counter > 0
BEGIN
SET @player_id = 0;
SET @match_minute = dbo.fx_generateRandomNumber(newID(), 1, 90);
SET @pos_random = dbo.fx_generateRandomNumber(newID(), 1, 6);

IF @pos_random = 1
BEGIN
	IF @a_fw1 > 0
		SET @player_id = @a_fw1;
	ELSE
	BEGIN
		IF @a_fw2 > 0
			SET @player_id = @a_fw2;
		ELSE
			IF @a_fw3 > 0
				SET @player_id = @a_fw3;
	END
END

IF @pos_random = 2
BEGIN
	IF @a_fw2 > 0
		SET @player_id = @a_fw2;
	ELSE
	BEGIN
		IF @a_fw3 > 0
			SET @player_id = @a_fw3;
		ELSE
			IF @a_fw1 > 0
				SET @player_id = @a_fw1;
	END
END
	
IF @pos_random = 3
BEGIN
	IF @a_fw3 > 0
		SET @player_id = @a_fw3;
	ELSE
	BEGIN
		IF @a_fw1 > 0
			SET @player_id = @a_fw1;
		ELSE
			IF @a_fw2 > 0
				SET @player_id = @a_fw2;
	END
END

IF @pos_random = 4 -- im scored
BEGIN
	IF @a_im1 > 0
		SET @player_id = @a_im1;
	ELSE
	BEGIN
		IF @a_im2 > 0
			SET @player_id = @a_im2;
		ELSE
			IF @a_im3 > 0
				SET @player_id = @a_im3;
	END
END

IF @pos_random = 5 -- wing scored
BEGIN
	IF @a_rw > 0
		SET @player_id = @a_rw;
	ELSE
		IF @a_lw > 0
			SET @player_id = @a_lw;
END

IF @pos_random = 6 -- wing scored
BEGIN
	IF @a_lw > 0
		SET @player_id = @a_lw;
	ELSE
		IF @a_rw > 0
			SET @player_id = @a_rw;
END

IF @player_id = 0
BEGIN
	SET @player_id = @a_rb;
END

SELECT @player_name = player_name FROM player WHERE player_id=@player_id;
SET @highlight = 'After '+CAST(@match_minute AS varchar(12))+' minutes, '+@player_name+' scored a goal for '+@away_name+'.';
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
UPDATE dbo.player SET fitness=fitness-dbo.fx_generateRandomNumber(newID(), 2, 5) WHERE player_id=@player_id AND fitness>50;
SET @counter=@counter-1;
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


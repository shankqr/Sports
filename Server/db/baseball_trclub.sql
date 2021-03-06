USE [baseball]
GO
/****** Object:  Trigger [dbo].[trclub]    Script Date: 1/26/2013 12:26:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trclub]
   ON  [dbo].[club]
   AFTER UPDATE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;

DECLARE @uid varchar(100)
SELECT @uid = uid FROM inserted;

IF (@uid != '0' AND @uid != '1')
BEGIN

DECLARE @club_id int, @club_name varchar(100), @division int, @series int, @news varchar(1000)
--@devtoken varchar(100), @gameid varchar(10),
SELECT @club_id = club_id FROM inserted;
SELECT @club_name = club_name FROM inserted;
SELECT @division = division FROM inserted;
SELECT @series = series FROM inserted;
--SELECT @devtoken = devicetoken FROM inserted;
--SELECT @gameid = game_id FROM inserted;

IF UPDATE(fan_members)
BEGIN
DECLARE @fan_members_before int, @fan_members_after int, @fan_members_diff int
SELECT @fan_members_before = fan_members FROM deleted;
SELECT @fan_members_after = fan_members FROM inserted;
IF (@fan_members_after > @fan_members_before)
BEGIN
SET @fan_members_diff = @fan_members_after - @fan_members_before;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, CAST(@fan_members_diff AS varchar(5))+' new supporters signed up', 'Your total fan members has increased to '+CAST(@fan_members_after AS varchar(5))+' from '+CAST(@fan_members_before AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
--ACHIEVEMENT 33
IF @fan_members_after>249000 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=33)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 33, 1)
UPDATE club SET revenue_others=17500, revenue_total=revenue_total+17500, balance=balance+17500 WHERE club_id=@club_id
END
END
IF (@fan_members_before > @fan_members_after)
BEGIN
SET @fan_members_diff = @fan_members_before - @fan_members_after;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, CAST(@fan_members_diff AS varchar(5))+' supporters resigned', 'Your total fan members has decreased to '+CAST(@fan_members_after AS varchar(5))+' from '+CAST(@fan_members_before AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(fan_mood)
BEGIN
DECLARE @fan_mood_before int, @fan_mood_after int
SELECT @fan_mood_before = fan_mood FROM deleted;
SELECT @fan_mood_after = fan_mood FROM inserted;
IF (@fan_mood_after > @fan_mood_before)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Fan mood towards your club is improving', 'Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
IF (@fan_mood_before > @fan_mood_after)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Fan mood towards your club is declining', 'Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(revenue_sponsors)
BEGIN
DECLARE @sponsor_before int, @sponsor_after int, @sponsor_diff int
SELECT @sponsor_before = revenue_sponsors FROM deleted;
SELECT @sponsor_after = revenue_sponsors FROM inserted;
IF (@sponsor_after > @sponsor_before)
BEGIN
SET @sponsor_diff = @sponsor_after - @sponsor_before;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, '$'+CAST(@sponsor_diff AS varchar(5))+' increase in funding from sponsors', 'Sponsors funding has increased by $'+CAST(@sponsor_diff AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
IF (@sponsor_before > @sponsor_after)
BEGIN
SET @sponsor_diff = @sponsor_before - @sponsor_after;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, '$'+CAST(@sponsor_diff AS varchar(5))+' decrease in funding from sponsors', 'Sponsors funding has decreased by $'+CAST(@sponsor_diff AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(teamspirit)
BEGIN
DECLARE @teamspirit_before int, @teamspirit_after int
SELECT @teamspirit_before = teamspirit FROM deleted;
SELECT @teamspirit_after = teamspirit FROM inserted;
IF (@teamspirit_after > @teamspirit_before)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team spirit is improving', 'Employ more psychologists to improve team spirit.', '', 0, @club_id, 0, 0, 0)
END
IF (@teamspirit_before > @teamspirit_after)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team spirit is declining', 'Employ more psychologists to improve team spirit.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(confidence)
BEGIN
DECLARE @confidence_before int, @confidence_after int
SELECT @confidence_before = confidence FROM deleted;
SELECT @confidence_after = confidence FROM inserted;
IF (@confidence_after > @confidence_before)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team confidence is improving', 'Employ more psychologists to improve team confidence.', '', 0, @club_id, 0, 0, 0)
END
IF (@confidence_before > @confidence_after)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team confidence is declining', 'Employ more psychologists to improve team confidence.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(stadium)
BEGIN
DECLARE @counter int, @news_headline varchar(1000)
SET @news_headline = @club_name+' has upgraded their arena';
SET @counter = ISNULL((SELECT count(*) FROM news WHERE headline=@news_headline), 0);
IF (@counter=0)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @club_name+' has upgraded their arena', 'You can upgrade your arena to increase the seating capacity and average ticket price.', '', 0, 0, @division, @series, 0)
END
END

IF UPDATE(club_name)
BEGIN
DECLARE @club_name_before varchar(100), @uid_before varchar(100)
SELECT @uid_before = uid FROM deleted;
IF (@uid_before = '0')
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @club_name+', welcome to the game', 'Welcome stranger. We wish you good luck in rising to the top.', '', 0, @club_id, 0, 0, 0)
END
ELSE
BEGIN
SELECT @club_name_before = club_name FROM deleted;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @club_name_before+' has changed their club name to '+@club_name, 'You can rename your club at anytime you wish.', '', 0, 0, @division, @series, 0)
--ACHIEVEMENT 1
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=1)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 1, 1)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END

END
END

IF UPDATE(coach_id)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @club_name+' has signed up a new coach', 'Hire a more experience coach to improve the training of your players.', '', 0, 0, @division, @series, 0)
END

IF UPDATE(league_ranking)
BEGIN
DECLARE @league_ranking_before int, @league_ranking_after int
SELECT @league_ranking_before = league_ranking FROM deleted;
SELECT @league_ranking_after = league_ranking FROM inserted;
IF (@league_ranking_after > @league_ranking_before)
BEGIN
SET @news = 'Team move down the league to position #'+CAST(@league_ranking_after AS varchar(5))+' in the series';
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @news, 'Fan and supporters are disappointed.', '', 0, @club_id, 0, 0, 0)
END
IF (@league_ranking_before > @league_ranking_after)
BEGIN
SET @news = 'Team climbed the league to position #'+CAST(@league_ranking_after AS varchar(5))+' in the series';
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @news, 'Fan and supporters a thrilled by this news.', '', 0, @club_id, 0, 0, 0)
--ACHIEVEMENT 31
IF @league_ranking_before>1 AND @league_ranking_after=1 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=31)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 31, 1)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END
END
END

IF UPDATE(division)
BEGIN
DECLARE @division_before int, @division_after int
SELECT @division_before = division FROM deleted;
SELECT @division_after = division FROM inserted;
IF (@division_after > @division_before)
BEGIN
SET @news = 'Bad news, your club has been demoted to a lower division!'
--EXEC usp_pushfast @gameid, @devtoken, @news
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @news, 'Fan and supporters are really disappointed by this news. However everyone in your club is determined to fight back to the top.', '', 0, @club_id, 0, 0, 0)
END
IF (@division_before > @division_after)
BEGIN
SET @news = 'Congratulations, your club has been promoted to a higher division and rewarded $100,000!'
--EXEC usp_pushfast @gameid, @devtoken, @news
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @news, 'Congratulations on this big achievement. Fan and supporters are thrilled by this news.', '', 0, @club_id, 0, 0, 0)
UPDATE club SET revenue_others=100000, revenue_total=revenue_total+100000, balance=balance+100000 WHERE club_id=@club_id
--ACHIEVEMENT 30
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=30)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 30, 1)
UPDATE club SET revenue_others=12500, revenue_total=revenue_total+12500, balance=balance+12500 WHERE club_id=@club_id
END
--ACHIEVEMENT 35
IF @division_after=1 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=35)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 35, 1)
UPDATE club SET revenue_others=20000, revenue_total=revenue_total+20000, balance=balance+20000 WHERE club_id=@club_id
END

END
END

IF UPDATE(away_pic)
BEGIN
--ACHIEVEMENT 2
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=2)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 2, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(spokespersons)
BEGIN
--ACHIEVEMENT 3
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=3)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 3, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(training)
BEGIN
--ACHIEVEMENT 4
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=4)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 4, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(coaches)
BEGIN
--ACHIEVEMENT 5
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=5)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 5, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(formation)
BEGIN
--ACHIEVEMENT 6
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=6)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 6, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(stadium)
BEGIN
--ACHIEVEMENT 7
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=7)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 7, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
DECLARE @stadium_after int
SELECT @stadium_after = stadium FROM inserted;
IF(@stadium_after>64)
BEGIN
--ACHIEVEMENT 32
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=32)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 32, 1)
UPDATE club SET revenue_others=250000, revenue_total=revenue_total+250000, balance=balance+250000 WHERE club_id=@club_id
END
END
END

IF UPDATE(fb_uid)
BEGIN
--ACHIEVEMENT 8
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=8)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 8, 1)
UPDATE club SET revenue_others=35000, revenue_total=revenue_total+35000, balance=balance+35000 WHERE club_id=@club_id
END
END

IF UPDATE(playing_cup)
BEGIN
--ACHIEVEMENT 9
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=9)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 9, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(accountants)
BEGIN
--ACHIEVEMENT 10
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=10)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 10, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(captain)
BEGIN
--ACHIEVEMENT 11
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=11)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 11, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(physiotherapists)
BEGIN
--ACHIEVEMENT 14
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=14)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 14, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(xp)
BEGIN
--ACHIEVEMENT 16
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=16)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 16, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
--ACHIEVEMENT 18
DECLARE @xp_after int
SELECT @xp_after = xp FROM inserted;
IF @xp_after>10 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=18)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 18, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
--ACHIEVEMENT 37
IF @xp_after>2500000 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=37)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 37, 1)
UPDATE club SET revenue_others=15000, revenue_total=revenue_total+15000, balance=balance+15000 WHERE club_id=@club_id
END
--LEVEL UP REWARD
DECLARE @xp_before int, @level_before int, @level_after int
SELECT @xp_before = xp FROM deleted;
SET @level_before = sqrt(@xp_before/10) + 1;
SET @level_after = sqrt(@xp_after/10) + 1;

IF @level_after=@level_before+1
BEGIN
UPDATE club SET fan_members=fan_members+(@level_after*10), energy=energy+3, balance=balance+(@level_after*1000) WHERE club_id=@club_id
END

END

IF UPDATE(doctors)
BEGIN
--ACHIEVEMENT 17
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=17)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 17, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(tactic)
BEGIN
--ACHIEVEMENT 19
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=19)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 19, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(scouts)
BEGIN
--ACHIEVEMENT 20
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=20)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 20, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(coach_id)
BEGIN
--ACHIEVEMENT 22
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=22)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 22, 1)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END
END

IF UPDATE(managers)
BEGIN
--ACHIEVEMENT 23
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=23)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 23, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(psychologists)
BEGIN
--ACHIEVEMENT 26
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=26)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 26, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(undefeated_counter)
BEGIN
--ACHIEVEMENT 27
DECLARE @u_after int
SELECT @u_after = undefeated_counter FROM inserted;
IF @u_after>2 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=27)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 27, 1)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END
END

IF UPDATE(balance)
BEGIN
DECLARE @balance_after int
SELECT @balance_after = balance FROM inserted;
--ACHIEVEMENT 34
IF (@balance_after > 9999999) AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=34)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 34, 1)
UPDATE club SET revenue_others=17500, revenue_total=revenue_total+17500, balance=balance+17500 WHERE club_id=@club_id
END
END

IF UPDATE(building2)
BEGIN
--ACHIEVEMENT 13
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=13)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 13, 1)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(building3)
BEGIN
--ACHIEVEMENT 21
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=21)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 21, 1)
UPDATE club SET revenue_others=10000, revenue_total=revenue_total+10000, balance=balance+10000 WHERE club_id=@club_id
END
END

IF UPDATE(building1)
BEGIN
--ACHIEVEMENT 25
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=25)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 25, 1)
UPDATE club SET revenue_others=20000, revenue_total=revenue_total+20000, balance=balance+20000 WHERE club_id=@club_id
END
END

IF UPDATE(sim)
BEGIN
--ACHIEVEMENT 36
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=36)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 36, 1)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

END
END

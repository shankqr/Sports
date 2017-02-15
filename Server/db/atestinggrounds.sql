
SELECT TOP(1) * FROM match WHERE match_datetime<=GETDATE() AND match_played=0

--UPDATE club SET alliance_id=0

SELECT * FROM View_MatchHighlightPlayer WHERE match_id=15401801 ORDER BY match_minute

SELECT * FROM club WHERE uid IN(select uid from club group by uid having count(*) > 1) AND uid!='0' AND uid!='1'
--UPDATE club SET uid='0' WHERE uid IN(select uid from club group by uid having count(*) > 1) AND uid!='0' AND uid!='1'

SELECT * FROM club WHERE game_id=11

SELECT club_id, count(club_id) as cnt FROM player GROUP by club_id ORDER BY cnt ASC

SELECT S.club_id, S.player_name, C.cnt
  FROM player  S
       INNER JOIN (SELECT club_id, count(club_id) as cnt
                     FROM player 
                    GROUP BY club_id) C ON S.club_id = C.club_id AND C.cnt < 11 ORDER BY C.cnt ASC

--stadium reset
UPDATE club SET stadium_capacity=stadium*50, average_ticket=stadium

SELECT TOP(2) club_id, balance FROM club ORDER BY balance DESC

SELECT TOP 50 club_id, count(*) FROM player GROUP BY club_id ORDER BY count(*) DESC
SELECT * FROM player WHERE club_id=35638
SELECT * FROM club WHERE club_id=18099
--31622
--18233
--126
--18099

UPDATE player set nationality = cast(cast(crypt_gen_random(1) as int) * 262.0 / 256 as int)

SELECT count(*) FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_age > 34 AND club.uid != '0'

SELECT count(*) FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_id = 17 AND club.uid = '47099a89b5eac5fa72b10f434be7f3e32'

select product_id from transactions group by product_id having count(*) >1

SELECT * FROM club WHERE club_name LIKE '%Manchester coyotes%' AND division=5 AND series=176
SELECT * FROM club WHERE club_name LIKE '%COYOTES%'
--13558

--4975f16945baad72ee01cb63acf4b358e / 2528
--0975f16945baad72ee01cb63acf4b358e --28132

SELECT MAX(fan_members) FROM club
SELECT MIN(fan_members) FROM club
SELECT AVG(fan_members) FROM club

SELECT * FROM transactions WHERE uid='2b36628448f32fd1f54617fa0c253f43dbcf02c02' --
SELECT * FROM transactions WHERE uid='13483bb307c76b1aa623a4aac8e526c6e4a620328' --3861
SELECT * FROM transactions WHERE product_id=416902
SELECT * FROM bid WHERE uid='2b36628448f32fd1f54617fa0c253f43dbcf02c02'
SELECT * FROM club WHERE uid LIKE '%6e8e40e178b945abdcbb3982282a7a3d'
SELECT * FROM club WHERE uid LIKE '%7099a89b5eac5fa72b10f434be7f3e32'
SELECT * FROM player WHERE player_id=1088265
SELECT * FROM player WHERE player_name = 'Bard Darrell'
SELECT * FROM player WHERE club_id=10286 --87319, 87206 c65ce8207df0e423a88237a50672a23c40d4dce9d5b11d5e0c427860d711b453
SELECT * FROM club WHERE club_id=82706

SELECT * FROM club WHERE email!='(null)' AND email is not NULL

SELECT * FROM club WHERE energy<20
--UPDATE club SET energy=20 WHERE energy<20

SELECT * FROM receipt WHERE uid='4d7dea5ed8af000930fab75718e7f97a3f5195d77'

--EXEC usp_block 'e83bd4ce7a7269ed0742cf8f4854c10217f8fa7f'
EXEC usp_ResetRemove 'c57cec61ea8d4ffe71d53c2557988c74cec68243'

SELECT * FROM club WHERE xp>100000 ORDER BY xp DESC 
SELECT * FROM club WHERE xp>100000 ORDER BY date_found DESC

UPDATE club SET e=energy

UPDATE club SET e=e+1 WHERE e<energy

--Brampton Millers club_id=8300
--UPDATE club SET energy=energy+10
--UPDATE club SET balance=balance+1260750, revenue_others=1260750 WHERE club_id=1200
--UPDATE club SET uid='19e79c6863520613d6cc642d422fad5e727d1b6fa' WHERE club_id=7774
--UPDATE club SET uid='0' WHERE club_id=53204
--UPDATE club SET e=0, building1=0, building2=0, building3=0
--UPDATE club SET currency_second=25

SELECT * FROM club WHERE balance>50000000

SELECT TOP 10 * FROM chat ORDER BY chat_id DESC

SELECT TOP 10 * FROM club ORDER BY revenue_stadium DESC
SELECT TOP 10 * FROM club ORDER BY revenue_sponsors DESC
SELECT TOP 10 * FROM club ORDER BY revenue_investments DESC
SELECT TOP 50 * FROM club ORDER BY fan_members DESC
SELECT TOP 10 * FROM club ORDER BY average_ticket DESC
SELECT TOP 10 * FROM club ORDER BY coaches DESC
SELECT TOP 50 * FROM club ORDER BY balance DESC

SELECT dbo.fx_minOf(4, 28)

SELECT MAX(revenue_stadium) FROM club

EXEC xp_cmdshell 'C:\windows\system32\cscript.exe c:\vbs\pushfast.vbs "0" "71e1b0f692f4fedb0f262bc4d5c5264a9036146e379c6fcc331d4360d93e5d3e" "pushfast"',no_output

EXEC usp_pushfast '0', '71e1b0f692f4fedb0f262bc4d5c5264a9036146e379c6fcc331d4360d93e5d3e', 'from usp_pushfast'

SELECT TOP 10 * FROM View_Match WHERE (club_home = 1 OR club_away = 1) AND match_type_id = 3 AND match_played = 0 ORDER BY match_datetime ASC
UPDATE match SET match_played=1 WHERE match_id=2246999

SELECT TOP 10 club_id, player_id, player_name, player_age, player_salary, player_value, COUNT(player_id) AS Score FROM View_MatchHighlightPlayer WHERE (highlight_type_id = 1 OR highlight_type_id = 2) AND match_type_id = 2 GROUP BY player_id, player_name, player_age, player_salary, player_value, club_id ORDER BY Score DESC

SELECT * FROM club WHERE gk > 1001334 OR rb > 1001334 OR lb > 1001334 OR rw > 1001334 OR lw > 1001334 OR cd1 > 1001334 OR cd2 > 1001334 OR cd3 > 1001334 OR im1 > 1001334 OR im2 > 1001334 OR im3 > 1001334 OR fw1 > 1001334 OR fw2 > 1001334 OR fw3 > 1001334

SELECT * FROM club WHERE logo_pic > 30

SELECT * FROM admin_recycle_club inner join club ON admin_recycle_club.uid = club.uid

SELECT * FROM club WHERE uid LIKE '%44c58b61cc91f727003456418d2d77adf'
--UPDATE club SET stadium_capacity=1300 WHERE club_name='POTENZIA'
--UPDATE club SET uid='2f143e31ed7339fd4bf3a0fd33d6d7288e8f3d7e' WHERE club_name='BEER MONSTERS'
--UPDATE club SET uid='0' WHERE club_name='OLDHAM ATHLETIC'
--UPDATE club SET last_login=GETDATE(), latitude=0, longitude=0, devicetoken='0' WHERE uid='a73d504dfcf5b102d3bfd302ba38377e29f116cf'
UPDATE club SET tactic=0 --uid='0' WHERE uid LIKE '%a73d504dfcf5b102d3bfd302ba38377e29f116cf'

SELECT * FROM club WHERE club_name LIKE '%England boys%'
SELECT * FROM club WHERE club_id=18233 OR club_id=18099 OR club_id=23965 OR club_id=28567
SELECT * FROM player WHERE club_id=395206
--UPDATE player SET club_id=-1 WHERE club_id=18233
SELECT * FROM club WHERE uid = '3d6b0b760aedef78c169c919ef3795020d9964d8e'
DELETE transactions WHERE uid = '40a4847bc850ae0637122bfd76f65b45cf1bafc60'
EXEC usp_Reset 44766

SELECT DISTINCT [uid], COUNT([uid]) AS total FROM [admin_block] GROUP BY [uid] ORDER BY total DESC

SELECT * FROM transactions WHERE product_price>9000000

--UPDATE club SET balance=balance+1000000, revenue_others=1000000 WHERE club_id=93
--UPDATE club SET uid='0' WHERE club_id=1473
--UPDATE club SET uid='2c305c1d681a3aa46c32d6863a99015cb6aa8c4dc' WHERE club_id=6708

SELECT TOP 10 * FROM club WHERE division=6
SELECT * FROM player WHERE club_id>82705 --854,000

SELECT * FROM club WHERE balance<100000 AND uid = '0'
SELECT count(*) FROM club WHERE balance<99000 AND uid = '0'

SELECT * FROM club WHERE division=9 AND series=8

SELECT * FROM club WHERE club_id>26560 AND club_id<26638
--UPDATE club SET division=10 WHERE club_id>26560 AND club_id<26638
--DELETE FROM club WHERE game_id=1 club_id>26630 AND club_id<26638
--DELETE FROM player WHERE club_id>26630 AND club_id<26638
--DELETE FROM chat

SELECT fb_name FROM club WHERE fb_name LIKE '%[^abcdefghijklmnopqrstuvwxyz0123456789 ,_~`&.?-]%'
UPDATE club SET fb_name='' WHERE fb_name LIKE '%[^abcdefghijklmnopqrstuvwxyz0123456789 ,_~`&.?-]%'

EXEC usp_PushNewsClubs

SELECT count(*) FROM club WHERE devicetoken!='' OR devicetoken is not null

SELECT count(*) FROM club WHERE uid!='0' AND uid!='1' AND last_login < GETDATE()-30
SELECT * FROM club WHERE uid!='0' AND uid!='1' AND last_login < GETDATE()-60
--UPDATE club SET uid='0' WHERE uid!='0' AND uid!='1' AND last_login < GETDATE()-30 AND xp = 0 AND game_id = 11 

SELECT count(*) FROM club WHERE last_login > GETDATE()-30
SELECT * FROM club WHERE last_login > GETDATE()-1

SELECT * FROM club WHERE last_login < GETDATE()-365

SELECT count(*) FROM club WHERE uid = '0' AND division<15 AND longitude != 0 AND longitude != 101.6 AND latitude != 0 AND latitude != 3 AND last_login > GETDATE()-15 AND division < 5

SELECT count(*) FROM club WHERE division=66

SELECT TOP(1) * FROM club WHERE uid = '0' AND division=15 AND balance=199000

SELECT TOP(1) * FROM club WHERE division=15 AND division=15

SELECT * FROM club WHERE division=14 OR division=15 ORDER BY club_id DESC

SELECT count(*) FROM club WHERE division>30
SELECT count(*) FROM club WHERE club_id>82705 AND uid = '0'
SELECT count(*) FROM player WHERE club_id>82705

SELECT count(*) FROM club WHERE game_id = '3'

SELECT MAX(division) FROM club

SELECT count(*) FROM club WHERE division=30 AND series=15

SELECT count(*) FROM club WHERE balance < 0
--UPDATE club SET balance=balance+100000 WHERE balance < 0

SELECT count(*) FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_age > 39 AND club.uid != '0'
DELETE player FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_age > 39 AND club.uid != '0'

SELECT * FROM player WHERE player_id > 1000000 AND club_id=0

SELECT * FROM player WHERE player_value is null player_name='Cody Coleman' player_value=0
--DELETE player WHERE player_value is null

SELECT count(*) FROM match WHERE match_played=0 AND match_datetime <= GETDATE() AND match_type_id=1

SELECT * FROM match WHERE match_played=0 AND match_datetime <= GETDATE() ORDER BY match_datetime DESC

SELECT count(*) FROM match WHERE division=1
SELECT count(*) FROM match WHERE division=2
SELECT count(*) FROM match WHERE division=3
SELECT count(*) FROM match WHERE division=4
SELECT count(*) FROM match WHERE division=5
SELECT count(*) FROM match WHERE division=6
SELECT count(*) FROM match WHERE division=7
SELECT count(*) FROM match WHERE division=8
SELECT count(*) FROM match WHERE division=9
SELECT count(*) FROM match WHERE division=10
SELECT count(*) FROM match WHERE division=11
SELECT count(*) FROM match WHERE division=12
SELECT count(*) FROM match WHERE division=13
SELECT count(*) FROM match WHERE division=14
SELECT count(*) FROM match WHERE division=15
SELECT count(*) FROM match WHERE division=16
SELECT count(*) FROM match WHERE division=30

SELECT TOP 1 * FROM match WHERE division=11 AND series=625 AND season_week=8 AND match_type_id=1 AND match_played=1

SELECT TOP 1 * FROM match WHERE season_week=6 AND match_type_id=2 AND match_played=1

SELECT count(*) FROM match WHERE season_week=18 AND match_type_id=1 AND match_played=1

SELECT count(*) FROM match WHERE match_type_id>3 AND match_played=1 AND division=8
SELECT * FROM match WHERE match_type_id>3 AND match_played=0

SELECT count(*) FROM match WHERE match_type_id=3 AND match_played=0

SELECT TOP 1 * FROM match WHERE division=15 AND season_week=1 AND match_type_id=1
SELECT TOP 1 * FROM match WHERE division=10 AND season_week=18 AND match_type_id=1

SELECT * FROM match WHERE match_type_id=3 AND match_played=1 AND (club_home=30897 OR club_away=30897)

SELECT * FROM match WHERE match_type_id>1000

SELECT match_id, match_type_id, challenge_datetime, club_home, club_home_name, club_away, club_away_name FROM View_Match WHERE club_away=4 AND match_type_id = 3 AND match_played = 0 ORDER BY challenge_datetime DESC

SELECT count(*) FROM news
SELECT TOP 100 * FROM news WHERE everyone=1 ORDER BY news_datetime DESC

EXECUTE usp_PlayMatchToday

EXECUTE usp_PlayerSalesBulk

EXECUTE usp_PlayerSalesStar 1, 1
EXECUTE usp_PlayerSalesStar 2, 1
EXECUTE usp_PlayerSalesStar 3, 1
EXECUTE usp_PlayerSalesStar 4, 1
EXECUTE usp_PlayerSalesStar 5, 1
EXECUTE usp_PlayerSalesStar 6, 1
EXECUTE usp_PlayerSalesStar 7, 1
EXECUTE usp_PlayerSalesStar 8, 1
EXECUTE usp_PlayerSalesStar 9, 1

SELECT COUNT(*) FROM club
SELECT * FROM club WHERE club_id>26629 AND club_id<26640
SELECT * FROM View_ClubROWID WHERE club_id != ROWID
SELECT ROW_NUMBER() OVER (ORDER BY club_id ASC) AS ROWID, club_id FROM club WHERE club_id=26631

--EXECUTE usp_ClubResetDivisionSeriesBulk 20, 1, 625

EXECUTE usp_LeagueRankingBulk 11, 1, 625

EXECUTE usp_LeagueRanking 1, 1
SELECT club_id, club_name, division, series, league_ranking FROM club WHERE division=6 AND series=1 ORDER BY league_ranking ASC
SELECT * FROM View_Series WHERE division=6 AND series=1 ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC
SELECT * FROM View_SeriesBase WHERE division=1 AND series=1 ORDER BY Win DESC, Lose ASC, GF DESC, GA ASC

--EXECUTE usp_PromoteDemoteBulk 6, 1, 625

--EXECUTE usp_LeagueBulk '2011-04-12 00:00:00.000', 2, 1, 5
--EXECUTE usp_MatchLeagueGenerator '2011-04-12 00:00:00.000', 1, 1
--DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=1 AND division=8
--DELETE FROM match WHERE match_type_id=1 AND division=8
--DELETE FROM league

EXECUTE usp_League_NEW_Part1 --11 Hours to complete UpdateLeaguePosition must be DISABBLED!
EXECUTE usp_League_NEW_Part2 --23 Minutes

--Check league ranking is correct
SELECT * FROM club WHERE league_ranking>10

SELECT count(*) FROM club WHERE league_ranking is null
SELECT count(*) FROM club WHERE league_ranking<0
SELECT count(*) FROM club WHERE league_ranking>10
SELECT count(*) FROM club WHERE league_ranking=0
SELECT count(*) FROM club WHERE league_ranking=1
SELECT count(*) FROM club WHERE league_ranking=2
SELECT count(*) FROM club WHERE league_ranking=3
SELECT count(*) FROM club WHERE league_ranking=4
SELECT count(*) FROM club WHERE league_ranking=5
SELECT count(*) FROM club WHERE league_ranking=6
SELECT count(*) FROM club WHERE league_ranking=7
SELECT count(*) FROM club WHERE league_ranking=8
SELECT count(*) FROM club WHERE league_ranking=9
SELECT count(*) FROM club WHERE league_ranking=10

EXECUTE usp_League_NEW_Part3 --5 Minutes UpdateLeaguePosition must be DISABBLED!
EXECUTE usp_League_NEW_Part4 --8 Hours

EXECUTE usp_PromoteDemote 15, 88
EXECUTE usp_PromoteDemoteBulk 15, 89, 625
EXECUTE usp_PromoteDemoteBulk 16, 1, 625
EXECUTE usp_PromoteBulk 17, 1, 625


--EXECUTE usp_MatchCupGenerator
SELECT * FROM match WHERE match_type_id=2 ORDER BY season_week
SELECT MAX(season_week) FROM match WHERE match_type_id=2
SELECT count(*) FROM match WHERE match_type_id=2 AND match_played=0 AND season_week=(SELECT MAX(season_week) FROM match WHERE match_type_id=2)

SELECT count(*) FROM match WHERE match_type_id=2 AND match_played=1
SELECT count(*) FROM club WHERE playing_cup=1
SELECT count(*) FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=2
SELECT TOP 10 * FROM dbo.match INNER JOIN match_highlight ON match.match_id = match_highlight.match_id WHERE match.match_type_id=2
SELECT count(*) FROM club INNER JOIN match ON club.club_id = match.club_home OR club.club_id = match.club_away WHERE match.match_type_id=2 AND match_played=0
SELECT TOP 100 * FROM club INNER JOIN match ON club.club_id = match.club_away WHERE match.match_type_id=2 AND club.playing_cup=1
--UPDATE club SET club.playing_cup=0 FROM club INNER JOIN match ON club.club_id = match.club_home WHERE match.match_type_id=2
--UPDATE club SET club.playing_cup=0 FROM club INNER JOIN match ON club.club_id = match.club_away WHERE match.match_type_id=2
--DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=2
--DELETE FROM match WHERE match_type_id=2
--INSERT INTO dbo.news VALUES (getdate(), 1, 'HIJOSDEDIOS has won the CUP and received $250,000', 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
--UPDATE club SET balance=balance+500000, revenue_others=500000 WHERE club_id=40607

--EXECUTE usp_PlayerNew 14920

--UPDATE club SET last_login=GETDATE(), latitude=0, longitude=0, devicetoken='0' WHERE uid='a73d504dfcf5b102d3bfd302ba38377e29f116cf'
--UPDATE club SET stadium_status = 'Good Condition'
--UPDATE club SET stadium_capacity= 100 WHERE stadium=0 uid = '0'

UPDATE club SET club_name = LTRIM(RTRIM(club_name)) WHERE club_id=1
UPDATE club SET fan_mood = 100 WHERE fan_mood is null
UPDATE club SET teamspirit = 100 WHERE teamspirit is null
UPDATE club SET revenue_sponsors = 0 WHERE revenue_sponsors is null
UPDATE club SET revenue_total = 0 WHERE revenue_total is null
UPDATE club SET balance=balance+10000, revenue_others=10000 WHERE balance<0
UPDATE club SET fan_members=355 WHERE club_id=126

SELECT MAX(match_id) FROM match WHERE match_id < 320000 AND division=7 AND series=625
SELECT * FROM match WHERE season_week=1 ORDER BY season_week
SELECT * FROM match ORDER BY match_id
SELECT * FROM match WHERE division=6 AND series=200 ORDER BY season_week
SELECT * FROM match WHERE match_type_id = 3 AND match_played=0 AND division=1 ORDER BY season_week
--DELETE FROM match WHERE match_type_id=1 AND division=14 AND series=2
--DELETE FROM match_highlight

SELECT * FROM View_Club WHERE club_id=126 ORDER BY club_name
SELECT * FROM club WHERE club_id=1
SELECT * FROM View_Match
SELECT * FROM View_MatchHighlightPlayer
SELECT * FROM View_PlayerClub
SELECT * FROM club WHERE division=7 AND series=57 AND uid != '0' AND club_id > 39079  
SELECT * FROM product
SELECT * FROM coach
SELECT * FROM season

SELECT * FROM match_highlight WHERE match_id=1000
--DELETE FROM match_highlight WHERE match_id < 631

--EXECUTE usp_CoachNew

--EXECUTE usp_ClubNew 1, 1
--EXECUTE usp_ClubNewBulk 10, 1, 625

EXEC usp_Reset 25
EXEC usp_ResetClub '1a73d504dfcf5b102d3bfd302ba38377e29f116cf'

--UPDATE club SET club_name = UPPER(club_name)

--UPDATE club SET fb_birthday=convert(datetime, '18-06-1982', 105) WHERE club_id=21

--UPDATE club SET fb_uid='', fb_name='', fb_pic='', fb_email='', fb_url='', fb_sex='', fb_locale='', fb_birthday=convert(datetime, '01-01-1900', 105) WHERE club_id=21

--UPDATE club SET revenue_investments=0, expenses_salary=500, expenses_interest=0, revenue_total=0, expenses_total=0, balance=500000 WHERE club_id = 4069

--UPDATE club SET fan_expectation=1 WHERE club_id=126

--UPDATE club SET logo_pic=CAST(dbo.fx_generateRandomNumber(newID(), 1, 13) AS varchar(6))
--UPDATE club SET home_pic=CAST(dbo.fx_generateRandomNumber(newID(), 1, 27) AS varchar(6))
--UPDATE club SET away_pic=CAST(dbo.fx_generateRandomNumber(newID(), 1, 27) AS varchar(6))

--UPDATE club SET confidence=200 WHERE confidence > 200
--UPDATE club SET fan_mood=200 WHERE fan_mood > 200

--UPDATE club SET longitude=0, latitude=0 WHERE longitude=101.6

--UPDATE club SET uid=1 WHERE club_id=203

SELECT * FROM match_highlight
--DELETE FROM match_highlight WHERE match_id > 720

--DELETE FROM club WHERE club_id > 14060

--DELETE FROM player WHERE club_id=0 AND player_goals=1
--DELETE FROM player WHERE player_id>154660 AND player_id<1000000
SELECT * FROM player WHERE club_id=69
--UPDATE player SET club_id=69 WHERE player_id>154 AND player_id<166
--UPDATE player SET fitness = dbo.fx_generateRandomNumber(newID(), 80, 120)
--UPDATE player SET position='All', nationality=1, happiness=1000, contract_expiry=GETDATE()+366

--UPDATE player SET
--player_value=(((keeper*keeper*5)+(defend*defend*3)+(playmaking*playmaking*2)+(attack*attack*3)+(passing*passing*2)+(fitness))*10),
--player_salary=(((keeper*keeper)+(defend*defend)+(playmaking*playmaking)+(attack*attack)+(passing*passing))/10)

--EXECUTE usp_PlayerNew 0

SELECT TOP 100 * FROM news ORDER BY news_datetime DESC
DELETE FROM news WHERE marquee!=1 OR everyone!=1
DELETE FROM news WHERE marquee=1 AND everyone=1
DELETE FROM news WHERE news_id > 7048
DELETE FROM news WHERE club_id = 71
DELETE FROM news WHERE headline IS NULL

INSERT INTO dbo.news VALUES (getdate(), 1, 'Weekly Financial Update Took Place', 'Your club weekly financial has been updated.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 'Please upgrade to latest version of this game on App Store', 'Launch App Store on your iphone/ipod and check under Updates.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 'The League season is coming to an end, promotion is taking place', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 'Top 5 clubs in the series for division 6 and above will be promoted to a higher division', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 'Only Top 1 club in the series for division 5 and bellow will be promoted to a higher division', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 'All clubs bellow 5th place in the series will be demoted to a lower division', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 'HIJOSDEDIOS has won the CUP and received $250,000', 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)

--INSERT INTO dbo.news VALUES (getdate(), 1, (SELECT player_name FROM dbo.player WHERE player_id=755)+' has been injured in a match', 'Your player is injured. Hire more doctors to recover him faster.', '', 0, 100, 0, 0, 0)
SELECT * FROM news WHERE club_id = 100

SELECT * FROM View_MatchHighlightPlayer

--EXECUTE usp_Weekly

SELECT * FROM admin_name_first

SELECT * FROM admin_name_last

SELECT name FROM admin_name_last WHERE name LIKE '%[^abcdefghijklmnopqrstuvwxyz]%'
--DELETE admin_name_first WHERE name LIKE '%[^a-z]%'

SELECT * FROM admin_name_last WHERE name LIKE '%[ö]%'

SELECT * FROM View_Series WHERE division=3 AND series=2 ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC

SELECT * FROM View_Promotion WHERE division=2 ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC

SELECT TOP 5 player_id, player_name, player_age, player_salary, player_value, COUNT(player_id) AS Score FROM View_MatchHighlightPlayer WHERE (highlight_type_id = 1 OR highlight_type_id = 2) AND division = 1 AND match_type_id = 1 GROUP BY player_id, player_name, player_age, player_salary, player_value ORDER BY Score DESC

--UPDATE TOP(1) match SET match_played=1 WHERE match_datetime=convert(datetime, '09-10-2009', 105) AND match_played=0

--UPDATE match SET match_played=1 WHERE match_id=608

--UPDATE TOP(1) match SET match_played=1 WHERE match_type_id=3 AND match_played=0

--UPDATE admin_points SET definition = 'Level 23' WHERE points_id > 219

SELECT * FROM admin_points

--EXECUTE usp_AdminPoints

--UPDATE club SET uid='0', balance=99000 WHERE last_login < GETDATE()-100
--UPDATE club SET uid='0' WHERE club_id=15060
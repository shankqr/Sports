
EXECUTE usp_LeagueRankingBulk 11, 1, 625

EXECUTE usp_LeagueRanking 1, 1
SELECT club_id, club_name, division, series, league_ranking FROM club WHERE division=6 AND series=1 ORDER BY league_ranking ASC
SELECT * FROM View_Series WHERE division=6 AND series=1 ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC
SELECT * FROM View_SeriesBase WHERE division=1 AND series=1 ORDER BY Win DESC, Lose ASC, GF DESC, GA ASC

--EXECUTE usp_PromoteDemoteBulk 6, 1, 625

EXEC usp_ClubResetDivisionSeries 3, 1

--EXECUTE usp_LeagueBulk '2011-03-08 00:00:00.000', 14, 619, 625
EXECUTE usp_MatchLeagueGenerator '2011-03-01 00:00:00.000', 1, 1
--DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=1 AND division=8
--DELETE FROM match WHERE match_type_id=1 AND division=1
--DELETE FROM league

SELECT * FROM match WHERE season_week=1 AND division=1 AND (club_home=6 OR club_away=6) ORDER BY season_week

SELECT * FROM match_highlight

INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), 2, 1, 'Gold Cup', GETDATE());

SELECT count(*) FROM club WHERE division=10 AND series=9

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
SELECT count(*) FROM match WHERE division=17
SELECT count(*) FROM match WHERE division=18
SELECT count(*) FROM match WHERE division=19
SELECT count(*) FROM match WHERE division=20
SELECT count(*) FROM match WHERE division=21
SELECT count(*) FROM match WHERE division=22
SELECT count(*) FROM match WHERE division=23
SELECT count(*) FROM match WHERE division=24
SELECT count(*) FROM match WHERE division=25
SELECT count(*) FROM match WHERE division=26
SELECT count(*) FROM match WHERE division=27
SELECT count(*) FROM match WHERE division=28
SELECT count(*) FROM match WHERE division=29
SELECT count(*) FROM match WHERE division=30
SELECT count(*) FROM match WHERE division=31

SELECT count(*) FROM match WHERE division>14
--DELETE match WHERE division=8 AND series=310
--EXECUTE usp_MatchLeagueGenerator '2011-07-07 00:00:00.000', 12, 310
SELECT * FROM match WHERE division=14 AND series=618

SELECT count(*) FROM match WHERE division=12 AND series=310
SELECT * FROM match WHERE division=12 AND series=310 ORDER BY season_week

EXEC usp_MatchCheck 12, 1, 625


EXECUTE usp_ClubNewBulkBulk 11, 30


SELECT count(*) FROM club WHERE division=1
SELECT count(*) FROM club WHERE division=2
SELECT count(*) FROM club WHERE division=3
SELECT count(*) FROM club WHERE division=4
SELECT count(*) FROM club WHERE division=5
SELECT count(*) FROM club WHERE division=6
SELECT count(*) FROM club WHERE division=7
SELECT count(*) FROM club WHERE division=8
SELECT count(*) FROM club WHERE division=9
SELECT count(*) FROM club WHERE division=10
SELECT count(*) FROM club WHERE division=11
SELECT count(*) FROM club WHERE division=12
SELECT count(*) FROM club WHERE division=13
SELECT count(*) FROM club WHERE division=14
SELECT count(*) FROM club WHERE division=15
SELECT count(*) FROM club WHERE division=16
SELECT count(*) FROM club WHERE division=17
SELECT count(*) FROM club WHERE division=18
SELECT count(*) FROM club WHERE division=19
SELECT count(*) FROM club WHERE division=20
SELECT count(*) FROM club WHERE division=21
SELECT count(*) FROM club WHERE division=22
SELECT count(*) FROM club WHERE division=23
SELECT count(*) FROM club WHERE division=24
SELECT count(*) FROM club WHERE division=25
SELECT count(*) FROM club WHERE division=26
SELECT count(*) FROM club WHERE division=27
SELECT count(*) FROM club WHERE division=28
SELECT count(*) FROM club WHERE division=29
SELECT count(*) FROM club WHERE division=30
SELECT count(*) FROM club WHERE division=31

SELECT count(*) FROM club WHERE division>14
SELECT count(*) FROM club WHERE division<15 AND uid = '0'

SELECT count(*) FROM club WHERE division=11 AND series>135
SELECT count(*) FROM club WHERE division=11 AND series=140
SELECT count(*) FROM club WHERE division=12 AND series=140

SELECT count(*) FROM club WHERE uid = '0'
SELECT * FROM club WHERE uid != '0' AND division>14 AND last_login > GETDATE()-35
--UPDATE club SET division=14, series=626 WHERE division>14 AND last_login > GETDATE()-35

SELECT * FROM club WHERE division=14 AND series>618 ORDER BY series DESC
--UPDATE club SET division=0, series=0 WHERE division>14 AND series>618
--DELETE club WHERE division=0 AND series=0

SELECT count(*) FROM club WHERE division=8 --6254
SELECT count(*) FROM club WHERE division=9 --6246
SELECT count(*) FROM club WHERE division=10 --6251
SELECT count(*) FROM club WHERE division=11 --6249

SELECT * FROM Rowid_Series WHERE series!=((ROWID-1)/10)+1

SELECT * FROM club WHERE division=2 AND series=246
SELECT * FROM club WHERE division=8 AND series=247
SELECT * FROM club WHERE division=8 AND series=249
SELECT * FROM club WHERE division=8 AND series=250

SELECT * FROM club WHERE division=9 AND series=250

SELECT * FROM club WHERE division=10 AND series=247

SELECT * FROM club WHERE division=11 AND series=250

SELECT count(*) FROM club WHERE league_ranking<1 AND league_ranking>10 AND league_ranking is null

SELECT * FROM View_Series WHERE division=8 AND series=247 ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC

UPDATE league SET last_update=GETDATE() --Prevents UpdateLeaguePosition from executing on WS
EXECUTE usp_League_NEW_Part1 --11 Hours to complete UpdateLeaguePosition must be DISABBLED!
--Check league ranking is correct
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
EXECUTE usp_League_NEW_Part2 --23 Minutes
EXECUTE usp_League_NEW_Part3 --5 Minutes UpdateLeaguePosition must be DISABBLED!
EXECUTE usp_League_NEW_Part4 --8 Hours

SELECT count(*) FROM match WHERE match_type_id=1 AND season_week=18
SELECT count(*) FROM match WHERE match_type_id=1 AND season_week=18 AND match_played=1
SELECT league_round FROM season

DECLARE @d1 datetime
SET @d1 = GETDATE()+1
--EXECUTE usp_LeagueBulk @d1, 10, 1, 625

DELETE FROM league
UPDATE season SET league_round=1, league_start=@d1, league_end=GETDATE()+127
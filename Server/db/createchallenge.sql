SELECT * FROM match WHERE match_type_id=3 AND match_played=0 AND club_home=1

--DELETE FROM match WHERE match_type_id=3 AND match_played=0

SELECT TOP 10 match_id, match_type_id, match_datetime, club_home, club_home_name, club_away, club_away_name, club_winner, club_loser, home_score, away_score FROM View_Match WHERE (club_home_uid = '0a73d504dfcf5b102d3bfd302ba38377e29f116cf' OR club_away_uid = '0a73d504dfcf5b102d3bfd302ba38377e29f116cf') AND match_played = 1 ORDER BY match_datetime DESC

EXECUTE usp_MatchFriendly '0a73d504dfcf5b102d3bfd302ba38377e29f116cf' ,2 ,1000 ,1000 ,0 ,''

EXEC usp_PlayMatchBot
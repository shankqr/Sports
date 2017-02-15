SELECT * FROM bid WHERE GETUTCDATE() > bid_datetime+1 ORDER BY player_id, bid_datetime ASC

SELECT f.bid_id, f.uid, f.club_id, f.club_name, f.player_id, f.bid_value, f.bid_datetime
FROM (
SELECT player_id, MIN(bid_datetime) as mindt FROM bid GROUP BY player_id
) as x inner join bid as f on f.player_id = x.player_id and f.bid_datetime = x.mindt
WHERE GETUTCDATE() > f.bid_datetime+1

SELECT player_id, MIN(bid_datetime) FROM bid WHERE GETUTCDATE() > bid_datetime+1 GROUP BY player_id

SELECT f.bid_id, f.uid, f.club_id, f.club_name, f.player_id, f.bid_value, f.bid_datetime
FROM (
SELECT player_id, MAX(bid_value) as maxbidval FROM bid WHERE player_id=1 GROUP BY player_id
) as x inner join bid as f on f.player_id = x.player_id and f.bid_value = x.maxbidval

Declare c Cursor For 
SELECT player_id, MIN(bid_datetime) FROM bid WHERE GETUTCDATE()>bid_datetime+1 GROUP BY player_id
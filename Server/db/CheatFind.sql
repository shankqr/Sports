SELECT count(*) FROM club WHERE uid = '0'

SELECT * FROM club WHERE club_name LIKE 'THE buzzkills%' AND division=9 AND series=530
SELECT * FROM transactions WHERE uid='eddf89c92c78162927c130a72f8414b4752f8f0e' --3861
SELECT * FROM club WHERE uid LIKE '%a26406b6334ac217f33899938d61550118854d8f'
SELECT * FROM player WHERE player_id=9257 --47590
SELECT * FROM player WHERE player_name = 'Bard Darrell'
SELECT * FROM player WHERE club_id=9257 --87319, 87206 c65ce8207df0e423a88237a50672a23c40d4dce9d5b11d5e0c427860d711b453
SELECT * FROM club WHERE club_id=23846

SELECT * FROM match WHERE match_type_id=2 ORDER BY season_week AND (club_home=62841 OR club_away=62841)
SELECT * FROM club WHERE division=5 and series=596
SELECT max(match_id) from match --always plus one

--Start from 15 March 2012 basketball and baseball only
SELECT * FROM receipt WHERE uid LIKE '%09e850739c1124b608d814b38dcf0f67ad7fa2f8'

--EXEC usp_block '0c4450d0d2c66ff13e0933ca1c4a047024382de4'
--EXEC usp_ResetRemove '0c4450d0d2c66ff13e0933ca1c4a047024382de4'
--EXEC usp_Reset 25906

--11537, 54930, 75136, 65880 not in the next round of cup FFc
--52274, 62841
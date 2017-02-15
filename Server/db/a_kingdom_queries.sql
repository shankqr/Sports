
EXEC usp_MapGenerator 16, 100

EXEC usp_HeroEquip '1ae8169ef2afbdd7c8a60d37f84ba8d7d', 'hero_helmet', 102

UPDATE building_level_temp SET requirement_id=requirement_id+100

UPDATE building_level_temp SET building_id=building_id+1

UPDATE building_level_temp SET require1_building_id=11

UPDATE building_level_temp SET production=0

UPDATE building_level_temp SET capacity=0

UPDATE building_level_temp SET hero_xp=0, power=0

UPDATE building_level SET require1_building_id=require1_building_id+1 WHERE require1_building_id=100

SELECT dbo.club.*, dbo.View_Boost.* FROM dbo.club INNER JOIN dbo.View_Boost ON dbo.club.club_id = dbo.View_Boost.club_id AND dbo.club.club_id=1

SELECT club_id
, RANK() OVER(ORDER BY xp DESC) as 'rank_xp' 
, RANK() OVER(ORDER BY kills DESC) as 'rank_kills' 
, RANK() OVER(ORDER BY kills_lost DESC) as 'rank_kills_lost' 
, RANK() OVER(ORDER BY battles_won DESC) as 'rank_battles_won' 
, RANK() OVER(ORDER BY attacks_won DESC) as 'rank_attacks_won' 
, RANK() OVER(ORDER BY defenses_won DESC) as 'rank_defenses_won' 
, RANK() OVER(ORDER BY won_lost DESC) as 'rank_won_lost' 
, RANK() OVER(ORDER BY players_scouted DESC) as 'rank_players_scouted' 
FROM View_Club

UPDATE building_level_temp SET requirement_id=requirement_id+21, building_id=5, r4=r2

ISNULL((SELECT COUNT(*) AS Expr1 FROM dbo.base WHERE (queue_location = dbo.build.location) AND (queue_finish > GETUTCDATE()) AND (base_id = dbo.build.base_id)), 0)
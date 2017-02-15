SELECT achievement_type.name, achievement_type.description, achievement_type.reward, achievement_type.image_url, achievement.club_id
FROM achievement_type LEFT JOIN achievement ON achievement_type.achievement_type_id=achievement.achievement_type_id AND achievement.club_id=7
ORDER BY achievement_type.achievement_type_id
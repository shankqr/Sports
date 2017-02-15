SELECT news.news_datetime, news.headline, club.game_id, club.devicetoken FROM news inner join club ON news.club_id=club.club_id 
WHERE club.devicetoken!='(null)' AND club.devicetoken!='' AND club.devicetoken!='0' AND club.uid!='0' AND club.uid!='1' 
AND news.push=1 AND news.news_datetime>GETDATE()-1

SELECT * FROM news inner join club 
ON (news.division=club.division AND news.series=club.series) 
WHERE club.devicetoken!='(null)' AND club.devicetoken!='' AND club.devicetoken!='0' AND club.uid!='0' AND club.uid!='1' 
AND news.push=1 AND news.news_datetime>GETDATE()-1
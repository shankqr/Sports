USE [hm]
GO
/****** Object:  StoredProcedure [dbo].[usp_Bid]    Script Date: 07/13/2011 17:39:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2012
-- Description:	Bid
-- =============================================
ALTER PROCEDURE [dbo].[usp_Bid]
AS
BEGIN
DECLARE @bid_id int, @bid_date varchar(100), @bid_value int, @player_id int, @bid_date_min varchar(100), 
@club_id int, @club_uid varchar(100), @club_name varchar(100), 
@vclub_id int, @vclub_name varchar(100), @club_balance int, 
@headline varchar(1000), @news varchar(1000)

Declare c Cursor For 
SELECT player_id, MIN(bid_datetime) FROM bid WHERE GETUTCDATE()>bid_datetime+1 GROUP BY player_id

Open c
Fetch next From c into @player_id, @bid_date_min
While @@Fetch_Status=0
Begin

SELECT @bid_id=f.bid_id, @club_uid=f.[uid], @club_id=f.club_id, @club_name=f.club_name, 
@bid_value=f.bid_value, @bid_date=f.bid_datetime
FROM (
SELECT player_id, MAX(bid_value) as maxbidval FROM bid WHERE player_id=@player_id GROUP BY player_id
) as x inner join bid as f on f.player_id = x.player_id and f.bid_value = x.maxbidval

SELECT @vclub_id=club_id, @vclub_name=club_name, @club_balance=balance FROM club WHERE [uid]=@club_uid

IF(@club_id=@vclub_id AND @club_name=@vclub_name AND @club_balance>@bid_value)
BEGIN
	UPDATE player SET club_id=@club_id WHERE player_id=@player_id
	
	UPDATE club SET balance=balance-@bid_value, 
	expenses_purchases=expenses_purchases+@bid_value,
	expenses_total=expenses_total+@bid_value
	WHERE club_id=@club_id
	
	SET @headline='Congratulations! You have won the bid for player.';
	SET @news='The Board of Directors and Fans are happy with your purchase!';
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0)
	
	DELETE bid WHERE player_id=@player_id
END
ELSE
BEGIN
	DELETE bid WHERE bid_id=@bid_id
END

Fetch next From c into @player_id, @bid_date_min

End
Close c
Deallocate c

END
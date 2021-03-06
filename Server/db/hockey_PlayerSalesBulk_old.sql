USE [hockey]
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerSalesBulk]    Script Date: 1/25/2014 5:51:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2010
-- Description:	Add 10 new players for sale
-- =============================================
ALTER PROCEDURE [dbo].[usp_PlayerSalesBulk]
AS
BEGIN

DECLARE @total_player1GK int, @total_player2GK int, @total_player3GK int, @total_player4GK int, @total_player5GK int, 
@total_player6GK int, @total_player7GK int, @total_player8GK int, @total_player9GK int, @total_player10GK int

SET @total_player1GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 1
END

IF @total_player2GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 2
END

IF @total_player3GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 3
END

IF @total_player4GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 4
END

IF @total_player5GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 5
END

IF @total_player6GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 6
END

IF @total_player7GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 7
END

IF @total_player8GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 8
END

DECLARE @total_player1DLR int, @total_player2DLR int, @total_player3DLR int, @total_player4DLR int, @total_player5DLR int, 
@total_player6DLR int, @total_player7DLR int, @total_player8DLR int, @total_player9DLR int, @total_player10DLR int

SET @total_player1DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10DLR = ISNULL((SELECT count(*) FROM player WHERE position='DEF' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 1
END

IF @total_player2DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 2
END

IF @total_player3DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 3
END

IF @total_player4DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 4
END

IF @total_player5DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 5
END

IF @total_player6DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 6
END

IF @total_player7DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 7
END

IF @total_player8DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 8
END


DECLARE @total_player1DC int, @total_player2DC int, @total_player3DC int, @total_player4DC int, @total_player5DC int, 
@total_player6DC int, @total_player7DC int, @total_player8DC int, @total_player9DC int, @total_player10DC int

SET @total_player1DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10DC = ISNULL((SELECT count(*) FROM player WHERE position='CTR' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 1
END

IF @total_player2DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 2
END

IF @total_player3DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 3
END

IF @total_player4DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 4
END

IF @total_player5DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 5
END

IF @total_player6DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 6
END

IF @total_player7DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 7
END

IF @total_player8DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 8
END


DECLARE @total_player1MLR int, @total_player2MLR int, @total_player3MLR int, @total_player4MLR int, @total_player5MLR int, 
@total_player6MLR int, @total_player7MLR int, @total_player8MLR int, @total_player9MLR int, @total_player10MLR int

SET @total_player1MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10MLR = ISNULL((SELECT count(*) FROM player WHERE position='FWD' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 1
END

IF @total_player2MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 2
END

IF @total_player3MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 3
END

IF @total_player4MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 4
END

IF @total_player5MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 5
END

IF @total_player6MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 6
END

IF @total_player7MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 7
END

IF @total_player8MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 8
END


DECLARE @total_player1MC int, @total_player2MC int, @total_player3MC int, @total_player4MC int, @total_player5MC int, 
@total_player6MC int, @total_player7MC int, @total_player8MC int, @total_player9MC int, @total_player10MC int

SET @total_player1MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10MC = ISNULL((SELECT count(*) FROM player WHERE position='WNG' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 1
END

IF @total_player2MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 2
END

IF @total_player3MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 3
END

IF @total_player4MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 4
END

IF @total_player5MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 5
END

IF @total_player6MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 6
END

IF @total_player7MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 7
END

IF @total_player8MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 8
END


END

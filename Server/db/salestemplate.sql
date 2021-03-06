USE [ffc]
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerSalesBulk]    Script Date: 08/09/2011 14:42:06 ******/
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

IF @total_player9GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 9
END

IF @total_player10GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 10
END

DECLARE @total_player1DLR int, @total_player2DLR int, @total_player3DLR int, @total_player4DLR int, @total_player5DLR int, 
@total_player6DLR int, @total_player7DLR int, @total_player8DLR int, @total_player9DLR int, @total_player10DLR int

SET @total_player1DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=10 AND club_id=-1), 0);

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

IF @total_player9DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 9
END

IF @total_player10DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 10
END

DECLARE @total_player1DC int, @total_player2DC int, @total_player3DC int, @total_player4DC int, @total_player5DC int, 
@total_player6DC int, @total_player7DC int, @total_player8DC int, @total_player9DC int, @total_player10DC int

SET @total_player1DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=10 AND club_id=-1), 0);

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

IF @total_player9DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 9
END

IF @total_player10DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 10
END

DECLARE @total_player1MLR int, @total_player2MLR int, @total_player3MLR int, @total_player4MLR int, @total_player5MLR int, 
@total_player6MLR int, @total_player7MLR int, @total_player8MLR int, @total_player9MLR int, @total_player10MLR int

SET @total_player1MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=10 AND club_id=-1), 0);

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

IF @total_player9MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 9
END

IF @total_player10MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 10
END

DECLARE @total_player1MC int, @total_player2MC int, @total_player3MC int, @total_player4MC int, @total_player5MC int, 
@total_player6MC int, @total_player7MC int, @total_player8MC int, @total_player9MC int, @total_player10MC int

SET @total_player1MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=10 AND club_id=-1), 0);

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

IF @total_player9MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 9
END

IF @total_player10MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 10
END

DECLARE @total_player1SC int, @total_player2SC int, @total_player3SC int, @total_player4SC int, @total_player5SC int, 
@total_player6SC int, @total_player7SC int, @total_player8SC int, @total_player9SC int, @total_player10SC int

SET @total_player1SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 1
END

IF @total_player2SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 2
END

IF @total_player3SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 3
END

IF @total_player4SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 4
END

IF @total_player5SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 5
END

IF @total_player6SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 6
END

IF @total_player7SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 7
END

IF @total_player8SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 8
END

IF @total_player9SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 9
END

IF @total_player10SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 10
END

DECLARE @total_player1DMLR int, @total_player2DMLR int, @total_player3DMLR int, @total_player4DMLR int, @total_player5DMLR int, 
@total_player6DMLR int, @total_player7DMLR int, @total_player8DMLR int, @total_player9DMLR int, @total_player10DMLR int

SET @total_player1DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 1
END

IF @total_player2DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 2
END

IF @total_player3DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 3
END

IF @total_player4DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 4
END

IF @total_player5DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 5
END

IF @total_player6DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 6
END

IF @total_player7DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 7
END

IF @total_player8DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 8
END

IF @total_player9DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 9
END

IF @total_player10DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 10
END

DECLARE @total_player1DMC int, @total_player2DMC int, @total_player3DMC int, @total_player4DMC int, @total_player5DMC int, 
@total_player6DMC int, @total_player7DMC int, @total_player8DMC int, @total_player9DMC int, @total_player10DMC int

SET @total_player1DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 1
END

IF @total_player2DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 2
END

IF @total_player3DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 3
END

IF @total_player4DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 4
END

IF @total_player5DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 5
END

IF @total_player6DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 6
END

IF @total_player7DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 7
END

IF @total_player8DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 8
END

IF @total_player9DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 9
END

IF @total_player10DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 10
END

DECLARE @total_player1AMLR int, @total_player2AMLR int, @total_player3AMLR int, @total_player4AMLR int, @total_player5AMLR int, 
@total_player6AMLR int, @total_player7AMLR int, @total_player8AMLR int, @total_player9AMLR int, @total_player10AMLR int

SET @total_player1AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 1
END

IF @total_player2AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 2
END

IF @total_player3AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 3
END

IF @total_player4AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 4
END

IF @total_player5AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 5
END

IF @total_player6AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 6
END

IF @total_player7AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 7
END

IF @total_player8AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 8
END

IF @total_player9AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 9
END

IF @total_player10AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 10
END

DECLARE @total_player1AMC int, @total_player2AMC int, @total_player3AMC int, @total_player4AMC int, @total_player5AMC int, 
@total_player6AMC int, @total_player7AMC int, @total_player8AMC int, @total_player9AMC int, @total_player10AMC int

SET @total_player1AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=1 AND club_id=-1), 0);
SET @total_player2AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player3AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=3 AND club_id=-1), 0);
SET @total_player4AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player5AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=5 AND club_id=-1), 0);
SET @total_player6AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player7AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=7 AND club_id=-1), 0);
SET @total_player8AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=8 AND club_id=-1), 0);
SET @total_player9AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=9 AND club_id=-1), 0);
SET @total_player10AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=10 AND club_id=-1), 0);

IF @total_player1AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 1
END

IF @total_player2AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 2
END

IF @total_player3AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 3
END

IF @total_player4AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 4
END

IF @total_player5AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 5
END

IF @total_player6AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 6
END

IF @total_player7AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 7
END

IF @total_player8AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 8
END

IF @total_player9AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 9
END

IF @total_player10AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 10
END

END

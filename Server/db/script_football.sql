USE [master]
GO
/****** Object:  Database [football]    Script Date: 2/14/2017 9:10:10 PM ******/
CREATE DATABASE [football]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SQL2008_650940_ffc_data', FILENAME = N'C:\Data\football.mdf' , SIZE = 2947904KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SQL2008_650940_ffc_log', FILENAME = N'C:\Data\football.ldf' , SIZE = 2377088KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [football] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [football].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [football] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [football] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [football] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [football] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [football] SET ARITHABORT OFF 
GO
ALTER DATABASE [football] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [football] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [football] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [football] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [football] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [football] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [football] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [football] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [football] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [football] SET  DISABLE_BROKER 
GO
ALTER DATABASE [football] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [football] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [football] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [football] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [football] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [football] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [football] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [football] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [football] SET  MULTI_USER 
GO
ALTER DATABASE [football] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [football] SET DB_CHAINING OFF 
GO
ALTER DATABASE [football] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [football] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [football] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'football', N'ON'
GO
ALTER DATABASE [football] SET QUERY_STORE = OFF
GO
USE [football]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [football]
GO
/****** Object:  UserDefinedFunction [dbo].[fx_convertVarcharHexToDec]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fx_convertVarcharHexToDec] 
(@varHex varchar(8))
RETURNS int
AS
BEGIN
	
declare @val_int int
declare @val_hex varchar(10)

set @val_hex = @varHex

--convert hex-varchar to integer.
set @val_int =
      ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),1,1),'0123456789ABCDEF')-1)*power(16,7))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),2,1),'0123456789ABCDEF')-1)*power(16,6))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),3,1),'0123456789ABCDEF')-1)*power(16,5))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),4,1),'0123456789ABCDEF')-1)*power(16,4))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),5,1),'0123456789ABCDEF')-1)*power(16,3))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),6,1),'0123456789ABCDEF')-1)*power(16,2))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),7,1),'0123456789ABCDEF')-1)*power(16,1))
    + ((charindex(substring(right('00000000'+substring(@val_hex,3,8),
            8),8,1),'0123456789ABCDEF')-1)*power(16,0))
--display.
return @val_int
END
GO
/****** Object:  UserDefinedFunction [dbo].[fx_generateRandomNumber]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fx_generateRandomNumber](
	@guid as uniqueidentifier, 
	@intMin int =  0, 
	@intMax int = 10  )
RETURNS int
AS
BEGIN
	
	declare @tmp1 as int
	declare @tmp2 as numeric(10,3) 
	declare @tmp3 as numeric(10,3)

set @tmp1 = dbo.fx_convertVarcharHexToDec('0x' + right(cast
(@guid as varchar(64)), 2)) 	

set @tmp2 = (@intMax - @intMin) / cast(255 as  numeric(10,3))	
--filter factor

set @tmp3 = (@tmp1 * @tmp2) + @intMin
	
return cast(round(@tmp3, 0) as int)

END
GO
/****** Object:  UserDefinedFunction [dbo].[fx_minOf]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fx_minOf]
(@Param1 Integer, @Param2 Integer)
Returns Integer 
As
BEGIN
Return(Select Case When @Param1 < @Param2 
                   Then @Param1 Else @Param2 End MinValue)
END
GO
/****** Object:  Table [dbo].[club]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[club](
	[club_id] [bigint] NOT NULL,
	[game_id] [varchar](10) NULL,
	[uid] [varchar](50) NOT NULL,
	[club_name] [nvarchar](max) NULL,
	[last_login] [datetime] NULL,
	[date_found] [datetime] NULL,
	[email] [varchar](50) NULL,
	[password] [varchar](50) NULL,
	[email_verified] [int] NULL,
	[division] [int] NULL,
	[series] [int] NULL,
	[balance] [bigint] NULL,
	[currency_second] [int] NULL,
	[xp] [int] NULL,
	[xp_gain] [int] NULL,
	[xp_history] [int] NULL,
	[xp_gain_a] [int] NULL,
	[xp_history_a] [int] NULL,
	[energy] [int] NULL,
	[e] [int] NULL,
	[alliance_id] [bigint] NULL,
	[face_pic] [varchar](250) NULL,
	[fb_pic] [varchar](250) NULL,
	[fb_id] [varchar](250) NULL,
	[fb_name] [varchar](250) NULL,
	[fb_username] [varchar](250) NULL,
	[fb_gender] [varchar](50) NULL,
	[fb_timezone] [varchar](50) NULL,
	[fan_members] [int] NULL,
	[longitude] [float] NULL,
	[latitude] [float] NULL,
	[playing_cup] [bit] NOT NULL,
	[league_ranking] [int] NULL,
	[undefeated_counter] [int] NULL,
	[fan_mood] [int] NULL,
	[stadium_status] [varchar](50) NULL,
	[stadium_capacity] [int] NULL,
	[stadium] [int] NULL,
	[average_ticket] [int] NULL,
	[stadium_finish_upgrade] [datetime] NULL,
	[managers] [int] NULL,
	[scouts] [int] NULL,
	[spokespersons] [int] NULL,
	[coaches] [int] NULL,
	[psychologists] [int] NULL,
	[accountants] [int] NULL,
	[physiotherapists] [int] NULL,
	[doctors] [int] NULL,
	[coach_id] [int] NULL,
	[training] [int] NULL,
	[teamspirit] [int] NULL,
	[confidence] [int] NULL,
	[tactic] [int] NULL,
	[formation] [int] NULL,
	[gk] [int] NULL,
	[rb] [int] NULL,
	[lb] [int] NULL,
	[rw] [int] NULL,
	[lw] [int] NULL,
	[cd1] [int] NULL,
	[cd2] [int] NULL,
	[cd3] [int] NULL,
	[im1] [int] NULL,
	[im2] [int] NULL,
	[im3] [int] NULL,
	[fw1] [int] NULL,
	[fw2] [int] NULL,
	[fw3] [int] NULL,
	[sgk] [int] NULL,
	[sd] [int] NULL,
	[sim] [int] NULL,
	[sfw] [int] NULL,
	[sw] [int] NULL,
	[captain] [int] NULL,
	[penalty] [int] NULL,
	[freekick] [int] NULL,
	[cornerkick] [int] NULL,
	[revenue_stadium] [int] NULL,
	[revenue_sponsors] [int] NULL,
	[revenue_sales] [int] NULL,
	[revenue_investments] [int] NULL,
	[revenue_others] [int] NULL,
	[revenue_total] [int] NULL,
	[expenses_stadium] [int] NULL,
	[expenses_salary] [int] NULL,
	[expenses_purchases] [int] NULL,
	[expenses_interest] [int] NULL,
	[expenses_others] [int] NULL,
	[expenses_total] [int] NULL,
	[devicetoken] [varchar](100) NULL,
	[logo_pic] [varchar](250) NULL,
	[home_pic] [varchar](250) NULL,
	[away_pic] [varchar](250) NULL,
	[building1] [int] NULL,
	[building1_dt] [datetime] NULL,
	[building2] [int] NULL,
	[building2_dt] [datetime] NULL,
	[building3] [int] NULL,
	[building3_dt] [datetime] NULL,
 CONSTRAINT [PK_club] PRIMARY KEY CLUSTERED 
(
	[club_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[alliance]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alliance](
	[alliance_id] [bigint] IDENTITY(1,1) NOT NULL,
	[leader_id] [bigint] NOT NULL,
	[leader_name] [nvarchar](max) NULL,
	[name] [nvarchar](max) NULL,
	[date_found] [datetime] NULL,
	[alliance_level] [int] NULL,
	[currency_first] [int] NULL,
	[currency_second] [int] NULL,
	[leader_firstname] [nvarchar](max) NULL,
	[leader_secondname] [nvarchar](max) NULL,
	[logo_id] [int] NULL,
	[flag_id] [int] NULL,
	[fanpage_url] [nvarchar](max) NULL,
	[introduction_text] [nvarchar](max) NULL,
	[cup_name] [nvarchar](max) NULL,
	[cup_first_prize] [int] NULL,
	[cup_second_prize] [int] NULL,
	[cup_start] [datetime] NULL,
	[cup_round] [int] NULL,
	[cup_totalround] [int] NULL,
	[cup_first_id] [int] NULL,
	[cup_first_name] [nvarchar](max) NULL,
	[cup_second_id] [int] NULL,
	[cup_second_name] [nvarchar](max) NULL,
 CONSTRAINT [PK_alliance] PRIMARY KEY CLUSTERED 
(
	[alliance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_Alliance]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Alliance]
AS
SELECT     alliance_id, leader_id, leader_name, name, date_found, alliance_level, currency_first, currency_second, leader_firstname, leader_secondname, logo_id, flag_id, 
                      fanpage_url, introduction_text, cup_name, cup_first_prize, cup_second_prize, cup_start, cup_round, cup_totalround, cup_first_id, cup_first_name, cup_second_id, 
                      cup_second_name,
                          (SELECT     COUNT(*) AS Expr1
                            FROM          dbo.club
                            WHERE      (alliance_id = dbo.alliance.alliance_id)) AS total_members,
                          (SELECT     SUM(CAST(SQRT(xp / 10) AS INT) + 1) AS Expr2
                            FROM          dbo.club AS club_1
                            WHERE      (alliance_id = dbo.alliance.alliance_id)) AS score
FROM         dbo.alliance

GO
/****** Object:  Table [dbo].[coach]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coach](
	[coach_id] [int] NOT NULL,
	[coach_name] [varchar](250) NULL,
	[coach_leadership] [int] NULL,
	[coach_skill] [int] NULL,
	[coach_desc] [varchar](max) NULL,
	[coach_age] [int] NULL,
	[coach_star] [int] NULL,
	[coach_salary] [int] NULL,
	[coach_value] [int] NULL,
 CONSTRAINT [PK_coach] PRIMARY KEY CLUSTERED 
(
	[coach_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_Club]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Club]
AS
SELECT     club_id, game_id, uid, club_name, last_login, date_found, longitude, latitude, playing_cup, division, series, league_ranking, undefeated_counter, fan_members, 
                      fan_mood, stadium_status, stadium_capacity, average_ticket, stadium_finish_upgrade, stadium, managers, scouts, spokespersons, coaches, psychologists, 
                      accountants, physiotherapists, doctors, coach_id,
                          (SELECT     coach_name
                            FROM          dbo.coach
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_name,
                          (SELECT     coach_leadership
                            FROM          dbo.coach AS coach_1
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_leadership,
                          (SELECT     coach_skill
                            FROM          dbo.coach AS coach_2
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_skill,
                          (SELECT     coach_desc
                            FROM          dbo.coach AS coach_3
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_desc,
                          (SELECT     coach_age
                            FROM          dbo.coach AS coach_4
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_age,
                          (SELECT     coach_star
                            FROM          dbo.coach AS coach_5
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_star,
                          (SELECT     coach_salary
                            FROM          dbo.coach AS coach_6
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_salary,
                          (SELECT     coach_value
                            FROM          dbo.coach AS coach_7
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_value, training, teamspirit, confidence, tactic, formation, gk, rb, lb, rw, lw, cd1, cd2, cd3, im1, im2, im3, fw1, fw2, 
                      fw3, sgk, sd, sim, sfw, sw, captain, penalty, freekick, cornerkick, revenue_stadium, revenue_sponsors, revenue_sales, revenue_investments, revenue_others, 
                      revenue_total, expenses_stadium, expenses_salary, expenses_purchases, expenses_interest, expenses_others, expenses_total, balance, fb_name, fb_timezone, 
                      fb_id, fb_gender, fb_username, face_pic, logo_pic, home_pic, away_pic, energy, xp, xp_gain, xp_history, e, building1, building1_dt, building2, building2_dt, building3, 
                      building3_dt, currency_second, alliance_id, fb_pic,
                          (SELECT     name
                            FROM          dbo.alliance
                            WHERE      (alliance_id = dbo.club.alliance_id)) AS alliance_name
FROM         dbo.club

GO
/****** Object:  Table [dbo].[match]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[match](
	[match_id] [bigint] IDENTITY(1,1) NOT NULL,
	[match_played] [bit] NOT NULL,
	[match_type_id] [int] NULL,
	[match_datetime] [datetime] NULL,
	[season_week] [int] NULL,
	[club_home] [bigint] NULL,
	[club_away] [bigint] NULL,
	[season_id] [int] NULL,
	[division] [int] NULL,
	[series] [int] NULL,
	[weather_id] [int] NULL,
	[spectators] [int] NULL,
	[stadium_overflow] [int] NULL,
	[ticket_sales] [int] NULL,
	[club_winner] [bigint] NULL,
	[club_loser] [bigint] NULL,
	[home_possession] [int] NULL,
	[away_possession] [int] NULL,
	[home_score] [int] NULL,
	[away_score] [int] NULL,
	[home_score_different] [int] NULL,
	[away_score_different] [int] NULL,
	[home_formation] [int] NULL,
	[away_formation] [int] NULL,
	[home_tactic] [int] NULL,
	[away_tactic] [int] NULL,
	[home_teamspirit] [int] NULL,
	[away_teamspirit] [int] NULL,
	[home_confidence] [int] NULL,
	[away_confidence] [int] NULL,
	[challenge_datetime] [datetime] NULL,
	[challenge_note] [nvarchar](1000) NULL,
	[challenge_win] [int] NULL,
	[challenge_lose] [int] NULL,
	[challenge_draw] [int] NULL,
 CONSTRAINT [PK_match] PRIMARY KEY CLUSTERED 
(
	[match_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_SeriesBase]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_SeriesBase]
AS
SELECT DISTINCT TOP (100) PERCENT dbo.club.club_id, dbo.club.club_name, dbo.club.division, dbo.club.series,
                          (SELECT     COUNT(match_id) AS Expr1
                            FROM          dbo.match AS match_1
                            WHERE      (match_type_id = 1) AND (match_played = 1) AND (club_home = dbo.club.club_id) OR
                                                   (match_type_id = 1) AND (match_played = 1) AND (club_away = dbo.club.club_id)) AS Played,
                          (SELECT     COUNT(match_id) AS Expr1
                            FROM          dbo.match AS match_2
                            WHERE      (match_type_id = 1) AND (match_played = 1) AND (club_winner = dbo.club.club_id)) AS Win,
                          (SELECT     COUNT(match_id) AS Expr1
                            FROM          dbo.match AS match_3
                            WHERE      (match_type_id = 1) AND (match_played = 1) AND (club_loser = dbo.club.club_id)) AS Lose, ISNULL
                          ((SELECT     SUM(home_score) AS Expr1
                              FROM         dbo.match AS match_4
                              WHERE     (match_type_id = 1) AND (match_played = 1) AND (club_home = dbo.club.club_id)), 0) + ISNULL
                          ((SELECT     SUM(away_score) AS Expr1
                              FROM         dbo.match AS match_5
                              WHERE     (match_type_id = 1) AND (match_played = 1) AND (club_away = dbo.club.club_id)), 0) AS GF, ISNULL
                          ((SELECT     SUM(away_score) AS Expr1
                              FROM         dbo.match AS match_6
                              WHERE     (match_type_id = 1) AND (match_played = 1) AND (club_home = dbo.club.club_id)), 0) + ISNULL
                          ((SELECT     SUM(home_score) AS Expr1
                              FROM         dbo.match AS match_7
                              WHERE     (match_type_id = 1) AND (match_played = 1) AND (club_away = dbo.club.club_id)), 0) AS GA
FROM         dbo.match INNER JOIN
                      dbo.club ON (dbo.match.club_home = dbo.club.club_id OR
                      dbo.match.club_away = dbo.club.club_id) AND dbo.match.match_type_id = 1

GO
/****** Object:  View [dbo].[View_Series]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Series]
AS
SELECT     club_id, club_name, division, series, Played, Win, Lose, GF, GA, Played - Win - Lose AS Draw, GF - GA AS GD, Win * 3 + (Played - Win - Lose) AS Pts
FROM         dbo.View_SeriesBase

GO
/****** Object:  View [dbo].[View_Match]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Match]
AS
SELECT     match_id, match_played, match_type_id, match_datetime, season_id, season_week, division, series, weather_id, spectators, stadium_overflow, ticket_sales, 
                      club_home,
                          (SELECT     uid
                            FROM          dbo.club AS club_2
                            WHERE      (dbo.match.club_home = club_id)) AS club_home_uid,
                          (SELECT     club_name
                            FROM          dbo.club
                            WHERE      (dbo.match.club_home = club_id)) AS club_home_name, club_away,
                          (SELECT     uid
                            FROM          dbo.club AS club_2
                            WHERE      (dbo.match.club_away = club_id)) AS club_away_uid,
                          (SELECT     club_name
                            FROM          dbo.club AS club_1
                            WHERE      (dbo.match.club_away = club_id)) AS club_away_name, club_winner, club_loser, home_possession, away_possession, home_score, away_score, 
                      home_score_different, away_score_different, home_formation, away_formation, home_tactic, away_tactic, home_teamspirit, away_teamspirit, home_confidence, 
                      away_confidence, challenge_datetime, challenge_note, challenge_win, challenge_lose, challenge_draw
FROM         dbo.match

GO
/****** Object:  View [dbo].[Rowid_Series]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Rowid_Series]
AS
SELECT     ROW_NUMBER() OVER (ORDER BY series ASC) AS ROWID, club_id, division, series
FROM         club
WHERE     division = 8

GO
/****** Object:  View [dbo].[View_Promotion]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Promotion]
AS
SELECT     f.club_id, f.club_name, f.division, f.series, f.Played, f.Win, f.Draw, f.Lose, f.GF, f.GA, f.GD, f.Pts
FROM         (SELECT     division, series, MAX(Pts) AS Pts
                       FROM          dbo.View_Series
                       GROUP BY division, series) AS x INNER JOIN
                      dbo.View_Series AS f ON f.division = x.division AND f.series = x.series AND f.Pts = x.Pts
GO
/****** Object:  Table [dbo].[player]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[player](
	[player_id] [bigint] NOT NULL,
	[club_id] [bigint] NULL,
	[position] [varchar](50) NULL,
	[player_name] [nvarchar](max) NULL,
	[player_age] [int] NULL,
	[player_goals] [int] NULL,
	[player_salary] [int] NULL,
	[player_value] [int] NULL,
	[player_condition] [int] NULL,
	[player_condition_days] [int] NULL,
	[card_yellow] [int] NULL,
	[card_red] [int] NULL,
	[nationality] [int] NULL,
	[contract_expiry] [date] NULL,
	[happiness] [real] NULL,
	[keeper] [real] NULL,
	[defend] [real] NULL,
	[playmaking] [real] NULL,
	[attack] [real] NULL,
	[passing] [real] NULL,
	[fitness] [real] NULL,
 CONSTRAINT [PK_player_1] PRIMARY KEY CLUSTERED 
(
	[player_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[match_highlight]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[match_highlight](
	[highlight_id] [bigint] IDENTITY(1,1) NOT NULL,
	[match_id] [bigint] NULL,
	[match_minute] [int] NULL,
	[player_id] [bigint] NULL,
	[highlight_type_id] [int] NULL,
	[highlight] [varchar](max) NULL,
 CONSTRAINT [PK_match_highlight] PRIMARY KEY CLUSTERED 
(
	[highlight_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_MatchHighlightPlayer]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_MatchHighlightPlayer]
AS
SELECT     dbo.match_highlight.highlight_id, dbo.match_highlight.match_id, dbo.match_highlight.match_minute, dbo.match_highlight.player_id, 
                      dbo.match_highlight.highlight_type_id, dbo.match_highlight.highlight, dbo.match.season_id, dbo.match.season_week, dbo.match.division, 
                      dbo.match.series, dbo.match.match_type_id, dbo.match.club_away, dbo.match.club_home, dbo.match.match_datetime, dbo.player.club_id, 
                      dbo.player.player_name, dbo.player.player_goals, dbo.player.player_age, dbo.player.player_salary, dbo.player.player_value
FROM         dbo.match INNER JOIN
                      dbo.match_highlight ON dbo.match.match_id = dbo.match_highlight.match_id INNER JOIN
                      dbo.player ON dbo.match_highlight.player_id = dbo.player.player_id

GO
/****** Object:  View [dbo].[View_AllianceEvent]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AllianceEvent]
AS
SELECT     alliance_id, name,
                          (SELECT     SUM(xp_gain_a) AS Expr2
                            FROM          dbo.club AS club_1
                            WHERE      (alliance_id = dbo.alliance.alliance_id)) AS xp_gain
FROM         dbo.alliance

GO
/****** Object:  View [dbo].[View_PlayerClub]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PlayerClub]
AS
SELECT     dbo.player.player_id, dbo.player.club_id, dbo.player.player_name, dbo.player.player_age, dbo.player.player_goals, dbo.player.player_salary, 
                      dbo.player.player_value, dbo.player.player_condition, dbo.player.player_condition_days, dbo.player.card_yellow, dbo.player.card_red, 
                      dbo.player.keeper, dbo.player.defend, dbo.player.playmaking, dbo.player.attack, dbo.player.passing, dbo.player.fitness, dbo.View_Club.club_name, 
                      dbo.View_Club.division, dbo.View_Club.series, dbo.View_Club.playing_cup, dbo.View_Club.managers, dbo.View_Club.coaches, dbo.View_Club.doctors, 
                      dbo.View_Club.coach_skill, dbo.View_Club.training
FROM         dbo.player INNER JOIN
                      dbo.View_Club ON dbo.player.club_id = dbo.View_Club.club_id

GO
/****** Object:  View [dbo].[View_ClubROWID]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ClubROWID]
AS
SELECT ROW_NUMBER() OVER (ORDER BY club_id ASC) AS ROWID, club_id FROM club

GO
/****** Object:  View [dbo].[View_ClubInfo]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ClubInfo]
AS
SELECT     club_id, date_found, club_name, coach_id, stadium, balance, revenue_sponsors, fan_members, xp, division, series, league_ranking, longitude, latitude, home_pic, 
                      away_pic, logo_pic, fb_pic, fb_name, alliance_id,
                          (SELECT     name
                            FROM          dbo.alliance
                            WHERE      (alliance_id = dbo.club.alliance_id)) AS alliance_name, xp_gain, xp_history
FROM         dbo.club

GO
/****** Object:  View [dbo].[View_AllianceEventResult]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AllianceEventResult]
AS
SELECT     alliance_id, name,
                          (SELECT     SUM(xp_history_a) AS Expr2
                            FROM          dbo.club AS club_1
                            WHERE      (alliance_id = dbo.alliance.alliance_id)) AS xp_gain
FROM         dbo.alliance

GO
/****** Object:  Table [dbo].[achievement]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[achievement](
	[achievement_id] [bigint] IDENTITY(1,1) NOT NULL,
	[club_id] [bigint] NOT NULL,
	[achievement_type_id] [int] NOT NULL,
	[claimed] [bit] NOT NULL,
 CONSTRAINT [PK_achievements] PRIMARY KEY CLUSTERED 
(
	[achievement_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[achievement_type]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[achievement_type](
	[achievement_type_id] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](500) NOT NULL,
	[reward] [int] NOT NULL,
	[image_url] [varchar](500) NOT NULL,
	[tutorial] [varchar](max) NULL,
	[valid] [bit] NOT NULL,
 CONSTRAINT [PK_achievement_type] PRIMARY KEY CLUSTERED 
(
	[achievement_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[admin_character]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin_character](
	[character_id] [int] NOT NULL,
	[character] [varchar](1000) NULL,
 CONSTRAINT [PK_admin_character] PRIMARY KEY CLUSTERED 
(
	[character_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[admin_name_first]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin_name_first](
	[name] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[admin_name_last]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin_name_last](
	[name] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[alliance_apply]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alliance_apply](
	[apply_id] [bigint] IDENTITY(1,1) NOT NULL,
	[alliance_id] [bigint] NOT NULL,
	[club_id] [bigint] NOT NULL,
	[club_name] [nvarchar](max) NULL,
	[date_posted] [datetime] NULL,
 CONSTRAINT [PK_alliance_apply] PRIMARY KEY CLUSTERED 
(
	[apply_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[alliance_donation]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alliance_donation](
	[donation_id] [bigint] IDENTITY(1,1) NOT NULL,
	[alliance_id] [bigint] NOT NULL,
	[club_id] [bigint] NOT NULL,
	[club_name] [nvarchar](max) NULL,
	[currency_first] [int] NULL,
	[currency_second] [int] NULL,
	[date_posted] [datetime] NULL,
 CONSTRAINT [PK_alliance_donation] PRIMARY KEY CLUSTERED 
(
	[donation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[alliance_event]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alliance_event](
	[event_id] [bigint] IDENTITY(1,1) NOT NULL,
	[alliance_id] [bigint] NOT NULL,
	[club_id] [bigint] NOT NULL,
	[club_name] [nvarchar](max) NULL,
	[message] [nvarchar](max) NULL,
	[date_posted] [datetime] NULL,
 CONSTRAINT [PK_alliance_event] PRIMARY KEY CLUSTERED 
(
	[event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[alliance_wall]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alliance_wall](
	[chat_id] [bigint] IDENTITY(1,1) NOT NULL,
	[club_id] [bigint] NOT NULL,
	[club_name] [nvarchar](max) NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[date_posted] [datetime] NULL,
	[alliance_id] [bigint] NULL,
	[alliance_name] [nvarchar](max) NULL,
	[target_alliance_id] [bigint] NULL,
 CONSTRAINT [PK_alliance_wall] PRIMARY KEY CLUSTERED 
(
	[chat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[bid]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bid](
	[bid_id] [bigint] IDENTITY(1,1) NOT NULL,
	[uid] [varchar](50) NOT NULL,
	[club_id] [bigint] NOT NULL,
	[club_name] [nvarchar](max) NOT NULL,
	[player_id] [bigint] NOT NULL,
	[bid_value] [int] NOT NULL,
	[bid_datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_bid] PRIMARY KEY CLUSTERED 
(
	[bid_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[chat]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chat](
	[chat_id] [bigint] IDENTITY(1,1) NOT NULL,
	[club_id] [bigint] NOT NULL,
	[club_name] [nvarchar](max) NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[date_posted] [datetime] NULL,
	[alliance_id] [bigint] NULL,
	[alliance_name] [nvarchar](max) NULL,
 CONSTRAINT [PK_chat] PRIMARY KEY CLUSTERED 
(
	[chat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[event_alliance]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_alliance](
	[event_id] [bigint] NOT NULL,
	[event_active] [int] NULL,
	[event_row1] [varchar](250) NULL,
	[event_row2] [varchar](max) NULL,
	[event_row3] [varchar](max) NULL,
	[event_duration] [int] NULL,
	[event_starting] [datetime] NULL,
	[event_ending] [datetime] NULL,
	[prize1] [int] NULL,
	[prize2] [int] NULL,
	[prize3] [int] NULL,
	[prize4] [int] NULL,
	[prize5] [int] NULL,
 CONSTRAINT [PK_event_alliance] PRIMARY KEY CLUSTERED 
(
	[event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[event_solo]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_solo](
	[event_id] [bigint] NOT NULL,
	[event_active] [int] NULL,
	[event_row1] [varchar](250) NULL,
	[event_row2] [varchar](max) NULL,
	[event_row3] [varchar](max) NULL,
	[event_duration] [int] NULL,
	[event_starting] [datetime] NULL,
	[event_ending] [datetime] NULL,
	[prize1] [int] NULL,
	[prize2] [int] NULL,
	[prize3] [int] NULL,
	[prize4] [int] NULL,
	[prize5] [int] NULL,
 CONSTRAINT [PK_event_solo] PRIMARY KEY CLUSTERED 
(
	[event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[identifier]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[identifier](
	[identifier_id] [int] NOT NULL,
	[game_id] [varchar](10) NOT NULL,
	[latest_version] [varchar](250) NULL,
	[url_app] [varchar](500) NULL,
	[reviews] [varchar](500) NULL,
	[promote_apps] [varchar](500) NULL,
	[sale1] [varchar](250) NULL,
	[sale2] [varchar](250) NULL,
	[sc3] [varchar](250) NULL,
	[sc4] [varchar](250) NULL,
	[sc5] [varchar](250) NULL,
	[sc6] [varchar](250) NULL,
	[sc7] [varchar](250) NULL,
	[staff] [varchar](250) NULL,
	[rename] [varchar](250) NULL,
	[reset] [varchar](250) NULL,
	[refill] [varchar](250) NULL,
	[upgrade1] [varchar](250) NULL,
	[upgrade2] [varchar](250) NULL,
	[upgrade3] [varchar](250) NULL,
	[upgrade4] [varchar](250) NULL,
	[upgrade5] [varchar](250) NULL,
	[upgrade6] [varchar](250) NULL,
	[upgrade7] [varchar](250) NULL,
	[upgrade8] [varchar](250) NULL,
	[upgrade9] [varchar](250) NULL,
	[upgrade10] [varchar](250) NULL,
 CONSTRAINT [PK_identifier] PRIMARY KEY CLUSTERED 
(
	[identifier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[league]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[league](
	[division] [int] NULL,
	[series] [int] NULL,
	[last_update] [date] NULL,
	[table_xml] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mail]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mail](
	[mail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[date_posted] [datetime] NULL,
	[title] [nvarchar](max) NULL,
	[message] [nvarchar](max) NULL,
	[everyone] [int] NULL,
	[alliance_id] [bigint] NULL,
	[to_id] [bigint] NULL,
	[to_name] [nvarchar](max) NULL,
	[club_id] [bigint] NULL,
	[club_name] [nvarchar](max) NULL,
	[open_read] [int] NULL,
	[reply_counter] [int] NULL,
 CONSTRAINT [PK_mail] PRIMARY KEY CLUSTERED 
(
	[mail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mail_reply]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mail_reply](
	[reply_id] [bigint] IDENTITY(1,1) NOT NULL,
	[mail_id] [bigint] NULL,
	[date_posted] [datetime] NULL,
	[message] [nvarchar](max) NULL,
	[club_id] [bigint] NULL,
	[club_name] [nvarchar](max) NULL,
 CONSTRAINT [PK_mail_reply] PRIMARY KEY CLUSTERED 
(
	[reply_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mailclub]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mailclub](
	[mailclub_id] [bigint] IDENTITY(1,1) NOT NULL,
	[mail_id] [bigint] NULL,
	[club_id] [bigint] NULL,
 CONSTRAINT [PK_mailclub] PRIMARY KEY CLUSTERED 
(
	[mailclub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[news]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[news](
	[news_id] [bigint] IDENTITY(1,1) NOT NULL,
	[news_datetime] [datetime] NOT NULL,
	[push] [bit] NOT NULL,
	[marquee] [bit] NOT NULL,
	[headline] [nvarchar](max) NOT NULL,
	[news] [nvarchar](max) NOT NULL,
	[image_url] [nvarchar](max) NOT NULL,
	[everyone] [bit] NOT NULL,
	[club_id] [bigint] NOT NULL,
	[division] [int] NOT NULL,
	[series] [int] NOT NULL,
	[playing_cup] [bit] NOT NULL,
 CONSTRAINT [PK_news] PRIMARY KEY CLUSTERED 
(
	[news_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[password_request]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[password_request](
	[request_id] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[request_date] [datetime] NULL,
	[request_game_id] [varchar](10) NULL,
	[request_uid] [varchar](50) NULL,
	[request_email] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[product]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product](
	[product_id] [int] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[name] [varchar](50) NULL,
	[description] [varchar](500) NULL,
	[sql_command] [varchar](1000) NULL,
	[price_real] [int] NOT NULL,
	[price_virtual] [varchar](50) NULL,
	[product_star] [int] NULL,
	[content_url] [varchar](500) NULL,
 CONSTRAINT [PK_product] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[receipt]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[receipt](
	[receipt_id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [varchar](250) NOT NULL,
	[transaction_id] [varchar](250) NOT NULL,
	[product_id] [varchar](250) NOT NULL,
	[purchase_date] [varchar](250) NOT NULL,
 CONSTRAINT [PK_receipt] PRIMARY KEY CLUSTERED 
(
	[receipt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[sales]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sales](
	[sale_id] [int] NOT NULL,
	[sale_active] [int] NULL,
	[sale_sold] [int] NULL,
	[sale_row1] [varchar](250) NULL,
	[sale_row2] [varchar](250) NULL,
	[sale_row3] [varchar](250) NULL,
	[sale_row4] [varchar](250) NULL,
	[sale_duration] [int] NULL,
	[sale_starting] [datetime] NULL,
	[sale_ending] [datetime] NULL,
	[sale_price] [varchar](250) NULL,
	[sale_identifier] [varchar](250) NULL,
	[sale_sql1] [nvarchar](max) NULL,
	[sale_sql2] [nvarchar](max) NULL,
	[sale_background_url] [varchar](250) NULL,
	[bundle1_quantity] [varchar](250) NULL,
	[bundle2_quantity] [varchar](250) NULL,
	[bundle3_quantity] [varchar](250) NULL,
	[bundle4_quantity] [varchar](250) NULL,
 CONSTRAINT [PK_sales] PRIMARY KEY CLUSTERED 
(
	[sale_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[season]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[season](
	[season_id] [int] NOT NULL,
	[slide_url] [varchar](max) NULL,
	[footer] [varchar](max) NULL,
	[season] [int] NULL,
	[league_name] [varchar](50) NULL,
	[league_headline] [varchar](max) NULL,
	[league_divisions] [int] NULL,
	[league_round] [int] NULL,
	[league_start] [datetime] NULL,
	[league_end] [datetime] NULL,
	[cup_name] [varchar](50) NULL,
	[cup_headline] [varchar](max) NULL,
	[cup_winner] [varchar](50) NULL,
	[cup_prize] [int] NULL,
	[cup_join_fee] [int] NULL,
	[cup_round] [int] NULL,
	[cup_totalround] [int] NULL,
	[cup_start] [datetime] NULL,
	[cup_end] [datetime] NULL,
	[maintenance] [int] NULL,
	[cup_second] [varchar](50) NULL,
	[cup_winner_id] [int] NULL,
	[cup_second_id] [int] NULL,
	[alliance_require_currency1] [int] NULL,
	[alliance_require_currency2] [int] NULL,
 CONSTRAINT [PK_season] PRIMARY KEY CLUSTERED 
(
	[season_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[transactions]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[transaction_id] [bigint] IDENTITY(1,1) NOT NULL,
	[transaction_datetime] [datetime] NOT NULL,
	[uid] [varchar](50) NOT NULL,
	[product_id] [int] NOT NULL,
	[product_type] [varchar](50) NOT NULL,
	[product_price] [int] NOT NULL,
 CONSTRAINT [PK_transactions] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[trophy]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trophy](
	[trophy_id] [bigint] IDENTITY(1,1) NOT NULL,
	[club_id] [bigint] NOT NULL,
	[type] [int] NOT NULL,
	[name] [varchar](250) NULL,
	[title] [varchar](250) NULL,
 CONSTRAINT [PK_trophy] PRIMARY KEY CLUSTERED 
(
	[trophy_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [indexuid]    Script Date: 2/14/2017 9:10:10 PM ******/
CREATE NONCLUSTERED INDEX [indexuid] ON [dbo].[club]
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [clubidindex]    Script Date: 2/14/2017 9:10:10 PM ******/
CREATE NONCLUSTERED INDEX [clubidindex] ON [dbo].[player]
(
	[club_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[achievement_type] ADD  CONSTRAINT [DF_Table_1_price_real]  DEFAULT ((99)) FOR [reward]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_division]  DEFAULT ((0)) FOR [division]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_series]  DEFAULT ((0)) FOR [series]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_balance]  DEFAULT ((0)) FOR [balance]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fan_expectation]  DEFAULT ((0)) FOR [xp_gain]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_xp_gain1]  DEFAULT ((0)) FOR [xp_history]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_xp_gain1_1]  DEFAULT ((0)) FOR [xp_gain_a]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_xp_history1]  DEFAULT ((0)) FOR [xp_history_a]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fan_members]  DEFAULT ((0)) FOR [fan_members]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_longitude]  DEFAULT ((0)) FOR [longitude]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_latitude]  DEFAULT ((0)) FOR [latitude]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_playing_cup]  DEFAULT ((0)) FOR [playing_cup]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_world_ranking]  DEFAULT ((0)) FOR [league_ranking]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_undefeated_counter]  DEFAULT ((0)) FOR [undefeated_counter]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fan_mood]  DEFAULT ((0)) FOR [fan_mood]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_stadium_capacity]  DEFAULT ((1000)) FOR [stadium_capacity]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_stadium]  DEFAULT ((0)) FOR [stadium]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_average_ticket]  DEFAULT ((1)) FOR [average_ticket]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_managers]  DEFAULT ((0)) FOR [managers]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_scouts]  DEFAULT ((0)) FOR [scouts]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_spokespersons]  DEFAULT ((0)) FOR [spokespersons]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_coaches]  DEFAULT ((0)) FOR [coaches]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_psychologists]  DEFAULT ((0)) FOR [psychologists]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_accountants]  DEFAULT ((0)) FOR [accountants]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_physiotherapists]  DEFAULT ((0)) FOR [physiotherapists]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_doctors]  DEFAULT ((0)) FOR [doctors]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_training]  DEFAULT ((0)) FOR [training]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_teamspirit]  DEFAULT ((0)) FOR [teamspirit]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_confidence]  DEFAULT ((0)) FOR [confidence]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_tactic]  DEFAULT ((0)) FOR [tactic]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_formation]  DEFAULT ((0)) FOR [formation]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_gk]  DEFAULT ((0)) FOR [gk]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_rb]  DEFAULT ((0)) FOR [rb]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_lb]  DEFAULT ((0)) FOR [lb]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_rw]  DEFAULT ((0)) FOR [rw]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_lw]  DEFAULT ((0)) FOR [lw]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_cd1]  DEFAULT ((0)) FOR [cd1]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_cd2]  DEFAULT ((0)) FOR [cd2]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_cd3]  DEFAULT ((0)) FOR [cd3]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_im1]  DEFAULT ((0)) FOR [im1]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_im2]  DEFAULT ((0)) FOR [im2]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_im3]  DEFAULT ((0)) FOR [im3]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fw1]  DEFAULT ((0)) FOR [fw1]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fw2]  DEFAULT ((0)) FOR [fw2]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fw3]  DEFAULT ((0)) FOR [fw3]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sgk]  DEFAULT ((0)) FOR [sgk]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sd]  DEFAULT ((0)) FOR [sd]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sim]  DEFAULT ((0)) FOR [sim]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sfw]  DEFAULT ((0)) FOR [sfw]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sw]  DEFAULT ((0)) FOR [sw]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_stadium]  DEFAULT ((0)) FOR [revenue_stadium]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_sponsors]  DEFAULT ((0)) FOR [revenue_sponsors]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_player_sales]  DEFAULT ((0)) FOR [revenue_sales]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_investments]  DEFAULT ((0)) FOR [revenue_investments]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_prize_money]  DEFAULT ((0)) FOR [revenue_others]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_total]  DEFAULT ((0)) FOR [revenue_total]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_stadium]  DEFAULT ((0)) FOR [expenses_stadium]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_player_salary]  DEFAULT ((0)) FOR [expenses_salary]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_player_purchases]  DEFAULT ((0)) FOR [expenses_purchases]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_interest]  DEFAULT ((0)) FOR [expenses_interest]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_firing]  DEFAULT ((0)) FOR [expenses_others]
GO
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_total]  DEFAULT ((0)) FOR [expenses_total]
GO
ALTER TABLE [dbo].[mail] ADD  CONSTRAINT [DF_mail_everyone]  DEFAULT ((0)) FOR [everyone]
GO
ALTER TABLE [dbo].[mail] ADD  CONSTRAINT [DF_mail_club_id]  DEFAULT ((0)) FOR [club_id]
GO
ALTER TABLE [dbo].[mail_reply] ADD  CONSTRAINT [DF_mail_reply_club_id]  DEFAULT ((0)) FOR [club_id]
GO
ALTER TABLE [dbo].[match] ADD  CONSTRAINT [DF_match_match_played]  DEFAULT ((0)) FOR [match_played]
GO
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_marquee]  DEFAULT ((1)) FOR [marquee]
GO
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_to_all]  DEFAULT ((0)) FOR [everyone]
GO
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_club_id]  DEFAULT ((0)) FOR [club_id]
GO
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_division]  DEFAULT ((0)) FOR [division]
GO
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_series]  DEFAULT ((0)) FOR [series]
GO
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_playing_cup]  DEFAULT ((0)) FOR [playing_cup]
GO
ALTER TABLE [dbo].[password_request] ADD  CONSTRAINT [DF_password_request_request_id]  DEFAULT (newid()) FOR [request_id]
GO
ALTER TABLE [dbo].[player] ADD  CONSTRAINT [DF_player_player_injured]  DEFAULT ((0)) FOR [player_condition_days]
GO
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_type]  DEFAULT ('Consumable') FOR [type]
GO
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_price_real]  DEFAULT ((99)) FOR [price_real]
GO
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_price_virtual]  DEFAULT ((10000)) FOR [price_virtual]
GO
/****** Object:  StoredProcedure [dbo].[usp_Bid]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2012
-- Description:	Bid
-- =============================================
CREATE PROCEDURE [dbo].[usp_Bid]
AS
BEGIN

DECLARE @bid_id int, @bid_date varchar(100), @bid_value int, @player_id int, @bid_date_min varchar(100), 
@club_id int, @club_uid varchar(100), @club_name varchar(100), 
@vclub_id int, @vclub_name varchar(100), @club_balance bigint, 
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

	DELETE bid WHERE player_id=@player_id
	
	DECLARE @prev_club_id int
	SET @prev_club_id = ISNULL((SELECT club_id FROM player WHERE player_id=@player_id), 0);
	
	IF(@prev_club_id=-1)
	BEGIN

	DECLARE @player_name varchar(100)
	SET @player_name = (SELECT player_name FROM player WHERE player_id=@player_id);

	UPDATE player SET club_id=@club_id WHERE player_id=@player_id
	
	UPDATE club SET balance=balance-@bid_value, 
	expenses_purchases=expenses_purchases+@bid_value,
	expenses_total=expenses_total+@bid_value
	WHERE club_id=@club_id
	
	SET @headline='Congratulations! You have won the bid for player '+@player_name+', worth $'+CAST(@bid_value AS varchar(10));
	SET @news='The Board of Directors and Fans are happy with your purchase!';
	INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0)
	
	SET @headline='Spokesperson: We won the bid on player '+@player_name+' for $'+CAST(@bid_value AS varchar(10));
	INSERT INTO dbo.chat VALUES (@club_id, @club_name, @headline, GETUTCDATE(), 0, '')
	
	INSERT INTO dbo.transactions VALUES (GETUTCDATE(), @club_uid, @player_id, @club_name, @bid_value)
	
	--ACHIEVEMENT 24
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=24)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@club_id, 24, 0)
	END
	
	END
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
GO
/****** Object:  StoredProcedure [dbo].[usp_block]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Block IIS url sequence through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_block]
(@block_uid varchar(1000))
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\ablocker.vbs "'+@block_uid+'"'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_BlockAll]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2011
-- Description: Block all cheats
-- =============================================
CREATE PROCEDURE [dbo].[usp_BlockAll]
AS
BEGIN

DECLARE @total_uid int, @block_uid varchar(100)

Declare c Cursor For 
SELECT DISTINCT substring([uid], 2, 40), COUNT([uid]) AS total FROM [admin_block] GROUP BY [uid] ORDER BY total DESC

Open c
Fetch next From c into @block_uid, @total_uid
While @@Fetch_Status=0
Begin

IF @total_uid > 19
BEGIN
EXEC usp_block @block_uid
EXEC usp_ResetRemove @block_uid
END
ELSE
BEGIN
DELETE admin_block WHERE [uid] LIKE '%'+@block_uid
END

Fetch next From c into @block_uid, @total_uid
End
Close c
Deallocate c

END

GO
/****** Object:  StoredProcedure [dbo].[usp_BuyDiamonds]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reward for buying diamonds
-- =============================================
CREATE PROCEDURE [dbo].[usp_BuyDiamonds]
(@club_uid varchar(1000), @total int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

IF @total = 1700
BEGIN
	EXECUTE usp_PlayerBundle 1, @club_id
END

IF @total = 800
BEGIN
	UPDATE dbo.club SET currency_second=currency_second+200 WHERE [uid]=@club_uid;
END

--ACHIEVEMENT 41
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=41)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 41, 0);
UPDATE dbo.club SET currency_second=currency_second+70 WHERE [uid]=@club_uid; --First time buyer promo
EXECUTE usp_SendMailNews @club_id, 'Thanks for purchasing Diamonds for the very first time. We have credited your account with an extra 70 Diamonds as a reward. Enjoy!';
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_ClubNew]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 2 November 2009
-- Description:	Insert random club
-- =============================================

CREATE PROCEDURE [dbo].[usp_ClubNew]
(@division int, @series int)
AS
BEGIN
DECLARE @count int, @club_id int, @club_id_new int, @random int, @vclub_name varchar(100), @vlogo_pic int, @counter int
SET @count = 1;
SET @club_id = ISNULL((SELECT MAX(club_id) FROM club), 0);
WHILE @count < 11
BEGIN

SET @club_id_new = @club_id+@count;

SET @vlogo_pic = ((@club_id_new % 26)+1);
SET @counter = ((@club_id_new / 26)+1);

If @vlogo_pic = 1
Begin
	SET @vclub_name = 'CLUB A' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 2
Begin
	SET @vclub_name = 'CLUB B' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 3
Begin
	SET @vclub_name = 'CLUB C' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 4
Begin
	SET @vclub_name = 'CLUB D' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 5
Begin
	SET @vclub_name = 'CLUB E' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 6
Begin
	SET @vclub_name = 'CLUB F' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 7
Begin
	SET @vclub_name = 'CLUB G' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 8
Begin
	SET @vclub_name = 'CLUB H' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 9
Begin
	SET @vclub_name = 'CLUB I' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 10
Begin
	SET @vclub_name = 'CLUB J' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 11
Begin
	SET @vclub_name = 'CLUB K' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 12
Begin
	SET @vclub_name = 'CLUB L' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 13
Begin
	SET @vclub_name = 'CLUB M' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 14
Begin
	SET @vclub_name = 'CLUB N' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 15
Begin
	SET @vclub_name = 'CLUB O' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 16
Begin
	SET @vclub_name = 'CLUB P' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 17
Begin
	SET @vclub_name = 'CLUB Q' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 18
Begin
	SET @vclub_name = 'CLUB R' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 19
Begin
	SET @vclub_name = 'CLUB S' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 20
Begin
	SET @vclub_name = 'CLUB T' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 21
Begin
	SET @vclub_name = 'CLUB U' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 22
Begin
	SET @vclub_name = 'CLUB V' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 23
Begin
	SET @vclub_name = 'CLUB W' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 24
Begin
	SET @vclub_name = 'CLUB X' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 25
Begin
	SET @vclub_name = 'CLUB Y' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 26
Begin
	SET @vclub_name = 'CLUB Z' + CAST(@counter AS VARCHAR);
End

-- Create New Club
INSERT INTO dbo.club VALUES (@club_id_new, '1', '0', @vclub_name, 1/1/2011, 1/1/2011, 0, 0, 0, @division, @series, 10, 0, 100, 10, 1, 'Good Condition', 50, 1, 1, 1/1/2011, 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 10, 10, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199000, '', '', '', '', '', '', '1', 
CAST(@vlogo_pic AS varchar(6)), '26', '26', 20, 0, 20, 0, 1/1/2011, 0, 1/1/2011, 0, 1/1/2011, 25, 0)

-- Add Random New Players to Club
EXECUTE usp_PlayerNew @club_id_new

SET @count=@count+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ClubNewBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk Club Generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_ClubNewBulk]
(@division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN
EXECUTE usp_ClubNew @division, @counter
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ClubNewBulkBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk Club Generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_ClubNewBulkBulk]
(@start int, @max int)
AS
BEGIN
DECLARE @counter int
SET @counter = @start;
WHILE @counter < @max+1
BEGIN
EXECUTE usp_ClubNewBulk @counter, 1, 625
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ClubResetDivisionSeries]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 24 June 2010
-- Description:	Reset division and series
-- =============================================
CREATE PROCEDURE [dbo].[usp_ClubResetDivisionSeries]
(@division int, @series int)
AS
BEGIN
DECLARE @start_club_id int

IF(@division=1)
	SET @start_club_id=0

IF(@division=2)
	SET @start_club_id=10
	
IF(@division=3)
	SET @start_club_id=60
	
IF(@division=4)
	SET @start_club_id=310
	
IF(@division=5)
	SET @start_club_id=1560
	
IF(@division>5)
	SET @start_club_id=1560+(6250*(@division-5))

UPDATE club SET division=@division, series=@series WHERE club_id>@start_club_id+((@series-1)*10) AND club_id<@start_club_id+11+((@series-1)*10)

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ClubResetDivisionSeriesBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk League Generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_ClubResetDivisionSeriesBulk]
(@division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN
EXECUTE usp_ClubResetDivisionSeries @division, @counter
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_CoachNew]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 10 December 2009
-- Description:	Random coach generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_CoachNew]
AS
BEGIN
DECLARE @counter int, @coach_id int, @coach_name varchar(100), @coach_desc varchar(1000), @first_name varchar(50), @last_name varchar(50), 
@coach_age int, @coach_star int, @coach_salary int, @coach_value int, @coach_leadership int, @coach_skill int
SET @counter = 10;
SET @coach_id = ISNULL((SELECT MAX(coach_id) FROM coach), 0);
WHILE @counter > 0
BEGIN
SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @coach_name = @first_name + ' ' + @last_name;
SET @coach_desc = (SELECT TOP 1 character FROM admin_character ORDER BY NEWID());
SET @coach_age = dbo.fx_generateRandomNumber(newID(), 40, 60-@counter);
SET @coach_star = @counter;
SET @coach_salary = 500 + dbo.fx_generateRandomNumber(newID(), 200, 400)*@counter;
SET @coach_value = 80000 + dbo.fx_generateRandomNumber(newID(), 20000, 40000)*@counter;
SET @coach_leadership = dbo.fx_generateRandomNumber(newID(), 10, 17)*@counter;
SET @coach_skill = dbo.fx_generateRandomNumber(newID(), 13, 17)*@counter;

-- Insert New Coach
INSERT INTO dbo.coach VALUES (@coach_id+@counter, @coach_name, @coach_leadership, @coach_skill, @coach_desc, @coach_age, @coach_star, @coach_salary, @coach_value)

SET @counter=@counter-1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_DoSlot]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to humble begining
-- =============================================
CREATE PROCEDURE [dbo].[usp_DoSlot]
(@club_uid varchar(1000))
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

--ACHIEVEMENT 38
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=38)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 38, 0)
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_EventAllianceRandom]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add a random sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_EventAllianceRandom]
AS
BEGIN
DECLARE @counter int, @event_duration int

SET @counter = (SELECT COUNT(*) FROM event_alliance WHERE event_active = 1 AND event_starting < GETUTCDATE() AND event_ending > GETUTCDATE());

--No active events
IF @counter = 0
BEGIN

SET @counter = (SELECT COUNT(*) FROM event_alliance WHERE event_active = 1 AND event_starting < GETUTCDATE() AND event_ending < GETUTCDATE());
--Event ended so reward winners
IF @counter = 1
BEGIN

SET @counter = (SELECT COUNT(*) FROM club WHERE xp_history_a > 0);
--Make sure not to reward winners more then once
IF @counter > 1
BEGIN

DECLARE @row int, @alliance_id int, @prize1 int, @prize2 int, @prize3 int, @prize4 int, @prize5 int, @news varchar(MAX)
SET @prize1 = (SELECT prize1 FROM event_alliance WHERE event_id=1);
SET @prize2 = (SELECT prize2 FROM event_alliance WHERE event_id=1);
SET @prize3 = (SELECT prize3 FROM event_alliance WHERE event_id=1);
SET @prize4 = (SELECT prize4 FROM event_alliance WHERE event_id=1);
SET @prize5 = (SELECT prize5 FROM event_alliance WHERE event_id=1);
SET @row=0;

Declare c Cursor For SELECT TOP(20) alliance_id FROM View_AllianceEventResult ORDER BY xp_gain DESC
Open c
Fetch next From c into @alliance_id
While @@Fetch_Status=0
Begin
	SET @row=@row+1;

	IF @row = 1
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize1 WHERE alliance_id=@alliance_id;
		SET @news = 'Congratulations! You have won 1st place in the Alliance Tournament and have been rewarded with the 1st prize of ' + CAST(@prize1 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailAlliance @alliance_id, @news, 0;
	END
	ELSE IF @row = 2
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize2 WHERE alliance_id=@alliance_id;
		SET @news = 'Congratulations! You have won 2nd place in the Alliance Tournament and have been rewarded with the 2nd prize of ' + CAST(@prize2 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailAlliance @alliance_id, @news, 0;
	END
	ELSE IF @row = 3
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize3 WHERE alliance_id=@alliance_id;
		SET @news = 'Congratulations! You have won 3rd place in the Alliance Tournament and have been rewarded with the 3rd prize of ' + CAST(@prize3 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailAlliance @alliance_id, @news, 0;
	END
	ELSE IF (@row > 3 AND @row < 11)
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize4 WHERE alliance_id=@alliance_id;
		SET @news = 'Congratulations! You have achieved between the 4th to 10th place in the Alliance Tournament and have been rewarded with the consolation prize of ' + CAST(@prize4 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailAlliance @alliance_id, @news, 0;
	END
	ELSE IF (@row > 10 AND @row < 21)
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize5 WHERE alliance_id=@alliance_id;
		SET @news = 'Congratulations! You have achieved between the 10th to 20th place in the Alliance Tournament and have been rewarded with the consolation prize of ' + CAST(@prize5 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailAlliance @alliance_id, @news, 0;
	END

	Fetch next From c into @alliance_id
End
Close c
Deallocate c

UPDATE club SET xp_history_a=0;
END

END

--Create new event
SET @event_duration = dbo.fx_generateRandomNumber(newID(), 8, 12);
UPDATE event_alliance SET event_active=1, event_starting=GETUTCDATE(), event_duration=@event_duration, event_ending=GETUTCDATE()+@event_duration WHERE event_id=1;
UPDATE club SET xp_gain_a=0;

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_EventAllianceResult]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add a random sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_EventAllianceResult]
AS
BEGIN
DECLARE @counter int

SET @counter = (SELECT COUNT(*) FROM event_alliance WHERE event_active = 1 AND event_starting < GETUTCDATE() AND event_ending < GETUTCDATE());
--Event ended so save results to xp_history_a
IF @counter = 1
BEGIN

SET @counter = (SELECT COUNT(*) FROM club WHERE xp_history_a > 0);
--Make sure not to transfer to xp_history_a more then once
IF @counter < 5
BEGIN
UPDATE club SET xp_history_a=xp_gain_a WHERE xp_gain_a is not NULL;
END

END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EventSoloRandom]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add a random sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_EventSoloRandom]
AS
BEGIN
DECLARE @counter int, @event_duration int

SET @counter = (SELECT COUNT(*) FROM event_solo WHERE event_active = 1 AND event_starting < GETUTCDATE() AND event_ending > GETUTCDATE());

--No active events
IF @counter = 0
BEGIN

SET @counter = (SELECT COUNT(*) FROM event_solo WHERE event_active = 1 AND event_starting < GETUTCDATE() AND event_ending < GETUTCDATE());
--Event ended so reward winners
IF @counter = 1
BEGIN

SET @counter = (SELECT COUNT(*) FROM club WHERE xp_history > 0);
--Make sure not to reward winners more then once
IF @counter > 1
BEGIN

DECLARE @row int, @club_id int, @prize1 int, @prize2 int, @prize3 int, @prize4 int, @prize5 int, @news varchar(MAX)
SET @prize1 = (SELECT prize1 FROM event_solo WHERE event_id=1);
SET @prize2 = (SELECT prize2 FROM event_solo WHERE event_id=1);
SET @prize3 = (SELECT prize3 FROM event_solo WHERE event_id=1);
SET @prize4 = (SELECT prize4 FROM event_solo WHERE event_id=1);
SET @prize5 = (SELECT prize5 FROM event_solo WHERE event_id=1);
SET @row=0;

Declare c Cursor For SELECT TOP(20) club_id FROM View_ClubInfo ORDER BY xp_history DESC
Open c
Fetch next From c into @club_id
While @@Fetch_Status=0
Begin
	SET @row=@row+1;

	IF @row = 1
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize1 WHERE club_id=@club_id;
		SET @news = 'Congratulations! You have won 1st place in the Solo Tournament and have been rewarded with the 1st prize of ' + CAST(@prize1 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailNews @club_id, @news;
	END
	ELSE IF @row = 2
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize2 WHERE club_id=@club_id;
		SET @news = 'Congratulations! You have won 2nd place in the Solo Tournament and have been rewarded with the 2nd prize of ' + CAST(@prize2 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailNews @club_id, @news;
	END
	ELSE IF @row = 3
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize3 WHERE club_id=@club_id;
		SET @news = 'Congratulations! You have won 3rd place in the Solo Tournament and have been rewarded with the 3rd prize of ' + CAST(@prize3 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailNews @club_id, @news;
	END
	ELSE IF (@row > 3 AND @row < 11)
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize4 WHERE club_id=@club_id;
		SET @news = 'Congratulations! You have achieved between the 4th to 10th place in the Solo Tournament and have been rewarded with the consolation prize of ' + CAST(@prize4 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailNews @club_id, @news;
	END
	ELSE IF (@row > 10 AND @row < 21)
	BEGIN
		UPDATE club SET currency_second=currency_second+@prize5 WHERE club_id=@club_id;
		SET @news = 'Congratulations! You have achieved between the 10th to 20th place in the Solo Tournament and have been rewarded with the consolation prize of ' + CAST(@prize5 AS varchar(12)) + ' Diamonds';
		EXECUTE usp_SendMailNews @club_id, @news;
	END

	Fetch next From c into @club_id
End
Close c
Deallocate c

UPDATE club SET xp_history=0;
END

END

--Create new event
SET @event_duration = dbo.fx_generateRandomNumber(newID(), 8, 12);
UPDATE event_solo SET event_active=1, event_starting=GETUTCDATE(), event_duration=@event_duration, event_ending=GETUTCDATE()+@event_duration WHERE event_id=1;
UPDATE club SET xp_gain=0;

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_EventSoloResult]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add a random sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_EventSoloResult]
AS
BEGIN
DECLARE @counter int

SET @counter = (SELECT COUNT(*) FROM event_solo WHERE event_active = 1 AND event_starting < GETUTCDATE() AND event_ending < GETUTCDATE());
--Event ended so save results to xp_history
IF @counter = 1
BEGIN

SET @counter = (SELECT COUNT(*) FROM club WHERE xp_history > 0);
--Make sure not to transfer to xp_history more then once
IF @counter < 5
BEGIN
UPDATE club SET xp_history=xp_gain WHERE xp_gain is not NULL;
END

END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part1]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Dec 2010
-- Description:	New League Season
-- =============================================
CREATE PROCEDURE [dbo].[usp_League_NEW_Part1]
AS
BEGIN

DELETE mailclub
DELETE mail_reply
DELETE mail
DELETE chat
DELETE alliance_wall
DELETE news

DECLARE @max_division int

SET @max_division = ISNULL((SELECT MAX(division) FROM club), 4);

EXECUTE usp_LeagueRanking 1, 1
EXECUTE usp_LeagueRankingBulk 2, 1, 5
EXECUTE usp_LeagueRankingBulk 3, 1, 25
EXECUTE usp_LeagueRankingBulk 4, 1, 125

DECLARE @counter int, @total_match int
SET @counter = 5;
WHILE @counter < @max_division+1
BEGIN
SET @total_match = ISNULL((SELECT count(*) FROM match WHERE division=@counter), 0);
IF(@total_match>11250)
BEGIN
EXECUTE usp_LeagueRankingBulk @counter, 1, 625
END
ELSE
BEGIN
SET @max_division = @counter
END
SET @counter=@counter+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part2]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Dec 2010
-- Description:	New League Season award trophy and price
-- =============================================
CREATE PROCEDURE [dbo].[usp_League_NEW_Part2]
AS
BEGIN
DECLARE @club_id int, @division int, @series int, @headline nvarchar(MAX), @news nvarchar(MAX), @title nvarchar(MAX)

DECLARE c CURSOR FOR SELECT club_id, division, series FROM club WHERE league_ranking=1
OPEN c
Fetch next From c into @club_id, @division, @series
WHILE @@Fetch_Status=0
BEGIN
	SET @title = 'League 1st div.' + CAST(@division AS varchar(12)) + ' ser.' + CAST(@series AS varchar(12));
	INSERT INTO dbo.trophy VALUES (@club_id, 4, @title, GETUTCDATE());
	UPDATE club SET balance=balance+100000, revenue_others=100000 WHERE club_id=@club_id;
	SET @headline='Congratulations! Your club has finished 1st in the League and received a Trophy along with $100,000.';
	SET @news='The Board of Directors and Fans are thriled to with your achievement';
	INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0);
	Fetch next From c into @club_id, @division, @series
END
CLOSE c
DEALLOCATE c
SET @club_id=0
SET @division=0
SET @series=0

DECLARE b CURSOR FOR SELECT club_id, division, series FROM club WHERE league_ranking=2
OPEN b
Fetch next From b into @club_id, @division, @series
WHILE @@Fetch_Status=0
BEGIN
	SET @title = 'League 2nd div.' + CAST(@division AS varchar(12)) + ' ser.' + CAST(@series AS varchar(12));
	INSERT INTO dbo.trophy VALUES (@club_id, 5, @title, GETUTCDATE());
	UPDATE club SET balance=balance+50000, revenue_others=50000 WHERE club_id=@club_id;
	SET @headline='Congratulations! Your club has finished 2nd in the League and received a Trophy along with $50,000.';
	SET @news='The Board of Directors and Fans are thriled to with your achievement';
	INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0);
	Fetch next From b into @club_id, @division, @series
END
CLOSE b
DEALLOCATE b
SET @club_id=0
SET @division=0
SET @series=0

DECLARE a CURSOR FOR SELECT club_id, division, series FROM club WHERE league_ranking=3
OPEN a
Fetch next From a into @club_id, @division, @series
WHILE @@Fetch_Status=0
BEGIN
	SET @title = 'League 3rd div.' + CAST(@division AS varchar(12)) + ' ser.' + CAST(@series AS varchar(12));
	INSERT INTO dbo.trophy VALUES (@club_id, 6, @title, GETUTCDATE());
	UPDATE club SET balance=balance+25000, revenue_others=25000 WHERE club_id=@club_id;
	SET @headline='Congratulations! Your club has finished 3rd in the League and received a Trophy along with $25,000.';
	SET @news='The Board of Directors and Fans are thriled to with your achievement';
	INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0);
	Fetch next From a into @club_id, @division, @series
END
CLOSE a
DEALLOCATE a
SET @club_id=0
SET @division=0
SET @series=0

END
GO
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part3]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Dec 2010
-- Description:	New League Season
-- =============================================
CREATE PROCEDURE [dbo].[usp_League_NEW_Part3]
AS
BEGIN
DECLARE @max_division int

SET @max_division = ISNULL((SELECT MAX(division) FROM club), 5);

EXECUTE usp_PromoteDemote 1, 1
EXECUTE usp_PromoteDemoteBulk 2, 1, 5
EXECUTE usp_PromoteDemoteBulk 3, 1, 25
EXECUTE usp_PromoteDemoteBulk 4, 1, 125

DECLARE @counter int, @total_match int
SET @counter = 5;
WHILE @counter < @max_division+1
BEGIN
SET @total_match = ISNULL((SELECT count(*) FROM match WHERE division=@counter+1), 0);
IF(@total_match>11250)
BEGIN
EXECUTE usp_PromoteDemoteBulk @counter, 1, 625
END
ELSE
BEGIN
EXECUTE usp_PromoteBulk @counter, 1, 625
SET @max_division = @counter
END
SET @counter=@counter+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part4]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Dec 2010
-- Description:	New League Season
-- =============================================
CREATE PROCEDURE [dbo].[usp_League_NEW_Part4]
AS
BEGIN

DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=1
DELETE FROM match WHERE match_type_id=1

DECLARE @d1 datetime
SET @d1 = GETUTCDATE()+1

EXECUTE usp_MatchLeagueGenerator @d1, 1, 1
EXECUTE usp_LeagueBulk @d1, 2, 1, 5
EXECUTE usp_LeagueBulk @d1, 3, 1, 25
EXECUTE usp_LeagueBulk @d1, 4, 1, 125

DECLARE @max_division int
SET @max_division = ISNULL((SELECT MAX(division) FROM club), 4);

DECLARE @counter int
SET @counter = 5;
WHILE @counter < @max_division+1
BEGIN
EXECUTE usp_LeagueBulk @d1, @counter, 1, 625
SET @counter=@counter+1;
END

DELETE FROM league
UPDATE season SET league_round=1, league_start=@d1, league_end=GETUTCDATE()+37
UPDATE player SET player.player_age=player.player_age+1 FROM player INNER JOIN club ON player.club_id = club.club_id WHERE club.uid != '0'
DELETE player FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_age > 34 AND club.uid != '0'

END
GO
/****** Object:  StoredProcedure [dbo].[usp_LeagueBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk League Generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_LeagueBulk]
(@startdate datetime, @division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN
EXECUTE usp_MatchLeagueGenerator @startdate, @division, @counter
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_LeagueRanking]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 24 June 2010
-- Description:	Set league_ranking club in division and series
-- =============================================
CREATE PROCEDURE [dbo].[usp_LeagueRanking]
(@division int, @series int)
AS
BEGIN
DECLARE @row int, @club_id int

SET @row=0

Declare c Cursor For SELECT club_id FROM View_Series WHERE division=@division AND series=@series ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC
Open c
Fetch next From c into @club_id
While @@Fetch_Status=0
Begin
	SET @row=@row+1
	UPDATE club SET league_ranking=@row WHERE club_id=@club_id
	Fetch next From c into @club_id
End
Close c
Deallocate c

END
GO
/****** Object:  StoredProcedure [dbo].[usp_LeagueRankingBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk League Ranking Updater
-- =============================================
CREATE PROCEDURE [dbo].[usp_LeagueRankingBulk]
(@division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN
EXECUTE usp_LeagueRanking @division, @counter
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_MatchAllianceBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2010
-- Description:	Generate Cup Match Round
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchAllianceBulk]
AS
BEGIN
DECLARE @alliance_id int
Declare d Cursor For SELECT alliance_id FROM View_Alliance WHERE total_members>1

Open d

Fetch next From d into @alliance_id
While @@Fetch_Status=0
Begin
	EXECUTE usp_MatchAllianceGenerator @alliance_id
	Fetch next From d into @alliance_id
End

Close d
Deallocate d

END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchAllianceGenerator]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2010
-- Description:	Generate Cup Match Round
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchAllianceGenerator]
(@a_id int)
AS
BEGIN
DECLARE @match_id int, @match_date varchar(100), @season_week int, @last_season_week int, @club_home int, @club_away int, 
@total_match int, @total_match_played int, @total_match_unplayed int, @total_match_last_season int, @winner_club_name varchar(100), @winner_club_id int,
@highlight varchar(250), @runerup_club_name varchar(100), @runerup_club_id int, @mtype int, @prize_first int, @prize_second int,
@prize_total int, @currency_first int, @a_name varchar(250)

SET @mtype = @a_id + 1000;

SET @total_match = ISNULL((SELECT count(*) FROM match WHERE match_type_id=@mtype), 0);
SET @total_match_played = ISNULL((SELECT count(*) FROM match WHERE match_type_id=@mtype AND match_played=1), 0);
SET @total_match_unplayed = ISNULL((SELECT count(*) FROM match WHERE match_type_id=@mtype AND match_played=0), 0);

SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), GETUTCDATE()+3)));
SET @last_season_week = ISNULL((SELECT MAX(season_week) FROM match WHERE match_type_id=@mtype), 0);
SET @season_week = @last_season_week + 1;

SET @total_match_last_season = ISNULL((SELECT count(*) FROM match WHERE match_type_id=@mtype AND match_played=1 AND season_week=@last_season_week), 0);

IF @total_match_last_season = 1
BEGIN

SET @winner_club_id = ISNULL((SELECT club_winner FROM match WHERE match_type_id=@mtype AND match_played=1 AND season_week=@last_season_week), 0);
SELECT @winner_club_name = club_name FROM club WHERE club_id=@winner_club_id

SET @runerup_club_id = ISNULL((SELECT club_loser FROM match WHERE match_type_id=@mtype AND match_played=1 AND season_week=@last_season_week), 0);
SELECT @runerup_club_name = club_name FROM club WHERE club_id=@runerup_club_id

DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=@mtype
DELETE FROM match WHERE match_type_id=@mtype

SET @prize_first = ISNULL((SELECT cup_first_prize FROM alliance WHERE alliance_id=@a_id), 0);
SET @prize_second  = ISNULL((SELECT cup_second_prize FROM alliance WHERE alliance_id=@a_id), 0);

SET @currency_first = ISNULL((SELECT currency_first FROM alliance WHERE alliance_id=@a_id), 0);
SET @prize_total = @prize_first + @prize_second;
IF (@prize_total > @currency_first)
BEGIN
	SET @prize_first = 0;
	SET @prize_second = 0;
	UPDATE alliance SET cup_first_prize=0, cup_second_prize=0 WHERE alliance_id=@a_id;
END
ELSE
BEGIN
	UPDATE club SET balance=balance+@prize_first, revenue_others=@prize_first WHERE club_id=@winner_club_id;
	UPDATE club SET balance=balance+@prize_second, revenue_others=@prize_second WHERE club_id=@runerup_club_id;
END

SET @highlight = @winner_club_name+' has won the Alliance CUP and received $' + CAST(@prize_first AS VARCHAR) + ', '+@runerup_club_name+' received $' + CAST(@prize_second AS VARCHAR) + ' for reaching the finals';
INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @highlight, 'Join or create an Alliance CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
INSERT INTO alliance_event VALUES (@a_id , 0, '', @highlight, GETUTCDATE())
UPDATE alliance SET cup_first_id=@winner_club_id, cup_first_name=@winner_club_name, cup_second_id=@runerup_club_id, cup_second_name=@runerup_club_name, currency_first=currency_first-cup_first_prize-cup_second_prize, cup_round=0, cup_totalround=@last_season_week, cup_start=CONVERT(datetime, FLOOR(CONVERT(float(24), GETUTCDATE()+7))) WHERE alliance_id=@a_id;

SELECT @a_name = name FROM alliance WHERE alliance_id=@a_id

INSERT INTO dbo.trophy VALUES (@winner_club_id, 1, @a_name + ' Alliance Gold Cup', GETUTCDATE());
INSERT INTO dbo.trophy VALUES (@runerup_club_id, 2, @a_name + ' Alliance Silver Cup', GETUTCDATE());

SET @currency_first = ISNULL((SELECT currency_first FROM alliance WHERE alliance_id=@a_id), 0);
SET @prize_total = @prize_first + @prize_second;
IF (@prize_total > @currency_first)
BEGIN
	SET @prize_first = 0;
	SET @prize_second = 0;
	UPDATE alliance SET cup_first_prize=0, cup_second_prize=0 WHERE alliance_id=@a_id;
END

END
ELSE
BEGIN

IF @season_week = 1 -- First round for the cup
BEGIN
	SET @highlight = 'New CUP season has kicked off and entered round 1!';
	UPDATE alliance SET cup_round=1 WHERE alliance_id=@a_id;
	INSERT INTO alliance_event VALUES (@a_id , 0, '', @highlight, GETUTCDATE());
	Declare c Cursor For SELECT club_id FROM club WHERE alliance_id=@a_id;
END
ELSE
BEGIN
	SET @highlight = 'CUP has entered round '+CAST(@season_week AS varchar(10));
	UPDATE alliance SET cup_round=@season_week WHERE alliance_id=@a_id;
	INSERT INTO alliance_event VALUES (@a_id , 0, '', @highlight, GETUTCDATE());
	Declare c Cursor For SELECT club_winner FROM match WHERE match_played=1 AND match_type_id=@mtype AND season_week=@last_season_week;
END

Open c
Fetch next From c into @club_home
While @@Fetch_Status=0
Begin
	Fetch next From c into @club_away

	INSERT INTO dbo.match (match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
	VALUES (0, @mtype, @match_date, 1, @season_week, 0, 0, @club_home, @club_away)
	Fetch next From c into @club_home
End
Close c
Deallocate c

END


END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchCheck]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk League Ranking Updater
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchCheck]
(@division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
DECLARE @match_total int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN

SET @match_total = (SELECT count(*) FROM match WHERE division=@division AND series=@counter)

IF @match_total < 90
	print (@counter)

SET @counter=@counter+1;

END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_MatchCupGenerator]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2010
-- Description:	Generate Cup Match Round
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchCupGenerator]
AS
BEGIN
DECLARE @match_id int, @match_date varchar(100), @season_id int, @season_week int, @last_season_week int, @club_home int, @club_away int, 
@total_match int, @total_match_played int, @total_match_unplayed int, @total_match_last_season int, @winner_club_name varchar(100), @winner_club_id int,
@highlight varchar(250), @runerup_club_name varchar(100), @runerup_club_id int

SET @total_match = ISNULL((SELECT count(*) FROM match WHERE match_type_id=2), 0);
SET @total_match_played = ISNULL((SELECT count(*) FROM match WHERE match_type_id=2 AND match_played=1), 0);
SET @total_match_unplayed = ISNULL((SELECT count(*) FROM match WHERE match_type_id=2 AND match_played=0), 0);

SET @season_id = ISNULL((SELECT MAX(season_id) FROM season), 0);
SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), GETUTCDATE()+3)));
SET @last_season_week = ISNULL((SELECT MAX(season_week) FROM match WHERE match_type_id=2), 0);
SET @season_week = @last_season_week + 1;

SET @total_match_last_season = ISNULL((SELECT count(*) FROM match WHERE match_type_id=2 AND match_played=1 AND season_week=@last_season_week), 0);

IF @total_match_last_season = 1
BEGIN

SET @winner_club_id = ISNULL((SELECT club_winner FROM match WHERE match_type_id=2 AND match_played=1 AND season_week=@last_season_week), 0);
SELECT @winner_club_name = club_name FROM club WHERE club_id=@winner_club_id

SET @runerup_club_id = ISNULL((SELECT club_loser FROM match WHERE match_type_id=2 AND match_played=1 AND season_week=@last_season_week), 0);
SELECT @runerup_club_name = club_name FROM club WHERE club_id=@runerup_club_id

UPDATE club SET club.playing_cup=0 FROM club INNER JOIN match ON club.club_id = match.club_home WHERE match.match_type_id=2
UPDATE club SET club.playing_cup=0 FROM club INNER JOIN match ON club.club_id = match.club_away WHERE match.match_type_id=2
DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=2
DELETE FROM match WHERE match_type_id=2

SET @highlight = @winner_club_name+' has won the CUP and received $250,000, '+@runerup_club_name+' received $100,000 for reaching the finals';
INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @highlight, 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
UPDATE season SET cup_winner=@winner_club_name, cup_round=0, cup_totalround=@last_season_week, cup_start=CONVERT(datetime, FLOOR(CONVERT(float(24), GETUTCDATE()+7))), cup_end=CONVERT(datetime, FLOOR(CONVERT(float(24), GETUTCDATE()+70)))

INSERT INTO dbo.trophy VALUES (@winner_club_id, 1, 'Gold Cup', GETUTCDATE());
INSERT INTO dbo.trophy VALUES (@runerup_club_id, 2, 'Silver Cup', GETUTCDATE());

UPDATE club SET balance=balance+250000, revenue_others=250000 WHERE club_id=@winner_club_id
UPDATE club SET balance=balance+100000, revenue_others=100000 WHERE club_id=@runerup_club_id

--ACHIEVEMENT 28
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@winner_club_id AND achievement_type_id=28)
BEGIN
INSERT INTO dbo.achievement VALUES(@winner_club_id, 28, 0)
END

--ACHIEVEMENT 29
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@runerup_club_id AND achievement_type_id=29)
BEGIN
INSERT INTO dbo.achievement VALUES(@runerup_club_id, 29, 0)
END

END
ELSE
BEGIN

IF @season_week = 1 -- First round for the cup
BEGIN
	SET @highlight = 'New CUP season has kicked off and entered round 1!'
	INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @highlight, 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
	Declare c Cursor For SELECT club_id FROM club WHERE playing_cup=1
END
ELSE
BEGIN
	SET @highlight = 'CUP has entered round '+CAST(@season_week AS varchar(10))
	INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @highlight, 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
	Declare c Cursor For SELECT club_winner FROM match WHERE match_played=1 AND match_type_id=2 AND season_week=@last_season_week
END

Open c
Fetch next From c into @club_home
While @@Fetch_Status=0
Begin
	Fetch next From c into @club_away
	INSERT INTO dbo.match (match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
	VALUES (0, 2, @match_date, @season_id, @season_week, 0, 0, @club_home, @club_away)
	Fetch next From c into @club_home
End
Close c
Deallocate c

END


END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchCupReset]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2010
-- Description:	Generate Cup Match Round
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchCupReset]
AS
BEGIN

--Reward winners of last cup match

--Update news and footer

--Clear old cup data
UPDATE club SET club.playing_cup=0 FROM club INNER JOIN match ON club.club_id = match.club_home WHERE match.match_type_id=2
UPDATE club SET club.playing_cup=0 FROM club INNER JOIN match ON club.club_id = match.club_away WHERE match.match_type_id=2
DELETE match_highlight FROM match_highlight INNER JOIN match ON match.match_id = match_highlight.match_id WHERE match.match_type_id=2
DELETE FROM match WHERE match_type_id=2

END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchFriendly]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2011
-- Description:	Create New Friendly Match
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchFriendly]
(@home_uid varchar(100), @away int, @win int, @lose int, @draw int, @note nvarchar(MAX))
AS
BEGIN
DECLARE @match_id int, @repeat int, @home int, @home_name varchar(500), @m_news varchar(2000)

SET @home = ISNULL((SELECT club_id FROM club WHERE [uid]=@home_uid), 1);
SET @home_name = (SELECT club_name FROM club WHERE [uid]=@home_uid);

SET @repeat = (SELECT count(*) FROM match WHERE match_type_id=3 AND match_played=0 AND ((club_home=@home AND club_away=@away) OR (club_home=@away AND club_away=@home)));
IF(@repeat>0)
BEGIN
SET @match_id = (SELECT MAX(match_id) FROM match WHERE match_type_id=3 AND match_played=0 AND ((club_home=@home AND club_away=@away) OR (club_home=@away AND club_away=@home)));
UPDATE dbo.match SET challenge_datetime=GETDATE(), club_home=@home, club_away=@away, challenge_win=@win, challenge_lose=@lose, challenge_draw=@draw, challenge_note=@note WHERE match_id=@match_id; 
END
ELSE
BEGIN
	INSERT INTO dbo.match (match_played, match_type_id, challenge_datetime, club_home, club_away, challenge_win, challenge_lose, challenge_draw, challenge_note) 
	VALUES (0, 3, GETDATE(), @home, @away, @win, @lose, @draw, @note)

	SET @m_news = @home_name + ' has challenged you to a friendly! Accept to gain XP = Level difference between both your clubs.';
	--EXECUTE usp_SendMailNews @away, @m_news
	
	--ACHIEVEMENT 12
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@home AND achievement_type_id=12)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@home, 12, 0)
	END
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_MatchLeagueGenerator]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 07 July 2010
-- Description:	Generate League Matches for whole season
-- =============================================
CREATE PROCEDURE [dbo].[usp_MatchLeagueGenerator]
(@startdate datetime, @division int, @series int)
AS
BEGIN
DECLARE @counter1 int, @counter2 int, @offset int, @start int, @end int, @match_id int,
@match_date varchar(1000), @season_id int, @season_week int, @club_home int, @club_away int

SET @offset = 0;
SET @season_id = ISNULL((SELECT MAX(season_id) FROM season), 0);

SET @counter1 = 1;
WHILE @counter1 < 11
BEGIN
	SET @club_home = (SELECT club_id FROM (SELECT Row_Number() OVER (ORDER BY club_id) AS rowid, club_id FROM club WHERE division=@division AND series=@series) AS a WHERE rowid=@counter1)

	SET @counter2 = 1;
	WHILE @counter2 < 10
	BEGIN

	IF(@counter2 = @counter1)
		SET @offset = 1;
		
	SET @club_away = (SELECT club_id FROM (SELECT Row_Number() OVER (ORDER BY club_id) AS rowid, club_id FROM club WHERE division=@division AND series=@series) AS a WHERE rowid=@counter2+@offset)
	
	SET @season_week = @counter2 + @counter1 - 1;
	
	IF((@counter2+@offset) = 10)
	BEGIN
		IF(@season_week = 10)
		BEGIN
			SET @season_week = 11;
		END
		ELSE
		BEGIN
			IF(@season_week = 11)
			BEGIN
				SET @season_week = 13;
			END
			ELSE
			BEGIN
				IF(@season_week = 12)
				BEGIN
					SET @season_week = 15;
				END
				ELSE
				BEGIN
					IF(@season_week = 13)
					BEGIN
						SET @season_week = 17;
					END
					ELSE
					BEGIN
						IF(@season_week = 14)
						BEGIN
							SET @season_week = 10;
						END
						ELSE
						BEGIN
							IF(@season_week = 15)
							BEGIN
								SET @season_week = 12;
							END
							ELSE
							BEGIN
								IF(@season_week = 16)
								BEGIN
									SET @season_week = 14;
								END
								ELSE
								BEGIN
									IF(@season_week = 17)
									BEGIN
										SET @season_week = 16;
									END
								END
							END
						END
					END
				END
			END
		END
	END
	
	IF(@season_week = 1)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate)));
	IF(@season_week = 2)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 2;
	IF(@season_week = 3)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 4;
	IF(@season_week = 4)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 6;
	IF(@season_week = 5)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 8;
	IF(@season_week = 6)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 10;
	IF(@season_week = 7)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 12;
	IF(@season_week = 8)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 14;
	IF(@season_week = 9)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 16;
	IF(@season_week = 10)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 18;
	IF(@season_week = 11)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 20;
	IF(@season_week = 12)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 22;
	IF(@season_week = 13)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 24;
	IF(@season_week = 14)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 26;
	IF(@season_week = 15)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 28;
	IF(@season_week = 16)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 30;
	IF(@season_week = 17)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 32;
	IF(@season_week = 18)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 34;
	
	IF((@counter2+@offset) > @counter1)
	BEGIN
		INSERT INTO dbo.match (match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
		VALUES (0, 1, @match_date, @season_id, @season_week, @division, @series, @club_home, @club_away)
	END
	SET @counter2=@counter2+1;
	END
	
	SET @offset = 0;
	
	SET @counter2 = 1;
	WHILE @counter2 < 10
	BEGIN

	IF(@counter2 = @counter1)
		SET @offset = 1;
		
	SET @club_away = (SELECT club_id FROM (SELECT Row_Number() OVER (ORDER BY club_id) AS rowid, club_id FROM club WHERE division=@division AND series=@series) AS a WHERE rowid=@counter2+@offset)
	
	SET @season_week = @counter2 + @counter1 + 8;
	
	IF(@season_week > 18)
	BEGIN
		SET @season_week = @season_week - 18;
		IF((@counter2+@offset) = 10)
		BEGIN
			IF(@season_week = 1)
			BEGIN
				SET @season_week = 2;
			END
			ELSE
			BEGIN
				IF(@season_week = 2)
				BEGIN
					SET @season_week = 4;
				END
				ELSE
				BEGIN
					IF(@season_week = 3)
					BEGIN
						SET @season_week = 6;
					END
					ELSE
					BEGIN
						IF(@season_week = 4)
						BEGIN
							SET @season_week = 8;
						END
						ELSE
						BEGIN
							IF(@season_week = 5)
							BEGIN
								SET @season_week = 1;
							END
							ELSE
							BEGIN
								IF(@season_week = 6)
								BEGIN
									SET @season_week = 3;
								END
								ELSE
								BEGIN
									IF(@season_week = 7)
									BEGIN
										SET @season_week = 5;
									END
									ELSE
									BEGIN
										IF(@season_week = 8)
										BEGIN
											SET @season_week = 7;
										END
									END
								END
							END
						END
					END
				END
			END
		END
	END
	
	IF(@season_week = 1)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate)));
	IF(@season_week = 2)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 2;
	IF(@season_week = 3)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 4;
	IF(@season_week = 4)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 6;
	IF(@season_week = 5)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 8;
	IF(@season_week = 6)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 10;
	IF(@season_week = 7)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 12;
	IF(@season_week = 8)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 14;
	IF(@season_week = 9)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 16;
	IF(@season_week = 10)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 18;
	IF(@season_week = 11)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 20;
	IF(@season_week = 12)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 22;
	IF(@season_week = 13)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 24;
	IF(@season_week = 14)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 26;
	IF(@season_week = 15)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 28;
	IF(@season_week = 16)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 30;
	IF(@season_week = 17)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 32;
	IF(@season_week = 18)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 34;
	
	IF((@counter2+@offset) > @counter1)
	BEGIN
		INSERT INTO dbo.match (match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
		VALUES (0, 1, @match_date, @season_id, @season_week, @division, @series, @club_away, @club_home)
	END
	SET @counter2=@counter2+1;
	END
	
SET @offset = 0;
SET @counter1=@counter1+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerBundle]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Create counter 5 Star player(s) to add
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerBundle]
(@total int, @club_id int)
AS
BEGIN

DECLARE @counter int, @player_id int, @player_name varchar(100), @first_name varchar(50), @last_name varchar(50), 
@player_age int, @keeper int, @defend int, @playmaking int, @attack int, @passing int, @fitness int, @type int, 
@player_value int, @player_salary int

SET @counter = 0;
SET @player_id = ISNULL((SELECT MAX(player_id) FROM player), 0);
WHILE @counter < @total
BEGIN

SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 21, 25);
SET @fitness = dbo.fx_generateRandomNumber(newID(), 190, 200);

SET @type = dbo.fx_generateRandomNumber(newID(), 1, 5);

IF(@type = 1) -- STRIKER
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = dbo.fx_generateRandomNumber(newID(), 13, 15)*(13);
SET @passing = 0;
END

IF(@type = 2) -- MIDFIELDER LEFT RIGHT (MLR)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 13, 15)*(13);
END

IF(@type = 3) -- DEFENDER LEFT RIGHT (DLR)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 13, 15)*(13);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = 0;
END

IF(@type = 4) -- KEEPER
BEGIN
SET @keeper = dbo.fx_generateRandomNumber(newID(), 13, 15)*(13);
SET @defend = 0;
SET @playmaking = 0;
SET @attack = 0;
SET @passing = 0;
END

IF(@type = 5) -- PLAYMAKING
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 13, 15)*(13);
SET @attack = 0;
SET @passing = 0;
END


SET @player_value=(((@keeper*@keeper*5)+(@defend*@defend*3)+(@playmaking*@playmaking*3)+(@attack*@attack*3)+(@passing*@passing*3))*10);
SET @player_salary=(((@keeper*@keeper)+(@defend*@defend)+(@playmaking*@playmaking)+(@attack*@attack)+(@passing*@passing))/20);

-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter+1, @club_id, 'All', @player_name, @player_age, 10, @player_salary, @player_value, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

SET @player_name = 'Thank you for buying the Diamonds promotion. You have been rewarded a 5 Star player named ' + @player_name
EXEC usp_SendMailNews @club_id, @player_name

SET @counter=@counter+1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerEnergize]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Player Options
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerEnergize]
(@club_uid varchar(1000), @pid int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

UPDATE club SET e=e-10 WHERE uid=@club_uid;

--ACHIEVEMENT 48
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=48)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 48, 0);
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerHeal]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Player Options
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerHeal]
(@club_uid varchar(1000), @pid int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

UPDATE club SET e=e-10 WHERE uid=@club_uid;

--ACHIEVEMENT 47
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=47)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 47, 0);
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerMorale]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Player Options
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerMorale]
(@club_uid varchar(1000), @pid int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

UPDATE club SET xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5, currency_second=currency_second-3 WHERE uid=@club_uid;

--ACHIEVEMENT 46
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=46)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 46, 0);
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerNew]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Create 11 Random players and assgin to club_id as well as it's formation pos
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerNew]
(@club_id int)
AS
BEGIN
DECLARE @counter int, @player_id int, @player_name varchar(100), @first_name varchar(50), @last_name varchar(50), 
@player_age int, @keeper int, @defend int, @playmaking int, @attack int, @passing int, @fitness int
SET @counter = 1;
SET @player_id = ISNULL((SELECT MAX(player_id) FROM player), 0);
WHILE @counter < 17
BEGIN
SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 21, 25);
SET @keeper = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @defend = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @attack = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @passing = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @fitness = dbo.fx_generateRandomNumber(newID(), 150, 200);

-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter, @club_id, 'All', @player_name, @player_age, 1, 150, 10000, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

-- Update Club
IF @counter = 1
	UPDATE dbo.club SET gk=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 2
	UPDATE dbo.club SET rb=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 3
	UPDATE dbo.club SET lb=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 4
	UPDATE dbo.club SET rw=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 5
	UPDATE dbo.club SET lw=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 6
	UPDATE dbo.club SET cd1=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 7
	UPDATE dbo.club SET cd2=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 8
	UPDATE dbo.club SET im1=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 9
	UPDATE dbo.club SET im2=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 10
	UPDATE dbo.club SET fw1=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 11
	UPDATE dbo.club SET fw2=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 12
	UPDATE dbo.club SET sgk=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 13
	UPDATE dbo.club SET sd=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 14
	UPDATE dbo.club SET sim=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 15
	UPDATE dbo.club SET sfw=@player_id+@counter WHERE dbo.club.club_id=@club_id
IF @counter = 16
	UPDATE dbo.club SET sw=@player_id+@counter WHERE dbo.club.club_id=@club_id

SET @counter=@counter+1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerNewClub]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Insert random player to 70 club
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerNewClub]
AS
BEGIN
DECLARE @counter int, @start_player_id int
SET @counter = 1;
WHILE @counter < 71
BEGIN
SET @start_player_id = ((@counter-1)*11)+1;
EXECUTE usp_PlayerNewOnly @counter, @start_player_id

SET @counter=@counter+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerNewOnly]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Generate 11 random new player for a given club_id
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerNewOnly]
(@club_id int, @start_player_id int)
AS
BEGIN
DECLARE @counter int, @player_id int, @player_name varchar(100), @first_name varchar(50), @last_name varchar(50), 
@player_age int, @keeper int, @defend int, @playmaking int, @attack int, @passing int, @fitness int
SET @counter = 0;
WHILE @counter < 11
BEGIN
SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 18, 25);
SET @keeper = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @defend = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @attack = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @passing = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @fitness = dbo.fx_generateRandomNumber(newID(), 80, 160);

-- Create New Player
INSERT INTO dbo.player VALUES (@start_player_id+@counter, @club_id, 'All', @player_name, @player_age, 1, 150, 10000, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

SET @counter=@counter+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerRename]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Player Options
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerRename]
(@club_uid varchar(1000), @pid int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

UPDATE club SET xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5, currency_second=currency_second-10 WHERE uid=@club_uid;

--ACHIEVEMENT 45
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=45)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 45, 0);
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerResetClub]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 13 Feb 2010
-- Description:	Reset club_id of player to original
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerResetClub]
(@counter1 int)
AS
BEGIN
WHILE @counter1 > 0
BEGIN
	UPDATE player SET club_id = @counter1 WHERE player_id > (@counter1-1)*11 AND player_id < (@counter1*11)+1
	SET @counter1=@counter1-1;
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerResetClubID]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 13 Feb 2010
-- Description:	Reset club_id of player to original
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerResetClubID]
(@counter1 int)
AS
BEGIN
WHILE @counter1 > 0
BEGIN
	UPDATE player SET club_id = @counter1 WHERE player_id > (@counter1-1)*11 AND player_id < (@counter1*11)+1
	SET @counter1=@counter1-1;
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerSales]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add 10 new players for sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerSales]
(@type int)
AS
BEGIN
DECLARE @counter int, @player_id int, @position varchar(50), @player_name varchar(100), @first_name varchar(50), @last_name varchar(50), 
@player_age int, @player_value int, @player_salary int, @keeper int, @defend int, @playmaking int, @attack int, @passing int, @fitness int
SET @counter = 1;
SET @player_id = ISNULL((SELECT MAX(player_id) FROM player), 0);
WHILE @counter < 11
BEGIN
SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 18, 28);

IF(@type = 1) -- KEEPER
BEGIN
SET @keeper = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @defend = 0;
SET @playmaking = 0;
SET @attack = 0;
SET @passing = 0;
SET @position = 'GK';
END

IF(@type = 2) -- DEFENDER LEFT RIGHT (DLR)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = 0;
SET @position = 'DLR';
END

IF(@type = 3) -- DEFENDER CENTER (DC)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @position = 'DC';
END

IF(@type = 4) -- MIDFIELDER LEFT RIGHT (MLR)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @position = 'MLR';
END

IF(@type = 5) -- MIDFIELDER CENTER (MC)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @position = 'MC';
END

IF(@type = 6) -- STRIKER
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @passing = 0;
SET @position = 'SC';
END

IF(@type = 7) -- DEFENDING MIDFIELDER LEFT RIGHT (DMLR)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @position = 'DMLR';
END

IF(@type = 8) -- DEFENDING MIDFIELDER CENTER (DMC)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @attack = 0;
SET @passing = 0;
SET @position = 'DMC';
END

IF(@type = 9) -- ATTACKING MIDFIELDER LEFT RIGHT (AMLR)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @passing = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @position = 'AMLR';
END

IF(@type = 10) -- ATTACKING MIDFIELDER CENTER (AMC)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @attack = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @passing = 0;
SET @position = 'AMC';
END

SET @fitness = dbo.fx_generateRandomNumber(newID(), 190, 200);
SET @player_value=(((@keeper*@keeper*5)+(@defend*@defend*3)+(@playmaking*@playmaking*3)+(@attack*@attack*3)+(@passing*@passing*3))*10);
SET @player_salary=(((@keeper*@keeper)+(@defend*@defend)+(@playmaking*@playmaking)+(@attack*@attack)+(@passing*@passing))/20);
-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter, -1, @position, @player_name, @player_age, @counter, @player_salary, @player_value, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerSalesBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2010
-- Description:	Add 10 new players for sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerSalesBulk]
AS
BEGIN

DECLARE @total_player1GK int, @total_player2GK int, @total_player3GK int, @total_player4GK int, @total_player5GK int, 
@total_player6GK int, @total_player7GK int, @total_player8GK int, @total_player9GK int, @total_player10GK int

SET @total_player2GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8GK = ISNULL((SELECT count(*) FROM player WHERE position='GK' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 2
END

IF @total_player4GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 4
END

IF @total_player6GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 6
END

IF @total_player8GK < 1
BEGIN
EXECUTE usp_PlayerSalesStar 1, 8
END


DECLARE @total_player1DLR int, @total_player2DLR int, @total_player3DLR int, @total_player4DLR int, @total_player5DLR int, 
@total_player6DLR int, @total_player7DLR int, @total_player8DLR int, @total_player9DLR int, @total_player10DLR int

SET @total_player2DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8DLR = ISNULL((SELECT count(*) FROM player WHERE position='DLR' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 2
END

IF @total_player4DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 4
END

IF @total_player6DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 6
END

IF @total_player8DLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 2, 8
END


DECLARE @total_player1DC int, @total_player2DC int, @total_player3DC int, @total_player4DC int, @total_player5DC int, 
@total_player6DC int, @total_player7DC int, @total_player8DC int, @total_player9DC int, @total_player10DC int

SET @total_player2DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8DC = ISNULL((SELECT count(*) FROM player WHERE position='DC' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 2
END

IF @total_player4DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 4
END

IF @total_player6DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 6
END

IF @total_player8DC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 3, 8
END


DECLARE @total_player1MLR int, @total_player2MLR int, @total_player3MLR int, @total_player4MLR int, @total_player5MLR int, 
@total_player6MLR int, @total_player7MLR int, @total_player8MLR int, @total_player9MLR int, @total_player10MLR int

SET @total_player2MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8MLR = ISNULL((SELECT count(*) FROM player WHERE position='MLR' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 2
END

IF @total_player4MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 4
END

IF @total_player6MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 6
END

IF @total_player8MLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 4, 8
END


DECLARE @total_player1MC int, @total_player2MC int, @total_player3MC int, @total_player4MC int, @total_player5MC int, 
@total_player6MC int, @total_player7MC int, @total_player8MC int, @total_player9MC int, @total_player10MC int

SET @total_player2MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8MC = ISNULL((SELECT count(*) FROM player WHERE position='MC' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 2
END

IF @total_player4MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 4
END

IF @total_player6MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 6
END

IF @total_player8MC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 5, 8
END


DECLARE @total_player1SC int, @total_player2SC int, @total_player3SC int, @total_player4SC int, @total_player5SC int, 
@total_player6SC int, @total_player7SC int, @total_player8SC int, @total_player9SC int, @total_player10SC int

SET @total_player2SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8SC = ISNULL((SELECT count(*) FROM player WHERE position='SC' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 2
END

IF @total_player4SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 4
END

IF @total_player6SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 6
END

IF @total_player8SC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 6, 8
END


DECLARE @total_player1DMLR int, @total_player2DMLR int, @total_player3DMLR int, @total_player4DMLR int, @total_player5DMLR int, 
@total_player6DMLR int, @total_player7DMLR int, @total_player8DMLR int, @total_player9DMLR int, @total_player10DMLR int

SET @total_player2DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8DMLR = ISNULL((SELECT count(*) FROM player WHERE position='DMLR' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 2
END

IF @total_player4DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 4
END

IF @total_player6DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 6
END

IF @total_player8DMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 7, 8
END


DECLARE @total_player1DMC int, @total_player2DMC int, @total_player3DMC int, @total_player4DMC int, @total_player5DMC int, 
@total_player6DMC int, @total_player7DMC int, @total_player8DMC int, @total_player9DMC int, @total_player10DMC int

SET @total_player2DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8DMC = ISNULL((SELECT count(*) FROM player WHERE position='DMC' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 2
END

IF @total_player4DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 4
END

IF @total_player6DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 6
END

IF @total_player8DMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 8, 8
END


DECLARE @total_player1AMLR int, @total_player2AMLR int, @total_player3AMLR int, @total_player4AMLR int, @total_player5AMLR int, 
@total_player6AMLR int, @total_player7AMLR int, @total_player8AMLR int, @total_player9AMLR int, @total_player10AMLR int

SET @total_player2AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8AMLR = ISNULL((SELECT count(*) FROM player WHERE position='AMLR' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 2
END

IF @total_player4AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 4
END

IF @total_player6AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 6
END

IF @total_player8AMLR < 1
BEGIN
EXECUTE usp_PlayerSalesStar 9, 8
END


DECLARE @total_player1AMC int, @total_player2AMC int, @total_player3AMC int, @total_player4AMC int, @total_player5AMC int, 
@total_player6AMC int, @total_player7AMC int, @total_player8AMC int, @total_player9AMC int, @total_player10AMC int

SET @total_player2AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=2 AND club_id=-1), 0);
SET @total_player4AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=4 AND club_id=-1), 0);
SET @total_player6AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=6 AND club_id=-1), 0);
SET @total_player8AMC = ISNULL((SELECT count(*) FROM player WHERE position='AMC' AND player_goals=8 AND club_id=-1), 0);

IF @total_player2AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 2
END

IF @total_player4AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 4
END

IF @total_player6AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 6
END

IF @total_player8AMC < 1
BEGIN
EXECUTE usp_PlayerSalesStar 10, 8
END


END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerSalesStar]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add 10 new players for sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerSalesStar]
(@type int, @counter int)
AS
BEGIN
DECLARE @player_id int, @position varchar(50), @player_name varchar(100), @first_name varchar(50), @last_name varchar(50), 
@player_age int, @player_value int, @player_salary int, @keeper int, @defend int, @playmaking int, @attack int, @passing int, @fitness int
SET @player_id = ISNULL((SELECT MAX(player_id) FROM player), 0);

SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 18, 28);

IF(@type = 1) -- KEEPER
BEGIN
SET @keeper = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @defend = 0;
SET @playmaking = 0;
SET @attack = 0;
SET @passing = 0;
SET @position = 'GK';
END

IF(@type = 2) -- DEFENDER LEFT RIGHT (DLR)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = 0;
SET @position = 'DLR';
END

IF(@type = 3) -- DEFENDER CENTER (DC)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @position = 'DC';
END

IF(@type = 4) -- MIDFIELDER LEFT RIGHT (MLR)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @position = 'MLR';
END

IF(@type = 5) -- MIDFIELDER CENTER (MC)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @position = 'MC';
END

IF(@type = 6) -- STRIKER
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = dbo.fx_generateRandomNumber(newID(), 13, 15)*(@counter+3);
SET @passing = 0;
SET @position = 'SC';
END

IF(@type = 7) -- DEFENDING MIDFIELDER LEFT RIGHT (DMLR)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @playmaking = 0;
SET @attack = 0;
SET @passing = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @position = 'DMLR';
END

IF(@type = 8) -- DEFENDING MIDFIELDER CENTER (DMC)
BEGIN
SET @keeper = 0;
SET @defend = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @attack = 0;
SET @passing = 0;
SET @position = 'DMC';
END

IF(@type = 9) -- ATTACKING MIDFIELDER LEFT RIGHT (AMLR)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = 0;
SET @attack = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @passing = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @position = 'AMLR';
END

IF(@type = 10) -- ATTACKING MIDFIELDER CENTER (AMC)
BEGIN
SET @keeper = 0;
SET @defend = 0;
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 10, 12)*(@counter+3);
SET @attack = dbo.fx_generateRandomNumber(newID(), 8, 10)*(@counter+3);
SET @passing = 0;
SET @position = 'AMC';
END

SET @fitness = dbo.fx_generateRandomNumber(newID(), 190, 200);
SET @player_value=(((@keeper*@keeper*5)+(@defend*@defend*3)+(@playmaking*@playmaking*3)+(@attack*@attack*3)+(@passing*@passing*3))*10);
SET @player_salary=(((@keeper*@keeper)+(@defend*@defend)+(@playmaking*@playmaking)+(@attack*@attack)+(@passing*@passing))/20);
-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter, -1, @position, @player_name, @player_age, @counter, @player_salary, @player_value, 0, 0, 0, 0, cast(cast(crypt_gen_random(1) as int) * 262.0 / 256 as int), GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerScout]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Create 2 Random players to add
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerScout]
(@club_id int)
AS
BEGIN
DECLARE @counter int, @player_id int, @player_name varchar(100), @first_name varchar(50), @last_name varchar(50), 
@player_age int, @keeper int, @defend int, @playmaking int, @attack int, @passing int, @fitness int
SET @counter = 1;
SET @player_id = ISNULL((SELECT MAX(player_id) FROM player), 0);
WHILE @counter < 3
BEGIN
SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 21, 25);
SET @keeper = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @defend = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @attack = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @passing = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @fitness = dbo.fx_generateRandomNumber(newID(), 150, 200);

-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter, @club_id, 'All', @player_name, @player_age, 2, 150, 10000, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

SET @player_name = 'Your Scouts has recruited a new player named ' + @player_name
EXEC usp_SendMailNews @club_id, @player_name

SET @counter=@counter+1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerScoutBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Dec 2010
-- Description:	Add new scouted players to all active clubs
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerScoutBulk]
AS
BEGIN
DECLARE @club_id int

DECLARE c CURSOR FOR SELECT club_id FROM club WHERE uid!='0'
OPEN c
Fetch next From c into @club_id
WHILE @@Fetch_Status=0
BEGIN
	EXEC usp_PlayerScout @club_id
	Fetch next From c into @club_id
END
CLOSE c
DEALLOCATE c
SET @club_id=0

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerUpgrade]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Player Options
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayerUpgrade]
(@club_uid varchar(1000), @pid int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

UPDATE club SET xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5, currency_second=currency_second-5 WHERE uid=@club_uid;

--ACHIEVEMENT 44
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=44)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 44, 0);
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchBot]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2010
-- Description:	Bot clubs accepts all frienldy challenges
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchBot]
AS
BEGIN
DECLARE @counter1 int

SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM View_Match WHERE match_played=0 AND match_type_id=3 AND challenge_lose=5000 AND (club_away_uid='0' OR club_away_uid='1')), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) View_Match SET match_played=1 WHERE match_played=0 AND match_type_id=3 AND challenge_lose=5000 AND (club_away_uid='0' OR club_away_uid='1')
	SET @counter1=@counter1-1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchID]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery20.sql|7|0|C:\Users\tapfantasy\AppData\Local\Temp\2\~vsBBB0.sql
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2009
-- Description:	Set match_played=1 for all match today and before today's date
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchID]
(@match_id int)
AS
BEGIN
UPDATE match SET match_played=1 WHERE match_id=@match_id;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchNull]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2009
-- Description:	Set match_played=1 for all match today and before today's date
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchNull]
AS
BEGIN
DECLARE @counter1 int

SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM match WHERE match_played=1 AND home_score is null), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) match SET match_played=1 WHERE match_played=1 AND home_score is null
	SET @counter1=@counter1-1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchToday]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2011
-- Description: Executed Every Day
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchToday]
AS
BEGIN

--Set match_played=1 for all match today and before today's date
DECLARE @counter1 int
SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM match WHERE match_played=0 AND match_datetime<=GETUTCDATE()), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) match SET match_played=1 WHERE match_datetime<=GETUTCDATE() AND match_played=0
	SET @counter1=@counter1-1;
END

--Reduce injury days by 1
UPDATE player SET player_condition=0 WHERE player_condition_days=1;
UPDATE player SET player_condition_days=player_condition_days-1 WHERE player_condition_days>0;

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchTodayAllianceOnly]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2011
-- Description: Executed Every Day
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchTodayAllianceOnly]
AS
BEGIN

--Set match_played=1 for all match today and before today's date for alliance cup only
DECLARE @counter1 int
SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM match WHERE match_played=0 AND match_datetime<=GETUTCDATE() AND match_type_id>3), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) match SET match_played=1 WHERE match_datetime<=GETUTCDATE() AND match_played=0 AND match_type_id>3
	SET @counter1=@counter1-1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchTommorow]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2009
-- Description:	Set match_played=1 for all match today and before today's date
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchTommorow]
AS
BEGIN
DECLARE @counter1 int

SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM match WHERE match_played=0 AND match_datetime<=GETDATE()+1), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) match SET match_played=1 WHERE match_datetime<=GETDATE()+1 AND match_played=0
	SET @counter1=@counter1-1;
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_Promote]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 22 June 2010
-- Description:	Promote the last division
-- =============================================
CREATE PROCEDURE [dbo].[usp_Promote]
(@division int, @series int)
AS
BEGIN

IF @division > 5
BEGIN
UPDATE club SET league_ranking=0, division=division-1, series=(((series-1)/5)*5)+(league_ranking) WHERE division=@division AND series=@series AND league_ranking is not null AND league_ranking!=0 AND league_ranking<6 --Promote
END

IF @division < 6
BEGIN
UPDATE club SET league_ranking=0, division=division-1, series=((series-1)/5)+1 WHERE division=@division AND series=@series AND league_ranking=1 --Promote
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PromoteBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk Promote Last Division
-- =============================================
CREATE PROCEDURE [dbo].[usp_PromoteBulk]
(@division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN
EXECUTE usp_Promote @division, @counter
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PromoteDemote]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 22 June 2010
-- Description:	Promote or demote divisions after league is complete
-- =============================================
CREATE PROCEDURE [dbo].[usp_PromoteDemote]
(@division int, @series int)
AS
BEGIN

IF @division > 5
BEGIN
	UPDATE club SET league_ranking=0, division=division-1, series=(((series-1)/5)*5)+(league_ranking) WHERE division=@division AND series=@series AND league_ranking is not null AND league_ranking>0 AND league_ranking<6 --Promote
	UPDATE club SET league_ranking=0, division=division+1, series=(((series-1)/5)*5)+(league_ranking-5) WHERE division=@division AND series=@series AND league_ranking is not null AND league_ranking<11 AND league_ranking>5 --Demote
END

IF @division = 5
BEGIN
	UPDATE club SET league_ranking=0, division=division-1, series=((series-1)/5)+1 WHERE division=@division AND series=@series AND league_ranking=1 --Promote
	UPDATE club SET league_ranking=0, division=division+1, series=(((series-1)/5)*5)+(league_ranking-5) WHERE division=@division AND series=@series AND league_ranking is not null AND league_ranking<11 AND league_ranking>5 --Demote
END

IF(@division = 4 OR @division = 3 OR @division = 2)
BEGIN
	UPDATE club SET league_ranking=0, division=division-1, series=((series-1)/5)+1 WHERE division=@division AND series=@series AND league_ranking=1 --Promote
	UPDATE club SET league_ranking=0, division=division+1, series=((series-1)*5)+(league_ranking-5) WHERE division=@division AND series=@series AND league_ranking is not null AND league_ranking<11 AND league_ranking>5 --Demote
END

IF @division = 1
BEGIN
	--TODO League Champion Award
	UPDATE club SET league_ranking=0, division=division+1, series=((series-1)*5)+(league_ranking-5) WHERE division=@division AND series=@series AND league_ranking is not null AND league_ranking<11 AND league_ranking>5 --Demote
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PromoteDemoteBulk]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 March 2010
-- Description:	Bulk League Generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_PromoteDemoteBulk]
(@division int, @startseries int, @maxseries int)
AS
BEGIN
DECLARE @counter int
SET @counter = @startseries;
WHILE @counter < @maxseries+1
BEGIN
EXECUTE usp_PromoteDemote @division, @counter
SET @counter=@counter+1;
END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_push]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Send Push Not through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_push]
(@devtoken varchar(100), @msg varchar(1000))
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\pushnot.vbs "'+@devtoken+'" "'+@msg+'"'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_pushall]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Send Push Not to Everyone through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_pushall]
(@msg varchar(1000))
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\pushall.vbs "'+@msg+'"'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_pushfast]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Send Push Not through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_pushfast]
(@gameid varchar(10), @devtoken varchar(100), @msg varchar(1000))
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\pushfast.vbs "'+@gameid+'" "'+@devtoken+'" "'+@msg+'"'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PushNewsAll]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Send Push Not through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_PushNewsAll]
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\ffc_PushNewsAll.vbs'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PushNewsClubs]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Send Push Not through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_PushNewsClubs]
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\ffc_PushNewsClubs.vbs'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PushNewsSeries]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 4 DEC 2010
-- Description:	Send Push Not through vbs script
-- =============================================
CREATE PROCEDURE [dbo].[usp_PushNewsSeries]
AS
BEGIN
DECLARE @param varchar(1000)
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\ffc_PushNewsSeries.vbs'
EXEC xp_cmdshell @param, no_output
END

GO
/****** Object:  StoredProcedure [dbo].[usp_RegisterSale]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reward for buying sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_RegisterSale]
(@club_uid varchar(1000), @sale_id int)
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

DECLARE @sale_sql1 nvarchar(MAX), @sale_sql2 nvarchar(MAX)

SET @sale_sql1 = (SELECT sale_sql1 FROM sales WHERE sale_id=@sale_id);
SET @sale_sql2 = (SELECT sale_sql2 FROM sales WHERE sale_id=@sale_id);

IF (@sale_sql1 IS NOT NULL AND @sale_sql1 != '')
BEGIN
	SET @sale_sql1 = @sale_sql1 + CAST(@club_id AS varchar(12));
	EXECUTE (@sale_sql1);
END

IF (@sale_sql2 IS NOT NULL AND @sale_sql2 != '')
BEGIN
	SET @sale_sql2 = @sale_sql2 + CAST(@club_id AS varchar(12));
	EXECUTE (@sale_sql2);
END

UPDATE sales SET sale_sold=sale_sold+1 WHERE sale_id=@sale_id;

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_RenameBotClub]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 1 Jan 2012
-- Description:	Bid
-- =============================================
CREATE PROCEDURE [dbo].[usp_RenameBotClub]
AS
BEGIN

DECLARE @vclub_id int, @vclub_name varchar(100), @vlogo_pic int, @counter int

Declare c Cursor For 
SELECT club_id FROM club WHERE club_name LIKE '[A-Z] CLUB'

Open c
Fetch next From c into @vclub_id
While @@Fetch_Status=0
Begin

SET @vlogo_pic = ((@vclub_id % 26)+1);
SET @counter = ((@vclub_id / 26)+1);

If @vlogo_pic = 1
Begin
	SET @vclub_name = 'CLUB A' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 2
Begin
	SET @vclub_name = 'CLUB B' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 3
Begin
	SET @vclub_name = 'CLUB C' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 4
Begin
	SET @vclub_name = 'CLUB D' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 5
Begin
	SET @vclub_name = 'CLUB E' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 6
Begin
	SET @vclub_name = 'CLUB F' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 7
Begin
	SET @vclub_name = 'CLUB G' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 8
Begin
	SET @vclub_name = 'CLUB H' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 9
Begin
	SET @vclub_name = 'CLUB I' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 10
Begin
	SET @vclub_name = 'CLUB J' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 11
Begin
	SET @vclub_name = 'CLUB K' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 12
Begin
	SET @vclub_name = 'CLUB L' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 13
Begin
	SET @vclub_name = 'CLUB M' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 14
Begin
	SET @vclub_name = 'CLUB N' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 15
Begin
	SET @vclub_name = 'CLUB O' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 16
Begin
	SET @vclub_name = 'CLUB P' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 17
Begin
	SET @vclub_name = 'CLUB Q' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 18
Begin
	SET @vclub_name = 'CLUB R' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 19
Begin
	SET @vclub_name = 'CLUB S' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 20
Begin
	SET @vclub_name = 'CLUB T' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 21
Begin
	SET @vclub_name = 'CLUB U' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 22
Begin
	SET @vclub_name = 'CLUB V' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 23
Begin
	SET @vclub_name = 'CLUB W' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 24
Begin
	SET @vclub_name = 'CLUB X' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 25
Begin
	SET @vclub_name = 'CLUB Y' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 26
Begin
	SET @vclub_name = 'CLUB Z' + CAST(@counter AS VARCHAR);
End

UPDATE club SET club_name=@vclub_name, logo_pic=@vlogo_pic WHERE club_id=@vclub_id;

Fetch next From c into @vclub_id

End
Close c
Deallocate c

END
GO
/****** Object:  StoredProcedure [dbo].[usp_Reset]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to humble begining  (USED in ResetClub)
-- =============================================
CREATE PROCEDURE [dbo].[usp_Reset]
(@club_id int)
AS
BEGIN

DECLARE @vclub_name varchar(100), @vlogo_pic int, @counter int

SET @vlogo_pic = ((@club_id % 26)+1);
SET @counter = ((@club_id / 26)+1);

If @vlogo_pic = 1
Begin
	SET @vclub_name = 'CLUB A' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 2
Begin
	SET @vclub_name = 'CLUB B' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 3
Begin
	SET @vclub_name = 'CLUB C' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 4
Begin
	SET @vclub_name = 'CLUB D' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 5
Begin
	SET @vclub_name = 'CLUB E' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 6
Begin
	SET @vclub_name = 'CLUB F' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 7
Begin
	SET @vclub_name = 'CLUB G' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 8
Begin
	SET @vclub_name = 'CLUB H' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 9
Begin
	SET @vclub_name = 'CLUB I' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 10
Begin
	SET @vclub_name = 'CLUB J' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 11
Begin
	SET @vclub_name = 'CLUB K' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 12
Begin
	SET @vclub_name = 'CLUB L' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 13
Begin
	SET @vclub_name = 'CLUB M' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 14
Begin
	SET @vclub_name = 'CLUB N' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 15
Begin
	SET @vclub_name = 'CLUB O' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 16
Begin
	SET @vclub_name = 'CLUB P' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 17
Begin
	SET @vclub_name = 'CLUB Q' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 18
Begin
	SET @vclub_name = 'CLUB R' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 19
Begin
	SET @vclub_name = 'CLUB S' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 20
Begin
	SET @vclub_name = 'CLUB T' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 21
Begin
	SET @vclub_name = 'CLUB U' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 22
Begin
	SET @vclub_name = 'CLUB V' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 23
Begin
	SET @vclub_name = 'CLUB W' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 24
Begin
	SET @vclub_name = 'CLUB X' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 25
Begin
	SET @vclub_name = 'CLUB Y' + CAST(@counter AS VARCHAR);
End
Else If @vlogo_pic = 26
Begin
	SET @vclub_name = 'CLUB Z' + CAST(@counter AS VARCHAR);
End

UPDATE club 
SET revenue_stadium=0, revenue_sponsors=0, revenue_sales=0, revenue_others=0, expenses_stadium=0, expenses_purchases=0,
expenses_others=0, revenue_investments=0, expenses_salary=0, expenses_interest=0, revenue_total=0, expenses_total=0, balance=199000,
playing_cup=0, undefeated_counter=0, fan_members=100, fan_mood=10, stadium_capacity=50, stadium=1,
average_ticket=1, managers=0, scouts=0, spokespersons=0, coaches=0, psychologists=0, accountants=0, physiotherapists=0,
gk=0, rb=0, lb=0, rw=0, lw=0, cd1=0, cd2=0, cd3=0, im1=0, im2=0, im3=0, fw1=0, fw2=0, fw3=0,
sgk=0, sd=0, sim=0, sfw=0, sw=0, captain=0, penalty=0, freekick=0, cornerkick=0,
doctors=0, coach_id=1, teamspirit=100, confidence=100, energy=20, xp=0, e=20, building1=0, building2=0, building3=0, 
currency_second=25, alliance_id=0, home_pic=26, away_pic=26, club_name=@vclub_name, logo_pic=CAST(@vlogo_pic AS varchar(6)) 
WHERE club_id = @club_id

DELETE trophy WHERE club_id = @club_id

DELETE achievement WHERE club_id = @club_id

DELETE bid WHERE club_id = @club_id

DELETE player WHERE club_id=@club_id

EXEC usp_PlayerNew @club_id

END

GO
/****** Object:  StoredProcedure [dbo].[usp_ResetClub]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to humble begining
-- =============================================
CREATE PROCEDURE [dbo].[usp_ResetClub]
(@club_uid varchar(1000))
AS
BEGIN

DECLARE @club_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_ResetJump]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to humble begining
-- =============================================
CREATE PROCEDURE [dbo].[usp_ResetJump]
(@club_uid varchar(1000))
AS
BEGIN

DECLARE @club_id int, @game_id int

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);
SET @game_id = ISNULL((SELECT game_id FROM club WHERE [uid]=@club_uid), 0);

IF @club_id != 0
BEGIN

EXEC usp_Reset @club_id

UPDATE TOP(1) club SET fb_name='', last_login=GETDATE(), date_found=GETDATE(), game_id=@game_id, [uid]=@club_uid WHERE uid='0'

UPDATE club SET [uid] = '0' WHERE club_id=@club_id

SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_uid), 0);
IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
END

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_ResetRemove]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to remove forever
-- =============================================
CREATE PROCEDURE [dbo].[usp_ResetRemove]
(@club_uid varchar(1000))
AS
BEGIN
DECLARE @club_id int, @club_u varchar(1000)

SET @club_u = '0'+@club_uid;
SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_u), 0);
IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
UPDATE club SET [uid] = '0' WHERE club_id=@club_id
DELETE transactions WHERE uid = @club_u
DELETE admin_block WHERE uid = @club_u
END

SET @club_u = '1'+@club_uid;
SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_u), 0);
IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
UPDATE club SET [uid] = '0' WHERE club_id=@club_id
DELETE transactions WHERE uid = @club_u
DELETE admin_block WHERE uid = @club_u
END

SET @club_u = '2'+@club_uid;
SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_u), 0);
IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
UPDATE club SET [uid] = '0' WHERE club_id=@club_id
DELETE transactions WHERE uid = @club_u
DELETE admin_block WHERE uid = @club_u
END

SET @club_u = '3'+@club_uid;
SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_u), 0);
IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
UPDATE club SET [uid] = '0' WHERE club_id=@club_id
DELETE transactions WHERE uid = @club_u
DELETE admin_block WHERE uid = @club_u
END

SET @club_u = '4'+@club_uid;
SET @club_id = ISNULL((SELECT club_id FROM club WHERE [uid]=@club_u), 0);
IF @club_id != 0
BEGIN
EXEC usp_Reset @club_id
UPDATE club SET [uid] = '0' WHERE club_id=@club_id
DELETE transactions WHERE uid = @club_u
DELETE admin_block WHERE uid = @club_u
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SalesRandom]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 11 December 2009
-- Description:	Add a random sale
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesRandom]
AS
BEGIN
DECLARE @counter int, @sale_id int, 
@sale_row3 varchar(250), @sale_row4 varchar(250), @sale_price varchar(250), @sale_identifier varchar(250), @sale_sql1 varchar(1000), @sale_sql2 varchar(1000), 
@bundle1_quantity varchar(250), @bundle2_quantity varchar(250), @bundle3_quantity varchar(250), @bundle4_quantity varchar(250),
@sale_duration int, @sale_start int, @sale_random int

SET @sale_id = ISNULL((SELECT MAX(sale_id) FROM sales), 0);
SET @counter = (SELECT COUNT(*) FROM sales WHERE sale_starting < GETUTCDATE() AND sale_ending > GETUTCDATE())

IF @counter = 0
BEGIN

SET @sale_start = dbo.fx_generateRandomNumber(newID(), 0, 2);
SET @sale_duration = dbo.fx_generateRandomNumber(newID(), 3, 5);
SET @sale_row4 = '';

SET @sale_random = dbo.fx_generateRandomNumber(newID(), 1, 5);

IF @sale_random = 1
BEGIN
SET @sale_row3 = '2000 DIAMONDS';
SET @sale_price = '$99.99';
SET @sale_identifier = 'sale1';
SET @bundle1_quantity = '250';
SET @bundle2_quantity = '50,000';
SET @bundle3_quantity = '3';
SET @bundle4_quantity = '2,000';
SET @sale_sql1 = 'UPDATE club SET currency_second=currency_second+2250, balance=balance+50000, fan_members=fan_members+2000 WHERE club_id=';
SET @sale_sql2 = 'EXECUTE usp_PlayerBundle 3, ';
END

IF @sale_random = 2
BEGIN
SET @sale_row3 = '1000 DIAMONDS';
SET @sale_price = '$49.99';
SET @sale_identifier = 'sale2';
SET @bundle1_quantity = '100';
SET @bundle2_quantity = '35,000';
SET @bundle3_quantity = '2';
SET @bundle4_quantity = '1,000';
SET @sale_sql1 = 'UPDATE club SET currency_second=currency_second+1100, balance=balance+35000, fan_members=fan_members+1000 WHERE club_id=';
SET @sale_sql2 = 'EXECUTE usp_PlayerBundle 2, ';
END

IF @sale_random = 3
BEGIN
SET @sale_row3 = '275 DIAMONDS';
SET @sale_price = '$19.99';
SET @sale_identifier = 'sc5';
SET @bundle1_quantity = '50';
SET @bundle2_quantity = '20,000';
SET @bundle3_quantity = '1';
SET @bundle4_quantity = '500';
SET @sale_sql1 = 'UPDATE club SET currency_second=currency_second+325, balance=balance+20000, fan_members=fan_members+500 WHERE club_id=';
SET @sale_sql2 = 'EXECUTE usp_PlayerBundle 1, ';
END

IF @sale_random = 4
BEGIN
SET @sale_row3 = '150 DIAMONDS';
SET @sale_price = '$9.99';
SET @sale_identifier = 'sc4';
SET @bundle1_quantity = '30';
SET @bundle2_quantity = '15,000';
SET @bundle3_quantity = '0';
SET @bundle4_quantity = '500';
SET @sale_sql1 = 'UPDATE club SET currency_second=currency_second+180, balance=balance+15000, fan_members=fan_members+500 WHERE club_id=';
SET @sale_sql2 = '';
END

IF @sale_random = 5
BEGIN
SET @sale_row3 = '60 DIAMONDS';
SET @sale_price = '$4.99';
SET @sale_identifier = 'sc3';
SET @bundle1_quantity = '20';
SET @bundle2_quantity = '10,000';
SET @bundle3_quantity = '0';
SET @bundle4_quantity = '300';
SET @sale_sql1 = 'UPDATE club SET currency_second=currency_second+80, balance=balance+10000, fan_members=fan_members+300 WHERE club_id=';
SET @sale_sql2 = '';
END

INSERT INTO dbo.sales VALUES (@sale_id+1, 1, 0, '', '', @sale_row3, @sale_row4, @sale_duration, GETUTCDATE()+@sale_start, GETUTCDATE()+@sale_start+@sale_duration, @sale_price, @sale_identifier, @sale_sql1, @sale_sql2, '', @bundle1_quantity, @bundle2_quantity, @bundle3_quantity, @bundle4_quantity)

END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SendMailAlliance]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Send to alliance members only
-- =============================================
CREATE PROCEDURE [dbo].[usp_SendMailAlliance]
(@a_id int, @msg varchar(MAX), @club_id int)
AS
BEGIN

IF @a_id != 0
BEGIN
INSERT INTO dbo.mail VALUES (GETUTCDATE(), N'', @msg, 0, @a_id, 0, N'', 0, N'Secretary', 0, 0);
INSERT INTO alliance_wall VALUES (@club_id, N'Notice', @msg, GETUTCDATE(), @a_id, N'', @a_id)
END

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SendMailNews]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to humble begining
-- =============================================
CREATE PROCEDURE [dbo].[usp_SendMailNews]
(@club_id int, @msg varchar(MAX))
AS
BEGIN

IF @msg is not NULL
BEGIN

IF @club_id = 0
BEGIN
INSERT INTO dbo.news VALUES (GETUTCDATE(), 0, 1, @msg, N'', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.mail VALUES (GETUTCDATE(), N'', @msg, 1, -1, 0, N'', 0, N'Secretary', 0, 0);
END
ELSE
BEGIN
INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @msg, N'', '', 0, @club_id, 0, 0, 0)
END

END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_SendMailPush]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 12 Oct 2010
-- Description:	Reset club to humble begining
-- =============================================
CREATE PROCEDURE [dbo].[usp_SendMailPush]
(@msg varchar(MAX))
AS
BEGIN

INSERT INTO dbo.news VALUES (GETUTCDATE(), 1, 1, @msg, N'', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.mail VALUES (GETUTCDATE(), N'', @msg, 1, -1, 0, N'', 0, N'Secretary', 0, 0);

END

GO
/****** Object:  StoredProcedure [dbo].[usp_Weekly]    Script Date: 2/14/2017 9:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 17 Sept 2009
-- Description:	Once a week update
-- =============================================
CREATE PROCEDURE [dbo].[usp_Weekly]
AS
BEGIN

EXECUTE usp_SalesRandom;

DELETE FROM news;
DELETE FROM mail WHERE everyone = 1;

DELETE player WHERE club_id=0;

--Update league ranking
UPDATE season SET league_round=league_round+1, cup_round=cup_round+2;
UPDATE season SET league_round=18 WHERE league_round>18;

--Accept challenge from bot clubs for 5000 only
--EXECUTE usp_PlayMatchBot

--mantain player values
UPDATE player SET keeper=0 WHERE keeper is null OR keeper<0
UPDATE player SET defend=0 WHERE defend is null OR defend<0
UPDATE player SET playmaking=0 WHERE playmaking is null OR playmaking<0
UPDATE player SET attack=0 WHERE attack is null OR attack<0
UPDATE player SET passing=0 WHERE passing is null OR passing<0
UPDATE player SET fitness=0 WHERE fitness is null OR fitness<0
UPDATE player SET happiness=0 WHERE happiness is null OR happiness<0
UPDATE player SET keeper=199 WHERE keeper>200
UPDATE player SET defend=199 WHERE defend>200
UPDATE player SET playmaking=199 WHERE playmaking>200
UPDATE player SET attack=199 WHERE attack>200
UPDATE player SET passing=199 WHERE passing>200
UPDATE player SET fitness=199 WHERE fitness>200
UPDATE player SET happiness=199 WHERE happiness>200

--Update Player Stats
UPDATE View_PlayerClub SET 
keeper = CASE WHEN (training = 1) THEN keeper - player_condition + 1 + (CAST((dbo.fx_minOf(200, coaches)+coach_skill) AS real)/100) ELSE keeper END,
defend = CASE WHEN (training = 2) THEN defend - player_condition + 1 + (CAST((dbo.fx_minOf(200, coaches)+coach_skill) AS real)/100) ELSE defend END,
playmaking = CASE WHEN (training = 3) THEN playmaking - player_condition + 1 + (CAST((dbo.fx_minOf(200, coaches)+coach_skill) AS real)/100) ELSE playmaking END,
attack = CASE WHEN (training = 4) THEN attack - player_condition + 1 + (CAST((dbo.fx_minOf(200, coaches)+coach_skill) AS real)/100) ELSE attack END,
passing = CASE WHEN (training = 5) THEN passing - player_condition + 1 + (CAST((dbo.fx_minOf(200, coaches)+coach_skill) AS real)/100) ELSE passing END,
fitness = CASE WHEN (training = 6) THEN fitness + 10 ELSE fitness END,
player_condition_days=player_condition_days-7-doctors 
WHERE club_id != 0

UPDATE player SET 
player_value=(((keeper*keeper*5)+(defend*defend*3)+(playmaking*playmaking*3)+(attack*attack*3)+(passing*passing*3))*10),
player_salary=(((keeper*keeper)+(defend*defend)+(playmaking*playmaking)+(attack*attack)+(passing*passing))/20) 
WHERE club_id != 0 AND club_id != -1

UPDATE player SET player_goals=1 WHERE player_goals<1
UPDATE player SET player_goals=10 WHERE player_goals>10

--Clear negative player_condition_days
UPDATE player SET player_condition_days=0 WHERE player_condition_days < 0
UPDATE player SET player_condition=0 WHERE player_condition_days = 0
UPDATE player SET fitness=fitness+20 WHERE fitness<181 AND player_condition=0

--mantain player values
UPDATE player SET keeper=0 WHERE keeper is null OR keeper<0
UPDATE player SET defend=0 WHERE defend is null OR defend<0
UPDATE player SET playmaking=0 WHERE playmaking is null OR playmaking<0
UPDATE player SET attack=0 WHERE attack is null OR attack<0
UPDATE player SET passing=0 WHERE passing is null OR passing<0
UPDATE player SET fitness=0 WHERE fitness is null OR fitness<0
UPDATE player SET happiness=0 WHERE happiness is null OR happiness<0
UPDATE player SET keeper=199 WHERE keeper>200
UPDATE player SET defend=199 WHERE defend>200
UPDATE player SET playmaking=199 WHERE playmaking>200
UPDATE player SET attack=199 WHERE attack>200
UPDATE player SET passing=199 WHERE passing>200
UPDATE player SET fitness=199 WHERE fitness>200
UPDATE player SET happiness=199 WHERE happiness>200

--Mantainance
UPDATE club SET fan_mood = 100 WHERE fan_mood is null OR fan_mood<0
UPDATE club SET teamspirit = 100 WHERE teamspirit is null OR teamspirit<0
UPDATE club SET revenue_sponsors = 0 WHERE revenue_sponsors is null OR revenue_sponsors<0
UPDATE club SET revenue_total = 0 WHERE revenue_total is null OR revenue_total<0

UPDATE club SET
revenue_sponsors=dbo.fx_minOf(100000, fan_members), 
expenses_stadium=0, 
expenses_interest=0, 
revenue_investments=accountants, 
expenses_salary=(SELECT SUM(player_salary) FROM player WHERE player.club_id=club.club_id) --+ coach_salary 
WHERE uid != '0'

--Clear negative finance
UPDATE club SET revenue_investments=0 WHERE revenue_investments is null OR revenue_investments<0
UPDATE club SET expenses_interest=0 WHERE expenses_interest is null OR expenses_interest<0
UPDATE club SET expenses_salary=0 WHERE expenses_salary is null OR expenses_salary<0
UPDATE club SET expenses_total=0 WHERE expenses_total is null OR expenses_total<0
UPDATE club SET balance=0 WHERE balance is null

--Update Club Total and Balance
UPDATE club SET
revenue_stadium=0,
revenue_sales=0,
revenue_others=0,
expenses_purchases=0,
expenses_others=0, 
revenue_total=revenue_sponsors+revenue_investments,
expenses_total=expenses_stadium+expenses_salary+expenses_interest,
balance=balance+(revenue_sponsors+revenue_investments)-(expenses_stadium+expenses_salary+expenses_interest),
teamspirit=teamspirit+psychologists,
confidence=confidence+psychologists,
fan_mood=fan_mood+spokespersons 
WHERE uid != '0'

--Clear negative finance
UPDATE club SET revenue_investments=0 WHERE revenue_investments is null OR revenue_investments<0
UPDATE club SET expenses_interest=0 WHERE expenses_interest is null OR expenses_interest<0
UPDATE club SET expenses_salary=0 WHERE expenses_salary is null OR expenses_salary<0
UPDATE club SET expenses_total=0 WHERE expenses_total is null OR expenses_total<0
UPDATE club SET balance=0 WHERE balance is null

--Clear over limit fan_mood, teamsprit, confidence
UPDATE club SET teamspirit=190 WHERE teamspirit > 200
UPDATE club SET confidence=190 WHERE confidence > 200
UPDATE club SET fan_mood=190 WHERE fan_mood > 200
UPDATE club SET fan_members = 100 WHERE fan_members is null OR fan_members<100

EXECUTE usp_SendMailNews 0, 'Amazing discount for your 1st purchase. Purchase any amount of Diamonds now and automatically receive 70 Diamonds more!'
--EXECUTE usp_SendMailNews 0, 'Play Slots to earn more Diamonds for your club! You will find the Slots button beside the log out button bellow'
--EXECUTE usp_SendMailNews 0, '50% discount on Energy refills! USD$0.99 only for a limited time (usually USD$1.99)'
--EXECUTE usp_SendMailNews 0, 'Heavily discounted club FUNDS for purchase, stock up now! Just 60 Diamonds for $300K, usually cost 100 Diamonds'
--EXECUTE usp_SendMailNews 0, 'Like us on our Facebook to stay connected and get news on whats coming soon! https://www.facebook.com/footballelevenmanager'
--EXECUTE usp_SendMailNews 0, 'Here is an offer you cant refuse. Buy 1700 Diamonds now and receive a FREE 5 STAR player for your team! (limited time only)'
EXECUTE usp_SendMailNews 0, 'Buy 800 Diamonds now and receive FREE 200 more!'

--Start new league if end of season
DECLARE @total_match int, @total_match_played int
SET @total_match = ISNULL((SELECT count(*) FROM match WHERE match_type_id=1 AND season_week=18), 1);
SET @total_match_played = ISNULL((SELECT count(*) FROM match WHERE match_type_id=1 AND season_week=18 AND match_played=1), 0);
IF(@total_match = @total_match_played)
BEGIN
SET DEADLOCK_PRIORITY HIGH;
UPDATE league SET last_update=GETUTCDATE() --Prevents UpdateLeaguePosition from executing on WS
EXECUTE usp_League_NEW_Part1 --11 Hours to complete
EXECUTE usp_League_NEW_Part2 --23 Minutes
EXECUTE usp_League_NEW_Part3 --5 Minutes
EXECUTE usp_League_NEW_Part4 --8 Hours
EXECUTE usp_SendMailNews 0, 'A new league season has kicked off. The board wishes you good luck.';
EXECUTE usp_PlayerSalesBulk
END

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Rowid_Series'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Rowid_Series'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "alliance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 197
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 28
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1635
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Alliance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Alliance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "alliance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 265
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AllianceEvent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AllianceEvent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "alliance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 20
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1860
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AllianceEventResult'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AllianceEventResult'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[39] 4[33] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -480
         Left = 0
      End
      Begin Tables = 
         Begin Table = "club"
            Begin Extent = 
               Top = 15
               Left = 26
               Bottom = 157
               Right = 299
            End
            DisplayFlags = 280
            TopColumn = 16
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 134
         Width = 284
         Width = 690
         Width = 3675
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3285
         Width = 1500
         Width = 1770
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Club'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1530
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2145
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1710
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7080
         Alias = 2895
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Club'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Club'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[7] 2[45] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "club"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 15
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ClubInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ClubInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "club"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ClubROWID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ClubROWID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[25] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "match"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 205
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 16
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 77
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Match'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7725
         Alias = 1470
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Match'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Match'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[20] 2[28] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "match"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 223
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "match_highlight"
            Begin Extent = 
               Top = 6
               Left = 323
               Bottom = 195
               Right = 486
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "player"
            Begin Extent = 
               Top = 6
               Left = 524
               Bottom = 221
               Right = 711
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3360
         Alias = 555
         Table = 1560
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1260
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_MatchHighlightPlayer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_MatchHighlightPlayer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[53] 4[29] 2[4] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "player"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 356
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "View_Club"
            Begin Extent = 
               Top = 18
               Left = 382
               Bottom = 413
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2100
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PlayerClub'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_PlayerClub'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[21] 4[12] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "x"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 106
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Promotion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Promotion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[41] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "View_SeriesBase"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 17
         Width = 284
         Width = 1095
         Width = 2430
         Width = 720
         Width = 615
         Width = 675
         Width = 465
         Width = 570
         Width = 1140
         Width = 1290
         Width = 1470
         Width = 1845
         Width = 2100
         Width = 2100
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 50595
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Series'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Series'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "match"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "club"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 114
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_SeriesBase'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_SeriesBase'
GO
USE [master]
GO
ALTER DATABASE [football] SET  READ_WRITE 
GO

USE [master]
GO
/****** Object:  Database [baseball]    Script Date: 08/24/2011 10:05:03 ******/
CREATE DATABASE [baseball] ON  PRIMARY 
( NAME = N'baseball_data', FILENAME = N'F:\mdf\baseball.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'baseball_log', FILENAME = N'D:\ldf\baseball.ldf' , SIZE = 1024KB , MAXSIZE = UNLIMITED , FILEGROWTH = 10%)
GO
ALTER DATABASE [baseball] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [baseball].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [baseball] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [baseball] SET ANSI_NULLS OFF
GO
ALTER DATABASE [baseball] SET ANSI_PADDING OFF
GO
ALTER DATABASE [baseball] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [baseball] SET ARITHABORT OFF
GO
ALTER DATABASE [baseball] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [baseball] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [baseball] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [baseball] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [baseball] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [baseball] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [baseball] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [baseball] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [baseball] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [baseball] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [baseball] SET  DISABLE_BROKER
GO
ALTER DATABASE [baseball] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [baseball] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [baseball] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [baseball] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [baseball] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [baseball] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [baseball] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [baseball] SET  READ_WRITE
GO
ALTER DATABASE [baseball] SET RECOVERY SIMPLE
GO
ALTER DATABASE [baseball] SET  MULTI_USER
GO
ALTER DATABASE [baseball] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [baseball] SET DB_CHAINING OFF
GO
USE [baseball]
GO
/****** Object:  StoredProcedure [dbo].[usp_PushNewsSeries]    Script Date: 08/24/2011 10:05:04 ******/
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
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\baseball_PushNewsSeries.vbs'
EXEC xp_cmdshell @param, no_output
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PushNewsClubs]    Script Date: 08/24/2011 10:05:04 ******/
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
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\baseball_PushNewsClubs.vbs'
EXEC xp_cmdshell @param, no_output
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PushNewsAll]    Script Date: 08/24/2011 10:05:04 ******/
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
SET @param = 'C:\windows\system32\cscript.exe c:\vbs\baseball_PushNewsAll.vbs'
EXEC xp_cmdshell @param, no_output
END
GO
/****** Object:  StoredProcedure [dbo].[usp_pushfast]    Script Date: 08/24/2011 10:05:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_pushall]    Script Date: 08/24/2011 10:05:04 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_push]    Script Date: 08/24/2011 10:05:04 ******/
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
/****** Object:  Table [dbo].[trophy]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[trophy](
	[trophy_id] [int] NOT NULL,
	[club_id] [int] NOT NULL,
	[type] [int] NOT NULL,
	[name] [varchar](250) NULL,
	[title] [varchar](250) NULL,
 CONSTRAINT [PK_trophy] PRIMARY KEY CLUSTERED 
(
	[trophy_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[news]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[news](
	[news_id] [int] IDENTITY(1,1) NOT NULL,
	[news_datetime] [datetime] NOT NULL,
	[push] [bit] NOT NULL,
	[marquee] [bit] NOT NULL,
	[headline] [varchar](max) NOT NULL,
	[news] [varchar](max) NOT NULL,
	[image_url] [varchar](max) NOT NULL,
	[everyone] [bit] NOT NULL,
	[club_id] [int] NOT NULL,
	[division] [int] NOT NULL,
	[series] [int] NOT NULL,
	[playing_cup] [bit] NOT NULL,
 CONSTRAINT [PK_news] PRIMARY KEY CLUSTERED 
(
	[news_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[match_type]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[match_type](
	[match_type_id] [int] NOT NULL,
	[definition] [varchar](max) NULL,
 CONSTRAINT [PK_admin_match_type] PRIMARY KEY CLUSTERED 
(
	[match_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[match_highlight_type]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[match_highlight_type](
	[highlight_type_id] [int] NOT NULL,
	[definition] [varchar](max) NULL,
 CONSTRAINT [PK_match_highlight_type] PRIMARY KEY CLUSTERED 
(
	[highlight_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[match_highlight]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[match_highlight](
	[highlight_id] [int] IDENTITY(1,1) NOT NULL,
	[match_id] [int] NULL,
	[match_minute] [int] NULL,
	[player_id] [int] NULL,
	[highlight_type_id] [int] NULL,
	[highlight] [varchar](max) NULL,
 CONSTRAINT [PK_match_highlight] PRIMARY KEY CLUSTERED 
(
	[highlight_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[product]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[product](
	[product_id] [int] NOT NULL,
	[identifier] [varchar](250) NOT NULL,
	[for_sale] [bit] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[category] [varchar](50) NULL,
	[name] [varchar](50) NULL,
	[description] [varchar](500) NULL,
	[sql_command] [varchar](1000) NULL,
	[price_real] [int] NOT NULL,
	[price_virtual] [varchar](50) NULL,
	[product_star] [int] NULL,
	[image_url] [varchar](500) NULL,
	[content_url] [varchar](500) NULL,
 CONSTRAINT [PK_product] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[player_condition]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[player_condition](
	[condition_id] [int] NOT NULL,
	[definition] [varchar](max) NULL,
 CONSTRAINT [PK_player_condition] PRIMARY KEY CLUSTERED 
(
	[condition_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[transactions](
	[transaction_id] [int] IDENTITY(1,1) NOT NULL,
	[transaction_datetime] [datetime] NOT NULL,
	[uid] [varchar](50) NOT NULL,
	[product_id] [int] NOT NULL,
	[product_type] [varchar](50) NOT NULL,
	[product_price] [int] NOT NULL,
 CONSTRAINT [PK_transactions] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[season]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
 CONSTRAINT [PK_season] PRIMARY KEY CLUSTERED 
(
	[season_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[league]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[league](
	[division] [int] NULL,
	[series] [int] NULL,
	[last_update] [date] NULL,
	[table_xml] [nvarchar](max) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[identifier]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[identifier](
	[identifier_id] [int] NOT NULL,
	[game_id] [varchar](10) NOT NULL,
	[cup] [varchar](250) NULL,
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
	[star1] [varchar](250) NULL,
	[star2] [varchar](250) NULL,
	[star3] [varchar](250) NULL,
	[star4] [varchar](250) NULL,
	[star5] [varchar](250) NULL,
	[star6] [varchar](250) NULL,
	[star7] [varchar](250) NULL,
	[star8] [varchar](250) NULL,
	[star9] [varchar](250) NULL,
	[star10] [varchar](250) NULL,
	[fund1] [varchar](250) NULL,
	[fund2] [varchar](250) NULL,
	[fund3] [varchar](250) NULL,
	[fund4] [varchar](250) NULL,
	[fund5] [varchar](250) NULL,
	[leaderboard1] [varchar](250) NULL,
	[leaderboard2] [varchar](250) NULL,
	[leaderboard3] [varchar](250) NULL,
	[achievement1] [varchar](250) NULL,
	[achievement2] [varchar](250) NULL,
	[achievement3] [varchar](250) NULL,
	[appfile] [varchar](250) NULL,
	[reviews] [varchar](500) NULL,
	[rss] [varchar](500) NULL,
 CONSTRAINT [PK_identifier] PRIMARY KEY CLUSTERED 
(
	[identifier_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[chat]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chat](
	[chat_id] [int] IDENTITY(1,1) NOT NULL,
	[club_id] [int] NOT NULL,
	[club_name] [nvarchar](max) NOT NULL,
	[message] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_chat] PRIMARY KEY CLUSTERED 
(
	[chat_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bid]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bid](
	[bid_id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [varchar](50) NOT NULL,
	[club_id] [int] NOT NULL,
	[club_name] [nvarchar](max) NOT NULL,
	[player_id] [int] NOT NULL,
	[bid_value] [int] NOT NULL,
	[bid_datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_bid] PRIMARY KEY CLUSTERED 
(
	[bid_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_weather]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_weather](
	[weather_id] [int] NOT NULL,
	[definition] [varchar](50) NULL,
 CONSTRAINT [PK_admin_weather] PRIMARY KEY CLUSTERED 
(
	[weather_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_training]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_training](
	[training_id] [int] NOT NULL,
	[definition] [varchar](max) NOT NULL,
 CONSTRAINT [PK_training] PRIMARY KEY CLUSTERED 
(
	[training_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_tactic]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_tactic](
	[tactic_id] [int] NOT NULL,
	[definition] [varchar](max) NULL,
 CONSTRAINT [PK_admin_tactic] PRIMARY KEY CLUSTERED 
(
	[tactic_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_name_last]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_name_last](
	[name] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_name_first]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_name_first](
	[name] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_formation]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_formation](
	[formation_id] [int] NOT NULL,
	[definition] [varchar](50) NULL,
 CONSTRAINT [PK_admin_formation] PRIMARY KEY CLUSTERED 
(
	[formation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_fan]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_fan](
	[expectation_id] [int] NOT NULL,
	[definition] [varchar](50) NULL,
 CONSTRAINT [PK_fan_expectation] PRIMARY KEY CLUSTERED 
(
	[expectation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_division]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin_division](
	[division_id] [int] NOT NULL,
	[division] [int] NULL,
	[total_series] [int] NULL,
 CONSTRAINT [PK_division] PRIMARY KEY CLUSTERED 
(
	[division_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[admin_character]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_character](
	[character_id] [int] NOT NULL,
	[character] [varchar](1000) NULL,
 CONSTRAINT [PK_admin_character] PRIMARY KEY CLUSTERED 
(
	[character_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[admin_block]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admin_block](
	[block_id] [int] NOT NULL,
	[uid] [varchar](50) NOT NULL,
 CONSTRAINT [PK_admin_block] PRIMARY KEY CLUSTERED 
(
	[block_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[achievement_type]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[achievement]    Script Date: 08/24/2011 10:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[achievement](
	[achievement_id] [int] IDENTITY(1,1) NOT NULL,
	[club_id] [int] NOT NULL,
	[achievement_type_id] [int] NOT NULL,
 CONSTRAINT [PK_achievements] PRIMARY KEY CLUSTERED 
(
	[achievement_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fx_convertVarcharHexToDec]    Script Date: 08/24/2011 10:05:08 ******/
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
/****** Object:  Table [dbo].[coach]    Script Date: 08/24/2011 10:05:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[club]    Script Date: 08/24/2011 10:05:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[club](
	[club_id] [int] NOT NULL,
	[game_id] [varchar](10) NULL,
	[uid] [varchar](50) NULL,
	[club_name] [varchar](50) NULL,
	[last_login] [datetime] NULL,
	[date_found] [datetime] NULL,
	[longitude] [float] NULL,
	[latitude] [float] NULL,
	[playing_cup] [bit] NOT NULL,
	[division] [int] NULL,
	[series] [int] NULL,
	[league_ranking] [int] NULL,
	[undefeated_counter] [int] NULL,
	[fan_members] [int] NULL,
	[fan_mood] [int] NULL,
	[fan_expectation] [int] NULL,
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
	[balance] [int] NULL,
	[devicetoken] [varchar](100) NULL,
	[fb_uid] [varchar](50) NULL,
	[fb_name] [varchar](250) NULL,
	[fb_pic] [varchar](250) NULL,
	[fb_sex] [varchar](50) NULL,
	[fb_email] [varchar](250) NULL,
	[face_pic] [varchar](250) NULL,
	[logo_pic] [varchar](250) NULL,
	[home_pic] [varchar](250) NULL,
	[away_pic] [varchar](250) NULL,
	[energy] [int] NULL,
	[xp] [int] NULL,
	[e] [int] NULL,
	[building1] [int] NULL,
	[building1_dt] [datetime] NULL,
	[building2] [int] NULL,
	[building2_dt] [datetime] NULL,
	[building3] [int] NULL,
	[building3_dt] [datetime] NULL,
 CONSTRAINT [PK_club] PRIMARY KEY CLUSTERED 
(
	[club_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fx_generateRandomNumber]    Script Date: 08/24/2011 10:05:08 ******/
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
/****** Object:  Trigger [trtransactions]    Script Date: 08/24/2011 10:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trtransactions]
   ON  [dbo].[transactions]
   AFTER UPDATE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;
/*
DECLARE @uid varchar(100), @product_id int
SELECT @uid = uid FROM inserted;
SELECT @product_id = product_id FROM inserted;

IF (@uid != '0' AND @uid != '1')
BEGIN

DECLARE @club_id int, @player_value int, @news varchar(1000)

SET @player_value = (SELECT player_value FROM player WHERE player_id=@product_id);
SET @club_id = (SELECT club_id FROM club WHERE [uid]=@uid);

UPDATE dbo.club
SET 
revenue_others = @player_value,
revenue_total = revenue_total + @player_value,
balance = balance + @player_value
WHERE dbo.club.[uid]=@uid

INSERT INTO dbo.news VALUES (getdate(), 1, 1, '$'+cast(@player_value as varchar)+' has been refunded due to the player been purchased by other club first.', 'Refund Complete.', '', 0, @club_id, 0, 0, 0)

END
*/
END
GO
/****** Object:  View [dbo].[View_ClubROWID]    Script Date: 08/24/2011 10:05:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ClubROWID]
AS
SELECT ROW_NUMBER() OVER (ORDER BY club_id ASC) AS ROWID, club_id FROM club
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
/****** Object:  View [dbo].[View_Club]    Script Date: 08/24/2011 10:05:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Club]
AS
SELECT     club_id, game_id, uid, club_name, last_login, date_found, longitude, latitude, playing_cup, division, series, league_ranking, undefeated_counter, fan_members, 
                      fan_mood, fan_expectation,
                          (SELECT     definition
                            FROM          dbo.admin_fan
                            WHERE      (expectation_id = dbo.club.fan_expectation)) AS fan_expectation_def, stadium_status, stadium_capacity, average_ticket, stadium_finish_upgrade, 
                      stadium, managers, scouts, spokespersons, coaches, psychologists, accountants, physiotherapists, doctors, coach_id,
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
                            WHERE      (coach_id = dbo.club.coach_id)) AS coach_value, training,
                          (SELECT     definition
                            FROM          dbo.admin_training
                            WHERE      (training_id = dbo.club.training)) AS training_def, teamspirit, confidence, tactic, formation, gk, rb, lb, rw, lw, cd1, cd2, cd3, im1, im2, im3, fw1, fw2, fw3, sgk, 
                      sd, sim, sfw, sw, captain, penalty, freekick, cornerkick, revenue_stadium, revenue_sponsors, revenue_sales, revenue_investments, revenue_others, revenue_total, 
                      expenses_stadium, expenses_salary, expenses_purchases, expenses_interest, expenses_others, expenses_total, balance, fb_name, fb_pic, fb_uid, fb_sex, 
                      fb_email, face_pic, logo_pic, home_pic, away_pic, energy, xp, xp / 100 + 1 AS levelup, e, building1, building1_dt, building2, building2_dt, building3, building3_dt
FROM         dbo.club
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[32] 2[6] 3) )"
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
               Top = 15
               Left = 26
               Bottom = 157
               Right = 299
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Width = 1500
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
         Column = 1785
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
/****** Object:  StoredProcedure [dbo].[usp_Promote]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PromoteDemote]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  Trigger [trclub]    Script Date: 08/24/2011 10:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trclub]
   ON  [dbo].[club]
   AFTER UPDATE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;

DECLARE @uid varchar(100)
SELECT @uid = uid FROM inserted;

IF (@uid != '0' AND @uid != '1')
BEGIN

DECLARE @club_id int, @club_name varchar(100), @division int, @series int, @news varchar(1000)
--@devtoken varchar(100), @gameid varchar(10),
SELECT @club_id = club_id FROM inserted;
SELECT @club_name = club_name FROM inserted;
SELECT @division = division FROM inserted;
SELECT @series = series FROM inserted;
--SELECT @devtoken = devicetoken FROM inserted;
--SELECT @gameid = game_id FROM inserted;

IF UPDATE(fan_members)
BEGIN
DECLARE @fan_members_before int, @fan_members_after int, @fan_members_diff int
SELECT @fan_members_before = fan_members FROM deleted;
SELECT @fan_members_after = fan_members FROM inserted;
IF (@fan_members_after > @fan_members_before)
BEGIN
SET @fan_members_diff = @fan_members_after - @fan_members_before;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, CAST(@fan_members_diff AS varchar(5))+' new supporters signed up', 'Your total fan members has increased to '+CAST(@fan_members_after AS varchar(5))+' from '+CAST(@fan_members_before AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
--ACHIEVEMENT 33
IF @fan_members_after>249000 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=33)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 33)
UPDATE club SET revenue_others=17500, revenue_total=revenue_total+17500, balance=balance+17500 WHERE club_id=@club_id
END
END
IF (@fan_members_before > @fan_members_after)
BEGIN
SET @fan_members_diff = @fan_members_before - @fan_members_after;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, CAST(@fan_members_diff AS varchar(5))+' supporters resigned', 'Your total fan members has decreased to '+CAST(@fan_members_after AS varchar(5))+' from '+CAST(@fan_members_before AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(fan_mood)
BEGIN
DECLARE @fan_mood_before int, @fan_mood_after int
SELECT @fan_mood_before = fan_mood FROM deleted;
SELECT @fan_mood_after = fan_mood FROM inserted;
IF (@fan_mood_after > @fan_mood_before)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Fan mood towards your club is improving', 'Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
IF (@fan_mood_before > @fan_mood_after)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Fan mood towards your club is declining', 'Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(revenue_sponsors)
BEGIN
DECLARE @sponsor_before int, @sponsor_after int, @sponsor_diff int
SELECT @sponsor_before = revenue_sponsors FROM deleted;
SELECT @sponsor_after = revenue_sponsors FROM inserted;
IF (@sponsor_after > @sponsor_before)
BEGIN
SET @sponsor_diff = @sponsor_after - @sponsor_before;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, '$'+CAST(@sponsor_diff AS varchar(5))+' increase in funding from sponsors', 'Sponsors funding has increased by $'+CAST(@sponsor_diff AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
IF (@sponsor_before > @sponsor_after)
BEGIN
SET @sponsor_diff = @sponsor_before - @sponsor_after;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, '$'+CAST(@sponsor_diff AS varchar(5))+' decrease in funding from sponsors', 'Sponsors funding has decreased by $'+CAST(@sponsor_diff AS varchar(5))+'. Employ more spokesperson to improve fan and sponsor relationship with your club.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(teamspirit)
BEGIN
DECLARE @teamspirit_before int, @teamspirit_after int
SELECT @teamspirit_before = teamspirit FROM deleted;
SELECT @teamspirit_after = teamspirit FROM inserted;
IF (@teamspirit_after > @teamspirit_before)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team spirit is improving', 'Employ more psychologists to improve team spirit.', '', 0, @club_id, 0, 0, 0)
END
IF (@teamspirit_before > @teamspirit_after)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team spirit is declining', 'Employ more psychologists to improve team spirit.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(confidence)
BEGIN
DECLARE @confidence_before int, @confidence_after int
SELECT @confidence_before = confidence FROM deleted;
SELECT @confidence_after = confidence FROM inserted;
IF (@confidence_after > @confidence_before)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team confidence is improving', 'Employ more psychologists to improve team confidence.', '', 0, @club_id, 0, 0, 0)
END
IF (@confidence_before > @confidence_after)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Team confidence is declining', 'Employ more psychologists to improve team confidence.', '', 0, @club_id, 0, 0, 0)
END
END

IF UPDATE(stadium)
BEGIN
DECLARE @counter int, @news_headline varchar(1000)
SET @news_headline = @club_name+' has upgraded their arena';
SET @counter = ISNULL((SELECT count(*) FROM news WHERE headline=@news_headline), 0);
IF (@counter=0)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @club_name+' has upgraded their arena', 'You can upgrade your arena to increase the seating capacity and average ticket price.', '', 0, 0, @division, @series, 0)
END
END

IF UPDATE(club_name)
BEGIN
DECLARE @club_name_before varchar(100), @uid_before varchar(100)
SELECT @uid_before = uid FROM deleted;
IF (@uid_before = '0')
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @club_name+', welcome to the game', 'Welcome stranger. We wish you good luck in rising to the top.', '', 0, @club_id, 0, 0, 0)
END
ELSE
BEGIN
SELECT @club_name_before = club_name FROM deleted;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @club_name_before+' has changed their club name to '+@club_name, 'You can rename your club at anytime you wish.', '', 0, 0, @division, @series, 0)
--ACHIEVEMENT 1
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=1)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 1)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END

END
END

IF UPDATE(coach_id)
BEGIN
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @club_name+' has signed up a new coach', 'Hire a more experience coach to improve the training of your players.', '', 0, 0, @division, @series, 0)
END

IF UPDATE(league_ranking)
BEGIN
DECLARE @league_ranking_before int, @league_ranking_after int
SELECT @league_ranking_before = league_ranking FROM deleted;
SELECT @league_ranking_after = league_ranking FROM inserted;
IF (@league_ranking_after > @league_ranking_before)
BEGIN
SET @news = 'Team move down the league to position #'+CAST(@league_ranking_after AS varchar(5))+' in the series';
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @news, 'Fan and supporters are disappointed.', '', 0, @club_id, 0, 0, 0)
END
IF (@league_ranking_before > @league_ranking_after)
BEGIN
SET @news = 'Team climbed the league to position #'+CAST(@league_ranking_after AS varchar(5))+' in the series';
INSERT INTO dbo.news VALUES (getdate(), 0, 1, @news, 'Fan and supporters a thrilled by this news.', '', 0, @club_id, 0, 0, 0)
--ACHIEVEMENT 31
IF @league_ranking_before>1 AND @league_ranking_after=1 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=31)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 31)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END
END
END

IF UPDATE(division)
BEGIN
DECLARE @division_before int, @division_after int
SELECT @division_before = division FROM deleted;
SELECT @division_after = division FROM inserted;
IF (@division_after > @division_before)
BEGIN
SET @news = 'Bad news, your club has been demoted to a lower division!'
--EXEC usp_pushfast @gameid, @devtoken, @news
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @news, 'Fan and supporters are really disappointed by this news. However everyone in your club is determined to fight back to the top.', '', 0, @club_id, 0, 0, 0)
END
IF (@division_before > @division_after)
BEGIN
SET @news = 'Congratulations, your club has been promoted to a higher division and rewarded $100,000!'
--EXEC usp_pushfast @gameid, @devtoken, @news
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @news, 'Congratulations on this big achievement. Fan and supporters are thrilled by this news.', '', 0, @club_id, 0, 0, 0)
UPDATE club SET revenue_others=100000, revenue_total=revenue_total+100000, balance=balance+100000 WHERE club_id=@club_id
--ACHIEVEMENT 30
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=30)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 30)
UPDATE club SET revenue_others=12500, revenue_total=revenue_total+12500, balance=balance+12500 WHERE club_id=@club_id
END
--ACHIEVEMENT 35
IF @division_after=1 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=35)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 35)
UPDATE club SET revenue_others=20000, revenue_total=revenue_total+20000, balance=balance+20000 WHERE club_id=@club_id
END

END
END

IF UPDATE(away_pic)
BEGIN
--ACHIEVEMENT 2
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=2)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 2)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(spokespersons)
BEGIN
--ACHIEVEMENT 3
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=3)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 3)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(training)
BEGIN
--ACHIEVEMENT 4
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=4)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 4)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(coaches)
BEGIN
--ACHIEVEMENT 5
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=5)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 5)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(formation)
BEGIN
--ACHIEVEMENT 6
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=6)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 6)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(stadium)
BEGIN
--ACHIEVEMENT 7
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=7)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 7)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(fb_uid)
BEGIN
--ACHIEVEMENT 8
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=8)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 8)
UPDATE club SET revenue_others=35000, revenue_total=revenue_total+35000, balance=balance+35000 WHERE club_id=@club_id
END
END

IF UPDATE(playing_cup)
BEGIN
--ACHIEVEMENT 9
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=9)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 9)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(accountants)
BEGIN
--ACHIEVEMENT 10
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=10)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 10)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(captain)
BEGIN
--ACHIEVEMENT 11
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=11)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 11)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(physiotherapists)
BEGIN
--ACHIEVEMENT 14
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=14)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 14)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(xp)
BEGIN
--ACHIEVEMENT 16
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=16)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 16)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
--ACHIEVEMENT 18
DECLARE @xp_after int
SELECT @xp_after = xp FROM inserted;
IF @xp_after>99 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=18)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 18)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
--ACHIEVEMENT 32
IF @xp_after>199800 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=32)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 32)
UPDATE club SET revenue_others=15000, revenue_total=revenue_total+15000, balance=balance+15000 WHERE club_id=@club_id
END

END

IF UPDATE(doctors)
BEGIN
--ACHIEVEMENT 17
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=17)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 17)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(tactic)
BEGIN
--ACHIEVEMENT 19
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=19)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 19)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(scouts)
BEGIN
--ACHIEVEMENT 20
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=20)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 20)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(coach_id)
BEGIN
--ACHIEVEMENT 22
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=22)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 22)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END
END

IF UPDATE(managers)
BEGIN
--ACHIEVEMENT 23
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=23)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 23)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(sim)
BEGIN
--ACHIEVEMENT 25
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=25)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 25)
UPDATE club SET revenue_others=2500, revenue_total=revenue_total+2500, balance=balance+2500 WHERE club_id=@club_id
END
END

IF UPDATE(psychologists)
BEGIN
--ACHIEVEMENT 26
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=26)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 26)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@club_id
END
END

IF UPDATE(undefeated_counter)
BEGIN
--ACHIEVEMENT 27
DECLARE @u_after int
SELECT @u_after = undefeated_counter FROM inserted;
IF @u_after>2 AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=27)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 27)
UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
END
END

IF UPDATE(balance)
BEGIN
DECLARE @balance_after int
SELECT @balance_after = balance FROM inserted;
--ACHIEVEMENT 34
IF (@balance_after > 9999999) AND NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=34)
BEGIN
INSERT INTO dbo.achievement VALUES(@club_id, 34)
UPDATE club SET revenue_others=17500, revenue_total=revenue_total+17500, balance=balance+17500 WHERE club_id=@club_id
END
END

END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ClubResetDivisionSeries]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part2]    Script Date: 08/24/2011 10:05:09 ******/
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
DECLARE @club_id int, @headline varchar(1000), @news varchar(1000)

DECLARE c CURSOR FOR SELECT club_id FROM club WHERE league_ranking=1
OPEN c
Fetch next From c into @club_id
WHILE @@Fetch_Status=0
BEGIN
	INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), @club_id, 4, 'League 1st', GETDATE());
	UPDATE club SET balance=balance+100000, revenue_others=100000 WHERE club_id=@club_id
	SET @headline='Congratulations! Your club has finished 1st in the League and received a Trophy along with $100,000.';
	SET @news='The Board of Directors and Fans are thriled to with your achievement';
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0)
	Fetch next From c into @club_id
END
CLOSE c
DEALLOCATE c
SET @club_id=0

DECLARE b CURSOR FOR SELECT club_id FROM club WHERE league_ranking=2
OPEN b
Fetch next From b into @club_id
WHILE @@Fetch_Status=0
BEGIN
	INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), @club_id, 5, 'League 2nd', GETDATE());
	UPDATE club SET balance=balance+50000, revenue_others=50000 WHERE club_id=@club_id
	SET @headline='Congratulations! Your club has finished 2nd in the League and received a Trophy along with $50,000.';
	SET @news='The Board of Directors and Fans are thriled to with your achievement';
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0)
	Fetch next From b into @club_id
END
CLOSE b
DEALLOCATE b
SET @club_id=0

DECLARE a CURSOR FOR SELECT club_id FROM club WHERE league_ranking=3
OPEN a
Fetch next From a into @club_id
WHILE @@Fetch_Status=0
BEGIN
	INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), @club_id, 6, 'League 3rd', GETDATE());
	UPDATE club SET balance=balance+25000, revenue_others=25000 WHERE club_id=@club_id
	SET @headline='Congratulations! Your club has finished 3rd in the League and received a Trophy along with $25,000.';
	SET @news='The Board of Directors and Fans are thriled to with your achievement';
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0)
	Fetch next From a into @club_id
END
CLOSE a
DEALLOCATE a
SET @club_id=0

END
GO
/****** Object:  StoredProcedure [dbo].[usp_CoachNew]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  View [dbo].[Rowid_Series]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  Table [dbo].[player]    Script Date: 08/24/2011 10:05:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[player](
	[player_id] [int] NOT NULL,
	[club_id] [int] NULL,
	[position] [varchar](50) NULL,
	[player_name] [varchar](max) NULL,
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[match]    Script Date: 08/24/2011 10:05:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[match](
	[match_id] [int] NOT NULL,
	[match_played] [bit] NOT NULL,
	[match_type_id] [int] NULL,
	[match_datetime] [datetime] NULL,
	[season_week] [int] NULL,
	[club_home] [int] NULL,
	[club_away] [int] NULL,
	[season_id] [int] NULL,
	[division] [int] NULL,
	[series] [int] NULL,
	[weather_id] [int] NULL,
	[spectators] [int] NULL,
	[stadium_overflow] [int] NULL,
	[ticket_sales] [int] NULL,
	[club_winner] [int] NULL,
	[club_loser] [int] NULL,
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_ClubResetDivisionSeriesBulk]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Bid]    Script Date: 08/24/2011 10:05:09 ******/
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

	DELETE bid WHERE player_id=@player_id

	DECLARE @player_name varchar(100)
	SET @player_name = (SELECT player_name FROM player WHERE player_id=@player_id);

	UPDATE player SET club_id=@club_id WHERE player_id=@player_id
	
	UPDATE club SET balance=balance-@bid_value, 
	expenses_purchases=expenses_purchases+@bid_value,
	expenses_total=expenses_total+@bid_value
	WHERE club_id=@club_id
	
	SET @headline='Congratulations! You have won the bid for player '+@player_name+', worth $'+CAST(@bid_value AS varchar(10));
	SET @news='The Board of Directors and Fans are happy with your purchase!';
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_id, 0, 0, 0)
	
	SET @headline='Spokesperson: We won the bid on player '+@player_name+' for $'+CAST(@bid_value AS varchar(10));
	INSERT INTO dbo.chat VALUES (@club_id, @club_name, @headline)
	
	INSERT INTO dbo.transactions VALUES (getdate(), @club_uid, @player_id, @club_name, @bid_value)
	
	--ACHIEVEMENT 24
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_id AND achievement_type_id=24)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@club_id, 24)
	UPDATE club SET revenue_others=7500, revenue_total=revenue_total+7500, balance=balance+7500 WHERE club_id=@club_id
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
/****** Object:  Trigger [trplayer]    Script Date: 08/24/2011 10:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trplayer]
   ON  [dbo].[player]
   AFTER UPDATE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;

IF UPDATE(club_id)
BEGIN
DECLARE @player_id int, @player_name varchar(100), @player_value int, 
@club_id int, @club_id_before int, @club_name varchar(100),
@club_division int, @club_series int

SELECT @player_id = player_id FROM inserted;
SELECT @player_name = player_name FROM inserted;
SELECT @player_value = player_value FROM inserted;
SELECT @club_id = club_id FROM inserted;
SELECT @club_id_before = club_id FROM deleted;

IF((@club_id_before=0) OR (@club_id_before=-1)) --A club bought a new player
BEGIN
SET @club_name = (SELECT club_name FROM club WHERE club_id=@club_id);
SET @club_division = (SELECT division FROM club WHERE club_id=@club_id);
SET @club_series = (SELECT series FROM club WHERE club_id=@club_id);
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @club_name+ ' bought new player '+@player_name+' for $'+CAST(@player_value AS varchar(10)), 'Find new players on the transfer list.', '', 0, 0, @club_division, @club_series, 0)
END
ELSE --A club sold a player
BEGIN
SET @club_name = (SELECT club_name FROM club WHERE club_id=@club_id_before);
SET @club_division = (SELECT division FROM club WHERE club_id=@club_id_before);
SET @club_series = (SELECT series FROM club WHERE club_id=@club_id_before);
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @club_name+ ' transfer listed player '+@player_name+' for $'+CAST(@player_value AS varchar(10)), 'Find new players on the transfer list.', '', 0, 0, @club_division, @club_series, 0)
END

END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerSales]    Script Date: 08/24/2011 10:05:09 ******/
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
SET @player_salary=(((@keeper*@keeper)+(@defend*@defend)+(@playmaking*@playmaking)+(@attack*@attack)+(@passing*@passing))/10);
-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter, -1, @position, @player_name, @player_age, @counter, @player_salary, @player_value, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

SET @counter=@counter+1;
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayerResetClubID]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayerResetClub]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayerNewOnly]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayerNew]    Script Date: 08/24/2011 10:05:09 ******/
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
WHILE @counter < 12
BEGIN
SET @first_name = (SELECT TOP 1 name FROM admin_name_first ORDER BY NEWID());
SET @last_name = (SELECT TOP 1 name FROM admin_name_last ORDER BY NEWID());
SET @player_name = @first_name + ' ' + @last_name;
SET @player_age = dbo.fx_generateRandomNumber(newID(), 21, 35);
SET @keeper = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @defend = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @attack = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @passing = dbo.fx_generateRandomNumber(newID(), 0, 30);
SET @fitness = dbo.fx_generateRandomNumber(newID(), 50, 100);

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

SET @counter=@counter+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PromoteBulk]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayerSalesStar]    Script Date: 08/24/2011 10:05:09 ******/
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
SET @player_salary=(((@keeper*@keeper)+(@defend*@defend)+(@playmaking*@playmaking)+(@attack*@attack)+(@passing*@passing))/10);
-- Create New Player
INSERT INTO dbo.player VALUES (@player_id+@counter, -1, @position, @player_name, @player_age, @counter, @player_salary, @player_value, 0, 0, 0, 0, 0, GETDATE(), 199, @keeper, @defend, @playmaking, @attack, @passing, @fitness)

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PromoteDemoteBulk]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Reset]    Script Date: 08/24/2011 10:05:09 ******/
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

UPDATE club 
SET revenue_stadium=0, revenue_sponsors=0, revenue_sales=0, revenue_others=0, expenses_stadium=0, expenses_purchases=0,
expenses_others=0, revenue_investments=0, expenses_salary=0, expenses_interest=0, revenue_total=0, expenses_total=0, balance=99000,
playing_cup=0, undefeated_counter=0, fan_members=100, fan_mood=10, fan_expectation=0, stadium_capacity=50, stadium=1,
average_ticket=1, managers=0, scouts=0, spokespersons=0, coaches=0, psychologists=0, accountants=0, physiotherapists=0,
doctors=0, coach_id=1, teamspirit=100, confidence=100, energy=10, xp=0, e=0, building1=0, building2=0, building3=0 
WHERE club_id = @club_id

DELETE trophy WHERE club_id = @club_id

DELETE achievement WHERE club_id = @club_id

DELETE bid WHERE club_id = @club_id

DECLARE @keeper int, @defend int, @playmaking int, @attack int, @passing int

SET @keeper = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @defend = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @playmaking = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @attack = dbo.fx_generateRandomNumber(newID(), 0, 50);
SET @passing = dbo.fx_generateRandomNumber(newID(), 0, 50);

UPDATE player SET player_goals=1, player_salary=150, player_value=10000, keeper=@keeper, defend=@defend, playmaking=@playmaking, attack=@attack, passing=@passing
WHERE club_id=@club_id AND player_goals>1

END
GO
/****** Object:  View [dbo].[View_PlayerClub]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part3]    Script Date: 08/24/2011 10:05:09 ******/
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

EXECUTE usp_PromoteDemote 1, 1
EXECUTE usp_PromoteDemoteBulk 2, 1, 5
EXECUTE usp_PromoteDemoteBulk 3, 1, 25
EXECUTE usp_PromoteDemoteBulk 4, 1, 125
EXECUTE usp_PromoteDemoteBulk 5, 1, 625
EXECUTE usp_PromoteDemoteBulk 6, 1, 625
EXECUTE usp_PromoteDemoteBulk 7, 1, 625
EXECUTE usp_PromoteDemoteBulk 8, 1, 625
EXECUTE usp_PromoteDemoteBulk 9, 1, 625
EXECUTE usp_PromoteDemoteBulk 10, 1, 625
EXECUTE usp_PromoteDemoteBulk 11, 1, 625
EXECUTE usp_PromoteDemoteBulk 12, 1, 625
EXECUTE usp_PromoteDemoteBulk 13, 1, 625
EXECUTE usp_PromoteBulk 14, 1, 625

END
GO
/****** Object:  View [dbo].[View_MatchHighlightPlayer]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  View [dbo].[View_Match]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  View [dbo].[View_SeriesBase]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ResetJump]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ResetClub]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayerSalesBulk]    Script Date: 08/24/2011 10:05:10 ******/
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
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchNull]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchID]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchTommorow]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_MatchLeagueGenerator]    Script Date: 08/24/2011 10:05:10 ******/
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
@match_date varchar(100), @season_id int, @season_week int, @club_home int, @club_away int

SET @offset = 0;
SET @season_id = ISNULL((SELECT MAX(season_id) FROM season), 0);

SET @counter1 = 1;
WHILE @counter1 < 11
BEGIN
	SET @club_home = (SELECT club_id FROM (SELECT Row_Number() OVER (ORDER BY club_id) AS rowid, club_id FROM club WHERE division=@division AND series=@series) AS a WHERE rowid=@counter1)

	SET @counter2 = 1;
	WHILE @counter2 < 10
	BEGIN
	SET @match_id = ISNULL((SELECT MAX(match_id) FROM match), 0) + 1;

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
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 3;
	IF(@season_week = 3)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 7;
	IF(@season_week = 4)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 10;
	IF(@season_week = 5)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 14;
	IF(@season_week = 6)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 17;
	IF(@season_week = 7)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 21;
	IF(@season_week = 8)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 24;
	IF(@season_week = 9)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 28;
	IF(@season_week = 10)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 31;
	IF(@season_week = 11)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 35;
	IF(@season_week = 12)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 38;
	IF(@season_week = 13)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 42;
	IF(@season_week = 14)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 45;
	IF(@season_week = 15)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 49;
	IF(@season_week = 16)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 52;
	IF(@season_week = 17)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 56;
	IF(@season_week = 18)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 59;
	
	IF((@counter2+@offset) > @counter1)
		INSERT INTO dbo.match (match_id, match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
		VALUES (@match_id, 0, 1, @match_date, @season_id, @season_week, @division, @series, @club_home, @club_away)
	SET @counter2=@counter2+1;
	END
	
	SET @offset = 0;
	
	SET @counter2 = 1;
	WHILE @counter2 < 10
	BEGIN

	SET @match_id = ISNULL((SELECT MAX(match_id) FROM match), 0) + 1;

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
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 3;
	IF(@season_week = 3)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 7;
	IF(@season_week = 4)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 10;
	IF(@season_week = 5)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 14;
	IF(@season_week = 6)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 17;
	IF(@season_week = 7)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 21;
	IF(@season_week = 8)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 24;
	IF(@season_week = 9)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 28;
	IF(@season_week = 10)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 31;
	IF(@season_week = 11)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 35;
	IF(@season_week = 12)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 38;
	IF(@season_week = 13)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 42;
	IF(@season_week = 14)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 45;
	IF(@season_week = 15)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 49;
	IF(@season_week = 16)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 52;
	IF(@season_week = 17)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 56;
	IF(@season_week = 18)
		SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), @startdate))) + 59;
	
	IF((@counter2+@offset) > @counter1)
		INSERT INTO dbo.match (match_id, match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
		VALUES (@match_id, 0, 1, @match_date, @season_id, @season_week, @division, @series, @club_away, @club_home)
	SET @counter2=@counter2+1;
	END
	
SET @offset = 0;
SET @counter1=@counter1+1;
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchFriendly]    Script Date: 08/24/2011 10:05:10 ******/
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
(@home_uid varchar(100), @away int, @win int, @lose int, @draw int, @note varchar(8000))
AS
BEGIN
DECLARE @match_id int, @repeat int, @home int
SET @home = ISNULL((SELECT club_id FROM club WHERE [uid]=@home_uid), 1);
SET @repeat = (SELECT count(*) FROM match WHERE match_type_id=3 AND match_played=0 AND ((club_home=@home AND club_away=@away) OR (club_home=@away AND club_away=@home)));
IF(@repeat>0)
BEGIN
SET @match_id = (SELECT MAX(match_id) FROM match WHERE match_type_id=3 AND match_played=0 AND ((club_home=@home AND club_away=@away) OR (club_home=@away AND club_away=@home)));
UPDATE dbo.match SET challenge_datetime=GETDATE(), club_home=@home, club_away=@away, challenge_win=@win, challenge_lose=@lose, challenge_draw=@draw, challenge_note=@note WHERE match_id=@match_id; 
END
ELSE
BEGIN
	SET @match_id = ISNULL((SELECT MAX(match_id) FROM match), 0) + 1;
	INSERT INTO dbo.match (match_id, match_played, match_type_id, challenge_datetime, club_home, club_away, challenge_win, challenge_lose, challenge_draw, challenge_note) 
	VALUES (@match_id, 0, 3, GETDATE(), @home, @away, @win, @lose, @draw, @note)
	
	--ACHIEVEMENT 12
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@home AND achievement_type_id=12)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@home, 12)
	UPDATE club SET revenue_others=10000, revenue_total=revenue_total+10000, balance=balance+10000 WHERE club_id=@home
	END
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchCupReset]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_MatchCupGenerator]    Script Date: 08/24/2011 10:05:10 ******/
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
SET @match_date = CONVERT(datetime, FLOOR(CONVERT(float(24), GETDATE()+3)));
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
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @highlight, 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
UPDATE season SET cup_winner=@winner_club_name, cup_round=0, cup_totalround=@last_season_week, cup_start=CONVERT(datetime, FLOOR(CONVERT(float(24), GETDATE()+7))), cup_end=CONVERT(datetime, FLOOR(CONVERT(float(24), GETDATE()+70)))

INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), @winner_club_id, 1, 'Gold Cup', GETDATE());
INSERT INTO dbo.trophy VALUES (ISNULL((SELECT MAX(trophy_id) FROM trophy)+1, 1), @runerup_club_id, 2, 'Silver Cup', GETDATE());

UPDATE club SET balance=balance+250000, revenue_others=250000 WHERE club_id=@winner_club_id
UPDATE club SET balance=balance+100000, revenue_others=100000 WHERE club_id=@runerup_club_id

--ACHIEVEMENT 28
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@winner_club_id AND achievement_type_id=28)
BEGIN
INSERT INTO dbo.achievement VALUES(@winner_club_id, 28)
UPDATE club SET revenue_others=10000, revenue_total=revenue_total+10000, balance=balance+10000 WHERE club_id=@winner_club_id
END

--ACHIEVEMENT 29
IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@runerup_club_id AND achievement_type_id=29)
BEGIN
INSERT INTO dbo.achievement VALUES(@runerup_club_id, 29)
UPDATE club SET revenue_others=5000, revenue_total=revenue_total+5000, balance=balance+5000 WHERE club_id=@runerup_club_id
END

--EXEC usp_pushall @highlight

END
ELSE
BEGIN

IF @season_week = 1 -- First round for the cup
BEGIN
	SET @highlight = 'New CUP season has kicked off and entered round 1!'
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @highlight, 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
	Declare c Cursor For SELECT club_id FROM club WHERE playing_cup=1
END
ELSE
BEGIN
	SET @highlight = 'CUP has entered round '+CAST(@season_week AS varchar(10))
	INSERT INTO dbo.news VALUES (getdate(), 1, 1, @highlight, 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
	Declare c Cursor For SELECT club_winner FROM match WHERE match_played=1 AND match_type_id=2 AND season_week=@last_season_week
END

Open c
Fetch next From c into @club_home
While @@Fetch_Status=0
Begin
	Fetch next From c into @club_away
	SET @match_id = ISNULL((SELECT MAX(match_id) FROM match), 0) + 1;
	INSERT INTO dbo.match (match_id, match_played, match_type_id, match_datetime, season_id, season_week, division, series, club_home, club_away) 
	VALUES (@match_id, 0, 2, @match_date, @season_id, @season_week, 0, 0, @club_home, @club_away)
	Fetch next From c into @club_home
End
Close c
Deallocate c

END


END
GO
/****** Object:  StoredProcedure [dbo].[usp_MatchCheck]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayerNewClub]    Script Date: 08/24/2011 10:05:09 ******/
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
/****** Object:  Trigger [trmatch_played]    Script Date: 08/24/2011 10:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trmatch_played]
   ON  [dbo].[match]
   AFTER UPDATE
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;
IF UPDATE(match_played)
BEGIN
DECLARE @match_id int, @match_played int, @match_type_id int, @club_home int, @club_away int, @division int, @series int, @challenge_win int, @challenge_lose int
SELECT @match_id = match_id FROM inserted;
SELECT @match_played = match_played FROM inserted;
SET @match_type_id = ISNULL((SELECT match_type_id FROM inserted), 0);
SET @club_home = ISNULL((SELECT club_home FROM inserted), 0);
SET @club_away = ISNULL((SELECT club_away FROM inserted), 0);
SET @division = ISNULL((SELECT division FROM inserted), 0);
SET @series = ISNULL((SELECT series FROM inserted), 0);
SET @challenge_win = ISNULL((SELECT challenge_win FROM inserted), 0);
SET @challenge_lose = ISNULL((SELECT challenge_lose FROM inserted), 0);

IF (@match_played = 1)
BEGIN
DECLARE @away_uid varchar(100), @home_uid varchar(100)
--Check if blank club
SET @home_uid = (SELECT [uid] FROM club WHERE club_id=@club_home);
SET @away_uid = (SELECT [uid] FROM club WHERE club_id=@club_away);

IF (@home_uid = '0' AND @away_uid = '0')
BEGIN
DECLARE @hscore int, @ascore int, @cwinner int, @closer int

SET @hscore = dbo.fx_generateRandomNumber(newID(), 0, 3);
SET @ascore = dbo.fx_generateRandomNumber(newID(), 0, 3);

IF (@hscore > @ascore)
BEGIN
	SET @cwinner = @club_home;
	SET @closer = @club_away;
END

IF (@ascore > @hscore)
BEGIN
	SET @cwinner = @club_away;
	SET @closer = @club_home;
END

IF (@ascore = @hscore)
BEGIN
	SET @cwinner = 0;
	SET @closer = 0;
END

UPDATE dbo.match
SET 
home_score = @hscore,
away_score = @ascore,
home_score_different = @hscore-@ascore,
away_score_different = @ascore-@hscore,
club_winner = @cwinner,
club_loser = @closer
WHERE match_id=@match_id

END
ELSE
BEGIN
-- Calculate the ticket_sales for this match
DECLARE  @spectators int, @stadium_overflow int, @stadium_capacity int, @average_ticket int, @ticket_sales int

SET @spectators =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)), 0);
SET @stadium_overflow =  ISNULL(((SELECT fan_members FROM club WHERE club_id=@club_home)+(SELECT fan_members FROM club WHERE club_id=@club_away)-(SELECT stadium_capacity FROM club WHERE club_id=@club_home)), 0);
SET @stadium_capacity = ISNULL((SELECT stadium_capacity FROM club WHERE club_id=@club_home), 500);
SET @average_ticket = ISNULL((SELECT average_ticket FROM club WHERE club_id=@club_home), 1);

IF(@stadium_overflow > 0)
	SET @ticket_sales = @average_ticket * @stadium_capacity;
ELSE
	SET @ticket_sales = @average_ticket * @spectators;
	
-- Friendly is 1/10 the sales of league or cup
IF(@match_type_id = 3)
BEGIN
	SET @ticket_sales = @ticket_sales / 10;
	
	--ACHIEVEMENT 15
	IF NOT EXISTS(SELECT achievement_id FROM achievement WHERE club_id=@club_away AND achievement_type_id=15)
	BEGIN
	INSERT INTO dbo.achievement VALUES(@club_away, 15)
	UPDATE club SET revenue_others=10000, revenue_total=revenue_total+10000, balance=balance+10000 WHERE club_id=@club_away
	END
END

-- Divide income to two clubs
SET @ticket_sales = @ticket_sales / 3;

-- Declare players
DECLARE
@h_gk int, @h_rb int, @h_lb int, @h_rw int, @h_lw int, 
@h_cd1 int, @h_cd2 int, @h_cd3 int, @h_im1 int, @h_im2 int, @h_im3 int, @h_fw1 int, @h_fw2 int, @h_fw3 int, 
@a_gk int, @a_rb int, @a_lb int, @a_rw int, @a_lw int, 
@a_cd1 int, @a_cd2 int, @a_cd3 int, @a_im1 int, @a_im2 int, @a_im3 int, @a_fw1 int, @a_fw2 int, @a_fw3 int

SET @h_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_home), 0);
SET @h_rb = ISNULL((SELECT rb FROM club WHERE club_id=@club_home), 0);
SET @h_lb = ISNULL((SELECT lb FROM club WHERE club_id=@club_home), 0);
SET @h_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_home), 0);
SET @h_cd2 = ISNULL((SELECT cd2 FROM club WHERE club_id=@club_home), 0);
SET @h_cd3 = ISNULL((SELECT cd3 FROM club WHERE club_id=@club_home), 0);
SET @h_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_home), 0);
SET @h_im2 = ISNULL((SELECT im2 FROM club WHERE club_id=@club_home), 0);
SET @h_im3 = ISNULL((SELECT im3 FROM club WHERE club_id=@club_home), 0);
SET @h_rw = ISNULL((SELECT rw FROM club WHERE club_id=@club_home), 0);
SET @h_lw = ISNULL((SELECT lw FROM club WHERE club_id=@club_home), 0);
SET @h_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_home), 0);
SET @h_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_home), 0);
SET @h_fw3 = ISNULL((SELECT fw3 FROM club WHERE club_id=@club_home), 0);

SET @h_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@h_gk AND club_id=@club_home), 0);
SET @h_rb = ISNULL((SELECT player_id FROM player WHERE player_id=@h_rb AND club_id=@club_home), 0);
SET @h_lb = ISNULL((SELECT player_id FROM player WHERE player_id=@h_lb AND club_id=@club_home), 0);
SET @h_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd1 AND club_id=@club_home), 0);
SET @h_cd2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd2 AND club_id=@club_home), 0);
SET @h_cd3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_cd3 AND club_id=@club_home), 0);
SET @h_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im1 AND club_id=@club_home), 0);
SET @h_im2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im2 AND club_id=@club_home), 0);
SET @h_im3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_im3 AND club_id=@club_home), 0);
SET @h_rw = ISNULL((SELECT player_id FROM player WHERE player_id=@h_rw AND club_id=@club_home), 0);
SET @h_lw = ISNULL((SELECT player_id FROM player WHERE player_id=@h_lw AND club_id=@club_home), 0);
SET @h_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw1 AND club_id=@club_home), 0);
SET @h_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw2 AND club_id=@club_home), 0);
SET @h_fw3 = ISNULL((SELECT player_id FROM player WHERE player_id=@h_fw3 AND club_id=@club_home), 0);

SET @a_gk = ISNULL((SELECT gk FROM club WHERE club_id=@club_away), 0);
SET @a_rb = ISNULL((SELECT rb FROM club WHERE club_id=@club_away), 0);
SET @a_lb = ISNULL((SELECT lb FROM club WHERE club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT cd1 FROM club WHERE club_id=@club_away), 0);
SET @a_cd2 = ISNULL((SELECT cd2 FROM club WHERE club_id=@club_away), 0);
SET @a_cd3 = ISNULL((SELECT cd3 FROM club WHERE club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT im1 FROM club WHERE club_id=@club_away), 0);
SET @a_im2 = ISNULL((SELECT im2 FROM club WHERE club_id=@club_away), 0);
SET @a_im3 = ISNULL((SELECT im3 FROM club WHERE club_id=@club_away), 0);
SET @a_rw = ISNULL((SELECT rw FROM club WHERE club_id=@club_away), 0);
SET @a_lw = ISNULL((SELECT lw FROM club WHERE club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT fw1 FROM club WHERE club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT fw2 FROM club WHERE club_id=@club_away), 0);
SET @a_fw3 = ISNULL((SELECT fw3 FROM club WHERE club_id=@club_away), 0);

SET @a_gk = ISNULL((SELECT player_id FROM player WHERE player_id=@a_gk AND club_id=@club_away), 0);
SET @a_rb = ISNULL((SELECT player_id FROM player WHERE player_id=@a_rb AND club_id=@club_away), 0);
SET @a_lb = ISNULL((SELECT player_id FROM player WHERE player_id=@a_lb AND club_id=@club_away), 0);
SET @a_cd1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd1 AND club_id=@club_away), 0);
SET @a_cd2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd2 AND club_id=@club_away), 0);
SET @a_cd3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_cd3 AND club_id=@club_away), 0);
SET @a_im1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im1 AND club_id=@club_away), 0);
SET @a_im2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im2 AND club_id=@club_away), 0);
SET @a_im3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_im3 AND club_id=@club_away), 0);
SET @a_rw = ISNULL((SELECT player_id FROM player WHERE player_id=@a_rw AND club_id=@club_away), 0);
SET @a_lw = ISNULL((SELECT player_id FROM player WHERE player_id=@a_lw AND club_id=@club_away), 0);
SET @a_fw1 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw1 AND club_id=@club_away), 0);
SET @a_fw2 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw2 AND club_id=@club_away), 0);
SET @a_fw3 = ISNULL((SELECT player_id FROM player WHERE player_id=@a_fw3 AND club_id=@club_away), 0);

-- Process score result
DECLARE
@wGK_D float, @wGK_A float, @wWB_D float, @wWB_A float, @wCD_D float, 
@wCD_A float, @wW_D float, @wW_A float, @wM_D float, @wM_A float, @wF_D float, @wF_A float,
@home_tactic int, @away_tactic int, 
@home_score int, @away_score int, 
@home_score_diff int, @away_score_diff int,
@home_possession int, @away_possession int, 
@club_winner int, @club_loser int, 

@home_gk float, @home_gk_d float, @home_gk_a float,
@home_rb float, @home_rb_d float, @home_rb_a float,
@home_lb float, @home_lb_d float, @home_lb_a float,
@home_cd1 float, @home_cd1_d float, @home_cd1_a float,
@home_cd2 float, @home_cd2_d float, @home_cd2_a float,
@home_cd3 float, @home_cd3_d float, @home_cd3_a float,
@home_im1 float, @home_im1_d float, @home_im1_a float,
@home_im2 float, @home_im2_d float, @home_im2_a float,
@home_im3 float, @home_im3_d float, @home_im3_a float,
@home_rw float, @home_rw_d float, @home_rw_a float,
@home_lw float, @home_lw_d float, @home_lw_a float,
@home_fw1 float, @home_fw1_d float, @home_fw1_a float,
@home_fw2 float, @home_fw2_d float, @home_fw2_a float,
@home_fw3 float, @home_fw3_d float, @home_fw3_a float,
@home_total_d float, @home_total_a float,

@home_keeper float, @home_defend float, @home_playmaking float, 
@home_passing float, @home_attack float, @home_fitness float,

@away_gk float, @away_gk_d float, @away_gk_a float,
@away_rb float, @away_rb_d float, @away_rb_a float,
@away_lb float, @away_lb_d float, @away_lb_a float,
@away_cd1 float, @away_cd1_d float, @away_cd1_a float,
@away_cd2 float, @away_cd2_d float, @away_cd2_a float,
@away_cd3 float, @away_cd3_d float, @away_cd3_a float,
@away_im1 float, @away_im1_d float, @away_im1_a float,
@away_im2 float, @away_im2_d float, @away_im2_a float,
@away_im3 float, @away_im3_d float, @away_im3_a float,
@away_rw float, @away_rw_d float, @away_rw_a float,
@away_lw float, @away_lw_d float, @away_lw_a float,
@away_fw1 float, @away_fw1_d float, @away_fw1_a float,
@away_fw2 float, @away_fw2_d float, @away_fw2_a float,
@away_fw3 float, @away_fw3_d float, @away_fw3_a float,
@away_total_d float, @away_total_a float,

@away_keeper float, @away_defend float, @away_playmaking float, 
@away_passing float, @away_attack float, @away_fitness float

-- Home points
SET @home_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_home), 0);

IF @home_tactic = 0 -- Normal
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 1 -- Defending
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.075;
SET @wM_D = 0.075;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.025;
SET @wM_A = 0.025;
SET @wF_A = 0.1;
END

IF @home_tactic = 2 -- Attacking
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 3 -- Pressing
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.075;
SET @wCD_D = 0.075;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @home_tactic = 4 -- Counter Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.075;
SET @wCD_A = 0.075;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @home_tactic = 5 -- Middle Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.1;
SET @wM_A = 0.125;
SET @wF_A = 0.075;
END

IF @home_tactic = 6 -- Wings Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.2;
SET @wM_A = 0.05;
SET @wF_A = 0.05;
END

IF @home_tactic = 7 -- Play Creatively
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0.025;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.075;
SET @wM_A = 0.1;
SET @wF_A = 0.075;
END

IF @home_tactic = 8 -- Long Shots
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.15;
END

-- GK
SET @home_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @h_gk), 0);
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_gk), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_gk), 0);
SET @home_gk = @home_keeper *(@home_fitness/200);
SET @home_gk_d = @home_gk * @wGK_D;
SET @home_gk_a = @home_gk * @wGK_A;
-- DR
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_rb), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_rb), 0);
SET @home_rb = @home_defend*(@home_fitness/200);
SET @home_rb_d = @home_rb * @wWB_D;
SET @home_rb_a = @home_rb * @wWB_A;
-- DL
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_lb), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_lb), 0);
SET @home_lb = @home_defend*(@home_fitness/200);
SET @home_lb_d = @home_lb * @wWB_D;
SET @home_lb_a = @home_lb * @wWB_A;
-- DC 1
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd1), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd1), 0);
SET @home_cd1 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_cd1_d = @home_cd1 * @wCD_D;
SET @home_cd1_a = @home_cd1 * @wCD_A;
-- DC 2
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd2), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd2), 0);
SET @home_cd2 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_cd2_d = @home_cd2 * @wCD_D;
SET @home_cd2_a = @home_cd2 * @wCD_A;
-- DC 3
SET @home_defend = ISNULL((SELECT defend FROM player WHERE player_id = @h_cd3), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_cd3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_cd3), 0);
SET @home_cd3 = ((@home_defend*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_cd3_d = @home_cd3 * @wCD_D;
SET @home_cd3_a = @home_cd3 * @wCD_A;
-- MC 1
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im1), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_im1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im1), 0);
SET @home_im1 = ((@home_playmaking*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_im1_d = @home_im1 * @wM_D;
SET @home_im1_a = @home_im1 * @wM_A;
-- MC 2
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im2), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_im2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im2), 0);
SET @home_im2 = ((@home_playmaking*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_im2_d = @home_im2 * @wM_D;
SET @home_im2_a = @home_im2 * @wM_A;
-- MC 3
SET @home_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @h_im3), 0);
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_im3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_im3), 0);
SET @home_im3 = ((@home_playmaking*0.7)+(@home_passing*0.3))*(@home_fitness/200);
SET @home_im3_d = @home_im3 * @wM_D;
SET @home_im3_a = @home_im3 * @wM_A;
-- MR
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_rw), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_rw), 0);
SET @home_rw = @home_passing *(@home_fitness/200);
SET @home_rw_d = @home_rw * @wW_D;
SET @home_rw_a = @home_rw * @wW_A;
-- ML
SET @home_passing = ISNULL((SELECT passing FROM player WHERE player_id = @h_lw), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_lw), 0);
SET @home_lw = @home_passing *(@home_fitness/200);
SET @home_lw_d = @home_lw * @wW_D;
SET @home_lw_a = @home_lw * @wW_A;
-- SC 1
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw1), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw1), 0);
SET @home_fw1 = @home_attack *(@home_fitness/200);
SET @home_fw1_d = @home_fw1 * @wF_D;
SET @home_fw1_a = @home_fw1 * @wF_A;
-- SC 2
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw2), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw2), 0);
SET @home_fw2 = @home_attack *(@home_fitness/200);
SET @home_fw2_d = @home_fw2 * @wF_D;
SET @home_fw2_a = @home_fw2 * @wF_A;
-- SC 3
SET @home_attack = ISNULL((SELECT attack FROM player WHERE player_id = @h_fw3), 0);
SET @home_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @h_fw3), 0);
SET @home_fw3 = @home_attack *(@home_fitness/200);
SET @home_fw3_d = @home_fw3 * @wF_D;
SET @home_fw3_a = @home_fw3 * @wF_A;

SET @home_total_d = @home_gk_d + @home_rb_d + @home_lb_d + @home_cd1_d + @home_cd2_d + @home_cd3_d + @home_im1_d + @home_im2_d + @home_im3_d + @home_rw_d + @home_lw_d + @home_fw1_d + @home_fw2_d + @home_fw3_d;
SET @home_total_a = @home_gk_a + @home_rb_a + @home_lb_a + @home_cd1_a + @home_cd2_a + @home_cd3_a + @home_im1_a+ @home_im2_a + @home_im3_a + @home_rw_a + @home_lw_a + @home_fw1_a + @home_fw2_a + @home_fw3_a;

-- Away points
SET @away_tactic = ISNULL((SELECT tactic FROM club WHERE club_id=@club_away), 0);

IF @away_tactic = 0 -- Normal
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @away_tactic = 1 -- Defending
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.075;
SET @wM_D = 0.075;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.025;
SET @wM_A = 0.025;
SET @wF_A = 0.1;
END

IF @away_tactic = 2 -- Attacking
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @away_tactic = 3 -- Pressing
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.075;
SET @wCD_D = 0.075;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.1;
SET @wM_A = 0.1;
SET @wF_A = 0.1;
END

IF @away_tactic = 4 -- Counter Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0.075;
SET @wCD_A = 0.075;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.1;
END

IF @away_tactic = 5 -- Middle Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.05;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0.075;
SET @wW_A = 0.1;
SET @wM_A = 0.125;
SET @wF_A = 0.075;
END

IF @away_tactic = 6 -- Wings Attack
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0;
SET @wM_D = 0;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.2;
SET @wM_A = 0.05;
SET @wF_A = 0.05;
END

IF @away_tactic = 7 -- Play Creatively
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.05;
SET @wCD_D = 0.05;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0.025;
SET @wGK_A = 0;
SET @wWB_A = 0.05;
SET @wCD_A = 0.05;
SET @wW_A = 0.075;
SET @wM_A = 0.1;
SET @wF_A = 0.075;
END

IF @away_tactic = 8 -- Long Shots
BEGIN
SET @wGK_D = 0.1;
SET @wWB_D = 0.1;
SET @wCD_D = 0.1;
SET @wW_D = 0.025;
SET @wM_D = 0.025;
SET @wF_D = 0;
SET @wGK_A = 0;
SET @wWB_A = 0;
SET @wCD_A = 0;
SET @wW_A = 0.075;
SET @wM_A = 0.075;
SET @wF_A = 0.15;
END

-- GK
SET @away_keeper = ISNULL((SELECT keeper FROM player WHERE player_id = @a_gk), 0);
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_gk), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_gk), 0);
SET @away_gk = @away_keeper *(@away_fitness/200);
SET @away_gk_d = @away_gk * @wGK_D;
SET @away_gk_a = @away_gk * @wGK_A;
-- DR
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_rb), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_rb), 0);
SET @away_rb = @away_defend*(@away_fitness/200);
SET @away_rb_d = @away_rb * @wWB_D;
SET @away_rb_a = @away_rb * @wWB_A;
-- DL
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_lb), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_lb), 0);
SET @away_lb = @away_defend*(@away_fitness/200);
SET @away_lb_d = @away_lb * @wWB_D;
SET @away_lb_a = @away_lb * @wWB_A;
-- DC 1
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd1), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd1), 0);
SET @away_cd1 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_cd1_d = @away_cd1 * @wCD_D;
SET @away_cd1_a = @away_cd1 * @wCD_A;
-- DC 2
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd2), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd2), 0);
SET @away_cd2 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_cd2_d = @away_cd2 * @wCD_D;
SET @away_cd2_a = @away_cd2 * @wCD_A;
-- DC 3
SET @away_defend = ISNULL((SELECT defend FROM player WHERE player_id = @a_cd3), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_cd3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_cd3), 0);
SET @away_cd3 = ((@away_defend*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_cd3_d = @away_cd3 * @wCD_D;
SET @away_cd3_a = @away_cd3 * @wCD_A;
-- MC 1
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im1), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_im1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im1), 0);
SET @away_im1 = ((@away_playmaking*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_im1_d = @away_im1 * @wM_D;
SET @away_im1_a = @away_im1 * @wM_A;
-- MC 2
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im2), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_im2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im2), 0);
SET @away_im2 = ((@away_playmaking*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_im2_d = @away_im2 * @wM_D;
SET @away_im2_a = @away_im2 * @wM_A;
-- MC 3
SET @away_playmaking = ISNULL((SELECT playmaking FROM player WHERE player_id = @a_im3), 0);
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_im3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_im3), 0);
SET @away_im3 = ((@away_playmaking*0.7)+(@away_passing*0.3))*(@away_fitness/200);
SET @away_im3_d = @away_im3 * @wM_D;
SET @away_im3_a = @away_im3 * @wM_A;
-- MR
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_rw), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_rw), 0);
SET @away_rw = @away_passing *(@away_fitness/200);
SET @away_rw_d = @away_rw * @wW_D;
SET @away_rw_a = @away_rw * @wW_A;
-- ML
SET @away_passing = ISNULL((SELECT passing FROM player WHERE player_id = @a_lw), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_lw), 0);
SET @away_lw = @away_passing *(@away_fitness/200);
SET @away_lw_d = @away_lw * @wW_D;
SET @away_lw_a = @away_lw * @wW_A;
-- SC 1
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw1), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw1), 0);
SET @away_fw1 = @away_attack *(@away_fitness/200);
SET @away_fw1_d = @away_fw1 * @wF_D;
SET @away_fw1_a = @away_fw1 * @wF_A;
-- SC 2
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw2), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw2), 0);
SET @away_fw2 = @away_attack *(@away_fitness/200);
SET @away_fw2_d = @away_fw2 * @wF_D;
SET @away_fw2_a = @away_fw2 * @wF_A;
-- SC 3
SET @away_attack = ISNULL((SELECT attack FROM player WHERE player_id = @a_fw3), 0);
SET @away_fitness = ISNULL((SELECT fitness FROM player WHERE player_id = @a_fw3), 0);
SET @away_fw3 = @away_attack *(@away_fitness/200);
SET @away_fw3_d = @away_fw3 * @wF_D;
SET @away_fw3_a = @away_fw3 * @wF_A;

SET @away_total_d = @away_gk_d + @away_rb_d + @away_lb_d + @away_cd1_d + @away_cd2_d + @away_cd3_d + @away_im1_d + @away_im2_d + @away_im3_d + @away_rw_d + @away_lw_d + @away_fw1_d + @away_fw2_d + @away_fw3_d;
SET @away_total_a = @away_gk_a + @away_rb_a + @away_lb_a + @away_cd1_a + @away_cd2_a + @away_cd3_a + @away_im1_a+ @away_im2_a + @away_im3_a + @away_rw_a + @away_lw_a + @away_fw1_a + @away_fw2_a + @away_fw3_a;

-- Points summary
DECLARE @home_teamspirit int, @away_teamspirit int, @home_confidence int, @away_confidence int
SET @home_teamspirit = ISNULL((SELECT teamspirit FROM club WHERE club_id=@club_home), 100);
SET @home_confidence = ISNULL((SELECT confidence FROM club WHERE club_id=@club_home), 100);
SET @away_teamspirit = ISNULL((SELECT teamspirit FROM club WHERE club_id=@club_away), 100);
SET @away_confidence = ISNULL((SELECT confidence FROM club WHERE club_id=@club_away), 100);
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

IF (@away_total_d = 0)
BEGIN
	SET @away_total_d = 1;
END

IF (@home_total_d = 0)
BEGIN
	SET @home_total_d = 1;
END

SET @home_score = (@home_total_a / @away_total_d);
SET @away_score = (@away_total_a / @home_total_d);

IF (@home_score < 0)
BEGIN
	SET @home_score = 0;
END

IF (@away_score < 0)
BEGIN
	SET @away_score = 0;
END

IF ((@home_teamspirit+@home_confidence)>(@away_teamspirit+@away_confidence))
BEGIN
	SET @home_score = @home_score+1;
END

IF ((@away_teamspirit+@away_confidence)>(@home_teamspirit+@home_confidence))
BEGIN
	SET @away_score = @away_score+1;
END

SET @home_score = @home_score + dbo.fx_generateRandomNumber(newID(), 0, 3);
SET @away_score = @away_score + dbo.fx_generateRandomNumber(newID(), 0, 3);

IF (@home_uid = '0' OR @home_uid = '1')
BEGIN
	SET @home_score = @home_score + dbo.fx_generateRandomNumber(newID(), 1, 3);
END

IF (@away_uid = '0' OR @away_uid = '1')
BEGIN
	SET @away_score = @away_score + dbo.fx_generateRandomNumber(newID(), 1, 3);
END
	
IF (@home_score > 5)
BEGIN
	SET @home_score = dbo.fx_generateRandomNumber(newID(), 4, 7);
END

IF (@away_score > 5)
BEGIN
	SET @away_score = dbo.fx_generateRandomNumber(newID(), 4, 7);
END

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Cup advantage to Home team if it is a Draw
IF (@match_type_id = 2)
BEGIN
	IF (@home_score = @away_score)
	BEGIN
		SET @home_score = @home_score + 1;
	END
END

SET @home_score_diff = @home_score - @away_score;
SET @away_score_diff = @away_score - @home_score;
SET @home_possession = @home_total_a;
SET @away_possession = @away_total_a;

IF (@home_score > @away_score)
BEGIN
SET @club_winner = @club_home;
SET @club_loser = @club_away;
END
ELSE
BEGIN
SET @club_winner = @club_away;
SET @club_loser = @club_home;
END

IF (@home_score = @away_score)
BEGIN
SET @club_winner = 0;
SET @club_loser = 0;
END

UPDATE dbo.match
SET 
weather_id = dbo.fx_generateRandomNumber(newID(), 1, 3),
spectators=@spectators,
stadium_overflow=@stadium_overflow,
home_formation=(SELECT formation FROM club WHERE club_id=match.club_home),
away_formation=(SELECT formation FROM club WHERE club_id=match.club_away),
home_tactic=@home_tactic,
home_teamspirit=@home_teamspirit,
home_confidence=@home_confidence,
away_tactic=@away_tactic,
away_teamspirit=@away_teamspirit,
away_confidence=@away_confidence,
match_datetime=GETDATE(),
ticket_sales = @ticket_sales,
home_score = @home_score, 
away_score = @away_score, 
home_possession = @home_possession, 
away_possession = @away_possession, 
home_score_different = @home_score_diff, 
away_score_different = @away_score_diff,
club_winner = @club_winner, 
club_loser = @club_loser
WHERE match_id=@match_id

-- Challenge money update if friendly match
IF(@match_type_id = 3)
BEGIN
DECLARE @bal int
IF (@home_score > @away_score)
BEGIN
SET @bal = ISNULL((SELECT balance FROM club WHERE club_id=@club_away), 0);
IF (@bal>0)
BEGIN
-- Update finance for club home
UPDATE dbo.club
SET 
revenue_others = @challenge_lose,
revenue_total = revenue_total + @challenge_lose,
balance = balance + @challenge_lose
WHERE dbo.club.club_id=@club_home
-- Update finance for club away
UPDATE dbo.club
SET 
expenses_others = @challenge_lose,
expenses_total = expenses_total + @challenge_lose,
balance = balance - @challenge_lose
WHERE dbo.club.club_id=@club_away
END
END

IF (@away_score > @home_score)
BEGIN
SET @bal = ISNULL((SELECT balance FROM club WHERE club_id=@club_home), 0);
IF (@bal>0)
BEGIN
-- Update finance for club away
UPDATE dbo.club
SET 
revenue_others = @challenge_win,
revenue_total = revenue_total + @challenge_win,
balance = balance + @challenge_win
WHERE dbo.club.club_id=@club_away
-- Update finance for club home
UPDATE dbo.club
SET 
expenses_others = @challenge_win,
expenses_total = expenses_total + @challenge_win,
balance = balance - @challenge_win
WHERE dbo.club.club_id=@club_home
END
END
END

IF(@match_type_id != 3) -- Not a frienldy match
BEGIN
-- Club Home updates
DECLARE @fan_members int, @fan_mood int, @fan_expectation int, @undefeated_counter int,
@undefeated_counter_away int,@managers int, @physiotherapists int

SELECT @fan_members = fan_members FROM club WHERE club_id=@club_home;
SELECT @fan_mood = fan_mood FROM club WHERE club_id=@club_home;
SELECT @fan_expectation = fan_expectation FROM club WHERE club_id=@club_home;
SELECT @undefeated_counter = undefeated_counter FROM club WHERE club_id=@club_home;

IF (@home_score_diff > 0)
BEGIN
SET @fan_expectation = 0;
SET @fan_members = @fan_members + @home_score_diff*25;
SET @home_confidence = @home_confidence + 10;
SET @undefeated_counter = @undefeated_counter + 1;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Your team is now undefeated for '+cast(@undefeated_counter as varchar)+' competitive games', 'Fans are excited with your performance.', '', 0, @club_home, 0, 0, 0)
END

IF (@home_score_diff = 0)
BEGIN
SET @fan_expectation = 1;
SET @fan_members = @fan_members + 10;
END

IF (@home_score_diff < 0)
BEGIN
SET @fan_expectation = 2;
SET @fan_members = @fan_members + @home_score_diff;
SET @home_confidence = @home_confidence - 10;
SET @undefeated_counter = 0;
END

SET @fan_mood = @fan_mood + @home_score_diff;
SET @home_teamspirit = @home_teamspirit + @home_score_diff;
	
IF (@fan_mood < 10)
	SET @fan_mood = 10;
	
IF (@fan_mood > 200)
	SET @fan_mood = 200;
	
IF (@home_confidence < 20)
	SET @home_confidence = 20;
	
IF (@home_teamspirit < 20)
	SET @home_teamspirit = 20;
	
IF (@home_confidence > 200)
	SET @home_confidence = 200;
	
IF (@home_teamspirit > 200)
	SET @home_teamspirit = 200;

UPDATE dbo.club
SET 
revenue_stadium = @ticket_sales*2,
revenue_total = revenue_total + (@ticket_sales*2),
balance = balance + (@ticket_sales*2),
fan_members = @fan_members, 
fan_mood = @fan_mood, 
fan_expectation = @fan_expectation, 
undefeated_counter = @undefeated_counter,
teamspirit = @home_teamspirit, 
confidence = @home_confidence
WHERE dbo.club.club_id=@club_home

-- Club Away updates
SELECT @fan_members = fan_members FROM club WHERE club_id=@club_away;
SELECT @fan_mood = fan_mood FROM club WHERE club_id=@club_away;
SELECT @fan_expectation = fan_expectation FROM club WHERE club_id=@club_away;
SELECT @undefeated_counter_away = undefeated_counter FROM club WHERE club_id=@club_away;

IF (@away_score_diff > 0)
BEGIN
SET @fan_expectation = 0;
SET @fan_members = @fan_members + @away_score_diff*25;
SET @away_confidence = @away_confidence + 10;
SET @undefeated_counter_away = @undefeated_counter_away + 1;
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Your team is now undefeated for '+cast(@undefeated_counter_away as varchar)+' competitive games', 'Fans are excited with your performance.', '', 0, @club_away, 0, 0, 0)
END

IF (@away_score_diff = 0)
BEGIN
SET @fan_expectation = 1;
SET @fan_members = @fan_members + 10;
END

IF (@away_score_diff < 0)
BEGIN
SET @fan_expectation = 2;
SET @fan_members = @fan_members + @away_score_diff;
SET @away_confidence = @away_confidence - 10;
SET @undefeated_counter_away = 0;
END

SET @fan_mood = @fan_mood + @away_score_diff;
SET @away_teamspirit = @away_teamspirit + @away_score_diff;
	
IF (@fan_mood < 10)
	SET @fan_mood = 10;
	
IF (@fan_mood > 200)
	SET @fan_mood = 200;
	
IF (@away_confidence < 20)
	SET @away_confidence = 20;
	
IF (@away_teamspirit < 20)
	SET @away_teamspirit = 20;
	
IF (@away_confidence > 200)
	SET @away_confidence = 200;
	
IF (@away_teamspirit > 200)
	SET @away_teamspirit = 200;

UPDATE dbo.club
SET 
revenue_others = @ticket_sales,
revenue_total = revenue_total + @ticket_sales,
balance = balance + @ticket_sales,
fan_members = @fan_members, 
fan_mood = @fan_mood, 
fan_expectation = @fan_expectation, 
undefeated_counter = @undefeated_counter_away,
teamspirit = @away_teamspirit, 
confidence = @away_confidence
WHERE dbo.club.club_id=@club_away

END -- If not equals to friendly match

-- News results
DECLARE @news_marque varchar(1000), @news varchar(1000), @news_money varchar(1100), @news_result varchar(1000), 
@headline varchar(500), @home_name varchar(100), @away_name varchar(100)
--, @home_devtoken varchar(100), @away_devtoken varchar(100), @home_gameid varchar(10), @away_gameid varchar(10)

SELECT @home_name = club_name FROM club WHERE club_id=@club_home;
SELECT @away_name = club_name FROM club WHERE club_id=@club_away;
--SELECT @home_devtoken = devicetoken FROM club WHERE club_id=@club_home;
--SELECT @away_devtoken = devicetoken FROM club WHERE club_id=@club_away;
--SELECT @home_gameid = game_id FROM club WHERE club_id=@club_home;
--SELECT @away_gameid = game_id FROM club WHERE club_id=@club_away;

SET @headline = @home_name+' '+CAST(@home_score AS varchar(12)) +'-'+ CAST(@away_score AS varchar(12))+' '+@away_name;
SET @news_money = '';
IF @stadium_overflow > 0
BEGIN
	SET @news_money = 'There were only '+CAST(@stadium_capacity AS varchar(12))
	+' seats available in '+@home_name+', '
	+CAST(@stadium_overflow AS varchar(12))+' angry fans did not get to see the match live. ';
END

SET @news_marque = '';
IF(@match_type_id != 3)
BEGIN
SET @news_money = @news_money+'Average ticket price was $'+CAST(@average_ticket AS varchar(12));
SET @news_money = @news_money+', total sales were divided two third(2/3) to home club and one third(1/3) to away club. ';--, each received $'+CAST(@ticket_sales AS varchar(12))+' and $'+CAST(@ticket_sales AS varchar(12))+'. ';
SET @news_marque = '. Spectator income amounted to $'+CAST(@ticket_sales AS varchar(12));
END

SET @news_result = 'The game ends with ';

IF (@home_score_diff > 0)
BEGIN
	SET @news_result = @news_result + @home_name + ' beating ' + @away_name + ' ' + CAST(@home_score AS varchar(12))+' - '+CAST(@away_score AS varchar(12));
END

IF (@home_score_diff < 0)
BEGIN
	SET @news_result = @news_result + @away_name + ' beating ' + @home_name + ' ' + CAST(@away_score AS varchar(12))+' - '+CAST(@home_score AS varchar(12));
END

IF (@home_score_diff = 0)
BEGIN
	SET @news_result = @news_result + 'a draw ' + CAST(@away_score AS varchar(12)) + ' - ' + CAST(@home_score AS varchar(12));
END

SET @news = @news_money+@news_result;

IF (@match_type_id = 1) -- League Match
BEGIN
	SET @headline='(LEAGUE) '+@headline+@news_marque;
END

IF (@match_type_id = 2) -- Cup Match
BEGIN
	SET @headline='(CUP) '+@headline+@news_marque;
END

IF (@match_type_id = 3) -- Friendly Match
BEGIN
	SET @headline='(FRIENDLY) '+@headline;
END

INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_home, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 1, @headline, @news, '', 0, @club_away, 0, 0, 0)

-- Match Highlights
DECLARE @match_minute int, @highlight_type_id int, @highlight varchar(250), 
@player_id int, @player_name varchar(50), @pos_random int, @midfield_random int, @wing_random int, @counter int
-- Clear Match Highlights Table first
DELETE FROM dbo.match_highlight WHERE match_id=@match_id
-- Introduction
SET @highlight_type_id = 0;
SET @match_minute = 0;
SET @player_id = 0;
SET @highlight = 'A crowd of '+CAST(@spectators AS varchar(12))+' lines up at '+@home_name+' stadium. ';
SET @highlight = @highlight+@news_money;
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
-- Goals scored home
SET @counter = @home_score;
SET @highlight_type_id = 1;
WHILE @counter > 0
BEGIN
SET @player_id = 0;
SET @match_minute = dbo.fx_generateRandomNumber(newID(), 1, 90);
SET @pos_random = dbo.fx_generateRandomNumber(newID(), 1, 6);

IF @pos_random = 1
BEGIN
	IF @h_fw1 > 0
		SET @player_id = @h_fw1;
	ELSE
	BEGIN
		IF @h_fw2 > 0
			SET @player_id = @h_fw2;
		ELSE
			IF @h_fw3 > 0
				SET @player_id = @h_fw3;
	END
END

IF @pos_random = 2
BEGIN
	IF @h_fw2 > 0
		SET @player_id = @h_fw2;
	ELSE
	BEGIN
		IF @h_fw3 > 0
			SET @player_id = @h_fw3;
		ELSE
			IF @h_fw1 > 0
				SET @player_id = @h_fw1;
	END
END

IF @pos_random = 3
BEGIN
	IF @h_fw3 > 0
		SET @player_id = @h_fw3;
	ELSE
	BEGIN
		IF @h_fw1 > 0
			SET @player_id = @h_fw1;
		ELSE
			IF @h_fw2 > 0
				SET @player_id = @h_fw2;
	END
END

IF @pos_random = 4 -- im scored
BEGIN
	IF @h_im1 > 0
		SET @player_id = @h_im1;
	ELSE
	BEGIN
		IF @h_im2 > 0
			SET @player_id = @h_im2;
		ELSE
			IF @h_im3 > 0
				SET @player_id = @h_im3;
	END
END

IF @pos_random = 5 -- wing scored
BEGIN
	IF @h_rw > 0
		SET @player_id = @h_rw;
	ELSE
		IF @h_lw > 0
			SET @player_id = @h_lw;
END

IF @pos_random = 6 -- wing scored
BEGIN
	IF @h_lw > 0
		SET @player_id = @h_lw;
	ELSE
		IF @h_rw > 0
			SET @player_id = @h_rw;
END

IF @player_id = 0
BEGIN
SET @player_id = @h_rb;
END

SELECT @player_name = player_name FROM player WHERE player_id=@player_id;
SET @highlight = 'After '+CAST(@match_minute AS varchar(12))+' minutes, '+@player_name+' scored a goal for '+@home_name+'.';
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
UPDATE dbo.player SET fitness=fitness-10 WHERE player_id=@player_id;
SET @counter=@counter-1;
END

-- Goals scored away
SET @counter = @away_score;
SET @highlight_type_id = 2;
WHILE @counter > 0
BEGIN
SET @player_id = 0;
SET @match_minute = dbo.fx_generateRandomNumber(newID(), 1, 90);
SET @pos_random = dbo.fx_generateRandomNumber(newID(), 1, 6);

IF @pos_random = 1
BEGIN
	IF @a_fw1 > 0
		SET @player_id = @a_fw1;
	ELSE
	BEGIN
		IF @a_fw2 > 0
			SET @player_id = @a_fw2;
		ELSE
			IF @a_fw3 > 0
				SET @player_id = @a_fw3;
	END
END

IF @pos_random = 2
BEGIN
	IF @a_fw2 > 0
		SET @player_id = @a_fw2;
	ELSE
	BEGIN
		IF @a_fw3 > 0
			SET @player_id = @a_fw3;
		ELSE
			IF @a_fw1 > 0
				SET @player_id = @a_fw1;
	END
END
	
IF @pos_random = 3
BEGIN
	IF @a_fw3 > 0
		SET @player_id = @a_fw3;
	ELSE
	BEGIN
		IF @a_fw1 > 0
			SET @player_id = @a_fw1;
		ELSE
			IF @a_fw2 > 0
				SET @player_id = @a_fw2;
	END
END

IF @pos_random = 4 -- im scored
BEGIN
	IF @a_im1 > 0
		SET @player_id = @a_im1;
	ELSE
	BEGIN
		IF @a_im2 > 0
			SET @player_id = @a_im2;
		ELSE
			IF @a_im3 > 0
				SET @player_id = @a_im3;
	END
END

IF @pos_random = 5 -- wing scored
BEGIN
	IF @a_rw > 0
		SET @player_id = @a_rw;
	ELSE
		IF @a_lw > 0
			SET @player_id = @a_lw;
END

IF @pos_random = 6 -- wing scored
BEGIN
	IF @a_lw > 0
		SET @player_id = @a_lw;
	ELSE
		IF @a_rw > 0
			SET @player_id = @a_rw;
END

IF @player_id = 0
BEGIN
	SET @player_id = @a_rb;
END

SELECT @player_name = player_name FROM player WHERE player_id=@player_id;
SET @highlight = 'After '+CAST(@match_minute AS varchar(12))+' minutes, '+@player_name+' scored a goal for '+@away_name+'.';
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)
UPDATE dbo.player SET fitness=fitness-10 WHERE player_id=@player_id;
SET @counter=@counter-1;
END

-- Results
SET @highlight_type_id = 0;
SET @match_minute = 0;
SET @player_id = 0;
SET @highlight = 'This was a great game played by both sides. ';
SET @highlight = @highlight+@news_result;
INSERT INTO dbo.match_highlight VALUES (@match_id, @match_minute, @player_id, @highlight_type_id, @highlight)

-- Push Not results
/*
IF (@home_devtoken!='(null)' AND @home_devtoken!='0' AND @home_devtoken!='')
BEGIN
	EXEC usp_pushfast @home_gameid, @home_devtoken, @headline
END

IF (@away_devtoken!='(null)' AND @away_devtoken!='0' AND @away_devtoken!='')
BEGIN
	EXEC usp_pushfast @away_gameid, @away_devtoken, @headline
END
*/
END
END
END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ClubNew]    Script Date: 08/24/2011 10:05:10 ******/
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
DECLARE @counter int, @club_id int, @club_id_new int, @random int
SET @counter = 1;
SET @club_id = ISNULL((SELECT MAX(club_id) FROM club), 0);
WHILE @counter < 11
BEGIN

SET @club_id_new = @club_id+@counter;

-- Create New Club
INSERT INTO dbo.club VALUES (@club_id_new, '1', '0', 'UNKNOWN CLUB', 1/1/2011, 1/1/2011, 0, 0, 0, @division, @series, 10, 0, 100, 10, 1, 'Good Condition', 100, 1, 1, 1/1/2011, 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 10, 10, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99000, '', '', '', '', '', '', '1', 
CAST(dbo.fx_generateRandomNumber(newID(), 1, 13) AS varchar(6)), '1', '1', 10, 0, 0, 0, 1/1/2011, 0, 1/1/2011, 0, 1/1/2011)

-- Add Random New Players to Club
EXECUTE usp_PlayerNew @club_id_new

SET @counter=@counter+1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ClubNewBulk]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_LeagueBulk]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchToday]    Script Date: 08/24/2011 10:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shankar Nathan
-- Create date: 16 Sept 2009
-- Description:	Set match_played=1 for all match today and before today's date
-- =============================================
CREATE PROCEDURE [dbo].[usp_PlayMatchToday]
AS
BEGIN

DELETE FROM player WHERE position='All' AND club_id=0

--Generate new players on transfer list
EXECUTE usp_PlayerSalesBulk

DECLARE @counter1 int
SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM match WHERE match_played=0 AND match_datetime<=GETDATE()), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) match SET match_played=1 WHERE match_datetime<=GETDATE() AND match_played=0
	SET @counter1=@counter1-1;
END

END
GO
/****** Object:  StoredProcedure [dbo].[usp_PlayMatchBot]    Script Date: 08/24/2011 10:05:10 ******/
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

SET @counter1 = ISNULL((SELECT COUNT(match_id) FROM View_Match WHERE match_played=0 AND match_type_id=3 AND challenge_win=challenge_lose AND (club_away_uid='0' OR club_away_uid='1')), 0);
WHILE @counter1 > 0
BEGIN
	UPDATE TOP(1) View_Match SET match_played=1 WHERE match_played=0 AND match_type_id=3 AND challenge_win=challenge_lose AND (club_away_uid='0' OR club_away_uid='1')
	SET @counter1=@counter1-1;
END

END
GO
/****** Object:  View [dbo].[View_Series]    Script Date: 08/24/2011 10:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Series]
AS
SELECT     club_id, club_name, division, series, Played, Win, Lose, GF, GA, Played - Win - Lose AS Draw, GF - GA AS GD, Win * 3 + (Played - Win - Lose) AS Pts
FROM         dbo.View_SeriesBase
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
/****** Object:  View [dbo].[View_Promotion]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Weekly]    Script Date: 08/24/2011 10:05:10 ******/
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
keeper = CASE WHEN (training = 1) THEN keeper - player_condition + 1 + (CAST((coaches+coach_skill) AS real)/100) ELSE keeper END,
defend = CASE WHEN (training = 2) THEN defend - player_condition + 1 + (CAST((coaches+coach_skill) AS real)/100) ELSE defend END,
playmaking = CASE WHEN (training = 3) THEN playmaking - player_condition + 1 + (CAST((coaches+coach_skill) AS real)/100) ELSE playmaking END,
attack = CASE WHEN (training = 4) THEN attack - player_condition + 1 + (CAST((coaches+coach_skill) AS real)/100) ELSE attack END,
passing = CASE WHEN (training = 5) THEN passing - player_condition + 1 + (CAST((coaches+coach_skill) AS real)/100) ELSE passing END,
fitness = CASE WHEN (training = 6) THEN fitness + 10 ELSE fitness END,
player_condition_days=player_condition_days-7-doctors 
WHERE club_id != 0

UPDATE player SET 
player_value=(((keeper*keeper)+(defend*defend)+(playmaking*playmaking)+(attack*attack)+(passing*passing))*30),
player_salary=(((keeper*keeper)+(defend*defend)+(playmaking*playmaking)+(attack*attack)+(passing*passing))/10),
player_goals=(((keeper*keeper)+(defend*defend)+(playmaking*playmaking)+(attack*attack)+(passing*passing))/3000) 
WHERE club_id != 0

UPDATE player SET player_goals=1 WHERE player_goals<1
UPDATE player SET player_goals=10 WHERE player_goals>10

--Clear negative player_condition_days
UPDATE player SET player_condition_days=0 WHERE player_condition_days < 0
UPDATE player SET player_condition=0 WHERE player_condition_days = 0
UPDATE player SET fitness=fitness+20 WHERE fitness<181 AND player_condition=0

--Player above 35 decline
UPDATE player SET
keeper=keeper-1,
defend=defend-1,
playmaking=playmaking-1,
attack=attack-1,
passing=passing-1
WHERE player_age > 35 AND club_id != 0

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
--UPDATE club SET longitude=0, latitude=0 WHERE longitude=101.6
--UPDATE club SET club_name = UPPER(club_name)

--Clear All News
DELETE FROM news --WHERE everyone!=1

UPDATE club SET
revenue_sponsors=fan_members*fan_mood/5, 
expenses_stadium=stadium_capacity/10, 
expenses_interest=-balance/(100+accountants), 
revenue_investments=(balance/1000)+accountants, 
expenses_salary=(SELECT SUM(player_salary) FROM player WHERE player.club_id=club.club_id) --+ coach_salary 
WHERE uid != '0'

--Clear negative finance
UPDATE club SET revenue_investments=0 WHERE revenue_investments is null OR revenue_investments<0
UPDATE club SET expenses_interest=0 WHERE expenses_interest is null OR expenses_interest<0

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
fan_members=fan_members+spokespersons,
fan_mood=fan_mood+spokespersons 
WHERE uid != '0'

--Clear over limit fan_mood, teamsprit, confidence
UPDATE club SET teamspirit=190 WHERE teamspirit > 200
UPDATE club SET confidence=190 WHERE confidence > 200
UPDATE club SET fan_mood=190 WHERE fan_mood > 200
UPDATE club SET fan_members = 100 WHERE fan_members is null OR fan_members<100

DELETE player WHERE club_id=0 AND position='All'

--Update league ranking
UPDATE season SET league_round=league_round+2, cup_round=cup_round+1

--Accept challenge from bot clubs
EXECUTE usp_PlayMatchBot

--Clear All Invites and Friendly
DELETE FROM match WHERE match_type_id = 3 AND match_played=0

--News regarding weekly update
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Your 5 star ratings on AppStore motivates us to make this game better!', 'Launch App Store on your iphone/ipod and find this game then rate it.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Download Latest Football Fantasy from AppStore now!', 'Search for tapfantasy on AppStore now!', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 1, 1, 'Weekly Financial Update Took Place. A new league season has begun, the board wishes you good luck.', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Top 5 clubs in the series for division 6 and above will be promoted to a higher division', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Only Top 1 club in the series for division 5 and bellow will be promoted to a higher division', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'All clubs bellow 5th place in the series will be demoted to a lower division', 'The board wishes you good luck.', '', 1, 0, 0, 0, 0)
INSERT INTO dbo.news VALUES (getdate(), 0, 1, 'Win the CUP and receive $250,000, be second and receive $100,000', 'Register your club for the CUP and stand a chance to win. Your team will improve their skills and gain experience faster when playing in cup matches.', '', 1, 0, 0, 0, 0)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_LeagueRanking]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part4]    Script Date: 08/24/2011 10:05:10 ******/
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
DELETE FROM league

SET DEADLOCK_PRIORITY HIGH;

DECLARE @d1 datetime, @d2 datetime, @d3 datetime
SET @d1 = GETDATE()+1
SET @d2 = GETDATE()+2
SET @d3 = GETDATE()+3

UPDATE season SET league_round=1, league_start=@d1, league_end=GETDATE()+127

EXECUTE usp_MatchLeagueGenerator @d1, 1, 1
EXECUTE usp_LeagueBulk @d1, 2, 1, 5
EXECUTE usp_LeagueBulk @d1, 3, 1, 25
EXECUTE usp_LeagueBulk @d1, 4, 1, 125
EXECUTE usp_LeagueBulk @d1, 5, 1, 625
EXECUTE usp_LeagueBulk @d1, 6, 1, 625
EXECUTE usp_LeagueBulk @d1, 7, 1, 625
EXECUTE usp_LeagueBulk @d1, 8, 1, 625
EXECUTE usp_LeagueBulk @d1, 9, 1, 625
EXECUTE usp_LeagueBulk @d1, 10, 1, 625
EXECUTE usp_LeagueBulk @d2, 11, 1, 625
EXECUTE usp_LeagueBulk @d2, 12, 1, 625
EXECUTE usp_LeagueBulk @d2, 13, 1, 625
EXECUTE usp_LeagueBulk @d2, 14, 1, 625

END
GO
/****** Object:  StoredProcedure [dbo].[usp_LeagueRankingBulk]    Script Date: 08/24/2011 10:05:10 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_League_NEW_Part1]    Script Date: 08/24/2011 10:05:10 ******/
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

EXECUTE usp_LeagueRanking 1, 1
EXECUTE usp_LeagueRankingBulk 2, 1, 5
EXECUTE usp_LeagueRankingBulk 3, 1, 25
EXECUTE usp_LeagueRankingBulk 4, 1, 125
EXECUTE usp_LeagueRankingBulk 5, 1, 625
EXECUTE usp_LeagueRankingBulk 6, 1, 625
EXECUTE usp_LeagueRankingBulk 7, 1, 625
EXECUTE usp_LeagueRankingBulk 8, 1, 625
EXECUTE usp_LeagueRankingBulk 9, 1, 625
EXECUTE usp_LeagueRankingBulk 10, 1, 625
EXECUTE usp_LeagueRankingBulk 11, 1, 625
EXECUTE usp_LeagueRankingBulk 12, 1, 625
EXECUTE usp_LeagueRankingBulk 13, 1, 625
EXECUTE usp_LeagueRankingBulk 14, 1, 625
EXECUTE usp_LeagueRankingBulk 15, 1, 625
EXECUTE usp_LeagueRankingBulk 16, 1, 625
EXECUTE usp_LeagueRankingBulk 17, 1, 625

END
GO
/****** Object:  Default [DF_product_identifier]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_identifier]  DEFAULT ('com.tapf.sm.') FOR [identifier]
GO
/****** Object:  Default [DF_product_for_sale]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_for_sale]  DEFAULT ((1)) FOR [for_sale]
GO
/****** Object:  Default [DF_product_type]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_type]  DEFAULT ('Consumable') FOR [type]
GO
/****** Object:  Default [DF_product_price_real]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_price_real]  DEFAULT ((99)) FOR [price_real]
GO
/****** Object:  Default [DF_product_price_virtual]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[product] ADD  CONSTRAINT [DF_product_price_virtual]  DEFAULT ((10000)) FOR [price_virtual]
GO
/****** Object:  Default [DF_Table_1_price_real]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[achievement_type] ADD  CONSTRAINT [DF_Table_1_price_real]  DEFAULT ((99)) FOR [reward]
GO
/****** Object:  Default [DF_news_marquee]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_marquee]  DEFAULT ((1)) FOR [marquee]
GO
/****** Object:  Default [DF_news_to_all]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_to_all]  DEFAULT ((0)) FOR [everyone]
GO
/****** Object:  Default [DF_news_club_id]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_club_id]  DEFAULT ((0)) FOR [club_id]
GO
/****** Object:  Default [DF_news_division]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_division]  DEFAULT ((0)) FOR [division]
GO
/****** Object:  Default [DF_news_series]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_series]  DEFAULT ((0)) FOR [series]
GO
/****** Object:  Default [DF_news_playing_cup]    Script Date: 08/24/2011 10:05:06 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_playing_cup]  DEFAULT ((0)) FOR [playing_cup]
GO
/****** Object:  Default [DF_club_longitude]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_longitude]  DEFAULT ((0)) FOR [longitude]
GO
/****** Object:  Default [DF_club_latitude]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_latitude]  DEFAULT ((0)) FOR [latitude]
GO
/****** Object:  Default [DF_club_playing_cup]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_playing_cup]  DEFAULT ((0)) FOR [playing_cup]
GO
/****** Object:  Default [DF_club_division]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_division]  DEFAULT ((0)) FOR [division]
GO
/****** Object:  Default [DF_club_series]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_series]  DEFAULT ((0)) FOR [series]
GO
/****** Object:  Default [DF_club_world_ranking]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_world_ranking]  DEFAULT ((0)) FOR [league_ranking]
GO
/****** Object:  Default [DF_club_undefeated_counter]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_undefeated_counter]  DEFAULT ((0)) FOR [undefeated_counter]
GO
/****** Object:  Default [DF_club_fan_members]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fan_members]  DEFAULT ((0)) FOR [fan_members]
GO
/****** Object:  Default [DF_club_fan_mood]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fan_mood]  DEFAULT ((0)) FOR [fan_mood]
GO
/****** Object:  Default [DF_club_fan_expectation]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fan_expectation]  DEFAULT ((0)) FOR [fan_expectation]
GO
/****** Object:  Default [DF_club_stadium_capacity]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_stadium_capacity]  DEFAULT ((1000)) FOR [stadium_capacity]
GO
/****** Object:  Default [DF_club_stadium]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_stadium]  DEFAULT ((0)) FOR [stadium]
GO
/****** Object:  Default [DF_club_average_ticket]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_average_ticket]  DEFAULT ((1)) FOR [average_ticket]
GO
/****** Object:  Default [DF_club_managers]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_managers]  DEFAULT ((0)) FOR [managers]
GO
/****** Object:  Default [DF_club_scouts]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_scouts]  DEFAULT ((0)) FOR [scouts]
GO
/****** Object:  Default [DF_club_spokespersons]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_spokespersons]  DEFAULT ((0)) FOR [spokespersons]
GO
/****** Object:  Default [DF_club_coaches]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_coaches]  DEFAULT ((0)) FOR [coaches]
GO
/****** Object:  Default [DF_club_psychologists]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_psychologists]  DEFAULT ((0)) FOR [psychologists]
GO
/****** Object:  Default [DF_club_accountants]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_accountants]  DEFAULT ((0)) FOR [accountants]
GO
/****** Object:  Default [DF_club_physiotherapists]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_physiotherapists]  DEFAULT ((0)) FOR [physiotherapists]
GO
/****** Object:  Default [DF_club_doctors]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_doctors]  DEFAULT ((0)) FOR [doctors]
GO
/****** Object:  Default [DF_club_training]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_training]  DEFAULT ((0)) FOR [training]
GO
/****** Object:  Default [DF_club_teamspirit]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_teamspirit]  DEFAULT ((0)) FOR [teamspirit]
GO
/****** Object:  Default [DF_club_confidence]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_confidence]  DEFAULT ((0)) FOR [confidence]
GO
/****** Object:  Default [DF_club_tactic]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_tactic]  DEFAULT ((0)) FOR [tactic]
GO
/****** Object:  Default [DF_club_formation]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_formation]  DEFAULT ((0)) FOR [formation]
GO
/****** Object:  Default [DF_club_gk]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_gk]  DEFAULT ((0)) FOR [gk]
GO
/****** Object:  Default [DF_club_rb]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_rb]  DEFAULT ((0)) FOR [rb]
GO
/****** Object:  Default [DF_club_lb]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_lb]  DEFAULT ((0)) FOR [lb]
GO
/****** Object:  Default [DF_club_rw]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_rw]  DEFAULT ((0)) FOR [rw]
GO
/****** Object:  Default [DF_club_lw]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_lw]  DEFAULT ((0)) FOR [lw]
GO
/****** Object:  Default [DF_club_cd1]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_cd1]  DEFAULT ((0)) FOR [cd1]
GO
/****** Object:  Default [DF_club_cd2]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_cd2]  DEFAULT ((0)) FOR [cd2]
GO
/****** Object:  Default [DF_club_cd3]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_cd3]  DEFAULT ((0)) FOR [cd3]
GO
/****** Object:  Default [DF_club_im1]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_im1]  DEFAULT ((0)) FOR [im1]
GO
/****** Object:  Default [DF_club_im2]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_im2]  DEFAULT ((0)) FOR [im2]
GO
/****** Object:  Default [DF_club_im3]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_im3]  DEFAULT ((0)) FOR [im3]
GO
/****** Object:  Default [DF_club_fw1]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fw1]  DEFAULT ((0)) FOR [fw1]
GO
/****** Object:  Default [DF_club_fw2]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fw2]  DEFAULT ((0)) FOR [fw2]
GO
/****** Object:  Default [DF_club_fw3]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_fw3]  DEFAULT ((0)) FOR [fw3]
GO
/****** Object:  Default [DF_club_sgk]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sgk]  DEFAULT ((0)) FOR [sgk]
GO
/****** Object:  Default [DF_club_sd]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sd]  DEFAULT ((0)) FOR [sd]
GO
/****** Object:  Default [DF_club_sim]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sim]  DEFAULT ((0)) FOR [sim]
GO
/****** Object:  Default [DF_club_sfw]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sfw]  DEFAULT ((0)) FOR [sfw]
GO
/****** Object:  Default [DF_club_sw]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_sw]  DEFAULT ((0)) FOR [sw]
GO
/****** Object:  Default [DF_club_revenue_stadium]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_stadium]  DEFAULT ((0)) FOR [revenue_stadium]
GO
/****** Object:  Default [DF_club_revenue_sponsors]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_sponsors]  DEFAULT ((0)) FOR [revenue_sponsors]
GO
/****** Object:  Default [DF_club_revenue_player_sales]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_player_sales]  DEFAULT ((0)) FOR [revenue_sales]
GO
/****** Object:  Default [DF_club_revenue_investments]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_investments]  DEFAULT ((0)) FOR [revenue_investments]
GO
/****** Object:  Default [DF_club_revenue_prize_money]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_prize_money]  DEFAULT ((0)) FOR [revenue_others]
GO
/****** Object:  Default [DF_club_revenue_total]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_revenue_total]  DEFAULT ((0)) FOR [revenue_total]
GO
/****** Object:  Default [DF_club_expenses_stadium]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_stadium]  DEFAULT ((0)) FOR [expenses_stadium]
GO
/****** Object:  Default [DF_club_expenses_player_salary]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_player_salary]  DEFAULT ((0)) FOR [expenses_salary]
GO
/****** Object:  Default [DF_club_expenses_player_purchases]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_player_purchases]  DEFAULT ((0)) FOR [expenses_purchases]
GO
/****** Object:  Default [DF_club_expenses_interest]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_interest]  DEFAULT ((0)) FOR [expenses_interest]
GO
/****** Object:  Default [DF_club_expenses_firing]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_firing]  DEFAULT ((0)) FOR [expenses_others]
GO
/****** Object:  Default [DF_club_expenses_total]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_expenses_total]  DEFAULT ((0)) FOR [expenses_total]
GO
/****** Object:  Default [DF_club_balance]    Script Date: 08/24/2011 10:05:08 ******/
ALTER TABLE [dbo].[club] ADD  CONSTRAINT [DF_club_balance]  DEFAULT ((0)) FOR [balance]
GO
/****** Object:  Default [DF_player_player_injured]    Script Date: 08/24/2011 10:05:09 ******/
ALTER TABLE [dbo].[player] ADD  CONSTRAINT [DF_player_player_injured]  DEFAULT ((0)) FOR [player_condition_days]
GO
/****** Object:  Default [DF_match_match_played]    Script Date: 08/24/2011 10:05:09 ******/
ALTER TABLE [dbo].[match] ADD  CONSTRAINT [DF_match_match_played]  DEFAULT ((0)) FOR [match_played]
GO

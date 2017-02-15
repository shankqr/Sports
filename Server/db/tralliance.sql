USE [football]
GO
/****** Object:  Trigger [dbo].[trclub]    Script Date: 1/19/2013 9:46:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tralliance]
   ON  [dbo].[alliance]
   AFTER INSERT
   NOT FOR REPLICATION
AS
BEGIN
SET NOCOUNT ON;

DECLARE @aid int, @cid int
SELECT @aid = alliance_id FROM inserted;
SELECT @cid = leader_id FROM inserted;

IF (@aid> 0 AND @cid > 0)
BEGIN
	UPDATE club SET alliance_id=@aid WHERE club_id=@cid;
END

END
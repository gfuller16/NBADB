USE [NBADB]
GO

/****** Object:  StoredProcedure [dbo].[spDraftRookies]    Script Date: 3/6/2018 8:22:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDraftRookies] --2017
@RetireYear INT
AS
BEGIN

    IF EXISTS(SELECT [plID] FROM [tblPlayer] WHERE [plExperience] > 10)
    BEGIN

	   DECLARE @plID INT

	   SET @RetireYear = @RetireYear + 1

	   DECLARE [RetirePlayers] CURSOR FOR

		  SELECT
		  [plID]
		  FROM [tblPlayer]
		  WHERE [plExperience] > 10
		  AND [plRetired] = 0

	   OPEN [RetirePlayers]
	   FETCH NEXT FROM [RetirePlayers] INTO @plID

	   WHILE(@@FETCH_STATUS = 0)
	   BEGIN
    
		  INSERT INTO tblRetirees
		  SELECT
		  ISNULL((SELECT MAX(rtID) + 1 FROM tblRetirees),0),
		  [plFirstName],[plLastName],
		  AVG([pshPoints]),
		  AVG([pshAssists]),
		  AVG([pshRebounds]),
		  @RetireYear
		  FROM [tblPlayer] p
		  JOIN [tblPlayerStatsHistory] h
			 ON h.[psh_plID] = p.[plID]
		  WHERE [plID] = @plID
		  GROUP BY
		  [plFirstName],[plLastName]

		  DECLARE @Position INT = (SELECT [plPosition] FROM [tblPlayer] WHERE [plID] = @plID)
		  DECLARE @Team INT = (SELECT [plTeam] FROM [tblPlayer] WHERE [plID] = @plID)

		  EXEC [spCreateRookie] @RetireYear, @Position

		  INSERT INTO tblPlayer
		  SELECT TOP 1
		  r.[rkID],
		  r.[rkFirstName],
		  r.[rkLastName],
		  @Team,
		  r.[rkInsideShot],
		  r.[rkOutsideShot],
		  r.[rkPass],
		  r.[rkRebound],
		  r.[rkDefense],
		  r.[rkIQ],
		  r.[rkDetermination],
		  0,
		  @Position,
		  0,
		  r.[rkYear],
		  0
		  FROM [tblRookies] r
		  ORDER BY r.[rkID] DESC

		  UPDATE [tblPlayer]
		  SET plRetired = 1
		  WHERE plID = @plID

		  FETCH NEXT FROM [RetirePlayers] INTO @plID

	   END

	   CLOSE [RetirePlayers]
	   DEALLOCATE [RetirePlayers]

	   /*
	   SELECT * FROM [tblPlayer]
	   WHERE [plExperience] = 0

	   SELECT * FROM [tblRetirees]

	   SELECT * FROM [tblRookies]
	   */

    END

    --[spReset]
    --PRINT @RookieFirstName + ' ' + @RookieLastName

END
GO

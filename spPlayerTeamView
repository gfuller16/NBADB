USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spPlayerTeamView]    Script Date: 4/26/2017 9:06:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPlayerTeamView]
@ID INT
AS
BEGIN

IF (@ID = 1)
BEGIN
	SELECT [plID]
		,[plFirstName]
		,[plLastName]
		,po.[poShortDesc] as [Position]
		,tblTeam.tmName
		,[plTeam]
		,[plInsideShot]
		,[plOutsideShot]
		,[plPass]
		,[plRebound]
		,[plDefense]
		,[plIQ]
		,[plDetermination]
		,[plExperience]
	FROM [NBADB].[dbo].[tblPlayer] pl
	JOIN tblTeam
		ON tblTeam.tmID = pl.plTeam
	JOIN tblPosition po
		ON po.poID = pl.plPosition

END

ELSE IF (@ID = 2)
BEGIN
	SELECT t.tmLocation + ' ' + t.tmName AS TeamName
		  ,SUM(([plInsideShot] * 1.3)
		  + ([plOutsideShot] * 1.4)
		  + ([plPass] * 1.2)
		  + ([plRebound] * 1.1)
		  + ([plDefense] * 1)
		  + ([plIQ] * 1.5)
		  + ([plDetermination] * .75)) AS Total
	FROM [NBADB].[dbo].[tblPlayer] p
	JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	GROUP BY t.tmLocation, t.tmName
	ORDER BY Total DESC
END

ELSE IF (@ID = 3)
BEGIN
	  SELECT p.plID,
		  p.plFirstName + ' ' + p.plLastName as Name
		  ,SUM(([plInsideShot] * 1.3)
		  + ([plOutsideShot] * 1.4)
		  + ([plPass] * 1.2)
		  + ([plRebound] * 1.1)
		  + ([plDefense] * 1)
		  + ([plIQ] * 1.5)
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	  GROUP BY p.plID, p.plFirstName,p.plLastName
	  ORDER BY Total DESC
END

ELSE IF (@ID = 5)
BEGIN
	DELETE FROM tblPlayer
	INSERT INTO tblPlayer
	SELECT
	plID,plFirstName,plLastName,
	plTeam,plInsideShot,plOutsideShot,
	plPass,plRebound,plDefense,
	plIQ,plDetermination,plExperience,
	plPosition
	FROM tblPlayerBackup
END

ELSE IF (@ID = 6)
BEGIN

	DELETE FROM tblPlayerBackup
	INSERT INTO tblPlayerBackup
	SELECT
	plID,plFirstName,plLastName,
	plTeam,plInsideShot,plOutsideShot,
	plPass,plRebound,plDefense,
	plIQ,getdate(),plDetermination,plExperience
	,plPosition
	FROM tblPlayer
END

ELSE IF (@ID = 666)
BEGIN
	UPDATE [NBADB].[dbo].[tblTeam]
	SET tmDivLosses = 0, tmDivWins = 0, tmConfLosses = 0, tmConfWins = 0, tmTotalWins = 0, tmTotalLosses = 0, tmNonConfLosses = 0, tmNonConfWins = 0
	DELETE FROM tblGameStats
	DELETE FROM tblGames
	DELETE FROM tblMVP
	DELETE FROM tblNBAChampion
	DELETE FROM tblNBAStandings
	DELETE FROM tblPlayoffSeeding

	DELETE FROM tblPlayer
	INSERT INTO tblPlayer
	SELECT
	plID,plFirstName,plLastName,
	plTeam,plInsideShot,plOutsideShot,
	plPass,plRebound,plDefense,
	plIQ,plDetermination,plExperience,
	plPosition
	FROM tblPlayerBackup

END

END

USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spReset]    Script Date: 3/6/2018 8:26:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spReset]
AS
BEGIN

	UPDATE [NBADB].[dbo].[tblTeam]
	SET tmDivLosses = 0, tmDivWins = 0, tmConfLosses = 0, tmConfWins = 0, tmTotalWins = 0, tmTotalLosses = 0, tmNonConfLosses = 0, tmNonConfWins = 0
	DELETE FROM tblGameStats
	DELETE FROM tblGames
	DELETE FROM tblMVP
	DELETE FROM tblNBAChampion
	DELETE FROM tblNBAStandings
	DELETE FROM tblPlayoffSeeding
	DELETE FROM tblPlayerStatsHistory
	DELETE FROM tblMIP
	DELETE FROM tblROY
	DELETE FROM tblTripleDoubleClub
	DELETE FROM tblFantasyChampion
	DELETE FROM tblFantasyTeam
	DELETE FROM tblScoringTitle
	DELETE FROM tblRetirees
	DELETE FROM tblRookies

	DELETE FROM tblPlayer
	INSERT INTO tblPlayer
	SELECT
	plID,plFirstName,plLastName,
	plTeam,plInsideShot,plOutsideShot,
	plPass,plRebound,plDefense,
	plIQ,plDetermination,plExperience,
	plPosition,plFantasyScore,plRookieYear,
	plRetired
	FROM tblPlayerBackup

END

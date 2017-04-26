USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spTopTeamStats]    Script Date: 4/26/2017 9:09:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spTopTeamStats]
@INT INT
AS
BEGIN

	IF(@INT = 1)
	BEGIN

		SELECT DISTINCT
		t.tmID,
		t.tmLocation + ' ' + t.tmName AS [Team Name],
		(SELECT COUNT(*) FROM [NBADB].[dbo].[tblGames] WHERE [gmTeam1] = t.tmID OR [gmTeam2] = t.tmID) AS GamesPlayed,
		CONVERT(DECIMAL(5,2),(ISNULL(CONVERT(DECIMAL(5,1),(SELECT SUM([gmPoints1]) FROM [NBADB].[dbo].[tblGames] where gmTeam1 = t.tmID group by [gmTeam1])),0) +
							  ISNULL(CONVERT(DECIMAL(5,1),(SELECT SUM([gmPoints2]) FROM [NBADB].[dbo].[tblGames] where gmTeam2 = t.tmID group by [gmTeam2])),0)) /
		(SELECT COUNT(*) FROM [NBADB].[dbo].[tblGames] WHERE [gmTeam1] = t.tmID OR [gmTeam2] = t.tmID)) AS AvgPoints
		FROM tblTeam t
		JOIN tblGames g
			ON g.gmTeam1 = t.tmID
			OR g.gmTeam2 = t.tmID
		ORDER BY AvgPoints DESC

	END

	ELSE IF(@INT = 2)
	BEGIN
		
		SELECT DISTINCT
		t.tmID,
		t.tmLocation + ' ' + t.tmName AS [Team Name],
		(SELECT COUNT(*) FROM [NBADB].[dbo].[tblGames] WHERE [gmTeam1] = t.tmID OR [gmTeam2] = t.tmID) AS GamesPlayed,
		CONVERT(DECIMAL(5,2),(ISNULL(CONVERT(DECIMAL(5,1),(SELECT SUM([gmAssists1]) FROM [NBADB].[dbo].[tblGames] where gmTeam1 = t.tmID group by [gmTeam1])),0) +
							  ISNULL(CONVERT(DECIMAL(5,1),(SELECT SUM([gmAssists2]) FROM [NBADB].[dbo].[tblGames] where gmTeam2 = t.tmID group by [gmTeam2])),0)) /
		(SELECT COUNT(*) FROM [NBADB].[dbo].[tblGames] WHERE [gmTeam1] = t.tmID OR [gmTeam2] = t.tmID)) AS AvgAssists
		FROM tblTeam t
		JOIN tblGames g
			ON g.gmTeam1 = t.tmID
			OR g.gmTeam2 = t.tmID
		ORDER BY AvgAssists DESC

	END

	ELSE IF(@INT = 3)
	BEGIN
			
		SELECT DISTINCT
		t.tmID,
		t.tmLocation + ' ' + t.tmName AS [Team Name],
		(SELECT COUNT(*) FROM [NBADB].[dbo].[tblGames] WHERE [gmTeam1] = t.tmID OR [gmTeam2] = t.tmID) AS GamesPlayed,
		CONVERT(DECIMAL(5,2),(ISNULL(CONVERT(DECIMAL(5,1),(SELECT SUM([gmRebounds1]) FROM [NBADB].[dbo].[tblGames] where gmTeam1 = t.tmID group by [gmTeam1])),0) +
							  ISNULL(CONVERT(DECIMAL(5,1),(SELECT SUM([gmRebounds2]) FROM [NBADB].[dbo].[tblGames] where gmTeam2 = t.tmID group by [gmTeam2])),0)) /
		(SELECT COUNT(*) FROM [NBADB].[dbo].[tblGames] WHERE [gmTeam1] = t.tmID OR [gmTeam2] = t.tmID)) AS AvgRebounds
		FROM tblTeam t
		JOIN tblGames g
			ON g.gmTeam1 = t.tmID
			OR g.gmTeam2 = t.tmID
		ORDER BY AvgRebounds DESC

	END
END

USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spTopTeamStats]    Script Date: 4/24/2017 3:07:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTopTeamStats]
AS
BEGIN

	SELECT DISTINCT
	t.tmID,
	t.tmLocation + ' ' + t.tmName AS Team,
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

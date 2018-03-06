USE [NBADB]
GO

/****** Object:  StoredProcedure [dbo].[spBestTeamHistory]    Script Date: 3/6/2018 8:21:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBestTeamHistory]
@ID INT
AS
BEGIN

IF (@ID = 1)
BEGIN
	SELECT TOP 10
		t.tmLocation + ' ' + t.tmName AS [TeamName]
		,[st_tmTotalWins]
		,[st_tmTotalLosses]
		,[stWinPercentage]
		,[stYear]
	FROM [NBADB].[dbo].[tblNBAStandings] n
	JOIN [dbo].[tblTeam] t
		ON t.tmID = n.st_tmID
	ORDER BY
	[stWinPercentage] DESC, [stYear] DESC
END

ELSE IF (@ID = 2)
BEGIN
	SELECT
		t.tmLocation + ' ' + t.tmName AS [TeamName]
		,SUM([st_tmTotalWins]) AS All_TimeWins
		,SUM([st_tmTotalLosses]) AS All_TimeLosses
		,CONVERT(DECIMAL(6,3),CONVERT(DECIMAL,SUM([st_tmTotalWins]))/(CONVERT(DECIMAL,SUM([st_tmTotalWins]))+CONVERT(DECIMAL,SUM([st_tmTotalLosses])))) AS [All_TimeWinPct]
	FROM [NBADB].[dbo].[tblNBAStandings] n
	JOIN [dbo].[tblTeam] t
		ON t.tmID = n.st_tmID
	GROUP BY
	t.tmLocation,
	t.tmName
	ORDER BY
	[All_TimeWinPct] DESC
END

END
GO

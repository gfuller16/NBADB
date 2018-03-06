USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spWinners]    Script Date: 3/6/2018 8:29:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spWinners]
AS
BEGIN

	-- STATS
	SELECT t.tmLocation + ' ' + t.tmName as TeamName
			,[chYear]
	FROM [NBADB].[dbo].[tblNBAChampion] c
	JOIN tblTeam t
		ON t.tmID = c.ch_tmID
	ORDER BY [chYear] DESC

	--Counts
	SELECT t.tmLocation + ' ' + t.tmName as TeamName,
	COUNT(chID) as Champs,
	CONVERT(VARCHAR(6),CONVERT(DECIMAL(5,2),CONVERT(DECIMAL(4,2),COUNT(chID))/CONVERT(DECIMAL(4,2),(SELECT COUNT(chID) FROM tblNBAChampion))) * 100) + '%' AS PercTitles
	FROM [NBADB].[dbo].[tblNBAChampion] c
	JOIN tblTeam t
		ON t.tmID = c.ch_tmID
	GROUP BY
	t.tmLocation, t.tmName
	ORDER BY
	Champs DESC
END

USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spWinners]    Script Date: 4/19/2017 12:46:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spWinners]
@ID INT
AS
BEGIN

IF(@ID = 1)
	BEGIN
		-- STATS
		SELECT t.tmLocation + ' ' + t.tmName as TeamName
			  ,[chYear]
		FROM [NBADB].[dbo].[tblNBAChampion] c
		JOIN tblTeam t
			ON t.tmID = c.ch_tmID

		SELECT p.plFirstName + ' ' + p.plLastName as Name
			  ,[tmName] as Team
			  ,[mPtsAvg]
			  ,[mAstAvg]
			  ,[mRebAvg]
			  ,[mYear]
			  ,[mRS_Finals]
		FROM [NBADB].[dbo].[tblMVP] m
		JOIN tblPlayer p
			ON p.plID = m_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
	END

ELSE IF (@ID = 2)
	BEGIN
		--Counts
		SELECT t.tmLocation + ' ' + t.tmName as TeamName,
		COUNT(*) as Champs
		FROM [NBADB].[dbo].[tblNBAChampion] c
		JOIN tblTeam t
			ON t.tmID = c.ch_tmID
		GROUP BY
		t.tmLocation, t.tmName
		ORDER BY
		Champs DESC

		SELECT p.plFirstName + ' ' + p.plLastName as Name
			  ,(SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 1 AND m_plID = p.plID) AS FinalsMVPs
			  ,(SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 0 AND m_plID = p.plID) AS RegularSeasonMVPs
		FROM [NBADB].[dbo].[tblMVP] m
		JOIN tblPlayer p
			ON p.plID = m_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY
		p.plFirstName,
		p.plID,
		p.plLastName
		ORDER BY
		((SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 1 AND m_plID = p.plID)+(SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 0 AND m_plID = p.plID)) DESC,
		(SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 1 AND m_plID = p.plID) DESC
	END
END

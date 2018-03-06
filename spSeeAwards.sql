USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spSeeAwards]    Script Date: 3/6/2018 8:26:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSeeAwards]
@INT INT
AS
BEGIN
	
	IF(@INT = 1) --MVP
	BEGIN
		
		SELECT p.plFirstName + ' ' + p.plLastName as [Name]
			  ,[tmName] as [Team]
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
		ORDER BY [mYear] DESC,[mRS_Finals]

		SELECT p.plFirstName + ' ' + p.plLastName as [Name]
			  ,(SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 1 AND m_plID = p.plID) AS [FinalsMVPs]
			  ,(SELECT COUNT(mRS_Finals) FROM tblMVP WHERE mRS_Finals = 0 AND m_plID = p.plID) AS [RegularSeasonMVPs]
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

	ELSE IF(@INT = 2) --ROY
	BEGIN
		
		SELECT
		p.plID,
		p.plFirstName + ' ' + p.plLastName as [Player Name],
		t.tmLocation + ' ' + t.tmName as [Team Name],
		r.rPtsAvg as [PtsAvg],
		r.rAstAvg as [AstAvg],
		r.rRebAvg as [RebAvg],
		r.rYear as [Year]
		FROM tblROY r
		JOIN tblPlayer p
			ON p.plID = r.r_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		ORDER BY [rYear] DESC

	END

	ELSE IF(@INT = 3) --MIP
	BEGIN
		
		SELECT
		p.plID,
		p.plFirstName + ' ' + p.plLastName as [Player Name],
		t.tmLocation + ' ' + t.tmName as [Team Name],
		m.mipPtsImproved as [PtsImproved],
		m.mipAstImproved as [AstImproved],
		m.mipRebImproved as [RebImproved],
		m.mipYear as [Year]
		FROM tblMIP m
		JOIN tblPlayer p
			ON p.plID = m.mip_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		ORDER BY [mipYear] DESC

		SELECT
		p.plID,
		p.plFirstName + ' ' + p.plLastName as [Player Name],
		t.tmLocation + ' ' + t.tmName as [Team Name],
		COUNT(p.plID) as [Nominated]
		FROM tblMIP m
		JOIN tblPlayer p
			ON p.plID = m.mip_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plID,plFirstName,plLastName,tmLocation,tmName
		ORDER BY [Nominated] DESC

	END

	ELSE IF(@INT = 4)
	BEGIN
		
		SELECT
		p.plID,
		p.plFirstName + ' ' + p.plLastName as [Player Name],
		t.tmLocation + ' ' + t.tmName as [Team Name],
		s.scPointsAvg as [PtsAvg],
		s.scYear as [Year]
		FROM tblScoringTitle s
		JOIN tblPlayer p
			ON p.plID = s.sc_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		ORDER BY [scYear] DESC

		SELECT
		p.plID,
		p.plFirstName + ' ' + p.plLastName as [Player Name],
		t.tmLocation + ' ' + t.tmName as [Team Name],
		COUNT(p.plID) as [Nominated]
		FROM tblScoringTitle s
		JOIN tblPlayer p
			ON p.plID = s.sc_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plID,plFirstName,plLastName,tmLocation,tmName
		ORDER BY [Nominated] DESC

	END
END

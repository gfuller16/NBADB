USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spTripleDoubleClub]    Script Date: 4/24/2017 4:17:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTripleDoubleClub]
AS
BEGIN

	;WITH cte_Averages AS
	(
	SELECT CONVERT(VARCHAR(30),p.plFirstName + ' ' + ISNULL(p.plLastName,'')) as [Player Name]
		  ,CONVERT(VARCHAR(17),t.tmLocation) AS [Location]
		  ,po.[poShortDesc] AS [Position]
		  ,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) as AvgPoints
		  ,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) as AvgAssists
		  ,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) as AvgRebounds
		  ,COUNT([gs_gmID]) as GamesPlayed
	  FROM [NBADB].[dbo].[tblGameStats] gs
	  JOIN tblPlayer p
		ON p.plID = gs.gs_plID
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	  JOIN tblPosition po
		ON po.poID = p.plPosition
	GROUP BY p.plFirstName,p.plLastName,t.tmLocation,po.[poShortDesc]
	)

	SELECT
	*
	FROM cte_Averages
	WHERE AvgPoints >= 10.0
	AND AvgAssists >= 10.0
	AND AvgRebounds >= 10.0
	ORDER BY AvgPoints + AvgAssists + AvgRebounds DESC
END

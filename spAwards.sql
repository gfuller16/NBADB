USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spAwards]    Script Date: 3/6/2018 8:21:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAwards]
@INT INT
AS
BEGIN
	
	DECLARE @rsMVP INT,@finalsMVP INT,
			@mvpPTS DECIMAL(4,1),
			@mvpAST DECIMAL(4,1),
			@mvpREB DECIMAL(4,1),
			@gmID INT, @Team1 INT, @Team2 INT

	SET NOCOUNT ON

	IF(@INT = 0) --Regular Season MVP
	BEGIN

	IF(SELECT MAX(psFRWins) FROM tblPlayoffSeeding) = 0
	BEGIN

		IF OBJECT_ID('tempdb.dbo.#RSMvp','U') IS NOT NULL
		DROP TABLE #RSMvp;

		CREATE TABLE #RSMvp(
		rsRank INT NOT NULL,
		rs_plID INT NOT NULL,
		rsScore DECIMAL(4,1) NOT NULL,
		rsType VARCHAR(4) NOT NULL
		)

		INSERT INTO #RSMvp
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsPoints]))) DESC) AS [Rank] 
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsPoints])))) as AvgPoints
			  ,'PTS'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsPoints]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsAssists]))) DESC, CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsRebounds]))) DESC

		INSERT INTO #RSMvp
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC) AS [Rank]
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
			  ,'AST'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, COUNT([gs_gmID]) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

		INSERT INTO #RSMvp
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC) AS [Rank]
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgRebounds
			  ,'REB'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC, COUNT([gs_gmID]) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC

		SET @rsMVP = (
		SELECT TOP 1
			p.plID
		FROM #RSMvp r
		JOIN tblPlayer p
			ON p.plID = r.rs_plID
		GROUP BY p.plID
		ORDER BY CONVERT(DECIMAL(5,2),SUM(CONVERT(DECIMAL(4,1),rsRank))/3)
		)

		SET @mvpPTS = (
			SELECT CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
			  FROM [NBADB].[dbo].[tblGameStats] gs
			  JOIN tblPlayer p
				ON p.plID = gs.gs_plID
			  JOIN tblTeam t
				ON t.tmID = p.plTeam
			 WHERE p.plID = @rsMVP
		)

		SET @mvpAST = (
			SELECT CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
			  FROM [NBADB].[dbo].[tblGameStats] gs
			  JOIN tblPlayer p
				ON p.plID = gs.gs_plID
			  JOIN tblTeam t
				ON t.tmID = p.plTeam
			WHERE p.plID = @rsMVP
		)

		SET @mvpREB = (
			SELECT CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgRebounds
			  FROM [NBADB].[dbo].[tblGameStats] gs
			  JOIN tblPlayer p
				ON p.plID = gs.gs_plID
			  JOIN tblTeam t
				ON t.tmID = p.plTeam
			WHERE p.plID = @rsMVP
		)

		INSERT INTO [dbo].[tblMVP](mID,m_plID,mPtsAvg,mAstAvg,mRebAvg,mYear,mRS_Finals)
		VALUES(
		(SELECT ISNULL(MAX(mID),0) FROM [dbo].[tblMVP]) + 1, 
		(@rsMVP),
		(@mvpPTS),
		(@mvpAST),
		(@mvpREB),
		((SELECT ISNULL(MAX(mYear),2016) + 1 FROM [dbo].[tblMVP])),
		(0))

		INSERT INTO [dbo].[tblNBAStandings](st_tmID,st_tmTotalWins,st_tmTotalLosses,stWinPercentage,stYear)
		SELECT
		tmID,
		tmTotalWins,
		tmTotalLosses,
		CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))),
		(SELECT ISNULL(MAX(stYear),2016) + 1 FROM tblNBAStandings)
		FROM [dbo].[tblTeam] t

		INSERT INTO [dbo].[tblScoringTitle]
		SELECT TOP 1
			ISNULL((SELECT MAX(scID) + 1 FROM tblScoringTitle),0)
			,p.plID
			,CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsPoints]))) as AvgPoints
			,ISNULL((SELECT MAX(stYear) FROM tblNBAStandings),2017)
		FROM [NBADB].[dbo].[tblGameStats] gs
		JOIN tblPlayer p
		  ON p.plID = gs.gs_plID
		JOIN tblTeam t
		  ON t.tmID = p.plTeam
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsPoints]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsAssists]))) DESC, CONVERT(DECIMAL(4,2),AVG(CONVERT(DECIMAL(4,2),[gsRebounds]))) DESC


	END
	END

	ELSE IF(@INT = 1) --Finals MVP
	BEGIN
		
		IF OBJECT_ID('tempdb.dbo.#FinalsMvp','U') IS NOT NULL
		DROP TABLE #FinalsMvp;

		CREATE TABLE #FinalsMvp(
		fsRank INT NOT NULL,
		fs_plID INT NOT NULL,
		fsScore DECIMAL(4,1) NOT NULL,
		fsType VARCHAR(4) NOT NULL
		)

		SET @gmID = (SELECT MAX(gmID) FROM dbo.tblGames)
		SET @Team1 = (SELECT gmTeam1 FROM dbo.tblGames WHERE gmID = @gmID)
		SET @Team2 = (SELECT gmTeam2 FROM dbo.tblGames WHERE gmID = @gmID)

		INSERT INTO #FinalsMvp
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC) AS [Rank] 
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
			  ,'PTS'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		  JOIN tblGames g
			ON g.gmID = gs.gs_gmID
		WHERE (g.gmID > 216) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2)
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

		INSERT INTO #FinalsMvp
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC) AS [Rank] 
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
			  ,'AST'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		  JOIN tblGames g
			ON g.gmID = gs.gs_gmID
		WHERE (g.gmID > 216) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2)
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

		INSERT INTO #FinalsMvp
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC) AS [Rank] 
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgPoints
			  ,'REB'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		  JOIN tblGames g
			ON g.gmID = gs.gs_gmID
		WHERE (g.gmID > 216) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2)
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

		SET @finalsMVP = (
		SELECT TOP 1
			p.plID
		FROM #FinalsMvp f
		JOIN tblPlayer p
			ON p.plID = f.fs_plID
		WHERE p.plTeam = (SELECT ps_tmID FROM dbo.tblPlayoffSeeding WHERE psFinalsWins = 4)
		GROUP BY p.plID
		ORDER BY CONVERT(DECIMAL(5,2),SUM(CONVERT(DECIMAL(4,1),fsRank))/3)
		)

		SET @mvpPTS = (
			SELECT CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
			  FROM [NBADB].[dbo].[tblGameStats] gs
			  JOIN tblPlayer p
				ON p.plID = gs.gs_plID
			  JOIN tblTeam t
				ON t.tmID = p.plTeam
			  JOIN tblGames g
				ON g.gmID = gs.gs_gmID
			 WHERE (g.gmID > 216) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2)
			 AND p.plID = @finalsMVP
		)

		SET @mvpAST = (
			SELECT CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgPoints
			  FROM [NBADB].[dbo].[tblGameStats] gs
			  JOIN tblPlayer p
				ON p.plID = gs.gs_plID
			  JOIN tblTeam t
				ON t.tmID = p.plTeam
			  JOIN tblGames g
				ON g.gmID = gs.gs_gmID
			 WHERE (g.gmID > 216) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2)
			 AND p.plID = @finalsMVP
		)

		SET @mvpREB = (
			SELECT CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgPoints
			  FROM [NBADB].[dbo].[tblGameStats] gs
			  JOIN tblPlayer p
				ON p.plID = gs.gs_plID
			  JOIN tblTeam t
				ON t.tmID = p.plTeam
			  JOIN tblGames g
				ON g.gmID = gs.gs_gmID
			 WHERE (g.gmID > 216) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2)
			 AND p.plID = @finalsMVP
		)

		INSERT INTO [dbo].[tblMVP](mID,m_plID,mPtsAvg,mAstAvg,mRebAvg,mYear,mRS_Finals)
		VALUES(
		(SELECT ISNULL(MAX(mID),0) FROM [dbo].[tblMVP]) + 1, 
		(@finalsMVP),
		(@mvpPTS),
		(@mvpAST),
		(@mvpREB),
		((SELECT ISNULL(MAX(mYear),2016) FROM [dbo].[tblMVP])),
		(1))

	END

	ELSE IF(@INT = 2) --Rookie of the Year
	BEGIN
		
		INSERT INTO tblROY
		SELECT TOP 1 *
		FROM(
		SELECT
		(SELECT ISNULL(MAX(rID),0) + 1 FROM tblROY) AS [rID],
		p.plID,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,g.gsPoints))) as AvgPoints,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,g.gsAssists))) as AvgAssists,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,g.gsRebounds))) as AvgRebounds,
		(SELECT MAX(chYear) FROM tblNBAChampion) AS [Year]
		FROM tblPlayer p
		JOIN tblGameStats g
			ON g.gs_plID = p.plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		WHERE p.plExperience = (SELECT MIN(plExperience) FROM tblPlayer)
		GROUP BY
		p.plID) AS r
		ORDER BY (AvgPoints + AvgAssists + AvgRebounds) DESC

	END

	ELSE IF(@INT = 3) --Most Improved Player / Triple Double Club
	BEGIN
		
		IF OBJECT_ID('tempdb.dbo.#CurrentYear','U') IS NOT NULL
		DROP TABLE #CurrentYear;

		IF OBJECT_ID('tempdb.dbo.#PriorYear','U') IS NOT NULL
		DROP TABLE #PriorYear;

		CREATE TABLE #CurrentYear(
		c_plID INT NOT NULL,
		cAvgPoints   DECIMAL(3,1) NOT NULL,
		cAvgAssists  DECIMAL(3,1) NOT NULL,
		cAvgRebounds DECIMAL(3,1) NOT NULL,
		cYear INT NOT NULL
		)

		CREATE TABLE #PriorYear(
		p_plID INT NOT NULL,
		pAvgPoints   DECIMAL(3,1) NOT NULL,
		pAvgAssists  DECIMAL(3,1) NOT NULL,
		pAvgRebounds DECIMAL(3,1) NOT NULL,
		pYear INT NOT NULL
		)

		INSERT INTO #CurrentYear
		SELECT
		ps.psh_plID,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,ps.pshPoints))) as cAvgPoints,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,ps.pshAssists))) as cAvgAssists,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,ps.pshRebounds))) as cAvgRebounds,
		pshYear as cYear
		FROM tblPlayerStatsHistory ps
		WHERE pshYear = (SELECT MAX(chYear) FROM tblNBAChampion) 
		GROUP BY ps.psh_plID, pshYear

		INSERT INTO #PriorYear
		SELECT
		ps.psh_plID,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,ps.pshPoints))) as pAvgPoints,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,ps.pshAssists))) as pAvgAssists,
		CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL,ps.pshRebounds))) as pAvgRebounds,
		ISNULL(ps.pshYear,2016) as pYear
		FROM tblPlayerStatsHistory ps
		WHERE pshYear = (SELECT ISNULL(MAX(chYear),2000) - 1 FROM tblNBAChampion)
		GROUP BY ps.psh_plID, ps.pshYear

		INSERT INTO tblMIP
		SELECT TOP 1
		(SELECT ISNULL(MAX(mipID),-1) + 1 FROM tblMIP) as [mipID],
		COALESCE(c_plID,p_plID) as [Player ID],
		(cAvgPoints - pAvgPoints) as [PtsImproved],
		(cAvgAssists - pAvgAssists) as [AstImproved],
		(cAvgRebounds - pAvgRebounds) as [RebImproved],
		cYear as [Year]
		FROM #CurrentYear
		LEFT JOIN #PriorYear
			ON p_plID = c_plID
		WHERE pAvgPoints IS NOT NULL
		ORDER BY ((cAvgPoints - pAvgPoints) + (cAvgAssists - pAvgAssists) + (cAvgRebounds - pAvgRebounds)) DESC

		INSERT INTO tblTripleDoubleClub
		SELECT
		c_plID,
		cAvgPoints,
		cAvgAssists,
		cAvgRebounds,
		cYear
		FROM #CurrentYear
		WHERE cAvgPoints >= 10.0
		AND cAvgAssists >= 10.0
		AND cAvgRebounds >= 10.0

	END

END

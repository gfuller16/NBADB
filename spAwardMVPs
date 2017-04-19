USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spAwardMVPs]    Script Date: 4/19/2017 12:43:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAwardMVPs]
AS
BEGIN
	
	DECLARE @rsMVP INT,@finalsMVP INT,
			@mvpPTS DECIMAL(4,1),
			@mvpAST DECIMAL(4,1),
			@mvpREB DECIMAL(4,1),
			@gmID INT, @Team1 INT, @Team2 INT

	SET NOCOUNT ON

	IF(SELECT ISNULL(MAX(psFRWins),0) FROM tblPlayoffSeeding) = 0
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
		SELECT RANK() OVER(ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC) AS [Rank] 
			  ,p.plID
			  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
			  ,'PTS'
		  FROM [NBADB].[dbo].[tblGameStats] gs
		  JOIN tblPlayer p
			ON p.plID = gs.gs_plID
		  JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

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
		((SELECT ISNULL(MAX(mYear),1999) + 1 FROM [dbo].[tblMVP])),
		(0))

		INSERT INTO [dbo].[tblNBAStandings](st_tmID,st_tmTotalWins,st_tmTotalLosses,stWinPercentage,stYear)
		SELECT
		tmID,
		tmTotalWins,
		tmTotalLosses,
		CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))),
		(SELECT ISNULL(MAX(stYear),1999) + 1 FROM tblNBAStandings)
		FROM [dbo].[tblTeam] t

	END

	ELSE IF(SELECT MAX(psFinalsWins) FROM tblPlayoffSeeding) = 4
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
		((SELECT ISNULL(MAX(mYear),1999) FROM [dbo].[tblMVP])),
		(1))

	END
END

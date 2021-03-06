USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spSeeMVPRace]    Script Date: 3/6/2018 8:27:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spSeeMVPRace]
@ID INT
AS
BEGIN

	DECLARE @rsMVP INT,@finalsMVP INT,
			@mvpPTS DECIMAL(4,1),
			@mvpAST DECIMAL(4,1),
			@mvpREB DECIMAL(4,1),
			@gmID INT, @Team1 INT, @Team2 INT

	SET NOCOUNT ON

		IF OBJECT_ID('tempdb.dbo.#RSMvp','U') IS NOT NULL
		DROP TABLE #RSMvp;

		CREATE TABLE #RSMvp(
		rsRank INT NOT NULL,
		rs_plID INT NOT NULL,
		rsScore DECIMAL(4,1) NOT NULL,
		rsType VARCHAR(4) NOT NULL
		)

IF (@ID = 1)
BEGIN

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
		
		
		SELECT
			p.plID,
			p.plFirstName + ' ' + ISNULL(p.plLastName,'') as [Player Name],
			t.tmLocation + ' ' + t.tmName as [Team Name],
			CONVERT(DECIMAL(5,2),SUM(CONVERT(DECIMAL(4,1),rsRank))/3) as Average
		FROM #RSMvp r
		JOIN tblPlayer p
			ON p.plID = r.rs_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plID,p.plFirstName,p.plLastName,t.tmLocation,t.tmName
		ORDER BY CONVERT(DECIMAL(5,2),SUM(CONVERT(DECIMAL(4,1),rsRank))/3)

END

ELSE IF (@ID = 2)
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
		  JOIN tblPlayoffSeeding ps
			ON ps.ps_tmID = t.tmID
		  JOIN tblGames g
			ON g.gmID = gs.gs_gmID
		WHERE (g.gmID > 720) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2) AND (ps.psCFWins = 4)
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
		  JOIN tblPlayoffSeeding ps
			ON ps.ps_tmID = t.tmID
		  JOIN tblGames g
			ON g.gmID = gs.gs_gmID
		WHERE (g.gmID > 720) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2) AND (ps.psCFWins = 4)
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
		  JOIN tblPlayoffSeeding ps
			ON ps.ps_tmID = t.tmID
		  JOIN tblGames g
			ON g.gmID = gs.gs_gmID
		WHERE (g.gmID > 720) AND (g.gmTeam1 = @Team1) AND (g.gmTeam2 = @Team2) AND (ps.psCFWins = 4)
		GROUP BY p.plFirstName,p.plLastName,t.tmLocation,p.plID
		ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, COUNT(gs.gs_gmID) DESC,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

		SELECT
			p.plID,
			p.plFirstName + ' ' + ISNULL(p.plLastName,'') as [Player Name],
			t.tmLocation + ' ' + t.tmName as [Team Name],
			CONVERT(DECIMAL(4,2),SUM(CONVERT(DECIMAL(4,1),f.fsRank))/4) as Average
		FROM #FinalsMvp f
		JOIN tblPlayer p
			ON p.plID = f.fs_plID
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		GROUP BY p.plID,p.plFirstName,p.plLastName,t.tmLocation,t.tmName
		ORDER BY CONVERT(DECIMAL(4,2),SUM(CONVERT(DECIMAL(4,1),f.fsRank))/3)
END

END

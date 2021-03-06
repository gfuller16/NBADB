USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spPlayoffs]    Script Date: 3/6/2018 8:24:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spPlayoffs]
AS
BEGIN

	DECLARE @gmID INT = (SELECT ISNULL(MAX(gmID),0) FROM dbo.tblGames) + 1

	DECLARE @Team1 INT,
	@Team2 INT,
	@Team1Points INT,
	@Team2Points INT,
	@Team1Assists INT,
	@Team2Assists INT,
	@Team1Rebounds INT,
	@Team2Rebounds INT,
	@PointDiff INT

	EXEC [dbo].[spAwards] 0 -- Regular Season MVP

	/****************************EC SEMIS, 1 V. 4 **************************
	******************************************************************************/
	SET @Team1 = (
	SELECT tmID
	FROM tblPlayoffSeeding ps
	JOIN tblTeam t
		ON t.tmID = ps.ps_tmID
	WHERE psSeed = 1
		  AND ps_cfID = 0
		  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
		)
	
	SET @Team2 = (
	SELECT tmID
	FROM tblPlayoffSeeding ps
	JOIN tblTeam t
		ON t.tmID = ps.ps_tmID
	WHERE psSeed = 4
		  AND ps_cfID = 0
		  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
		)
	
	SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))

	IF(SELECT MAX(psFRWins) FROM tblPlayoffSeeding WHERE (psSeed = 1 OR psSeed = 4) AND (ps_cfID = 0) AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN

		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/

	/****************************EC SEMIS, 2 V. 3 **************************
	******************************************************************************/

	ELSE IF(SELECT MAX(psFRWins) FROM tblPlayoffSeeding WHERE (psSeed = 2 OR psSeed = 3) AND (ps_cfID = 0) AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN

		SET @Team1 = (
		SELECT tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psSeed = 2
			  AND ps_cfID = 0
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			)
	
		SET @Team2 = (
		SELECT tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psSeed = 3
			  AND ps_cfID = 0
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			)

		SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))

		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/

	/****************************WC SEMIS, 1 V. 4 **************************
	******************************************************************************/

	ELSE IF(SELECT MAX(psFRWins) FROM tblPlayoffSeeding WHERE (psSeed = 1 OR psSeed = 4) AND (ps_cfID = 1) AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN

		SET @Team1 = (
		SELECT tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psSeed = 1
			  AND ps_cfID = 1
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			)
	
		SET @Team2 = (
		SELECT tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psSeed = 4
			  AND ps_cfID = 1
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			)

		SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))

		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/

	/****************************WC SEMIS, 2 V. 3 **************************
	******************************************************************************/

	ELSE IF(SELECT MAX(psFRWins) FROM tblPlayoffSeeding WHERE (psSeed = 2 OR psSeed = 3) AND (ps_cfID = 1) AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN 

		SET @Team1 = (
		SELECT tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psSeed = 2
			  AND ps_cfID = 1
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			)
	
		SET @Team2 = (
		SELECT tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psSeed = 3
			  AND ps_cfID = 1
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			)

		SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))
		
		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFRWins = psFRWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/

	/*********************************EC FINALS***********************************
	******************************************************************************/

	ELSE IF(SELECT MAX(psCFWins) FROM tblPlayoffSeeding WHERE (ps_cfID = 0) AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN 

		SET @Team1 = (
		SELECT TOP 1 tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psFRWins = 4
			  AND ps_cfID = 0
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
		ORDER BY psSeed
			)
	
		SET @Team2 = (
		SELECT TOP 1 tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psFRWins = 4
			  AND ps_cfID = 0
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			  AND tmID <> @Team1
		ORDER BY psSeed
			)

		SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))
		
		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psCFWins = psCFWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psCFWins = psCFWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psCFWins = psCFWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/

	/*********************************WC FINALS***********************************
	******************************************************************************/

	ELSE IF(SELECT MAX(psCFWins) FROM tblPlayoffSeeding WHERE (ps_cfID = 1) AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN 

		SET @Team1 = (
		SELECT TOP 1 tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psFRWins = 4
			  AND ps_cfID = 1
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
		ORDER BY psSeed
			)
	
		SET @Team2 = (
		SELECT TOP 1 tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psFRWins = 4
			  AND ps_cfID = 1
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			  AND tmID <> @Team1
		ORDER BY psSeed
			)

		SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))
		
		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psCFWins = psCFWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psCFWins = psCFWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psCFWins = psCFWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/

	/*********************************NBA FINALS***********************************
	******************************************************************************/

	ELSE IF(SELECT MAX(psFinalsWins) FROM tblPlayoffSeeding WHERE psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)) < 4
	BEGIN 

		SET @Team1 = (
		SELECT TOP 1 tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psCFWins = 4
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
		ORDER BY ps.psSeed, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,t.[tmTotalWins]))/(CONVERT(DECIMAL,t.[tmTotalWins])+CONVERT(DECIMAL,t.[tmTotalLosses]))) DESC
			)
	
		SET @Team2 = (
		SELECT TOP 1 tmID
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		WHERE psCFWins = 4
			  AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)
			  AND t.tmID <> @Team1
			)

		SET @PointDiff = (SELECT (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team1) - (SELECT tmTotalWins FROM tblTeam WHERE tmID = @Team2))
		
		EXEC [dbo].[spPlayPSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
							FROM dbo.tblGameStats gs
							JOIN dbo.tblPlayer p
								ON p.plID = gs.gs_plID
							JOIN dbo.tblTeam t
								ON t.tmID = p.plTeam
							WHERE gs_gmID = @gmID AND t.tmID = @Team1
							GROUP BY t.tmID) + (@PointDiff * 3)

		SET @Team2Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Assists = (SELECT SUM(CONVERT(INT,gsAssists))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		SET @Team1Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

		SET @Team2Rebounds = (SELECT SUM(CONVERT(INT,gsRebounds))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team2
								GROUP BY t.tmID)

		IF (@Team1Points > @Team2Points)
		BEGIN
		
			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFinalsWins = psFinalsWins + 1
			WHERE ps_tmID = @Team1
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) 
		BEGIN

			UPDATE [dbo].[tblPlayoffSeeding]
			SET psFinalsWins = psFinalsWins + 1
			WHERE ps_tmID = @Team2
			AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE
		BEGIN

			IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) > (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2))
			BEGIN

				UPDATE [dbo].[tblPlayoffSeeding]
				SET psFinalsWins = psFinalsWins + 1
				WHERE ps_tmID = @Team1
				AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) < (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2))
			BEGIN

				UPDATE [dbo].[tblPlayoffSeeding]
				SET psFinalsWins = psFinalsWins + 1
				WHERE ps_tmID = @Team2
				AND psYear = (SELECT MAX(psYear) FROM tblPlayoffSeeding)

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points + 1,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

		END

		EXEC [dbo].[spEndOfSeason]

	END

	/*****************************************************************************
	******************************************************************************/
END

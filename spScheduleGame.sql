USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleGame]    Script Date: 3/6/2018 8:26:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spScheduleGame]
AS

BEGIN

	SET NOCOUNT ON

	DECLARE @gmID INT = (SELECT ISNULL(MAX(gmID),0) FROM dbo.tblGames) + 1

	DECLARE @Team1 INT,
	@Div1 INT,
	@Conf1 INT,
	@Team2 INT,
	@Div2 INT,
	@Conf2 INT,
	@Team1Points INT,
	@Team2Points INT,
	@Team1Assists INT,
	@Team2Assists INT,
	@Team1Rebounds INT,
	@Team2Rebounds INT

	IF(SELECT MAX([tmDivWins] + [tmDivLosses]) FROM [dbo].[tblTeam]) = 0
	BEGIN
		
		EXEC [dbo].[spSetFantasySquads]

	END

	IF(SELECT MIN([tmDivWins] + [tmDivLosses]) FROM [dbo].[tblTeam]) < 12
	BEGIN
	/*
	Other Divisional Teams         (d)		 = 3
	Games vs. each Divisional Team (g)		 = 4
	Div Games for each Team  (d) * (g) = (x) = 12
	Total Teams	/ 2				  (tt)		 = 12
	Total Div Games (x) * (tt) = 144
	*/
		PRINT '----- DIVISIONAL GAME (144) gmID: ' + CAST(@gmID AS VARCHAR(3)) + ' -----' 
		SET @Team1 = (SELECT TOP 1 tmID
					  FROM [dbo].[tblTeam] t
					  WHERE (([tmDivWins] + [tmDivLosses]) < 12)
					  ORDER BY NEWID())

		SET @Div1  = (SELECT TOP 1 tmDivision
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team1)

		SET @Conf1 = (SELECT TOP 1 tmConference
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team1)

		BEGIN TRY

		SET @Team2 = (SELECT TOP 1 tmID
					  FROM [dbo].[tblTeam] ty
					  LEFT JOIN [dbo].[tblGames] g
						ON g.gmTeam1 = ty.tmID
					  LEFT JOIN [dbo].[tblGames] gg
						ON gg.gmTeam2 = ty.tmID
					  WHERE (tmID <> @Team1)
					  AND (tmDivision = @Div1)
					  AND (SELECT COUNT(*)
						FROM [NBADB].[dbo].[tblGames] g
						JOIN [NBADB].[dbo].[tblTeam] t
							ON t.tmID = g.gmTeam1
						JOIN [NBADB].[dbo].[tblTeam] tt
							ON tt.tmID = g.gmTeam2
						WHERE (t.tmID = @Team1 OR tt.tmID = @Team1)
						AND (t.tmID = ty.tmID OR tt.tmID = ty.tmID)) < 4
					  ORDER BY NEWID())

		END TRY

		BEGIN CATCH

			SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage;

			RAISERROR('ERROR', 16, 10)

		END CATCH

		SET @Div2  = (SELECT TOP 1 tmDivision
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team2)

		SET @Conf2 = (SELECT TOP 1 tmConference
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team2)

		EXEC [dbo].[spPlayRSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

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

		IF (@Team1Points > @Team2Points) --TEAM 1 WINS
		BEGIN
		
			UPDATE [dbo].[tblTeam]
			SET tmDivWins = tmDivWins + 1, tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
			WHERE tmID = @Team1

			UPDATE [dbo].[tblTeam]
			SET tmDivLosses = tmDivLosses + 1, tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
			WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) --TEAM 2 WINS
		BEGIN

			UPDATE [dbo].[tblTeam]
			SET tmDivWins = tmDivWins + 1, tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
			WHERE tmID = @Team2

			UPDATE [dbo].[tblTeam]
			SET tmDivLosses = tmDivLosses + 1, tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
			WHERE tmID = @Team1

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE	--TIE GAME
		BEGIN

			IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) > (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2)) --TEAM 1 BETTER DEFENSE
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmDivWins = tmDivWins + 1, tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team1

				UPDATE [dbo].[tblTeam]
				SET tmDivLosses = tmDivLosses + 1, tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) < (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2)) -- TEAM 2 BETTER DEFENSE
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmDivWins = tmDivWins + 1, tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team2

				UPDATE [dbo].[tblTeam]
				SET tmDivLosses = tmDivLosses + 1, tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team1

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points + 1,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE	--TIEBREAKER TO TEAM 1
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmDivWins = tmDivWins + 1, tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team1

				UPDATE [dbo].[tblTeam]
				SET tmDivLosses = tmDivLosses + 1, tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

		END
	END

	
	ELSE IF (SELECT MIN([tmConfWins] + [tmConfLosses]) FROM [dbo].[tblTeam]) < 36
	BEGIN
	/*
	Div Games per team     (d) = 12
	Div Opp			      (do) = 3
	Conf Opp		      (co) = 11
	Non-division/Conf Opp (op) = (co) - (do) = 8
	Games v. each (nd)	  (gm) = 3
	Non-Div/Conf Games	  (nd) = (op) * (gm) = 24
	Total Teams / 2		  (tt) = 12
	Total Conf Games/team (c) = (d) + (nd)  = 36
	Total Games before NC	  = (c) * (tt)  = 432
	*/
		PRINT '----- CONFERENCE GAME (432) gmID: ' + CAST(@gmID AS VARCHAR(3)) + ' -----'
		SET @Team1 = (SELECT TOP 1 tmID
					  FROM [dbo].[tblTeam] t
					  WHERE (([tmConfWins] + [tmConfLosses]) < 36)
					  ORDER BY NEWID())

		SET @Div1  = (SELECT TOP 1 tmDivision
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team1)

		SET @Conf1 = (SELECT TOP 1 tmConference
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team1)

		BEGIN TRY 

		SET @Team2 = (SELECT TOP 1 tmID
					  FROM [dbo].[tblTeam] ty
					  LEFT JOIN [dbo].[tblGames] g
						ON g.gmTeam1 = ty.tmID
					  LEFT JOIN [dbo].[tblGames] gg
						ON gg.gmTeam2 = ty.tmID
					  WHERE (tmID <> @Team1)
					  AND (tmDivision <> @Div1)
					  AND (tmConference = @Conf1)
					  AND (([tmConfWins] + [tmConfLosses]) < 36)
					  AND (SELECT COUNT(*)
						FROM [NBADB].[dbo].[tblGames] g
						JOIN [NBADB].[dbo].[tblTeam] t
							ON t.tmID = g.gmTeam1
						JOIN [NBADB].[dbo].[tblTeam] tt
							ON tt.tmID = g.gmTeam2
						WHERE (t.tmID = @Team1 OR tt.tmID = @Team1)
						AND (t.tmID = ty.tmID OR tt.tmID = ty.tmID)) < 3
					  ORDER BY NEWID())

		END TRY

		BEGIN CATCH
			
			SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

			RAISERROR('ERROR', 16, 10)

		END CATCH

		SET @Div2  = (SELECT TOP 1 tmDivision
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team2)

		SET @Conf2 = (SELECT TOP 1 tmConference
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team2)


		EXEC [dbo].[spPlayRSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

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

		IF (@Team1Points > @Team2Points) --TEAM 1 WINS
		BEGIN
		
			UPDATE [dbo].[tblTeam]
			SET tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
			WHERE tmID = @Team1

			UPDATE [dbo].[tblTeam]
			SET tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
			WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) --TEAM 2 WINS
		BEGIN

			UPDATE [dbo].[tblTeam]
			SET tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
			WHERE tmID = @Team2

			UPDATE [dbo].[tblTeam]
			SET tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
			WHERE tmID = @Team1

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE	--TIE GAME
		BEGIN
		
			IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) > (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2)) --TEAM 1 BETTER DEFENSE
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team1

				UPDATE [dbo].[tblTeam]
				SET tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) < (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2)) --TEAM 2 BETTER DEFENSE
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team2

				UPDATE [dbo].[tblTeam]
				SET tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team1

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points + 1,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE	--TIEBREAKER TO TEAM 1
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmConfWins = tmConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team1

				UPDATE [dbo].[tblTeam]
				SET tmConfLosses = tmConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

		END

	END

	
	ELSE IF (SELECT MIN([tmNonConfWins] + [tmNonConfLosses]) FROM [dbo].[tblTeam]) < 24 --(12 teams * 2 games each = 24)
	BEGIN
	/*
	Total Teams / 2				(tt) = 12
	Games v. Each NC			(nc) = 2
	Total NC Games/team			(gm) = (tt) * (nc) = 24
	Total Games after Conf 		(cf) = 432
	Total Games before Playoffs (tg) = (cf) + [(tt) * (nc)] = 720
	*/
		PRINT '----- Non-CONFERENCE GAME (720) gmID: ' + CAST(@gmID AS VARCHAR(3)) + ' -----'
		SET @Team1 = (SELECT TOP 1 tmID
					  FROM [dbo].[tblTeam] t
					  WHERE (([tmNonConfWins] + [tmNonConfLosses]) < 24)
					  ORDER BY NEWID())

		SET @Div1  = (SELECT TOP 1 tmDivision
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team1)

		SET @Conf1 = (SELECT TOP 1 tmConference
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team1)

		BEGIN TRY

		SET @Team2 = (SELECT TOP 1 tmID
					  FROM [dbo].[tblTeam] ty
					  LEFT JOIN [dbo].[tblGames] g
						ON g.gmTeam1 = ty.tmID
					  LEFT JOIN [dbo].[tblGames] gg
						ON gg.gmTeam2 = ty.tmID
					  WHERE (tmID <> @Team1)
					  AND (tmConference <> @Conf1)
					  AND (([tmNonConfWins] + [tmNonConfLosses]) < 24)
					  AND (SELECT COUNT(*)
						FROM [NBADB].[dbo].[tblGames] g
						JOIN [NBADB].[dbo].[tblTeam] t
							ON t.tmID = g.gmTeam1
						JOIN [NBADB].[dbo].[tblTeam] tt
							ON tt.tmID = g.gmTeam2
						WHERE (t.tmID = @Team1 OR tt.tmID = @Team1)
						AND (t.tmID = ty.tmID OR tt.tmID = ty.tmID)) < 2
					  ORDER BY NEWID())

		END TRY

		BEGIN CATCH
			
			SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

			RAISERROR('ERROR', 16, 10)

		END CATCH

		SET @Div2  = (SELECT TOP 1 tmDivision
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team2)

		SET @Conf2 = (SELECT TOP 1 tmConference
					  FROM [dbo].[tblTeam]
					  WHERE tmID = @Team2)


		EXEC [dbo].[spPlayRSGame] @Team1, @Team2, @gmID

		SET @Team1Points = (SELECT SUM(CONVERT(INT,gsPoints * 0.70)) + SUM(CONVERT(INT,gsAssists * 0.25)) + SUM(CONVERT(INT,gsRebounds * 0.70))
								FROM dbo.tblGameStats gs
								JOIN dbo.tblPlayer p
									ON p.plID = gs.gs_plID
								JOIN dbo.tblTeam t
									ON t.tmID = p.plTeam
								WHERE gs_gmID = @gmID AND t.tmID = @Team1
								GROUP BY t.tmID)

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

		IF (@Team1Points > @Team2Points) --TEAM 1 WINS
		BEGIN
		
			UPDATE [dbo].[tblTeam]
			SET tmTotalWins = tmTotalWins + 1, tmNonConfWins = tmNonConfWins + 1
			WHERE tmID = @Team1

			UPDATE [dbo].[tblTeam]
			SET tmTotalLosses = tmTotalLosses + 1, tmNonConfLosses = tmNonConfLosses + 1
			WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE IF (@Team2Points > @Team1Points) --TEAM 2 WINS
		BEGIN

			UPDATE [dbo].[tblTeam]
			SET tmTotalWins = tmTotalWins + 1, tmNonConfWins = tmNonConfWins + 1
			WHERE tmID = @Team2

			UPDATE [dbo].[tblTeam]
			SET tmTotalLosses = tmTotalLosses + 1, tmNonConfLosses = tmNonConfLosses + 1
			WHERE tmID = @Team1

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

		END

		ELSE	--TIE GAME
		BEGIN
		
			IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) > (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2)) --TEAM 1 BETTER DEFENSE
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmNonConfWins = tmNonConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team1

				UPDATE [dbo].[tblTeam]
				SET tmNonConfLosses = tmNonConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE IF((SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team1) < (SELECT SUM(plDefense) FROM tblPlayer WHERE plTeam = @Team2)) --TEAM 2 BETTER DEFENSE
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmNonConfWins = tmNonConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team2

				UPDATE [dbo].[tblTeam]
				SET tmNonConfLosses = tmNonConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team1

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points,
				gmPoints2 = @Team2Points + 1,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

			ELSE	--TIEBREAKER TO TEAM 1
			BEGIN

				UPDATE [dbo].[tblTeam]
				SET tmNonConfWins = tmNonConfWins + 1, tmTotalWins = tmTotalWins + 1
				WHERE tmID = @Team1

				UPDATE [dbo].[tblTeam]
				SET tmNonConfLosses = tmNonConfLosses + 1, tmTotalLosses = tmTotalLosses + 1
				WHERE tmID = @Team2

			UPDATE dbo.tblGames 
			SET gmPoints1 = @Team1Points + 1,
				gmPoints2 = @Team2Points,
				gmAssists1 = @Team1Assists,
				gmAssists2 = @Team2Assists,
				gmRebounds1 = @Team1Rebounds,
				gmRebounds2 = @Team2Rebounds
			WHERE gmID = @gmID

			END

		END
	END


	IF (SELECT MIN([tmTotalWins] + [tmTotalLosses]) FROM [dbo].[tblTeam]) >= 60 --(36 Conference + 24 Non-Conference = 60 Total)--
	BEGIN

		IF(SELECT ISNULL(MAX(psFRWins),0) FROM tblPlayoffSeeding) = 0
		BEGIN

			IF OBJECT_ID('tempdb.dbo.#Playoffs','U') IS NOT NULL
				DROP TABLE #Playoffs;

			CREATE TABLE #Playoffs(
			pSeed INT NOT NULL,
			p_tmID INT NOT NULL,
			p_cfID INT NOT NULL,
			pYear INT NOT NULL
			)

			BEGIN TRY
				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					   (SELECT ISNULL(MAX(psSeed),0) FROM tblPlayoffSeeding) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 0
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC
			
				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					   (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 0 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					   (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 0 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					   (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 0 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				PRINT ''
				PRINT 'EASTERN CONFERENCE PLAYOFF SEEDING SET SUCCESSFULLY
				'
			END TRY

			BEGIN CATCH
					SELECT   
					ERROR_NUMBER() AS ErrorNumber  
					,ERROR_MESSAGE() AS ErrorMessage;
			END CATCH

			BEGIN TRY
				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					  (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs WHERE p_cfID = 1) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 1 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					  (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs WHERE p_cfID = 1) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
						FROM tblTeam
				WHERE tmConference = 1 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1 
					  (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs WHERE p_cfID = 1) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 1 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				INSERT INTO #Playoffs(pSeed,p_tmID,p_cfID,pYear)
				SELECT TOP 1
					  (SELECT ISNULL(MAX(pSeed),0) FROM #Playoffs WHERE p_cfID = 1) + 1,
					   tmID,
					   tmConference,
					   (SELECT ISNULL(MAX(psYear),2016) FROM tblPlayoffSeeding) + 1
				FROM tblTeam
				WHERE tmConference = 1 AND (tmID NOT IN(SELECT p_tmID FROM #Playoffs))
				ORDER BY tmConference, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmConfWins]))/(CONVERT(DECIMAL,[tmConfWins])+CONVERT(DECIMAL,[tmConfLosses]))) DESC

				PRINT 'WESTERN CONFERENCE PLAYOFF SEEDING SET SUCCESSFULLY
				'
			END TRY

			BEGIN CATCH
					SELECT   
					ERROR_NUMBER() AS ErrorNumber  
				   ,ERROR_MESSAGE() AS ErrorMessage;
			END CATCH

			INSERT INTO [dbo].[tblPlayoffSeeding](psSeed,ps_tmID,ps_cfID,psYear)
			SELECT pSeed,p_tmID,p_cfID,pYear FROM #Playoffs

		END

		EXEC [dbo].[spPlayoffs]
			
	END


END

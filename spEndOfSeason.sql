USE [NBADB]
GO

/****** Object:  StoredProcedure [dbo].[spEndOfSeason]    Script Date: 3/6/2018 8:22:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spEndOfSeason]
AS
BEGIN

		IF(SELECT MAX(psFinalsWins) FROM tblPlayoffSeeding) = 4
			BEGIN

				INSERT INTO [dbo].[tblNBAChampion](chID,ch_tmID,chYear)
				VALUES((SELECT ISNULL(MAX(chID),0) FROM tblNBAChampion) + 1,(SELECT ps_tmID FROM tblPlayoffSeeding WHERE psFinalsWins = 4),(SELECT ISNULL(MAX(chYear),2016) + 1 FROM tblNBAChampion))

				EXEC [dbo].[spAwards] 1 --Finals MVP
				EXEC [dbo].[spAwards] 2 --ROY	
							
				DECLARE @ChampName VARCHAR(50) = (SELECT tmLocation + ' ' + tmName 	FROM tblPlayoffSeeding ps JOIN tblTeam t ON t.tmID = ps.ps_tmID WHERE psFinalsWins = 4)
				DECLARE @ChampYear VARCHAR(4) = CAST((SELECT MAX(chYear) FROM tblNBAChampion) AS VARCHAR(4))
				DECLARE @RegMVP VARCHAR(30) = (SELECT ISNULL(plFirstName + ' ' + plLastName,'NOT FOUND') FROM tblPlayer p JOIN tblMVP m ON m.m_plID = p.plID WHERE mYear = @ChampYear AND m.mRS_Finals = 0)
				DECLARE @FinalsMVP VARCHAR(30) = (SELECT ISNULL(plFirstName + ' ' + plLastName,'NOT FOUND') FROM tblPlayer p JOIN tblMVP m ON m.m_plID = p.plID WHERE mYear = @ChampYear AND m.mRS_Finals = 1)
				DECLARE @ScoringChamp VARCHAR(30) = (SELECT p.plFirstName + ' ' + p.plLastName FROM tblScoringTitle s JOIN tblPlayer p ON p.plID = s.sc_plID WHERE scYear = @ChampYear)

				UPDATE [NBADB].[dbo].[tblTeam]
				SET tmDivLosses = 0, tmDivWins = 0, tmConfLosses = 0, tmConfWins = 0, tmTotalWins = 0, tmTotalLosses = 0, tmNonConfLosses = 0, tmNonConfWins = 0

				IF(SELECT MAX(pshID) FROM tblPlayerStatsHistory) IS NULL				
					DBCC CHECKIDENT ('[tblPlayerStatsHistory]',RESEED,0);

				INSERT INTO tblPlayerStatsHistory(psh_gmID,psh_plID,pshPoints,pshAssists,pshRebounds,pshYear)
				SELECT
				gs_gmID,
				gs_plID,
				gsPoints,
				gsAssists,
				gsRebounds,
				@ChampYear
				FROM tblGameStats

				EXEC [dbo].[spAwards] 3 --MIP

				EXEC [dbo].[spSetFantasyChamp] @ChampYear

				DELETE FROM tblGameStats
				DELETE FROM tblGames
				DELETE FROM tblPlayoffSeeding

				DECLARE @FantasyChamp VARCHAR(30) = (SELECT TOP 1 u.fuFirstName + ' ' + u.fuLastName FROM tblFantasyChampion f JOIN tblFantasyUser u ON u.fuID = f.fcOwner WHERE fcYear = @ChampYear)
				DECLARE @ROY VARCHAR(30) = (SELECT ISNULL(p.plFirstName + ' ' + p.plLastName,'NOT FOUND') FROM tblROY r JOIN tblPlayer p ON p.plID = r.r_plID WHERE r.rYear = @ChampYear)
				DECLARE @MIP VARCHAR(30) = (SELECT ISNULL(p.plFirstName + ' ' + p.plLastName,'NOT FOUND') FROM tblMIP m JOIN tblPlayer p ON p.plID = m.mip_plID WHERE m.mipYear = @ChampYear)

				PRINT ''
				PRINT 'THE ' + @ChampName + ' ARE YOUR ' + @ChampYear + ' NBA CHAMPIONS!!!
				'
				PRINT 'NBA FINALS MVP: ' + @FinalsMVP
				PRINT ''
				PRINT 'REGULAR SEASON MVP: ' + @RegMVP
				PRINT ''
				PRINT 'SCORING TITLE CHAMP: ' + @ScoringChamp
				PRINT ''
				PRINT 'ROOKIE OF THE YEAR: ' + @ROY
				PRINT ''
				PRINT 'MOST IMPROVED PLAYER: ' + @MIP
				PRINT ''
				PRINT 'FANTASY LEAGUE CHAMPION: ' + @FantasyChamp
				PRINT ''

				IF EXISTS(SELECT TOP 1 tdPlayerID_plID FROM tblTripleDoubleClub WHERE tdYear = @ChampYear)
				BEGIN
					
					DECLARE @TDPlayerID INT, @TDPlayerName VARCHAR(30)

					DECLARE #PlayerCursor CURSOR
					FOR

						SELECT tdPlayerID_plID 
						FROM tblTripleDoubleClub 
						WHERE tdYear = @ChampYear

					OPEN #PlayerCursor
					FETCH NEXT FROM #PlayerCursor INTO @TDPlayerID

					WHILE (@@FETCH_STATUS = 0)
					BEGIN
						
						SET @TDPlayerName = (SELECT plFirstName + ' ' + plLastName FROM tblPlayer WHERE plID = @TDPlayerID)

						PRINT '***TRIPLE DOUBLE CLUB INDUCTEE: ' + @TDPlayerName
						PRINT ''

						FETCH NEXT FROM #PlayerCursor INTO @TDPlayerID
					END

					CLOSE #PlayerCursor
					DEALLOCATE #PlayerCursor

				END

				EXEC [spUpdatePlayers]

				--EXEC [spDraftRookies] @ChampYear

				IF EXISTS(SELECT rkID FROM tblRookies WHERE rkYear = (@ChampYear + 1))
				BEGIN
				    
				    DECLARE @RookieFN VARCHAR(20), @RookieLN VARCHAR(30),@TeamName VARCHAR(30)

				    PRINT ''
				    PRINT 'PLEASE WELCOME THE ' + CONVERT(VARCHAR(4),(@ChampYear + 1)) + ' ROOKIE CLASS!'
				    PRINT '------------------------------------------'

				    DECLARE Rookie CURSOR FOR
					   
					   SELECT 
					   p.plFirstName, p.plLastName,(t.tmLocation + ' ' + t.tmName)
					   FROM tblPlayer p
					   JOIN tblTeam t
						  ON t.tmID = p.plTeam
					   WHERE p.plRookieYear = (@ChampYear + 1)

				    OPEN Rookie
				    FETCH NEXT FROM Rookie INTO @RookieFN,@RookieLN,@TeamName

				    WHILE(@@FETCH_STATUS = 0)
				    BEGIN					  

					   PRINT @RookieFN + ' ' + @RookieLN + ' of the ' + @TeamName
					   PRINT ''

					   FETCH NEXT FROM Rookie INTO @RookieFN,@RookieLN,@TeamName

				    END

				    CLOSE Rookie
				    DEALLOCATE Rookie

				END

			END

		ELSE
		BEGIN
			
			SELECT psSeed,
			   CONVERT(VARCHAR(40),CONVERT(VARCHAR(30),tmLocation + ' ' + tmName) + ' (' + CONVERT(VARCHAR(3),t.tmTotalWins) + '-' + CONVERT(VARCHAR(3),t.tmTotalLosses) + ') ') AS Name,
			   c.cfName,
			   d.dvName,
			   ps.psFRWins,
			   ps.psCFWins,
			   ps.psFinalsWins
		FROM tblPlayoffSeeding ps
		JOIN tblTeam t
			ON t.tmID = ps.ps_tmID
		JOIN tblConference c
			ON c.cfID = t.tmConference
		JOIN tblDivision d
			ON d.dvID = t.tmDivision

		END
END
GO

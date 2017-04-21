USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spEndOfSeason]    Script Date: 4/21/2017 2:29:49 PM ******/
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
				VALUES((SELECT ISNULL(MAX(chID),0) FROM tblNBAChampion) + 1,(SELECT ps_tmID FROM tblPlayoffSeeding WHERE psFinalsWins = 4),(SELECT ISNULL(MAX(chYear),1999) + 1 FROM tblNBAChampion))

				EXEC [dbo].[spAwardMVPs]

				DECLARE @ChampName VARCHAR(50) = (SELECT tmLocation + ' ' + tmName 	FROM tblPlayoffSeeding ps JOIN tblTeam t ON t.tmID = ps.ps_tmID WHERE psFinalsWins = 4)
				DECLARE @ChampYear VARCHAR(4) = CAST((SELECT MAX(chYear) FROM tblNBAChampion) AS VARCHAR(4))
				DECLARE @RegMVP VARCHAR(30) = (SELECT plFirstName + ' ' + plLastName FROM tblPlayer p JOIN tblMVP m ON m.m_plID = p.plID WHERE mYear = (SELECT MAX(chYear) FROM tblNBAChampion) AND m.mRS_Finals = 0)
				DECLARE @FinalsMVP VARCHAR(30) = (SELECT plFirstName + ' ' + plLastName FROM tblPlayer p JOIN tblMVP m ON m.m_plID = p.plID WHERE mYear = (SELECT MAX(chYear) FROM tblNBAChampion) AND m.mRS_Finals = 1)

				UPDATE [NBADB].[dbo].[tblTeam]
				SET tmDivLosses = 0, tmDivWins = 0, tmConfLosses = 0, tmConfWins = 0, tmTotalWins = 0, tmTotalLosses = 0, tmNonConfLosses = 0, tmNonConfWins = 0
				DELETE FROM tblGameStats
				DELETE FROM tblGames
				DELETE FROM tblPlayoffSeeding

				PRINT ''
				PRINT 'THE ' + @ChampName + ' ARE YOUR ' + @ChampYear + ' NBA CHAMPIONS!!!
				'

				PRINT 'REGULAR SEASON MVP: ' + @RegMVP
				PRINT ''
				PRINT 'NBA FINALS MVP: ' + @FinalsMVP

				UPDATE NBADB.dbo.tblPlayer
				SET 
				plIQ =		   CASE WHEN (plExperience < 15) THEN
									CASE WHEN (plDetermination - plExperience > 97)				 AND (plIQ < 99) THEN plIQ + .90
										 WHEN (plDetermination - plExperience BETWEEN 95 AND 97) AND (plIQ < 99) THEN plIQ + .75
										 WHEN (plDetermination - plExperience BETWEEN 92 AND 94) AND (plIQ < 99) THEN plIQ + .60
										 WHEN (plDetermination - plExperience BETWEEN 89 AND 91) AND (plIQ < 99) THEN plIQ + .45
										 WHEN (plDetermination - plExperience BETWEEN 86 AND 88) AND (plIQ < 99) THEN plIQ + .30
										 WHEN (plDetermination - plExperience BETWEEN 83 AND 85) AND (plIQ < 99) THEN plIQ + .20
										 WHEN (plDetermination - plExperience BETWEEN 80 AND 82) AND (plIQ < 99) THEN plIQ + .15
										 WHEN (plDetermination - plExperience BETWEEN 77 AND 79) AND (plIQ < 99) THEN plIQ + .10
										 WHEN (plDetermination - plExperience BETWEEN 74 AND 76) AND (plIQ < 99) THEN plIQ + .09
										 WHEN (plDetermination - plExperience BETWEEN 71 AND 73) AND (plIQ < 99) THEN plIQ + .08
										 WHEN (plDetermination - plExperience BETWEEN 68 AND 70) AND (plIQ < 99) THEN plIQ + .07
										 WHEN (plDetermination - plExperience BETWEEN 65 AND 67) AND (plIQ < 99) THEN plIQ + .06
										 WHEN (plDetermination - plExperience BETWEEN 62 AND 64) AND (plIQ < 99) THEN plIQ + .05
										 WHEN (plDetermination - plExperience BETWEEN 59 AND 61) AND (plIQ < 99) THEN plIQ + .04
										 WHEN (plDetermination - plExperience BETWEEN 56 AND 58) AND (plIQ < 99) THEN plIQ + .03
										 WHEN (plDetermination - plExperience BETWEEN 50 AND 55) AND (plIQ < 99) THEN plIQ + .02
										 ELSE plIQ END
									WHEN (plExperience >= 15) THEN plIQ - .50 END,
										
				plDefense =	   CASE WHEN (plExperience < 15) THEN
									CASE WHEN (plDetermination - plExperience > 97)				 AND (plDefense < 99) THEN plDefense + .90
										 WHEN (plDetermination - plExperience BETWEEN 95 AND 97) AND (plDefense < 99) THEN plDefense + .75
										 WHEN (plDetermination - plExperience BETWEEN 92 AND 94) AND (plDefense < 99) THEN plDefense + .60
										 WHEN (plDetermination - plExperience BETWEEN 89 AND 91) AND (plDefense < 99) THEN plDefense + .45
										 WHEN (plDetermination - plExperience BETWEEN 86 AND 88) AND (plDefense < 99) THEN plDefense + .30
										 WHEN (plDetermination - plExperience BETWEEN 83 AND 85) AND (plDefense < 99) THEN plDefense + .20
										 WHEN (plDetermination - plExperience BETWEEN 80 AND 82) AND (plDefense < 99) THEN plDefense + .15
										 WHEN (plDetermination - plExperience BETWEEN 77 AND 79) AND (plDefense < 99) THEN plDefense + .10
										 WHEN (plDetermination - plExperience BETWEEN 74 AND 76) AND (plDefense < 99) THEN plDefense + .09
										 WHEN (plDetermination - plExperience BETWEEN 71 AND 73) AND (plDefense < 99) THEN plDefense + .08
										 WHEN (plDetermination - plExperience BETWEEN 68 AND 70) AND (plDefense < 99) THEN plDefense + .07
										 WHEN (plDetermination - plExperience BETWEEN 65 AND 67) AND (plDefense < 99) THEN plDefense + .06
										 WHEN (plDetermination - plExperience BETWEEN 62 AND 64) AND (plDefense < 99) THEN plDefense + .05
										 WHEN (plDetermination - plExperience BETWEEN 59 AND 61) AND (plDefense < 99) THEN plDefense + .04
										 WHEN (plDetermination - plExperience BETWEEN 56 AND 58) AND (plDefense < 99) THEN plDefense + .03
										 WHEN (plDetermination - plExperience BETWEEN 50 AND 55) AND (plDefense < 99) THEN plDefense + .02
										 ELSE plDefense END
									WHEN (plExperience >= 15) THEN plDefense - .50 END,

				plOutsideShot = CASE WHEN (plExperience < 15) THEN
									CASE WHEN (plDetermination - plExperience > 97)				 AND (plOutsideShot < 99) THEN plOutsideShot + .90
										 WHEN (plDetermination - plExperience BETWEEN 95 AND 97) AND (plOutsideShot < 99) THEN plOutsideShot + .75
										 WHEN (plDetermination - plExperience BETWEEN 92 AND 94) AND (plOutsideShot < 99) THEN plOutsideShot + .60
										 WHEN (plDetermination - plExperience BETWEEN 89 AND 91) AND (plOutsideShot < 99) THEN plOutsideShot + .45
										 WHEN (plDetermination - plExperience BETWEEN 86 AND 88) AND (plOutsideShot < 99) THEN plOutsideShot + .30
										 WHEN (plDetermination - plExperience BETWEEN 83 AND 85) AND (plOutsideShot < 99) THEN plOutsideShot + .20
										 WHEN (plDetermination - plExperience BETWEEN 80 AND 82) AND (plOutsideShot < 99) THEN plOutsideShot + .15
										 WHEN (plDetermination - plExperience BETWEEN 77 AND 79) AND (plOutsideShot < 99) THEN plOutsideShot + .10
										 WHEN (plDetermination - plExperience BETWEEN 74 AND 76) AND (plOutsideShot < 99) THEN plOutsideShot + .09
										 WHEN (plDetermination - plExperience BETWEEN 71 AND 73) AND (plOutsideShot < 99) THEN plOutsideShot + .08
										 WHEN (plDetermination - plExperience BETWEEN 68 AND 70) AND (plOutsideShot < 99) THEN plOutsideShot + .07
										 WHEN (plDetermination - plExperience BETWEEN 65 AND 67) AND (plOutsideShot < 99) THEN plOutsideShot + .06
										 WHEN (plDetermination - plExperience BETWEEN 62 AND 64) AND (plOutsideShot < 99) THEN plOutsideShot + .05
										 WHEN (plDetermination - plExperience BETWEEN 59 AND 61) AND (plOutsideShot < 99) THEN plOutsideShot + .04
										 WHEN (plDetermination - plExperience BETWEEN 56 AND 58) AND (plOutsideShot < 99) THEN plOutsideShot + .03
										 WHEN (plDetermination - plExperience BETWEEN 50 AND 55) AND (plOutsideShot < 99) THEN plOutsideShot + .02
										 ELSE plOutsideShot END
									WHEN (plExperience >= 15) THEN plOutsideShot - .50 END,

				plInsideShot =  CASE WHEN (plExperience < 15) THEN
									CASE WHEN (plDetermination - plExperience > 97)				 AND (plInsideShot < 99) THEN plInsideShot + .90
										 WHEN (plDetermination - plExperience BETWEEN 95 AND 97) AND (plInsideShot < 99) THEN plInsideShot + .75
										 WHEN (plDetermination - plExperience BETWEEN 92 AND 94) AND (plInsideShot < 99) THEN plInsideShot + .60
										 WHEN (plDetermination - plExperience BETWEEN 89 AND 91) AND (plInsideShot < 99) THEN plInsideShot + .45
										 WHEN (plDetermination - plExperience BETWEEN 86 AND 88) AND (plInsideShot < 99) THEN plInsideShot + .30
										 WHEN (plDetermination - plExperience BETWEEN 83 AND 85) AND (plInsideShot < 99) THEN plInsideShot + .20
										 WHEN (plDetermination - plExperience BETWEEN 80 AND 82) AND (plInsideShot < 99) THEN plInsideShot + .15
										 WHEN (plDetermination - plExperience BETWEEN 77 AND 79) AND (plInsideShot < 99) THEN plInsideShot + .10
										 WHEN (plDetermination - plExperience BETWEEN 74 AND 76) AND (plInsideShot < 99) THEN plInsideShot + .09
										 WHEN (plDetermination - plExperience BETWEEN 71 AND 73) AND (plInsideShot < 99) THEN plInsideShot + .08
										 WHEN (plDetermination - plExperience BETWEEN 68 AND 70) AND (plInsideShot < 99) THEN plInsideShot + .07
										 WHEN (plDetermination - plExperience BETWEEN 65 AND 67) AND (plInsideShot < 99) THEN plInsideShot + .06
										 WHEN (plDetermination - plExperience BETWEEN 62 AND 64) AND (plInsideShot < 99) THEN plInsideShot + .05
										 WHEN (plDetermination - plExperience BETWEEN 59 AND 61) AND (plInsideShot < 99) THEN plInsideShot + .04
										 WHEN (plDetermination - plExperience BETWEEN 56 AND 58) AND (plInsideShot < 99) THEN plInsideShot + .03
										 WHEN (plDetermination - plExperience BETWEEN 50 AND 55) AND (plInsideShot < 99) THEN plInsideShot + .02
										 ELSE plInsideShot END
									WHEN (plExperience >= 15) THEN plInsideShot - .50 END

				UPDATE tblPlayer
				SET plExperience = plExperience + 1
				WHERE plExperience < 20

			END

		ELSE
		BEGIN
			
			SELECT psSeed,
			   CONVERT(VARCHAR(30),tmLocation + ' ' + tmName) AS Name,
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

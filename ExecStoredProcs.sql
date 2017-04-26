USE NBADB
GO

EXEC [spWinners] 1
EXEC [spWinners] 2

EXEC [spSeeMVPRace] 1
EXEC [spSeeMVPRace] 2

EXEC [spTopPlayerStats] '1'
EXEC [spTopPlayerStats] '009'

EXEC [dbo].[spTopTeamStats] 1
EXEC [dbo].[spTopTeamStats] 2
EXEC [dbo].[spTopTeamStats] 3
EXEC [dbo].[spTripleDoubleClub]

EXEC [spPlayerTeamView] 1
EXEC [spPlayerTeamView] 2
EXEC [spPlayerTeamView] 3
--EXEC [spPlayerTeamView] 5
--EXEC [spPlayerTeamView] 6
--EXEC [spPlayerTeamView] 666
--5: Delete Player, insert from PlayerBackUp
--6: Delete PlayerBackUp, insert from Player
--666: Start Over
--UPDATE tblPlayer
--SET plIQ = plIQ - 5
--WHERE plID NOT IN(0,1,5,6,9,10,11,15,18,20,21,22,30,35,40,45,50,51,55,56,57,60,65,69,71,82,83,85,88)
EXEC [spBestTeamHistory] 1
EXEC [spBestTeamHistory] 2
--(1 - 2)--

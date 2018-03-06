USE NBADB
GO

/*
EXEC [dbo].[spRegularSeason]
EXEC [dbo].[spScheduleGame]

EXEC [dbo].[spStandings]
*/

EXEC [spWinners]
EXEC [spSeeAwards] 1 --mvp
EXEC [spSeeAwards] 2 --roy
EXEC [spSeeAwards] 3 --mip
EXEC [spSeeAwards] 4 --scoring title

EXEC [spSeeMVPRace] 1
EXEC [spSeeFantasy] 1 --Team totals
EXEC [spSeeFantasy] 2 --Player totals
EXEC [spSeeFantasy] 3 --Champions

EXEC [spTopPlayerStats] '1'
EXEC [spTopPlayerStats] '005'
EXEC [spPlayerRankings] 5

EXEC [dbo].[spTopTeamStats] 1 --4,12,8,
EXEC [dbo].[spTopTeamStats] 2 --3,19,6
EXEC [dbo].[spTopTeamStats] 3 --13,20,21
EXEC [dbo].[spTripleDoubleClub]

SELECT * FROM tblPlayer WHERE plID = 50
EXEC [spPlayerTeamView] 1 --overall
EXEC [spPlayerTeamView] 2 --By Team
EXEC [spPlayerTeamView] 3 --By Player skill
EXEC [spPlayerTeamView] 4 --By Player skill, see overall
EXEC [spPlayerTeamView] 7 --Average Exp
--EXEC [spPlayerTeamView] 4
--EXEC [spPlayerTeamView] 6
--EXEC [spPlayerTeamView] 666
--5: Delete Player, insert from PlayerBackUp
--6: Delete PlayerBackUp, insert from Player
--UPDATE tblPlayer
--SET plIQ = plIQ - 5
--WHERE plID NOT IN(0,1,5,6,9,10,11,15,18,20,21,22,30,35,40,45,50,51,55,56,57,60,65,69,71,82,83,85,88)
EXEC [spBestTeamHistory] 1
EXEC [spBestTeamHistory] 2
EXEC [spTeamRankings]
--(1 - 2)--
--[spReset]

--update tblPlayer
--set plTeam = 0

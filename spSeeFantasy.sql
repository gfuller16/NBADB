USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spSeeFantasy]    Script Date: 3/6/2018 8:27:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSeeFantasy]
@ID INT
AS
BEGIN
	
	IF(@ID = 1)
	BEGIN
		
		SELECT TOP 10
		ftTeamName,
		SUM(ftScore) as [Score],
		ftYear
		FROM tblFantasyTeam f
		JOIN tblPlayer p
			ON p.plID = f.ftPlayer_plID
		GROUP BY
		ftTeamName,ftYear
		ORDER BY [ftYear] DESC,[Score] DESC

	END

	IF(@ID = 2)
	BEGIN
		
		SELECT TOP 50
		ftTeamName,
		plfirstName + ' ' + plLastName as [PlayerName],
		t.tmLocation as [Team],
		ftScore as [PlayerScore],
		(SELECT
		SUM(ftScore) as [Score]
		FROM tblFantasyTeam f2
		JOIN tblPlayer p2
			ON p2.plID = f2.ftPlayer_plID
		WHERE f2.ftTeamName = f1.ftTeamName
		GROUP BY
		f2.ftTeamName) as [TeamScore],
		ftYear
		FROM tblFantasyTeam f1
		JOIN tblPlayer p1
			ON p1.plID = f1.ftPlayer_plID
		JOIN tblTeam t
			ON t.tmID = p1.plTeam
		GROUP BY ftTeamName,t.tmLocation,
		plfirstName,plLastName,ftScore,ftYear
		ORDER BY [ftYear] DESC, [TeamScore] DESC, [ftTeamName] DESC, [PlayerScore] DESC

	END

	IF(@ID = 3)
	BEGIN
		
		SELECT DISTINCT
		f.fcTeamName,
		f.fcTeamScore,
		f.fcYear
		FROM tblFantasyChampion f
		JOIN tblPlayer p
			ON p.plID = f.fcPlayer
		JOIN tblFantasyUser u
			ON u.fuID = f.fcOwner
		JOIN tblTeam t
			ON t.tmID = p.plTeam
		ORDER BY fcYear DESC

	END

END

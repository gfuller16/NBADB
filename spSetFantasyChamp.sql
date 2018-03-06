USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spSetFantasyChamp]    Script Date: 3/6/2018 8:27:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSetFantasyChamp] --2000
@ChampYear INT
AS
BEGIN
	
	DECLARE
	@Owner INT,
	@TeamName VARCHAR(50),
	@PlayerID INT,
	@PlayerScore INT,
	@TeamScore INT

	DECLARE FantasyChamp CURSOR
	FOR

		SELECT TOP 5
			ftOwner_fuID,
			ftTeamName,
			ftPlayer_plID,
			ftScore as [PlayerScore],
			(SELECT
			SUM(ftScore) as [Score]
			FROM tblFantasyTeam f2
			JOIN tblPlayer p2
			ON p2.plID = f2.ftPlayer_plID
			WHERE f2.ftTeamName = f1.ftTeamName
			GROUP BY
			f2.ftTeamName) as [TeamScore]
		FROM tblFantasyTeam f1
		JOIN tblPlayer p1
			ON p1.plID = f1.ftPlayer_plID
		WHERE ftYear = @ChampYear
		GROUP BY ftOwner_fuID,ftTeamName,
			ftPlayer_plID,ftScore
		ORDER BY 
			[TeamScore] DESC, 
			[PlayerScore] DESC

	OPEN FantasyChamp
	FETCH NEXT FROM FantasyChamp INTO @Owner,@TeamName,@PlayerID,@PlayerScore,@TeamScore

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		
		INSERT INTO tblFantasyChampion
		SELECT
			ISNULL((SELECT MAX(fcID) + 1 FROM tblFantasyChampion),0),
			@Owner,
			@TeamName,
			@PlayerID,
			@PlayerScore,
			@TeamScore,
			@ChampYear

		FETCH NEXT FROM FantasyChamp INTO @Owner,@TeamName,@PlayerID,@PlayerScore,@TeamScore

	END

	CLOSE FantasyChamp
	DEALLOCATE FantasyChamp

END

USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spPlayRSGame]    Script Date: 3/6/2018 8:25:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spPlayRSGame] --2,3
@Team1 INT,
@Team2 INT,
@gmID INT
AS

BEGIN

	SET NOCOUNT ON

	DECLARE @TeamName1 VARCHAR(50) = 
	(SELECT tmLocation + ' ' + tmName
	FROM dbo.tblTeam
	WHERE tmID = @Team1)

	DECLARE @Team1Record VARCHAR(8) = 
	(SELECT (CONVERT(VARCHAR(2),tmTotalWins) + ' ' + '-' + ' ' + CONVERT(VARCHAR(2),tmTotalLosses))
	FROM dbo.tblTeam
	WHERE tmID = @Team1)

	DECLARE @TeamName2 VARCHAR(50) = 
	(SELECT tmLocation + ' ' + tmName
	FROM dbo.tblTeam
	WHERE tmID = @Team2)

	DECLARE @Team2Record VARCHAR(8) = 
	(SELECT (CONVERT(VARCHAR(2),tmTotalWins) + ' ' + '-' + ' ' + CONVERT(VARCHAR(2),tmTotalLosses))
	FROM dbo.tblTeam
	WHERE tmID = @Team2)

	PRINT CAST(@Team1 as VARCHAR(2)) + ' ' + @TeamName1 + ' ' + '(' + @Team1Record + ')'
	PRINT 'Vs.'
	PRINT CAST(@Team2 as VARCHAR(2)) + ' ' + @TeamName2 + ' ' + '(' + @Team2Record + ')'

	DECLARE @Contest INT = (SELECT COUNT(*)
				FROM [NBADB].[dbo].[tblGames] g
				JOIN [NBADB].[dbo].[tblTeam] t
					ON t.tmID = g.gmTeam1
				JOIN [NBADB].[dbo].[tblTeam] tt
					ON tt.tmID = g.gmTeam2
				WHERE (t.tmID = @Team1 OR tt.tmID = @Team1)
				AND (t.tmID = @Team2 OR tt.tmID = @Team2))

	INSERT INTO dbo.tblGames(gmID,gmTeam1,gmTeam2,gmPoints1,gmPoints2,gmContest)
	VALUES(@gmID,@Team1,@Team2,0,0,@Contest)

	DECLARE @P11pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team1 AND plRetired = 0)
	EXEC spPlayerStats @P11pID,@gmID

	DECLARE @P12pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team1 AND plID <> @P11pID AND plRetired = 0)
	EXEC spPlayerStats @P12pID,@gmID

	DECLARE @P13pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team1 AND plID <> @P11pID
																					  AND plID <> @P12pID AND plRetired = 0)
	EXEC spPlayerStats @P13pID,@gmID

	DECLARE @P14pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team1 AND plID <> @P11pID
																					  AND plID <> @P12pID
																					  AND plID <> @P13pID AND plRetired = 0)
	EXEC spPlayerStats @P14pID,@gmID

	DECLARE @P15pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team1 AND plID <> @P11pID
																					  AND plID <> @P12pID
																					  AND plID <> @P13pID
																					  AND plID <> @P14pID AND plRetired = 0)
	EXEC spPlayerStats @P15pID,@gmID

	DECLARE @P21pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team2 AND plRetired = 0)
	EXEC spPlayerStats @P21pID,@gmID

	DECLARE @P22pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team2 AND plID <> @P21pID AND plRetired = 0)
	EXEC spPlayerStats @P22pID,@gmID

	DECLARE @P23pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team2 AND plID <> @P21pID
																					  AND plID <> @P22pID AND plRetired = 0)
	EXEC spPlayerStats @P23pID,@gmID

	DECLARE @P24pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team2 AND plID <> @P21pID
																					  AND plID <> @P22pID
																					  AND plID <> @P23pID AND plRetired = 0)
	EXEC spPlayerStats @P24pID,@gmID

	DECLARE @P25pID INT = (SELECT TOP 1 plID FROM dbo.tblPlayer WHERE plTeam = @Team2 AND plID <> @P21pID
																					  AND plID <> @P22pID
																					  AND plID <> @P23pID
																					  AND plID <> @P24pID AND plRetired = 0)
	EXEC spPlayerStats @P25pID,@gmID

END

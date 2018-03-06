USE [NBADB]
GO

/****** Object:  StoredProcedure [dbo].[spPlayerTeamView]    Script Date: 3/6/2018 8:24:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPlayerTeamView]
@ID INT
AS
BEGIN

IF (@ID = 1)
BEGIN

	SELECT [plID]
		,[plFirstName]
		,[plLastName]
		,po.[poShortDesc] as [Position]
		,tblTeam.tmName
		,[plTeam]
		,[plInsideShot]
		,[plOutsideShot]
		,[plPass]
		,[plRebound]
		,[plDefense]
		,[plIQ]
		,[plDetermination]
		,[plExperience]
		,[plFantasyScore]
		,[plRookieYear]
		,[plRetired]
	FROM [NBADB].[dbo].[tblPlayer] pl
	JOIN tblTeam
		ON tblTeam.tmID = pl.plTeam
	JOIN tblPosition po
		ON po.poID = pl.plPosition
	WHERE [plRetired] = 0
	ORDER BY [plTeam]

END

ELSE IF (@ID = 2)
BEGIN

    DECLARE @TopTeamScore DECIMAL(6,2) = (
    SELECT TOP 1 SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30))) AS Total
    FROM [NBADB].[dbo].[tblPlayer] p
    JOIN tblTeam t
	   ON t.tmID = p.plTeam
    JOIN tblDivision d
	   ON d.dvID = t.tmDivision
    WHERE [plRetired] = 0
    GROUP BY t.tmLocation, t.tmName
    ORDER BY [Total] DESC)

    SELECT t.tmID,t.tmLocation + ' ' + t.tmName AS TeamName
	   ,CONVERT(DECIMAL(6,2),SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30)))) AS Total
	   ,CONVERT(DECIMAL(6,2),@TopTeamScore - (SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30))))) AS [PointsBehind]
    FROM [NBADB].[dbo].[tblPlayer] p
    JOIN tblTeam t
	   ON t.tmID = p.plTeam
    JOIN tblDivision d
	   ON d.dvID = t.tmDivision
    WHERE [plRetired] = 0
    GROUP BY t.tmID, t.tmLocation, t.tmName
    ORDER BY [Total] DESC

END

ELSE IF (@ID = 3)
BEGIN
	
    DECLARE @TopPlayerScore DECIMAL(6,2) = (   
    SELECT TOP 1 SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30))) AS Total
    FROM [NBADB].[dbo].[tblPlayer] p
    JOIN tblTeam t
	   ON t.tmID = p.plTeam
    JOIN tblDivision d
	   ON d.dvID = t.tmDivision
    WHERE [plRetired] = 0
    GROUP BY p.plID, p.plFirstName,p.plLastName
    ORDER BY Total DESC)

    SELECT p.plID,
	   p.plFirstName + ' ' + p.plLastName as Name
	   ,CONVERT(DECIMAL(6,2),SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30)))) AS Total
	   ,CONVERT(DECIMAL(6,2),@TopPlayerScore - (SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30))))) AS [PointsBehind]
    FROM [NBADB].[dbo].[tblPlayer] p
    JOIN tblTeam t
	   ON t.tmID = p.plTeam
    JOIN tblDivision d
	   ON d.dvID = t.tmDivision
    WHERE [plRetired] = 0
    GROUP BY p.plID, p.plFirstName,p.plLastName
    ORDER BY Total DESC

END

ELSE IF (@ID = 4)
BEGIN

    SELECT
    (SELECT CONVERT(DECIMAL(6,2),SUM((([plInsideShot]) + ([plOutsideShot] * 1.33) + ([plIQ]))
	   + (([plPass]    * 0.75) + ([plIQ] * 0.45))
	   + (([plRebound] * 0.45) + ([plIQ] * 0.05))
	   + (([plDefense] * 0.70) + ([plIQ] * 0.30))))
    FROM [NBADB].[dbo].[tblPlayer] p2
    JOIN tblTeam t2
	   ON t2.tmID = p2.plTeam
    WHERE p2.plID = p1.plID AND [plRetired] = 0 
    GROUP BY p2.plID, p2.plFirstName, p2.plLastName) as [Score]
    ,p1.*
    FROM tblPlayer p1
    WHERE [plRetired] = 0
    ORDER BY [Score] DESC

END

ELSE IF (@ID = 5)
BEGIN
	DELETE FROM tblPlayer
	INSERT INTO tblPlayer
	SELECT
	plID,plFirstName,plLastName,
	plTeam,plInsideShot,plOutsideShot,
	plPass,plRebound,plDefense,
	plIQ,plDetermination,plExperience,
	plPosition,plFantasyScore,plRookieYear,
	plRetired
	FROM tblPlayerBackup
END

ELSE IF (@ID = 6)
BEGIN

	DELETE FROM tblPlayerBackup
	INSERT INTO tblPlayerBackup
	SELECT
	plID,plFirstName,plLastName,
	plTeam,plInsideShot,plOutsideShot,
	plPass,plRebound,plDefense,
	plIQ,getdate(),plDetermination,plExperience,
	plPosition,plFantasyScore,plRookieYear,
	plRetired
	FROM tblPlayer
END

ELSE IF (@ID = 7)
BEGIN
SELECT
t.tmLocation,t.tmName,
CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL(3,1),p.plExperience))) as AvgExp
FROM tblPlayer p
JOIN tblTeam t
    ON t.tmID = p.plTeam
WHERE plRetired = 0
GROUP BY
t.tmLocation,t.tmName
ORDER BY AvgExp DESC
END

END
GO

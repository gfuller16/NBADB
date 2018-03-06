USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spSetFantasySquads]    Script Date: 3/6/2018 8:27:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spSetFantasySquads]
AS
BEGIN
	
	DECLARE @UserID INT, @Position INT
	DECLARE @Year INT = ISNULL((SELECT MAX(ftYear) + 1 FROM tblFantasyTeam),2000)

	IF OBJECT_ID('tempdb.dbo.#TempPlayer','U') IS NOT NULL
		DROP TABLE #TempPlayer;

	CREATE TABLE #TempPlayer(
	plID INT PRIMARY KEY,
	plPosition INT NOT NULL,
	plTalent DECIMAL(6,3)
	)

	INSERT INTO #TempPlayer
	SELECT p.plID,
		  p.plPosition,
		  SUM((([plInsideShot] * 0.40) + ([plOutsideShot] * 0.50) + ([plIQ] * 0.10))
		  + (([plPass] * 0.60) + ([plIQ] * 0.40))
		  + (([plRebound] * 0.55) + ([plDefense] * 0.25) + ([plIQ] * 0.20))
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	  GROUP BY p.plID, plPosition
	  ORDER BY Total DESC

	
	DECLARE SetPlayer CURSOR
		FOR
			
			SELECT DISTINCT
			plPosition
			FROM #TempPlayer

		OPEN SetPlayer
		FETCH NEXT FROM SetPlayer INTO @Position

		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			DECLARE SetUserSquad CURSOR
			FOR

				SELECT fuID
				FROM tblFantasyUser
				ORDER BY NEWID()

			OPEN SetUserSquad
			FETCH NEXT FROM SetUserSquad INTO @UserID

			WHILE(@@FETCH_STATUS = 0)
			BEGIN

				DECLARE @TeamID INT = (ISNULL((SELECT MAX(ftID) + 1 FROM tblFantasyTeam),0))

				INSERT INTO tblFantasyTeam
					SELECT TOP 1
					@TeamID,
					@UserID,
					fuFirstName + fuLastName + CONVERT(VARCHAR(4),@Year),
					(SELECT TOP 1 plID FROM #TempPlayer WHERE plPosition = @Position ORDER BY plTalent DESC),
					0,
					@Year
					FROM #TempPlayer,tblFantasyUser
					WHERE fuID = @UserID

				DELETE FROM #TempPlayer
				WHERE plID IN(SELECT ftPlayer_plID FROM tblFantasyTeam WHERE ftYear = @Year)

				FETCH NEXT FROM SetUserSquad INTO @UserID

			END

			CLOSE SetUserSquad
			DEALLOCATE SetUserSquad

		FETCH NEXT FROM SetPlayer INTO @Position

		END	

	CLOSE SetPlayer
	DEALLOCATE SetPlayer
	
END

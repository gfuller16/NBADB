USE [NBADB]
GO

/****** Object:  StoredProcedure [dbo].[spPlayerRankings]    Script Date: 3/6/2018 8:23:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPlayerRankings]
@INT INT
AS
BEGIN
	
	IF(@INT = 1)
	BEGIN

	SELECT TOP 20
		  p.plID,
		  p.plFirstName + ' ' + p.plLastName as Name
		  ,SUM((([plInsideShot] * 0.40) + ([plOutsideShot] * 0.50) + ([plIQ] * 0.10))
		  + (([plPass] * 0.60) + ([plIQ] * 0.40))
		  + (([plRebound] * 0.55) + ([plDefense] * 0.25) + ([plIQ] * 0.20))
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	WHERE plPosition = 1
	  GROUP BY p.plID, p.plFirstName,p.plLastName
	  ORDER BY Total DESC

	END

	ELSE IF(@INT = 2)
	BEGIN

	SELECT TOP 20
		  p.plID,
		  p.plFirstName + ' ' + p.plLastName as Name
		  ,SUM((([plInsideShot] * 0.40) + ([plOutsideShot] * 0.50) + ([plIQ] * 0.10))
		  + (([plPass] * 0.60) + ([plIQ] * 0.40))
		  + (([plRebound] * 0.55) + ([plDefense] * 0.25) + ([plIQ] * 0.20))
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	WHERE plPosition = 2
	  GROUP BY p.plID, p.plFirstName,p.plLastName
	  ORDER BY Total DESC

	END

	ELSE IF(@INT = 3)
	BEGIN

	SELECT TOP 20
		  p.plID,
		  p.plFirstName + ' ' + p.plLastName as Name
		  ,SUM((([plInsideShot] * 0.40) + ([plOutsideShot] * 0.50) + ([plIQ] * 0.10))
		  + (([plPass] * 0.60) + ([plIQ] * 0.40))
		  + (([plRebound] * 0.55) + ([plDefense] * 0.25) + ([plIQ] * 0.20))
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	WHERE plPosition = 3
	  GROUP BY p.plID, p.plFirstName,p.plLastName
	  ORDER BY Total DESC

	END

	ELSE IF(@INT = 4)
	BEGIN

	SELECT TOP 20
		  p.plID,
		  p.plFirstName + ' ' + p.plLastName as Name
		  ,SUM((([plInsideShot] * 0.40) + ([plOutsideShot] * 0.50) + ([plIQ] * 0.10))
		  + (([plPass] * 0.60) + ([plIQ] * 0.40))
		  + (([plRebound] * 0.55) + ([plDefense] * 0.25) + ([plIQ] * 0.20))
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	WHERE plPosition = 4
	  GROUP BY p.plID, p.plFirstName,p.plLastName
	  ORDER BY Total DESC
	
	END

	ELSE
	BEGIN

	SELECT TOP 20
		  p.plID,
		  p.plFirstName + ' ' + p.plLastName as Name
		  ,SUM((([plInsideShot] * 0.40) + ([plOutsideShot] * 0.50) + ([plIQ] * 0.10))
		  + (([plPass] * 0.60) + ([plIQ] * 0.40))
		  + (([plRebound] * 0.55) + ([plDefense] * 0.25) + ([plIQ] * 0.20))
		  + ([plDetermination] * .75)) AS Total
	  FROM [NBADB].[dbo].[tblPlayer] p
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	JOIN tblDivision d
		ON d.dvID = t.tmDivision
	WHERE plPosition = 5
	  GROUP BY p.plID, p.plFirstName,p.plLastName
	  ORDER BY Total DESC
	
	END

END
GO

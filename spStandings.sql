USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spStandings]    Script Date: 4/24/2017 3:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spStandings]
AS

SET NOCOUNT ON

--EXEC [dbo].[spRegularSeason]
--EXEC [dbo].[spScheduleGame]

BEGIN
PRINT 'NBA STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
      ,[tmConfWins]
      ,[tmConfLosses]
      ,[tmNonConfWins]
      ,[tmNonConfLosses]
      ,[tmTotalWins]
      ,[tmTotalLosses]
	  ,CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) AS WinPerc
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
ORDER BY CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,[tmTotalWins]))/(CONVERT(DECIMAL,[tmTotalWins])+CONVERT(DECIMAL,[tmTotalLosses]))) DESC, tmConfWins DESC, tmConfLosses

PRINT '
EASTERN CONFERENCE STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,tmConfWins))/(CONVERT(DECIMAL,tmConfWins)+CONVERT(DECIMAL,tmConfLosses))) DESC, tmTotalWins DESC, tmTotalLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmConfWins]
      ,[tmConfLosses]
	  ,CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,tmConfWins))/(CONVERT(DECIMAL,tmConfWins)+CONVERT(DECIMAL,tmConfLosses))) AS WinPerc
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE c.cfID = 0
ORDER BY CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,tmConfWins))/(CONVERT(DECIMAL,tmConfWins)+CONVERT(DECIMAL,tmConfLosses))) DESC, tmTotalWins DESC, tmTotalLosses

PRINT '
WESTERN CONFERENCE STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,tmConfWins))/(CONVERT(DECIMAL,tmConfWins)+CONVERT(DECIMAL,tmConfLosses))) DESC, tmTotalWins DESC, tmTotalLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmConfWins]
      ,[tmConfLosses]
	  ,CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,tmConfWins))/(CONVERT(DECIMAL,tmConfWins)+CONVERT(DECIMAL,tmConfLosses))) AS WinPerc
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE c.cfID = 1
ORDER BY CONVERT(DECIMAL(6,3),(CONVERT(DECIMAL,tmConfWins))/(CONVERT(DECIMAL,tmConfWins)+CONVERT(DECIMAL,tmConfLosses))) DESC, tmTotalWins DESC, tmTotalLosses

PRINT '
SOUTHEAST DIVISION STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE d.dvID = 0
ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses

PRINT '
CENTRAL DIVISION STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE d.dvID = 1
ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses

PRINT '
ATLANTIC DIVISION STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE d.dvID = 2
ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses

PRINT '
SOUTHWEST DIVISION STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE d.dvID = 3
ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses

PRINT '
NORTHWEST DIVISION STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE d.dvID = 4
ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses

PRINT '
PACIFIC DIVISION STANDINGS'
SELECT CONVERT(VARCHAR(5),RANK() OVER(ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses)) AS [Rank]
      ,CAST([tmLocation] AS VARCHAR(20)) AS Location
      ,CAST([tmName] AS VARCHAR(20)) AS Name
      ,c.cfName
      ,d.dvName
      ,[tmDivWins]
      ,[tmDivLosses]
FROM [NBADB].[dbo].[tblTeam] t
JOIN tblConference c
	ON c.cfID = t.tmConference
JOIN tblDivision d
	ON d.dvID = t.tmDivision
WHERE d.dvID = 5
ORDER BY tmDivWins DESC, tmDivLosses, tmConfWins DESC, tmConfLosses

END

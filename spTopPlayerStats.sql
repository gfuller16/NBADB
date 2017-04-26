USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spTopPlayerStats]    Script Date: 4/24/2017 3:08:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTopPlayerStats]
@ORDER VARCHAR(3)
AS
BEGIN

IF (@ORDER = '1')
BEGIN

	SET NOCOUNT ON
	SELECT TOP 10 CONVERT(VARCHAR(30),p.plFirstName + ' ' + ISNULL(p.plLastName,'')) as Name
		  ,CONVERT(VARCHAR(17),t.tmLocation) as Location
		  ,po.[poShortDesc] AS [Position]
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgRebounds
		  ,COUNT([gs_gmID]) as GamesPlayed
	  FROM [NBADB].[dbo].[tblGameStats] gs
	  JOIN tblPlayer p
		ON p.plID = gs.gs_plID
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	  JOIN tblPosition po
		ON po.poID = p.plPosition
	GROUP BY p.plFirstName,p.plLastName,t.tmLocation,po.[poShortDesc]
	ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, GamesPlayed DESC,CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

	SELECT TOP 10 CONVERT(VARCHAR(30),p.plFirstName + ' ' + ISNULL(p.plLastName,'')) as Name,CONVERT(VARCHAR(17),t.tmLocation) as Location
		  ,po.[poShortDesc] AS [Position]
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgRebounds
		  ,COUNT([gs_gmID]) as GamesPlayed
	  FROM [NBADB].[dbo].[tblGameStats] gs
	  JOIN tblPlayer p
		ON p.plID = gs.gs_plID
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	  JOIN tblPosition po
		ON po.poID = p.plPosition
	GROUP BY p.plFirstName,p.plLastName,t.tmLocation,po.[poShortDesc]
	ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC, GamesPlayed DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC

	SELECT TOP 10 CONVERT(VARCHAR(30),p.plFirstName + ' ' + ISNULL(p.plLastName,'')) as Name,CONVERT(VARCHAR(17),t.tmLocation) as Location
		  ,po.[poShortDesc] AS [Position]
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgRebounds
		  ,COUNT([gs_gmID]) as GamesPlayed
	  FROM [NBADB].[dbo].[tblGameStats] gs
	  JOIN tblPlayer p
		ON p.plID = gs.gs_plID
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	  JOIN tblPosition po
		ON po.poID = p.plPosition
	GROUP BY p.plFirstName,p.plLastName,t.tmLocation,po.[poShortDesc]
	ORDER BY CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds]))) DESC, GamesPlayed DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints]))) DESC, CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists]))) DESC

END

ELSE IF (LEN(@ORDER) > 1)
BEGIN

	SET @ORDER = CONVERT(INT,@ORDER)

	SELECT p.plID,CONVERT(VARCHAR(30),p.plFirstName + ' ' + ISNULL(p.plLastName,'')) as Name,CONVERT(VARCHAR(17),t.tmLocation) as Location
		  ,po.[poShortDesc] AS [Position]
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsPoints])))) as AvgPoints
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsAssists])))) as AvgAssists
		  ,CONVERT(VARCHAR(15),CONVERT(DECIMAL(4,1),AVG(CONVERT(DECIMAL(4,1),[gsRebounds])))) as AvgRebounds
		  ,COUNT([gs_gmID]) as GamesPlayed
	  FROM [NBADB].[dbo].[tblGameStats] gs
	  JOIN tblPlayer p
		ON p.plID = gs.gs_plID
	  JOIN tblTeam t
		ON t.tmID = p.plTeam
	  JOIN tblPosition po
		ON po.poID = p.plPosition
	WHERE p.plID = @ORDER
	GROUP BY p.plID,p.plFirstName,p.plLastName,t.tmLocation,po.[poShortDesc]

END

END

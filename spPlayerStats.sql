USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spPlayerStats]    Script Date: 4/26/2017 9:05:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPlayerStats] --59,1
@plID INT,
@gmID INT
AS
BEGIN
	
	DECLARE @P1InsideShot  INT = (SELECT RAND()*(100-1)+1)
	DECLARE @P1OutsideShot INT = (SELECT RAND()*(100-1)+1)
	DECLARE @P1Pass        INT = (SELECT RAND()*(100-1)+1)
	DECLARE @P1Rebound     INT = (SELECT RAND()*(100-1)+1)
	DECLARE @P1Defense     INT = (SELECT RAND()*(100-1)+1)
	DECLARE @P1IQ		   INT = (SELECT RAND()*(100-1)+1)
	DECLARE @P1Points INT,@P1Assists INT, @P1Rebounds INT,@P1Name VARCHAR(50)

	SET @P1Points = (SELECT
			(CAST(CASE WHEN (@P1InsideShot < (plInsideShot/10)) THEN (SELECT RAND()*(21-16)+16)
				 WHEN (@P1InsideShot < (plInsideShot/7))		THEN (SELECT RAND()*(16-12)+12)
				 WHEN (@P1InsideShot < (plInsideShot/4))		THEN (SELECT RAND()*(12-8)+8)
				 WHEN (@P1InsideShot < (plInsideShot/2))		THEN (SELECT RAND()*(8-4)+4)
				 WHEN (@P1InsideShot < (plInsideShot))			THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT) * 2)
			+
			(CAST(CASE WHEN (@P1OutsideShot < (plOutsideShot/10)) THEN (SELECT RAND()*(16-10)+10)
				 WHEN (@P1OutsideShot < (plOutsideShot/7))		  THEN (SELECT RAND()*(10-8)+8)
				 WHEN (@P1OutsideShot < (plOutsideShot/4))		  THEN (SELECT RAND()*(8-6)+6)
				 WHEN (@P1OutsideShot < (plOutsideShot/2))		  THEN (SELECT RAND()*(6-4)+4)
				 WHEN (@P1OutsideShot < (plOutsideShot))		  THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT) * 3)
			+
			CAST(CASE WHEN (@P1IQ < (plIQ/15)) THEN (SELECT RAND()*(15-11)+11)
				 WHEN (@P1IQ < (plIQ/7))	   THEN (SELECT RAND()*(11-8)+8)
				 WHEN (@P1IQ < (plIQ/2))	   THEN (SELECT RAND()*(8-5)+5)
				 WHEN (@P1IQ < (plIQ))		   THEN (SELECT RAND()*(5-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			FROM dbo.tblPlayer p
			WHERE @plID = plID)

	SET @P1Assists = (SELECT
			CAST(CASE WHEN (@P1Pass < (plPass/10)) THEN (SELECT RAND()*(20-16)+16)
				 WHEN (@P1Pass < (plPass/7))	   THEN (SELECT RAND()*(16-12)+12)
				 WHEN (@P1Pass < (plPass/4))	   THEN (SELECT RAND()*(12-9)+9)
				 WHEN (@P1Pass < (plPass/2))	   THEN (SELECT RAND()*(9-5)+5)
				 WHEN (@P1Pass < (plPass))		   THEN (SELECT RAND()*(5-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			+
			CAST(CASE WHEN (@P1IQ < (plIQ/12)) THEN (SELECT RAND()*(14-11)+11)
				 WHEN (@P1IQ < (plIQ/6))	   THEN (SELECT RAND()*(11-8)+8)
				 WHEN (@P1IQ < (plIQ/3))	   THEN (SELECT RAND()*(8-4)+4)
				 WHEN (@P1IQ < (plIQ))		   THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			AS AssistTotal
			FROM dbo.tblPlayer p
			WHERE @plID = plID)

	SET @P1Rebounds = (SELECT
			CAST(CASE WHEN (@P1Rebound < (plRebound/10)) THEN (SELECT RAND()*(20-16)+16)
				 WHEN (@P1Rebound < (plRebound/7))		 THEN (SELECT RAND()*(16-12)+12)
				 WHEN (@P1Rebound < (plRebound/4))		 THEN (SELECT RAND()*(12-9)+9)
				 WHEN (@P1Rebound < (plRebound/2))		 THEN (SELECT RAND()*(9-6)+6)
				 WHEN (@P1Rebound < (plRebound))		 THEN (SELECT RAND()*(6-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			+
			CAST(CASE WHEN (@P1Defense < (plDefense/15)) THEN (SELECT RAND()*(9-6)+6)
				 WHEN (@P1Defense < (plDefense/7))		 THEN (SELECT RAND()*(6-4)+4)
				 WHEN (@P1Defense < (plDefense/2))		 THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			+
			CAST(CASE WHEN (@P1IQ < (plIQ/15)) THEN (SELECT RAND()*(10-7)+7)
				 WHEN (@P1IQ < (plIQ/7))	   THEN (SELECT RAND()*(7-4)+4)
				 WHEN (@P1IQ < (plIQ/2))	   THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			AS ReboundTotal
	FROM dbo.tblPlayer p
	WHERE @plID = plID)

	SET @P1Name = (SELECT plFirstName + ' ' + plLastName FROM dbo.tblPlayer WHERE plID = @plID)

	INSERT INTO dbo.tblGameStats(gsID,gs_gmID,gs_plID,gsPoints,gsAssists,gsRebounds)
	VALUES((SELECT ISNULL(MAX(gsID),0) FROM dbo.tblGameStats) + 1,@gmID,@plID,@P1Points,@P1Assists,@P1Rebounds)

	--PRINT @P1Name
	--PRINT 'Points: ' + CAST(@P1Points AS VARCHAR(3))
	--PRINT 'Assists: '+ CAST(@P1Assists AS VARCHAR(3))
	--PRINT 'Rebounds: '+CAST(@P1Rebounds AS VARCHAR(3))

END

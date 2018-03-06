USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spPlayerStats]    Script Date: 3/6/2018 8:23:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spPlayerStats] --59,1
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
			(CAST(CASE WHEN (@P1InsideShot < (plInsideShot/15)) THEN (SELECT RAND()*(22-17)+17)
				 WHEN (@P1InsideShot < (plInsideShot/8))		THEN (SELECT RAND()*(17-12)+12)
				 WHEN (@P1InsideShot < (plInsideShot/4))		THEN (SELECT RAND()*(12-8)+8)
				 WHEN (@P1InsideShot < (plInsideShot/2))		THEN (SELECT RAND()*(8-4)+4)
				 WHEN (@P1InsideShot < (plInsideShot))			THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT) * 2)
			+
			(CAST(CASE WHEN (@P1OutsideShot < (plOutsideShot/15)) THEN (SELECT RAND()*(17-11)+11)
				 WHEN (@P1OutsideShot < (plOutsideShot/8))		  THEN (SELECT RAND()*(11-8)+8)
				 WHEN (@P1OutsideShot < (plOutsideShot/4))		  THEN (SELECT RAND()*(8-6)+6)
				 WHEN (@P1OutsideShot < (plOutsideShot/2))		  THEN (SELECT RAND()*(6-4)+4)
				 WHEN (@P1OutsideShot < (plOutsideShot))		  THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT) * 3)
			+
			CAST(CASE WHEN (@P1IQ < (plIQ/15)) THEN (SELECT RAND()*(16-12)+12)
				 WHEN (@P1IQ < (plIQ/8))	   THEN (SELECT RAND()*(12-8)+8)
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
			CAST(CASE WHEN (@P1Defense < (plDefense/15)) THEN (SELECT RAND()*(10-8)+8)
				 WHEN (@P1Defense < (plDefense/7))		 THEN (SELECT RAND()*(8-4)+4)
				 WHEN (@P1Defense < (plDefense/2))		 THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			+
			CAST(CASE WHEN (@P1IQ < (plIQ/15)) THEN (SELECT RAND()*(9-6)+6)
				 WHEN (@P1IQ < (plIQ/7))	   THEN (SELECT RAND()*(6-4)+4)
				 WHEN (@P1IQ < (plIQ/2))	   THEN (SELECT RAND()*(4-2)+2)
				 ELSE (SELECT RAND()*(2-0)+0) END AS INT)
			AS ReboundTotal
	FROM dbo.tblPlayer p
	WHERE @plID = plID)

	SET @P1Name = (SELECT plFirstName + ' ' + plLastName FROM dbo.tblPlayer WHERE plID = @plID)

	INSERT INTO dbo.tblGameStats(gsID,gs_gmID,gs_plID,gsPoints,gsAssists,gsRebounds)
	VALUES((SELECT ISNULL(MAX(gsID),0) FROM dbo.tblGameStats) + 1,@gmID,@plID,@P1Points,@P1Assists,@P1Rebounds)



	UPDATE tblFantasyTeam
	SET ftScore = ftScore + ((@P1Points * 0.7) + (@P1Assists * 0.5) + (@P1Rebounds * 0.3))
	WHERE ftPlayer_plID = @plID

	UPDATE tblFantasyTeam
	SET ftScore = CASE WHEN @P1Points >= 10 AND @P1Assists >= 10 THEN ftScore + 5
					   WHEN @P1Points >= 10 AND @P1Rebounds >= 10 THEN ftScore + 5
					   WHEN @P1Assists >= 10 AND @P1Rebounds >= 10 THEN ftScore + 5
					   ELSE ftScore END
	WHERE ftPlayer_plID = @plID

	UPDATE tblFantasyTeam
	SET ftScore = CASE WHEN @P1Points >= 10 AND @P1Assists >= 10 AND @P1Rebounds >= 10 THEN ftScore + 15
					   ELSE ftScore END
	WHERE ftPlayer_plID = @plID

END

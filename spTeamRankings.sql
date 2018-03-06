USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spTeamRankings]    Script Date: 3/6/2018 8:28:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spTeamRankings]
AS
BEGIN

    IF OBJECT_ID('tempdb.dbo.#GetRanks','U') IS NOT NULL
	   DROP TABLE #GetRanks;

    CREATE TABLE #GetRanks(
    rk_tmID INT NOT NULL,
    rkRank INT NOT NULL,
    rkYear INT NOT NULL
    )

    INSERT INTO #GetRanks
    SELECT [st_tmID]
	   ,RANK() OVER(PARTITION BY [stYear] ORDER BY [stWinPercentage] DESC) as [Rank]
	   ,[stYear]
    FROM [NBADB].[dbo].[tblNBAStandings] n

    SELECT 
    rk_tmID,
    t.tmName,
    CONVERT(DECIMAL(3,1),AVG(CONVERT(DECIMAL(3,1),rkRank))) AS [AvgRank]
    FROM #GetRanks r
    JOIN tblTeam t
	   ON t.tmID = r.rk_tmID
    GROUP BY
    rk_tmID,t.tmName
    ORDER BY [AvgRank]

END

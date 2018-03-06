USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spTripleDoubleClub]    Script Date: 3/6/2018 8:29:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spTripleDoubleClub]
AS
BEGIN

	SELECT
	p.plFirstName + ' ' + p.plLastName as [Player],
	td.tdPoints as [Points],
	td.tdAssists as [Assists],
	td.tdRebounds as [Rebounds],
	td.tdYear as [Year]
	FROM tblTripleDoubleClub td
	JOIN tblPlayer p
		ON p.plID = td.tdPlayerID_plID
	ORDER BY tdYear,tdPoints,tdAssists,tdRebounds

END

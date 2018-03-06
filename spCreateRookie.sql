USE [NBADB]
GO

/****** Object:  StoredProcedure [dbo].[spCreateRookie]    Script Date: 3/6/2018 8:22:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCreateRookie]
@RookieYear INT,
@Position INT
AS
BEGIN
    
    DECLARE @RookieFirstName VARCHAR(20)= (SELECT TOP 1 [rnFirstName] FROM [tblRookieNames] ORDER BY NEWID())
    DECLARE @RookieLastName VARCHAR(30) = (SELECT TOP 1 [rnLastName] FROM [tblRookieNames] ORDER BY NEWID())
    DECLARE 
    @InShot INT,
    @OutShot INT,
    @Pass INT,
    @Rebound INT,
    @Defense INT,
    @IQ INT,
    @Determination INT

    IF(@Position = 1)
    BEGIN
	   
	   SET @InShot =	    (SELECT RAND()*(80-50)+50)
	   SET @OutShot =	    (SELECT RAND()*(80-40)+40)
	   SET @Pass =		    (SELECT RAND()*(85-60)+60)
	   SET @Rebound =	    (SELECT RAND()*(70-25)+25)
	   SET @Defense =	    (SELECT RAND()*(80-45)+45)
	   SET @IQ =		    (SELECT RAND()*(85-50)+50)
	   SET @Determination = CEILING((SELECT RAND()*(96-50)+50) / 5) * 5

    END

    ELSE IF(@Position = 2)
    BEGIN

	   SET @InShot =	    (SELECT RAND()*(80-60)+60)
	   SET @OutShot =	    (SELECT RAND()*(90-60)+60)
	   SET @Pass =		    (SELECT RAND()*(80-45)+45)
	   SET @Rebound =	    (SELECT RAND()*(75-35)+35)
	   SET @Defense =	    (SELECT RAND()*(80-45)+45)
	   SET @IQ =		    (SELECT RAND()*(85-50)+50)
	   SET @Determination = CEILING((SELECT RAND()*(96-50)+50) / 5) * 5	   

    END

    ELSE IF(@Position = 3)
    BEGIN

	   SET @InShot =	    (SELECT RAND()*(80-50)+50)
	   SET @OutShot =	    (SELECT RAND()*(80-40)+40)
	   SET @Pass =		    (SELECT RAND()*(80-40)+40)
	   SET @Rebound =	    (SELECT RAND()*(75-45)+45)
	   SET @Defense =	    (SELECT RAND()*(80-50)+50)
	   SET @IQ =		    (SELECT RAND()*(85-50)+50)
	   SET @Determination = CEILING((SELECT RAND()*(96-50)+50) / 5) * 5	   

    END

    ELSE IF(@Position = 4)
    BEGIN
	   
	   SET @InShot =	    (SELECT RAND()*(90-40)+40)
	   SET @OutShot =	    (SELECT RAND()*(70-35)+35)
	   SET @Pass =		    (SELECT RAND()*(75-40)+40)
	   SET @Rebound =	    (SELECT RAND()*(85-55)+55)
	   SET @Defense =	    (SELECT RAND()*(85-55)+55)
	   SET @IQ =		    (SELECT RAND()*(85-45)+45)
	   SET @Determination = CEILING((SELECT RAND()*(96-50)+50) / 5) * 5

    END

    ELSE
    BEGIN

	   SET @InShot =	    (SELECT RAND()*(90-40)+40)
	   SET @OutShot =	    (SELECT RAND()*(75-25)+25)
	   SET @Pass =		    (SELECT RAND()*(75-35)+35)
	   SET @Rebound =	    (SELECT RAND()*(90-55)+55)
	   SET @Defense =	    (SELECT RAND()*(85-50)+50)
	   SET @IQ =		    (SELECT RAND()*(85-45)+45)
	   SET @Determination = CEILING((SELECT RAND()*(96-50)+50) / 5) * 5	   

    END

    INSERT INTO [tblRookies]
    SELECT
    ISNULL((SELECT MAX(plID) + 1 FROM [tblPlayer]),0),
    @RookieFirstName,@RookieLastName,
    @InShot,
    @OutShot,
    @Pass,
    @Rebound,
    @Defense,
    @IQ,
    @Determination,
    @RookieYear

END
GO

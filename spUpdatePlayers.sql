USE [NBADB]
GO
/****** Object:  StoredProcedure [dbo].[spUpdatePlayers]    Script Date: 3/6/2018 8:29:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdatePlayers]
AS
BEGIN
    
    UPDATE NBADB.dbo.tblPlayer
				SET 
				plIQ =		   CASE WHEN (plExperience < 5) THEN
								   CASE WHEN (plDetermination > 95) AND (plIQ < 99) THEN plIQ + .90
									   WHEN (plDetermination > 90) AND (plIQ < 99) THEN plIQ + .75
									   WHEN (plDetermination > 85) AND (plIQ < 99) THEN plIQ + .60
									   WHEN (plDetermination > 80) AND (plIQ < 99) THEN plIQ + .45
									   WHEN (plDetermination > 75) AND (plIQ < 99) THEN plIQ + .30
									   WHEN (plDetermination > 70) AND (plIQ < 99) THEN plIQ + .15
									   WHEN (plDetermination > 65) AND (plIQ < 99) THEN plIQ + .10
									   WHEN (plDetermination > 60) AND (plIQ < 99) THEN plIQ + .05
																		  ELSE plIQ END
								   WHEN (plExperience < 10) THEN
								   CASE WHEN (plDetermination > 95) AND (plIQ < 99) THEN plIQ + .45
									   WHEN (plDetermination > 90) AND (plIQ < 99) THEN plIQ + .40
									   WHEN (plDetermination > 85) AND (plIQ < 99) THEN plIQ + .30
									   WHEN (plDetermination > 80) AND (plIQ < 99) THEN plIQ + .15
									   WHEN (plDetermination > 75) AND (plIQ < 99) THEN plIQ + .10
									   WHEN (plDetermination > 70) AND (plIQ < 99) THEN plIQ + .05
									   WHEN (plDetermination > 65) AND (plIQ < 99) THEN plIQ
									   WHEN (plDetermination > 60) AND (plIQ < 99) THEN plIQ - .05
																		  ELSE plIQ - .10 END
								   WHEN (plExperience < 15) THEN
								   CASE WHEN (plDetermination > 95) AND (plIQ < 99) THEN plIQ + .25
									   WHEN (plDetermination > 90) AND (plIQ < 99) THEN plIQ + .20
									   WHEN (plDetermination > 85) AND (plIQ < 99) THEN plIQ + .10
									   WHEN (plDetermination > 80) AND (plIQ < 99) THEN plIQ + .05
									   WHEN (plDetermination > 75) AND (plIQ < 99) THEN plIQ
									   WHEN (plDetermination > 70) AND (plIQ < 99) THEN plIQ - .05
									   WHEN (plDetermination > 65) AND (plIQ < 99) THEN plIQ - .10
									   WHEN (plDetermination > 60) AND (plIQ < 99) THEN plIQ - .15
																		  ELSE plIQ - .20 END
								   WHEN (plExperience < 20) THEN
								   CASE WHEN (plDetermination > 95) AND (plIQ < 99) THEN plIQ - .01
									   WHEN (plDetermination > 90) AND (plIQ < 99) THEN plIQ - .02
									   WHEN (plDetermination > 85) AND (plIQ < 99) THEN plIQ - .05
									   WHEN (plDetermination > 80) AND (plIQ < 99) THEN plIQ - .10
									   WHEN (plDetermination > 75) AND (plIQ < 99) THEN plIQ - .15
									   WHEN (plDetermination > 70) AND (plIQ < 99) THEN plIQ - .20
									   WHEN (plDetermination > 65) AND (plIQ < 99) THEN plIQ - .30
									   WHEN (plDetermination > 60) AND (plIQ < 99) THEN plIQ - .50
																		  ELSE plIQ - .75 END
								ELSE plIQ - 1
							   END,
										
				plDefense =	   CASE WHEN (plExperience < 5) THEN
								   CASE WHEN (plDetermination > 95) AND (plDefense < 99) THEN plDefense + .90
									   WHEN (plDetermination > 90) AND (plDefense < 99) THEN plDefense + .75
									   WHEN (plDetermination > 85) AND (plDefense < 99) THEN plDefense + .60
									   WHEN (plDetermination > 80) AND (plDefense < 99) THEN plDefense + .45
									   WHEN (plDetermination > 75) AND (plDefense < 99) THEN plDefense + .30
									   WHEN (plDetermination > 70) AND (plDefense < 99) THEN plDefense + .15
									   WHEN (plDetermination > 65) AND (plDefense < 99) THEN plDefense + .10
									   WHEN (plDetermination > 60) AND (plDefense < 99) THEN plDefense + .05
																			  ELSE plDefense END
								   WHEN (plExperience < 10) THEN
								   CASE WHEN (plDetermination > 95) AND (plDefense < 99) THEN plDefense + .45
									   WHEN (plDetermination > 90) AND (plDefense < 99) THEN plDefense + .40
									   WHEN (plDetermination > 85) AND (plDefense < 99) THEN plDefense + .30
									   WHEN (plDetermination > 80) AND (plDefense < 99) THEN plDefense + .15
									   WHEN (plDetermination > 75) AND (plDefense < 99) THEN plDefense + .10
									   WHEN (plDetermination > 70) AND (plDefense < 99) THEN plDefense + .05
									   WHEN (plDetermination > 65) AND (plDefense < 99) THEN plDefense
									   WHEN (plDetermination > 60) AND (plDefense < 99) THEN plDefense - .05
																			  ELSE plDefense - .10 END
								   WHEN (plExperience < 15) THEN
								   CASE WHEN (plDetermination > 95) AND (plDefense < 99) THEN plDefense + .25
									   WHEN (plDetermination > 90) AND (plDefense < 99) THEN plDefense + .20
									   WHEN (plDetermination > 85) AND (plDefense < 99) THEN plDefense + .10
									   WHEN (plDetermination > 80) AND (plDefense < 99) THEN plDefense + .05
									   WHEN (plDetermination > 75) AND (plDefense < 99) THEN plDefense
									   WHEN (plDetermination > 70) AND (plDefense < 99) THEN plDefense - .05
									   WHEN (plDetermination > 65) AND (plDefense < 99) THEN plDefense - .10
									   WHEN (plDetermination > 60) AND (plDefense < 99) THEN plDefense - .15
																			  ELSE plDefense - .20 END
								   WHEN (plExperience < 20) THEN
								   CASE WHEN (plDetermination > 95) AND (plDefense < 99) THEN plDefense - .01
									   WHEN (plDetermination > 90) AND (plDefense < 99) THEN plDefense - .02
									   WHEN (plDetermination > 85) AND (plDefense < 99) THEN plDefense - .05
									   WHEN (plDetermination > 80) AND (plDefense < 99) THEN plDefense - .10
									   WHEN (plDetermination > 75) AND (plDefense < 99) THEN plDefense - .15
									   WHEN (plDetermination > 70) AND (plDefense < 99) THEN plDefense - .20
									   WHEN (plDetermination > 65) AND (plDefense < 99) THEN plDefense - .30
									   WHEN (plDetermination > 60) AND (plDefense < 99) THEN plDefense - .50
																			  ELSE plDefense - .75 END
								ELSE plDefense - 1
								END,

				plOutsideShot = CASE WHEN (plExperience < 5) THEN
								   CASE WHEN (plDetermination > 95) AND (plOutsideShot < 99) THEN plOutsideShot + .90
									   WHEN (plDetermination > 90) AND (plOutsideShot < 99) THEN plOutsideShot + .75
									   WHEN (plDetermination > 85) AND (plOutsideShot < 99) THEN plOutsideShot + .60
									   WHEN (plDetermination > 80) AND (plOutsideShot < 99) THEN plOutsideShot + .45
									   WHEN (plDetermination > 75) AND (plOutsideShot < 99) THEN plOutsideShot + .30
									   WHEN (plDetermination > 70) AND (plOutsideShot < 99) THEN plOutsideShot + .15
									   WHEN (plDetermination > 65) AND (plOutsideShot < 99) THEN plOutsideShot + .10
									   WHEN (plDetermination > 60) AND (plOutsideShot < 99) THEN plOutsideShot + .05
																				 ELSE plOutsideShot END
								   WHEN (plExperience < 10) THEN
								   CASE WHEN (plDetermination > 95) AND (plOutsideShot < 99) THEN plOutsideShot + .45
									   WHEN (plDetermination > 90) AND (plOutsideShot < 99) THEN plOutsideShot + .40
									   WHEN (plDetermination > 85) AND (plOutsideShot < 99) THEN plOutsideShot + .30
									   WHEN (plDetermination > 80) AND (plOutsideShot < 99) THEN plOutsideShot + .15
									   WHEN (plDetermination > 75) AND (plOutsideShot < 99) THEN plOutsideShot + .10
									   WHEN (plDetermination > 70) AND (plOutsideShot < 99) THEN plOutsideShot + .05
									   WHEN (plDetermination > 65) AND (plOutsideShot < 99) THEN plOutsideShot
									   WHEN (plDetermination > 60) AND (plOutsideShot < 99) THEN plOutsideShot - .05
																				 ELSE plOutsideShot - .10 END
								   WHEN (plExperience < 15) THEN
								   CASE WHEN (plDetermination > 95) AND (plOutsideShot < 99) THEN plOutsideShot + .25
									   WHEN (plDetermination > 90) AND (plOutsideShot < 99) THEN plOutsideShot + .20
									   WHEN (plDetermination > 85) AND (plOutsideShot < 99) THEN plOutsideShot + .10
									   WHEN (plDetermination > 80) AND (plOutsideShot < 99) THEN plOutsideShot + .05
									   WHEN (plDetermination > 75) AND (plOutsideShot < 99) THEN plOutsideShot
									   WHEN (plDetermination > 70) AND (plOutsideShot < 99) THEN plOutsideShot - .05
									   WHEN (plDetermination > 65) AND (plOutsideShot < 99) THEN plOutsideShot - .10
									   WHEN (plDetermination > 60) AND (plOutsideShot < 99) THEN plOutsideShot - .15
																				 ELSE plOutsideShot - .20 END
								   WHEN (plExperience < 20) THEN
								   CASE WHEN (plDetermination > 95) AND (plOutsideShot < 99) THEN plOutsideShot - .01
									   WHEN (plDetermination > 90) AND (plOutsideShot < 99) THEN plOutsideShot - .02
									   WHEN (plDetermination > 85) AND (plOutsideShot < 99) THEN plOutsideShot - .05
									   WHEN (plDetermination > 80) AND (plOutsideShot < 99) THEN plOutsideShot - .10
									   WHEN (plDetermination > 75) AND (plOutsideShot < 99) THEN plOutsideShot - .15
									   WHEN (plDetermination > 70) AND (plOutsideShot < 99) THEN plOutsideShot - .20
									   WHEN (plDetermination > 65) AND (plOutsideShot < 99) THEN plOutsideShot - .30
									   WHEN (plDetermination > 60) AND (plOutsideShot < 99) THEN plOutsideShot - .50
																				 ELSE plOutsideShot - .75 END
								ELSE plOutsideShot - 1
								END,

				plInsideShot =  CASE WHEN (plExperience < 5) THEN
								   CASE WHEN (plDetermination > 95) AND (plInsideShot < 99) THEN plInsideShot + .90
									   WHEN (plDetermination > 90) AND (plInsideShot < 99) THEN plInsideShot + .75
									   WHEN (plDetermination > 85) AND (plInsideShot < 99) THEN plInsideShot + .60
									   WHEN (plDetermination > 80) AND (plInsideShot < 99) THEN plInsideShot + .45
									   WHEN (plDetermination > 75) AND (plInsideShot < 99) THEN plInsideShot + .30
									   WHEN (plDetermination > 70) AND (plInsideShot < 99) THEN plInsideShot + .15
									   WHEN (plDetermination > 65) AND (plInsideShot < 99) THEN plInsideShot + .10
									   WHEN (plDetermination > 60) AND (plInsideShot < 99) THEN plInsideShot + .05
																				ELSE plInsideShot END
								   WHEN (plExperience < 10) THEN
								   CASE WHEN (plDetermination > 95) AND (plInsideShot < 99) THEN plInsideShot + .45
									   WHEN (plDetermination > 90) AND (plInsideShot < 99) THEN plInsideShot + .40
									   WHEN (plDetermination > 85) AND (plInsideShot < 99) THEN plInsideShot + .30
									   WHEN (plDetermination > 80) AND (plInsideShot < 99) THEN plInsideShot + .15
									   WHEN (plDetermination > 75) AND (plInsideShot < 99) THEN plInsideShot + .10
									   WHEN (plDetermination > 70) AND (plInsideShot < 99) THEN plInsideShot + .05
									   WHEN (plDetermination > 65) AND (plInsideShot < 99) THEN plInsideShot
									   WHEN (plDetermination > 60) AND (plInsideShot < 99) THEN plInsideShot - .05
																				ELSE plInsideShot - .10 END
								   WHEN (plExperience < 15) THEN
								   CASE WHEN (plDetermination > 95) AND (plInsideShot < 99) THEN plInsideShot + .25
									   WHEN (plDetermination > 90) AND (plInsideShot < 99) THEN plInsideShot + .20
									   WHEN (plDetermination > 85) AND (plInsideShot < 99) THEN plInsideShot + .10
									   WHEN (plDetermination > 80) AND (plInsideShot < 99) THEN plInsideShot + .05
									   WHEN (plDetermination > 75) AND (plInsideShot < 99) THEN plInsideShot
									   WHEN (plDetermination > 70) AND (plInsideShot < 99) THEN plInsideShot - .05
									   WHEN (plDetermination > 65) AND (plInsideShot < 99) THEN plInsideShot - .10
									   WHEN (plDetermination > 60) AND (plInsideShot < 99) THEN plInsideShot - .15
																				ELSE plInsideShot - .20 END
								   WHEN (plExperience < 20) THEN
								   CASE WHEN (plDetermination > 95) AND (plInsideShot < 99) THEN plInsideShot - .01
									   WHEN (plDetermination > 90) AND (plInsideShot < 99) THEN plInsideShot - .02
									   WHEN (plDetermination > 85) AND (plInsideShot < 99) THEN plInsideShot - .05
									   WHEN (plDetermination > 80) AND (plInsideShot < 99) THEN plInsideShot - .10
									   WHEN (plDetermination > 75) AND (plInsideShot < 99) THEN plInsideShot - .15
									   WHEN (plDetermination > 70) AND (plInsideShot < 99) THEN plInsideShot - .20
									   WHEN (plDetermination > 65) AND (plInsideShot < 99) THEN plInsideShot - .30
									   WHEN (plDetermination > 60) AND (plInsideShot < 99) THEN plInsideShot - .50
																				ELSE plInsideShot - .75 END
								ELSE plInsideShot - 1
								END,

				plPass =		 CASE WHEN (plExperience < 5) THEN
								   CASE WHEN (plDetermination > 95) AND (plPass < 99) THEN plPass + .90
									   WHEN (plDetermination > 90) AND (plPass < 99) THEN plPass + .75
									   WHEN (plDetermination > 85) AND (plPass < 99) THEN plPass + .60
									   WHEN (plDetermination > 80) AND (plPass < 99) THEN plPass + .45
									   WHEN (plDetermination > 75) AND (plPass < 99) THEN plPass + .30
									   WHEN (plDetermination > 70) AND (plPass < 99) THEN plPass + .15
									   WHEN (plDetermination > 65) AND (plPass < 99) THEN plPass + .10
									   WHEN (plDetermination > 60) AND (plPass < 99) THEN plPass + .05
																		    ELSE plPass END
								   WHEN (plExperience < 10) THEN
								   CASE WHEN (plDetermination > 95) AND (plPass < 99) THEN plPass + .45
									   WHEN (plDetermination > 90) AND (plPass < 99) THEN plPass + .40
									   WHEN (plDetermination > 85) AND (plPass < 99) THEN plPass + .30
									   WHEN (plDetermination > 80) AND (plPass < 99) THEN plPass + .15
									   WHEN (plDetermination > 75) AND (plPass < 99) THEN plPass + .10
									   WHEN (plDetermination > 70) AND (plPass < 99) THEN plPass + .05
									   WHEN (plDetermination > 65) AND (plPass < 99) THEN plPass
									   WHEN (plDetermination > 60) AND (plPass < 99) THEN plPass - .05
																		    ELSE plPass - .10 END
								   WHEN (plExperience < 15) THEN
								   CASE WHEN (plDetermination > 95) AND (plPass < 99) THEN plPass + .25
									   WHEN (plDetermination > 90) AND (plPass < 99) THEN plPass + .20
									   WHEN (plDetermination > 85) AND (plPass < 99) THEN plPass + .10
									   WHEN (plDetermination > 80) AND (plPass < 99) THEN plPass + .05
									   WHEN (plDetermination > 75) AND (plPass < 99) THEN plPass
									   WHEN (plDetermination > 70) AND (plPass < 99) THEN plPass - .05
									   WHEN (plDetermination > 65) AND (plPass < 99) THEN plPass - .10
									   WHEN (plDetermination > 60) AND (plPass < 99) THEN plPass - .15
																		    ELSE plPass - .20 END
								   WHEN (plExperience < 20) THEN
								   CASE WHEN (plDetermination > 95) AND (plPass < 99) THEN plPass - .01
									   WHEN (plDetermination > 90) AND (plPass < 99) THEN plPass - .02
									   WHEN (plDetermination > 85) AND (plPass < 99) THEN plPass - .05
									   WHEN (plDetermination > 80) AND (plPass < 99) THEN plPass - .10
									   WHEN (plDetermination > 75) AND (plPass < 99) THEN plPass - .15
									   WHEN (plDetermination > 70) AND (plPass < 99) THEN plPass - .20
									   WHEN (plDetermination > 65) AND (plPass < 99) THEN plPass - .30
									   WHEN (plDetermination > 60) AND (plPass < 99) THEN plPass - .50
																		    ELSE plPass - .75 END
								ELSE plPass - 1
								END,

				 plRebound =	CASE WHEN (plExperience < 5) THEN
								   CASE WHEN (plDetermination > 95) AND (plRebound < 99) THEN plRebound + .90
									   WHEN (plDetermination > 90) AND (plRebound < 99) THEN plRebound + .75
									   WHEN (plDetermination > 85) AND (plRebound < 99) THEN plRebound + .60
									   WHEN (plDetermination > 80) AND (plRebound < 99) THEN plRebound + .45
									   WHEN (plDetermination > 75) AND (plRebound < 99) THEN plRebound + .30
									   WHEN (plDetermination > 70) AND (plRebound < 99) THEN plRebound + .15
									   WHEN (plDetermination > 65) AND (plRebound < 99) THEN plRebound + .10
									   WHEN (plDetermination > 60) AND (plRebound < 99) THEN plRebound + .05
																			  ELSE plRebound END
								   WHEN (plExperience < 10) THEN
								   CASE WHEN (plDetermination > 95) AND (plRebound < 99) THEN plRebound + .45
									   WHEN (plDetermination > 90) AND (plRebound < 99) THEN plRebound + .40
									   WHEN (plDetermination > 85) AND (plRebound < 99) THEN plRebound + .30
									   WHEN (plDetermination > 80) AND (plRebound < 99) THEN plRebound + .15
									   WHEN (plDetermination > 75) AND (plRebound < 99) THEN plRebound + .10
									   WHEN (plDetermination > 70) AND (plRebound < 99) THEN plRebound + .05
									   WHEN (plDetermination > 65) AND (plRebound < 99) THEN plRebound
									   WHEN (plDetermination > 60) AND (plRebound < 99) THEN plRebound - .05
																			  ELSE plRebound - .10 END
								   WHEN (plExperience < 15) THEN
								   CASE WHEN (plDetermination > 95) AND (plRebound < 99) THEN plRebound + .25
									   WHEN (plDetermination > 90) AND (plRebound < 99) THEN plRebound + .20
									   WHEN (plDetermination > 85) AND (plRebound < 99) THEN plRebound + .10
									   WHEN (plDetermination > 80) AND (plRebound < 99) THEN plRebound + .05
									   WHEN (plDetermination > 75) AND (plRebound < 99) THEN plRebound
									   WHEN (plDetermination > 70) AND (plRebound < 99) THEN plRebound - .05
									   WHEN (plDetermination > 65) AND (plRebound < 99) THEN plRebound - .10
									   WHEN (plDetermination > 60) AND (plRebound < 99) THEN plRebound - .15
																			  ELSE plRebound - .20 END
								   WHEN (plExperience < 20) THEN
								   CASE WHEN (plDetermination > 95) AND (plRebound < 99) THEN plRebound - .01
									   WHEN (plDetermination > 90) AND (plRebound < 99) THEN plRebound - .02
									   WHEN (plDetermination > 85) AND (plRebound < 99) THEN plRebound - .05
									   WHEN (plDetermination > 80) AND (plRebound < 99) THEN plRebound - .10
									   WHEN (plDetermination > 75) AND (plRebound < 99) THEN plRebound - .15
									   WHEN (plDetermination > 70) AND (plRebound < 99) THEN plRebound - .20
									   WHEN (plDetermination > 65) AND (plRebound < 99) THEN plRebound - .30
									   WHEN (plDetermination > 60) AND (plRebound < 99) THEN plRebound - .50
																			  ELSE plRebound - .75 END
								ELSE plRebound - 1
								END

				UPDATE tblPlayer
				SET plExperience = plExperience + 1

END

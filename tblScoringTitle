USE [NBADB]
GO

/****** Object:  Table [dbo].[tblScoringTitle]    Script Date: 3/6/2018 8:18:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblScoringTitle](
	[scID] [int] NOT NULL,
	[sc_plID] [int] NOT NULL,
	[scPointsAvg] [decimal](3, 1) NOT NULL,
	[scYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[scID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblScoringTitle]  WITH CHECK ADD FOREIGN KEY([sc_plID])
REFERENCES [dbo].[tblPlayerBackUp] ([plID])
GO

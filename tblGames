USE [NBADB]
GO

/****** Object:  Table [dbo].[tblGames]    Script Date: 4/26/2017 9:03:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblGames](
	[gmID] [int] NOT NULL,
	[gmTeam1] [int] NOT NULL,
	[gmTeam2] [int] NOT NULL,
	[gmPoints1] [int] NULL,
	[gmPoints2] [int] NULL,
	[gmContest] [int] NULL,
	[gmAssists1] [int] NULL,
	[gmAssists2] [int] NULL,
	[gmRebounds1] [int] NULL,
	[gmRebounds2] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[gmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblGames]  WITH CHECK ADD FOREIGN KEY([gmTeam1])
REFERENCES [dbo].[tblTeam] ([tmID])
GO

ALTER TABLE [dbo].[tblGames]  WITH CHECK ADD FOREIGN KEY([gmTeam2])
REFERENCES [dbo].[tblTeam] ([tmID])
GO

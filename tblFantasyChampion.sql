USE [NBADB]
GO

/****** Object:  Table [dbo].[tblFantasyChampion]    Script Date: 3/6/2018 8:12:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblFantasyChampion](
	[fcID] [int] NOT NULL,
	[fcOwner] [int] NOT NULL,
	[fcTeamName] [varchar](50) NOT NULL,
	[fcPlayer] [int] NOT NULL,
	[fcPlayerScore] [int] NOT NULL,
	[fcTeamScore] [int] NOT NULL,
	[fcYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[fcID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblFantasyChampion]  WITH CHECK ADD FOREIGN KEY([fcPlayer])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

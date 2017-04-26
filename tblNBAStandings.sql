USE [NBADB]
GO

/****** Object:  Table [dbo].[tblNBAStandings]    Script Date: 4/19/2017 12:55:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblNBAStandings](
	[stID] [int] IDENTITY(1,1) NOT NULL,
	[st_tmID] [int] NOT NULL,
	[st_tmTotalWins] [int] NOT NULL,
	[st_tmTotalLosses] [int] NOT NULL,
	[stWinPercentage] [decimal](6, 3) NOT NULL,
	[stYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[stID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblNBAStandings]  WITH CHECK ADD FOREIGN KEY([st_tmID])
REFERENCES [dbo].[tblTeam] ([tmID])
GO

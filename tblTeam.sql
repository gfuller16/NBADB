USE [NBADB]
GO

/****** Object:  Table [dbo].[tblTeam]    Script Date: 3/6/2018 8:19:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblTeam](
	[tmID] [int] NOT NULL,
	[tmLocation] [varchar](40) NOT NULL,
	[tmName] [varchar](40) NOT NULL,
	[tmConference] [int] NOT NULL,
	[tmDivision] [int] NOT NULL,
	[tmDivWins] [int] NULL,
	[tmDivLosses] [int] NULL,
	[tmConfWins] [int] NULL,
	[tmConfLosses] [int] NULL,
	[tmNonConfWins] [int] NULL,
	[tmNonConfLosses] [int] NULL,
	[tmTotalWins] [int] NULL,
	[tmTotalLosses] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[tmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblTeam]  WITH CHECK ADD FOREIGN KEY([tmConference])
REFERENCES [dbo].[tblConference] ([cfID])
GO

ALTER TABLE [dbo].[tblTeam]  WITH CHECK ADD FOREIGN KEY([tmDivision])
REFERENCES [dbo].[tblDivision] ([dvID])
GO

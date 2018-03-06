USE [NBADB]
GO

/****** Object:  Table [dbo].[tblFantasyTeam]    Script Date: 3/6/2018 8:12:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblFantasyTeam](
	[ftID] [int] NOT NULL,
	[ftOwner_fuID] [int] NOT NULL,
	[ftTeamName] [varchar](50) NOT NULL,
	[ftPlayer_plID] [int] NULL,
	[ftScore] [int] NOT NULL,
	[ftYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ftID] ASC,
	[ftOwner_fuID] ASC,
	[ftYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblFantasyTeam]  WITH CHECK ADD FOREIGN KEY([ftOwner_fuID])
REFERENCES [dbo].[tblFantasyUser] ([fuID])
GO

ALTER TABLE [dbo].[tblFantasyTeam]  WITH CHECK ADD FOREIGN KEY([ftPlayer_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

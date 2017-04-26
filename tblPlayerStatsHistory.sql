USE [NBADB]
GO

/****** Object:  Table [dbo].[tblGameStats]    Script Date: 4/26/2017 10:05:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblPlayerStatsHistory](
	[pshID] [int] NOT NULL,
	[psh_gmID] [int] NOT NULL,
	[psh_plID] [int] NOT NULL,
	[pshPoints] [int] NOT NULL,
	[pshAssists] [int] NOT NULL,
	[pshRebounds] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pshID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblPlayerStatsHistory]  WITH CHECK ADD FOREIGN KEY([psh_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

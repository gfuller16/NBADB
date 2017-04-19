USE [NBADB]
GO

/****** Object:  Table [dbo].[tblGameStats]    Script Date: 4/19/2017 12:55:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblGameStats](
	[gsID] [int] NOT NULL,
	[gs_gmID] [int] NOT NULL,
	[gs_plID] [int] NOT NULL,
	[gsPoints] [int] NOT NULL,
	[gsAssists] [int] NOT NULL,
	[gsRebounds] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[gsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblGameStats]  WITH CHECK ADD FOREIGN KEY([gs_gmID])
REFERENCES [dbo].[tblGames] ([gmID])
GO

ALTER TABLE [dbo].[tblGameStats]  WITH CHECK ADD FOREIGN KEY([gs_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

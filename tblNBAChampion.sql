USE [NBADB]
GO

/****** Object:  Table [dbo].[tblNBAChampion]    Script Date: 4/19/2017 12:55:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblNBAChampion](
	[chID] [int] NOT NULL,
	[ch_tmID] [int] NOT NULL,
	[chYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[chID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblNBAChampion]  WITH CHECK ADD FOREIGN KEY([ch_tmID])
REFERENCES [dbo].[tblTeam] ([tmID])
GO
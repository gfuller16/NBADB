USE [NBADB]
GO

/****** Object:  Table [dbo].[tblRetirees]    Script Date: 3/6/2018 8:17:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblRetirees](
	[rtID] [int] NOT NULL,
	[rtFirstName] [varchar](20) NOT NULL,
	[rtLastName] [varchar](30) NULL,
	[rtAvgPoints] [decimal](5, 2) NOT NULL,
	[rtAvgAssists] [decimal](5, 2) NOT NULL,
	[rtAvgRebounds] [decimal](5, 2) NOT NULL,
	[rtRetireYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

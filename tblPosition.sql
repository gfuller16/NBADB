USE [NBADB]
GO

/****** Object:  Table [dbo].[tblPosition]    Script Date: 3/6/2018 8:16:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblPosition](
	[poID] [int] NOT NULL,
	[poDesc] [varchar](20) NULL,
	[poShortDesc] [varchar](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[poID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

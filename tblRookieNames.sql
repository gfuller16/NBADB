USE [NBADB]
GO

/****** Object:  Table [dbo].[tblRookieNames]    Script Date: 3/6/2018 8:17:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblRookieNames](
	[rnID] [int] NOT NULL,
	[rnFirstName] [varchar](20) NOT NULL,
	[rnLastName] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

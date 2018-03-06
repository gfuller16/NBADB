USE [NBADB]
GO

/****** Object:  Table [dbo].[tblFantasyUser]    Script Date: 3/6/2018 8:12:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblFantasyUser](
	[fuID] [int] NOT NULL,
	[fuFirstName] [varchar](25) NOT NULL,
	[fuLastName] [varchar](25) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[fuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

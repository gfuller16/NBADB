USE [NBADB]
GO

/****** Object:  Table [dbo].[tblRookies]    Script Date: 3/6/2018 8:17:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblRookies](
	[rkID] [int] NOT NULL,
	[rkFirstName] [varchar](20) NOT NULL,
	[rkLastName] [varchar](30) NOT NULL,
	[rkInsideShot] [decimal](5, 2) NOT NULL,
	[rkOutsideShot] [decimal](5, 2) NOT NULL,
	[rkPass] [decimal](5, 2) NOT NULL,
	[rkRebound] [decimal](5, 2) NOT NULL,
	[rkDefense] [decimal](5, 2) NOT NULL,
	[rkIQ] [decimal](5, 2) NOT NULL,
	[rkDetermination] [decimal](5, 2) NOT NULL,
	[rkYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

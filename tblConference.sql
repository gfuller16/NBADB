USE [NBADB]
GO

/****** Object:  Table [dbo].[tblConference]    Script Date: 3/6/2018 8:09:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblConference](
	[cfID] [int] NOT NULL,
	[cfName] [varchar](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cfID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

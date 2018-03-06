USE [NBADB]
GO

/****** Object:  Table [dbo].[tblMIP]    Script Date: 3/6/2018 8:14:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblMIP](
	[mipID] [int] NOT NULL,
	[mip_plID] [int] NOT NULL,
	[mipPtsImproved] [decimal](3, 1) NOT NULL,
	[mipAstImproved] [decimal](3, 1) NOT NULL,
	[mipRebImproved] [decimal](3, 1) NOT NULL,
	[mipYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[mipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblMIP]  WITH CHECK ADD FOREIGN KEY([mip_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

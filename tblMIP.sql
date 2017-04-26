USE [NBADB]
GO

/****** Object:  Table [dbo].[tblMVP]    Script Date: 4/26/2017 9:25:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblMIP](
	[mipID] [int] NOT NULL,
	[mip_plID] [int] NOT NULL,
	[mipPtsAvg1] [decimal](3, 1) NOT NULL,
	[mipPtsAvg2] [decimal](3, 1) NOT NULL,
	[mipAstAvg1] [decimal](3, 1) NOT NULL,
	[mipAstAvg2] [decimal](3, 1) NOT NULL,
	[mipRebAvg1] [decimal](3, 1) NOT NULL,
	[mipRebAvg2] [decimal](3, 1) NOT NULL,
	[mipPriorWorth] [decimal](5, 2) NOT NULL,
	[mipCurrentWorth] [decimal](5, 2) NOT NULL,
	[mipYearEnd] [int] NOT NULL
PRIMARY KEY CLUSTERED 
(
	[mipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblMIP]  WITH CHECK ADD FOREIGN KEY([mip_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

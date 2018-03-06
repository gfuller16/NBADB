USE [NBADB]
GO

/****** Object:  Table [dbo].[tblTripleDoubleClub]    Script Date: 3/6/2018 8:19:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblTripleDoubleClub](
	[tdPlayerID_plID] [int] NOT NULL,
	[tdPoints] [decimal](3, 1) NOT NULL,
	[tdAssists] [decimal](3, 1) NOT NULL,
	[tdRebounds] [decimal](3, 1) NOT NULL,
	[tdYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tdPlayerID_plID] ASC,
	[tdYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblTripleDoubleClub]  WITH CHECK ADD FOREIGN KEY([tdPlayerID_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

USE [NBADB]
GO

/****** Object:  Table [dbo].[tblMVP]    Script Date: 4/26/2017 9:25:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblROY](
	[rID] [int] NOT NULL,
	[r_plID] [int] NOT NULL,
	[rPtsAvg] [decimal](3, 1) NOT NULL,
	[rAstAvg] [decimal](3, 1) NOT NULL,
	[rRebAvg] [decimal](3, 1) NOT NULL,
	[rYear] [int] NOT NULL
PRIMARY KEY CLUSTERED 
(
	[rID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblROY] ADD  DEFAULT ((0)) FOR [rPtsAvg]
GO

ALTER TABLE [dbo].[tblROY] ADD  DEFAULT ((0)) FOR [rAstAvg]
GO

ALTER TABLE [dbo].[tblROY] ADD  DEFAULT ((0)) FOR [rRebAvg]
GO

ALTER TABLE [dbo].[tblROY]  WITH CHECK ADD FOREIGN KEY([r_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

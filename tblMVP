USE [NBADB]
GO

/****** Object:  Table [dbo].[tblMVP]    Script Date: 4/19/2017 12:55:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblMVP](
	[mID] [int] NOT NULL,
	[m_plID] [int] NOT NULL,
	[mPtsAvg] [decimal](3, 1) NOT NULL,
	[mAstAvg] [decimal](3, 1) NOT NULL,
	[mRebAvg] [decimal](3, 1) NOT NULL,
	[mYear] [int] NOT NULL,
	[mRS_Finals] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[mID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblMVP] ADD  DEFAULT ((0)) FOR [mPtsAvg]
GO

ALTER TABLE [dbo].[tblMVP] ADD  DEFAULT ((0)) FOR [mAstAvg]
GO

ALTER TABLE [dbo].[tblMVP] ADD  DEFAULT ((0)) FOR [mRebAvg]
GO

ALTER TABLE [dbo].[tblMVP] ADD  DEFAULT ((0)) FOR [mRS_Finals]
GO

ALTER TABLE [dbo].[tblMVP]  WITH CHECK ADD FOREIGN KEY([m_plID])
REFERENCES [dbo].[tblPlayer] ([plID])
GO

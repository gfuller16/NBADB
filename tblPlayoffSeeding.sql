USE [NBADB]
GO

/****** Object:  Table [dbo].[tblPlayoffSeeding]    Script Date: 4/19/2017 12:55:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblPlayoffSeeding](
	[psID] [int] IDENTITY(1,1) NOT NULL,
	[ps_tmID] [int] NOT NULL,
	[psSeed] [int] NOT NULL,
	[ps_cfID] [int] NULL,
	[psFRWins] [int] NULL,
	[psCFWins] [int] NULL,
	[psFinalsWins] [int] NULL,
	[psYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[psID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblPlayoffSeeding] ADD  DEFAULT ((0)) FOR [psFRWins]
GO

ALTER TABLE [dbo].[tblPlayoffSeeding] ADD  DEFAULT ((0)) FOR [psCFWins]
GO

ALTER TABLE [dbo].[tblPlayoffSeeding] ADD  DEFAULT ((0)) FOR [psFinalsWins]
GO

ALTER TABLE [dbo].[tblPlayoffSeeding]  WITH CHECK ADD FOREIGN KEY([ps_cfID])
REFERENCES [dbo].[tblConference] ([cfID])
GO

ALTER TABLE [dbo].[tblPlayoffSeeding]  WITH CHECK ADD FOREIGN KEY([ps_tmID])
REFERENCES [dbo].[tblTeam] ([tmID])
GO

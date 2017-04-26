USE [NBADB]
GO

/****** Object:  Table [dbo].[tblPlayer]    Script Date: 4/24/2017 1:18:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblPlayer](
	[plID] [int] NOT NULL,
	[plFirstName] [varchar](25) NOT NULL,
	[plLastName] [varchar](30) NULL,
	[plTeam] [int] NULL,
	[plInsideShot] [decimal](5, 2) NULL,
	[plOutsideShot] [decimal](5, 2) NULL,
	[plPass] [decimal](5, 2) NULL,
	[plRebound] [decimal](5, 2) NULL,
	[plDefense] [decimal](5, 2) NULL,
	[plIQ] [decimal](5, 2) NULL,
	[plDetermination] [decimal](5, 2) NULL,
	[plExperience] [int] NULL,
	[plPosition] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[plID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblPlayer] ADD  DEFAULT ((0)) FOR [plExperience]
GO

ALTER TABLE [dbo].[tblPlayer]  WITH CHECK ADD FOREIGN KEY([plPosition])
REFERENCES [dbo].[tblPosition] ([poID])
GO

ALTER TABLE [dbo].[tblPlayer]  WITH CHECK ADD FOREIGN KEY([plTeam])
REFERENCES [dbo].[tblTeam] ([tmID])
GO
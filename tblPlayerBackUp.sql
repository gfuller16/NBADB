USE [NBADB]
GO

/****** Object:  Table [dbo].[tblPlayerBackUp]    Script Date: 4/24/2017 1:18:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblPlayerBackUp](
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
	[plDate] [datetime] NOT NULL,
	[plDetermination] [decimal](5, 2) NULL,
	[plExperience] [int] NULL,
	[plPosition] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblPlayerBackUp] ADD  DEFAULT (getdate()) FOR [plDate]
GO

ALTER TABLE [dbo].[tblPlayerBackUp] ADD  DEFAULT ((0)) FOR [plExperience]
GO

ALTER TABLE [dbo].[tblPlayerBackUp]  WITH CHECK ADD FOREIGN KEY([plPosition])
REFERENCES [dbo].[tblPosition] ([poID])
GO
GO

/****** Object:  Table [dbo].[TBL_TAG_CAPTIONS]    Script Date: 07/07/2015 14:45:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TBL_TAG_CAPTIONS](
	[ID_CAP] [int] IDENTITY(1,1) NOT NULL,
	[TAG] [varchar](2000) NULL,
	[CAPTION] [varchar](2000) NULL,
	[ID_LANG] [int] NULL,
	[DT_CREATED] [datetime] NULL,
	[CREATED_BY] [varchar](50) NULL,
	[DT_MODIFIED] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



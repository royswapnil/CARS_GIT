USE [CARSDEV]
GO

/****** Object:  Table [dbo].[TBL_MAS_VEHICLE_SETTINGS]    Script Date: 11.03.2016 10:37:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TBL_MAS_VEHICLE_SETTINGS](
	[Seq_No] [int] IDENTITY(1,1) NOT NULL,
	[SettingsType] [varchar](max) NULL,
	[SettingsCode] [int] NULL,
	[SettingDescription] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


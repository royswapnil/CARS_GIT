USE [CARSDEV]
GO

/****** Object:  Table [dbo].[TBL_MAS_VEHICLE_REFNO]    Script Date: 11.03.2016 10:31:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TBL_MAS_VEHICLE_REFNO](
	[Seq_No] [int] IDENTITY(1,1) NOT NULL,
	[Refno_Code] [int] NULL,
	[Refno_Description] [varchar](50) NULL,
	[Refno_Prefix] [varchar](50) NULL,
	[Refno_Year] [int] NULL,
	[Refno_Count] [int] NULL,
	[RefNo_Selected] [bit] NULL,
	[Refno_Vat] [varchar](20) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


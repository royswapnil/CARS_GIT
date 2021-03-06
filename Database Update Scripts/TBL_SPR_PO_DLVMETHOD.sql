USE [CARSDEV]
GO

/****** Object:  Table [dbo].[TBL_SPR_PO_DLVMETHOD]    Script Date: 31.01.2018 13:14:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TBL_SPR_PO_DLVMETHOD](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION_SHORT] [nchar](25) NOT NULL,
	[DESCRIPTION_LONG] [nchar](150) NULL,
 CONSTRAINT [PK_TBL_SPR_PO_DLVMETHOD] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


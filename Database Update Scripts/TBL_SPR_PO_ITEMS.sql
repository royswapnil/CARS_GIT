USE [CARSDEV]
GO

/****** Object:  Table [dbo].[TBL_SPR_PO_ITEMS]    Script Date: 31.01.2018 13:13:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TBL_SPR_PO_ITEMS](
	[ID_PO] [bigint] NOT NULL,
	[POLINENO] [int] NOT NULL,
	[POPREFIX] [varchar](50) NOT NULL,
	[PONUMBER] [varchar](50) NOT NULL,
	[ID_ITEM] [varchar](30) NOT NULL,
	[ITEM_CATG_DESC] [varchar](50) NOT NULL,
	[ORDERQTY] [decimal](13, 2) NOT NULL,
	[DELIVERED_QTY] [decimal](13, 2) NOT NULL,
	[REMAINING_QTY] [decimal](13, 2) NOT NULL,
	[BUYCOST] [decimal](13, 2) NOT NULL,
	[TOTALCOST] [decimal](13, 2) NOT NULL,
	[BACKORDERQTY] [decimal](13, 2) NULL,
	[ID_WOITEM_SEQ] [int] NULL,
	[CONFIRMQTY] [decimal](13, 2) NOT NULL,
	[CREATED_BY] [varchar](50) NOT NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	[DT_CREATED] [datetime] NOT NULL,
	[DT_MODIFIED] [datetime] NULL,
	[DELIVERED] [bit] NOT NULL,
	[ANNOTATION] [varchar](100) NULL,
 CONSTRAINT [PK_TBL_SPR_PO_ITEMS] PRIMARY KEY CLUSTERED 
(
	[ID_PO] ASC,
	[POLINENO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TBL_SPR_PO_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SPR_PO_ITEMS_TBL_SPR_PO_ITEMS] FOREIGN KEY([ID_PO], [POLINENO])
REFERENCES [dbo].[TBL_SPR_PO_ITEMS] ([ID_PO], [POLINENO])
GO

ALTER TABLE [dbo].[TBL_SPR_PO_ITEMS] CHECK CONSTRAINT [FK_TBL_SPR_PO_ITEMS_TBL_SPR_PO_ITEMS]
GO


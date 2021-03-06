IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TBL_INVOI__DEBTO__45A28A95]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INVOICE_DATA]'))
ALTER TABLE [dbo].[TBL_INVOICE_DATA] DROP CONSTRAINT [FK__TBL_INVOI__DEBTO__45A28A95]
GO
/****** Object:  Table [dbo].[TBL_INVOICE_DATA]    Script Date: 8/7/2017 2:02:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_INVOICE_DATA]') AND type in (N'U'))
DROP TABLE [dbo].[TBL_INVOICE_DATA]
GO
/****** Object:  Table [dbo].[TBL_INVOICE_DATA]    Script Date: 8/7/2017 2:02:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_INVOICE_DATA]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_INVOICE_DATA](
	[ID_DEB_INV_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[DEBTOR_SEQ] [int] NULL,
	[DEBTOR_ID] [int] NULL,
	[LINE_TYPE] [varchar](10) NULL,
	[LINE_ID] [varchar](30) NULL,
	[PRICE] [decimal](20, 5) NULL,
	[LINE_AMOUNT_NET] [decimal](20, 5) NULL,
	[LINE_DISCOUNT] [decimal](20, 5) NULL,
	[LINE_AMOUNT] [decimal](20, 5) NULL,
	[LINE_VAT_PERCENTAGE] [decimal](20, 5) NULL,
	[LINE_VAT_AMOUNT] [decimal](20, 5) NULL,
	[CREATED_BY] [varchar](20) NULL,
	[DT_CREATED] [datetime] NULL,
	[MODIFIED_BY] [varchar](20) NULL,
	[DT_MODIFIED] [datetime] NULL,
	[ID_WO_PREFIX] [varchar](5) NULL,
	[ID_WO_NO] [varchar](10) NULL,
	[ID_JOB_ID] [int] NULL,
	[ID_WOITEM_SEQ] [int] NULL,
	[FIXED_PRICE] [decimal](20, 5) NULL,
	[FIXED_PRICE_VAT] [decimal](20, 5) NULL,
	[JOBSUM] [decimal](13, 2) NULL,
	[INVOICESUM] [decimal](13, 2) NULL,
	[CALCULATEDFROM] [decimal](13, 2) NULL,
	[FINDVAT] [decimal](13, 2) NULL,
	[VAT_TRANSFER] [varchar](50) NULL,
	[VATAMOUNT] [decimal](13, 2) NULL,
	[DISC_PERCENT] [decimal](13, 2) NULL,
	[DEL_QTY] [decimal](13, 2) NULL,
	[ID_WOLAB_SEQ] [int] NULL,
	[ID_INV_NO] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_DEB_INV_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TBL_INVOI__DEBTO__45A28A95]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INVOICE_DATA]'))
ALTER TABLE [dbo].[TBL_INVOICE_DATA]  WITH CHECK ADD FOREIGN KEY([DEBTOR_SEQ])
REFERENCES [dbo].[TBL_WO_DEBITOR_DETAIL] ([ID_DBT_SEQ])
GO

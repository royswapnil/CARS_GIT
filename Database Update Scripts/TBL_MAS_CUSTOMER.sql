USE [CARSDEV]
GO

/****** Object:  Table [dbo].[TBL_MAS_CUSTOMER]    Script Date: 11.03.2016 11:14:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TBL_MAS_CUSTOMER](
	[ID_CUSTOMER] [varchar](10) NOT NULL,
	[CUST_NAME] [varchar](100) NOT NULL,
	[CUST_GEN_TYPE] [char](1) NULL,
	[ID_CUST_GROUP] [int] NULL,
	[CUST_CONTACT_PERSON] [varchar](50) NULL,
	[ID_CUST_REG_CD] [varchar](10) NULL,
	[ID_CUST_PC_CODE] [varchar](10) NULL,
	[ID_CUST_DISC_CD] [varchar](10) NULL,
	[CUST_SSN_NO] [varchar](20) NULL,
	[CUST_DRIV_LICNO] [varchar](20) NULL,
	[CUST_PHONE_OFF] [varchar](20) NULL,
	[CUST_PHONE_HOME] [varchar](20) NULL,
	[CUST_PHONE_MOBILE] [varchar](20) NULL,
	[CUST_FAX] [varchar](20) NULL,
	[CUST_ID_EMAIL] [varchar](60) NULL,
	[CUST_REMARKS] [varchar](500) NULL,
	[CUST_PERM_ADD1] [varchar](50) NULL,
	[CUST_PERM_ADD2] [varchar](50) NULL,
	[ID_CUST_PERM_ZIPCODE] [varchar](10) NULL,
	[CUST_BILL_ADD1] [varchar](50) NULL,
	[CUST_BILL_ADD2] [varchar](50) NULL,
	[ID_CUST_BILL_ZIPCODE] [varchar](10) NULL,
	[CUST_ACCOUNT_NO] [varchar](20) NULL,
	[ID_CUST_PAY_TYPE] [varchar](10) NULL,
	[ID_CUST_CURRENCY] [int] NULL,
	[CUST_CREDIT_LIMIT] [decimal](13, 2) NULL,
	[CUST_UNUTIL_CREDIT] [decimal](13, 2) NULL,
	[ID_CUST_WARN] [varchar](10) NULL,
	[ID_CUST_PAY_TERM] [int] NULL,
	[FLG_CUST_INACTIVE] [bit] NULL,
	[FLG_CUST_ADV] [bit] NULL,
	[FLG_CUST_FACTORING] [bit] NULL,
	[FLG_CUST_BATCHINV] [bit] NULL,
	[FLG_CUST_NOCREDIT] [bit] NULL,
	[CREATED_BY] [varchar](20) NOT NULL,
	[DT_CREATED] [datetime] NOT NULL,
	[MODIFIED_BY] [varchar](20) NULL,
	[DT_MODIFIED] [datetime] NULL,
	[CUST_BALANCE] [decimal](13, 2) NULL,
	[IsSameAddress] [bit] NULL,
	[IsExported] [bit] NULL,
	[CUST_HOURLYPRICE] [decimal](9, 2) NULL,
	[COSTPRICE] [decimal](12, 5) NULL,
	[CUST_GARAGEMAT] [decimal](9, 2) NULL,
	[CUST_SUB] [int] NULL,
	[CUST_DEP] [int] NULL,
	[CUST_INV_EMAIL] [varchar](200) NULL,
	[CUST_FIRST_NAME] [varchar](50) NULL,
	[CUST_MIDDLE_NAME] [varchar](50) NULL,
	[CUST_LAST_NAME] [varchar](50) NULL,
	[CUST_COUNTRY] [varchar](50) NULL,
	[CUST_VISIT_ADDRESS] [varchar](50) NULL,
	[CUST_MAIL_ADDRESS] [varchar](50) NULL,
	[CUST_PHONE_ALT] [varchar](20) NULL,
	[CUST_HOMEPAGE] [varchar](150) NULL,
	[CUST_NOTES] [varchar](1000) NULL,
	[FLG_PRIVATE_COMP] [bit] NULL,
	[FLG_EINVOICE] [bit] NULL,
	[FLG_ORDCONF_EMAIL] [bit] NULL,
	[FLG_COSTPRICE] [bit] NULL,
	[FLG_CUST_IGNOREINV] [bit] NULL,
	[FLG_INV_EMAIL] [bit] NULL,
	[FLG_NO_SMS] [bit] NULL,
	[FLG_NO_MARKETING] [bit] NULL,
	[FLG_NO_HUMANEORG] [bit] NULL,
	[FLG_NO_PHONESALE] [bit] NULL,
	[FLG_NO_EMAIL] [bit] NULL,
	[FLG_NO_GM] [bit] NULL,
	[FLG_NO_ENV_FEE] [bit] NULL,
	[FLG_PROSPECT] [bit] NULL,
	[CUST_DISC_GENERAL] [int] NULL,
	[CUST_DISC_LABOUR] [int] NULL,
	[CUST_DISC_SPARES] [int] NULL,
	[CUST_NO_EMPLOYEES] [int] NULL,
	[CUST_ENIRO_ID] [varchar](50) NULL,
	[DT_CUST_BORN] [date] NULL,
	[CUST_COMPANY_NO] [varchar](50) NULL,
	[CUST_COMPANY_DESCRIPTION] [varchar](100) NULL,
 CONSTRAINT [PK_TBL_MAS_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[ID_CUSTOMER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] ADD  CONSTRAINT [DF__TBL_MAS_C__CUST___52BDF375]  DEFAULT ((0)) FOR [CUST_BALANCE]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] ADD  CONSTRAINT [DF_TBL_MAS_CUSTOMER_IsSameAddress]  DEFAULT ((0)) FOR [IsSameAddress]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] ADD  CONSTRAINT [DF_TBL_MAS_CUSTOMER_IsExported]  DEFAULT ((0)) FOR [IsExported]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_CONFIG_DETAILS] FOREIGN KEY([ID_CUST_CURRENCY])
REFERENCES [dbo].[TBL_MAS_CONFIG_DETAILS] ([ID_PARAM])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_CONFIG_DETAILS]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_CUST_GROUP] FOREIGN KEY([ID_CUST_GROUP])
REFERENCES [dbo].[TBL_MAS_CUST_GROUP] ([ID_CUST_GRP_SEQ])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_CUST_GROUP]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_CUSTOMER] FOREIGN KEY([ID_CUST_PAY_TERM])
REFERENCES [dbo].[TBL_MAS_CUST_PAYTERMS] ([ID_PT_SEQ])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_CUSTOMER]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS] FOREIGN KEY([ID_CUST_REG_CD])
REFERENCES [dbo].[TBL_MAS_SETTINGS] ([ID_SETTINGS])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS1] FOREIGN KEY([ID_CUST_PC_CODE])
REFERENCES [dbo].[TBL_MAS_SETTINGS] ([ID_SETTINGS])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS1]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS2] FOREIGN KEY([ID_CUST_DISC_CD])
REFERENCES [dbo].[TBL_MAS_SETTINGS] ([ID_SETTINGS])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS2]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS3] FOREIGN KEY([ID_CUST_PAY_TYPE])
REFERENCES [dbo].[TBL_MAS_SETTINGS] ([ID_SETTINGS])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS3]
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS4] FOREIGN KEY([ID_CUST_WARN])
REFERENCES [dbo].[TBL_MAS_SETTINGS] ([ID_SETTINGS])
GO

ALTER TABLE [dbo].[TBL_MAS_CUSTOMER] CHECK CONSTRAINT [FK_TBL_MAS_CUSTOMER_TBL_MAS_SETTINGS4]
GO


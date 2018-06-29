GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTOMER_INSERT]    Script Date: 12/15/2015 1:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Thomas Won Nyheim (TWN)
-- Create date: 2015/01/10
-- Modified:	2015/12/02 TWN - Added new columns FLG_NO_GM and FLG_NO_ENV_FEE
--				2016/10/17 TWN - Added check for existing customer ID
-- Description:	Inserts customer details
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'USP_CUSTOMER_INSERT')
   exec('CREATE PROCEDURE [dbo].[USP_CUSTOMER_INSERT] AS BEGIN SET NOCOUNT ON; END')
GO


ALTER PROCEDURE [dbo].[USP_CUSTOMER_INSERT] 
(
	@ID_CUSTOMER			varchar(10)		= NULL, -- IF NULL CREATE NEW 
    @CUST_NAME				varchar(100)	, -- Required, Combined FIRST_NAME + MIDDLE_NAME + LAST_NAME
    @CUST_GEN_TYPE			char(1)			= NULL,
    @ID_CUST_GROUP			int				= NULL,
    @CUST_CONTACT_PERSON    varchar(50)		= NULL,
    @ID_CUST_REG_CD			varchar(10)		= NULL,
    @ID_CUST_PC_CODE		varchar(10)		= NULL,
    @ID_CUST_DISC_CD		varchar(10)		= NULL,
    @CUST_SSN_NO			varchar(20)		= NULL,
    @CUST_DRIV_LICNO		varchar(20)		= NULL,
    @CUST_PHONE_OFF			varchar(20)		= NULL,
    @CUST_PHONE_HOME		varchar(20)		= NULL,
    @CUST_PHONE_MOBILE		varchar(20)		= NULL,
    @CUST_FAX				varchar(20)		= NULL,
    @CUST_ID_EMAIL			varchar(60)		= NULL,
    @CUST_REMARKS			varchar(500)	= NULL,
    @CUST_PERM_ADD1			varchar(50)		= NULL,
    @CUST_PERM_ADD2			varchar(50)		= NULL,
    @ID_CUST_PERM_ZIPCODE	varchar(10)		= NULL,
    @CUST_BILL_ADD1			varchar(50)		= NULL,
    @CUST_BILL_ADD2			varchar(50)		= NULL,
    @ID_CUST_BILL_ZIPCODE	varchar(10)		= NULL,
    @CUST_ACCOUNT_NO		varchar(20)		= NULL,
    @ID_CUST_PAY_TYPE		varchar(10)		= NULL,
    @ID_CUST_CURRENCY		int				= NULL,
    @CUST_CREDIT_LIMIT		decimal(13,2)	= NULL,
    @CUST_UNUTIL_CREDIT		decimal(13,2)	= NULL,
    @ID_CUST_WARN			varchar(10)		= NULL,
    @ID_CUST_PAY_TERM		int				= NULL,
    @FLG_CUST_INACTIVE		bit				= 0,
    @FLG_CUST_ADV			bit				= 0,
    @FLG_CUST_FACTORING		bit				= 0,
    @FLG_CUST_BATCHINV		bit				= 0,
    @FLG_CUST_NOCREDIT		bit				= 0,
    @CREATED_BY				varchar(20)		, -- Required
    --@DT_CREATED			datetime		,
    @MODIFIED_BY			varchar(20)		, -- Required
    --@DT_MODIFIED			datetime		,
    @CUST_BALANCE			decimal(13,2)	= 0,
    @IsSameAddress			bit				= 0,
    @IsExported				bit				= 0,
    @CUST_HOURLYPRICE		decimal(9,2)	= NULL,
    @FLG_COSTPRICE			bit				= 0,
    @COSTPRICE				decimal(12,5)	= 0,
    @CUST_GARAGEMAT			decimal(9,2)	= 0,
    @CUST_SUB				int				= NULL,
    @CUST_DEP				int				= NULL,
    @FLG_CUST_IGNOREINV		bit				= 0,
    @FLG_INV_EMAIL			bit				= 0,
    @CUST_INV_EMAIL			varchar(200)	= NULL,
    @CUST_FIRST_NAME		varchar(50)		= NULL,
	@CUST_MIDDLE_NAME		varchar(50)		= NULL,
    @CUST_LAST_NAME			varchar(50)		,
    @CUST_COUNTRY			varchar(50)		= NULL,
    @CUST_VISIT_ADDRESS		varchar(50)		= NULL,
    @CUST_MAIL_ADDRESS		varchar(50)		= NULL,
    @CUST_PHONE_ALT			varchar(20)		= NULL,
    @CUST_HOMEPAGE			varchar(150)	= NULL,
    @FLG_EINVOICE			bit				= 0,
    @FLG_ORDCONF_EMAIL		bit				= 0,
    @FLG_NO_SMS				bit				= 0,
    @FLG_NO_MARKETING		bit				= 0,
    @FLG_NO_HUMANEORG		bit				= 0,
    @FLG_NO_PHONESALE		bit				= 0,
    @FLG_PRIVATE_COMP		bit				= 0,
    @FLG_NO_EMAIL			bit				= 0,
	@FLG_NO_GM				bit				= 0,
	@FLG_NO_ENV_FEE			bit				= 0,
	@FLG_PROSPECT			bit				= 0,
	@CUST_NOTES				varchar(1000)	= NULL,
	@ID_CP					int				= NULL,
	@CUST_DISC_GENERAL		int				= NULL,
	@CUST_DISC_LABOUR		int				= NULL,
	@CUST_DISC_SPARES		int				= NULL,
	@DT_CUST_BORN			date			= NULL,
	@CUST_ENIRO_ID			varchar(50)		= NULL,
	@CUST_COMPANY_DESCRIPTION varchar(100)	= NULL,
	@CUST_COMPANY_NO		varchar(50)		= NULL,
	@RETVAL					varchar(10) OUTPUT,
	@RETCUST				varchar(15) OUTPUT  
)

AS
BEGIN

DECLARE @DT_CREATED DATETIME = getdate()
DECLARE @DT_MODIFIED DATETIME = getdate()
DECLARE @VALIDATE BIT = 1

IF @ID_CUSTOMER IS NULL OR @ID_CUSTOMER = ''
BEGIN
	DECLARE @START_NUM INT =  (SELECT TOP 1 CUST_START_NO FROM TBL_MAS_CUST_CONFIG WHERE DT_EFF_FROM <= GETDATE() ORDER BY DT_EFF_FROM DESC) 
	DECLARE @NEXT_NUM INT = (SELECT TOP 1 t1.ID_CUSTOMER+1 FROM TBL_MAS_CUSTOMER t1 WHERE NOT EXISTS(SELECT * FROM TBL_MAS_CUSTOMER t2 where t2.ID_CUSTOMER = t1.ID_CUSTOMER + 1) and ID_CUSTOMER > @START_NUM ORDER BY CAST(t1.ID_CUSTOMER As INT))
	SET @ID_CUSTOMER = @NEXT_NUM
	IF LEN(@NEXT_NUM) = 0
	BEGIN
		SET @ID_CUSTOMER = @START_NUM
	END
END
PRINT @ID_CUSTOMER
IF LEN(@CUST_LAST_NAME) < 2
BEGIN
	SET @VALIDATE = 0
END

-- Insert Statement if customer does not exist
IF NOT EXISTS (SELECT * FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = @ID_CUSTOMER) AND @VALIDATE = 1 AND LEN(@ID_CUSTOMER) > 0
BEGIN
	INSERT INTO [dbo].[TBL_MAS_CUSTOMER]
				([ID_CUSTOMER]
				,[CUST_NAME]
				,[CUST_GEN_TYPE]
				,[ID_CUST_GROUP]
				,[CUST_CONTACT_PERSON]
				,[ID_CUST_REG_CD]
				,[ID_CUST_PC_CODE]
				,[ID_CUST_DISC_CD]
				,[CUST_SSN_NO]
				,[CUST_DRIV_LICNO]
				,[CUST_PHONE_OFF]
				,[CUST_PHONE_HOME]
				,[CUST_PHONE_MOBILE]
				,[CUST_FAX]
				,[CUST_ID_EMAIL]
				,[CUST_REMARKS]
				,[CUST_PERM_ADD1]
				,[CUST_PERM_ADD2]
				,[ID_CUST_PERM_ZIPCODE]
				,[CUST_BILL_ADD1]
				,[CUST_BILL_ADD2]
				,[ID_CUST_BILL_ZIPCODE]
				,[CUST_ACCOUNT_NO]
				,[ID_CUST_PAY_TYPE]
				,[ID_CUST_CURRENCY]
				,[CUST_CREDIT_LIMIT]
				,[CUST_UNUTIL_CREDIT]
				,[ID_CUST_WARN]
				,[ID_CUST_PAY_TERM]
				,[FLG_CUST_INACTIVE]
				,[FLG_CUST_ADV]
				,[FLG_CUST_FACTORING]
				,[FLG_CUST_BATCHINV]
				,[FLG_CUST_NOCREDIT]
				,[CREATED_BY]
				,[DT_CREATED]
				,[MODIFIED_BY]
				,[DT_MODIFIED]
				,[CUST_BALANCE]
				,[IsSameAddress]
				,[IsExported]
				,[CUST_HOURLYPRICE]
				,[FLG_COSTPRICE]
				,[COSTPRICE]
				,[CUST_GARAGEMAT]
				,[CUST_SUB]
				,[CUST_DEP]
				,[FLG_CUST_IGNOREINV]
				,[FLG_INV_EMAIL]
				,[CUST_INV_EMAIL]
				,[CUST_FIRST_NAME]
				,[CUST_MIDDLE_NAME]
				,[CUST_LAST_NAME]
				,[CUST_COUNTRY]
				,[CUST_VISIT_ADDRESS]
				,[CUST_MAIL_ADDRESS]
				,[CUST_PHONE_ALT]
				,[CUST_HOMEPAGE]
				,[FLG_EINVOICE]
				,[FLG_ORDCONF_EMAIL]
				,[FLG_NO_SMS]
				,[FLG_NO_MARKETING]
				,[FLG_NO_HUMANEORG]
				,[FLG_NO_PHONESALE]
				,[FLG_PRIVATE_COMP]
				,[FLG_NO_EMAIL]
				,[FLG_NO_GM]
				,[FLG_NO_ENV_FEE]
				,[FLG_PROSPECT]
				,[CUST_NOTES]
				,[ID_CP]
				,[CUST_DISC_GENERAL]
				,[CUST_DISC_LABOUR]
				,[CUST_DISC_SPARES]
				,[DT_CUST_BORN]
				,[CUST_ENIRO_ID]
				,[CUST_COMPANY_DESCRIPTION]
				,[CUST_COMPANY_NO])
			VALUES
				(@ID_CUSTOMER,
				@CUST_NAME,
				@CUST_GEN_TYPE,
				@ID_CUST_GROUP,
				@CUST_CONTACT_PERSON,
				@ID_CUST_REG_CD,
				@ID_CUST_PC_CODE,
				@ID_CUST_DISC_CD,
				@CUST_SSN_NO,
				@CUST_DRIV_LICNO,
				@CUST_PHONE_OFF,
				@CUST_PHONE_HOME,
				@CUST_PHONE_MOBILE,
				@CUST_FAX,
				@CUST_ID_EMAIL,
				@CUST_REMARKS,
				@CUST_PERM_ADD1,
				@CUST_PERM_ADD2,
				@ID_CUST_PERM_ZIPCODE,
				@CUST_BILL_ADD1,
				@CUST_BILL_ADD2,
				@ID_CUST_BILL_ZIPCODE,
				@CUST_ACCOUNT_NO,
				@ID_CUST_PAY_TYPE,
				@ID_CUST_CURRENCY,
				@CUST_CREDIT_LIMIT,
				@CUST_UNUTIL_CREDIT,
				@ID_CUST_WARN,
				@ID_CUST_PAY_TERM,
				@FLG_CUST_INACTIVE,
				@FLG_CUST_ADV,
				@FLG_CUST_FACTORING,
				@FLG_CUST_BATCHINV,
				@FLG_CUST_NOCREDIT,
				@CREATED_BY,
				@DT_CREATED,
				@MODIFIED_BY,
				@DT_MODIFIED,
				@CUST_BALANCE,
				@IsSameAddress,
				@IsExported,
				@CUST_HOURLYPRICE,
				@FLG_COSTPRICE,
				@COSTPRICE,
				@CUST_GARAGEMAT,
				@CUST_SUB,
				@CUST_DEP,
				@FLG_CUST_IGNOREINV,
				@FLG_INV_EMAIL,
				@CUST_INV_EMAIL,
				@CUST_FIRST_NAME,
				@CUST_MIDDLE_NAME,
				@CUST_LAST_NAME,
				@CUST_COUNTRY,
				@CUST_VISIT_ADDRESS,
				@CUST_MAIL_ADDRESS,
				@CUST_PHONE_ALT,
				@CUST_HOMEPAGE,
				@FLG_EINVOICE,
				@FLG_ORDCONF_EMAIL,
				@FLG_NO_SMS,
				@FLG_NO_MARKETING,
				@FLG_NO_HUMANEORG,
				@FLG_NO_PHONESALE,
				@FLG_PRIVATE_COMP,
				@FLG_NO_EMAIL,
				@FLG_NO_GM,
				@FLG_NO_ENV_FEE,
				@FLG_PROSPECT,
				@CUST_NOTES,
				@ID_CP,
				@CUST_DISC_GENERAL,
				@CUST_DISC_LABOUR,
				@CUST_DISC_SPARES,
				@DT_CUST_BORN,
				@CUST_ENIRO_ID,
				@CUST_COMPANY_DESCRIPTION,
				@CUST_COMPANY_NO
			)
		SET @RETVAL = 'INSFLG'
END
ELSE IF EXISTS (SELECT * FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = @ID_CUSTOMER) AND @VALIDATE = 1
BEGIN
	UPDATE [dbo].[TBL_MAS_CUSTOMER]
	SET
		--[ID_CUSTOMER] =  @ID_CUSTOMER,
		[CUST_NAME] =  @CUST_NAME,
		[CUST_GEN_TYPE] =  @CUST_GEN_TYPE,
		[ID_CUST_GROUP] =  @ID_CUST_GROUP,
		[CUST_CONTACT_PERSON] =  @CUST_CONTACT_PERSON,
		[ID_CUST_REG_CD] =  @ID_CUST_REG_CD,
		[ID_CUST_PC_CODE] =  @ID_CUST_PC_CODE,
		[ID_CUST_DISC_CD] =  @ID_CUST_DISC_CD,
		[CUST_SSN_NO] =  @CUST_SSN_NO,
		[CUST_DRIV_LICNO] =  @CUST_DRIV_LICNO,
		[CUST_PHONE_OFF] =  @CUST_PHONE_OFF,
		[CUST_PHONE_HOME] =  @CUST_PHONE_HOME,
		[CUST_PHONE_MOBILE] =  @CUST_PHONE_MOBILE,
		[CUST_FAX] =  @CUST_FAX,
		[CUST_ID_EMAIL] =  @CUST_ID_EMAIL,
		[CUST_REMARKS] =  @CUST_REMARKS,
		[CUST_PERM_ADD1] =  @CUST_PERM_ADD1,
		[CUST_PERM_ADD2] =  @CUST_PERM_ADD2,
		[ID_CUST_PERM_ZIPCODE] =  @ID_CUST_PERM_ZIPCODE,
		[CUST_BILL_ADD1] =  @CUST_BILL_ADD1,
		[CUST_BILL_ADD2] =  @CUST_BILL_ADD2,
		[ID_CUST_BILL_ZIPCODE] =  @ID_CUST_BILL_ZIPCODE,
		[CUST_ACCOUNT_NO] =  @CUST_ACCOUNT_NO,
		[ID_CUST_PAY_TYPE] =  @ID_CUST_PAY_TYPE,
		[ID_CUST_CURRENCY] =  @ID_CUST_CURRENCY,
		[CUST_CREDIT_LIMIT] =  @CUST_CREDIT_LIMIT,
		[CUST_UNUTIL_CREDIT] =  @CUST_UNUTIL_CREDIT,
		[ID_CUST_WARN] =  @ID_CUST_WARN,
		[ID_CUST_PAY_TERM] =  @ID_CUST_PAY_TERM,
		[FLG_CUST_INACTIVE] =  @FLG_CUST_INACTIVE,
		[FLG_CUST_ADV] =  @FLG_CUST_ADV,
		[FLG_CUST_FACTORING] =  @FLG_CUST_FACTORING,
		[FLG_CUST_BATCHINV] =  @FLG_CUST_BATCHINV,
		[FLG_CUST_NOCREDIT] =  @FLG_CUST_NOCREDIT,
		--[CREATED_BY] =  @CREATED_BY,
		--[DT_CREATED] =  @DT_CREATED,
		[MODIFIED_BY] =  @MODIFIED_BY,
		[DT_MODIFIED] =  @DT_MODIFIED,
		[CUST_BALANCE] =  @CUST_BALANCE,
		[IsSameAddress] =  @IsSameAddress,
		[IsExported] =  @IsExported,
		[CUST_HOURLYPRICE] =  @CUST_HOURLYPRICE,
		[FLG_COSTPRICE] =  @FLG_COSTPRICE,
		[COSTPRICE] =  @COSTPRICE,
		[CUST_GARAGEMAT] =  @CUST_GARAGEMAT,
		[CUST_SUB] =  @CUST_SUB,
		[CUST_DEP] =  @CUST_DEP,
		[FLG_CUST_IGNOREINV] =  @FLG_CUST_IGNOREINV,
		[FLG_INV_EMAIL] =  @FLG_INV_EMAIL,
		[CUST_INV_EMAIL] =  @CUST_INV_EMAIL,
		[CUST_FIRST_NAME] =  @CUST_FIRST_NAME,
		[CUST_MIDDLE_NAME] =  @CUST_MIDDLE_NAME,
		[CUST_LAST_NAME] =  @CUST_LAST_NAME,
		[CUST_COUNTRY] =  @CUST_COUNTRY,
		[CUST_VISIT_ADDRESS] =  @CUST_VISIT_ADDRESS,
		[CUST_MAIL_ADDRESS] =  @CUST_MAIL_ADDRESS,
		[CUST_PHONE_ALT] =  @CUST_PHONE_ALT,
		[CUST_HOMEPAGE] =  @CUST_HOMEPAGE,
		[FLG_EINVOICE] =  @FLG_EINVOICE,
		[FLG_ORDCONF_EMAIL] =  @FLG_ORDCONF_EMAIL,
		[FLG_NO_SMS] =  @FLG_NO_SMS,
		[FLG_NO_MARKETING] =  @FLG_NO_MARKETING,
		[FLG_NO_HUMANEORG] =  @FLG_NO_HUMANEORG,
		[FLG_NO_PHONESALE] =  @FLG_NO_PHONESALE,
		[FLG_PRIVATE_COMP] =  @FLG_PRIVATE_COMP,
		[FLG_NO_EMAIL] =  @FLG_NO_EMAIL,
		[FLG_NO_GM] = @FLG_NO_GM,
		[FLG_NO_ENV_FEE] = @FLG_NO_ENV_FEE,
		[CUST_NOTES] = @CUST_NOTES,
		[FLG_PROSPECT] = @FLG_PROSPECT,
		[ID_CP] = @ID_CP,
		[CUST_DISC_GENERAL] = @CUST_DISC_GENERAL,
		[CUST_DISC_LABOUR] = @CUST_DISC_LABOUR,
		[CUST_DISC_SPARES] = @CUST_DISC_SPARES,
		[DT_CUST_BORN] = @DT_CUST_BORN,
		[CUST_ENIRO_ID] = @CUST_ENIRO_ID,
		[CUST_COMPANY_DESCRIPTION] = @CUST_COMPANY_DESCRIPTION,
		[CUST_COMPANY_NO] = @CUST_COMPANY_NO				
	WHERE 
		ID_CUSTOMER = @ID_CUSTOMER
	SET @RETVAL = 'UPDFLG'
	END
	SET @RETCUST = @ID_CUSTOMER
END
IF @VALIDATE = 0
BEGIN
 SET @RETVAL = 'ERRFLG'
END

PRINT @RETVAL
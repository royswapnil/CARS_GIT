/****** Object:  StoredProcedure [dbo].[USP_FETCH_INVOICEJOURNAL]    Script Date: 1/8/2018 1:26:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_INVOICEJOURNAL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_INVOICEJOURNAL]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_INVOICEJOURNAL]    Script Date: 1/8/2018 1:26:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_INVOICEJOURNAL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_INVOICEJOURNAL] AS' 
END
GO

/*************************************** APPLICATION: MSG *************************************************************                                              
* MODULE : DEBTOR                                              
* FILE NAME : USP_FETCH_INVOICEJOURNAL.PRC                                              
* PURPOSE   : TO FETCH INVOICE JOURNAL FROM INVOICE(HEADER,DETAIL,LINES,LABOUR,VAT).                                               
* AUTHOR    : SUBRAMANIAN                                           
* DATE      : 03-12-2007                                            
*********************************************************************************************************************/                                              
/*********************************************************************************************************************                                               
I/P : -- INPUT PARAMETERS                                              
O/P :-- OUTPUT PARAMETERS                                              
ERROR CODE                                              
DESCRIPTION

********************************************************************************************************************/                                              
--'*********************************************************************************'*********************************                                              
--'* MODIFIED HISTORY :                                                 
--'* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION                                               
--*#0001#                                              
--'*********************************************************************************'*********************************                                  
-- *************************************  
-- Modified Date: 15th July 2009  
-- Invoice no size is increased to varchar(10) to varchar(50) and voucher text to 50 to 100  
-----------------------------------------------------
--Author :  Praveen K         
--Modified Date : 13/08/13       
--Description: Row 638 Transaction Rounding Issue and Discount issue
------------------------------------------------------   
ALTER PROCEDURE [dbo].[USP_FETCH_INVOICEJOURNAL]                                         
(                                
 @INV_SUBSIDIARY INT   = -1,                                
 @INV_DEPT NTEXT    = '<ROOT><INVNO ID_DEPT="3"/></ROOT>',                                
 @INV_STATRTDATE DATETIME = '09/11/2008',                                
 @INV_ENDDATE DATETIME  = '09/13/2008',   
 @TEMPLATE_ID INT,   
 @CREATED_BY VARCHAR(20)  = 'ADMIN',   
 @EXPTYPE VARCHAR(5) = NULL,   
 @ISGROUP BIT = 0   
)                                              
AS  
BEGIN                                                
 BEGIN TRY                                

	 DECLARE @IDOC AS INT   
  DECLARE @DEPT TABLE   
  (                                
   ID_DEPT INT                                
  )                                                                                                       
        EXEC SP_XML_PREPAREDOCUMENT @IDOC OUTPUT,@INV_DEPT   
  INSERT INTO @DEPT                                                                                                      
   SELECT                                                                                   
    ID_DEPT                                
   FROM                                                                                                      
    OPENXML(@IDOC,'ROOT/INVNO',1)                                                                                                      
    WITH (  ID_DEPT INT  )                                                                                                     
            
  EXEC SP_XML_REMOVEDOCUMENT @IDOC                     
                
  DECLARE @INVOICEJOURNAL TABLE                
  (                
	ACCMATRIXSLNO INT, 
	LA_FLG_CRE_DEB BIT, 
	ACCOUNTNO  VARCHAR(50), 
	DEPT_ACCOUNT_NO VARCHAR(50), 
	DIMENSION  VARCHAR(50), 
	LA_CUST_ACCCODE VARCHAR(20), 
	-- ******************************* 
	-- Modified Date : 27th April 2009 
	-- Bug ID   : 4881 
	--   LA_DEPT_ACCCODE VARCHAR(20), 
	LA_DEPT_ACCCODE VARCHAR(60), 
	-- *********** End Of Modification *** 
	LA_SaleAccCode VARCHAR(20), 
	LA_SALEDESCRIPTION VARCHAR(30), 
	LA_DESCRIPTION VARCHAR(50), 
	PROJECT VARCHAR(50), 
	LA_VAT_CODE INT 
  ) 

 DECLARE  @CustGrp TABLE  
 (  
   ID_Cust_Grp INT  
 )  
  
 INSERT INTO @CustGrp  
  SELECT   
    DISTINCT ID_CUST_GRP  
  FROM  
   TBL_LA_ACCOUNT_MATRIX MATRIX  
  INNER JOIN  
   TBL_MAS_CUST_GROUP CUST_GRP  
  ON  
   MATRIX.LA_CUST_ACCCODE=CUST_GRP.Cust_AccCode  
       
                
  DECLARE @ERROR_ACCOUNT_CODE AS VARCHAR(50)                      
   SELECT TOP 1 @ERROR_ACCOUNT_CODE= Error_Acc_Code FROM  TBL_LA_CONFIG_ACC_CODE ORDER BY ID_SEQ DESC                   
                
  DECLARE @STARTDATE AS  VARCHAR(50)                
  DECLARE @ENDDATE AS  VARCHAR(50)                
                  
  SET @STARTDATE = ISNULL(@INV_STATRTDATE,CONVERT(CHAR(10),(SELECT MIN(DT_INVOICE) FROM TBL_INV_HEADER),101))                
  SET @ENDDATE = ISNULL(@INV_ENDDATE,CONVERT(CHAR(10),(SELECT MAX(DT_INVOICE) FROM TBL_INV_HEADER),101))                  
                
  DECLARE @DEPTCOUNT AS INT                                
  SELECT @DEPTCOUNT = COUNT(*) FROM  @DEPT WHERE ID_DEPT IS NOT NULL                
  IF @DEPTCOUNT = 0
    BEGIN                
		IF @INV_SUBSIDIARY = -1                
		BEGIN
			INSERT INTO @DEPT                
				SELECT Distinct ID_DEPT FROM TBL_MAS_DEPT -- WHERE (ID_SUBSIDERY_DEPT = @INV_SUBSIDIARY) OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228  
		END
		ELSE
		BEGIN
			INSERT INTO @DEPT                
				SELECT ID_DEPT FROM TBL_MAS_DEPT WHERE (ID_SUBSIDERY_DEPT = @INV_SUBSIDIARY) -- OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228  
				
		END
	END
	
	                
  --FETCHING LAST TRANSACTION ID                   
   DECLARE @TRANSRES AS INT, @CNTRANSRES AS INT                            
   SELECT @TRANSRES = MAX(CONVERT(INT,INV_TRANSACTIONID)) FROM TBL_INV_HEADER WHERE INV_TRANSACTIONID!=''''                           
   SELECT @CNTRANSRES = MAX(CONVERT(INT,CN_TRANSACTIONID)) FROM TBL_INV_HEADER WHERE CN_TRANSACTIONID IS NOT NULL
             
    IF @TRANSRES is null                        
    BEGIN                        
     SET @TRANSRES = 1                        
    END                        
    ELSE IF @TRANSRES is not null                        
    BEGIN
		IF ISNULL(@CNTRANSRES, 0) > @TRANSRES 
			SET @TRANSRES = @CNTRANSRES
           
		SET @TRANSRES = @TRANSRES + 1                          
    END                        
  
  IF @INV_SUBSIDIARY <> -1  
	SELECT @EXPTYPE = TransferMethod FROM TBL_MAS_SUBSIDERY WHERE ID_Subsidery = @INV_SUBSIDIARY  
  
  IF @EXPTYPE IS NULL  
	SET @EXPTYPE = 'NET'  
  
  SELECT TOP 1 @ISGROUP =   
	 CASE WHEN FLG_GROUPING = 'I' THEN   
	  0  
	 ELSE  
	  1  
	 END    
  FROM TBL_LA_CONFIG   
  ORDER BY DT_CREATED DESC   
  
  IF @ISGROUP IS NULL   
	SET @ISGROUP = 0   
  
  --LABOUR                 
  DECLARE @LABOUR TABLE                                
  (                                
	 ID_INV_NO VARCHAR(50),   
	 DATE_INVOICE DATETIME,   
	 INV_CUST_GROUP VARCHAR(100),   
	 DEPT_ACC_CODE VARCHAR(100),   
	 INVOICETYPE VARCHAR(20),   
	 ACCMATRIXTYPE VARCHAR(20),   
	 INVL_ACCCODE VARCHAR(20),   
	 INVOICE_AMT NUMERIC(15,2),   
	 INVOICE_VAT_PER NUMERIC(5,2),   
	 INVOICE_PREFIX VARCHAR(20),   
	 INVOICE_NO VARCHAR(50),   
	 INVOICE_TRANSACTIONID VARCHAR(25),   
	 INVOICE_TRANSACTIONDATE DATETIME,   
	 ID_DEPT_INV INT,   
	 CUST_ACCCODE VARCHAR(20),   
	  
	 TEXTCODE VARCHAR(50),   
	 VOUCHER_TEXT VARCHAR(100),   
	 EXT_VAT_CODE CHAR(1),   
	 DUE_DATE VARCHAR(20),   
	 CUST_ID VARCHAR(50),   
	 CUST_NO INT,   
	 CUST_NAME VARCHAR(100),   
	 CUST_ADDR1 VARCHAR(50),   
	 CUST_ADDR2 VARCHAR(50),   
	 CUST_POST_CODE VARCHAR(10),   
	 CUST_PLACE VARCHAR(50),   
	 CUST_PHONE VARCHAR(20),   
	 CUST_FAX VARCHAR(20),   
	 CUST_CREDIT_LIMIT NUMERIC(15,2),   
	 CUST_PAYTERM VARCHAR(20),   
	 CUST_GROUP VARCHAR(20),
	 ID_CN_NO VARCHAR(15), 
	 LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT,
	 ID_JOB INT ,
	 ID_WO_NO INT,
	 ID_WO_PREFIX VARCHAR(5),
	 ID_Mech varchar(50) 
  )                
     
/*	 --LABOUR - SELLING -- FOR NON-MECHANICALS               
  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech
   )                
   SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOUR'                
    ,'SELLING'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
						isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
			ELSE
						isnull(INVDT.LINE_AMOUNT_NET,0)
			END
	,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	 ,@TRANSRES                
		,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
		,ID_Dept_Inv                
		,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))  
	  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX
   INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='LABOUR'
	and id.ID_WO_NO = INVDT.ID_WO_NO AND id.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 	AND ih.ID_DEBITOR = INVDT.DEBTOR_ID  AND id.id_job = INVDT.ID_JOB_ID                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )              
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND WH.WO_TYPE_WOH='ORD'
   
   
   -------------------------------------************************LABOUR COST(NON-MECHANICS) ROW 274 - START

INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech
   )                
   SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOUR'                
    ,'COST'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,
	abs(CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
			CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
				(WOD.WO_TOT_LAB_AMT * WOD.WO_LBR_VATPER/100) 
			 ELSE
				-- FAZAL
				--(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT  * (WODEB.DBT_PER/100)) - (WOD.WO_TOT_LAB_AMT * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)--(WOD.WO_LBR_VATPER/100)) Modified :30/03/2010
				(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + 
				(((WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)
				-- END
			END
		ELSE  
			WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100) 
		END  
	ELSE
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
			CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
				(WOD.WO_TOT_LAB_AMT_FP * WOD.WO_LBR_VATPER/100) 
			 ELSE
				--(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT  * (WODEB.DBT_PER/100)) - (WOD.WO_TOT_LAB_AMT * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)--(WOD.WO_LBR_VATPER/100)) Modified :30/03/2010
				(WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WODEB.DEBTOR_VAT_PERCENTAGE/100) ELSE (WODEB.WO_LBR_VATPER/100) END)
			END
		ELSE  
			WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100) 
		END 
	END)
	-- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
                         
	 ,@TRANSRES                
		,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
		,ID_Dept_Inv                
		,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))  
	  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE  --commented for due date 2
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )              
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
--   AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
   AND ISNULL(cg.USE_INTCUST,0)=1
   AND WH.WO_TYPE_WOH='ORD'
-------------------------------------************************LABOUR COST(NON-MECHANICS) ROW 274 - END	
   

	--LABOUR - DISCOUNT LINES -- FOR NON-MECHANICALS 
	 INSERT INTO @LABOUR                
    (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED ,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech 
    )                
	SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOUR'                
    ,'DISCOUNT'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,isnull(INVDT.LINE_DISCOUNT,0)
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
      ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
	 END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE   
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX 
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='LABOUR'
	and id.ID_WO_NO = INVDT.ID_WO_NO AND id.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 	AND ih.ID_DEBITOR = INVDT.DEBTOR_ID  AND id.id_job = INVDT.ID_JOB_ID
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
   --AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) 
   --AND WODEB.DBT_AMT <> 0 
   AND WH.WO_TYPE_WOH='ORD'


-------------VA ORDERS - START
     --LABOUR - SELLING -- FOR NON-MECHANICALS               
  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech
   )                
   SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'VASELLING'                
    ,'SELLING'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,
	CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
			CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
				(WOD.WO_TOT_LAB_AMT * WOD.WO_LBR_VATPER/100) 
			 ELSE
				-- FAZAL
				--(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT  * (WODEB.DBT_PER/100)) - (WOD.WO_TOT_LAB_AMT * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)--(WOD.WO_LBR_VATPER/100)) Modified :30/03/2010
				(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + 
				(((WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)
				-- END
			END
		ELSE  
			WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100) 
		END  
	ELSE
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			--ISNULL(id.INVD_FIXEDAMT *  WODEB.DBT_PER/100,0) + (id.INVD_FIXEDAMT * WOD.WO_LBR_VATPER/100)  Changed since Fixed Amount is stored after split in invoice table
			/*CHANGE FOR OWNER PAY VAT AND FIXED PRICE*/
			CASE WHEN WOD.WO_OWN_PAY_VAT=1  THEN
				CASE WHEN IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND WODEB.DBT_PER=0 THEN
					ISNULL(id.INVD_FIXEDAMT * 
						CASE WHEN WODEB.WO_FIXED_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_FIXED_VATPER/100) END,0)
				ELSE
					CASE WHEN IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND WODEB.DBT_PER<>0 and ih.ID_DEBITOR=WOD.WO_OWN_CR_CUST THEN
						ISNULL(id.INVD_FIXEDAMT,0) + (WOD.WO_FIXED_PRICE*WOD.WO_VAT_PERCENTAGE/100)
					else
						ISNULL(id.INVD_FIXEDAMT,0)
					end					
				END
			ELSE
				ISNULL(id.INVD_FIXEDAMT,0) + (ISNULL(id.INVD_FIXEDAMT,0) * WOD.WO_LBR_VATPER/100)
			END
		ELSE  
			--ISNULL(id.INVD_FIXEDAMT *  WODEB.DBT_PER/100,0) --id.INVD_FIXEDAMT   Changed since Fixed Amount is stored after split in invoice table
			ISNULL(id.INVD_FIXEDAMT,0) 
		END 
	END
	-- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
                    
	 ,@TRANSRES                
		,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
		,ID_Dept_Inv                
		,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())))) 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))  
	  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE 
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )              
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
--   AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND WH.WO_TYPE_WOH='CRSL'
   
   
   -------------------------------------************************LABOUR COST(NON-MECHANICS) ROW 274 - START

INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech
   )                
   SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'VASELLING'                
    ,'COST'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,
	abs(CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
			CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
				(WOD.WO_TOT_LAB_AMT * WOD.WO_LBR_VATPER/100) 
			 ELSE
				-- FAZAL
				--(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT  * (WODEB.DBT_PER/100)) - (WOD.WO_TOT_LAB_AMT * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)--(WOD.WO_LBR_VATPER/100)) Modified :30/03/2010
				(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + 
				(((WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)
				-- END
			END
		ELSE  
			WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100) 
		END  
	ELSE
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			--ISNULL(id.INVD_FIXEDAMT *  WODEB.DBT_PER/100,0) + (id.INVD_FIXEDAMT * WOD.WO_LBR_VATPER/100)  Changed since Fixed Amount is stored after split in invoice table
			/*CHANGE FOR OWNER PAY VAT AND FIXED PRICE*/
			CASE WHEN WOD.WO_OWN_PAY_VAT=1  THEN
				CASE WHEN IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND WODEB.DBT_PER=0 THEN
					ISNULL(id.INVD_FIXEDAMT * 
						CASE WHEN WODEB.WO_FIXED_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_FIXED_VATPER/100) END,0)
				ELSE
					CASE WHEN IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND WODEB.DBT_PER<>0 and ih.ID_DEBITOR=WOD.WO_OWN_CR_CUST THEN
						ISNULL(id.INVD_FIXEDAMT,0) + (WOD.WO_FIXED_PRICE*WOD.WO_VAT_PERCENTAGE/100)
					else
						ISNULL(id.INVD_FIXEDAMT,0)
					end					
				END
			ELSE
				ISNULL(id.INVD_FIXEDAMT,0) + (ISNULL(id.INVD_FIXEDAMT,0) * WOD.WO_LBR_VATPER/100)
			END
		ELSE  
			--ISNULL(id.INVD_FIXEDAMT *  WODEB.DBT_PER/100,0) --id.INVD_FIXEDAMT   Changed since Fixed Amount is stored after split in invoice table
			ISNULL(id.INVD_FIXEDAMT,0) 
		END 
	END)
	-- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
                         
	 ,@TRANSRES                
		,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
		,ID_Dept_Inv                
		,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())))) 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))  
	  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE  
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )              
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
--   AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
   AND ISNULL(cg.USE_INTCUST,0)=1
   AND WH.WO_TYPE_WOH='CRSL'
-------------------------------------************************LABOUR COST(NON-MECHANICS) ROW 274 - END	
   

	--LABOUR - DISCOUNT LINES -- FOR NON-MECHANICALS 
	 INSERT INTO @LABOUR                
    (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED ,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech 
    )                
	SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'VASELLING'                
    ,'DISCOUNT'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
    ,
	abs(CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
	    ((WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) * WO_DISCOUNT/100) 
	ELSE
		0 
	END) 
 -- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
                         
	,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
	 --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))  
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
	 END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE commented for due date 2
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
   --AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) 
   --AND WODEB.DBT_AMT <> 0 
   AND WH.WO_TYPE_WOH='CRSL'

-------------VA ORDERS - END
/***************************----LABOUR EDITED FOR NEW FIXED PRICE CHANGE ROW 475 START ************************/ 

     --LABOUR - SELLING -- FOR NON-MECHANICALS               
  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech
   )                
   SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOURDIFF'                
    ,'SELLING'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,
	CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		0  
	ELSE
	CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,WOD.ID_WO_PREFIX,WOD.ID_WO_NO,wod.id_job) =0 THEN 0
     ELSE
		(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
			CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
				((WOD.WO_TOT_LAB_AMT_FP- ((WOD.WO_TOT_LAB_AMT_FP) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * WOD.WO_LBR_VATPER/100)  -- Row 722
			 ELSE
				--(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT  * (WODEB.DBT_PER/100)) - (WOD.WO_TOT_LAB_AMT * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)--(WOD.WO_LBR_VATPER/100)) Modified :30/03/2010
				--(WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)
			(WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) 
					* 
					CASE WHEN (WODEB.WO_LBR_VATPER=1.00) or (WODEB.WO_LBR_VATPER=0 AND WODEB.DBT_PER<>0 AND WODEB.DBT_PER<100) THEN 
						(WODEB.DEBTOR_VAT_PERCENTAGE/100) 
					ELSE 
						(WODEB.WO_LBR_VATPER/100) END)
			END
		ELSE  
			WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100) 
		END  ) 
			*		(CASE WHEN wod.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
		ELSE 
			CASE WHEN wod.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
					(wod.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE+(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)
		--* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END)) 
	END
	END
	-- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	 ,@TRANSRES                
		,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
		,ID_Dept_Inv                
		,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())))) 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))  
	  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE  Commented for due date 2 
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )              
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
--   AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND WH.WO_TYPE_WOH='ORD'
	AND WOD.WO_FIXED_PRICE <>0 AND (ISNULL(WOD.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(WOD.WO_TOT_VAT_AMT_FP,0)>0) 
	--AND ISNULL(WOD.WO_OWN_RISK_AMT,0)=0
   
   -------------------------------------************************LABOUR COST(NON-MECHANICS) ROW 274 - START

INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech
   )                
   SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOURDIFF'                
    ,'COST'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
	,
	CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
		0
	ELSE
	abs(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
			CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
				(WOD.WO_TOT_LAB_AMT_FP * WOD.WO_LBR_VATPER/100) 
			 ELSE
				--(WOD.WO_TOT_LAB_AMT * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT  * (WODEB.DBT_PER/100)) - (WOD.WO_TOT_LAB_AMT * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)--(WOD.WO_LBR_VATPER/100)) Modified :30/03/2010
				(WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) + (((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) - ((WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) * (ISNULL(WOD.WO_DISCOUNT, 0)/100))) * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)
			END
		ELSE  
			WOD.WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100) 
		END) * (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))
	END
	-- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
                         
	 ,@TRANSRES                
		,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
		,ID_Dept_Inv                
		,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())))) 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))  
	  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE  --commented for due date 2
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )              
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
--   AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
   AND ISNULL(cg.USE_INTCUST,0)=1
   AND WH.WO_TYPE_WOH='ORD'
-------------------------------------************************LABOUR COST(NON-MECHANICS) ROW 274 - END	
   

	--LABOUR - DISCOUNT LINES -- FOR NON-MECHANICALS 
	 INSERT INTO @LABOUR                
    (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED ,ID_JOB,ID_WO_NO,ID_WO_PREFIX,ID_Mech 
    )                
	SELECT  distinct                
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOURDIFF'                
    ,'DISCOUNT'                
    ,null --INVL_LABOUR_ACCOUNTCODE							--Account Code
    ,CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
		0
	ELSE
	CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,WOD.ID_WO_PREFIX,WOD.ID_WO_NO,wod.id_job) =0 THEN 0
     ELSE
		abs(
		CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
			0 -- Row 722
		else	
			((WO_TOT_LAB_AMT_FP * (WODEB.DBT_PER/100)) * WO_DISCOUNT/100) 
		end)
			*		(CASE WHEN wod.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
		ELSE 
			CASE WHEN wod.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE+(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)
		--* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END)) 
	END 
	END 
 -- ************* End Of Modification ***********************           
    ,null -- ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER				-- vat percentage
      ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
	 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
	 --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))  
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
	 END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,null--dbo.FnGetExtVATByVAT(idl.WO_GM_VAT) AS EXT_VAT_CODE					-- vat code
	 --,'00.00.0000' AS DUE_DATE   
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX 
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 ,'LABOUR'
   FROM  TBL_INV_HEADER ih                
   INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO                
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   INNER JOIN TBL_MAS_DEPT md                
   ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg                
   ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    and  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL    --AND ih.ID_INV_NO='FK12098'
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
   AND WOD.FLG_CHRG_STD_TIME=1  
   --AND WOD.ID_WODET_SEQ NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR)
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) 
   --AND WODEB.DBT_AMT <> 0 
   AND WH.WO_TYPE_WOH='ORD'
	AND WOD.WO_FIXED_PRICE <>0 AND (ISNULL(WOD.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(WOD.WO_TOT_VAT_AMT_FP,0)>0)
	--AND ISNULL(WOD.WO_OWN_RISK_AMT,0)=0

/***************************----LABOUR EDITED FOR NEW FIXED PRICE CHANGE ROW 475 END ************************/ 


	UPDATE @LABOUR SET EXT_VAT_CODE =DBO.FnGetExtVATByVAT(DBO.fn_GetLabourVatforINV(ID_INV_NO))
		 ,INVOICE_VAT_PER =DBO.fn_GetLabourVATPERCENTforINV(ID_INV_NO)	
		 
	UPDATE @LABOUR SET INVL_ACCCODE =DBO.fn_GetLabourACCforINV(ID_INV_NO)
	WHERE INVOICETYPE<>'VASELLING'

	UPDATE @LABOUR SET INVL_ACCCODE =DBO.fn_GetVAACCforINV(ID_INV_NO)
	WHERE INVOICETYPE='VASELLING'
*/          
  --LABOUR - SELLING - CLOCKED TIME               
  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX--,ID_Mech  
   )                
   SELECT   DISTINCT               
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOUR'                
    ,'SELLING'                
    ,CASE WHEN INVL_LABOUR_ACCOUNTCODE IS NULL THEN
		DBO.fn_GetLabourACCforINV(ih.ID_INV_NO )
	 ELSE
		INVL_LABOUR_ACCOUNTCODE
	END                

	,		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
						isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
			ELSE
						isnull(INVDT.LINE_AMOUNT_NET,0)
			END        
    ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER         
   ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
 ,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,CASE WHEN idl.INVL_VAT_CODE IS NULL THEN 
				DBO.FnGetExtVATByVAT(DBO.fn_GetLabourVatforINV(ih.ID_INV_NO))
			ELSE
				dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) 
			END	 
	  AS EXT_VAT_CODE   				
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)
	 ,ID.ID_JOB
	 ,id.ID_WO_NO 
	 ,id.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN  
   FROM  TBL_INV_HEADER ih 
   INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO
  -- INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
  -- INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		--AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
   ON   ih.ID_INV_NO = idl.ID_INV_NO AND IDL.ID_WODET_INVL   = id.ID_WODET_INV                
   INNER JOIN TBL_MAS_DEPT md        ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg  ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
 --  LEFT OUTER JOIN TBL_WO_JOB_DETAIL AS WOJ ON   
	--WOJ.ID_WODET_SEQ_JOB =WOD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WOD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WOD.ID_WO_NO
 --  INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX
   INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='LABOUR'
	and id.ID_WO_NO = INVDT.ID_WO_NO AND id.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 	AND ih.ID_DEBITOR = INVDT.DEBTOR_ID  AND id.id_job = INVDT.ID_JOB_ID
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
   AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL --AND WOD.FLG_CHRG_STD_TIME=0                
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
   --AND WODEB.DBT_AMT <> 0 
   --AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) --Modified 4/5/2010 for owner pay vat
   AND id.WO_TYPE_WOH='ORD'

    -------------------------------------************************LABOUR COST(CLOCKED TIME) ROW 274 - START

  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX--,ID_Mech  
   )                
   SELECT   DISTINCT               
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOUR'                
    ,'COST'                
    ,CASE WHEN INVL_LABOUR_ACCOUNTCODE IS NULL THEN
		DBO.fn_GetLabourACCforINV(ih.ID_INV_NO )
	 ELSE
		INVL_LABOUR_ACCOUNTCODE
	END                
-- ******************************************************  
-- Modified Date : 11TH November 2008  
-- Bug ID   : 4262  
    --,INVL_AMOUNT                
   ,  
	abs(
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
					isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
		ELSE
					isnull(INVDT.LINE_AMOUNT_NET,0)
		END
	)
 -- ************* End Of Modification ***********************           
    ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER         
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
   ,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
  
 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
   (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,CASE WHEN idl.INVL_VAT_CODE IS NULL THEN 
				DBO.FnGetExtVATByVAT(DBO.fn_GetLabourVatforINV(ih.ID_INV_NO))
			ELSE
				dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) 
			END	 
	  AS EXT_VAT_CODE   				
	 -- ,'00.00.0000' AS DUE_DATE 
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 --,idl.INVL_IDLOGIN AS CUST_ID --,'' AS CUST_ID  -- Since both mech had same clockin,clockout details it was not picked as 2 different lines
	 ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)
	 ,ID.ID_JOB
	 ,id.ID_WO_NO 
	 ,id.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN  
   FROM  TBL_INV_HEADER ih 
   INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO
  -- INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
  -- INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		--AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
   ON   ih.ID_INV_NO = idl.ID_INV_NO AND IDL.ID_WODET_INVL   = id.ID_WODET_INV                
   INNER JOIN TBL_MAS_DEPT md        ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg  ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
 --  LEFT OUTER JOIN TBL_WO_JOB_DETAIL AS WOJ ON   
	--WOJ.ID_WODET_SEQ_JOB =WOD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WOD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WOD.ID_WO_NO
   --INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX
   INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = IH.ID_INV_NO AND INVDT.LINE_TYPE='LABOUR'
	AND ID.ID_WO_NO = INVDT.ID_WO_NO AND ID.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 	AND IH.ID_DEBITOR = INVDT.DEBTOR_ID  AND ID.ID_JOB = INVDT.ID_JOB_ID    
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
   AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL --AND WOD.FLG_CHRG_STD_TIME=0                
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
   --AND WODEB.DBT_AMT <> 0 
   --AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
   AND ISNULL(cg.USE_INTCUST,0)=1
   AND id.WO_TYPE_WOH='ORD'
-------------------------------------************************LABOUR COST(CLOCKED TIME) ROW 274 - END

   --LABOUR - DISCOUNT                
   INSERT INTO @LABOUR                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,ID_CN_NO, LA_VAT_CODE, 
	 FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO ,ID_WO_PREFIX--,ID_Mech 
    )                 
    SELECT  DISTINCT                
     ih.ID_INV_NO                
     ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
     ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
     ,DPT_AccCode+'_'+DPT_Name                
     ,'LABOUR'                
     ,'DISCOUNT'                
     ,INVL_LABOUR_ACCOUNTCODE                
	 ,isnull(INVDT.LINE_DISCOUNT,0) 
     ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
     ,@TRANSRES                
     ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
     ,ID_Dept_Inv                
     ,Cust_AccCode   
  
  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
	  --,'00.00.0000' AS DUE_DATE 
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	  --,idl.INVL_IDLOGIN AS CUST_ID --,'' AS CUST_ID  -- Since both mech had same clockin,clockout details it was not picked as 2 different lines
      ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP   
	  ,ID_CN_NO	
	  ,cg.ID_VAT_CD 
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	  ,ID.ID_JOB
	 ,id.ID_WO_NO 
	 ,id.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
	--INNER JOIN TBL_WO_DETAIL WOD ON WOD.ID_WO_PREFIX=ID.ID_WO_PREFIX AND WOD.ID_WO_NO=ID.ID_WO_NO AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ AND WOD.FLG_CHRG_STD_TIME=0
 --   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
 --   	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
    INNER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
    ON   ih.ID_INV_NO = idl.ID_INV_NO       AND IDL.ID_WODET_INVL   = id.ID_WODET_INV            
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
    --INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX     
	INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = IH.ID_INV_NO AND INVDT.LINE_TYPE='LABOUR'
	AND ID.ID_WO_NO = INVDT.ID_WO_NO AND ID.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 	AND IH.ID_DEBITOR = INVDT.DEBTOR_ID  AND ID.ID_JOB = INVDT.ID_JOB_ID	            
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
 AND  (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
 --AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) AND WODEB.DBT_AMT <> 0
 AND id.WO_TYPE_WOH='ORD' 
 
 /***************************----LABOUR (CLOCKED TIME) EDITED FOR NEW FIXED PRICE CHANGE ROW 475 START ************************/  
 
   --LABOUR - SELLING - CLOCKED TIME               
  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX--,ID_Mech  
   )                
   SELECT   DISTINCT               
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOURDIFF'                
    ,'SELLING'                
    ,CASE WHEN INVL_LABOUR_ACCOUNTCODE IS NULL THEN
		DBO.fn_GetLabourACCforINV(ih.ID_INV_NO )
	 ELSE
		INVL_LABOUR_ACCOUNTCODE
	END                
-- ******************************************************  
-- Modified Date : 11TH November 2008  
-- Bug ID   : 4262  
    --,INVL_AMOUNT                
   ,  
	CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		0
	ELSE
	CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,WOD.ID_WO_PREFIX,WOD.ID_WO_NO,wod.id_job) =0 THEN 0
     ELSE
		(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
				-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
				CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
					isnull(( idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * idl.INVL_DIS/100)),0)  * (WOD.WO_LBR_VATPER/100) --Row 722
				ELSE
					-- INVL_BFAMOUNT + idl.INVL_VAT  
					--Modified :30/03/2010 (WODEB.WO_LBR_VATPER/100))instead of (WOD.WO_LBR_VATPER/100)) To take vat % based on customer
					-- FAZAL
					/*isnull(( idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price)   *  WODEB.DBT_PER/100,0) 
					+ ((isnull(( idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * idl.INVL_DIS/100))   *  WODEB.DBT_PER/100,0)  * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END)  *  WODEB.DBT_PER/100)*/
					isnull((idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price)   *  (WODEB.DBT_PER/100), 0) 
					--+ ((isnull(((idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * (WODEB.DBT_PER/100)) - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * (idl.INVL_DIS/100) * (WODEB.DBT_PER/100))),0)  * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END))
					+ ((isnull(((idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * (WODEB.DBT_PER/100)) - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * (idl.INVL_DIS/100) * (WODEB.DBT_PER/100))),0)  * 
					CASE WHEN (WODEB.WO_LBR_VATPER=1.00) or (WODEB.WO_LBR_VATPER=0 AND WODEB.DBT_PER<>0 AND WODEB.DBT_PER<100) THEN 
						(WOD.WO_LBR_VATPER/100) 
					ELSE (WODEB.WO_LBR_VATPER/100) END))
					-- END
				END
		ELSE  
			--INVL_BFAMOUNT  
			isnull(( idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * idl.INVL_DIS/100))   *  WODEB.DBT_PER/100,0) 	
		END) * 		(CASE WHEN wod.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
		ELSE 
			CASE WHEN wod.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
			(wod.WO_FIXED_PRICE+(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)
		--(SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END)) 
	END
	END
	-- ************* End Of Modification ***********************           
    ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER         
   ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
 ,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
  
 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
  --(SELECT TextCode   
  --   FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
  -- (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
  --  WHERE ID_SETTINGS =   
  -- (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
  --  WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
  -- AND ID_INV_CONFIG =   
  --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
  --  ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
  --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))  
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,CASE WHEN idl.INVL_VAT_CODE IS NULL THEN 
				DBO.FnGetExtVATByVAT(DBO.fn_GetLabourVatforINV(ih.ID_INV_NO))
			ELSE
				dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) 
			END	 
	  AS EXT_VAT_CODE   				
	 -- ,'00.00.0000' AS DUE_DATE 
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 --,idl.INVL_IDLOGIN AS CUST_ID --,'' AS CUST_ID  -- Since both mech had same clockin,clockout details it was not picked as 2 different lines
	 ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN  
   FROM  TBL_INV_HEADER ih 
   INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
   ON   ih.ID_INV_NO = idl.ID_INV_NO AND IDL.ID_WODET_INVL   =WOD.ID_WODET_SEQ                
   INNER JOIN TBL_MAS_DEPT md        ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg  ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
   LEFT OUTER JOIN TBL_WO_JOB_DETAIL AS WOJ ON   
	WOJ.ID_WODET_SEQ_JOB =WOD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WOD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WOD.ID_WO_NO
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
   AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL AND WOD.FLG_CHRG_STD_TIME=0                
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) --Modified 4/5/2010 for owner pay vat
   AND WH.WO_TYPE_WOH='ORD'
   AND WOD.WO_FIXED_PRICE <>0 AND (ISNULL(WOD.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(WOD.WO_TOT_VAT_AMT_FP,0)>0) 
   --AND ISNULL(WOD.WO_OWN_RISK_AMT,0)=0


    -------------------------------------************************LABOUR COST(CLOCKED TIME) ROW 274 - START

  INSERT INTO @LABOUR                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX--,ID_Mech  
   )                
   SELECT   DISTINCT               
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'LABOURDIFF'                
    ,'COST'                
    ,CASE WHEN INVL_LABOUR_ACCOUNTCODE IS NULL THEN
		DBO.fn_GetLabourACCforINV(ih.ID_INV_NO )
	 ELSE
		INVL_LABOUR_ACCOUNTCODE
	END                
-- ******************************************************  
-- Modified Date : 11TH November 2008  
-- Bug ID   : 4262  
    --,INVL_AMOUNT                
   ,
	CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
		0
	ELSE 
	abs(
	--CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
				-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
				CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
					isnull(( idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * idl.INVL_DIS/100)),0)  * (WOD.WO_LBR_VATPER/100) 
				ELSE
					isnull((idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price)   *  (WODEB.DBT_PER/100), 0) 
					+ ((isnull(((idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * (WODEB.DBT_PER/100)) - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * (idl.INVL_DIS/100) * (WODEB.DBT_PER/100))),0)  * CASE WHEN WODEB.WO_LBR_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_LBR_VATPER/100) END))
				END
		ELSE  
			--INVL_BFAMOUNT  
			isnull(( idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price - (idl.INVL_Mech_hour * idl.INVL_MECh_Hourly_Price * idl.INVL_DIS/100))   *  WODEB.DBT_PER/100,0) 	
		END)* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))
	END
 -- ************* End Of Modification ***********************           
    ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER         
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
   ,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
  
 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
   (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,CASE WHEN idl.INVL_VAT_CODE IS NULL THEN 
				DBO.FnGetExtVATByVAT(DBO.fn_GetLabourVatforINV(ih.ID_INV_NO))
			ELSE
				dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) 
			END	 
	  AS EXT_VAT_CODE   				
	 -- ,'00.00.0000' AS DUE_DATE 
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 --,idl.INVL_IDLOGIN AS CUST_ID --,'' AS CUST_ID  -- Since both mech had same clockin,clockout details it was not picked as 2 different lines
	 ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN  
   FROM  TBL_INV_HEADER ih 
   INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
   ON   ih.ID_INV_NO = idl.ID_INV_NO AND IDL.ID_WODET_INVL   =WOD.ID_WODET_SEQ                
   INNER JOIN TBL_MAS_DEPT md        ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg  ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
   LEFT OUTER JOIN TBL_WO_JOB_DETAIL AS WOJ ON   
	WOJ.ID_WODET_SEQ_JOB =WOD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WOD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WOD.ID_WO_NO
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
   AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL AND WOD.FLG_CHRG_STD_TIME=0                
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
   AND ISNULL(cg.USE_INTCUST,0)=1
   AND WH.WO_TYPE_WOH='ORD'
-------------------------------------************************LABOUR COST(CLOCKED TIME) ROW 274 - END

   --LABOUR - DISCOUNT                
   INSERT INTO @LABOUR                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,ID_CN_NO, LA_VAT_CODE, 
	 FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO ,ID_WO_PREFIX--,ID_Mech 
    )                 
    SELECT  DISTINCT                
     ih.ID_INV_NO                
     ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
     ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
     ,DPT_AccCode+'_'+DPT_Name                
     ,'LABOURDIFF'                
     ,'DISCOUNT'                
     ,INVL_LABOUR_ACCOUNTCODE                
-- ******************************************************  
-- Modified Date : 11TH November 2008  
-- Bug ID   : 4262  
     --,INVL_AMOUNT                
	,CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
		0
	ELSE
     CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,WOD.ID_WO_PREFIX,WOD.ID_WO_NO,wod.id_job) =0 THEN 0
     ELSE
      abs(CAST(
		(CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND IH.ID_DEBITOR=WOD.WO_OWN_CR_CUST THEN
			0--((IDL.INVL_Mech_hour*IDL.INVL_MECh_Hourly_Price*IDL.INVL_VAT_PER/100)*IDL.INVL_DIS/100) -- Row 722
		else
			CASE WHEN WODEB.DBT_PER > 0 AND WODEB.DBT_PER < 100 THEN 
				(isnull(WODEB.DBT_PER,0)/100)*(IDL.INVL_Mech_hour*IDL.INVL_MECh_Hourly_Price*IDL.INVL_DIS/100)
			ELSE
				(IDL.INVL_Mech_hour*IDL.INVL_MECh_Hourly_Price*IDL.INVL_DIS/100)
			END
		end)
		AS DECIMAL(15,2)))
      *		(CASE WHEN wod.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
		ELSE 
			CASE WHEN wod.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
					(wod.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE+(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)  
      --* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))
    END
    END
-- ************* End Of Modification ***********************  
     ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
     ,@TRANSRES                
     ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
     ,ID_Dept_Inv                
     ,Cust_AccCode   
  
  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
  --(SELECT TextCode   
  --   FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
  -- (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
  --  WHERE ID_SETTINGS =   
  -- (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
  --  WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
  -- AND ID_INV_CONFIG =   
  --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
  --  ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
  --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
	  --,'00.00.0000' AS DUE_DATE 
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	  --,idl.INVL_IDLOGIN AS CUST_ID --,'' AS CUST_ID  -- Since both mech had same clockin,clockout details it was not picked as 2 different lines
      ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP   
	  ,ID_CN_NO	
	  ,cg.ID_VAT_CD 
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	  ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
	INNER JOIN TBL_WO_DETAIL WOD ON WOD.ID_WO_PREFIX=ID.ID_WO_PREFIX AND WOD.ID_WO_NO=ID.ID_WO_NO AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ AND WOD.FLG_CHRG_STD_TIME=0
    INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
    	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
    INNER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
    ON   ih.ID_INV_NO = idl.ID_INV_NO         AND IDL.ID_WODET_INVL   =WOD.ID_WODET_SEQ          
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
    INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
 AND  (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
 AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1)  AND WODEB.DBT_AMT <> 0
 AND WH.WO_TYPE_WOH='ORD' 
 AND WOD.WO_FIXED_PRICE <>0 AND (ISNULL(WOD.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(WOD.WO_TOT_VAT_AMT_FP,0)>0)
 
 /***************************----LABOUR (CLOCKED TIME) EDITED FOR NEW FIXED PRICE CHANGE ROW 475 END ************************/  
  
    --CODING TO UPDATE THE INVOICE NUMBER                
    --UPDATE @LABOUR SET INVOICE_NO = SUBSTRING(ID_INV_NO,LEN(INVOICE_PREFIX)+1,LEN(ID_INV_NO)-LEN(INVOICE_PREFIX))                          
   --END LABOUR    
   
    --Sept 13 2012 
	--Since both mech had same clockin,clockout details it was not picked as 2 different lines
	UPDATE @LABOUR SET CUST_ID=''

	INSERT INTO @LABOUR 
		(ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,                
		 INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,
		 ID_DEPT_INV,CUST_ACCCODE, TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, 
		 CUST_NAME, CUST_ADDR1, CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, 
		 CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED)
	SELECT ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
		 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
		 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,NULL, LA_VAT_CODE, 0 
	FROM @LABOUR WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0
 
  --SPARES                 
  DECLARE @SPARES TABLE                                
  (                                
	 ID_INV_NO    VARCHAR(50),                
	 DATE_INVOICE   DATETIME,                
	 INV_CUST_GROUP   VARCHAR(100),                          
	 DEPT_ACC_CODE   VARCHAR(100),                
	 INVOICETYPE    VARCHAR(20),                
	 ACCMATRIXTYPE   VARCHAR(20),               
	 INVL_ACCCODE   VARCHAR(20),                
	 INVOICE_AMT    NUMERIC(15,2),                
	 INVOICE_VAT_PER   NUMERIC(5,2),                
	 INVOICE_PREFIX   VARCHAR(20),                
	 INVOICE_NO    VARCHAR(50),                
	 INVOICE_TRANSACTIONID VARCHAR(25),                
	 INVOICE_TRANSACTIONDATE DATETIME,                
	 ID_DEPT_INV    INT,                          
	 CUST_ACCCODE   VARCHAR(20),   
	  
	 TEXTCODE VARCHAR(50),   
	 VOUCHER_TEXT VARCHAR(100),   
	 EXT_VAT_CODE CHAR(1),   
	 DUE_DATE VARCHAR(20),   
	 CUST_ID VARCHAR(50),   
	 CUST_NO INT,   
	 CUST_NAME VARCHAR(100),   
	 CUST_ADDR1 VARCHAR(50),   
	 CUST_ADDR2 VARCHAR(50),   
	 CUST_POST_CODE VARCHAR(10),   
	 CUST_PLACE VARCHAR(50),   
	 CUST_PHONE VARCHAR(20),   
	 CUST_FAX VARCHAR(20),   
	 CUST_CREDIT_LIMIT NUMERIC(15,2),   
	 CUST_PAYTERM VARCHAR(20),   
	 CUST_GROUP VARCHAR(20),
     ID_CN_NO VARCHAR(15), 
     LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT ,
	 JOBNO INT ,
	 ORDERNO VARCHAR(10)
	 ,ID_WO_PREFIX VARCHAR(5)
	 ,ID_WOITEM_SEQ VARCHAR(20) 
	 
  )     
        
   --SPARES - SELLING                
   INSERT INTO @SPARES            (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED ,JOBNO,ORDERNO,ID_WO_PREFIX
    )                 
    SELECT   DISTINCT 
     ih.ID_INV_NO                
     ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                 
     ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
     ,DPT_AccCode+'_'+DPT_Name                
     ,'SPARES'                
     ,'SELLING'                
     ,INVL_SPARES_ACCOUNTCODE     
	,		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
						SUM(isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0))
			ELSE
						SUM(isnull(INVDT.LINE_AMOUNT_NET,0))
			END 
	 ,(ISNULL(INVL_VAT_PER,0)) AS INVL_VAT_PER  
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		 ,@TRANSRES                
		 ,INV_TRANSDATE                
		 ,ID_Dept_Inv                
		 ,Cust_AccCode                
	  
	  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	  ,'' AS CUST_ID   
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP  
	  ,ID_CN_NO 
	  --,cg.ID_VAT_CD
	  ,idl.INVL_VAT_CODE
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	  ,id.ID_JOB	
	  , id.ID_WO_NO
	   ,id.ID_WO_PREFIX
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    LEFT OUTER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_WO_NO = id.ID_WO_NO AND INVDT.ID_WO_PREFIX = id.ID_WO_PREFIX 
		AND INVDT.ID_JOB_ID = id.ID_JOB AND INVDT.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ AND INVDT.DEBTOR_ID = ih.ID_DEBITOR AND INVDT.ID_INV_NO = ih.ID_INV_NO
		AND INVDT.LINE_TYPE='SPARES'
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                             
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL 
		--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0) OR (WOD.WO_OWN_PAY_VAT=1 )))  --Modified 4/5/2010 for owner pay vat
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
	
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER        
 GROUP BY  
 ih.ID_INV_NO                
     ,DT_INVOICE  
     ,DT_CREDITNOTE              
     ,INV_CUST_GROUP                
     ,DPT_AccCode,DPT_Name                
     ,INVL_SPARES_ACCOUNTCODE                
     ,INV_TRANSACTIONID                
     ,INV_TRANSDATE                
     ,ID_Dept_Inv                
     ,Cust_AccCode  
	  ,ih.ID_Subsidery_Inv  
	  ,ih.DT_CREATED  
	  ,idl.INVL_VAT_CODE  
	  ,ih.INV_KID  
	  ,ih.ID_DEBITOR   
	  ,ih.CUST_NAME   
	  ,ih.CUST_PERM_ADD1  
	  ,ih.CUST_PERM_ADD2  
	  ,cg.ID_PAY_TERM 
	  ,id.FLG_FIXED_PRICE
	  ,id.INVD_FIXEDAMT 
	  --,WODEB.DBT_PER 
	  ,ID_CN_NO
	  ,cg.ID_VAT_CD 
	  ,FLG_EXPORTED_AND_CREDITED
	  ,idl.INVL_VAT_PER
	  --,WODEB.WO_VAT_PERCENTAGE
	  --,WOD.WO_VAT_PERCENTAGE	
	  ,id.ID_JOB
	  , id.ID_WO_NO	
	  ,id.ID_WO_PREFIX
	  --,WOD.WO_OWN_PAY_VAT	
	  --,WODEB.ID_JOB_DEB
	  --,WOD.WO_OWN_RISK_AMT
	  --,wod.WO_FIXED_PRICE
	  --,WODEB.WO_FIXED_VATPER
	  ,INVDT.LINE_VAT_PERCENTAGE
	
 --END OF MODIFICATION  
 
 -------------------------------------************************SPARE COST ROW 274 - START

   --SPARES - COST              
    INSERT INTO @SPARES            (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED ,JOBNO,ORDERNO,ID_WO_PREFIX
    )                 
    SELECT   DISTINCT 
     ih.ID_INV_NO                
     ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                 
     ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
     ,DPT_AccCode+'_'+DPT_Name                
     ,'SPARES'                
     ,'SCOST'                
     ,INVL_SPARES_ACCOUNTCODE     
	 ,		CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
						SUM(isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0))
			ELSE
						SUM(isnull(INVDT.LINE_AMOUNT_NET,0))
			END    
	 ,(ISNULL(INVL_VAT_PER,0)) AS INVL_VAT_PER  
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		 ,@TRANSRES                
		 ,INV_TRANSDATE                
		 ,ID_Dept_Inv                
		 ,Cust_AccCode                
	  
	  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
	  ,'' AS CUST_ID   
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP  
	  ,ID_CN_NO 
	  --,cg.ID_VAT_CD
	  ,idl.INVL_VAT_CODE
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	  ,id.ID_JOB	
	  ,id.ID_WO_NO
	  ,id.ID_WO_PREFIX
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    --INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    --LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    LEFT OUTER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_WO_NO = id.ID_WO_NO AND INVDT.ID_WO_PREFIX = id.ID_WO_PREFIX 
		AND INVDT.ID_JOB_ID = id.ID_JOB AND INVDT.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ AND INVDT.DEBTOR_ID = ih.ID_DEBITOR AND INVDT.ID_INV_NO = ih.ID_INV_NO
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                             
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL 
		--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0) OR (WOD.WO_OWN_PAY_VAT=1 )))  --Modified 4/5/2010 for owner pay vat
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00 
   AND ISNULL(cg.USE_INTCUST,0)=1  
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER        
 GROUP BY  
 ih.ID_INV_NO                
     ,DT_INVOICE  
     ,DT_CREDITNOTE              
     ,INV_CUST_GROUP                
     ,DPT_AccCode,DPT_Name                
     ,INVL_SPARES_ACCOUNTCODE                
     ,INV_TRANSACTIONID                
     ,INV_TRANSDATE                
     ,ID_Dept_Inv                
     ,Cust_AccCode  
	  ,ih.ID_Subsidery_Inv  
	  ,ih.DT_CREATED  
	  ,idl.INVL_VAT_CODE  
	  ,ih.INV_KID  
	  ,ih.ID_DEBITOR   
	  ,ih.CUST_NAME   
	  ,ih.CUST_PERM_ADD1  
	  ,ih.CUST_PERM_ADD2  
	  ,cg.ID_PAY_TERM 
	  ,id.FLG_FIXED_PRICE
	  ,id.INVD_FIXEDAMT 
	  --,WODEB.DBT_PER 
	  ,ID_CN_NO
	  ,cg.ID_VAT_CD 
	  ,FLG_EXPORTED_AND_CREDITED
	  ,idl.INVL_VAT_PER
	  --,WODEB.WO_VAT_PERCENTAGE
	  --,WOD.WO_VAT_PERCENTAGE	
	  ,id.ID_JOB
	  ,id.ID_WO_NO	
	  ,id.ID_WO_PREFIX
	  --,WOD.WO_OWN_PAY_VAT	
	  --,WODEB.ID_JOB_DEB
	  ,INVDT.LINE_VAT_PERCENTAGE	
	
 --END OF MODIFICATION
-------------------------------------************************SPARE COST ROW 274 - END

  
   --SPARES - DISCOUNT                
   INSERT INTO @SPARES                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,JOBNO , ORDERNO,ID_WO_PREFIX,ID_WOITEM_SEQ
    )                 
    SELECT   DISTINCT               
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'SPARES'                
		 ,'DISCOUNT'                
		 ,INVL_SPARES_ACCOUNTCODE                
		,abs(sum(isnull(INVDT.LINE_DISCOUNT,0)))
		,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		,@TRANSRES          
		,INV_TRANSDATE                
		,ID_Dept_Inv                
		,Cust_AccCode   
		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
		  END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO 
		--,cg.ID_VAT_CD
		,idl.INVL_VAT_CODE
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,id.ID_JOB
		,id.ID_WO_NO
		,id.ID_WO_PREFIX
		,idl.ID_WOITEM_SEQ
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    --INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    --LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP  
    INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_WO_NO = id.ID_WO_NO AND INVDT.ID_WO_PREFIX = id.ID_WO_PREFIX 
		AND INVDT.ID_JOB_ID = id.ID_JOB AND INVDT.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ AND INVDT.DEBTOR_ID = ih.ID_DEBITOR AND INVDT.ID_INV_NO = ih.ID_INV_NO
		AND INVDT.LINE_TYPE='SPARES'	               
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                            
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL    
	--Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
			--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER >= 0))) 
			--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
	-- ***********************************  
	-- Modified Date : 10th November 2008  
	-- Bug Id   : 4271  
 GROUP BY  
	ih.ID_INV_NO                
	,DT_INVOICE 
	,DT_CREDITNOTE                
	,INV_CUST_GROUP                
	,DPT_AccCode,DPT_Name                
	,INVL_SPARES_ACCOUNTCODE                
	,INV_TRANSACTIONID                
	,INV_TRANSDATE                
	,ID_Dept_Inv                
	,Cust_AccCode  
	,ih.ID_Subsidery_Inv  
	,ih.DT_CREATED    
	,INVL_VAT_PER   
	,idl.INVL_VAT_CODE  
	,ih.INV_KID  
	,ih.ID_DEBITOR  
	,ih.CUST_NAME  
	,ih.CUST_PERM_ADD1  
	,ih.CUST_PERM_ADD2  
	,cg.ID_PAY_TERM  
	,id.FLG_FIXED_PRICE 
	--,WODEB.DBT_PER
	--,WODEB.WO_VAT_PERCENTAGE
	,ID_CN_NO 
	,cg.ID_VAT_CD
	,FLG_EXPORTED_AND_CREDITED 
	,id.ID_WO_NO 
	,id.ID_WO_PREFIX
	,id.ID_JOB
	,idl.INVL_VAT
	,idl.ID_WOITEM_SEQ
	--,WOD.WO_OWN_RISK_AMT
	--,wod.WO_FIXED_PRICE
	--,WOD.WO_OWN_PAY_VAT
	--,WODEB.ID_JOB_DEB
-- ***** End Of Modification *************      

 --------------------**********************ROW 274 FOR SPARES DISCOUNT CREDIT - START
  --SPARES - DISCOUNT                
   INSERT INTO @SPARES                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,JOBNO , ORDERNO,ID_WO_PREFIX,ID_WOITEM_SEQ
    )                 
    SELECT   DISTINCT               
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'SPARES'                
		 ,'DISCOUNTC'                
		 ,INVL_SPARES_ACCOUNTCODE                
		,abs(sum(isnull(INVDT.LINE_DISCOUNT,0)))
		,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		,@TRANSRES          
		,INV_TRANSDATE                
		,ID_Dept_Inv                
		,Cust_AccCode   
		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
		END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX     
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO 
		,idl.INVL_VAT_CODE
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,id.ID_JOB
		,id.ID_WO_NO
		,id.ID_WO_PREFIX
		,idl.ID_WOITEM_SEQ
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    --INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    --LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP         
    INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_WO_NO = id.ID_WO_NO AND INVDT.ID_WO_PREFIX = id.ID_WO_PREFIX 
		AND INVDT.ID_JOB_ID = id.ID_JOB AND INVDT.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ AND INVDT.DEBTOR_ID = ih.ID_DEBITOR AND INVDT.ID_INV_NO = ih.ID_INV_NO
		AND INVDT.LINE_TYPE='SPARES'		        
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                            
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL    
	 --Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER >= 0))) 
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
	AND md.FLG_INTCUST_EXP = 1
		--and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
	AND ISNULL(cg.USE_INTCUST,0)=1
-- ***********************************  
-- Modified Date : 10th November 2008  
-- Bug Id   : 4271  
 GROUP BY  
	ih.ID_INV_NO                
	,DT_INVOICE 
	,DT_CREDITNOTE                
	,INV_CUST_GROUP                
	,DPT_AccCode,DPT_Name                
	,INVL_SPARES_ACCOUNTCODE                
	,INV_TRANSACTIONID                
	,INV_TRANSDATE                
	,ID_Dept_Inv                
	,Cust_AccCode  
	,ih.ID_Subsidery_Inv  
	,ih.DT_CREATED    
	,INVL_VAT_PER   
	,idl.INVL_VAT_CODE  
	,ih.INV_KID  
	,ih.ID_DEBITOR  
	,ih.CUST_NAME  
	,ih.CUST_PERM_ADD1  
	,ih.CUST_PERM_ADD2  
	,cg.ID_PAY_TERM  
	,id.FLG_FIXED_PRICE 
	,ID_CN_NO 
	,cg.ID_VAT_CD
	,FLG_EXPORTED_AND_CREDITED 
	,id.ID_WO_NO 
	,id.ID_WO_PREFIX
	,id.ID_JOB
	,idl.INVL_VAT
	,idl.ID_WOITEM_SEQ
-- ***** End Of Modification *************      
 --------------------**********************ROW 274 FOR SPARES DISCOUNT CREDIT - END
              
   --SPARES - STOCK                
                
   INSERT INTO @SPARES                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,JOBNO ,ORDERNO,ID_WO_PREFIX
    )                 
    SELECT  DISTINCT                 
     ih.ID_INV_NO                
	,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
	ELSE DT_CREDITNOTE END                
	,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
	,DPT_AccCode+'_'+DPT_Name                
	,'SPARES'                
	,'STOCK'                
	,INVL_SPARES_ACCOUNTCODE                
	,
		CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
		SUM(cast(INVL_DELIVER_QTY * INVL_AVERAGECOST  as decimal(15,2))) 
		ELSE
		0 
		END 
	,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX                       
	,@TRANSRES                
	,INV_TRANSDATE                
	,ID_Dept_Inv                
	,Cust_AccCode   
	,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	END AS TEXTCODE   
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	,'' AS EXT_VAT_CODE  
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
	,'' AS CUST_ID   
	,ih.ID_DEBITOR AS CUST_NO    
	,'' AS CUST_NAME   
	,'' AS CUST_ADDR1   
	,'' AS CUST_ADDR2   
	,'' AS CUST_POST_CODE   
	,'' AS CUST_PLACE   
	,'' AS CUST_PHONE   
	,'' AS CUST_FAX   
	,'0.00' AS CUST_CREDIT_LIMIT   
	,0 CUST_PAYTERM   
	,0 AS CUST_GROUP
	,ID_CN_NO 
	,idl.INVL_VAT_CODE
	,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	,id.ID_JOB
	,id.ID_WO_NO
	,id.ID_WO_PREFIX
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    --INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    --LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                            
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0))) 
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0))) 
	GROUP BY
	  ih.ID_INV_NO 
     ,DT_INVOICE 
     ,DT_CREDITNOTE 
     ,INV_CUST_GROUP 
     ,DPT_AccCode,DPT_Name 
     ,INVL_SPARES_ACCOUNTCODE 
     ,INV_TRANSACTIONID 
     ,INV_TRANSDATE 
     ,ID_Dept_Inv 
     ,Cust_AccCode 
	 ,ih.ID_Subsidery_Inv 
	 ,ih.DT_CREATED 
	 ,INVL_VAT_PER 
	 ,idl.INVL_VAT_CODE 
	 ,ih.INV_KID 
	 ,ih.ID_DEBITOR 
	 ,ih.CUST_NAME 
	 ,ih.CUST_PERM_ADD1 
	 ,ih.CUST_PERM_ADD2 
	 ,cg.ID_PAY_TERM 
	 ,id.FLG_FIXED_PRICE 
	 --,WODEB.DBT_PER 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ih.FLG_EXPORTED_AND_CREDITED
	 ,id.ID_JOB 
	 ,id.ID_WO_NO
	 ,id.ID_WO_PREFIX
             
    --SPARES - COST                
    INSERT INTO @SPARES                
     (                 
      ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
      ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
      INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	  TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	  CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,
	  ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED ,JOBNO , ORDERNO,ID_WO_PREFIX
     )                 
     SELECT  DISTINCT                 
		ih.ID_INV_NO                
		,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		ELSE DT_CREDITNOTE END                
		,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		,DPT_AccCode+'_'+DPT_Name                
		,'SPARES'                
		,'COST'                
		,INVL_SPARES_ACCOUNTCODE                
		,CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
			SUM(cast(INVL_DELIVER_QTY * INVL_AVERAGECOST  as decimal(15,2))) 
		ELSE
			0 
		END
		,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		,@TRANSRES                
		,INV_TRANSDATE                
		,ID_Dept_Inv                
		,Cust_AccCode   
		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
		END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,'' AS EXT_VAT_CODE
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX     
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO   
		,idl.INVL_VAT_CODE
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,id.ID_JOB
		,id.ID_WO_NO
		,id.ID_WO_PREFIX
     FROM  TBL_INV_HEADER ih 
     INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    --INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    --LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
     INNER JOIN TBL_INV_DETAIL_LINES idl 
     ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
     INNER JOIN TBL_MAS_DEPT md                
     ON   ih.ID_Dept_Inv = md.ID_DEPT                
     INNER JOIN TBL_MAS_CUST_GROUP cg                
     ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
     WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                       
     AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
     AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
      OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
     AND   ih.ID_INV_NO IS NOT NULL                    
 --Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE' ) 
		--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0))) 
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
	GROUP BY
	  ih.ID_INV_NO 
     ,DT_INVOICE 
     ,DT_CREDITNOTE 
     ,INV_CUST_GROUP 
     ,DPT_AccCode,DPT_Name 
     ,INVL_SPARES_ACCOUNTCODE 
     ,INV_TRANSACTIONID 
     ,INV_TRANSDATE 
     ,ID_Dept_Inv 
     ,Cust_AccCode 
	 ,ih.ID_Subsidery_Inv 
	 ,ih.DT_CREATED 
	 ,INVL_VAT_PER 
	 ,idl.INVL_VAT_CODE 
	 ,ih.INV_KID 
	 ,ih.ID_DEBITOR 
	 ,ih.CUST_NAME 
	 ,ih.CUST_PERM_ADD1 
	 ,ih.CUST_PERM_ADD2 
	 ,cg.ID_PAY_TERM 
	 ,id.FLG_FIXED_PRICE 
	 --,WODEB.DBT_PER 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ih.FLG_EXPORTED_AND_CREDITED 
	 ,id.ID_JOB
	 ,id.ID_WO_NO
	 ,id.ID_WO_PREFIX

	/******************--------------SPARE PARTS ROW 475 FIXED PRICE CHANGE START---------------------********/
	
	   --SPARES - SELLING                
   INSERT INTO @SPARES            (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED ,JOBNO,ORDERNO,ID_WO_PREFIX
    )                 
    SELECT   DISTINCT 
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER   
 --DISTINCT                 
 --END OF MODIFICATION  
     ih.ID_INV_NO                
     ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                 
     ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
     ,DPT_AccCode+'_'+DPT_Name                
     ,'SPARESDIFF'                
     ,'SELLING'                
     ,INVL_SPARES_ACCOUNTCODE     
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER        
 --**************************************  
 -- Modified Date : 10th November 2008  
 -- Bug ID      :  4269  
-- ,SUM(INVL_AMOUNT)  
	,  
	--CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
	CASE WHEN ISNULL((SELECT MAX(CONVERT(INT,FLG_FIXED_PRICE)) FROM TBL_INV_DETAIL IDX WHERE IDX.ID_INV_NO=ih.ID_INV_NO),0) =0 THEN
		0
	ELSE
	CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,WOD.ID_WO_PREFIX,WOD.ID_WO_NO,wod.id_job) =0 THEN 0
     ELSE
		(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			CASE WHEN WODEB.DBT_PER IS NULL THEN
				--SUM(ISNULL(INVL_BFAMOUNT,0)) + SUM(ISNULL(idl.INVL_VAT, 0))  
				SUM(ISNULL(INVL_BFAMOUNT,0)) + SUM(((ISNULL(idl.INVL_BFAMOUNT, 0) )-(cast((((ISNULL(idl.INVL_BFAMOUNT,0)) ) * (idl.INVL_DIS/100)  )  as decimal(15,2))))  * (idl.INVL_VAT_PER/100))--Row 722
			ELSE
				-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
				CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
					(SUM(((ISNULL(idl.INVL_BFAMOUNT, 0) )-(cast((((ISNULL(idl.INVL_BFAMOUNT,0)) ) * (idl.INVL_DIS/100)  )  as decimal(15,2))))) * ISNULL(WOINV.LINE_VAT_PERCENTAGE,0)/100) -- Row 722
				ELSE
					--(SUM(ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) + (SUM(ISNULL(idl.INVL_VAT, 0)) * (WODEB.DBT_PER/100))  
					(SUM(ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) + (SUM(((ISNULL(idl.INVL_BFAMOUNT, 0) )-(cast((((ISNULL(idl.INVL_BFAMOUNT,0)) ) * (idl.INVL_DIS/100)  )  as decimal(15,2))))*  (WODEB.DBT_PER/100)) *  --Row 722
						(CASE WHEN WODEB.WO_VAT_PERCENTAGE=1.00 THEN (
							CASE WHEN (SELECT COUNT(DISTINCT INVL.INVL_VAT_PER) FROM TBL_INV_DETAIL_LINES INVL WHERE INVL.ID_INV_NO=IH.ID_INV_NO) > 1 THEN 
								IDL.INVL_VAT_PER/100 
							ELSE
								ISNULL(WOINV.LINE_VAT_PERCENTAGE,0)/100
							END) 
						ELSE 
							--(WODEB.WO_VAT_PERCENTAGE/100) 
							((CASE WHEN ISNULL(wod.WO_FIXED_PRICE,0)<>0 THEN WODEB.WO_FIXED_VATPER ELSE WODEB.WO_VAT_PERCENTAGE END)/100) 
						END))
					--(idl.INVL_VAT_PER/100)) Modified on 30/3/2010 with case statement
				END
			END
			
		ELSE
			CASE WHEN WODEB.DBT_PER IS NULL THEN  
				SUM(ISNULL(INVL_BFAMOUNT,0))
			ELSE
				SUM(ISNULL(INVL_BFAMOUNT,0)) * (WODEB.DBT_PER/100) 
			END
		END) * 
			(CASE WHEN wod.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
		ELSE 
			CASE WHEN wod.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE+(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)  
		--* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END)) 
	END 
	END
	 -- *********** End Of Modification ********  
	 ,(ISNULL(INVL_VAT_PER,0)) AS INVL_VAT_PER  
	 --,INVL_AMOUNT                
		 --,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                 
	 --END OF MODIFICATION  
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		 ,@TRANSRES                
		 ,INV_TRANSDATE                
		 ,ID_Dept_Inv                
		 ,Cust_AccCode                
	  
	  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
	 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
	  --,'00.00.0000' AS DUE_DATE 
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	  ,'' AS CUST_ID   
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP  
	  ,ID_CN_NO 
	  --,cg.ID_VAT_CD
	  ,idl.INVL_VAT_CODE
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	  ,WOD.ID_JOB	
	  , WOD.ID_WO_NO
	   ,WOD.ID_WO_PREFIX
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    LEFT OUTER JOIN TBL_INVOICE_DATA WOINV ON WOINV.ID_WO_NO = WOD.ID_WO_NO AND WOINV.ID_WO_PREFIX = WOD.ID_WO_PREFIX 
		AND WOINV.ID_JOB_ID = WOD.ID_JOB AND WOINV.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ AND WOINV.DEBTOR_ID = ih.ID_DEBITOR AND WOINV.ID_INV_NO = ih.ID_INV_NO
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                             
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL 
		AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0) OR (WOD.WO_OWN_PAY_VAT=1 )))  --Modified 4/5/2010 for owner pay vat
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
		AND WOD.WO_FIXED_PRICE <>0 AND (ISNULL(WOD.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(WOD.WO_TOT_VAT_AMT_FP,0)>0) 
		--AND ISNULL(WOD.WO_OWN_RISK_AMT,0)=0
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER        
 GROUP BY  
 ih.ID_INV_NO                
     ,DT_INVOICE  
     ,DT_CREDITNOTE              
     ,INV_CUST_GROUP                
     ,DPT_AccCode,DPT_Name                
     ,INVL_SPARES_ACCOUNTCODE                
     ,INV_TRANSACTIONID                
     ,INV_TRANSDATE                
     ,ID_Dept_Inv                
     ,Cust_AccCode  
	  ,ih.ID_Subsidery_Inv  
	  ,ih.DT_CREATED  
	  ,idl.INVL_VAT_CODE  
	  ,ih.INV_KID  
	  ,ih.ID_DEBITOR   
	  ,ih.CUST_NAME   
	  ,ih.CUST_PERM_ADD1  
	  ,ih.CUST_PERM_ADD2  
	  ,cg.ID_PAY_TERM 
	  ,id.FLG_FIXED_PRICE
	  ,id.INVD_FIXEDAMT 
	  ,WODEB.DBT_PER 
	  ,ID_CN_NO
	  ,cg.ID_VAT_CD 
	  ,FLG_EXPORTED_AND_CREDITED
	  ,idl.INVL_VAT_PER
	  ,WODEB.WO_VAT_PERCENTAGE
	  ,WOD.WO_VAT_PERCENTAGE	
	  ,WOD.ID_JOB
	  ,WOD.ID_WO_NO	
	  ,WOD.ID_WO_PREFIX
	  ,WOD.WO_OWN_PAY_VAT	
	  ,WODEB.ID_JOB_DEB	
	  ,wod.WO_FIXED_PRICE
	  ,wod.WO_TOT_VAT_AMT
	  ,WODEB.WO_FIXED_VATPER
	  ,wod.WO_OWN_CR_CUST
	  ,wod.WO_OWN_RISK_CUST
	  ,WODEB.DEBTOR_VAT_PERCENTAGE
	  ,WOINV.LINE_VAT_PERCENTAGE
 --END OF MODIFICATION  
 
 -------------------------------------************************SPARE COST ROW 274 - START

   --SPARES - COST              
    INSERT INTO @SPARES            (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED ,JOBNO,ORDERNO,ID_WO_PREFIX
    )                 
    SELECT   DISTINCT 
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER   
 --DISTINCT                 
 --END OF MODIFICATION  
     ih.ID_INV_NO                
     ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                 
     ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
     ,DPT_AccCode+'_'+DPT_Name                
     ,'SPARESDIFF'                
     ,'SCOST'                
     ,INVL_SPARES_ACCOUNTCODE     
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER        
 --**************************************  
 -- Modified Date : 10th November 2008  
 -- Bug ID      :  4269  
-- ,SUM(INVL_AMOUNT)  
	  ,  
	  CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
		0
	  ELSE 
		(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
			CASE WHEN WODEB.DBT_PER IS NULL THEN
				--SUM(ISNULL(INVL_BFAMOUNT,0)) + SUM(ISNULL(idl.INVL_VAT, 0))  
				SUM(ISNULL(INVL_BFAMOUNT,0)) + SUM(ISNULL(idl.INVL_BFAMOUNT, 0)  * (idl.INVL_VAT_PER/100))  
			ELSE
				-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
				CASE WHEN WOD.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
					(SUM(ISNULL(idl.INVL_BFAMOUNT, 0)) * ISNULL(WOINV.LINE_VAT_PERCENTAGE,0)/100)
				ELSE
					--(SUM(ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) + (SUM(ISNULL(idl.INVL_VAT, 0)) * (WODEB.DBT_PER/100))  
					(SUM(ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) + (SUM(ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * 
						(CASE WHEN WODEB.WO_VAT_PERCENTAGE=1.00 THEN (
							CASE WHEN (SELECT COUNT(DISTINCT INVL.INVL_VAT_PER) FROM TBL_INV_DETAIL_LINES INVL WHERE INVL.ID_INV_NO=IH.ID_INV_NO) > 1 THEN 
								IDL.INVL_VAT_PER/100 
							ELSE
								ISNULL(WOINV.LINE_VAT_PERCENTAGE,0)/100
							END) 
						ELSE 
							(WODEB.WO_VAT_PERCENTAGE/100) 
						END))
						--(idl.INVL_VAT_PER/100)) Modified on 30/3/2010 with case statement
				END
			END
			
		ELSE
			CASE WHEN WODEB.DBT_PER IS NULL THEN  
				SUM(ISNULL(INVL_BFAMOUNT,0))
			ELSE
				SUM(ISNULL(INVL_BFAMOUNT,0)) * (WODEB.DBT_PER/100) 
			END
		END) * (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))   
	  END 
	 -- *********** End Of Modification ********  
	 ,(ISNULL(INVL_VAT_PER,0)) AS INVL_VAT_PER  
	 --,INVL_AMOUNT                
		 --,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                 
	 --END OF MODIFICATION  
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		 ,@TRANSRES                
		 ,INV_TRANSDATE                
		 ,ID_Dept_Inv                
		 ,Cust_AccCode                
	  
	  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
	  --,'00.00.0000' AS DUE_DATE  
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
	  ,'' AS CUST_ID   
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP  
	  ,ID_CN_NO 
	  --,cg.ID_VAT_CD
	  ,idl.INVL_VAT_CODE
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
	  ,WOD.ID_JOB	
	  , WOD.ID_WO_NO
	   ,WOD.ID_WO_PREFIX
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    LEFT OUTER JOIN TBL_INVOICE_DATA WOINV ON WOINV.ID_WO_NO = WOD.ID_WO_NO AND WOINV.ID_WO_PREFIX = WOD.ID_WO_PREFIX 
		AND WOINV.ID_JOB_ID = WOD.ID_JOB AND WOINV.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ AND WOINV.DEBTOR_ID = ih.ID_DEBITOR AND WOINV.ID_INV_NO = ih.ID_INV_NO
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                             
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL 
		AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0) OR (WOD.WO_OWN_PAY_VAT=1 )))  --Modified 4/5/2010 for owner pay vat
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
   AND md.FLG_INTCUST_EXP = 1
   --and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00 
   AND ISNULL(cg.USE_INTCUST,0)=1  
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4270, MULTIPLE ENTRIES FOR SAME SPARE PART IN WORKORDER        
 GROUP BY  
 ih.ID_INV_NO                
     ,DT_INVOICE  
     ,DT_CREDITNOTE              
     ,INV_CUST_GROUP                
     ,DPT_AccCode,DPT_Name                
     ,INVL_SPARES_ACCOUNTCODE                
     ,INV_TRANSACTIONID                
     ,INV_TRANSDATE                
     ,ID_Dept_Inv                
     ,Cust_AccCode  
	  ,ih.ID_Subsidery_Inv  
	  ,ih.DT_CREATED  
	  ,idl.INVL_VAT_CODE  
	  ,ih.INV_KID  
	  ,ih.ID_DEBITOR   
	  ,ih.CUST_NAME   
	  ,ih.CUST_PERM_ADD1  
	  ,ih.CUST_PERM_ADD2  
	  ,cg.ID_PAY_TERM 
	  ,id.FLG_FIXED_PRICE
	  ,id.INVD_FIXEDAMT 
	  ,WODEB.DBT_PER 
	  ,ID_CN_NO
	  ,cg.ID_VAT_CD 
	  ,FLG_EXPORTED_AND_CREDITED
	  ,idl.INVL_VAT_PER
	  ,WODEB.WO_VAT_PERCENTAGE
	  ,WOD.WO_VAT_PERCENTAGE	
	  ,WOD.ID_JOB
	  ,WOD.ID_WO_NO	
	  ,WOD.ID_WO_PREFIX
	  ,WOD.WO_OWN_PAY_VAT	
	  ,WODEB.ID_JOB_DEB
	  ,WODEB.DEBTOR_VAT_PERCENTAGE	
 	  ,WOINV.LINE_VAT_PERCENTAGE
 	 --END OF MODIFICATION
-------------------------------------************************SPARE COST ROW 274 - END

  
   --SPARES - DISCOUNT                
   INSERT INTO @SPARES                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,JOBNO , ORDERNO,ID_WO_PREFIX,ID_WOITEM_SEQ
    )                 
    SELECT   DISTINCT               
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'SPARESDIFF'                
		 ,'DISCOUNT'                
		 ,INVL_SPARES_ACCOUNTCODE                
		 --Bug ID:-ss7 30b      
		 --Date  :-22-Oct-2008      
		 --desc  :-Invoice Amount was wrongly called      
			 --,INVL_AMOUNT                
		  
		-- ***********************************  
		-- Modified Date : 10th November 2008  
		-- Bug Id   : 4271  
		 ,
		-- CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
		CASE WHEN ISNULL((SELECT MAX(CONVERT(INT,FLG_FIXED_PRICE)) FROM TBL_INV_DETAIL IDX WHERE IDX.ID_INV_NO=ih.ID_INV_NO),0) =0 THEN
				0
		 ELSE
		 CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,WOD.ID_WO_PREFIX,WOD.ID_WO_NO,wod.id_job) =0 THEN 0
     ELSE
				(CASE WHEN WODEB.DBT_PER IS NULL THEN  
					--cast(sum((INVL_BFAMOUNT * (INVL_DIS/100)))  as decimal(15,2)) 
					CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN 
						--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) + (ISNULL(idl.INVL_BFAMOUNT, 0)) * (idl.INVL_VAT_PER/100))   * (INVL_DIS/100) )  as decimal(15,2)) 
						CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) )   * (INVL_DIS/100) )  AS DECIMAL(15,2))--ROW 722
					ELSE
						cast(sum((INVL_BFAMOUNT * (INVL_DIS/100) ))  as decimal(15,2)) 
					END
				ELSE
					CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN 
						--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (WODEB.WO_VAT_PERCENTAGE/100)) * (dbo.fn_getSpreDiscPerc(idl.CREATED_BY,ID_DEBITOR,idl.ID_ITEM_INVL,idl.ID_MAKE,idl.ID_WAREHOUSE)/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 						
						CASE WHEN (SELECT COUNT(*) FROM TBL_WO_DEBITOR_DETAIL DEBT WHERE DEBT.ID_WO_NO = WOD.ID_WO_NO AND DEBT.ID_WO_PREFIX = WOD.ID_WO_PREFIX  AND DEBT.ID_JOB_ID = WOD.ID_JOB) > 1 THEN
							--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (WODEB.WO_VAT_PERCENTAGE/100)) * (dbo.fn_getSpreDiscPerc(idl.CREATED_BY,ID_DEBITOR,idl.ID_ITEM_INVL,idl.ID_MAKE,idl.ID_WAREHOUSE)/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 						
							--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (idl.INVL_VAT_PER/100)) * (INVL_DIS/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 
							/*Change to handle discounted spare parts for a job with owner pay vat */	
						--	cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (idl.INVL_VAT_PER/100)) * (INVL_DIS/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2))
							CASE WHEN ((SELECT ID_CUST_WO FROM TBL_WO_HEADER WHERE ID_WO_NO=WOD.ID_WO_NO AND ID_WO_PREFIX=WOD.ID_WO_PREFIX)<>(ih.ID_DEBITOR) and ((select WO_OWN_PAY_VAT from TBL_WO_DETAIL where ID_WO_NO=wod.ID_WO_NO and ID_WO_PREFIX=wod.ID_WO_PREFIX and id_job=WOD.ID_JOB)=1)) THEN
								CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) * (INVL_DIS/100) )  AS DECIMAL(15,2))
							ELSE
								CASE WHEN ((SELECT ID_CUST_WO FROM TBL_WO_HEADER WHERE ID_WO_NO=WOD.ID_WO_NO AND ID_WO_PREFIX=WOD.ID_WO_PREFIX)=(ih.ID_DEBITOR) and ((select WO_OWN_PAY_VAT from TBL_WO_DETAIL where ID_WO_NO=wod.ID_WO_NO and ID_WO_PREFIX=wod.ID_WO_PREFIX and id_job=WOD.ID_JOB)=1) and WODEB.DBT_PER = 0.00) THEN
									0 --Row 722
								ELSE
									--CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(IDL.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (IDL.INVL_VAT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
									CASE WHEN ((SELECT SUM(INVL_VAT_AMOUNT) FROM TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO=ih.ID_INV_NO)=0 AND INVL_VAT_PER<>0.00) THEN
										CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
									ELSE
										CASE WHEN ((SELECT SUM(INVL_VAT_AMOUNT) FROM TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO=ih.ID_INV_NO)=0 AND (WODEB.WO_VAT_PERCENTAGE<>0.00 AND WODEB.WO_VAT_PERCENTAGE<>1.00)) THEN
											CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))--Row 722
										ELSE
											CASE WHEN (WODEB.WO_VAT_PERCENTAGE=0.00 and IDL.INVL_VAT_PER<>0.00 and idl.INVL_VAT=0.00) THEN			
												CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) ) * (INVL_DIS/100))  AS DECIMAL(15,2))--Row 722
											ELSE
												CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))--Row 722
											END
										END
									END
								END
							END
						/*Change End */	
						ELSE
							CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) ) * (INVL_DIS/100) /*(IDL.INVL_VAT_PER/100)) * (INVL_DIS/100) MODIFIED ON :30/3/10*/ )  AS DECIMAL(15,2)) 		--ROW 722				
						END
					ELSE
						CAST(SUM((INVL_BFAMOUNT * (INVL_DIS/100) * (WODEB.DBT_PER/100)))  AS DECIMAL(15,2)) 
					END

				END)
				* 		(CASE WHEN wod.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
		ELSE 
			CASE WHEN wod.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(wod.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
					(wod.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(wod.WO_FIXED_PRICE+wod.WO_TOT_VAT_AMT)*/
				(wod.WO_FIXED_PRICE+(wod.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,wod.ID_WO_PREFIX,wod.ID_WO_NO,wod.id_job)  )) 
			 --AMOUNT + VAT
			END
		END) 
				--* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))
		END
		END
		     
		-- ************ End Of Modification ************  
		 --change end      
			 ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
			 ,@TRANSRES          
		  ,INV_TRANSDATE                
			 ,ID_Dept_Inv                
			 ,Cust_AccCode   
		  
		  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		 -- (SELECT TextCode   
			-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
			--WHERE ID_SETTINGS =   
		 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
			--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		 --  AND ID_INV_CONFIG =   
			--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
			--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))
		 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
		  END AS TEXTCODE   
		  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		  --,'00.00.0000' AS DUE_DATE   
		  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
		  ,'' AS CUST_ID   
		  ,ih.ID_DEBITOR AS CUST_NO    
		  ,'' AS CUST_NAME   
		  ,'' AS CUST_ADDR1   
		  ,'' AS CUST_ADDR2   
		  ,'' AS CUST_POST_CODE   
		  ,'' AS CUST_PLACE   
		  ,'' AS CUST_PHONE   
		  ,'' AS CUST_FAX   
		  ,'0.00' AS CUST_CREDIT_LIMIT   
		  ,0 CUST_PAYTERM   
		  ,0 AS CUST_GROUP
		  ,ID_CN_NO 
		  --,cg.ID_VAT_CD
		  ,idl.INVL_VAT_CODE
		 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		 ,WOD.ID_JOB
		 , WOD.ID_WO_NO
		 ,WOD.ID_WO_PREFIX
		 ,idl.ID_WOITEM_SEQ
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                            
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL    
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER >= 0))) 
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
		AND WOD.WO_FIXED_PRICE <>0 AND (ISNULL(WOD.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(WOD.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(WOD.WO_TOT_VAT_AMT_FP,0)>0) 
		--AND ISNULL(WOD.WO_OWN_RISK_AMT,0)=0
-- ***********************************  
-- Modified Date : 10th November 2008  
-- Bug Id   : 4271  
 GROUP BY  
	ih.ID_INV_NO                
	,DT_INVOICE 
	,DT_CREDITNOTE                
	,INV_CUST_GROUP                
	,DPT_AccCode,DPT_Name                
	,INVL_SPARES_ACCOUNTCODE                
	,INV_TRANSACTIONID                
	,INV_TRANSDATE                
	,ID_Dept_Inv                
	,Cust_AccCode  
	,ih.ID_Subsidery_Inv  
	,ih.DT_CREATED    
	,INVL_VAT_PER   
	,idl.INVL_VAT_CODE  
	,ih.INV_KID  
	,ih.ID_DEBITOR  
	,ih.CUST_NAME  
	,ih.CUST_PERM_ADD1  
	,ih.CUST_PERM_ADD2  
	,cg.ID_PAY_TERM  
	,id.FLG_FIXED_PRICE 
	,WODEB.DBT_PER
	,WODEB.WO_VAT_PERCENTAGE
	,ID_CN_NO 
	,cg.ID_VAT_CD
	,FLG_EXPORTED_AND_CREDITED 
	,WOD.ID_WO_NO 
	,WOD.ID_WO_PREFIX
	,WOD.ID_JOB
	, WOD.ID_WO_NO
	,WOD.ID_WO_PREFIX
	,idl.INVL_VAT
	,idl.ID_WOITEM_SEQ
	,wod.WO_FIXED_PRICE
	,wod.WO_TOT_VAT_AMT
	,wod.WO_OWN_CR_CUST
	,wod.WO_OWN_RISK_CUST
	,wod.WO_OWN_PAY_VAT
	,WODEB.DEBTOR_VAT_PERCENTAGE
-- ***** End Of Modification *************      

 --------------------**********************ROW 274 FOR SPARES DISCOUNT CREDIT - START
  --SPARES - DISCOUNT                
   INSERT INTO @SPARES                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
     TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
     CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP ,
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,JOBNO , ORDERNO,ID_WO_PREFIX,ID_WOITEM_SEQ
    )                 
    SELECT   DISTINCT               
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'SPARESDIFF'                
		 ,'DISCOUNTC'                
		 ,INVL_SPARES_ACCOUNTCODE                
		 --Bug ID:-ss7 30b      
		 --Date  :-22-Oct-2008      
		 --desc  :-Invoice Amount was wrongly called      
			 --,INVL_AMOUNT                
		  
		-- ***********************************  
		-- Modified Date : 10th November 2008  
		-- Bug Id   : 4271  
		 ,
		 CASE WHEN id.FLG_FIXED_PRICE = 0 THEN
				0
		 ELSE 
				(CASE WHEN WODEB.DBT_PER IS NULL THEN  
					--cast(sum((INVL_BFAMOUNT * (INVL_DIS/100)))  as decimal(15,2)) 
					CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN 
						--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) + (ISNULL(idl.INVL_BFAMOUNT, 0)) * (idl.INVL_VAT_PER/100))   * (INVL_DIS/100) )  as decimal(15,2)) 
						cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) + ((ISNULL(idl.INVL_BFAMOUNT, 0)) * (idl.INVL_VAT_PER/100)))   * (INVL_DIS/100))  as decimal(15,2))
					ELSE
						cast(sum((INVL_BFAMOUNT * (INVL_DIS/100) ))  as decimal(15,2)) 
					END
				ELSE
					CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN 
						--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (WODEB.WO_VAT_PERCENTAGE/100)) * (dbo.fn_getSpreDiscPerc(idl.CREATED_BY,ID_DEBITOR,idl.ID_ITEM_INVL,idl.ID_MAKE,idl.ID_WAREHOUSE)/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 						
						CASE WHEN (SELECT COUNT(*) FROM TBL_WO_DEBITOR_DETAIL DEBT WHERE DEBT.ID_WO_NO = WOD.ID_WO_NO AND DEBT.ID_WO_PREFIX = WOD.ID_WO_PREFIX  AND DEBT.ID_JOB_ID = WOD.ID_JOB) > 1 THEN
							--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (WODEB.WO_VAT_PERCENTAGE/100)) * (dbo.fn_getSpreDiscPerc(idl.CREATED_BY,ID_DEBITOR,idl.ID_ITEM_INVL,idl.ID_MAKE,idl.ID_WAREHOUSE)/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 						
							--cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (idl.INVL_VAT_PER/100)) * (INVL_DIS/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 
							/*Change to handle discounted spare parts for a job with owner pay vat */	
						--	cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (idl.INVL_VAT_PER/100)) * (INVL_DIS/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2))
							CASE WHEN ((SELECT ID_CUST_WO FROM TBL_WO_HEADER WHERE ID_WO_NO=WOD.ID_WO_NO AND ID_WO_PREFIX=WOD.ID_WO_PREFIX)<>(ih.ID_DEBITOR) and ((select WO_OWN_PAY_VAT from TBL_WO_DETAIL where ID_WO_NO=wod.ID_WO_NO and ID_WO_PREFIX=wod.ID_WO_PREFIX and id_job=WOD.ID_JOB)=1)) THEN
								CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) * (INVL_DIS/100) )  AS DECIMAL(15,2))
							ELSE
								CASE WHEN ((SELECT ID_CUST_WO FROM TBL_WO_HEADER WHERE ID_WO_NO=WOD.ID_WO_NO AND ID_WO_PREFIX=WOD.ID_WO_PREFIX)=(ih.ID_DEBITOR) and ((select WO_OWN_PAY_VAT from TBL_WO_DETAIL where ID_WO_NO=wod.ID_WO_NO and ID_WO_PREFIX=wod.ID_WO_PREFIX and id_job=WOD.ID_JOB)=1) and WODEB.DBT_PER = 0.00) THEN
									CAST(SUM(((ISNULL(IDL.INVL_BFAMOUNT, 0)) * (IDL.INVL_VAT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
								ELSE
									--CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(IDL.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (IDL.INVL_VAT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
									CASE WHEN ((SELECT SUM(INVL_VAT_AMOUNT) FROM TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO=ih.ID_INV_NO)=0 AND INVL_VAT_PER<>0.00) THEN
										CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
									ELSE
										CASE WHEN ((SELECT SUM(INVL_VAT_AMOUNT) FROM TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO=ih.ID_INV_NO)=0 AND (WODEB.WO_VAT_PERCENTAGE<>0.00 AND WODEB.WO_VAT_PERCENTAGE<>1.00)) THEN
											CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(IDL.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (WODEB.WO_VAT_PERCENTAGE/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
										ELSE
											CASE WHEN (WODEB.WO_VAT_PERCENTAGE=0.00 and IDL.INVL_VAT_PER<>0.00 and idl.INVL_VAT=0.00) THEN			
												CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(IDL.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (WODEB.WO_VAT_PERCENTAGE/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
											ELSE
												CAST(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(IDL.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (IDL.INVL_VAT_PER/100)) * (INVL_DIS/100))  AS DECIMAL(15,2))
											END
										END
									END
								END
							END
						/*Change End */	
						ELSE
							cast(SUM(((ISNULL(INVL_BFAMOUNT,0)) *  (WODEB.DBT_PER/100) + (ISNULL(idl.INVL_BFAMOUNT, 0) *  (WODEB.DBT_PER/100)) * (idl.INVL_VAT_PER/100)) * (INVL_DIS/100) /*(idl.INVL_VAT_PER/100)) * (INVL_DIS/100) Modified on :30/3/10*/ )  as decimal(15,2)) 						
						END
					ELSE
						cast(sum((INVL_BFAMOUNT * (INVL_DIS/100) * (WODEB.DBT_PER/100)))  as decimal(15,2)) 
					END

				END) * (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))
		END
		     
		-- ************ End Of Modification ************  
		 --change end      
			 ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER                
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
			 ,@TRANSRES          
		  ,INV_TRANSDATE                
			 ,ID_Dept_Inv                
			 ,Cust_AccCode   
		  
		  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		 -- (SELECT TextCode   
			-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
			--WHERE ID_SETTINGS =   
		 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
			--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		 --  AND ID_INV_CONFIG =   
			--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
			--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))
		 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
		  END AS TEXTCODE   
		  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		 -- ,'00.00.0000' AS DUE_DATE
		 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX     
		  ,'' AS CUST_ID   
		  ,ih.ID_DEBITOR AS CUST_NO    
		  ,'' AS CUST_NAME   
		  ,'' AS CUST_ADDR1   
		  ,'' AS CUST_ADDR2   
		  ,'' AS CUST_POST_CODE   
		  ,'' AS CUST_PLACE   
		  ,'' AS CUST_PHONE   
		  ,'' AS CUST_FAX   
		  ,'0.00' AS CUST_CREDIT_LIMIT   
		  ,0 CUST_PAYTERM   
		  ,0 AS CUST_GROUP
		  ,ID_CN_NO 
		  --,cg.ID_VAT_CD
		  ,idl.INVL_VAT_CODE
		 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		 ,WOD.ID_JOB
		 , WOD.ID_WO_NO
		 ,WOD.ID_WO_PREFIX
		 ,idl.ID_WOITEM_SEQ
    FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
    INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
    LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX AND WODEB.ID_JOB_ID = WOD.ID_JOB
    	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
    INNER JOIN TBL_INV_DETAIL_LINES idl 
    ON ih.ID_INV_NO = idl.ID_INV_NO 
		AND id.ID_WODET_INV = idl.ID_WODET_INVL 
    INNER JOIN TBL_MAS_DEPT md                
    ON   ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN TBL_MAS_CUST_GROUP cg                
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                            
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL    
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER >= 0))) 
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
		AND md.FLG_INTCUST_EXP = 1
		--and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
		AND ISNULL(cg.USE_INTCUST,0)=1
-- ***********************************  
-- Modified Date : 10th November 2008  
-- Bug Id   : 4271  
 GROUP BY  
	ih.ID_INV_NO                
	,DT_INVOICE 
	,DT_CREDITNOTE                
	,INV_CUST_GROUP                
	,DPT_AccCode,DPT_Name                
	,INVL_SPARES_ACCOUNTCODE                
	,INV_TRANSACTIONID                
	,INV_TRANSDATE                
	,ID_Dept_Inv                
	,Cust_AccCode  
	,ih.ID_Subsidery_Inv  
	,ih.DT_CREATED    
	,INVL_VAT_PER   
	,idl.INVL_VAT_CODE  
	,ih.INV_KID  
	,ih.ID_DEBITOR  
	,ih.CUST_NAME  
	,ih.CUST_PERM_ADD1  
	,ih.CUST_PERM_ADD2  
	,cg.ID_PAY_TERM  
	,id.FLG_FIXED_PRICE 
	,WODEB.DBT_PER
	,WODEB.WO_VAT_PERCENTAGE
	,ID_CN_NO 
	,cg.ID_VAT_CD
	,FLG_EXPORTED_AND_CREDITED 
	,WOD.ID_WO_NO 
	,WOD.ID_WO_PREFIX
	,WOD.ID_JOB
	, WOD.ID_WO_NO
	,WOD.ID_WO_PREFIX
	,idl.INVL_VAT
	,idl.ID_WOITEM_SEQ
-- ***** End Of Modification *************      
 --------------------**********************ROW 274 FOR SPARES DISCOUNT CREDIT - END
              
/******************--------------SPARE PARTS ROW 475 FIXED PRICE CHANGE END---------------------********/



   --CODING TO UPDATE THE INVOICE NUMBER                
    --UPDATE @SPARES SET INVOICE_NO = SUBSTRING(ID_INV_NO,LEN(INVOICE_PREFIX)+1,LEN(ID_INV_NO)-LEN(INVOICE_PREFIX))                          
   --END SPARES   
	
		INSERT INTO @SPARES 
		(                 
		 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
		 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
		 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
		 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED
		)
		SELECT ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
		 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
		 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, 
		 CUST_GROUP, NULL, LA_VAT_CODE, 0 
		FROM @SPARES WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0
     
--SELECT '@SPARES',* FROM @SPARES
  --GARAGE MATERIAL                 
  DECLARE @GARAGEMATERIAL TABLE                                
  (                                
		ID_INV_NO    VARCHAR(50),                
		DATE_INVOICE   DATETIME,                
		INV_CUST_GROUP   VARCHAR(100),              
		DEPT_ACC_CODE   VARCHAR(100),                
		INVOICETYPE    VARCHAR(20),                
		ACCMATRIXTYPE   VARCHAR(20),                   
		INVL_ACCCODE   VARCHAR(20),                
		INVOICE_AMT    NUMERIC(15,2),                
		INVOICE_VAT_PER   NUMERIC(5,2),                
		INVOICE_PREFIX   VARCHAR(20),                
		INVOICE_NO    VARCHAR(50),                
		INVOICE_TRANSACTIONID VARCHAR(25),                
		INVOICE_TRANSACTIONDATE DATETIME,                
		ID_DEPT_INV    INT,                          
		CUST_ACCCODE   VARCHAR(20),   
		TEXTCODE VARCHAR(50),   
		VOUCHER_TEXT VARCHAR(100),   
		EXT_VAT_CODE CHAR(1),   
		DUE_DATE VARCHAR(20),   
		CUST_ID VARCHAR(50),   
		CUST_NO INT,   
		CUST_NAME VARCHAR(100),   
		CUST_ADDR1 VARCHAR(50),   
		CUST_ADDR2 VARCHAR(50),   
		CUST_POST_CODE VARCHAR(10),   
		CUST_PLACE VARCHAR(50),   
		CUST_PHONE VARCHAR(20),   
		CUST_FAX VARCHAR(20),   
		CUST_CREDIT_LIMIT NUMERIC(15,2),   
		CUST_PAYTERM VARCHAR(20),   
		CUST_GROUP VARCHAR(20),
		ID_CN_NO VARCHAR(15), 
		LA_VAT_CODE INT,
		FLG_EXPORTED_AND_CREDITED BIT,
		ID_JOB INT ,
		ID_WO_NO INT,
		ID_WO_PREFIX VARCHAR(5)	 
  )                
                
   --GM - SELLING                
   INSERT INTO @GARAGEMATERIAL                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
	 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX
    )                 
    SELECT  DISTINCT         
		ih.ID_INV_NO                
		,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		ELSE DT_CREDITNOTE END        
		,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		,DPT_AccCode+'_'+DPT_Name                
		,'GARAGEMATERIAL'                
		,'SELLING'                
		,INVD_GM_ACCCODE    
		,	CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
				isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
		ELSE
				isnull(INVDT.LINE_AMOUNT_NET,0)
		END
		,ISNULL(INVDT.LINE_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		,@TRANSRES                
		,INV_TRANSDATE                
		,ID_Dept_Inv                
		,Cust_AccCode   
		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
		END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO 
		,cg.ID_VAT_CD
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,idl.ID_JOB		
		,idl.ID_WO_NO 
		,idl.ID_WO_PREFIX
    FROM                
     TBL_INV_HEADER ih                
    INNER JOIN                 
     TBL_INV_DETAIL idl                
    ON ih.ID_INV_NO = idl.ID_INV_NO                
	INNER JOIN                
	  TBL_MAS_DEPT md                
		ON ih.ID_Dept_Inv = md.ID_DEPT                
		INNER JOIN                 
		 TBL_MAS_CUST_GROUP cg                
		ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP    
 --INNER JOIN TBL_WO_DETAIL DET  
 --ON DET.ID_WO_NO = idl.ID_WO_NO  
 --AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX   
 --AND DET.ID_JOB = idl.ID_JOB 
 --INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
 --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB  AND WODEB.id_job_id= det.id_job
	INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='GM'
	 and idl.ID_WO_NO = INVDT.ID_WO_NO AND idl.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 		AND ih.ID_DEBITOR = INVDT.DEBTOR_ID  AND idl.id_job = INVDT.ID_JOB_ID
	WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
		AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
		AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
		OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
		AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
 --AND WODEB.DBT_AMT <> 0 
 --AND (WODEB.DBT_PER > 0 OR DET.WO_OWN_PAY_VAT=1 )
 
 
 --------------------**********************ROW 274 FOR GM COST - START
 --GM - SELLING              
		INSERT INTO @GARAGEMATERIAL                
		(                 
		 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
		 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
		 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
		 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX
		)                 
		SELECT  DISTINCT         
			 ih.ID_INV_NO                
			 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
				ELSE DT_CREDITNOTE END        
			 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
			 ,DPT_AccCode+'_'+DPT_Name                
			 ,'GARAGEMATERIAL'                
			 ,'COST'                
			 ,INVD_GM_ACCCODE 
			,CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
 							isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
 				ELSE
 							isnull(INVDT.LINE_AMOUNT_NET,0)
			 END  
			,ISNULL(INVD_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
			,@TRANSRES                
			,INV_TRANSDATE                
			,ID_Dept_Inv                
			,Cust_AccCode   
			,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
			END AS TEXTCODE   
			,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
			,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
			,'' AS CUST_ID   
			,ih.ID_DEBITOR AS CUST_NO    
			,'' AS CUST_NAME   
			,'' AS CUST_ADDR1   
			,'' AS CUST_ADDR2   
			,'' AS CUST_POST_CODE   
			,'' AS CUST_PLACE   
			,'' AS CUST_PHONE   
			,'' AS CUST_FAX   
			,'0.00' AS CUST_CREDIT_LIMIT   
			,0 CUST_PAYTERM   
			,0 AS CUST_GROUP
			,ID_CN_NO 
			,cg.ID_VAT_CD
			,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
			,idl.ID_JOB		
			,idl.ID_WO_NO 
			,idl.ID_WO_PREFIX
		FROM TBL_INV_HEADER ih INNER JOIN                 
		 TBL_INV_DETAIL idl             
		ON ih.ID_INV_NO = idl.ID_INV_NO                
		INNER JOIN                
		  TBL_MAS_DEPT md                
			ON ih.ID_Dept_Inv = md.ID_DEPT                
			INNER JOIN                 
			 TBL_MAS_CUST_GROUP cg                
			ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP    
		 --INNER JOIN TBL_WO_DETAIL DET  
		 --ON DET.ID_WO_NO = idl.ID_WO_NO  
		 --AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX   
		 --AND DET.ID_JOB = idl.ID_JOB 
		 --INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
 		--AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB  AND WODEB.id_job_id= det.id_job
	   INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='GM'
		AND IDL.ID_WO_NO = INVDT.ID_WO_NO AND IDL.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = INVDT.DEBTOR_ID  AND idl.id_job = INVDT.ID_JOB_ID
		WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
		AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
		AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
		 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
		AND   ih.ID_INV_NO IS NOT NULL                 
	 --Fazal  
		AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		--AND WODEB.DBT_AMT > 0  AND (WODEB.DBT_PER > 0 OR DET.WO_OWN_PAY_VAT=1 )
		AND md.FLG_INTCUST_EXP = 1
		--and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00 
		AND ISNULL(cg.USE_INTCUST,0)=1  
------------------------------------------------**********************ROW 274 FOR GM COST - END

   --GM - DISCOUNT                 
   INSERT INTO @GARAGEMATERIAL                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX 
    )                 
    SELECT DISTINCT                
		ih.ID_INV_NO                
		,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		ELSE DT_CREDITNOTE END                
		,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		,DPT_AccCode+'_'+DPT_Name                
		,'GARAGEMATERIAL'                
		,'DISCOUNT'                
		,INVD_GM_ACCCODE   
		,isnull(INVDT.LINE_DISCOUNT,0)
		,ISNULL(INVD_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		,@TRANSRES                
		,INV_TRANSDATE                
		,ID_Dept_Inv                
		,Cust_AccCode   
		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
		 END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO 
		,cg.ID_VAT_CD
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,idl.ID_JOB
		,idl.ID_WO_NO 
		,idl.ID_WO_PREFIX
    FROM                
     TBL_INV_HEADER ih                
    INNER JOIN                 
     TBL_INV_DETAIL idl                
    ON ih.ID_INV_NO = idl.ID_INV_NO                
    INNER JOIN                 
     TBL_MAS_DEPT md                
    ON ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN                 
     TBL_MAS_CUST_GROUP cg                
    ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                
  --INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
  --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
 --INNER JOIN TBL_WO_DETAIL DET  
 --ON DET.ID_WO_NO = idl.ID_WO_NO  
 --AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX  
 --AND DET.ID_JOB = idl.ID_JOB    
  INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='GM'
 and idl.ID_WO_NO = INVDT.ID_WO_NO AND idl.ID_WO_PREFIX= INVDT.ID_WO_PREFIX 
 	AND ih.ID_DEBITOR = INVDT.DEBTOR_ID  AND idl.id_job = INVDT.ID_JOB_ID
 --END OF MODIFICATION  
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
 --AND WODEB.DBT_PER > 0 
 --AND WODEB.DBT_AMT <> 0 
           

/******************--------------GARAGEMATERIAL ROW 475 FIXED PRICE CHANGE START---------------------********/

   --GM - SELLING                
   INSERT INTO @GARAGEMATERIAL                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
	 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX
    )                 
    SELECT  DISTINCT         
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END        
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'GARAGEMATERIALDIFF'                
		 ,'SELLING'                
		 ,INVD_GM_ACCCODE    
		-- *********************************  
		-- Modified Date : 28th February 2009  
		-- Bug ID   : Bug List Issues : Bl - 115              
		 --,IN_DEB_GM_AMT - INVD_VAT_AMOUNT                
		, 
		--CASE WHEN idl.FLG_FIXED_PRICE = 0 THEN
		CASE WHEN ISNULL((SELECT MAX(CONVERT(INT,FLG_FIXED_PRICE)) FROM TBL_INV_DETAIL IDX WHERE IDX.ID_INV_NO=ih.ID_INV_NO),0) =0 THEN
			0
		ELSE
		CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job) =0 THEN 0
     ELSE
	 		(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
									-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
						CASE WHEN DET.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
							(DET.WO_TOT_GM_AMT_FP - (DET.WO_TOT_GM_AMT_FP * (ISNULL(DET.WO_DISCOUNT, 0) /100))) * ((ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) )
						ELSE
						(DET.WO_TOT_GM_AMT_FP + ((DET.WO_TOT_GM_AMT_FP - (DET.WO_TOT_GM_AMT_FP * (ISNULL(DET.WO_DISCOUNT, 0) /100))) * (CASE WHEN WODEB.WO_FIXED_VATPER =1 THEN (ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) ELSE (ISNULL(WODEB.WO_FIXED_VATPER,0)/100) END)/*(ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) Modified on 30/3/10*/ )) * (WODEB.DBT_PER/100) 		
							--(DET.WO_TOT_GM_AMT_FP + ((DET.WO_TOT_GM_AMT_FP - (DET.WO_TOT_GM_AMT_FP * (ISNULL(DET.WO_DISCOUNT, 0) /100))) * (CASE WHEN WODEB.WO_VAT_PERCENTAGE =1 THEN (ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) ELSE (ISNULL(WODEB.WO_VAT_PERCENTAGE,0)/100) END)/*(ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) Modified on 30/3/10*/ )) * (WODEB.DBT_PER/100) 
						END
			ELSE  
				WO_TOT_GM_AMT_FP * (WODEB.DBT_PER/100)   
			END ) 
		*		(CASE WHEN DET.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(DET.WO_FIXED_PRICE+DET.WO_TOT_VAT_AMT)*/
			(DET.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job)  )) 
		ELSE 
			CASE WHEN DET.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(DET.WO_FIXED_PRICE+DET.WO_TOT_VAT_AMT)*/
				(DET.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(DET.WO_FIXED_PRICE+DET.WO_TOT_VAT_AMT)*/
				(DET.WO_FIXED_PRICE+(DET.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)
			 
			--* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END)) 
		END
		END
		-- ************ End OF Modification *******  
		 ,ISNULL(INVD_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		 ,@TRANSRES                
		 ,INV_TRANSDATE                
		 ,ID_Dept_Inv                
		 ,Cust_AccCode   

		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		--(SELECT TextCode   
		-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		--(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
		--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		--AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
		(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
		END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		--,'00.00.0000' AS DUE_DATE   
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO 
		,cg.ID_VAT_CD
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,idl.ID_JOB		
		,DET.ID_WO_NO 
		,DET.ID_WO_PREFIX
    FROM                
     TBL_INV_HEADER ih                
    INNER JOIN                 
     TBL_INV_DETAIL idl                
    ON ih.ID_INV_NO = idl.ID_INV_NO                
INNER JOIN                
  TBL_MAS_DEPT md                
    ON ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN                 
     TBL_MAS_CUST_GROUP cg                
    ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP    
 INNER JOIN TBL_WO_DETAIL DET  
 ON DET.ID_WO_NO = idl.ID_WO_NO  
 AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX   
 AND DET.ID_JOB = idl.ID_JOB 
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
 	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB  AND WODEB.id_job_id= det.id_job
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
 --AND WODEB.DBT_AMT <> 0  
 AND (WODEB.DBT_PER > 0 OR DET.WO_OWN_PAY_VAT=1 )
 AND DET.WO_FIXED_PRICE <>0 AND (ISNULL(DET.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(DET.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(DET.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(DET.WO_TOT_VAT_AMT_FP,0)>0) 
 --AND ISNULL(DET.WO_OWN_RISK_AMT,0)=0	
 
 
 --------------------**********************ROW 274 FOR GM COST - START
 --GM - SELLING              
		INSERT INTO @GARAGEMATERIAL                
		(                 
		 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
		 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
		 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
		 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX
		)                 
		SELECT  DISTINCT         
			 ih.ID_INV_NO                
			 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		ELSE DT_CREDITNOTE END        
			 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
			 ,DPT_AccCode+'_'+DPT_Name                
			 ,'GARAGEMATERIALDIFF'                
			 ,'COST'                
			 ,INVD_GM_ACCCODE, 
			CASE WHEN idl.FLG_FIXED_PRICE = 0 THEN
					0
			ELSE
					(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
											-- Modified to get the labour amout if it si owner pay vat : 04/05/2010
								CASE WHEN DET.WO_OWN_PAY_VAT=1 AND WODEB.DBT_PER=0 AND IH.ID_DEBITOR = WODEB.ID_JOB_DEB THEN
									(DET.WO_TOT_GM_AMT_FP - (DET.WO_TOT_GM_AMT_FP * (ISNULL(DET.WO_DISCOUNT, 0) /100))) * ((ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) )
								ELSE		
									(DET.WO_TOT_GM_AMT_FP + ((DET.WO_TOT_GM_AMT_FP - (DET.WO_TOT_GM_AMT_FP * (ISNULL(DET.WO_DISCOUNT, 0) /100))) * (CASE WHEN WODEB.WO_VAT_PERCENTAGE =1 THEN (ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) ELSE (ISNULL(WODEB.WO_VAT_PERCENTAGE,0)/100) END)/*(ISNULL(DET.WO_VAT_PERCENTAGE,0) / 100) Modified on 30/3/10*/ )) * (WODEB.DBT_PER/100) 
								END
					ELSE  
						WO_TOT_GM_AMT_FP * (WODEB.DBT_PER/100)   
					END) * (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END))  
			END
			 ,ISNULL(INVD_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
			 ,@TRANSRES                
			 ,INV_TRANSDATE                
			 ,ID_Dept_Inv                
			 ,Cust_AccCode   
			,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
			END AS TEXTCODE   
			,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
			,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
			--,'00.00.0000' AS DUE_DATE 
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
			,'' AS CUST_ID   
			,ih.ID_DEBITOR AS CUST_NO    
			,'' AS CUST_NAME   
			,'' AS CUST_ADDR1   
			,'' AS CUST_ADDR2   
			,'' AS CUST_POST_CODE   
			,'' AS CUST_PLACE   
			,'' AS CUST_PHONE   
			,'' AS CUST_FAX   
			,'0.00' AS CUST_CREDIT_LIMIT   
			,0 CUST_PAYTERM   
			,0 AS CUST_GROUP
			,ID_CN_NO 
			,cg.ID_VAT_CD
			,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
			,idl.ID_JOB		
			,DET.ID_WO_NO 
			,DET.ID_WO_PREFIX
		FROM TBL_INV_HEADER ih INNER JOIN                 
		 TBL_INV_DETAIL idl             
		ON ih.ID_INV_NO = idl.ID_INV_NO                
		INNER JOIN                
		  TBL_MAS_DEPT md                
			ON ih.ID_Dept_Inv = md.ID_DEPT                
			INNER JOIN                 
			 TBL_MAS_CUST_GROUP cg                
			ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP    
		 INNER JOIN TBL_WO_DETAIL DET  
		 ON DET.ID_WO_NO = idl.ID_WO_NO  
		 AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX   
		 AND DET.ID_JOB = idl.ID_JOB 
		 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
 		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB  AND WODEB.id_job_id= det.id_job
		WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
		AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
		AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
		 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
		AND   ih.ID_INV_NO IS NOT NULL                 
	 --Fazal  
		AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		AND WODEB.DBT_AMT > 0  AND (WODEB.DBT_PER > 0 OR DET.WO_OWN_PAY_VAT=1 )
		AND md.FLG_INTCUST_EXP = 1
		--and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00 
		AND ISNULL(cg.USE_INTCUST,0)=1  
------------------------------------------------**********************ROW 274 FOR GM COST - END

   --GM - DISCOUNT                 
   INSERT INTO @GARAGEMATERIAL                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
     ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX 
    )                 
    SELECT DISTINCT                
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
			   ELSE DT_CREDITNOTE END                
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'GARAGEMATERIALDIFF'                
		 ,'DISCOUNT'                
		 ,INVD_GM_ACCCODE   
		 --MODIFIED DATE: 07 NOV 2008  
		 --BUG ID: 4272, GARAGE MATERIAL DISCOUNT NEEDS TO BE DISPLAYED  
		   ,
		   --CASE WHEN idl.FLG_FIXED_PRICE = 0 THEN
		   CASE WHEN ISNULL((SELECT MAX(CONVERT(INT,FLG_FIXED_PRICE)) FROM TBL_INV_DETAIL IDX WHERE IDX.ID_INV_NO=ih.ID_INV_NO),0) =0 THEN
					0
			ELSE
			CASE WHEN dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job) =0 THEN 0
     ELSE
				(CAST(CASE WHEN ISNULL(DET.WO_GM_PER,0) > 0 AND ISNULL(WO_DISCOUNT,0) > 0
					THEN
						CASE WHEN WODEB.DBT_PER > 0 AND WODEB.DBT_PER < 100 THEN
							(isnull(WODEB.DBT_PER,0)/100)* ISNULL(WO_HOURLEY_PRICE,0) * ISNULL(WO_CHRG_TIME_FP,0) * ISNULL(DET.WO_GM_PER,0) * 0.01 * ISNULL(WO_DISCOUNT,0) * 0.01
						ELSE
							ISNULL(WO_HOURLEY_PRICE,0) * ISNULL(WO_CHRG_TIME_FP,0) * ISNULL(DET.WO_GM_PER,0) * 0.01 * ISNULL(WO_DISCOUNT,0) * 0.01
						END
				ELSE
						0
				END AS DECIMAL(20,2)))  
			*		(CASE WHEN DET.WO_OWN_CR_CUST=IH.ID_DEBITOR AND ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(DET.WO_FIXED_PRICE+DET.WO_TOT_VAT_AMT)*/
				(DET.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100)* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job)  )) 
		ELSE 
			CASE WHEN DET.WO_OWN_RISK_CUST=IH.ID_DEBITOR AND ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN
				(1 - (
				 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
					--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
				 --else
							/*(DET.WO_FIXED_PRICE+DET.WO_TOT_VAT_AMT)*/
				(DET.WO_FIXED_PRICE)* 
					(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
								1 
					ELSE 
								WODEB.DBT_PER/100.00 END)
				 --end
				 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job)  )) 
				 
				 
		ELSE
			(1 - (
			 --CASE WHEN (SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO and IDET.FLG_FIXED_PRICE=1)=(SELECT COUNT(*) FROM TBL_INV_DETAIL IDET WHERE IDET.ID_INV_NO=ih.ID_INV_NO) then 
				--dbo.FnGetInvoiceAmount(IH.ID_INV_NO)
			 --else
						/*(DET.WO_FIXED_PRICE+DET.WO_TOT_VAT_AMT)*/
			(DET.WO_FIXED_PRICE+(DET.WO_FIXED_PRICE*WODEB.DEBTOR_VAT_PERCENTAGE/100))* 
				(CASE WHEN (WODEB.DBT_PER=1.00) or (WODEB.DBT_PER=0) THEN 
							1 
				ELSE 
							WODEB.DBT_PER/100.00 END)
			 --end
			 /dbo.FnGetInvoiceAmountFP_order(IH.ID_INV_NO,DET.ID_WO_PREFIX,DET.ID_WO_NO,DET.id_job)  )) 
			 --AMOUNT + VAT
			END
		END)	
				 --* (1 - (SELECT dbo.FnGetInvoiceAmount(IH.ID_INV_NO) / CASE WHEN dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO)= 0 THEN 1 ELSE dbo.FnGetInvoiceAmountFP(IH.ID_INV_NO) END)) 
			END
			END
			AS DISCOUNT  
		  --Bug ID:-ss7 30b      
		  --Date  :-22-Oct-2008        
		  --Desc  :- Currently GM Discount amount is hard coded as 0 as GM DIS is not there      
		  --     ,0  --IN_DEB_GM_AMT - INVD_VAT_AMOUNT                
		  --change end      
		 --END OF MODIFICATION  
		  
			 ,ISNULL(INVD_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
			 ,@TRANSRES                
			 ,INV_TRANSDATE                
			 ,ID_Dept_Inv                
			 ,Cust_AccCode   
		  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		 -- (SELECT TextCode   
			-- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
			--WHERE ID_SETTINGS =   
		 --  (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
			--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		 --  AND ID_INV_CONFIG =   
			--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
			--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
		  	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
		  END AS TEXTCODE   
		  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		  --,'00.00.0000' AS DUE_DATE  
		  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
		  ,'' AS CUST_ID   
		  ,ih.ID_DEBITOR AS CUST_NO    
		  ,'' AS CUST_NAME   
		  ,'' AS CUST_ADDR1   
		  ,'' AS CUST_ADDR2   
		  ,'' AS CUST_POST_CODE   
		  ,'' AS CUST_PLACE   
		  ,'' AS CUST_PHONE   
		  ,'' AS CUST_FAX   
		  ,'0.00' AS CUST_CREDIT_LIMIT   
		  ,0 CUST_PAYTERM   
		  ,0 AS CUST_GROUP
		  ,ID_CN_NO 
		  ,cg.ID_VAT_CD
		  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		  ,idl.ID_JOB
		  ,DET.ID_WO_NO 
		  ,DET.ID_WO_PREFIX
    FROM                
     TBL_INV_HEADER ih                
    INNER JOIN                 
     TBL_INV_DETAIL idl                
    ON ih.ID_INV_NO = idl.ID_INV_NO                
    INNER JOIN                 
     TBL_MAS_DEPT md                
    ON ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN                 
     TBL_MAS_CUST_GROUP cg                
    ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                
  INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
  	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
 --MODIFIED DATE: 07 NOV 2008  
 --BUG ID: 4272, GARAGE MATERIAL DISCOUNT NEEDS TO BE DISPLAYED  
 INNER JOIN TBL_WO_DETAIL DET  
 ON DET.ID_WO_NO = idl.ID_WO_NO  
 AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX  
 AND DET.ID_JOB = idl.ID_JOB    
 --END OF MODIFICATION  
  
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
 AND WODEB.DBT_PER > 0 
 --AND WODEB.DBT_AMT <> 0 
 AND DET.WO_FIXED_PRICE <>0 AND (ISNULL(DET.WO_TOT_LAB_AMT_FP,0)>0 OR ISNULL(DET.WO_TOT_SPARE_AMT_FP,0)>0 OR ISNULL(DET.WO_TOT_GM_AMT_FP,0) >0 OR ISNULL(DET.WO_TOT_VAT_AMT_FP,0)>0) 
 --AND ISNULL(DET.WO_OWN_RISK_AMT,0)=0	

/******************--------------GARAGEMATERIAL ROW 475 FIXED PRICE CHANGE END---------------------********/


		
	INSERT INTO @GARAGEMATERIAL                
    (                 
		ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
		ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
		INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
		ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED  
    ) 
	SELECT 	ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2,CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, 
		CUST_GROUP, NULL, LA_VAT_CODE , 0 
	FROM @GARAGEMATERIAL WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0
                 
  --VAT   
  DECLARE @VAT TABLE   
  (   
	 ID_INV_NO VARCHAR(50),   
	 DATE_INVOICE DATETIME,   
	 INV_CUST_GROUP VARCHAR(100),   
	 DEPT_ACC_CODE VARCHAR(100),   
	 INVOICETYPE VARCHAR(20),   
	 ACCMATRIXTYPE VARCHAR(20),   
	 INVL_ACCCODE VARCHAR(20),   
	 INVOICE_AMT NUMERIC(15,2),   
	 INVOICE_PREFIX VARCHAR(20),   
	 INVOICE_NO VARCHAR(50),   
	 INVOICE_TRANSACTIONID VARCHAR(25),   
	 INVOICE_TRANSACTIONDATE DATETIME,   
	 ID_DEPT_INV INT,   
	 CUST_ACCCODE VARCHAR(20),   
	   
	 TEXTCODE VARCHAR(50),   
	 VOUCHER_TEXT VARCHAR(100),   
	 EXT_VAT_CODE CHAR(1),   
	 DUE_DATE VARCHAR(20),   
	 CUST_ID VARCHAR(50),   
	 CUST_NO INT,   
	 CUST_NAME VARCHAR(100),   
	 CUST_ADDR1 VARCHAR(50),   
	 CUST_ADDR2 VARCHAR(50),   
	 CUST_POST_CODE VARCHAR(10),   
	 CUST_PLACE VARCHAR(50),   
	 CUST_PHONE VARCHAR(20),   
	 CUST_FAX VARCHAR(20),   
	 CUST_CREDIT_LIMIT NUMERIC(15,2),   
	 CUST_PAYTERM VARCHAR(20),   
	 CUST_GROUP VARCHAR(20),
	 ID_CN_NO VARCHAR(15), 
	 LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT
  )   
  
  IF UPPER(@EXPTYPE) = 'NET'   
  BEGIN   
	 --VAT - SELLING 
			/* modified to add labour vat Dt:09-12-2009*/
		INSERT INTO @VAT   
		(   
		  ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,   
		  ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_PREFIX,   
		  INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		  TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		  CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
		  ID_CN_NO, LA_VAT_CODE ,FLG_EXPORTED_AND_CREDITED
		)   
		SELECT  DISTINCT  
			ih.ID_INV_NO   
			,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
				ELSE DT_CREDITNOTE END   
			,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'               
			,DPT_AccCode+'_'+DPT_Name   
			,'VAT'   
			,'SELLING'   
			,null--,idl.INVL_VAT_ACCCODE   
			,null--,idl.INVL_VAT_AMOUNT   
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
			,@TRANSRES   
			,INV_TRANSDATE   
			,ID_Dept_Inv   
			,Cust_AccCode   
			,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
			END AS TEXTCODE   
			,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
			,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
			,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
			,'' AS CUST_ID   
			,ih.ID_DEBITOR AS CUST_NO    
			,'' AS CUST_NAME   
			,'' AS CUST_ADDR1   
			,'' AS CUST_ADDR2   
			,'' AS CUST_POST_CODE   
			,'' AS CUST_PLACE   
			,'' AS CUST_PHONE   
			,'' AS CUST_FAX   
			,'0.00' AS CUST_CREDIT_LIMIT   
			,0 CUST_PAYTERM   
			,0 AS CUST_GROUP
			,ID_CN_NO 
			,cg.ID_VAT_CD 
			,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)
	  FROM TBL_INV_HEADER ih   
	  INNER JOIN tbl_inv_detail_lines_vat idl ON ih.ID_INV_NO = idl.ID_INV_NO   
		  --Bug ID :-ss7 30b   
		  --date  :-22-Oct-2008   
		  --desc  :- Vat amount wrongly called  
	  INNER JOIN TBL_INV_DETAIL id ON   ih.ID_INV_NO = id.ID_INV_NO 
	  --LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
  	--	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB
	  LEFT OUTER JOIN TBL_INV_DETAIL_LINES  INVDETLIN ON ih.ID_INV_NO = INVDETLIN.ID_INV_NO
	  --INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX
	  
	  --change end   
	  INNER JOIN TBL_MAS_DEPT md ON ih.ID_Dept_Inv = md.ID_DEPT AND FLG_DPT_WAREHOUSE=0   
	  INNER JOIN TBL_MAS_CUST_GROUP cg ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
		WHERE (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228   
	  AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	  AND (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
	   OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
	   AND ih.ID_INV_NO IS NOT NULL     --and ih.ID_INV_NO = 'FK12189'
	  --Fazal  
	  AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')   
	  AND id.ID_WODET_INV NOT IN (SELECT ID_WODET_INVL FROM TBL_INV_DETAIL_LINES_LABOUR) 
		--AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0))) 
		--AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))  
	  and id.FLG_FIXED_PRICE = 0
	/*
		DECLARE @VAT_CD VARCHAR(10)
		EXEC INVOICE_GETVATACCOUNTFORINV @iv_ID_INV_NO='FK12469', @VAT_CODE = @VAT_CD OUTPUT
	*/
	  UPDATE @VAT SET INVL_ACCCODE =DBO.fn_GetVATACCOUNTforINV(ID_INV_NO)
	  UPDATE @VAT SET INVOICE_AMT = DBO.fn_GetVATAMOUTFORINV(ID_INV_NO)
 
	 INSERT INTO @VAT   
	 (   
	  ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,   
	  ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_PREFIX,   
	  INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	  TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	  CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP , 
	  ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
	 )   
	 SELECT DISTINCT  
	  ih.ID_INV_NO   
	  ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
			ELSE DT_CREDITNOTE END   
	  ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'               
	  ,DPT_AccCode+'_'+DPT_Name   
	  ,'VAT'   
	  ,'SELLING'   
	  ,id.INVD_VAT_ACCOUNTCODE   
	  --Bug ID :-ss7 30b   
	  --date  :-22-Oct-2008   
	  --desc  :- Vat amount wrongly called   
	  --,INVL_VAT_AMOUNT   
	  -- ******************************************************  
	  -- Modified Date : 11TH November 2008  
	  -- Bug ID   : 4262   
	  --,INVL_VAT_AMOUNT  + INVDETLIN.INVL_VAT   
	   --,WOD.WO_TOT_VAT_AMT 
	  ,DBO.FnGetFixedVATAmount(ih.ID_INV_NO,id.ID_WODET_INV)
	  -- ************* End OF Modification ****************  
	  --change end   
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	  ,@TRANSRES   
	  ,INV_TRANSDATE   
	  ,ID_Dept_Inv   
	  ,Cust_AccCode   
	  
	  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 --  (SELECT TextCode   
		--  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		--(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		-- WHERE ID_SETTINGS =   
		--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		--AND ID_INV_CONFIG =   
		-- (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		-- ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		-- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
	  END AS TEXTCODE   
	  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT 
	  -- ******************************************
	  -- Modified Date : 16th December 2009
	  -- Bug Description :  External vat was not comming  
	  --,dbo.FnGetExtVATByVAT(INVDETLIN.INVL_VAT_CODE) AS EXT_VAT_CODE   
	  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE 
	  -- ********** End Of Modification ************
	  --,'00.00.0000' AS DUE_DATE  
	  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX   
	  ,'' AS CUST_ID   
	  ,ih.ID_DEBITOR AS CUST_NO    
	  ,'' AS CUST_NAME   
	  ,'' AS CUST_ADDR1   
	  ,'' AS CUST_ADDR2   
	  ,'' AS CUST_POST_CODE   
	  ,'' AS CUST_PLACE   
	  ,'' AS CUST_PHONE   
	  ,'' AS CUST_FAX   
	  ,'0.00' AS CUST_CREDIT_LIMIT   
	  ,0 CUST_PAYTERM   
	  ,0 AS CUST_GROUP
	  , ID_CN_NO 
	  ,cg.ID_VAT_CD
	  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		FROM TBL_INV_HEADER ih 
  		INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
  		INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
  			AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB 
		--INNER JOIN tbl_inv_detail_lines_vat idl ON ih.ID_INV_NO = idl.ID_INV_NO -- and idl.invl_vat_amount >0   
	  --Bug ID :-ss7 30b   
	  --date  :-22-Oct-2008   
	  --desc  :- Vat amount wrongly called   
	 -- LEFT OUTER JOIN TBL_INV_DETAIL_LINES  INVDETLIN ON ih.ID_INV_NO = INVDETLIN.ID_INV_NO   
	  --change end   
	  INNER JOIN TBL_MAS_DEPT md ON ih.ID_Dept_Inv = md.ID_DEPT   
	  INNER JOIN TBL_MAS_CUST_GROUP cg ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
	  INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX
		WHERE (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228   
	  AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	  AND (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
	   OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
	  AND ih.ID_INV_NO IS NOT NULL   
	  --Fazal  
	  AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
	  AND WODEB.DBT_PER > 0 AND WODEB.DBT_AMT > 0 and id.flg_fixed_price=1

	INSERT INTO @VAT   
	 (   
	  ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,   
	  ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_PREFIX,   
	  INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	  TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	  CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP , 
	  ID_CN_NO, LA_VAT_CODE,FLG_EXPORTED_AND_CREDITED 
	 )   
	 SELECT DISTINCT  
		  ih.ID_INV_NO   
		  ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
				ELSE DT_CREDITNOTE END   
		  ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'               
		  ,DPT_AccCode+'_'+DPT_Name   
		  ,'VAT'   
		  ,'SELLING'   
		  ,idl.INVL_VAT_ACCCODE   
		  --Bug ID :-ss7 30b   
		  --date  :-22-Oct-2008   
		  --desc  :- Vat amount wrongly called   
		  --,INVL_VAT_AMOUNT   
		  -- ******************************************************  
		  -- Modified Date : 11TH November 2008  
		  -- Bug ID   : 4262   
		  --,INVL_VAT_AMOUNT  + INVDETLIN.INVL_VAT   
		  ,	CASE WHEN id.FLG_FIXED_PRICE = 0 THEN 
				CASE WHEN INVL_VAT_AMOUNT = id.INVD_VAT_AMOUNT THEN 
					INVL_VAT_AMOUNT * (WODEB.DBT_PER/100) 
				WHEN  WODEB.DBT_PER IS NULL   THEN 
						INVL_VAT_AMOUNT
				ELSE
					INVL_VAT_AMOUNT * (WODEB.DBT_PER/100) 
				END
			ELSE
				WOD.WO_TOT_VAT_AMT 
			END 
		     
		  -- ************* End OF Modification ****************  
		  --change end   
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		  ,@TRANSRES   
		  ,INV_TRANSDATE   
		  ,ID_Dept_Inv   
		  ,Cust_AccCode   
		  
		  ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		 --  (SELECT TextCode   
			--  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
			--(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
			-- WHERE ID_SETTINGS =   
			--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
			-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
			--AND ID_INV_CONFIG =   
			-- (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
			-- ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			-- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))
		  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
		  END AS TEXTCODE   
		  ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT 
		  -- ******************************************
		  -- Modified Date : 16th December 2009
		  -- Bug Description :  External vat was not comming  
		  --,dbo.FnGetExtVATByVAT(INVDETLIN.INVL_VAT_CODE) AS EXT_VAT_CODE   
		  ,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE 
		  -- ********** End Of Modification ************
		  --,'00.00.0000' AS DUE_DATE   
		  ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
		  ,'' AS CUST_ID   
		  ,ih.ID_DEBITOR AS CUST_NO    
		  ,'' AS CUST_NAME   
		  ,'' AS CUST_ADDR1   
		  ,'' AS CUST_ADDR2   
		  ,'' AS CUST_POST_CODE   
		  ,'' AS CUST_PLACE   
		  ,'' AS CUST_PHONE   
		  ,'' AS CUST_FAX   
		  ,'0.00' AS CUST_CREDIT_LIMIT   
		  ,0 CUST_PAYTERM   
		  ,0 AS CUST_GROUP
		  ,ID_CN_NO 
		  ,cg.ID_VAT_CD
		  ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		FROM TBL_INV_HEADER ih 
  		INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
  		LEFT JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
  			AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND id.id_job = wodeb.id_job_id
		INNER JOIN tbl_inv_detail_lines_vat idl ON ih.ID_INV_NO = idl.ID_INV_NO  and idl.invl_vat_amount >0   
	  --Bug ID :-ss7 30b   
	  --date  :-22-Oct-2008   
	  --desc  :- Vat amount wrongly called   
	  LEFT OUTER JOIN TBL_INV_DETAIL_LINES  INVDETLIN ON ih.ID_INV_NO = INVDETLIN.ID_INV_NO   
	  --change end   
	  INNER JOIN TBL_MAS_DEPT md ON ih.ID_Dept_Inv = md.ID_DEPT   
	  INNER JOIN TBL_MAS_CUST_GROUP cg ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
	  INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX

		WHERE (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228   
	  AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	  AND (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE
			 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE ) 
	  AND ih.ID_INV_NO IS NOT NULL   
	  --Fazal  
	  AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
		AND (((WODEB.DBT_PER IS NULL) OR (WODEB.DBT_PER > 0))) 
		AND (((WODEB.DBT_AMT IS NULL) OR (WODEB.DBT_AMT <> 0)))
	  and id.flg_fixed_price <> 1

	    
	 --CODING TO UPDATE THE INVOICE NUMBER   
		--UPDATE @VAT SET INVOICE_NO = SUBSTRING(ID_INV_NO,LEN(INVOICE_PREFIX)+1,LEN(ID_INV_NO)-LEN(INVOICE_PREFIX))   
	 --END VAT   
	  
	   
	INSERT INTO @VAT   
		(   
		  ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
		  INVOICE_AMT,INVOICE_PREFIX, INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		  TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		  CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, 
		  CUST_GROUP, ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
		) 
	SELECT ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
		  INVOICE_AMT,INVOICE_PREFIX, INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
		  TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		  CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM,
		  CUST_GROUP, NULL, LA_VAT_CODE, 0 
	FROM @VAT WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0
 
  END  

-------------------------------------------- ROUNDING --------------------------------------  
  DECLARE @ROUNDING TABLE   
  (   
	 ID_INV_NO VARCHAR(50),   
	 DATE_INVOICE DATETIME,   
	 INV_CUST_GROUP VARCHAR(100),   
	 DEPT_ACC_CODE VARCHAR(100),   
	 INVOICETYPE VARCHAR(20),   
	 ACCMATRIXTYPE VARCHAR(20),   
	 INVL_ACCCODE VARCHAR(20),   
	 INVOICE_AMT NUMERIC(15,2),   
	 INVOICE_PREFIX VARCHAR(20),   
	 INVOICE_NO VARCHAR(50),   
	 INVOICE_TRANSACTIONID VARCHAR(25),   
	 INVOICE_TRANSACTIONDATE DATETIME,   
	 ID_DEPT_INV INT,   
	 CUST_ACCCODE VARCHAR(20),   
	 TEXTCODE VARCHAR(50),   
	 VOUCHER_TEXT VARCHAR(100),   
	 EXT_VAT_CODE CHAR(1),   
	 DUE_DATE VARCHAR(20),   
	 CUST_ID VARCHAR(50),   
	 CUST_NO INT,   
	 CUST_NAME VARCHAR(100),   
	 CUST_ADDR1 VARCHAR(50),   
	 CUST_ADDR2 VARCHAR(50),   
	 CUST_POST_CODE VARCHAR(10),   
	 CUST_PLACE VARCHAR(50),   
	 CUST_PHONE VARCHAR(20),   
	 CUST_FAX VARCHAR(20),   
	 CUST_CREDIT_LIMIT NUMERIC(15,2),   
	 CUST_PAYTERM VARCHAR(20),   
	 CUST_GROUP VARCHAR(20),
	 ID_CN_NO VARCHAR(15), 
	 LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT
  ) 
  
  INSERT INTO @ROUNDING   
  (   
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,   
	 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_PREFIX,   
	 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
  )  
   SELECT DISTINCT   
	ih.ID_INV_NO   
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		  ELSE DT_CREDITNOTE END   
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'   
    ,DPT_AccCode+'_'+DPT_Name   
    ,'ROUNDING'   
    ,'SELLING'   
    ,(SELECT ACCOUNT_CODE   
		FROM TBL_MAS_INV_CONFIGURATION   
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv   
			AND ID_DEPT_INV=ih.ID_Dept_Inv   
			AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS INVL_VAT_ACCCODE   
	,dbo.FnGetRoundingamountExport(ih.ID_INV_NO) 
	 AS INVOICE_AMT    
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES   
    ,INV_TRANSDATE   
    ,ID_Dept_Inv   
    ,Cust_AccCode   
	,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
	END AS TEXTCODE   
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
    ,(SELECT EXT_VAT_CODE   
		FROM TBL_MAS_INV_CONFIGURATION   
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv   
			AND ID_DEPT_INV=ih.ID_Dept_Inv   
			AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS EXT_VAT_CODE   
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	,'' AS CUST_ID   
	,ih.ID_DEBITOR AS CUST_NO    
	,'' AS CUST_NAME   
	,'' AS CUST_ADDR1   
	,'' AS CUST_ADDR2   
	,'' AS CUST_POST_CODE   
	,'' AS CUST_PLACE   
	,'' AS CUST_PHONE   
	,'' AS CUST_FAX   
	,'0.00' AS CUST_CREDIT_LIMIT   
	,0 CUST_PAYTERM   
	,0 AS CUST_GROUP
	, ID_CN_NO 
	,cg.ID_VAT_CD
	,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)  
   FROM TBL_INV_HEADER ih
    INNER JOIN TBL_INV_DETAIL idl ON IH.ID_INV_NO=idl.ID_INV_NO   
	INNER JOIN TBL_MAS_DEPT md ON ih.ID_Dept_Inv = md.ID_DEPT   
	INNER JOIN TBL_MAS_CUST_GROUP cg ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP  
	--INNER JOIN TBL_WO_DETAIL DET ON DET.ID_WO_NO= idl.ID_WO_NO AND DET.ID_WO_PREFIX=idl.ID_WO_PREFIX AND DET.ID_JOB=isnull(idl.id_job,0)
   WHERE (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1)   
	AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	AND (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE  
	 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE ) 
	AND ih.ID_INV_NO IS NOT NULL   
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
	
	
-------------------------------------**********************ROW 274 FOR ROUNDING COST - START

  INSERT INTO @ROUNDING   
  (   
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,   
	 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_PREFIX,   
	 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
  )  
   SELECT DISTINCT   
	ih.ID_INV_NO   
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		  ELSE DT_CREDITNOTE END   
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'   
    ,DPT_AccCode+'_'+DPT_Name   
    ,'ROUNDING'   
    ,'COST'   
    ,(SELECT ACCOUNT_CODE   
		FROM TBL_MAS_INV_CONFIGURATION   
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv   
			AND ID_DEPT_INV=ih.ID_Dept_Inv   
			AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS INVL_VAT_ACCCODE   
	,
	dbo.FnGetRoundingamountExport(ih.ID_INV_NO)
	 AS INVOICE_AMT   
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES   
    ,INV_TRANSDATE   
    ,ID_Dept_Inv   
    ,Cust_AccCode   
	,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
	END AS TEXTCODE   
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
    ,(SELECT EXT_VAT_CODE   
		FROM TBL_MAS_INV_CONFIGURATION   
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv   
			AND ID_DEPT_INV=ih.ID_Dept_Inv   
			AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS EXT_VAT_CODE   
	--,'00.00.0000' AS DUE_DATE   
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX 
	,'' AS CUST_ID   
	,ih.ID_DEBITOR AS CUST_NO    
	,'' AS CUST_NAME   
	,'' AS CUST_ADDR1   
	,'' AS CUST_ADDR2   
	,'' AS CUST_POST_CODE   
	,'' AS CUST_PLACE   
	,'' AS CUST_PHONE   
	,'' AS CUST_FAX   
	,'0.00' AS CUST_CREDIT_LIMIT   
	,0 CUST_PAYTERM   
	,0 AS CUST_GROUP
	, ID_CN_NO 
	,cg.ID_VAT_CD
	,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)  
   FROM TBL_INV_HEADER ih
	INNER JOIN TBL_INV_DETAIL idl ON IH.ID_INV_NO=idl.ID_INV_NO   
	INNER JOIN TBL_MAS_DEPT md ON ih.ID_Dept_Inv = md.ID_DEPT   
	INNER JOIN TBL_MAS_CUST_GROUP cg ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
   WHERE (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1)   
	AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	AND (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE  
	 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE ) 
	AND ih.ID_INV_NO IS NOT NULL   
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
    AND md.FLG_INTCUST_EXP = 1
	--and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00  
	AND ISNULL(cg.USE_INTCUST,0)=1 

	INSERT INTO @ROUNDING   
	(   
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
	 INVOICE_AMT,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
	)
	SELECT 	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
	 INVOICE_AMT,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, NULL, LA_VAT_CODE, 0 
	FROM @ROUNDING WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0
-------------------------------------------- OWNRISK --------------------------------------

  DECLARE @OWNRISK TABLE 
  ( 
	 ID_INV_NO VARCHAR(50), 
	 DATE_INVOICE DATETIME, 
	 INV_CUST_GROUP VARCHAR(100), 
	 DEPT_ACC_CODE VARCHAR(100), 
	 INVOICETYPE VARCHAR(20), 
	 ACCMATRIXTYPE VARCHAR(20), 
	 INVL_ACCCODE VARCHAR(20), 
	 INVOICE_AMT NUMERIC(15,2), 
	 INVOICE_PREFIX VARCHAR(20), 
	 INVOICE_NO VARCHAR(50), 
	 INVOICE_TRANSACTIONID VARCHAR(25), 
	 INVOICE_TRANSACTIONDATE DATETIME, 
	 ID_DEPT_INV INT, 
	 CUST_ACCCODE VARCHAR(20), 
	 TEXTCODE VARCHAR(50), 
	 VOUCHER_TEXT VARCHAR(100), 
	 EXT_VAT_CODE CHAR(1), 
	 DUE_DATE VARCHAR(20), 
	 CUST_ID VARCHAR(50), 
	 CUST_NO INT, 
	 CUST_NAME VARCHAR(100), 
	 CUST_ADDR1 VARCHAR(50), 
	 CUST_ADDR2 VARCHAR(50), 
	 CUST_POST_CODE VARCHAR(10), 
	 CUST_PLACE VARCHAR(50), 
	 CUST_PHONE VARCHAR(20), 
	 CUST_FAX VARCHAR(20), 
	 CUST_CREDIT_LIMIT NUMERIC(15,2), 
	 CUST_PAYTERM VARCHAR(20), 
	 CUST_GROUP VARCHAR(20),
	 ID_CN_NO VARCHAR(15), 
	 LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT,
	 ID_WO_PREFIX VARCHAR(3),
	 ID_WO_NO VARCHAR(10),
	 ID_JOB_ID	INT 
  )
  
  INSERT INTO @OWNRISK 
  ( 
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
	 INVOICE_AMT,INVOICE_PREFIX, INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE, 
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_WO_PREFIX,ID_WO_NO,ID_JOB_ID 
  )
  SELECT DISTINCT 
	ih.ID_INV_NO 
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		  ELSE DT_CREDITNOTE END 
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP' 
    ,DPT_AccCode+'_'+DPT_Name 
    ,'OWNRISK' 
    ,'SELLING' 
    ,(md.OWNRISK_ACCTCODE) AS INVL_ACCCODE
	,abs(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
 					isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
 		ELSE
 					isnull(INVDT.LINE_AMOUNT_NET,0)
		END) AS INVOICE_AMT
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES 
    ,INV_TRANSDATE 
    ,ID_Dept_Inv 
    ,Cust_AccCode 
	,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
	END AS TEXTCODE 
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT 
    ,(SELECT EXT_VAT_CODE 
		FROM TBL_MAS_INV_CONFIGURATION 
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv 
			AND ID_DEPT_INV=ih.ID_Dept_Inv 
		AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS EXT_VAT_CODE 
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
	,'' AS CUST_ID 
	,ih.ID_DEBITOR AS CUST_NO  
	,'' AS CUST_NAME 
	,'' AS CUST_ADDR1 
	,'' AS CUST_ADDR2 
	,'' AS CUST_POST_CODE 
	,'' AS CUST_PLACE 
	,'' AS CUST_PHONE 
	,'' AS CUST_FAX 
	,'0.00' AS CUST_CREDIT_LIMIT 
	,0 CUST_PAYTERM 
	,0 AS CUST_GROUP
	,ID_CN_NO 
	,cg.ID_VAT_CD
	,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0),id.ID_WO_PREFIX,id.ID_WO_NO,id.ID_JOB
  FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
	--INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX = WODEB.ID_WO_PREFIX 
	--	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND id.id_job=WODEB.ID_JOB_ID
	--INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO = WOD.ID_WO_NO AND ID.ID_WO_PREFIX = WOD.ID_WO_PREFIX 
	--	AND WOD.ID_JOB = id.id_job AND ISNULL(WOD.WO_OWN_RISK_AMT,0)<>0
    INNER JOIN TBL_MAS_DEPT md 
    ON   ih.ID_Dept_Inv = md.ID_DEPT 
    INNER JOIN TBL_MAS_CUST_GROUP cg 
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
	INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = IH.ID_INV_NO AND INVDT.LINE_TYPE='OWNRISK'
		AND ID.ID_WO_NO = INVDT.ID_WO_NO AND ID.ID_WO_PREFIX= INVDT.ID_WO_PREFIX AND ID.ID_JOB = INVDT.ID_JOB_ID  
  WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228 
	AND  (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT)) 
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL 
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
	AND INVDT.LINE_AMOUNT_NET <> 0
	--AND id.ID_JOB IN (SELECT ID_JOB FROM TBL_INV_DETAIL WHERE ID_INV_NO=ih.ID_INV_NO AND ID_WO_NO=WODEB.ID_WO_NO)

    INSERT INTO @OWNRISK 
  ( 
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
	 INVOICE_AMT,INVOICE_PREFIX, INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE, 
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_WO_PREFIX,ID_WO_NO,ID_JOB_ID 
  )
  SELECT DISTINCT 
	ih.ID_INV_NO 
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		  ELSE DT_CREDITNOTE END 
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP' 
    ,DPT_AccCode+'_'+DPT_Name 
    ,'OWNRISK' 
    ,'COST' 
    ,(md.OWNRISK_ACCTCODE) AS INVL_ACCCODE
	,abs(CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
 						isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
 			ELSE
 						isnull(INVDT.LINE_AMOUNT_NET,0)
			END) AS INVOICE_AMT
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES 
    ,INV_TRANSDATE 
    ,ID_Dept_Inv 
    ,Cust_AccCode 
	,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
	END AS TEXTCODE 
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT 
    ,(SELECT EXT_VAT_CODE 
		FROM TBL_MAS_INV_CONFIGURATION 
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv 
			AND ID_DEPT_INV=ih.ID_Dept_Inv 
		AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS EXT_VAT_CODE 
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
	,'' AS CUST_ID 
	,ih.ID_DEBITOR AS CUST_NO  
	,'' AS CUST_NAME 
	,'' AS CUST_ADDR1 
	,'' AS CUST_ADDR2 
	,'' AS CUST_POST_CODE 
	,'' AS CUST_PLACE 
	,'' AS CUST_PHONE 
	,'' AS CUST_FAX 
	,'0.00' AS CUST_CREDIT_LIMIT 
	,0 CUST_PAYTERM 
	,0 AS CUST_GROUP
	,ID_CN_NO 
	,cg.ID_VAT_CD
	,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0),id.ID_WO_PREFIX,id.ID_WO_NO,id.ID_JOB
  FROM  TBL_INV_HEADER ih 
    INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO 
 --   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX = WODEB.ID_WO_PREFIX 
	--	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND id.id_job=WODEB.ID_JOB_ID
	--INNER JOIN TBL_WO_DETAIL WOD ON ID.ID_WO_NO = WOD.ID_WO_NO AND ID.ID_WO_PREFIX = WOD.ID_WO_PREFIX 
	--	AND WOD.ID_JOB = id.id_job AND ISNULL(WOD.WO_OWN_RISK_AMT,0)<>0
    INNER JOIN TBL_MAS_DEPT md 
    ON   ih.ID_Dept_Inv = md.ID_DEPT 
    INNER JOIN TBL_MAS_CUST_GROUP cg 
    ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP
	INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = IH.ID_INV_NO AND INVDT.LINE_TYPE='OWNRISK'
	AND ID.ID_WO_NO = INVDT.ID_WO_NO AND ID.ID_WO_PREFIX= INVDT.ID_WO_PREFIX AND ID.ID_JOB = INVDT.ID_JOB_ID 	 
  WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228 
	AND  (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT)) 
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL 
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
	--AND WODEB.DBT_PER = 0 
	--AND WODEB.ID_JOB_ID IN (SELECT ID_JOB FROM TBL_INV_DETAIL WHERE ID_INV_NO=ih.ID_INV_NO AND ID_WO_NO=WODEB.ID_WO_NO)
    AND md.FLG_INTCUST_EXP = 1
	--and (select SUM(INVL_VAT_AMOUNT) from TBL_INV_DETAIL_LINES_VAT WHERE ID_INV_NO = ih.ID_INV_NO)=0.00   
	AND ISNULL(cg.USE_INTCUST,0)=1
	AND INVDT.LINE_AMOUNT_NET <> 0

	INSERT INTO @OWNRISK 
	( 
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
	 INVOICE_AMT,INVOICE_PREFIX, INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE, 
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_WO_PREFIX,ID_WO_NO,ID_JOB_ID
    )
	SELECT 	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE, ACCMATRIXTYPE,INVL_ACCCODE,
	 INVOICE_AMT,INVOICE_PREFIX, INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE, 
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, NULL, LA_VAT_CODE, 0 ,ID_WO_PREFIX,ID_WO_NO,ID_JOB_ID 
	FROM @OWNRISK WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0
	

-------------------------------------------- INVOICE FEES --------------------------------------  
  DECLARE @INVOICEFEES TABLE   
  (   
	 ID_INV_NO VARCHAR(50),   
	 DATE_INVOICE DATETIME,   
	 INV_CUST_GROUP VARCHAR(100),   
	 DEPT_ACC_CODE VARCHAR(100),   
	 INVOICETYPE VARCHAR(20),   
	 ACCMATRIXTYPE VARCHAR(20),   
	 INVL_ACCCODE VARCHAR(20),   
	 INVOICE_AMT NUMERIC(15,2),   
	 INVOICE_VAT_PER NUMERIC(5,2),
	 INVOICE_PREFIX VARCHAR(20),   
	 INVOICE_NO VARCHAR(50),   
	 INVOICE_TRANSACTIONID VARCHAR(25),   
	 INVOICE_TRANSACTIONDATE DATETIME,   
	 ID_DEPT_INV INT,   
	 CUST_ACCCODE VARCHAR(20),   
	 TEXTCODE VARCHAR(50),   
	 VOUCHER_TEXT VARCHAR(100),   
	 EXT_VAT_CODE CHAR(1),   
	 DUE_DATE VARCHAR(20),   
	 CUST_ID VARCHAR(50),   
	 CUST_NO INT,   
	 CUST_NAME VARCHAR(100),   
	 CUST_ADDR1 VARCHAR(50),   
	 CUST_ADDR2 VARCHAR(50),   
	 CUST_POST_CODE VARCHAR(10),   
	 CUST_PLACE VARCHAR(50),   
	 CUST_PHONE VARCHAR(20),   
	 CUST_FAX VARCHAR(20),   
	 CUST_CREDIT_LIMIT NUMERIC(15,2),   
	 CUST_PAYTERM VARCHAR(20),   
	 CUST_GROUP VARCHAR(20),
	 ID_CN_NO VARCHAR(15), 
	 LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT
  ) 
  
  INSERT INTO @INVOICEFEES   
  (   
	 ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,   
	 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,   
	 INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
  )  
   SELECT DISTINCT   
	ih.ID_INV_NO   
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
		  ELSE DT_CREDITNOTE END   
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'   
    ,DPT_AccCode+'_'+DPT_Name   
    ,'INVOICEFEES'   
    ,'SELLING'   
    ,ih.INV_FEES_ACC_CODE AS INVL_VAT_ACCCODE   
	,CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN
		isnull(ih.INV_FEES_VAT_AMT,0) + isnull(ih.INV_FEES_AMT,0) 
	ELSE
		isnull(ih.INV_FEES_AMT,0) 
	END 
	AS INVOICE_AMT    
    ,ISNULL(IH.INV_FEES_VAT_PERCENTAGE,0) AS INVOICE_VAT_PER 
    ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
	,@TRANSRES   
    ,INV_TRANSDATE   
    ,ID_Dept_Inv   
    ,Cust_AccCode   
	,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 --(SELECT TextCode   
		--FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		--	(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--		WHERE ID_SETTINGS =   
		--			(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--				WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		--					AND ID_INV_CONFIG =   
		--						(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--							ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--							AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
	END AS TEXTCODE   
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
    ,(SELECT EXT_VAT_CODE   
		FROM TBL_MAS_INV_CONFIGURATION   
		WHERE ID_SUBSIDERY_INV = ih.ID_Subsidery_Inv   
			AND ID_DEPT_INV=ih.ID_Dept_Inv   
			AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())) AS EXT_VAT_CODE   
	--,'00.00.0000' AS DUE_DATE 
	,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	,'' AS CUST_ID   
	,ih.ID_DEBITOR AS CUST_NO    
	,'' AS CUST_NAME   
	,'' AS CUST_ADDR1   
	,'' AS CUST_ADDR2   
	,'' AS CUST_POST_CODE   
	,'' AS CUST_PLACE   
	,'' AS CUST_PHONE   
	,'' AS CUST_FAX   
	,'0.00' AS CUST_CREDIT_LIMIT   
	,0 CUST_PAYTERM   
	,0 AS CUST_GROUP
	, ID_CN_NO 
	,cg.ID_VAT_CD
	,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)  
   FROM TBL_INV_HEADER ih
    INNER JOIN TBL_INV_DETAIL idl ON IH.ID_INV_NO=idl.ID_INV_NO   
	INNER JOIN TBL_MAS_DEPT md ON ih.ID_Dept_Inv = md.ID_DEPT   
	INNER JOIN TBL_MAS_CUST_GROUP cg ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
   WHERE (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1)   
	AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	AND (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE  
	 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE ) 
	AND ih.ID_INV_NO IS NOT NULL   
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  

   	INSERT INTO @INVOICEFEES 
	(
	    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM,
		CUST_GROUP,ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
	)
	SELECT ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, 
	    CUST_GROUP,NULL, LA_VAT_CODE, 0 
	FROM @INVOICEFEES WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0  	


  -------------REDUCTION AMOUNT -----------

   --REDUCTION                 
  DECLARE @REDUCTION TABLE                                
  (                                
	ID_INV_NO    VARCHAR(50),                
	DATE_INVOICE   DATETIME,                
	INV_CUST_GROUP   VARCHAR(100),              
	DEPT_ACC_CODE   VARCHAR(100),                
	INVOICETYPE    VARCHAR(20),                
	ACCMATRIXTYPE   VARCHAR(20),                   
	INVL_ACCCODE   VARCHAR(20),                
	INVOICE_AMT    NUMERIC(15,2),                
	INVOICE_VAT_PER   NUMERIC(5,2),                
	INVOICE_PREFIX   VARCHAR(20),                
	INVOICE_NO    VARCHAR(50),                
	INVOICE_TRANSACTIONID VARCHAR(25),                
	INVOICE_TRANSACTIONDATE DATETIME,                
	ID_DEPT_INV    INT,                          
	CUST_ACCCODE   VARCHAR(20),   
	TEXTCODE VARCHAR(50),   
	VOUCHER_TEXT VARCHAR(100),   
	EXT_VAT_CODE CHAR(1),   
	DUE_DATE VARCHAR(20),   
	CUST_ID VARCHAR(50),   
	CUST_NO INT,   
	CUST_NAME VARCHAR(100),   
	CUST_ADDR1 VARCHAR(50),   
	CUST_ADDR2 VARCHAR(50),   
	CUST_POST_CODE VARCHAR(10),   
	CUST_PLACE VARCHAR(50),   
	CUST_PHONE VARCHAR(20),   
	CUST_FAX VARCHAR(20),   
	CUST_CREDIT_LIMIT NUMERIC(15,2),   
	CUST_PAYTERM VARCHAR(20),   
	CUST_GROUP VARCHAR(20),
	ID_CN_NO VARCHAR(15), 
	LA_VAT_CODE INT,
	FLG_EXPORTED_AND_CREDITED BIT,
	ID_JOB INT ,
	 ID_WO_NO INT,
	 ID_WO_PREFIX VARCHAR(5)	 
  )                
                
   --REDUCTION - SELLING                
   INSERT INTO @REDUCTION                
    (                 
     ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
	 ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
     INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	 TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX
    )                 
    SELECT  DISTINCT         
		 ih.ID_INV_NO                
		 ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END        
		 ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
		 ,DPT_AccCode+'_'+DPT_Name                
		 ,'REDUCTION'                
		 ,'SELLING'                
		 ,(md.OWNRISK_ACCTCODE) AS INVL_ACCCODE 
		,CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
 						isnull(INVDT.LINE_AMOUNT_NET,0) + isnull(INVDT.LINE_VAT_AMOUNT,0)
 			ELSE
 						isnull(INVDT.LINE_AMOUNT_NET,0)
			END AS INVOICE_AMT
		,ISNULL(INVDT.LINE_VAT_PERCENTAGE,0) AS INVL_VAT_PER                
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
		 ,@TRANSRES                
		 ,INV_TRANSDATE                
		 ,ID_Dept_Inv                
		 ,Cust_AccCode   

		,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
		END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		,dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) AS EXT_VAT_CODE   
		,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX  
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO    
		,'' AS CUST_NAME   
		,'' AS CUST_ADDR1   
		,'' AS CUST_ADDR2   
		,'' AS CUST_POST_CODE   
		,'' AS CUST_PLACE   
		,'' AS CUST_PHONE   
		,'' AS CUST_FAX   
		,'0.00' AS CUST_CREDIT_LIMIT   
		,0 CUST_PAYTERM   
		,0 AS CUST_GROUP
		,ID_CN_NO 
		,cg.ID_VAT_CD
		,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0) 
		,idl.ID_JOB		
		,idl.ID_WO_NO 
		,idl.ID_WO_PREFIX
    FROM                
     TBL_INV_HEADER ih                
    INNER JOIN                 
     TBL_INV_DETAIL idl                
    ON ih.ID_INV_NO = idl.ID_INV_NO                
INNER JOIN                
  TBL_MAS_DEPT md                
    ON ih.ID_Dept_Inv = md.ID_DEPT                
    INNER JOIN                 
     TBL_MAS_CUST_GROUP cg                
    ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP    
 --INNER JOIN TBL_WO_DETAIL DET  
 --ON DET.ID_WO_NO = idl.ID_WO_NO  
 --AND DET.ID_WO_PREFIX = idl.ID_WO_PREFIX   
 --AND DET.ID_JOB = idl.ID_JOB 
 --INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON idl.ID_WO_NO = WODEB.ID_WO_NO AND idl.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
 --	AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB  AND WODEB.id_job_id= det.id_job
 INNER JOIN TBL_INVOICE_DATA INVDT ON INVDT.ID_INV_NO = ih.ID_INV_NO AND INVDT.LINE_TYPE='REDUCTION'
	AND idl.ID_WO_NO = INVDT.ID_WO_NO AND idl.ID_WO_PREFIX= INVDT.ID_WO_PREFIX AND idl.ID_JOB = INVDT.ID_JOB_ID
    WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                               
    AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
    AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN  @STARTDATE  AND @ENDDATE                 
     OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
    AND   ih.ID_INV_NO IS NOT NULL                 
	AND INVDT.LINE_AMOUNT_NET <> 0
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 


INSERT INTO @REDUCTION 
	(
	    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM,
		CUST_GROUP,ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
	)
	SELECT ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, 
	    CUST_GROUP,NULL, LA_VAT_CODE, 0 
	FROM @REDUCTION WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0  	


  DECLARE @FIXED TABLE                                
  (                                
	 ID_INV_NO VARCHAR(50),   
	 DATE_INVOICE DATETIME,   
	 INV_CUST_GROUP VARCHAR(100),   
	 DEPT_ACC_CODE VARCHAR(100),   
	 INVOICETYPE VARCHAR(20),   
	 ACCMATRIXTYPE VARCHAR(20),   
	 INVL_ACCCODE VARCHAR(20),   
	 INVOICE_AMT NUMERIC(15,2),   
	 INVOICE_VAT_PER NUMERIC(5,2),   
	 INVOICE_PREFIX VARCHAR(20),   
	 INVOICE_NO VARCHAR(50),   
	 INVOICE_TRANSACTIONID VARCHAR(25),   
	 INVOICE_TRANSACTIONDATE DATETIME,   
	 ID_DEPT_INV INT,   
	 CUST_ACCCODE VARCHAR(20),   
	 TEXTCODE VARCHAR(50),   
	 VOUCHER_TEXT VARCHAR(100),   
	 EXT_VAT_CODE CHAR(1),   
	 DUE_DATE VARCHAR(20),   
	 CUST_ID VARCHAR(50),   
	 CUST_NO INT,   
	 CUST_NAME VARCHAR(100),   
	 CUST_ADDR1 VARCHAR(50),   
	 CUST_ADDR2 VARCHAR(50),   
	 CUST_POST_CODE VARCHAR(10),   
	 CUST_PLACE VARCHAR(50),   
	 CUST_PHONE VARCHAR(20),   
	 CUST_FAX VARCHAR(20),   
	 CUST_CREDIT_LIMIT NUMERIC(15,2),   
	 CUST_PAYTERM VARCHAR(20),   
	 CUST_GROUP VARCHAR(20),
	 ID_CN_NO VARCHAR(15), 
	 LA_VAT_CODE INT,
	 FLG_EXPORTED_AND_CREDITED BIT,
	 ID_JOB INT ,
	 ID_WO_NO INT,
	 ID_WO_PREFIX VARCHAR(5),
	 ID_Mech varchar(50) 
  )                
  --FIXED PRICE - SELLING           
  INSERT INTO @FIXED                
   (                 
    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,                
    ACCMATRIXTYPE,INVL_ACCCODE,INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,                
    INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,CUST_ACCCODE,   
	TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,ID_CN_NO, LA_VAT_CODE, 
	FLG_EXPORTED_AND_CREDITED,ID_JOB,ID_WO_NO,ID_WO_PREFIX--,ID_Mech  
   )                
   SELECT   DISTINCT               
    ih.ID_INV_NO                
    ,CASE WHEN ID_CN_NO IS NULL THEN DT_INVOICE                
    ELSE DT_CREDITNOTE END                
    ,ISNULL(INV_CUST_GROUP,'')  AS 'CUSTOMER GROUP'                
    ,DPT_AccCode+'_'+DPT_Name                
    ,'FIXED'                
    ,'SELLING'                
    ,(SELECT TOP 1 FIXED_PR_ACC_CODE FROM TBL_LA_CONFIG ORDER BY DT_CREATED DESC)                
	,CASE WHEN ISNULL(id.FLG_FIXED_PRICE,0) = 0 THEN 
			0  
		ELSE
			--CASE WHEN dbo.FnGetInvoiceAmountFP(ih.ID_INV_NO) - isnull(IH.INV_FEES_AMT,0) - isnull(IH.INV_FEES_VAT_AMT,0) = 0 THEN
		CASE WHEN (dbo.[FnGetInvoiceAmountFP_Order](ih.ID_INV_NO,id.ID_WO_PREFIX,id.ID_WO_NO,id.id_job) /*- isnull(IH.INV_FEES_AMT,0) - isnull(IH.INV_FEES_VAT_AMT,0)*/ = 0) /*OR ISNULL(WOD.WO_OWN_RISK_AMT,0)<>0*/ THEN
				CASE WHEN UPPER(@EXPTYPE) = 'GROSS' THEN  
					CASE WHEN WOD.WO_OWN_PAY_VAT=1  THEN
						CASE WHEN IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND WODEB.DBT_PER=0 THEN
							ISNULL(id.INVD_FIXEDAMT * 
								CASE WHEN WODEB.WO_FIXED_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_FIXED_VATPER/100) END,0)
						ELSE
							CASE WHEN IH.ID_DEBITOR = WODEB.ID_JOB_DEB AND WODEB.DBT_PER<>0 and ih.ID_DEBITOR=WOD.WO_OWN_CR_CUST THEN
								ISNULL(id.INVD_FIXEDAMT,0) + (WOD.WO_FIXED_PRICE*WOD.WO_VAT_PERCENTAGE/100)
							else
								ISNULL(id.INVD_FIXEDAMT,0)
							end					
						END
					ELSE
						ISNULL(id.INVD_FIXEDAMT,0) + ISNULL(id.INVD_FIXEDAMT * 
							CASE WHEN WODEB.WO_FIXED_VATPER=1.00 THEN (WOD.WO_LBR_VATPER/100) ELSE (WODEB.WO_FIXED_VATPER/100) END,0)
					END		
				ELSE
					ISNULL(id.INVD_FIXEDAMT,0)
				END
			ELSE
				0
			END
		END        
    ,ISNULL(INVL_VAT_PER,0) AS INVL_VAT_PER         
   ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX --'' AS INVOICE_PREFIX  commented for due date 2                          
 ,@TRANSRES                
    ,CONVERT(VARCHAR(20),INV_TRANSDATE,101)                
    ,ID_Dept_Inv                
    ,Cust_AccCode   
  
 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO))) 
  END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 ,CASE WHEN idl.INVL_VAT_CODE IS NULL THEN 
				DBO.FnGetExtVATByVAT(DBO.fn_GetLabourVatforINV(ih.ID_INV_NO))
			ELSE
				dbo.FnGetExtVATByVAT(cg.ID_VAT_CD) 
			END	 
	  AS EXT_VAT_CODE   				
	 -- ,'00.00.0000' AS DUE_DATE 
	 ,CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121) AS INVOICE_PREFIX    
	 --,idl.INVL_IDLOGIN AS CUST_ID --,'' AS CUST_ID  -- Since both mech had same clockin,clockout details it was not picked as 2 different lines
	 ,case when ISNULL(id.INVD_FIXEDAMT,0)<>0 then '' else idl.INVL_IDLOGIN end AS CUST_ID --17-01-13 - updated since it was giving two lines for fixed price when two mechanics were on job
	 ,ih.ID_DEBITOR AS CUST_NO    
	 ,'' AS CUST_NAME   
	 ,'' AS CUST_ADDR1   
	 ,'' AS CUST_ADDR2   
	 ,'' AS CUST_POST_CODE   
	 ,'' AS CUST_PLACE   
	 ,'' AS CUST_PHONE   
	 ,'' AS CUST_FAX   
	 ,'0.00' AS CUST_CREDIT_LIMIT   
	 ,0 CUST_PAYTERM   
	 ,0 AS CUST_GROUP 
	 ,ID_CN_NO 
	 ,cg.ID_VAT_CD 
	 ,ISNULL(ih.FLG_EXPORTED_AND_CREDITED, 0)
	 ,ID.ID_JOB
	 ,WOD.ID_WO_NO 
	 ,WOD.ID_WO_PREFIX
	 --,idl.INVL_IDLOGIN  
   FROM  TBL_INV_HEADER ih 
   INNER JOIN TBL_INV_DETAIL id ON ih.ID_INV_NO = id.ID_INV_NO
   INNER JOIN TBL_WO_DETAIL WOD	ON ID.ID_WO_NO= WOD.ID_WO_NO AND ID.ID_WO_PREFIX= WOD.ID_WO_PREFIX AND ID.ID_WODET_INV = WOD.ID_WODET_SEQ
   INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB ON ID.ID_WO_NO = WODEB.ID_WO_NO AND ID.ID_WO_PREFIX= WODEB.ID_WO_PREFIX 
		AND ih.ID_DEBITOR = WODEB.ID_JOB_DEB AND wodeb.id_job_id = id.id_job
   LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idl                
   ON   ih.ID_INV_NO = idl.ID_INV_NO AND IDL.ID_WODET_INVL   =WOD.ID_WODET_SEQ                
   INNER JOIN TBL_MAS_DEPT md        ON   ih.ID_Dept_Inv = md.ID_DEPT                
   INNER JOIN TBL_MAS_CUST_GROUP cg  ON   cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP                 
   LEFT OUTER JOIN TBL_WO_JOB_DETAIL AS WOJ ON   
	WOJ.ID_WODET_SEQ_JOB =WOD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WOD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WOD.ID_WO_NO
   INNER JOIN TBL_WO_HEADER WH ON   WH.ID_WO_NO=WOD.ID_WO_NO AND WH.ID_WO_PREFIX=WOD.ID_WO_PREFIX
   WHERE  (ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND   (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
   AND   (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE                 
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )
   AND   ih.ID_INV_NO IS NOT NULL --AND WOD.FLG_CHRG_STD_TIME=0                
   --Fazal  
   AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE') 
   --AND WODEB.DBT_AMT <> 0 
   AND (WODEB.DBT_PER > 0 OR WOD.WO_OWN_PAY_VAT=1) --Modified 4/5/2010 for owner pay vat
   AND WH.WO_TYPE_WOH='ORD'
	
   	INSERT INTO @FIXED 
	(
	    ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM,
		CUST_GROUP,ID_CN_NO, LA_VAT_CODE, FLG_EXPORTED_AND_CREDITED 
	)
	SELECT ID_INV_NO,DATE_INVOICE,INV_CUST_GROUP,DEPT_ACC_CODE,INVOICETYPE,ACCMATRIXTYPE,INVL_ACCCODE,
		INVOICE_AMT,INVOICE_VAT_PER,INVOICE_PREFIX,INVOICE_TRANSACTIONID,INVOICE_TRANSACTIONDATE,ID_DEPT_INV,
		CUST_ACCCODE,TEXTCODE, VOUCHER_TEXT, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, 
		CUST_ADDR2, CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, 
	    CUST_GROUP,NULL, LA_VAT_CODE, 0 
	FROM @FIXED WHERE ID_CN_NO IS NOT NULL AND FLG_EXPORTED_AND_CREDITED = 0  	
	
	 INSERT INTO @INVOICEJOURNAL
   SELECT              
    ISNULL(lam.ID_SLNO,0) as 'SLNO',                
    LA_FLG_CRE_DEB,                
    CASE WHEN (ISNULL(LA_ACCOUNTNO,'') <> '') THEN LA_ACCOUNTNO                      
       --ELSE (CASE WHEN (ISNULL(@ERROR_ACCOUNT_CODE,'') <> '') THEN  @ERROR_ACCOUNT_CODE ELSE '9999' END)   
       ELSE ''                 
       END AS 'ACCOUNTNO' ,                
    CASE WHEN (ISNULL(LA_DEPT_ACCOUNT_NO,'') <> '') THEN LA_DEPT_ACCOUNT_NO                      
        --ELSE (CASE WHEN (ISNULL(@ERROR_ACCOUNT_CODE,'') <> '') THEN  @ERROR_ACCOUNT_CODE ELSE '9999' END)  
        ELSE ''                    
      END AS DEPT_ACCOUNT_NO,                                
    LA_DIMENSION,                
    LA_CUST_ACCCODE,                
    LA_DEPT_ACCCODE,                
    LA_SaleAccCode,                
    LA_SALEDESCRIPTION,                
    lamd.LA_DESCRIPTION, 
    lam.PROJECT, 
    ISNULL((SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='VAT' AND DESCRIPTION = lam.LA_VATCODE), 0) AS LA_VAT_CODE 
   FROM                
    TBL_LA_ACCOUNT_MATRIX lam                
   inner JOIN                 
    TBL_LA_ACCOUNT_MATRIX_DETAIL lamd                
   ON lam.ID_SLNO = lamd.LA_SLNO 
                   
              
--TO BE REMOVED        
-- SELECT * FROM @INVOICEJOURNAL        
--END REMOVED        
      
  SELECT                 
   ID_INV_NO,  DATE_INVOICE, INV_CUST_GROUP,    DEPT_ACC_CODE,                
   INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,    ACCMATRIXSLNO,                
   LA_FLG_CRE_DEB, ACCOUNTNO,  DEPT_ACCOUNT_NO, DIMENSION,                
   INVOICE_AMT, CREDIT_AMOUNT, DEBIT_AMOUNT,    INVOICE_VAT_PER,                
   INVOICE_PREFIX, INVOICE_NO,  INVOICE_TRANSACTIONID,  INVOICE_TRANSACTIONDATE,   
   TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
   CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,   
   @CREATED_BY [CREATED_BY], PROJECT                 
  INTO #INVOICEJOURNAL            
  FROM                 
  (         
   --LABOUR - SELLING               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  ISNULL(LA_FLG_CRE_DEB,1)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
    DIMENSION,--INVOICE_AMT,
    --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
				--	ELSE NULL END,
    --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 			--		ELSE NULL END,
 	ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'LA'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE l.ACCMATRIXTYPE = 'SELLING'              
    AND l.INVOICETYPE='LABOUR' 
                  
  UNION ALL              
   --LABOUR - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	 CASE WHEN ID_CN_NO IS NULL THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 1	 END AS LA_FLG_CRE_DEB,                
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     DIMENSION,
     INVOICE_AMT,
     CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,                
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END,                
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY AS [CREATED_BY], a.PROJECT  
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'LA'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE l.ACCMATRIXTYPE = 'DISCOUNT'              
   AND l.INVOICETYPE='LABOUR' 
              
  UNION ALL
  
  ------------------------------------------------------------------************ROW 274 FOR LABOUR COST - START
  
--LABOUR - COST               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
    CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  1
		 ELSE 1	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
 --   CASE WHEN (SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=l.ID_WO_NO AND WH.ID_WO_PREFIX=l.ID_WO_PREFIX) IS NOT NULL
	--THEN WH.LA_DEPT_ACCOUNT_NO
	--ELSE
	--ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) 
	--END
	ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=l.ID_WO_NO AND WH.ID_WO_PREFIX=l.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	as DEPT_ACCOUNT_NO,
    DIMENSION,INVOICE_AMT,
    --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN 200--INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN 300--INVOICE_AMT
				--	ELSE NULL END,
    --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN 400--INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  500--INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  600--INVOICE_AMT 
 			--		ELSE NULL END,
	 CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END, 
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'LA'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE l.ACCMATRIXTYPE = 'COST'
   AND l.INVOICETYPE='LABOUR'               
             
-----------------------------------------------------------------************ROW 274 FOR LABOUR COST - END
----------- VA ORDERS START
UNION ALL
 --LABOUR - SELLING               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  ISNULL(LA_FLG_CRE_DEB,1)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
    DIMENSION,--INVOICE_AMT,
    --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
				--	ELSE NULL END,
    --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 			--		ELSE NULL END,
 	ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'VA'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE l.ACCMATRIXTYPE = 'SELLING' AND l.INVOICETYPE='VASELLING'              
                 
  UNION ALL              
   --LABOUR - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	 CASE WHEN ID_CN_NO IS NULL THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 1	 END AS LA_FLG_CRE_DEB,                
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     DIMENSION,
     INVOICE_AMT,
     CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,                
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END,                
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY AS [CREATED_BY], a.PROJECT  
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'VA'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE l.ACCMATRIXTYPE = 'DISCOUNT' AND l.INVOICETYPE='VASELLING'              
              
  UNION ALL
  
  ------------------------------------------------------------------************ROW 274 FOR LABOUR COST - START
  
--LABOUR - COST               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
    CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  1
		 ELSE 1	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
 --   CASE WHEN (SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=l.ID_WO_NO AND WH.ID_WO_PREFIX=l.ID_WO_PREFIX) IS NOT NULL
	--THEN WH.LA_DEPT_ACCOUNT_NO
	--ELSE
	--ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) 
	--END
	ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=l.ID_WO_NO AND WH.ID_WO_PREFIX=l.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	as DEPT_ACCOUNT_NO,
    DIMENSION,INVOICE_AMT,
    --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN 200--INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN 300--INVOICE_AMT
				--	ELSE NULL END,
    --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN 400--INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  500--INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  600--INVOICE_AMT 
 			--		ELSE NULL END,
	 CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END, 
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'VA'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE l.ACCMATRIXTYPE = 'COST' AND l.INVOICETYPE='VASELLING'              
           ----------- VA ORDERS END  
-----------------------------------------------------------------************ROW 274 FOR LABOUR COST - END 
/********************-----ROW 475 FIXED PRICE CHANGE START-----**********/

UNION ALL

--LABOUR - SELLING               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
       CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  
		0 
	ELSE
		CASE WHEN ID_CN_NO IS NOT NULL AND INVOICE_AMT<0 THEN 
			0
		ELSE 
			ISNULL(LA_FLG_CRE_DEB,1)	 
		END	
	END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
    DIMENSION,
 	ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'LA'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE l.ACCMATRIXTYPE = 'SELLING'              
    AND l.INVOICETYPE='LABOURDIFF' 
                  
  UNION ALL              
   --LABOUR - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	 CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  
	 			1
	 ELSE 
				CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN
					0
				ELSE
					ISNULL(LA_FLG_CRE_DEB,0) 
				END
	 END 
	 AS LA_FLG_CRE_DEB,                  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     DIMENSION,
     ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),                
     DEBIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 0 THEN  INVOICE_AMT 
						  ELSE NULL END),                
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY AS [CREATED_BY], a.PROJECT  
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'LA'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE l.ACCMATRIXTYPE = 'DISCOUNT'              
   AND l.INVOICETYPE='LABOURDIFF' 


UNION ALL
  
  ------------------------------------------------------------------************ROW 274 FOR LABOUR COST - START
  
--LABOUR - COST               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
    CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  1
			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
  	ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=l.ID_WO_NO AND WH.ID_WO_PREFIX=l.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	as DEPT_ACCOUNT_NO,
    DIMENSION,INVOICE_AMT,
	 CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 0 THEN  INVOICE_AMT 
						  ELSE NULL END, 
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @LABOUR l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'LA'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE l.ACCMATRIXTYPE = 'COST'
   AND l.INVOICETYPE='LABOURDIFF'               
             
-----------------------------------------------------------------************ROW 274 FOR LABOUR COST - END


/***********---FIXED PRICE LINE---**************/
UNION ALL
   --LABOUR - SELLING               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  ISNULL(LA_FLG_CRE_DEB,1)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
    DIMENSION,--INVOICE_AMT,
    --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
				--	ELSE NULL END,
    --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 			--		ELSE NULL END,
 	ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @FIXED l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'FP'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE l.ACCMATRIXTYPE = 'SELLING'              
    AND l.INVOICETYPE='FIXED' 

/***********---FIXED PRICE LINE---**************/


/********************-----ROW 475 FIXED PRICE CHANGE END-----**********/



  UNION ALL  
                
   --SPARES - SELLING              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN 0 
		 WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN ISNULL(LA_FLG_CRE_DEB,1) 
		 ELSE 0	 END AS LA_FLG_CRE_DEB,                     
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     DIMENSION,ABS(INVOICE_AMT),
	  CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN ABS(INVOICE_AMT)
						 ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  ABS(INVOICE_AMT) 
 						ELSE NULL END,                 
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP) 
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE s.ACCMATRIXTYPE = 'SELLING'  
   AND S.INVOICETYPE='SPARES'            
 
 
-----------------------------------------------------------------************ROW 274 FOR SPARES SELLING COST - START
  UNION ALL  
                
   --SPARES - COST              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	 CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  1
		 ELSE 1	 END AS LA_FLG_CRE_DEB,                     
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=s.ORDERNO AND WH.ID_WO_PREFIX=s.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO, 
     DIMENSION,ABS(INVOICE_AMT),
	 CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
						 ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 						ELSE NULL END,                 
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP)
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE s.ACCMATRIXTYPE = 'SCOST' 
   AND S.INVOICETYPE='SPARES' 
 
-----------------------------------------------------------------************ROW 274 FOR SPARES SELLING COST - END
               
  UNION ALL              
   --SPARES - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	  DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
      CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0  THEN  ISNULL(LA_FLG_CRE_DEB,0)
			 WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN 1
		 ELSE 1	 END AS LA_FLG_CRE_DEB,    
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),
     DEBIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END),              
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT  
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP)
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE s.ACCMATRIXTYPE = 'DISCOUNT'
   AND S.INVOICETYPE='SPARES' 

-------------------------------------************************SPARE DISCOUNT CREDIT ROW 274 - START
  UNION ALL              
   --SPARES - DISCOUNT - CREDIT SIDE              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	  DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
      CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0  THEN  1
			 WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,    
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END),              
     DEBIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT  
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP)
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE s.ACCMATRIXTYPE = 'DISCOUNTC' 
   AND S.INVOICETYPE='SPARES' 

-------------------------------------************************SPARE DISCOUNT CREDIT ROW 274 - END

  UNION ALL              
   --SPARES - STOCK                
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
     CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  ISNULL(LA_FLG_CRE_DEB,1) 
     			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  0
		 ELSE 0	 END AS LA_FLG_CRE_DEB,                   
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,   
     DIMENSION,ABS(INVOICE_AMT),
	 CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
	 					 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
	 					 ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 						ELSE NULL END,                 
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @SPARES s              
   LEFT OUTER JOIN               
   @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP) 
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'STGL'              
   WHERE s.ACCMATRIXTYPE = 'STOCK'
   AND S.INVOICETYPE='SPARES' 
                
  UNION ALL              
   --SPARES - COST              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
      CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  1
		 ELSE 1	 END AS LA_FLG_CRE_DEB,     
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,   
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END,                               
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP) 
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'CGL'              
   WHERE s.ACCMATRIXTYPE = 'COST' 
   AND S.INVOICETYPE='SPARES' 
                

   /********************-----SPARES ROW 475 FIXED PRICE CHANGE START-----**********/



  UNION ALL  
                
   --SPARES - SELLING              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	--CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN ISNULL(LA_FLG_CRE_DEB,1) 
	--	 WHEN ID_CN_NO IS NOT NULL AND INVOICE_AMT < 0 THEN 0 
	--	 ELSE 1	 END AS LA_FLG_CRE_DEB,   
	CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN 
			ISNULL(LA_FLG_CRE_DEB,1) 
		WHEN ID_CN_NO IS NOT NULL AND INVOICE_AMT < 0 THEN 
				0 
		ELSE 
		CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT >= 0 THEN 
				0
		ELSE
				1
		END	 
	END AS LA_FLG_CRE_DEB,                   
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     DIMENSION,ABS(INVOICE_AMT),
	  CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN ABS(INVOICE_AMT)
						 ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  ABS(INVOICE_AMT) 
 						ELSE NULL END,                 
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP) 
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE s.ACCMATRIXTYPE = 'SELLING'         
   AND S.INVOICETYPE='SPARESDIFF' 
   
   UNION ALL              
   --SPARES - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	  DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
      CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0  THEN  1
			 WHEN ID_CN_NO IS NOT NULL AND INVOICE_AMT < 0 THEN 1
		 ELSE 0	 END AS LA_FLG_CRE_DEB,    
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),
     DEBIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 0 THEN  INVOICE_AMT 
						  ELSE NULL END),              
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT  
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP)
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE s.ACCMATRIXTYPE = 'DISCOUNT'   
   AND S.INVOICETYPE='SPARESDIFF'      
   
   -----------------------------------------------------------------************ROW 274 FOR SPARES SELLING COST - START
  UNION ALL  
                
   --SPARES - COST              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
	 CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  1
		 WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,                     
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,     
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=s.ORDERNO AND WH.ID_WO_PREFIX=s.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO, 
     DIMENSION,ABS(INVOICE_AMT),
	 CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT
						 ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  INVOICE_AMT 
 						ELSE NULL END,                 
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP)
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE s.ACCMATRIXTYPE = 'SCOST' 
   AND S.INVOICETYPE='SPARESDIFF' 
 
-----------------------------------------------------------------************ROW 274 FOR SPARES SELLING COST - END

-------------------------------------************************SPARE DISCOUNT CREDIT ROW 274 - START
  UNION ALL              
   --SPARES - DISCOUNT - CREDIT SIDE              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	  DATE_INVOICE, INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,  ACCMATRIXSLNO,              
      CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0  THEN  ISNULL(LA_FLG_CRE_DEB,0)
			 WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN 1
		 ELSE 0	 END AS LA_FLG_CRE_DEB,    
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 0 THEN  INVOICE_AMT 
						  ELSE NULL END),              
     DEBIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),
     INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT  
   FROM @SPARES s              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON s.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND s.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   --AND s.LA_VAT_CODE = a.LA_VAT_CODE **Modified to get account matrix based on customer group vat code
   AND a.LA_VAT_CODE =(select ID_VAT_CD from TBL_MAS_CUST_GROUP where ID_CUST_GRP_SEQ=s.INV_CUST_GROUP)
   AND s.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'SP'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE s.ACCMATRIXTYPE = 'DISCOUNTC' 
   AND S.INVOICETYPE='SPARESDIFF' 

-------------------------------------************************SPARE DISCOUNT CREDIT ROW 274 - END

 /********************-----SPARES ROW 475 FIXED PRICE CHANGE END-----**********/
 
   UNION ALL              
   --GM - SELLING              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  ISNULL(LA_FLG_CRE_DEB,1)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,
      ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @GARAGEMATERIAL g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'GM'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE g.ACCMATRIXTYPE = 'SELLING' 
   AND g.INVOICETYPE='GARAGEMATERIAL'   
 ---------------------************ROW 274 FOR GM COST - START
  UNION ALL 
    --GM - COST              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
    CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  1
		 ELSE 1	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=g.ID_WO_NO AND WH.ID_WO_PREFIX=g.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,INVOICE_AMT,
     --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
	 			--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
	 			--		 ELSE NULL END,
     --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 				--		ELSE NULL END,
 	 CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END,			
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @GARAGEMATERIAL g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'GM'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE g.ACCMATRIXTYPE = 'COST'   
 AND g.INVOICETYPE='GARAGEMATERIAL'
  ---------------------************ROW 274 FOR GM COST - END
                 
  UNION ALL              
   --GM - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
     CASE WHEN ID_CN_NO IS NULL THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 1	 END AS LA_FLG_CRE_DEB,                
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,  
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),                
     DEBIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 1 THEN  INVOICE_AMT 
						  ELSE NULL END),                
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @GARAGEMATERIAL g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'GM'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE g.ACCMATRIXTYPE = 'DISCOUNT'              
 AND g.INVOICETYPE='GARAGEMATERIAL'
 
    /********************-----GM ROW 475 FIXED PRICE CHANGE START-----**********/   
   UNION ALL              
   --GM - SELLING              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  
		0
	 ELSE 
		CASE WHEN ID_CN_NO IS NOT NULL AND INVOICE_AMT<0 THEN  
			0
		ELSE
			ISNULL(LA_FLG_CRE_DEB,1)
		END
	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,
      ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @GARAGEMATERIAL g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'GM'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE g.ACCMATRIXTYPE = 'SELLING' 
   AND g.INVOICETYPE='GARAGEMATERIALDIFF'  
   
   
   UNION ALL              
   --GM - DISCOUNT              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
     CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>0 THEN  
	 			1
	 ELSE 
				CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN
					0
				ELSE
					ISNULL(LA_FLG_CRE_DEB,0) 
				END
	 END,                
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,  
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END),                
     DEBIT_AMOUNT  = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 0 THEN  INVOICE_AMT 
						  ELSE NULL END),                
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @GARAGEMATERIAL g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'GM'              
   AND a.LA_DESCRIPTION = 'DGL'              
   WHERE g.ACCMATRIXTYPE = 'DISCOUNT' 
      AND g.INVOICETYPE='GARAGEMATERIALDIFF'  
   
    ---------------------************ROW 274 FOR GM COST - START
  UNION ALL 
    --GM - COST              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
    CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT > 0 THEN  1
			WHEN ID_CN_NO IS NULL AND INVOICE_AMT < 0 THEN  ISNULL(LA_FLG_CRE_DEB,0)
		 ELSE 1	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=g.ID_WO_NO AND WH.ID_WO_PREFIX=g.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,INVOICE_AMT,
     --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
	 			--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
	 			--		 ELSE NULL END,
     --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 				--		ELSE NULL END,
 	 CREDIT_AMOUNT = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN INVOICE_AMT	
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN INVOICE_AMT		
						  ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB= 0 THEN  INVOICE_AMT 
						  ELSE NULL END,			
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @GARAGEMATERIAL g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'GM'              
   AND a.LA_DESCRIPTION = 'SCGL'              
   WHERE g.ACCMATRIXTYPE = 'COST'   
 AND g.INVOICETYPE='GARAGEMATERIALDIFF'
  ---------------------************ROW 274 FOR GM COST - END
        
/********************-----GM ROW 475 FIXED PRICE CHANGE END-----**********/   
         
 --------------REDUCTION-----------

 
UNION ALL

--REDUCTION - SELLING               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
     (CASE WHEN (ID_CN_NO IS NULL and ISNULL(INVOICE_AMT,0) >= 0) or (ID_CN_NO IS NOT NULL and ISNULL(INVOICE_AMT,0) < 0) THEN 
		1 
	  ELSE 
		0 
	  END) AS LA_FLG_CRE_DEB, 
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
    DIMENSION,
 	ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @REDUCTION r              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON r.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND r.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND r.LA_VAT_CODE = a.LA_VAT_CODE 
   AND r.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'RDC'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE r.ACCMATRIXTYPE = 'SELLING'              
    AND r.INVOICETYPE='REDUCTION' 
                  

 ----------------------------------		 
		      
  UNION ALL              
   --VAT - SELLING              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
     CASE WHEN ID_CN_NO IS NULL THEN  ISNULL(LA_FLG_CRE_DEB,1)
		 ELSE 0	 END AS LA_FLG_CRE_DEB, 
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,INVOICE_AMT,
     CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
	 					 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
	 					 ELSE NULL END,
     DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 						ELSE NULL END,
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @VAT v              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON v.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND v.LA_VAT_CODE = a.LA_VAT_CODE 
   AND v.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'VAT'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE v.ACCMATRIXTYPE = 'SELLING' 
 UNION ALL  
     
   -- ROUNDING - SELLING 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
	 CASE WHEN ID_CN_NO IS NULL THEN  
		CASE WHEN ISNULL(INVOICE_AMT,0)<0 THEN 
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				CASE WHEN INVOICE_AMT <> 0 THEN 
					0
				ELSE
					1
				END 
			ELSE
				1
			END
		ELSE
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				1 
			ELSE
				0
			END
		END
		--ISNULL(LA_FLG_CRE_DEB,1)
	 ELSE 
		CASE WHEN ISNULL(INVOICE_AMT,0)<0 THEN 
			1 
		ELSE
			0 
		END
	 END AS LA_FLG_CRE_DEB, 
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN 
						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN 
							INVOICE_AMT
					 ELSE 
						  NULL 
					 END),
     DEBIT_AMOUNT  = ABS(CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN 
							NULL 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  
							INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  
							INVOICE_AMT 
 					 ELSE 
 						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)<0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END 
 					 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @ROUNDING v 
	 LEFT OUTER JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
		AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
		AND v.LA_VAT_CODE = a.LA_VAT_CODE 
		AND v.INVL_ACCCODE = a.LA_SaleAccCode 
		AND a.LA_SALEDESCRIPTION = 'RD' 
		AND a.LA_DESCRIPTION = 'SEGL' 
		WHERE v.ACCMATRIXTYPE = 'SELLING'
AND V.INVOICETYPE='ROUNDING'

/******ROW 475 FIXED PRICE CHANGE - START****/
UNION ALL  
     
   -- ROUNDING - SELLING 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     CASE WHEN ID_CN_NO IS NULL THEN  
		CASE WHEN (ISNULL(INVOICE_AMT,0)<0) THEN 
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				CASE WHEN INVOICE_AMT>=0 THEN 
					1
				ELSE
					0
				END  
			ELSE
				0
			END
		ELSE
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				CASE WHEN INVOICE_AMT<0 THEN 
					1
				ELSE
					0
				END   
			ELSE
				1
			END
		END
		--ISNULL(LA_FLG_CRE_DEB,1)
	 ELSE 
		CASE WHEN (ISNULL(INVOICE_AMT,0)<0) THEN 
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				CASE WHEN INVOICE_AMT>=0 THEN 
					0
				ELSE
					1
				END  
			ELSE
				1
			END
		ELSE
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				CASE WHEN INVOICE_AMT<0 THEN 
					0
				ELSE
					1
				END   
			ELSE
				0
			END
		END
	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     DIMENSION,ABS(INVOICE_AMT),
     CREDIT_AMOUNT = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN 
						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN 
							INVOICE_AMT
					 ELSE 
						  NULL 
					 END),
     DEBIT_AMOUNT  = ABS(CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN 
							NULL 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  
							INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  
							INVOICE_AMT 
 					 ELSE 
 						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)<0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END 
 					 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @ROUNDING v 
	 LEFT OUTER JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
		AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
		AND v.LA_VAT_CODE = a.LA_VAT_CODE 
		AND v.INVL_ACCCODE = a.LA_SaleAccCode 
		AND a.LA_SALEDESCRIPTION = 'RD' 
		AND a.LA_DESCRIPTION = 'SEGL' 
		WHERE v.ACCMATRIXTYPE = 'SELLING'
AND V.INVOICETYPE='ROUNDINGDIFF'
    UNION ALL 
    
    ---------------------************ROW 274 FOR ROUNDING COST - START
   -- ROUNDING - COST 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     CASE WHEN ID_CN_NO IS NULL THEN  
		CASE WHEN ISNULL(INVOICE_AMT,0)<0 THEN 
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				0 
			ELSE
				1
			END 
		ELSE
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				1 
			ELSE
				0
			END  
		END
		--ISNULL(LA_FLG_CRE_DEB,1)
	 ELSE 
		CASE WHEN ISNULL(INVOICE_AMT,0)<0 THEN 
			1 
		ELSE
			0 
		END
	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO= (SELECT TOP 1 ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=v.ID_INV_NO) AND WH.ID_WO_PREFIX=(SELECT TOP 1 ID_WO_PREFIX FROM TBL_INV_DETAIL WHERE ID_INV_NO=v.ID_INV_NO) AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,ABS(INVOICE_AMT),
     --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
					--	 ELSE NULL END,
     --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 				--		ELSE NULL END,
     CREDIT_AMOUNT = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL THEN 
						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN 
							INVOICE_AMT
					 ELSE 
						  NULL 
					 END),
     DEBIT_AMOUNT  = ABS(CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL THEN 
							NULL 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  
							INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  
							INVOICE_AMT 
 					 ELSE 
 						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)<0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END 
 					 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @ROUNDING v 
	 LEFT OUTER JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
		AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
		AND v.LA_VAT_CODE = a.LA_VAT_CODE 
		AND v.INVL_ACCCODE = a.LA_SaleAccCode 
		AND a.LA_SALEDESCRIPTION = 'RD' 
		AND a.LA_DESCRIPTION = 'SCGL' 
		WHERE v.ACCMATRIXTYPE = 'COST'
 AND V.INVOICETYPE='ROUNDINGDIFF'
 ---------------------************ROW 274 FOR ROUNDING COST - END
 
 /******ROW 475 FIXED PRICE CHNAGE - END****/

    UNION ALL 
    
    ---------------------************ROW 274 FOR ROUNDING COST - START
   -- ROUNDING - COST 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     CASE WHEN ID_CN_NO IS NULL THEN  
		CASE WHEN ISNULL(INVOICE_AMT,0)<0 THEN 
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				1 
			ELSE
				0
			END 
		ELSE
			CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
				0 
			ELSE
				1
			END  
		END
		--ISNULL(LA_FLG_CRE_DEB,1)
	 ELSE 
		CASE WHEN ISNULL(INVOICE_AMT,0)<0 THEN 
			0 
		ELSE
			1 
		END
	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO= (SELECT TOP 1 ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=v.ID_INV_NO) AND WH.ID_WO_PREFIX=(SELECT TOP 1 ID_WO_PREFIX FROM TBL_INV_DETAIL WHERE ID_INV_NO=v.ID_INV_NO) AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,ABS(INVOICE_AMT),
     --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
					--	 ELSE NULL END,
     --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
					--	 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 				--		ELSE NULL END,
     CREDIT_AMOUNT = ABS(CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN 
						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)>=0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN 
							INVOICE_AMT
					 ELSE 
						  NULL 
					 END),
     DEBIT_AMOUNT  = ABS(CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN 
							NULL 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  
							INVOICE_AMT 
						  WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  
							INVOICE_AMT 
 					 ELSE 
 						  CASE WHEN DBO.FnGetInvoiceAmount(ID_INV_NO)<0 THEN
								INVOICE_AMT 
						  ELSE
								NULL
						  END 
 					 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @ROUNDING v 
	 LEFT OUTER JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
		AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
		AND v.LA_VAT_CODE = a.LA_VAT_CODE 
		AND v.INVL_ACCCODE = a.LA_SaleAccCode 
		AND a.LA_SALEDESCRIPTION = 'RD' 
		AND a.LA_DESCRIPTION = 'SCGL' 
		WHERE v.ACCMATRIXTYPE = 'COST'
 AND V.INVOICETYPE='ROUNDING'
 ---------------------************ROW 274 FOR ROUNDING COST - END
   UNION ALL
    
   -- OWNRISK - CREDIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --1 AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 1 ELSE 0 END) AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,ABS(INVOICE_AMT), 
     --INVOICE_AMT, 
     --0, 
     (CASE WHEN ID_CN_NO IS NULL THEN INVOICE_AMT ELSE 0 END), 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE INVOICE_AMT END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.LA_VAT_CODE = a.LA_VAT_CODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SEGL' 
   WHERE v.ACCMATRIXTYPE = 'SELLING' 
   AND V.INVOICETYPE='OWNRISK'
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))=0.00)
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)= 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
		
	)	
 	
	---------------------************ROW 274 FOR OR(CREDIT CUSTOMER)COST - START
     UNION ALL 
   -- OWNRISK - CREDIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --1 AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE 1 END) AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=v.ID_WO_NO AND WH.ID_WO_PREFIX=v.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,INVOICE_AMT, 
     --INVOICE_AMT, 
     --0, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE INVOICE_AMT END), 
     (CASE WHEN ID_CN_NO IS NULL THEN INVOICE_AMT ELSE 0 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.LA_VAT_CODE = a.LA_VAT_CODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SCGL' 
   WHERE v.ACCMATRIXTYPE = 'COST' 
   AND V.INVOICETYPE='OWNRISK'
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))=0.00)
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)= 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
		
	)
 
 ---------------------************ROW 274 FOR OR(CREDIT CUSTOMER) COST - END
		
  UNION ALL 
   -- OWNRISK - DEBIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --0  AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE 1 END)  AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,INVOICE_AMT, 
     --0, 
     --INVOICE_AMT, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE INVOICE_AMT END), 
     (CASE WHEN ID_CN_NO IS NULL THEN INVOICE_AMT ELSE 0 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SEGL' 
   WHERE v.ACCMATRIXTYPE = 'SELLING'
   AND V.INVOICETYPE='OWNRISK'
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))<>0.00) 
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)<> 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
	)	


 ---------------------************ROW 274 FOR OR(DEBIT CUSTOMER) COST - START
 
   UNION ALL 
   -- OWNRISK - DEBIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --0  AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 1 ELSE 0 END)  AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=v.ID_WO_NO AND WH.ID_WO_PREFIX=v.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,INVOICE_AMT, 
     --0, 
     --INVOICE_AMT, 
     (CASE WHEN ID_CN_NO IS NULL THEN INVOICE_AMT ELSE 0 END), 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE INVOICE_AMT END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SCGL' 
   WHERE v.ACCMATRIXTYPE = 'COST'
   AND V.INVOICETYPE='OWNRISK' 
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))<>0.00) 
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)<> 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
	)	
 
 ---------------------************ROW 274 FOR OR(DEBIT CUSTOMER) COST - END
 
/*****************************************OR FIXED PRICE*********************/

    UNION ALL
    
   -- OWNRISK - CREDIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --1 AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE 1 END) AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,ABS(INVOICE_AMT), 
     --INVOICE_AMT, 
     --0, 
    (CASE WHEN ID_CN_NO IS NULL THEN ABS(INVOICE_AMT) ELSE 0 END), 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE ABS(INVOICE_AMT) END),NULL,INVOICE_PREFIX,   
     INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.LA_VAT_CODE = a.LA_VAT_CODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SEGL' 
   WHERE v.ACCMATRIXTYPE = 'SELLING'
   AND V.INVOICETYPE='OWNRISKDIFF' 
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))=0.00)
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)= 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
		
	)

UNION ALL 
   -- OWNRISK - DEBIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --0  AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 1 ELSE 0 END)  AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,ABS(INVOICE_AMT), 
     --0, 
     --INVOICE_AMT, 
    (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE ABS(INVOICE_AMT) END), 
     (CASE WHEN ID_CN_NO IS NULL THEN ABS(INVOICE_AMT) ELSE 0 END),
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SEGL' 
   WHERE v.ACCMATRIXTYPE = 'SELLING'
   AND V.INVOICETYPE='OWNRISKDIFF'
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))<>0.00) 
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)<> 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
	)	


   ---------------------************ROW 274 FOR OR(CREDIT CUSTOMER)COST - START
     UNION ALL 
   -- OWNRISK - CREDIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --1 AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 1 ELSE 0 END) AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=v.ID_WO_NO AND WH.ID_WO_PREFIX=v.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,INVOICE_AMT, 
     --INVOICE_AMT, 
     (CASE WHEN ID_CN_NO IS NULL THEN INVOICE_AMT ELSE 0 END),
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE INVOICE_AMT END), 
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.LA_VAT_CODE = a.LA_VAT_CODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SCGL' 
   WHERE v.ACCMATRIXTYPE = 'COST' 
   AND V.INVOICETYPE='OWNRISKDIFF'
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))=0.00)
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)= 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
		
	)
 
 ---------------------************ROW 274 FOR OR(CREDIT CUSTOMER) COST - END

 ---------------------************ROW 274 FOR OR(DEBIT CUSTOMER) COST - START
 
   UNION ALL 
   -- OWNRISK - DEBIT CUSTOMER 
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE, 
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO, 
     --0  AS LA_FLG_CRE_DEB, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE 1 END)  AS LA_FLG_CRE_DEB,
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO, 
     --ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     ISNULL((SELECT TOP 1 WH.LA_DEPT_ACCOUNT_NO FROM TBL_WO_HEADER WH WHERE WH.ID_WO_NO=v.ID_WO_NO AND WH.ID_WO_PREFIX=v.ID_WO_PREFIX AND WH.LA_DEPT_ACCOUNT_NO <>''),ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE))
	 as DEPT_ACCOUNT_NO,   
     DIMENSION,INVOICE_AMT, 
     --0, 
     --INVOICE_AMT, 
     (CASE WHEN ID_CN_NO IS NULL THEN 0 ELSE INVOICE_AMT END),
     (CASE WHEN ID_CN_NO IS NULL THEN INVOICE_AMT ELSE 0 END), 
     NULL,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID, 
     INVOICE_TRANSACTIONDATE, 
	  (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @OWNRISK v 
	LEFT OUTER  JOIN @INVOICEJOURNAL a ON v.Cust_AccCode = a.LA_CUST_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
	AND v.INVL_ACCCODE = a.LA_SaleAccCode 
	AND a.LA_SALEDESCRIPTION = 'OR' 
	AND a.LA_DESCRIPTION = 'SCGL' 
   WHERE v.ACCMATRIXTYPE = 'COST'
   AND V.INVOICETYPE='OWNRISKDIFF'
   AND --((SELECT DBT_PER FROM TBL_WO_DEBITOR_DETAIL WHERE ID_JOB_DEB IN (SELECT ID_DEBITOR FROM TBL_INV_HEADER WHERE ID_INV_NO=V.ID_INV_NO) AND ID_WO_NO IN (SELECT ID_WO_NO FROM TBL_INV_DETAIL WHERE ID_INV_NO=V.ID_INV_NO))<>0.00) 
	(
		(
			SELECT DBT_PER 
			FROM TBL_WO_DEBITOR_DETAIL 
			WHERE ID_JOB_DEB IN 
						(
							SELECT ID_DEBITOR 
							FROM TBL_INV_HEADER 
							WHERE ID_INV_NO=V.ID_INV_NO
						) 
			AND ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB_ID=V.ID_JOB_ID
		)<> 0.00 
		AND ((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_NO=V.ID_WO_NO 
			AND ID_WO_PREFIX=V.ID_WO_PREFIX 
			AND ID_JOB=V.ID_JOB_ID)<>0)
	)	
 
 ---------------------************ROW 274 FOR OR(DEBIT CUSTOMER) COST - END


/*****************************************OR FIXED PRICE**********************/
 --------------INVOICE FEES-------------------
 
 UNION ALL              
   --INVOICE FEES - SELLING              
   SELECT CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	 DATE_INVOICE,  INV_CUST_GROUP,  DEPT_ACC_CODE,              
     INVOICETYPE, ACCMATRIXTYPE,  INVL_ACCCODE,  ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  ISNULL(LA_FLG_CRE_DEB,1)
		 ELSE 0	 END AS LA_FLG_CRE_DEB,  
     ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
     ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO, 
     DIMENSION,
      ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
     INVOICE_VAT_PER,INVOICE_PREFIX,  INVOICE_NO,   INVOICE_TRANSACTIONID,              
     INVOICE_TRANSACTIONDATE, 
	 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	 CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	 @CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @INVOICEFEES g              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON g.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND g.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND g.LA_VAT_CODE = a.LA_VAT_CODE 
   AND g.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'IF'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE g.ACCMATRIXTYPE = 'SELLING' 
   AND g.INVOICETYPE='INVOICEFEES'   

   UNION ALL
   --INVOICE FEES - SELLING               
   SELECT               
    CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO
		 ELSE ID_CN_NO END AS ID_INV_NO,
	DATE_INVOICE, INV_CUST_GROUP,   DEPT_ACC_CODE,              
    INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,   ACCMATRIXSLNO,              
        CASE WHEN ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN  0
		 ELSE ISNULL(LA_FLG_CRE_DEB,1)	 END AS LA_FLG_CRE_DEB,  
    ISNULL(ACCOUNTNO,@ERROR_ACCOUNT_CODE) as ACCOUNTNO,
    ISNULL(DEPT_ACCOUNT_NO, @ERROR_ACCOUNT_CODE) as DEPT_ACCOUNT_NO,    
    DIMENSION,--INVOICE_AMT,
    --CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,1) = 1 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =0 THEN INVOICE_AMT
				--	ELSE NULL END,
    --DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 0 AND ID_CN_NO IS NULL THEN INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  INVOICE_AMT 
				--		 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 1 THEN  INVOICE_AMT 
 			--		ELSE NULL END,
 	ABS(INVOICE_AMT) AS INVOICE_AMT,
    CREDIT_AMOUNT = CASE WHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT>=0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB =1 THEN ABS(INVOICE_AMT) 
						 WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
					ELSE NULL END,
    DEBIT_AMOUNT  = CASE WHEN LA_FLG_CRE_DEB = 1 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB IS NULL THEN  ABS(INVOICE_AMT) 
						 WHEN ID_CN_NO IS NOT NULL AND LA_FLG_CRE_DEB = 0 THEN  ABS(INVOICE_AMT) 
						 wHEN ISNULL(LA_FLG_CRE_DEB,0) = 0 AND ID_CN_NO IS NULL AND INVOICE_AMT<0 THEN ABS(INVOICE_AMT)
 					ELSE NULL END,
    INVOICE_VAT_PER,INVOICE_PREFIX, INVOICE_NO,    INVOICE_TRANSACTIONID,              
    INVOICE_TRANSACTIONDATE, 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END))) AS TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2, 
	CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP, 
	@CREATED_BY [CREATED_BY], a.PROJECT 
   FROM @INVOICEFEES l              
   LEFT OUTER JOIN               
    @INVOICEJOURNAL a               
   ON l.Cust_AccCode = a.LA_CUST_ACCCODE              
   AND l.DEPT_ACC_CODE = a.LA_DEPT_ACCCODE 
   AND l.LA_VAT_CODE = a.LA_VAT_CODE 
   AND l.INVL_ACCCODE = a.LA_SaleAccCode              
   AND a.LA_SALEDESCRIPTION = 'IF'              
   AND a.LA_DESCRIPTION = 'SEGL'              
   WHERE l.ACCMATRIXTYPE = 'SELLING'              
    AND l.INVOICETYPE='INVOICEFEESDIFF'  
 --------------INVOICE FEES-------------------   
    
    
  --GL Credit Amount        
  UNION ALL        
  SELECT distinct                
	ih.ID_INV_NO                
	,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
		  ELSE DT_CREDITNOTE END as  DATE_INVOICE              
	,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP,                    
	'' as DEPT_ACC_CODE,     
	'' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO,                
	CASE WHEN ID_CN_NO IS NULL THEN  ISNULL(LA_FLG_CRE_DEB,1) 
		 ELSE 0	 END AS LA_FLG_CRE_DEB,                    
	--ISNULL(cust.CUST_ACCOUNT_NO, cust.ID_CUSTOMER) as ACCOUNTNO,
	CASE WHEN CUST.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN 
			CUST.ID_CUSTOMER
		ELSE
			cust.CUST_ACCOUNT_NO
		END as ACCOUNTNO,
	--'' as DEPT_ACCOUNT_NO,
	LA_DEPT_ACCOUNT_NO,
	'' as DIMENSION,                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT,                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as CREDIT_AMOUNT,                
	CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
			as INVOICE_AMT,
		 CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
			as CREDIT_AMOUNT,
	NULL as DEBIT_AMOUNT,                
	null as INVOICE_VAT_PER,  
	CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
	--(SELECT --Bug ID:-BL-057  
	----Date   :-31-jan-2009   
	--substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
	----INV_PREFIX  
	----change end  
	--FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
	--(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
	--WHERE ID_SETTINGS=            
	--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
	--WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
	--AND ID_INV_CONFIG=                      
	--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
	--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
	--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))  
	CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)                   
	END  
	as INVOICE_PREFIX,  
	ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
	ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
	CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
		--(SELECT TextCode   
		--	FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
		--	(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--		WHERE ID_SETTINGS =   
		--		(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--			WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
		--			AND ID_INV_CONFIG =   
		--				 (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		--				 ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
		--				AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())
		--		 )
		--	  )
		--) 
	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))	  
	END AS TEXTCODE   
	,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	--,NULL as ID_Dept_Inv 
	,ID_DEPT_INV as ID_DEPT_INV
	,0 AS EXT_VAT_CODE   
	,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
	,ih.INV_KID AS CUST_ID   
	,ih.ID_DEBITOR AS CUST_NO   
	,ih.CUST_NAME AS CUST_NAME   
	,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
	,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
	,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
	,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
	,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
	,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
	,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
	,cg.ID_PAY_TERM AS CUST_PAYTERM   
	,ih.INV_CUST_GROUP AS CUST_GROUP,   
	@CREATED_BY [CREATED_BY], lam.PROJECT   
  FROM  TBL_INV_HEADER ih   
	inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
	inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
	inner join @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
	inner join TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode 
	and lam.id_dept =ih.ID_Dept_Inv /*in (SELECT ID_DEPT FROM @DEPT)*/ and lam.LA_Flg_LedGL =1 
	--AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT) 
	AND cg.ID_VAT_CD = ISNULL((SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='VAT' AND DESCRIPTION = lam.LA_VATCODE), 0)
	left outer join TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
	WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                         
	AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE
	 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )                 
	-- ******************************************
	-- Modified Date : 16th December 2009
	-- Bug Description : ar transaction can have Inv_amt = 0
	--AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 1        
	AND   ih.ID_INV_NO IS NOT NULL  And isnull(inv.LA_FLG_CRE_DEB,1) = 1        
	-- ************* End Of Modification ********* 
	--Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
	AND ISNULL(FLG_EXPORTED_AND_CREDITED,0) = 0
  -- GL CREDIT NOTE FOR CREDIT AMOUNT
  --GL Credit Amount        
  UNION ALL        
	SELECT distinct                
		ih.ID_CN_NO                
		,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
		  ELSE DT_CREDITNOTE END as  DATE_INVOICE            
		,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP,                    
		'' as DEPT_ACC_CODE,     
		'' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO                
		,0 AS LA_FLG_CRE_DEB,                   
		--, ISNULL(cust.CUST_ACCOUNT_NO, cust.ID_CUSTOMER) as ACCOUNTNO   
		CASE WHEN CUST.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN 
			CUST.ID_CUSTOMER
		ELSE
			cust.CUST_ACCOUNT_NO
		END as ACCOUNTNO,
		--'' as DEPT_ACCOUNT_NO,
		LA_DEPT_ACCOUNT_NO,	
		'' as DIMENSION,                
		--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT,                
		CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
			as INVOICE_AMT,	
		NULL as CREDIT_AMOUNT,                
		--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) AS DEBIT_AMOUNT,                
		CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
	 as DEBIT_AMOUNT,   
		null as INVOICE_VAT_PER,  
		CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
		--(SELECT substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
		--	FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
		--	  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
		--		WHERE ID_SETTINGS=            
		--		(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
		--			WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP) AND ID_INV_CONFIG=                      
		--			(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
		--				ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
		--				AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                     
		CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)
		END  
		as INVOICE_PREFIX,  ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
		ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
		CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			--(SELECT TextCode   
			--	FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
			--	(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
			--		WHERE ID_SETTINGS =   
			--		(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
			--			WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
			--			AND ID_INV_CONFIG =   
			--				 (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
			--				 ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			--				AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())
			--		 )
			--	  )
			--) 
		(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END)))	  
		END AS TEXTCODE   
		,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
		--,NULL as ID_Dept_Inv 
		,ID_DEPT_INV as ID_DEPT_INV
		,0 AS EXT_VAT_CODE   
		,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
		,'' AS CUST_ID   
		,ih.ID_DEBITOR AS CUST_NO   
		,ih.CUST_NAME AS CUST_NAME   
		,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
		,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
		,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
		,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
		,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
		,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
		,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
		,cg.ID_PAY_TERM AS CUST_PAYTERM   
		,ih.INV_CUST_GROUP AS CUST_GROUP,   
		@CREATED_BY [CREATED_BY], lam.PROJECT   
	  FROM  TBL_INV_HEADER ih   
	 inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
	 inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
	 inner join @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
	 inner join TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept =ih.ID_Dept_Inv /*in (SELECT ID_DEPT FROM @DEPT)*/ and lam.LA_Flg_LedGL =1 
	 -- AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT) 
      AND cg.ID_VAT_CD = ISNULL((SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='VAT' AND DESCRIPTION = lam.LA_VATCODE), 0)
	 left outer join TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
	  WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                         
	 AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	 AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
	  OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )                
	 -- ******************************************
	 -- Modified Date : 16th December 2009
	 -- Bug Description : ar transaction can have Inv_amt = 0
	 --AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 1        
	 AND   ih.ID_INV_NO IS NOT NULL  And isnull(inv.LA_FLG_CRE_DEB,1) = 1        
	 -- ************* End Of Modification ********* 
	 --Fazal  
	 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE' AND ID_CN_NO IS NOT NULL) 
  -- END CREDIT NOTE

  --GL Debit Amount        
  UNION ALL        
  SELECT distinct                
   ih.ID_INV_NO                
	,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
		  ELSE DT_CREDITNOTE END as  DATE_INVOICE              
	,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP                    
	,'' as DEPT_ACC_CODE    
	,'' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO,                
	--inv.LA_FLG_CRE_DEB, --ISNULL(cust.CUST_ACCOUNT_NO, cust.ID_CUSTOMER) as ACCOUNTNO,
	CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO)>=0 THEN 
	 inv.LA_FLG_CRE_DEB
	ELSE 1
    END AS LA_FLG_CRE_DEB,
	CASE WHEN CUST.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN 
			CUST.ID_CUSTOMER
		ELSE
			cust.CUST_ACCOUNT_NO
		END as ACCOUNTNO,
	--'' as DEPT_ACCOUNT_NO,
	LA_DEPT_ACCOUNT_NO,
	'' as DIMENSION,                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT, 
	CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
			as INVOICE_AMT,               
CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN NULL
			ELSE
				CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO)<0 THEN 
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))
				ELSE NULL
				END
			END	
	 as CREDIT_AMOUNT,              
CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO)>=0 THEN 
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))
				ELSE NULL
				END
			END	
	 as DEBIT_AMOUNT,                 
	NULL as INVOICE_VAT_PER,  
	CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
	 -- (SELECT --Bug ID:-BL-057  
	 -- --Date   :-31-jan-2009   
	 --  substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
	 -- --INV_PREFIX  
	 -- --change end  
	 --  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
	 --  WHERE ID_SETTINGS=            
		--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
		-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
	 --  AND ID_INV_CONFIG=                      
	 --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
	 -- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                     
	CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)
	 END  
	 as INVOICE_PREFIX,  ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
	 ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
	  CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
	 -- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
		-- (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--  WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		-- ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
	 --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))
  	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	 END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 --,NULL as ID_Dept_Inv   
	 ,ID_DEPT_INV as ID_DEPT_INV
	 ,0 AS EXT_VAT_CODE      
	 ,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
	 ,ih.INV_KID AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO   
	 ,ih.CUST_NAME AS CUST_NAME   
	 ,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
	 ,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
	 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
	 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
	 ,cg.ID_PAY_TERM AS CUST_PAYTERM   
	 ,ih.INV_CUST_GROUP AS CUST_GROUP,   
	 @CREATED_BY [CREATED_BY], lam.PROJECT   
  FROM  TBL_INV_HEADER ih   
	inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
	inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
	left outer JOIN @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
	inner join TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept =ih.ID_Dept_Inv /*in (SELECT ID_DEPT FROM @DEPT)*/ and lam.LA_Flg_LedGL =0    
	--AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT)   
	AND cg.ID_VAT_CD = ISNULL((SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='VAT' AND DESCRIPTION = lam.LA_VATCODE), 0)
	inner join TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
	WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
	AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
	 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )               
	-- ******************************************
	-- Modified Date : 16th December 2009
	-- Bug Description : ar transaction can have Inv_amt = 0
	--AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 0        
	AND   ih.ID_INV_NO IS NOT NULL  And inv.LA_FLG_CRE_DEB = 0        
	-- *************** End Of Modification ***********
	--Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
	AND ISNULL(FLG_EXPORTED_AND_CREDITED,0) = 0
	AND ih.INV_AMT >= 0
	
	---------------------------274--------------------------------------------------
	 --GL Debit Amount        
  UNION ALL        
  SELECT distinct                
   ih.ID_INV_NO                
	,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
		  ELSE DT_CREDITNOTE END as  DATE_INVOICE              
	,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP                    
	,'' as DEPT_ACC_CODE    
	,'' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO,                
	1 AS LA_FLG_CRE_DEB, --ISNULL(cust.CUST_ACCOUNT_NO, cust.ID_CUSTOMER) as ACCOUNTNO,
	CASE WHEN CUST.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN 
			CUST.ID_CUSTOMER
		ELSE
			cust.CUST_ACCOUNT_NO
		END as ACCOUNTNO,
	--'' as DEPT_ACCOUNT_NO,
	LA_DEPT_ACCOUNT_NO,
	'' as DIMENSION,                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT, 
	CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
			as INVOICE_AMT,               
	CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	 as CREDIT_AMOUNT,                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as DEBIT_AMOUNT, 
	NULL as DEBIT_AMOUNT,               
	NULL as INVOICE_VAT_PER,  
	CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
	 -- (SELECT --Bug ID:-BL-057  
	 -- --Date   :-31-jan-2009   
	 --  substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
	 -- --INV_PREFIX  
	 -- --change end  
	 --  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
	 --  WHERE ID_SETTINGS=            
		--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
		-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
	 --  AND ID_INV_CONFIG=                      
	 --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
	 -- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
	 CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)                
	 END  
	 as INVOICE_PREFIX,  ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
	 ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
	  CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   

  	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))   
	 END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 --,NULL as ID_Dept_Inv   
	 ,ID_DEPT_INV as ID_DEPT_INV
	 ,0 AS EXT_VAT_CODE      
	 ,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
	 ,ih.INV_KID AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO   
	 ,ih.CUST_NAME AS CUST_NAME   
	 ,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
	 ,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
	 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
	 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
	 ,cg.ID_PAY_TERM AS CUST_PAYTERM   
	 ,ih.INV_CUST_GROUP AS CUST_GROUP,   
	 @CREATED_BY [CREATED_BY], lam.PROJECT   
  FROM  TBL_INV_HEADER ih   
	inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
	inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
	left outer JOIN @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
	inner join TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept =ih.ID_Dept_Inv /*in (SELECT ID_DEPT FROM @DEPT)*/ and lam.LA_Flg_LedGL =0    
	--AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT)   
	AND cg.ID_VAT_CD = ISNULL((SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='VAT' AND DESCRIPTION = lam.LA_VATCODE), 0)
	inner join TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
	WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
	AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
	AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE  
	 OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )               
	-- ******************************************
	-- Modified Date : 16th December 2009
	-- Bug Description : ar transaction can have Inv_amt = 0
	--AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 0        
	AND   ih.ID_INV_NO IS NOT NULL  And inv.LA_FLG_CRE_DEB = 0        
	-- *************** End Of Modification ***********
	--Fazal  
	AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE')  
	AND ISNULL(FLG_EXPORTED_AND_CREDITED,0) = 0
	AND ih.INV_AMT < 0
	-------------------------------------------------------------------
	
 -- GL CREDIT NOTE DEBIT AMOUT
	  --GL Debit Amount        
  UNION ALL        
  SELECT distinct                
   ih.ID_CN_NO                
	,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
		  ELSE DT_CREDITNOTE END as  DATE_INVOICE              
	,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP                    
	,'' as DEPT_ACC_CODE    
	,'' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO,                
	1 AS LA_FLG_CRE_DEB, --ISNULL(cust.CUST_ACCOUNT_NO, cust.ID_CUSTOMER) as ACCOUNTNO,
	CASE WHEN CUST.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN 
			CUST.ID_CUSTOMER
		ELSE
			cust.CUST_ACCOUNT_NO
		END as ACCOUNTNO,
	--'' as DEPT_ACCOUNT_NO,
	LA_DEPT_ACCOUNT_NO, '' as DIMENSION,                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT, 
	CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
			as INVOICE_AMT,	                
	--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as  CREDIT_AMOUNT, 
	CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END	
	 as CREDIT_AMOUNT,                 
	NULL as DEBIT_AMOUNT,                
	NULL as INVOICE_VAT_PER,  
	CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
	 -- (SELECT --Bug ID:-BL-057  
	 -- --Date   :-31-jan-2009   
	 --  substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
	 -- --INV_PREFIX  
	 -- --change end  
	 --  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
	 --  WHERE ID_SETTINGS=            
		--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
		-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
	 --  AND ID_INV_CONFIG=                      
	 --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
		--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
	 -- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                     
	 CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)
	 END  
	 as INVOICE_PREFIX,  ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
	 ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
	  CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
	 -- (SELECT TextCode   
	 -- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
	 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
		--WHERE ID_SETTINGS =   
		-- (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
		--  WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
	 --  AND ID_INV_CONFIG =   
		--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
		-- ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
	 --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
 	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(CASE WHEN ID_CN_NO IS NULL THEN ID_INV_NO ELSE ID_CN_NO END)))
	 END AS TEXTCODE   
	 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
	 --,NULL as ID_Dept_Inv  
	 ,ID_DEPT_INV as ID_DEPT_INV
	 ,0 AS EXT_VAT_CODE      
	 ,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
	 ,'' AS CUST_ID   
	 ,ih.ID_DEBITOR AS CUST_NO   
	 ,ih.CUST_NAME AS CUST_NAME   
	 ,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
	 ,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
	 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
	 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
	 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
	 ,cg.ID_PAY_TERM AS CUST_PAYTERM   
	 ,ih.INV_CUST_GROUP AS CUST_GROUP,   
	 @CREATED_BY [CREATED_BY], lam.PROJECT   
  FROM  TBL_INV_HEADER ih   
 inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
 inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
 left outer JOIN @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
 inner join TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept =ih.ID_Dept_Inv /*in (SELECT ID_DEPT FROM @DEPT)*/ and lam.LA_Flg_LedGL =0    
 --AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT) 
 AND cg.ID_VAT_CD = ISNULL((SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='VAT' AND DESCRIPTION = lam.LA_VATCODE), 0)
 inner join TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
  WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
 AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
 AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
  OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )                
  -- ******************************************
 -- Modified Date : 16th December 2009
 -- Bug Description : ar transaction can have Inv_amt = 0
 --AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 0        
 AND   ih.ID_INV_NO IS NOT NULL  And inv.LA_FLG_CRE_DEB = 0        
 -- *************** End Of Modification ***********
 --Fazal  
 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE' AND ID_CN_NO IS NOT NULL)  
 -- END CREDIT NOTE
  )                 
   a    


	INSERT INTO #INVOICEJOURNAL(
		   ID_INV_NO,  DATE_INVOICE, INV_CUST_GROUP,    DEPT_ACC_CODE,                
		   INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,    ACCMATRIXSLNO,                
		   LA_FLG_CRE_DEB, ACCOUNTNO,  DEPT_ACCOUNT_NO, DIMENSION,                
		   INVOICE_AMT, CREDIT_AMOUNT, DEBIT_AMOUNT,    INVOICE_VAT_PER,                
		   INVOICE_PREFIX, INVOICE_NO,  INVOICE_TRANSACTIONID,  INVOICE_TRANSACTIONDATE,   
		   TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		   CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,   
		   [CREATED_BY], PROJECT)
		  SELECT distinct                
			 ih.ID_INV_NO                
			 ,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
					ELSE DT_CREDITNOTE END as  DATE_INVOICE             
			 ,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP,                    
			 '' as DEPT_ACC_CODE,    
			 '' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO,                
			 CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO) < 0 THEN 1 ELSE ISNULL(inv.LA_FLG_CRE_DEB,0) END AS LA_FLG_CRE_DEB, case when cust.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN cust.ID_CUSTOMER
				ELSE
					cust.CUST_ACCOUNT_NO
			END as ACCOUNTNO,
			--'' as DEPT_ACCOUNT_NO,
			LA_DEPT_ACCOUNT_NO, '' as DIMENSION,                
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - START
			--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT,                
			CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END as INVOICE_AMT,		
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - END	    , 
			 CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO)<0 THEN
					abs(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))
			 ELSE 
					NULL
			 END as CREDIT_AMOUNT,                 
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - START        
			 --ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as DEBIT_AMOUNT,                
			CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
			THEN 0.00
				ELSE
				CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO)<0 THEN
					NULL
				ELSE 
					abs(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))
				END
			END as DEBIT_AMOUNT,
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - END,                   
			null as INVOICE_VAT_PER,  
			CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
			 -- (SELECT --Bug ID:-BL-057  
			 -- --Date   :-31-jan-2009   
			 --  substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
			 -- --INV_PREFIX  
			 -- --change end  
			 --  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
			 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
			 --  WHERE ID_SETTINGS=            
				--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
				-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
			 --  AND ID_INV_CONFIG=                      
			 --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
				--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
			 -- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                     
			 CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)
			 END  
			 as INVOICE_PREFIX,  ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
			 ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
			CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			 -- (SELECT TextCode   
			 -- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
			 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
				--WHERE ID_SETTINGS =   
				-- (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
				--  WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
			 --  AND ID_INV_CONFIG =   
				--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
				-- ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			 --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
		 	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
			 END AS TEXTCODE   
			 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
			 --,NULL as ID_Dept_Inv  
			 ,ID_DEPT_INV as ID_DEPT_INV	
			 ,0 AS EXT_VAT_CODE      
			 ,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
			 ,ih.INV_KID AS CUST_ID   
			 ,ih.ID_DEBITOR AS CUST_NO   
			 ,ih.CUST_NAME AS CUST_NAME   
			 ,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
			 ,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
			 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
			 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
			 ,cg.ID_PAY_TERM AS CUST_PAYTERM   
			 ,ih.INV_CUST_GROUP AS CUST_GROUP,   
			 @CREATED_BY [CREATED_BY], lam.PROJECT   
			 FROM  TBL_INV_HEADER ih   
			 inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
			 inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
			 left outer JOIN @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
			 LEFT OUTER JOIN TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept =ih.ID_Dept_Inv /*in (SELECT ID_DEPT FROM @DEPT)*/ and lam.LA_Flg_LedGL = 0    
			 --AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT)
			  and LA_VATCODE in
				(SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = (
					SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP  WHERE ID_CUST_GRP_SEQ = cg.ID_CUST_GRP_SEQ) AND ID_CONFIG = 'VAT')
			 LEFT OUTER JOIN TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
			 WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
			 AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
			 AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
			  OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )                
			  -- ******************************************
			 -- Modified Date : 16th December 2009
			 -- Bug Description : ar transaction can have Inv_amt = 0
			 --AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 0        
			 AND   ih.ID_INV_NO IS NOT NULL  And ISNULL(inv.LA_FLG_CRE_DEB,0) = 0        
			 -- *************** End Of Modification ***********
			 --Fazal  
		 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE' )
		 AND ih.ID_INV_NO NOT IN (SELECT ID_INV_NO FROM #INVOICEJOURNAL where INVOICETYPE = '')
 		 AND ISNULL(ID_CN_NO,0) NOT IN (SELECT ID_INV_NO FROM #INVOICEJOURNAL where INVOICETYPE = '')
		 AND ISNULL(FLG_EXPORTED_AND_CREDITED,0) = 0
		 AND ih.INV_AMT >= 0
		 
--------------------------------------------274--------------------------------
		 INSERT INTO #INVOICEJOURNAL(
		   ID_INV_NO,  DATE_INVOICE, INV_CUST_GROUP,    DEPT_ACC_CODE,                
		   INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,    ACCMATRIXSLNO,                
		   LA_FLG_CRE_DEB, ACCOUNTNO,  DEPT_ACCOUNT_NO, DIMENSION,                
		   INVOICE_AMT, CREDIT_AMOUNT, DEBIT_AMOUNT,    INVOICE_VAT_PER,                
		   INVOICE_PREFIX, INVOICE_NO,  INVOICE_TRANSACTIONID,  INVOICE_TRANSACTIONDATE,   
		   TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		   CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,   
		   [CREATED_BY], PROJECT)
		  SELECT distinct                
			 ih.ID_INV_NO                
			 ,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
					ELSE DT_CREDITNOTE END as  DATE_INVOICE             
			 ,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP,                    
			 '' as DEPT_ACC_CODE,    
			 '' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE,  lam.ID_SLNO as ACCMATRIXSLNO,                
			 CASE WHEN DBO.FnGetInvoiceAmount(ih.ID_INV_NO) < 0 THEN 1 ELSE ISNULL(inv.LA_FLG_CRE_DEB,0) END AS LA_FLG_CRE_DEB, case when cust.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN cust.ID_CUSTOMER
				ELSE
					cust.CUST_ACCOUNT_NO
			END as ACCOUNTNO,
			--'' as DEPT_ACCOUNT_NO,
			LA_DEPT_ACCOUNT_NO, '' as DIMENSION,                
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - START
			--ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT,                
			CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END as INVOICE_AMT,		
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - END	    , 
			CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
			THEN 0.00
				ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END as CREDIT_AMOUNT,                
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - START  
			NULL as DEBIT_AMOUNT,
			null as INVOICE_VAT_PER,  
			CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
			 -- (SELECT --Bug ID:-BL-057  
			 --  substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
			 --  FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
			 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
			 --  WHERE ID_SETTINGS=            
				--(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
				-- WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
			 --  AND ID_INV_CONFIG=                      
			 --  (SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
				--ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
			 -- AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                     
			 CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)
			 END  
			 as INVOICE_PREFIX,  ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
			 ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
			CASE WHEN ih.ID_INV_NO IS NOT NULL THEN 
		 	(select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_INV_NO)))
			 END AS TEXTCODE   
			 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
			 --,NULL as ID_Dept_Inv  
			 ,ID_DEPT_INV as ID_DEPT_INV	
			 ,0 AS EXT_VAT_CODE      
			 ,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
			 ,ih.INV_KID AS CUST_ID   
			 ,ih.ID_DEBITOR AS CUST_NO   
			 ,ih.CUST_NAME AS CUST_NAME   
			 ,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
			 ,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
			 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
			 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
			 ,cg.ID_PAY_TERM AS CUST_PAYTERM   
			 ,ih.INV_CUST_GROUP AS CUST_GROUP,   
			 @CREATED_BY [CREATED_BY], lam.PROJECT   
			 FROM  TBL_INV_HEADER ih   
			 inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
			 inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
			 left outer JOIN @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
			 LEFT OUTER JOIN TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept in (SELECT ID_DEPT FROM @DEPT) and lam.LA_Flg_LedGL = 0    
			 AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT) and LA_VATCODE in
				(SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = (
					SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP  WHERE ID_CUST_GRP_SEQ = cg.ID_CUST_GRP_SEQ) AND ID_CONFIG = 'VAT')
			 LEFT OUTER JOIN TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
			 WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
			 AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
			 AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
			  OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )                
			AND   ih.ID_INV_NO IS NOT NULL  And ISNULL(inv.LA_FLG_CRE_DEB,0) = 0        
		 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE' )
		 AND ih.ID_INV_NO NOT IN (SELECT ID_INV_NO FROM #INVOICEJOURNAL where INVOICETYPE = '')
 		 AND ISNULL(ID_CN_NO,0) NOT IN (SELECT ID_INV_NO FROM #INVOICEJOURNAL where INVOICETYPE = '')
		 AND ISNULL(FLG_EXPORTED_AND_CREDITED,0) = 0
		 AND ih.INV_AMT < 0
		 
--------------------------------------------274--------------------------------
		 	
-- BEGIN CREDIT NOTE FOR AR TRANSACTION IF MATRIX IS NOT EXIST

	INSERT INTO #INVOICEJOURNAL(
		   ID_INV_NO,  DATE_INVOICE, INV_CUST_GROUP,    DEPT_ACC_CODE,                
		   INVOICETYPE, ACCMATRIXTYPE, INVL_ACCCODE,    ACCMATRIXSLNO,                
		   LA_FLG_CRE_DEB, ACCOUNTNO,  DEPT_ACCOUNT_NO, DIMENSION,                
		   INVOICE_AMT, CREDIT_AMOUNT, DEBIT_AMOUNT,    INVOICE_VAT_PER,                
		   INVOICE_PREFIX, INVOICE_NO,  INVOICE_TRANSACTIONID,  INVOICE_TRANSACTIONDATE,   
		   TEXTCODE, VOUCHER_TEXT, ID_DEPT_INV, EXT_VAT_CODE, DUE_DATE, CUST_ID, CUST_NO, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
		   CUST_POST_CODE, CUST_PLACE, CUST_PHONE, CUST_FAX, CUST_CREDIT_LIMIT, CUST_PAYTERM, CUST_GROUP,   
		   [CREATED_BY], PROJECT)
		  SELECT distinct                
			 ih.ID_CN_NO                
			 ,CASE WHEN ID_CN_NO IS NULL THEN ih.DT_INVOICE 
					ELSE DT_CREDITNOTE END as  DATE_INVOICE              
			 ,ISNULL(ih.INV_CUST_GROUP,'')  AS INV_CUST_GROUP,                    
			 '' as DEPT_ACC_CODE,    
			 '' as INVOICETYPE, '' as ACCMATRIXTYPE,  '' as INVL_ACCCODE
			 ,lam.ID_SLNO as ACCMATRIXSLNO
			 ,1 LA_FLG_CRE_DEB 
			 ,case when cust.CUST_ACCOUNT_NO IS NULL OR (CUST.CUST_ACCOUNT_NO = '') THEN cust.ID_CUSTOMER
				ELSE
					cust.CUST_ACCOUNT_NO
				END as ACCOUNTNO
			 ,--'' as DEPT_ACCOUNT_NO,
			  LA_DEPT_ACCOUNT_NO, '' as DIMENSION
			 ,---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - START
			 --,ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as INVOICE_AMT,                
			 --ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO)) as CREDIT_AMOUNT,                
			CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END as INVOICE_AMT,
			CASE WHEN (ISNULL(cg.USE_INTCUST,0)=1 AND (SELECT TOP 1 FLG_INTCUST_EXP FROM TBL_MAS_DEPT WHERE ID_Dept = ID_DEPT_INV) = 1)
				THEN 0.00
			ELSE
				ABS(DBO.FnGetInvoiceAmount(ih.ID_INV_NO))	
			END as CREDIT_AMOUNT		
			---------------------************ROW 274 FOR AR FOR VAT-FREE CUST - END	 
			 ,NULL as DEBIT_AMOUNT
			 ,NULL as INVOICE_VAT_PER
			 ,CASE WHEN ih.ID_INV_NO IS NOT NULL THEN                          
			  --(SELECT substring(ih.id_inv_no,0,DIFFERENCE(ih.id_inv_no,INV_PREFIX))  
			  --	   FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES=                      
				 --(SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG                      
					--WHERE ID_SETTINGS=            
					--	(SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG                      
					--	WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)                      
					--	AND ID_INV_CONFIG=                      
					--	(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV=                
					--		ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv                       
					--AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                     
			CONVERT(VARCHAR(20),dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR),121)
				END  
			 as INVOICE_PREFIX,  
			 ih.ID_INV_NO as INVOICE_NO,   @TRANSRES as INVOICE_TRANSACTIONID,                
			 ih.INV_TRANSDATE as INVOICE_TRANSACTIONDATE,   
			  CASE WHEN ih.ID_INV_NO IS NOT NULL THEN   
			 -- (SELECT TextCode   
			 -- FROM TBL_MAS_INV_PAYMENT_SERIES WHERE ID_PAYSERIES =   
			 --  (SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG   
				--WHERE ID_SETTINGS =   
				-- (SELECT ID_PAY_TYPE FROM TBL_MAS_CUST_GROUP MCG   
				--  WHERE MCG.ID_CUST_GRP_SEQ=Inv_CUST_GROUP)   
			 --  AND ID_INV_CONFIG =   
				--(SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION WHERE ID_SUBSIDERY_INV =   
				-- ih.ID_Subsidery_Inv AND ID_DEPT_INV=ih.ID_Dept_Inv   
			 --  AND ih.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))   
			 (select TextCode from TBL_MAS_INV_PAYMENT_SERIES where INV_PREFIX=(select dbo.FN_GETINVOICEPREFIX(ih.ID_CN_NO)))
			 END AS TEXTCODE   
			 ,dbo.FnGetVoucherText(ih.ID_INV_NO) AS VOUCHER_TEXT   
			 --,NULL as ID_Dept_Inv  
			 ,ID_DEPT_INV as ID_DEPT_INV	
			 ,0 AS EXT_VAT_CODE        
			 ,CAST(dbo.FnGetDueDate(DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DUE_DATE   
			 ,'' AS CUST_ID   
			 ,ih.ID_DEBITOR AS CUST_NO   
			 ,ih.CUST_NAME AS CUST_NAME   
			 ,ih.CUST_PERM_ADD1 AS CUST_ADDR1   
			 ,ih.CUST_PERM_ADD2 AS CUST_ADDR2   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODE') AS CUST_POST_CODE   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'POSTCODECITY') AS CUST_PLACE   
			 ,dbo.FnGetCustInfoByInvID(ih.ID_INV_NO, 'PHONE') AS CUST_PHONE   
			 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'FAX') AS CUST_FAX   
			 ,dbo.FnGetCustInfoByCustID(ih.ID_DEBITOR, 'CREDIT') AS CUST_CREDIT_LIMIT   
			 ,cg.ID_PAY_TERM AS CUST_PAYTERM   
			 ,ih.INV_CUST_GROUP AS CUST_GROUP,   
			 @CREATED_BY [CREATED_BY], lam.PROJECT   
			 FROM  TBL_INV_HEADER ih   
			 inner join TBL_MAS_CUST_GROUP cg  ON cg.ID_CUST_GRP_SEQ = ih.INV_CUST_GROUP   
			 inner join TBL_MAS_CUSTOMER cust ON cust.ID_CUSTOMER = ih.ID_DEBITOR   
			 left outer JOIN @CustGrp CGtable ON  ih.Inv_CUST_GROUP = CGtable.ID_Cust_Grp       
			 LEFT OUTER JOIN TBL_LA_ACCOUNT_MATRIX lam  on  lam.LA_CUST_ACCCODE= cg.Cust_AccCode and lam.id_dept in (SELECT ID_DEPT FROM @DEPT) and lam.LA_Flg_LedGL = 0    
			 AND lam.ID_Dept in (SELECT ID_DEPT FROM @DEPT) and LA_VATCODE in
				(SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = (
					SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP  WHERE ID_CUST_GRP_SEQ = cg.ID_CUST_GRP_SEQ) AND ID_CONFIG = 'VAT')
			 LEFT OUTER JOIN TBL_LA_ACCOUNT_MATRIX_Detail inv on  lam.id_slno = inv.LA_SLNO        
			 WHERE  (ih.ID_SUBSIDERY_INV = @INV_SUBSIDIARY OR  @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
			 AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
			 AND   (CONVERT(DATETIME,CONVERT(CHAR(10),ih.DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE 
			  OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )                
			  -- ******************************************
			 -- Modified Date : 16th December 2009
			 -- Bug Description : ar transaction can have Inv_amt = 0
			 --AND   ih.ID_INV_NO IS NOT NULL  AND ih.INV_AMT > 0 And inv.LA_FLG_CRE_DEB = 0        
			 AND   ih.ID_INV_NO IS NOT NULL  And ISNULL(inv.LA_FLG_CRE_DEB,0) = 0        
			 -- *************** End Of Modification ***********
			 --Fazal  
		 AND (ih.FLG_TRANS_TO_ACC IS NULL OR ih.FLG_TRANS_TO_ACC = 'FALSE' AND ID_CN_NO IS NOT NULL) 
		 AND (ih.ID_INV_NO IN (SELECT ID_INV_NO FROM #INVOICEJOURNAL where INVOICETYPE = '') OR FLG_EXPORTED_AND_CREDITED=1)
 		 AND ID_CN_NO NOT IN (SELECT ID_INV_NO FROM #INVOICEJOURNAL where INVOICETYPE = '')  

-- END CREDIT NOTE
		 
   ----UPDATING TRANSACTION ID                             
   UPDATE                             
		TBL_INV_HEADER                             
     SET                             
		FLG_TRANS_TO_ACC = 'TRUE',                            
		INV_TRANSACTIONID = 
		CASE WHEN ISNULL(FLG_EXPORTED_AND_CREDITED, 0) = 1 THEN 
			INV_TRANSACTIONID
		ELSE 
			@TRANSRES  
		END, 
		CN_TRANSACTIONID = 
		CASE WHEN ISNULL(FLG_EXPORTED_AND_CREDITED, 0) = 1 THEN 
			@TRANSRES 
		ELSE 
			NULL 
		END, 
		INV_TRANSDATE = 
		CASE WHEN ISNULL(FLG_EXPORTED_AND_CREDITED, 0) = 0 OR INV_TRANSDATE IS NULL THEN GETDATE() 
		ELSE INV_TRANSDATE
		END
   WHERE (FLG_TRANS_TO_ACC IS NULL  OR FLG_TRANS_TO_ACC = 'FALSE' )                            
   AND (@INV_SUBSIDIARY = -1 OR ID_DEPT_INV IN (SELECT ID_DEPT FROM @DEPT))   
   AND  (ID_SUBSIDERY_INV =    LTRIM(RTRIM(@INV_SUBSIDIARY)) OR   @INV_SUBSIDIARY = -1) -- Bug ID :4228                        
   AND  (CONVERT(DATETIME,CONVERT(CHAR(10),DT_INVOICE,101)) BETWEEN @STARTDATE AND @ENDDATE
    OR  CONVERT(DATETIME,CONVERT(CHAR(10),DT_CREDITNOTE,101)) BETWEEN @STARTDATE AND @ENDDATE )  
 
	IF (SELECT ISNULL(FLG_REM_COST,0) FROM TBL_LA_CONFIG)=1
	BEGIN
	UPDATE #INVOICEJOURNAL SET INVOICE_AMT=0 WHERE INVOICETYPE ='SPARES' AND (ACCMATRIXTYPE='COST' OR ACCMATRIXTYPE='STOCK')
	UPDATE #INVOICEJOURNAL SET CREDIT_AMOUNT=0 WHERE INVOICETYPE ='SPARES' AND (ACCMATRIXTYPE='COST' OR ACCMATRIXTYPE='STOCK') AND CREDIT_AMOUNT IS NOT NULL
	UPDATE #INVOICEJOURNAL SET DEBIT_AMOUNT=0 WHERE INVOICETYPE ='SPARES' AND (ACCMATRIXTYPE='COST' OR ACCMATRIXTYPE='STOCK') AND DEBIT_AMOUNT IS NOT NULL
	END
	
	
 
/*

  DELETE FROM TBL_LA_INVOICEJOURNAL                       
   WHERE TBL_LA_INVOICEJOURNAL.ID_INV_NO IN ( SELECT ID_INV_NO FROM #INVOICEJOURNAL)
*/
 
  SELECT [INVOICETYPE],   
 [Transaction type], [Posting date], [Voucher number], [Voucher date], [Voucher type], [Voucher tekst], [Department],   
 [Project], [Debit account], [Credit account], [VAT code], [Currency code], [Exchange rate], [Exchange amount],   
 [Amount], [Counterpart account], [Due date], [Chain no 1], [Quantity], [Customer Identification (CID)], [TaxClassNo],   
 [Slaccount], [Invoice number], [Remittance profile number], [Product no], [Employee no 1], [Extra1], [Extra2],   
 [Extra3], [Extra4], [Customer no], [Chain no 2], [Customer name], [Adress 1], [Adress 2], [Postcode], [Place],   
 [Skipalfa], [Telephone], [Telefax], [Sortname], [PostAccount], [BankAccount], [Credit Limit on customer],   
 [Delivery name], [Del.adress 1], [Del.adress 2], [Del. PostCode], [Del.Place], [Employee no 2], [District no],   
 [Payment Terms], [Skipnum], [Customer Type], [DiscountGroup], [CustomerProfile], [ACCOUNTNO], [DEPT_ACCOUNT_NO],   
 [ACCMATRIXTYPE], [LA_FLG_CRE_DEB], ID_INV_NO AS [INV_NUMBER], [CREDIT_AMOUNT], [DEBIT_AMOUNT],ACCMATRIXSLNO ,[Voucher Number 2],[Voucher Text 2],
 [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],[Invoice Amount 2],[Location],[Department Account No],[Dimension],[Payment terms 2]

  INTO #INVOICEJOURNALTEMP   
  FROM  
 (  
 SELECT   
  INVOICETYPE AS [INVOICETYPE],   
  dbo.FnGetExportFixedValue('Transaction type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Transaction type],   
  ISNULL(dbo.FnGetExportFixedValue('Posting date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), GETDATE()) AS [Posting date],  
  ISNULL(dbo.FnGetExportFixedValue('Voucher number', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),ID_INV_NO) AS [Voucher number],   --INVOICE_PREFIX + REPLACE(ID_INV_NO, INVOICE_PREFIX, '')) AS [Voucher number],   
  ISNULL(dbo.FnGetExportFixedValue('Voucher date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DATE_INVOICE) AS [Voucher date],   
  ISNULL(dbo.FnGetExportFixedValue('Voucher type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), TEXTCODE) AS [Voucher type],   
  ISNULL(dbo.FnGetExportFixedValue('Voucher tekst', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), VOUCHER_TEXT) AS [Voucher tekst],   
  --ISNULL(dbo.FnGetExportFixedValue('Department', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ID_DEPT_INV) AS [Department],   
	DEPT_ACCOUNT_NO AS [Department],
  ISNULL(dbo.FnGetExportFixedValue('Project', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), PROJECT) AS [Project],   
  ISNULL(dbo.FnGetExportFixedValue('Debit account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ACCOUNTNO) AS [Debit account],   
  ISNULL(dbo.FnGetExportFixedValue('Credit account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ACCOUNTNO) AS [Credit account],   
  ISNULL(dbo.FnGetExportFixedValue('VAT code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), EXT_VAT_CODE) AS [VAT code],   
  dbo.FnGetExportFixedValue('Currency code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Currency code],   
  dbo.FnGetExportFixedValue('Exchange rate', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Exchange rate],   
  dbo.FnGetExportFixedValue('Exchange amount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Exchange amount],   
  INVOICE_AMT AS [Amount],   
  dbo.FnGetExportFixedValue('Counterpart account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Counterpart account],   
  ISNULL(dbo.FnGetExportFixedValue('Due date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DUE_DATE) AS [Due date],   
  dbo.FnGetExportFixedValue('Chain no 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Chain no 1],   
  dbo.FnGetExportFixedValue('Quantity', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Quantity],   
  ISNULL(dbo.FnGetExportFixedValue('Customer Identification (CID)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_ID) AS [Customer Identification (CID)],   
  dbo.FnGetExportFixedValue('TaxClassNo', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [TaxClassNo],   
  dbo.FnGetExportFixedValue('Slaccount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Slaccount],   
  ISNULL(dbo.FnGetExportFixedValue('Invoice number', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),ID_INV_NO) AS [Invoice number],   --INVOICE_PREFIX + REPLACE(ID_INV_NO, INVOICE_PREFIX, '')) AS [Voucher number],   
  dbo.FnGetExportFixedValue('Remittance profile number', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Remittance profile number],   
  dbo.FnGetExportFixedValue('Product no', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Product no],   
  dbo.FnGetExportFixedValue('Employee no 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Employee no 1],   
  dbo.FnGetExportFixedValue('Extra1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra1],   
  dbo.FnGetExportFixedValue('Extra2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra2],   
  dbo.FnGetExportFixedValue('Extra3', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra3],   
  dbo.FnGetExportFixedValue('Extra4', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra4],   
  ISNULL(dbo.FnGetExportFixedValue('Customer no', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_NO) AS [Customer no],   
  dbo.FnGetExportFixedValue('Chain no 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Chain no 2],   
  ISNULL(dbo.FnGetExportFixedValue('Customer name', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_NAME) AS [Customer name],   
  ISNULL(dbo.FnGetExportFixedValue('Adress 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_ADDR1) AS [Adress 1],   
  ISNULL(dbo.FnGetExportFixedValue('Adress 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_ADDR2) AS [Adress 2],   
  ISNULL(dbo.FnGetExportFixedValue('Postcode', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_POST_CODE) AS [Postcode],   
  ISNULL(dbo.FnGetExportFixedValue('Place', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PLACE) AS [Place],   
  dbo.FnGetExportFixedValue('Skipalfa', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Skipalfa],   
  ISNULL(dbo.FnGetExportFixedValue('Telephone', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PHONE) AS [Telephone],   
  ISNULL(dbo.FnGetExportFixedValue('Telefax', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_FAX) AS [Telefax],   
  dbo.FnGetExportFixedValue('Sortname', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Sortname],   
  dbo.FnGetExportFixedValue('PostAccount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [PostAccount],   
  dbo.FnGetExportFixedValue('BankAccount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [BankAccount],   
  ISNULL(dbo.FnGetExportFixedValue('Credit Limit on customer', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_CREDIT_LIMIT) AS [Credit Limit on customer],   
  dbo.FnGetExportFixedValue('Delivery name', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Delivery name],   
  dbo.FnGetExportFixedValue('Del.adress 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del.adress 1],   
  dbo.FnGetExportFixedValue('Del.adress 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del.adress 2],   
  dbo.FnGetExportFixedValue('Del. PostCode', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del. PostCode],   
  dbo.FnGetExportFixedValue('Del.Place', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del.Place],   
  dbo.FnGetExportFixedValue('Employee no 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Employee no 2],   
  dbo.FnGetExportFixedValue('District no', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [District no],   
  ISNULL(dbo.FnGetExportFixedValue('Payment terms', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PAYTERM) AS [Payment terms],   
  dbo.FnGetExportFixedValue('Skipnum', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Skipnum],   
  ISNULL(dbo.FnGetExportFixedValue('Customer Type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_GROUP) AS [Customer Type],   
  dbo.FnGetExportFixedValue('DiscountGroup', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [DiscountGroup],   
  dbo.FnGetExportFixedValue('CustomerProfile', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [CustomerProfile],   
  ACCOUNTNO, 
--	DEPT_ACCOUNT_NO, 
	ISNULL(dbo.FnGetExportFixedValue('Department', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ID_DEPT_INV) AS [DEPT_ACCOUNT_NO]
	,ACCMATRIXTYPE, LA_FLG_CRE_DEB, ID_INV_NO, [CREDIT_AMOUNT], [DEBIT_AMOUNT],ACCMATRIXSLNO 
	,  ISNULL(dbo.FnGetExportFixedValue('Voucher Number 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),ID_INV_NO) AS [Voucher number 2]
	,  ISNULL(dbo.FnGetExportFixedValue('Voucher Text 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), VOUCHER_TEXT) AS [Voucher Text 2]
	--,  ISNULL(Replace(Convert(varchar(10), DATE_INVOICE, 120), '-', ''),'00000000')  AS [Invoice Date 2] 
		,isnull(dbo.FnGetExportFixedValue('Invoice Date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),
			Replace(Convert(varchar(10), CONVERT(VARCHAR(20),DATE_INVOICE,121), 120), '-', ''))
		AS [Invoice Date 2]
	 ,dbo.FnGetExportFixedValue('Debit Account Project code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Debit Account Project code]
	 ,dbo.FnGetExportFixedValue('Debit Account Vat Code(Credit Lines)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Debit Account Vat Code(Credit Lines)]   
     ,dbo.FnGetExportFixedValue('Debit Account Vat Code(Invoice)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Debit Account Vat Code(Invoice)] 
     ,dbo.FnGetExportFixedValue('Credit Account Project code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Credit Account Project code]  
     ,dbo.FnGetExportFixedValue('Credit Account Vat Code(Credit Lines)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Credit Account Vat Code(Credit Lines)]   
     ,dbo.FnGetExportFixedValue('Credit Account Vat Code(Invoice)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Credit Account Vat Code(Invoice)]
	 ,CASE WHEN isnull(DUE_DATE,'00.00.0000')='00.00.0000' THEN 
			isnull(dbo.FnGetExportFixedValue('Due Date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),'00000000') 
		  ELSE		 
		 --ISNULL(Replace(Convert(varchar(10), CONVERT(VARCHAR(20),cast(DUE_DATE as datetime),121), 120), '-', ''),'00000000')  
		 --ISNULL(dbo.FnGetExportFixedValue((Replace(Convert(varchar(10), CONVERT(VARCHAR(20),cast(DUE_DATE as datetime),121), 120), '-', '')), 'InvoiceJournalExport.aspx',@TEMPLATE_ID),'00000000')  
			isnull(dbo.FnGetExportFixedValue('Due Date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),Replace(Convert(varchar(10),CONVERT(VARCHAR(20), INVOICE_PREFIX ,121), 120), '-', ''))
		 END		 
		 AS [DUE DATE 2]
	 , INVOICE_AMT AS [Invoice Amount 2]
	 ,(SELECT top 1 DPT_Location FROM TBL_MAS_DEPT WHERE (ID_Dept = (SELECT TOP 1 ID_Dept_Inv FROM TBL_INV_HEADER HD WHERE HD.ID_INV_NO =#INVOICEJOURNAL.[ID_INV_NO])
			OR ID_Dept = (SELECT TOP 1 ID_Dept_Inv FROM TBL_INV_HEADER HD WHERE HD.ID_CN_NO =#INVOICEJOURNAL.[ID_INV_NO])))
				AS [Location]
	 ,ISNULL(dbo.FnGetExportFixedValue('Department Account No', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DEPT_ACCOUNT_NO) AS [Department Account No] 
	 ,ISNULL(dbo.FnGetExportFixedValue('Dimension', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DIMENSION) AS [Dimension] 
	 , ISNULL(dbo.FnGetExportFixedValue('Payment Terms 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PAYTERM) AS [Payment Terms 2]      
 FROM #INVOICEJOURNAL  WHERE (INVOICE_AMT <> 0 OR ((SELECT VAT_PERCENTAGE 
FROM TBL_MAS_SETTINGS 
WHERE 
ID_SETTINGS = (SELECT ID_VAT_CD 
			   FROM TBL_MAS_CUST_GROUP	
			   WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = CUST_NO)
			   ) 
AND ID_CONFIG = 'VAT')=0.00 AND INVOICETYPE='')) 
 )mst  
 ORDER BY [INVOICETYPE] 

 /*******************row-456*******************/
 select name.FIELD_NAME,name.FIELD_ID,con.AR_VAT_FREE,con.AR_VAT_PAYING,con.GL_VAT_FREE,con.GL_VAT_PAYING
into #temp1 from TBL_MAS_FIELD_CONFIGURATION con
inner join TBL_MAS_FIELD_NAMES name on name.FIELD_ID=con.FIELD_ID
where TEMPLATE_ID=@TEMPLATE_ID



IF (((SELECT TOP 1 ISNULL([Debit Account Vat Code(Credit Lines)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp1 WHERE FIELD_NAME='Debit Account Vat Code(Credit Lines)'))
BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Debit Account Vat Code(Credit Lines)]= 
CASE WHEN  LA_FLG_CRE_DEB=0 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'2'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'2'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp1 t1
 WHERE t1.FIELD_NAME='Debit Account Vat Code(Credit Lines)'  
 END
 
 
 IF (((SELECT TOP 1 ISNULL([Debit Account Vat Code(Invoice)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp1 WHERE FIELD_NAME='Debit Account Vat Code(Invoice)'))
 BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Debit Account Vat Code(Invoice)]= 
	CASE WHEN  LA_FLG_CRE_DEB=0 
		THEN 
			CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
				CASE WHEN [INVOICETYPE] <> '' THEN
					CASE WHEN ISNULL([PROJECT],'')='' THEN
						CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
							'3'
						ELSE
							GL_VAT_PAYING
						END
					ELSE
						[PROJECT]
					END
				ELSE	
					CASE WHEN ISNULL([PROJECT],'')='' THEN
						CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
							'3'
						ELSE
							AR_VAT_PAYING
						END
					ELSE
						[PROJECT]
					END				
				END	
			ELSE 
				CASE WHEN [INVOICETYPE] <> '' THEN
					CASE WHEN ISNULL([PROJECT],'')='' THEN
						CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
							'4'
						ELSE
							GL_VAT_FREE
						END
					ELSE
						[PROJECT]
					END
				ELSE	
					CASE WHEN ISNULL([PROJECT],'')='' THEN
						CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
							'4'
						ELSE
							AR_VAT_FREE
						END
					ELSE
						[PROJECT]
					END
				END	 
			END 
	ELSE 
		'' 
	END
 FROM #temp1 t1
 WHERE t1.FIELD_NAME='Debit Account Vat Code(Invoice)'  
END
 
IF (((SELECT TOP 1 ISNULL([Credit Account Vat Code(Credit Lines)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp1 WHERE FIELD_NAME='Credit Account Vat Code(Credit Lines)'))
 BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Credit Account Vat Code(Credit Lines)]= 
CASE WHEN  LA_FLG_CRE_DEB=1 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'2'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'2'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp1 t1
 WHERE t1.FIELD_NAME='Credit Account Vat Code(Credit Lines)'  
 END
 
IF (((SELECT TOP 1 ISNULL([Credit Account Vat Code(Invoice)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp1 WHERE FIELD_NAME='Credit Account Vat Code(Invoice)'))
 BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Credit Account Vat Code(Invoice)]= 
CASE WHEN  LA_FLG_CRE_DEB=1 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
						'3'
					ELSE
						GL_VAT_PAYING
					END
				ELSE
					[PROJECT]
				END				
			ELSE	
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
						'3'
					ELSE
						AR_VAT_PAYING
					END
				ELSE
					[PROJECT]					
				END	
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
						'4'
					ELSE
						GL_VAT_FREE
					END
				ELSE
					[PROJECT]
				END
			ELSE	
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
						'4'
					ELSE
						AR_VAT_FREE
					END
				ELSE
					[PROJECT]
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp1 t1
 WHERE t1.FIELD_NAME='Credit Account Vat Code(Invoice)'  
END
 
 IF (((SELECT TOP 1 ISNULL([Debit Account Project code],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp1 WHERE FIELD_NAME='Debit Account Project code'))
BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
[Debit Account Project code]= 
CASE WHEN  LA_FLG_CRE_DEB=0 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'3'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'3'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'1'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp1 t1
 WHERE t1.FIELD_NAME='Debit Account Project code' 
 END
 
IF (((SELECT TOP 1 ISNULL([Credit Account Project code],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp1 WHERE FIELD_NAME='Credit Account Project code'))
BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
[Credit Account Project code]= 
CASE WHEN  LA_FLG_CRE_DEB=1 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'3'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'3'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'1'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp1 t1
 WHERE t1.FIELD_NAME='Credit Account Project code' 
 END
 
  IF ((SELECT TOP 1 isnull(FLG_DISPLAY_VOCHER,0) FROM TBL_LA_CONFIG ) = 1)
  BEGIN
     IF ((SELECT TOP 1 VOCHER_TYPE FROM TBL_LA_CONFIG ) = 'AR')
       BEGIN
         UPDATE #INVOICEJOURNALTEMP
		 SET [Voucher type] = ''
		 WHERE [INVOICETYPE] <> ''
          
       END
     ELSE
      BEGIN
       IF ((SELECT TOP 1 VOCHER_TYPE FROM TBL_LA_CONFIG ) = 'GL')
         BEGIN
			 UPDATE #INVOICEJOURNALTEMP
			 SET [Voucher type] = ''
			 WHERE [INVOICETYPE] = ''
          
         END
       END
    
  END
 
 drop table #temp1
 /************************************/
 
 

  
--  UPDATE #INVOICEJOURNALTEMP   
--  SET [Department] = '', [Project] = '', [Invoice number] = '', [VAT code] = '', [Due date] = '00.00.0000',   
--  [Customer Identification (CID)] = '', [Customer no] = 0, [Customer name] = '', [Adress 1] = '',   
--  [Adress 2] = '', [Postcode] = '', [Place] = '', [Telephone] = '', [Telefax] = '', [Sortname] = '',   
--  [PostAccount] = '', [BankAccount] = '', [Credit Limit on customer] = '0.00', [Payment terms] = 0,   
--  [Customer Type] = 0  
--  WHERE [INVOICETYPE] <> ''  
  
  UPDATE #INVOICEJOURNALTEMP 
  SET	[Voucher number]=@TRANSRES
  WHERE [INVOICETYPE] <> ''	AND (SELECT ISNULL(FLG_DISPLAY_ALL_INVNUM,0) FROM TBL_LA_CONFIG ) = 0
	
	

  UPDATE #INVOICEJOURNALTEMP 
  SET	[Voucher tekst]='', 
		[Customer Identification (CID)] = '', [Customer name] = '', [Adress 1] = '', 
		[Adress 2] = '', [Postcode] = '', [Place] = '', [Telephone] = '', [Telefax] = '', [Sortname] = '', 
		[PostAccount] = '', [BankAccount] = '', [Credit Limit on customer] = '0.00', [Payment terms] = 0, 
		[Customer Type] = 0
  WHERE [INVOICETYPE] <> ''
  
   
 

  
  --UPDATE #INVOICEJOURNALTEMP   
  --SET [Department] = '0'  
  --WHERE [INVOICETYPE] = ''  

  IF @ISGROUP = 1   
  BEGIN   
	 DELETE   
	 FROM #INVOICEJOURNALTEMP    
	  
	 INSERT INTO #INVOICEJOURNALTEMP  
	 (    
	  [Transaction type], [Posting date], [Voucher number], [Voucher date], [Voucher type], [Voucher tekst], [Department],   
	  [Project], [Debit account], [Credit account], [VAT code], [Currency code], [Exchange rate], [Exchange amount],   
	  [Amount], [Counterpart account], [Due date], [Chain no 1], [Quantity], [Customer Identification (CID)], [TaxClassNo],   
	  [Slaccount], [Invoice number], [Remittance profile number], [Product no], [Employee no 1], [Extra1], [Extra2],   
	  [Extra3], [Extra4], [Customer no], [Chain no 2], [Customer name], [Adress 1], [Adress 2], [Postcode], [Place],   
	  [Skipalfa], [Telephone], [Telefax], [Sortname], [PostAccount], [BankAccount], [Credit Limit on customer],   
	  [Delivery name], [Del.adress 1], [Del.adress 2], [Del. PostCode], [Del.Place], [Employee no 2], [District no],   
	  [Payment Terms], [Skipnum], [Customer Type], [DiscountGroup], [CustomerProfile], LA_FLG_CRE_DEB ,ACCOUNTNO
	  ,[Voucher Number 2],[Voucher Text 2],
       [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],
       [Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],
       [Invoice Amount 2],[Location],[Department Account No],[Dimension],[Payment terms 2]
	 )  
	 SELECT   
	  dbo.FnGetExportFixedValue('Transaction type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Transaction type],  
	  MAX(ISNULL(dbo.FnGetExportFixedValue('Posting date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), GETDATE())) AS [Posting date],  
	  @TRANSRES AS [Voucher number], '' AS [Voucher date], '' AS [Voucher type], '' AS [Voucher tekst], DEPT_ACCOUNT_NO AS [Department], 
		ISNULL(dbo.FnGetExportFixedValue('Project', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), PROJECT) AS [Project],
	  ISNULL(dbo.FnGetExportFixedValue('Debit account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ACCOUNTNO) AS [Debit account],   
	  ISNULL(dbo.FnGetExportFixedValue('Credit account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ACCOUNTNO) AS [Credit account],   
	  '' AS [VAT code], '' AS [Currency code], '' AS [Exchange rate], '' AS [Exchange amount],   
	  SUM(CAST(INVOICE_AMT AS DECIMAL(14, 5))) AS [Amount], '' AS [Counterpart account], '' AS [Due date],  
	  '' AS [Chain no 1], '' AS [Quantity], '' AS [Customer Identification (CID)], '' AS [TaxClassNo],   
	  '' AS [Slaccount], '' AS [Invoice number], '' AS [Remittance profile number], '' AS [Product no],   
	  '' AS [Employee no 1], '' AS [Extra1], '' AS [Extra2], '' AS [Extra3], '' AS [Extra4], '' AS [Customer no],   
	  '' AS [Chain no 2], '' AS [Customer name], '' AS [Adress 1], '' AS [Adress 2], '' AS [Postcode],   
	  '' AS [Place], '' AS [Skipalfa], '' AS [Telephone], '' AS [Telefax], '' AS [Sortname], '' AS [PostAccount],   
	  '' AS [BankAccount], '' AS [Credit Limit on customer], '' AS [Delivery name], '' AS [Del.adress 1],   
	  '' AS [Del.adress 2], '' AS [Del. PostCode], '' AS [Del.Place], '' AS [Employee no 2], '' AS [District no],   
	  '' AS [Payment terms], '' AS [Skipnum], '' AS [Customer Type], '' AS [DiscountGroup], '' AS [CustomerProfile],
	  LA_FLG_CRE_DEB, ACCOUNTNO
	  ,'' AS [Voucher Number 2], '' AS [Voucher Text 2],''AS [Invoice Date 2],'' AS [Debit Account Project code],
	  '' AS [Debit Account Vat Code(Credit Lines)], '' AS [Debit Account Vat Code(Invoice)], '' AS [Credit Account Project code], 
	  '' AS [Credit Account Vat Code(Credit Lines)] , ''AS [Credit Account Vat Code(Invoice)],
	  '' AS [Due date 2], SUM(CAST(INVOICE_AMT AS DECIMAL(14, 5))) AS [Invoice Amount 2], ''AS [Location]
	  ,''AS [Department Account No] , ''AS [Dimension], ''AS [Payment terms 2]
	  
	  FROM #INVOICEJOURNAL  
	  WHERE INVOICETYPE <> ''  and  CAST(INVOICE_AMT AS DECIMAL(14, 5))  >0
	  group by ACCOUNTNO, DEPT_ACCOUNT_NO, DIMENSION, PROJECT,LA_FLG_CRE_DEB -- , INVOICETYPE, ACCMATRIXTYPE
	 
	 
	  INSERT INTO #INVOICEJOURNALTEMP  
	 (    
	  [Transaction type], [Posting date], [Voucher number], [Voucher date], [Voucher type], [Voucher tekst], [Department],   
	  [Project], [Debit account], [Credit account], [VAT code], [Currency code], [Exchange rate], [Exchange amount],   
	  [Amount], [Counterpart account], [Due date], [Chain no 1], [Quantity], [Customer Identification (CID)], [TaxClassNo],   
	  [Slaccount], [Invoice number], [Remittance profile number], [Product no], [Employee no 1], [Extra1], [Extra2],   
	  [Extra3], [Extra4], [Customer no], [Chain no 2], [Customer name], [Adress 1], [Adress 2], [Postcode], [Place],   
	  [Skipalfa], [Telephone], [Telefax], [Sortname], [PostAccount], [BankAccount], [Credit Limit on customer],   
	  [Delivery name], [Del.adress 1], [Del.adress 2], [Del. PostCode], [Del.Place], [Employee no 2], [District no],   
	  [Payment Terms], [Skipnum], [Customer Type], [DiscountGroup], [CustomerProfile], LA_FLG_CRE_DEB ,ACCOUNTNO,[INV_NUMBER]
	  ,[Voucher Number 2],[Voucher Text 2],
       [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],[Invoice Amount 2],[Location],[Department Account No],[Dimension],[Payment terms 2]
	 )  
	 SELECT   
		dbo.FnGetExportFixedValue('Transaction type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Transaction type],   
		ISNULL(dbo.FnGetExportFixedValue('Posting date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), GETDATE()) AS [Posting date],  
		ISNULL(dbo.FnGetExportFixedValue('Voucher number', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),ID_INV_NO) AS [Voucher number],   --INVOICE_PREFIX + REPLACE(ID_INV_NO, INVOICE_PREFIX, '')) AS [Voucher number],   
		ISNULL(dbo.FnGetExportFixedValue('Voucher date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DATE_INVOICE) AS [Voucher date],   
		ISNULL(dbo.FnGetExportFixedValue('Voucher type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), TEXTCODE) AS [Voucher type],   
		ISNULL(dbo.FnGetExportFixedValue('Voucher tekst', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), VOUCHER_TEXT) AS [Voucher tekst],   
		DEPT_ACCOUNT_NO AS [Department],
		ISNULL(dbo.FnGetExportFixedValue('Project', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), PROJECT) AS [Project],     
		ISNULL(dbo.FnGetExportFixedValue('Debit account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ACCOUNTNO) AS [Debit account],   
		ISNULL(dbo.FnGetExportFixedValue('Credit account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), ACCOUNTNO) AS [Credit account],   
		ISNULL(dbo.FnGetExportFixedValue('VAT code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), EXT_VAT_CODE) AS [VAT code],   
		dbo.FnGetExportFixedValue('Currency code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Currency code],   
		dbo.FnGetExportFixedValue('Exchange rate', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Exchange rate],   
		dbo.FnGetExportFixedValue('Exchange amount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Exchange amount],    
		CAST(INVOICE_AMT AS DECIMAL(14, 5)) AS [Amount], 
		dbo.FnGetExportFixedValue('Counterpart account', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Counterpart account],   
		ISNULL(dbo.FnGetExportFixedValue('Due date', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DUE_DATE) AS [Due date],   
		dbo.FnGetExportFixedValue('Chain no 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Chain no 1],   
		dbo.FnGetExportFixedValue('Quantity', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Quantity],   
		ISNULL(dbo.FnGetExportFixedValue('Customer Identification (CID)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_ID) AS [Customer Identification (CID)],   
		dbo.FnGetExportFixedValue('TaxClassNo', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [TaxClassNo],   
		dbo.FnGetExportFixedValue('Slaccount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Slaccount],   
		ISNULL(dbo.FnGetExportFixedValue('Invoice number', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),ID_INV_NO) AS [Invoice number],   --INVOICE_PREFIX + REPLACE(ID_INV_NO, INVOICE_PREFIX, '')) AS [Voucher number],   
		dbo.FnGetExportFixedValue('Remittance profile number', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Remittance profile number],   
		dbo.FnGetExportFixedValue('Product no', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Product no],  
		dbo.FnGetExportFixedValue('Employee no 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Employee no 1],   
		dbo.FnGetExportFixedValue('Extra1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra1], 
		dbo.FnGetExportFixedValue('Extra2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra2],   
		dbo.FnGetExportFixedValue('Extra3', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra3],   
		dbo.FnGetExportFixedValue('Extra4', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Extra4],   
		ISNULL(dbo.FnGetExportFixedValue('Customer no', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_NO) AS [Customer no],   
		dbo.FnGetExportFixedValue('Chain no 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Chain no 2],   
		ISNULL(dbo.FnGetExportFixedValue('Customer name', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_NAME) AS [Customer name],   
		ISNULL(dbo.FnGetExportFixedValue('Adress 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_ADDR1) AS [Adress 1],   
		ISNULL(dbo.FnGetExportFixedValue('Adress 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_ADDR2) AS [Adress 2],   
		ISNULL(dbo.FnGetExportFixedValue('Postcode', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_POST_CODE) AS [Postcode],   
		ISNULL(dbo.FnGetExportFixedValue('Place', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PLACE) AS [Place],   
		dbo.FnGetExportFixedValue('Skipalfa', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Skipalfa],   
		ISNULL(dbo.FnGetExportFixedValue('Telephone', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PHONE) AS [Telephone],   
		ISNULL(dbo.FnGetExportFixedValue('Telefax', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_FAX) AS [Telefax],   
		dbo.FnGetExportFixedValue('Sortname', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Sortname],   
		dbo.FnGetExportFixedValue('PostAccount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [PostAccount],   
		dbo.FnGetExportFixedValue('BankAccount', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [BankAccount],   
		ISNULL(dbo.FnGetExportFixedValue('Credit Limit on customer', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_CREDIT_LIMIT) AS [Credit Limit on customer],   
		dbo.FnGetExportFixedValue('Delivery name', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Delivery name],   
		dbo.FnGetExportFixedValue('Del.adress 1', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del.adress 1],   
		dbo.FnGetExportFixedValue('Del.adress 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del.adress 2],   
		dbo.FnGetExportFixedValue('Del. PostCode', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del. PostCode],   
		dbo.FnGetExportFixedValue('Del.Place', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Del.Place],   
		dbo.FnGetExportFixedValue('Employee no 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Employee no 2],   
		dbo.FnGetExportFixedValue('District no', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [District no],   
		ISNULL(dbo.FnGetExportFixedValue('Payment terms', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PAYTERM) AS [Payment terms],   
		dbo.FnGetExportFixedValue('Skipnum', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Skipnum],   
		ISNULL(dbo.FnGetExportFixedValue('Customer Type', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_GROUP) AS [Customer Type],   
		dbo.FnGetExportFixedValue('DiscountGroup', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [DiscountGroup],   
		dbo.FnGetExportFixedValue('CustomerProfile', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [CustomerProfile],
		LA_FLG_CRE_DEB, ACCOUNTNO,ID_INV_NO
		,  ISNULL(dbo.FnGetExportFixedValue('Voucher Number 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),ID_INV_NO) AS [Voucher number 2]
		,  ISNULL(dbo.FnGetExportFixedValue('Voucher Text 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), VOUCHER_TEXT) AS [Voucher Text 2]
		--,ISNULL(dbo.FnGetExportFixedValue((Replace(Convert(varchar(10), CONVERT(VARCHAR(20),DATE_INVOICE,121), 120), '-', '')), 'InvoiceJournalExport.aspx',@TEMPLATE_ID),'00000000')  
		,isnull(dbo.FnGetExportFixedValue('Invoice Date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),
			Replace(Convert(varchar(10), CONVERT(VARCHAR(20),DATE_INVOICE,121), 120), '-', ''))
		AS [Invoice Date 2]
		 ,dbo.FnGetExportFixedValue('Debit Account Project code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Debit Account Project code]
		 ,dbo.FnGetExportFixedValue('Debit Account Vat Code(Credit Lines)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Debit Account Vat Code(Credit Lines)]   
		 ,dbo.FnGetExportFixedValue('Debit Account Vat Code(Invoice)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Debit Account Vat Code(Invoice)] 
		 ,dbo.FnGetExportFixedValue('Credit Account Project code', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Credit Account Project code]  
		 ,dbo.FnGetExportFixedValue('Credit Account Vat Code(Credit Lines)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Credit Account Vat Code(Credit Lines)]   
		 ,dbo.FnGetExportFixedValue('Credit Account Vat Code(Invoice)', 'InvoiceJournalExport.aspx', @TEMPLATE_ID) AS [Credit Account Vat Code(Invoice)]
		 --,ISNULL(dbo.FnGetExportFixedValue('Due date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), Replace(Convert(varchar(10), DUE_DATE, 120), '-', ''),'00000000') AS [Due date 2]
		 ,CASE WHEN isnull(DUE_DATE,'00.00.0000')='00.00.0000' THEN 
			isnull(dbo.FnGetExportFixedValue('Due Date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),'00000000') 
		  ELSE		 
		 --ISNULL(Replace(Convert(varchar(10), CONVERT(VARCHAR(20),cast(DUE_DATE as datetime),121), 120), '-', ''),'00000000')  
		 --ISNULL(dbo.FnGetExportFixedValue((Replace(Convert(varchar(10), CONVERT(VARCHAR(20),cast(DUE_DATE as datetime),121), 120), '-', '')), 'InvoiceJournalExport.aspx',@TEMPLATE_ID),'00000000')  
			isnull(dbo.FnGetExportFixedValue('Due Date 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID),Replace(Convert(varchar(10), CONVERT(VARCHAR(20),INVOICE_PREFIX ,121), 120), '-', ''))
		 END		 
		 AS [DUE DATE 2]		 

		 , CAST(INVOICE_AMT AS DECIMAL(14, 5)) AS [Invoice Amount 2]
		 ,(SELECT top 1 DPT_Location FROM TBL_MAS_DEPT WHERE (ID_Dept = (SELECT TOP 1 ID_Dept_Inv FROM TBL_INV_HEADER HD WHERE HD.ID_INV_NO =#INVOICEJOURNAL.[ID_INV_NO])
				OR ID_Dept = (SELECT TOP 1 ID_Dept_Inv FROM TBL_INV_HEADER HD WHERE HD.ID_CN_NO =#INVOICEJOURNAL.[ID_INV_NO])))
					AS [Location]
		 ,ISNULL(dbo.FnGetExportFixedValue('Department Account No', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DEPT_ACCOUNT_NO) AS [Department Account No] 
		 ,ISNULL(dbo.FnGetExportFixedValue('Dimension', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), DIMENSION) AS [Dimension] 
		 , ISNULL(dbo.FnGetExportFixedValue('Payment Terms 2', 'InvoiceJournalExport.aspx', @TEMPLATE_ID), CUST_PAYTERM) AS [Payment Terms 2]      
		FROM #INVOICEJOURNAL
		WHERE INVOICETYPE = ''  and CAST(INVOICE_AMT AS DECIMAL(14, 5))  >0
  END  
  
 --select '#INVOICEJOURNAL',DUE_DATE,DATE_INVOICE,* from #INVOICEJOURNAL
  --select '#INVOICEJOURNALTEMP',[DUE DATE],[DUE DATE 2],[Voucher date],[Invoice Date 2],* from #INVOICEJOURNALTEMP
  /*CHANGE TO COMBINE SAME ACCOUNT CODE FROM SAME INVOICE INTO SINGLE RECORD BASED ON SETTING - ROW 385*/
/*******************row-456*******************/

 select name.FIELD_NAME,name.FIELD_ID,con.AR_VAT_FREE,con.AR_VAT_PAYING,con.GL_VAT_FREE,con.GL_VAT_PAYING
into #temp2 from TBL_MAS_FIELD_CONFIGURATION con
inner join TBL_MAS_FIELD_NAMES name on name.FIELD_ID=con.FIELD_ID
where TEMPLATE_ID=@TEMPLATE_ID 
--and con.AR_VAT_FREE is not null



IF (((SELECT TOP 1 ISNULL([Debit Account Vat Code(Credit Lines)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp2 WHERE FIELD_NAME='Debit Account Vat Code(Credit Lines)'))
BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Debit Account Vat Code(Credit Lines)]= 
CASE WHEN  LA_FLG_CRE_DEB=0 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	 
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'2'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'2'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp2 t1
 WHERE t1.FIELD_NAME='Debit Account Vat Code(Credit Lines)'
 END
 
 
IF (((SELECT TOP 1 ISNULL([Debit Account Vat Code(Invoice)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp2 WHERE FIELD_NAME='Debit Account Vat Code(Invoice)'))
 BEGIN
 
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Debit Account Vat Code(Invoice)]= 
CASE WHEN  LA_FLG_CRE_DEB=0 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
						'3'
					ELSE
						GL_VAT_PAYING
					END
				ELSE
					[PROJECT]
				END
			ELSE	
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
						'3'
					ELSE
						AR_VAT_PAYING
					END
				ELSE
					[PROJECT]
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
						'4'
					ELSE
						GL_VAT_FREE
					END
				ELSE
					[PROJECT]
				END
			ELSE	
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
						'4'
					ELSE
						AR_VAT_FREE
					END
				ELSE
					[PROJECT]
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp2 t1
 WHERE t1.FIELD_NAME='Debit Account Vat Code(Invoice)'  
 END
 
 
IF (((SELECT TOP 1 ISNULL([Credit Account Vat Code(Credit Lines)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp2 WHERE FIELD_NAME='Credit Account Vat Code(Credit Lines)'))
 BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Credit Account Vat Code(Credit Lines)]= 
CASE WHEN  LA_FLG_CRE_DEB=1 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'2'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'2'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp2 t1
WHERE t1.FIELD_NAME='Credit Account Vat Code(Credit Lines)'  
 END
 
IF (((SELECT TOP 1 ISNULL([Credit Account Vat Code(Invoice)],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp2 WHERE FIELD_NAME='Credit Account Vat Code(Invoice)'))
 BEGIN

 UPDATE #INVOICEJOURNALTEMP
 SET 
 [Credit Account Vat Code(Invoice)]= 
CASE WHEN  LA_FLG_CRE_DEB=1 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
						'3'
					ELSE
						GL_VAT_PAYING
					END
				ELSE
					[PROJECT]
				END
			ELSE	
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
						'3'
					ELSE
						AR_VAT_PAYING
					END
				ELSE
					[PROJECT]
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
						'4'
					ELSE
						GL_VAT_FREE
					END
				ELSE
					[PROJECT]
				END
			ELSE	
				CASE WHEN ISNULL([PROJECT],'')='' THEN
					CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
						'4'
					ELSE
						AR_VAT_FREE
					END
				ELSE
					[PROJECT]
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp2 t1
 WHERE t1.FIELD_NAME='Credit Account Vat Code(Invoice)'  
 END
 
IF (((SELECT TOP 1 ISNULL([Debit Account Project code],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp2 WHERE FIELD_NAME='Debit Account Project code'))
BEGIN

 UPDATE #INVOICEJOURNALTEMP
 SET 
[Debit Account Project code]= 
CASE WHEN  LA_FLG_CRE_DEB=0 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'3'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'3'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'1'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp2 t1
 WHERE t1.FIELD_NAME='Debit Account Project code' 
 END
 
IF (((SELECT TOP 1 ISNULL([Credit Account Project code],'') FROM #INVOICEJOURNALTEMP)='') AND EXISTS (SELECT * FROM #temp2 WHERE FIELD_NAME='Credit Account Project code'))
BEGIN
 UPDATE #INVOICEJOURNALTEMP
 SET 
[Credit Account Project code]= 
CASE WHEN  LA_FLG_CRE_DEB=1 
	THEN 
		CASE WHEN isnull(dbo.FnGetVATByCustID([Customer no]),0)>0 THEN 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_PAYING,'')='' THEN
					'3'
				ELSE
					GL_VAT_PAYING
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_PAYING,'')='' THEN
					'1'
				ELSE
					AR_VAT_PAYING
				END
			END	
		ELSE 
			CASE WHEN [INVOICETYPE] <> '' THEN
				CASE WHEN ISNULL(GL_VAT_FREE,'')='' THEN
					'3'
				ELSE
					GL_VAT_FREE
				END
			ELSE	
				CASE WHEN ISNULL(AR_VAT_FREE,'')='' THEN
					'1'
				ELSE
					AR_VAT_FREE
				END
			END	 
		END 
ELSE 
	'' 
END
 FROM #temp2 t1
 WHERE t1.FIELD_NAME='Credit Account Project code' 
 END
 

 
 IF ((SELECT TOP 1 isnull(FLG_DISPLAY_VOCHER,0) FROM TBL_LA_CONFIG ) = 1)
  BEGIN
     IF ((SELECT TOP 1 VOCHER_TYPE FROM TBL_LA_CONFIG ) = 'AR')
       BEGIN
         UPDATE #INVOICEJOURNALTEMP
		 SET [Voucher type] = ''
		 WHERE [INVOICETYPE] <> ''
          
       END
     ELSE
      BEGIN
       IF ((SELECT TOP 1 VOCHER_TYPE FROM TBL_LA_CONFIG ) = 'GL')
         BEGIN
			 UPDATE #INVOICEJOURNALTEMP
			 SET [Voucher type] = ''
			 WHERE [INVOICETYPE] = ''
          
         END
       END
    
  END
  
 --   IF ((SELECT ISNULL(FLG_DISPLAY_ALL_INVNUM,0) FROM TBL_LA_CONFIG ) = 1)
	--  BEGIN
	  
	        
	--		UPDATE #INVOICEJOURNALTEMP
	--		SET [Invoice number]=dbo.udf_GetNumeric([Invoice number])
			
	--       UPDATE #INVOICEJOURNALTEMP
	--		SET [Voucher number 2]=dbo.udf_GetNumeric([Voucher number 2])
	       
	--       UPDATE #INVOICEJOURNALTEMP   
	--	   SET [Voucher number]=[Invoice number],[Voucher number 2] = [Voucher number 2],[Invoice number]=[Invoice number]
	--	   WHERE [INVOICETYPE] <> '' 
	--  END
	--ELSE
	--	BEGIN
	--		UPDATE #INVOICEJOURNALTEMP   
	--		SET [Voucher number]=@TRANSRES,[Voucher number 2] = @TRANSRES,[Invoice number]=@TRANSRES
	--		WHERE [INVOICETYPE] <> '' 
	--	END
 
   UPDATE #INVOICEJOURNALTEMP   
   SET [Due date] = '00.00.0000'
   WHERE [INVOICETYPE] <> '' 
 drop table #temp2
 
 /************************************/
---------

	SELECT [INVOICETYPE],	[Transaction type],	[Posting date],	[Voucher number],	[Voucher date],	
	[Voucher type],	[Voucher tekst],	[Department],	[Project],	[Debit account],	[Credit account],	
	[VAT code],	[Currency code],	[Exchange rate],	[Exchange amount],	[Amount],	[Counterpart account],	
	[Due date],	[Chain no 1],	[Quantity],	[Customer Identification (CID)],	[TaxClassNo],	[Slaccount],	
	[Invoice number],	[Remittance profile number],	[Product no],	[Employee no 1],	[Extra1],	[Extra2],	
	[Extra3],	[Extra4],	[Customer no],	[Chain no 2],	[Customer name],	[Adress 1],	[Adress 2],	[Postcode],	
	[Place],	[Skipalfa],	[Telephone],	[Telefax],	[Sortname],	[PostAccount],	[BankAccount],	[Credit Limit on customer],	
	[Delivery name],	[Del.adress 1],	[Del.adress 2],	[Del. PostCode],	[Del.Place],	[Employee no 2],	
	[District no],	[Payment Terms],	[Skipnum],	[Customer Type],	[DiscountGroup],	[CustomerProfile],	[ACCOUNTNO],	
	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO]
	,[Voucher Number 2],[Voucher Text 2],
    [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],[Invoice Amount 2],[Location],[Department Account No],[Dimension],[Payment terms 2]
	INTO #INVOICEJOURNALTEMP2
	FROM #INVOICEJOURNALTEMP
----------



IF ISNULL((SELECT TOP 1 FLG_COMB_LINES FROM TBL_LA_CONFIG),0)=1
begin
	delete from #INVOICEJOURNALTEMP
	insert into #INVOICEJOURNALTEMP
	SELECT [INVOICETYPE],	[Transaction type],	[Posting date],	[Voucher number],	[Voucher date],	
	[Voucher type],	[Voucher tekst],	[Department],	[Project],	[Debit account],	[Credit account],	
	[VAT code],	[Currency code],	[Exchange rate],	[Exchange amount],	SUM([Amount]) [Amount],	[Counterpart account],	
	[Due date],	[Chain no 1],	[Quantity],	[Customer Identification (CID)],	[TaxClassNo],	[Slaccount],	
	[Invoice number],	[Remittance profile number],	[Product no],	[Employee no 1],	[Extra1],	[Extra2],	
	[Extra3],	[Extra4],	[Customer no],	[Chain no 2],	[Customer name],	[Adress 1],	[Adress 2],	[Postcode],	
	[Place],	[Skipalfa],	[Telephone],	[Telefax],	[Sortname],	[PostAccount],	[BankAccount],	[Credit Limit on customer],	
	[Delivery name],	[Del.adress 1],	[Del.adress 2],	[Del. PostCode],	[Del.Place],	[Employee no 2],	
	[District no],	[Payment Terms],	[Skipnum],	[Customer Type],	[DiscountGroup],	[CustomerProfile],	[ACCOUNTNO],	
	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	SUM([CREDIT_AMOUNT]) [CREDIT_AMOUNT],	SUM([DEBIT_AMOUNT]) [DEBIT_AMOUNT],	[ACCMATRIXSLNO]
	,[Voucher Number 2],[Voucher Text 2],
    [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],
    SUM([Invoice Amount 2])[Invoice Amount 2],[Location],[Department Account No],[Dimension],[Payment terms 2]
	FROM #INVOICEJOURNALTEMP2
	GROUP BY 
	[INVOICETYPE],	[Transaction type],	[Posting date],	[Voucher number],	[Voucher date],	
	[Voucher type],	[Voucher tekst],	[Department],	[Project],	[Debit account],	[Credit account],	
	[VAT code],	[Currency code],	[Exchange rate],	[Exchange amount],		[Counterpart account],	
	[Due date],	[Chain no 1],	[Quantity],	[Customer Identification (CID)],	[TaxClassNo],	[Slaccount],	
	[Invoice number],	[Remittance profile number],	[Product no],	[Employee no 1],	[Extra1],	[Extra2],	
	[Extra3],	[Extra4],	[Customer no],	[Chain no 2],	[Customer name],	[Adress 1],	[Adress 2],	[Postcode],	
	[Place],	[Skipalfa],	[Telephone],	[Telefax],	[Sortname],	[PostAccount],	[BankAccount],	[Credit Limit on customer],	
	[Delivery name],	[Del.adress 1],	[Del.adress 2],	[Del. PostCode],	[Del.Place],	[Employee no 2],	
	[District no],	[Payment Terms],	[Skipnum],	[Customer Type],	[DiscountGroup],	[CustomerProfile],	[ACCOUNTNO],	
	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[ACCMATRIXSLNO]
	,[Voucher Number 2],[Voucher Text 2],
    [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],[Location],[Department Account No],[Dimension],[Payment terms 2]
end
else
begin 
	delete from #INVOICEJOURNALTEMP
	insert into #INVOICEJOURNALTEMP
	SELECT [INVOICETYPE],	[Transaction type],	[Posting date],	[Voucher number],	[Voucher date],	
	[Voucher type],	[Voucher tekst],	[Department],	[Project],	[Debit account],	[Credit account],	
	[VAT code],	[Currency code],	[Exchange rate],	[Exchange amount],	[Amount],	[Counterpart account],	
	[Due date],	[Chain no 1],	[Quantity],	[Customer Identification (CID)],	[TaxClassNo],	[Slaccount],	
	[Invoice number],	[Remittance profile number],	[Product no],	[Employee no 1],	[Extra1],	[Extra2],	
	[Extra3],	[Extra4],	[Customer no],	[Chain no 2],	[Customer name],	[Adress 1],	[Adress 2],	[Postcode],	
	[Place],	[Skipalfa],	[Telephone],	[Telefax],	[Sortname],	[PostAccount],	[BankAccount],	[Credit Limit on customer],	
	[Delivery name],	[Del.adress 1],	[Del.adress 2],	[Del. PostCode],	[Del.Place],	[Employee no 2],	
	[District no],	[Payment Terms],	[Skipnum],	[Customer Type],	[DiscountGroup],	[CustomerProfile],	[ACCOUNTNO],	
	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO]
	,[Voucher Number 2],[Voucher Text 2],
    [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],[Invoice Amount 2],[Location],[Department Account No],[Dimension],[Payment terms 2]
	FROM #INVOICEJOURNALTEMP2
end

--ROW-640

	SELECT distinct TEMP.[INVOICE NUMBER] as ID_INV_NO ,DET.ID_WO_NO,DET.ID_WO_PREFIX INTO #ORDERTEMP
	FROM TBL_INV_DETAIL DET 
	inner join TBL_INV_HEADER inh on
	det.ID_INV_NO=inh.ID_INV_NO
	INNER JOIN #INVOICEJOURNALTEMP TEMP ON 
	(TEMP.[INVOICE NUMBER]=DET.ID_INV_NO or 
	TEMP.[INVOICE NUMBER]=inh.ID_CN_NO)

	SELECT [INVOICE NUMBER],
	SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=1 THEN [Amount] ELSE NULL END,0)) CREDITSUM, 
	SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=0 THEN [Amount] ELSE NULL END,0)) DEBITSUM,SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=1 THEN [Amount] ELSE NULL END,0))-SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=0 THEN [Amount] ELSE NULL END,0)) AS 'INV_DIFFERENCE' ,GETDATE() AS 'DT_CREATED', @CREATED_BY AS CREATED_BY 
	,[Voucher date] AS 'DT_INVOICE',TBL_INV_HEADER.ID_Subsidery_Inv AS 'ID_SUBSIDERY',TBL_INV_HEADER.ID_Dept_Inv AS 'ID_INV_DEPT'--,ID_WO_NO,ID_WO_PREFIX 
	INTO #INVOICEJOURNALERRORTEMP1
	FROM #INVOICEJOURNALTEMP 
	INNER JOIN TBL_INV_HEADER
	ON (#INVOICEJOURNALTEMP.[INVOICE NUMBER]=TBL_INV_HEADER.ID_INV_NO
	or
	(#INVOICEJOURNALTEMP.[INVOICE NUMBER]=TBL_INV_HEADER.ID_CN_NO))
	--INNER JOIN TBL_INV_DETAIL
	---ON #INVOICEJOURNALTEMP.[INVOICE NUMBER]=TBL_INV_DETAIL.ID_INV_NO
	GROUP BY [INVOICE NUMBER],[Voucher date],TBL_INV_HEADER.ID_Subsidery_Inv,TBL_INV_HEADER.ID_Dept_Inv--,TBL_INV_DETAIL.ID_WO_NO,TBL_INV_DETAIL.ID_WO_PREFIX
	HAVING ABS(SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=1 THEN [Amount] ELSE NULL END,0))- SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=0 THEN [Amount] ELSE NULL END,0))) > 0.10
		
		--select '#INVOICEJOURNALTEMP',* from #INVOICEJOURNALTEMP

BEGIN --BALANCE CHANGES (UPDATED)/ROW 795
	--ROW 722
	
	DECLARE @INVOICETYPE AS VARCHAR(50)
	DECLARE @TYPE_COUNT INT
	DECLARE @CD_FLAG INT
	DECLARE @CTR1 INT --COUNTER FOR WHILE
	DECLARE @TR INT --TOTAL NUMBER OF RECORDS 
	DECLARE @INV VARCHAR(50)
	SET @CTR1=1
	SET @TR=0
	SET @CD_FLAG=0
		
			DECLARE @DIFF DECIMAL(10,10)
			/*TAKE ALL INVOICES WITH DIFFERENCES INTO TEMP TABLE 1*/
			SELECT 
			ISNULL(SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=1 THEN [AMOUNT] ELSE NULL END,0))-SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=0 THEN [AMOUNT] ELSE NULL END,0)),0) AS 'DIFF',
			#INVOICEJOURNALTEMP.[INVOICE NUMBER] INTO #INVDIFF
			FROM #INVOICEJOURNALTEMP 
			INNER JOIN TBL_INV_HEADER
			ON (#INVOICEJOURNALTEMP.[INVOICE NUMBER]=TBL_INV_HEADER.ID_INV_NO
			OR
			(#INVOICEJOURNALTEMP.[INVOICE NUMBER]=TBL_INV_HEADER.ID_CN_NO))
			GROUP BY [INVOICE NUMBER],[VOUCHER DATE],TBL_INV_HEADER.ID_SUBSIDERY_INV,TBL_INV_HEADER.ID_DEPT_INV--,TBL_INV_DETAIL.ID_WO_NO,TBL_INV_DETAIL.ID_WO_PREFIX
			HAVING ABS(SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=1 THEN [AMOUNT] ELSE NULL END,0))
			- SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=0 THEN [AMOUNT] ELSE NULL END,0))) > 0.00 
			AND ABS(SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=1 THEN [AMOUNT] ELSE NULL END,0))- 
			SUM(ISNULL(CASE WHEN LA_FLG_CRE_DEB=0 THEN [AMOUNT] ELSE NULL END,0))) < 0.10 
			
			/*TAKE RECORDS FROM TEMP TABLE 1 INTO TEMP TABLE 2 WITH ROW NUMBER FOR ITERATION*/
			SELECT ROW_NUMBER() OVER(ORDER BY [INVOICE NUMBER]) AS ROWNUM,[INVOICE NUMBER],DIFF INTO #INVLIST FROM #INVDIFF WHERE ABS(DIFF)>0 AND ABS(DIFF)<0.4
			SELECT @TR=COUNT(*) FROM #INVLIST /*NUMBER OF INVOICES WITH DIFFERENCES (BETWEEN 0 TP 0.4)*/
			
		WHILE(@CTR1<=@TR) /*TO CYCLE THROUGH ALL INVOICES WITH DIFFRENCE*/
		BEGIN

			SELECT @INVOICETYPE = INVTEMP.INVOICETYPE FROM #INVOICEJOURNALTEMP INVTEMP
			INNER JOIN #INVLIST LST ON LST.[INVOICE NUMBER]=INVTEMP.[INVOICE NUMBER]
			WHERE INVTEMP.INVOICETYPE LIKE '%DIFF%' AND LST.ROWNUM=@CTR1
			
			SELECT @INV=[INVOICE NUMBER],@DIFF=DIFF FROM #INVLIST WHERE ROWNUM=@CTR1

			SET @CTR1+=1
			
			IF (@INVOICETYPE IS NOT NULL) 
			BEGIN --ONLY FIXED PRICE TYPES -START
				SELECT @TYPE_COUNT = COUNT(*) FROM #INVOICEJOURNALTEMP INVTEMP 
				WHERE INVTEMP.INVOICETYPE = @INVOICETYPE AND LA_FLG_CRE_DEB=0 AND INVTEMP.[INVOICE NUMBER]=@INV
				
				IF @TYPE_COUNT=0
				BEGIN
					SET @CD_FLAG=1
					SELECT @TYPE_COUNT = COUNT(*) FROM #INVOICEJOURNALTEMP INVTEMP
					WHERE INVTEMP.INVOICETYPE = @INVOICETYPE AND LA_FLG_CRE_DEB=1 AND INVTEMP.[INVOICE NUMBER]=@INV
				END
		  
				IF @INVOICETYPE IS NOT NULL
				BEGIN

					IF @DIFF <> 0
					BEGIN
						IF @CD_FLAG=0 AND @TYPE_COUNT<>0
						BEGIN
							UPDATE INVTEMP
							SET INVTEMP.[AMOUNT]=INVTEMP.[AMOUNT]+(@DIFF/@TYPE_COUNT)
							FROM #INVOICEJOURNALTEMP INVTEMP
							WHERE INVTEMP.INVOICETYPE = @INVOICETYPE AND LA_FLG_CRE_DEB=0 AND INVTEMP.[INVOICE NUMBER]=@INV
						END
						ELSE
						BEGIN		
							UPDATE INVTEMP
							SET INVTEMP.[AMOUNT]=INVTEMP.[AMOUNT]-(@DIFF/@TYPE_COUNT)
							FROM #INVOICEJOURNALTEMP INVTEMP
							WHERE INVTEMP.INVOICETYPE = @INVOICETYPE AND LA_FLG_CRE_DEB=1 AND INVTEMP.[INVOICE NUMBER]=@INV
						END
					END
				END
			END --END
			ELSE
			BEGIN --ROW 795 START /*ADD NEW BALANCE LINE BASED ON LABOUR OR SPARE PART LINE RECORD*/
				
				IF (ABS(@DIFF)<0.1 AND @DIFF<>0) --CONTINUE IF THERE IS A DIFFERENCE BETWEEN -0.1 AND 0.1
				BEGIN
					IF (@DIFF>0 AND @DIFF<0.10) --POSITIVE DIFFERENCE, FLAG = 0
					BEGIN
						IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV)
						BEGIN
							IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND LA_FLG_CRE_DEB=1 AND [INVOICE NUMBER]=@INV)
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[CREDIT ACCOUNT],[DEBIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	@DIFF,	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',	0,	[INV_NUMBER],	0,	@DIFF,	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],		[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	@DIFF,	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV  
							END
							ELSE
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	@DIFF,	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',	[LA_FLG_CRE_DEB],	[INV_NUMBER],	0,	@DIFF,	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	@DIFF,	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV 
							
							END
						END
						
						ELSE IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV)
						BEGIN
							IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND LA_FLG_CRE_DEB=1 AND [INVOICE NUMBER]=@INV)
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[CREDIT ACCOUNT],[DEBIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	@DIFF,	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',	0,	[INV_NUMBER],	0,	@DIFF,	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],		[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	@DIFF,	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV 
							END
							ELSE
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	@DIFF,	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',	[LA_FLG_CRE_DEB],	[INV_NUMBER],	0,	@DIFF,	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	@DIFF,	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV 
							
							END
						END
						
					END
					ELSE IF (@DIFF<0 AND @DIFF>-0.10) --NEGATIVE DIFFERENCE, FLAG = 1
					BEGIN
						IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV)
						BEGIN
							IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND LA_FLG_CRE_DEB=1 AND [INVOICE NUMBER]=@INV)
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	ABS(@DIFF),	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',		0,			[INV_NUMBER],	0,			ABS(@DIFF),	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	ABS(@DIFF),		[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING'  AND [INVOICE NUMBER]=@INV AND LA_FLG_CRE_DEB=1
							END
							ELSE
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[CREDIT ACCOUNT],	[DEBIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	ABS(@DIFF),	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',		1,			[INV_NUMBER],	ABS(@DIFF),		0,		[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],		[DEBIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	ABS(@DIFF),		[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'LABOUR' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV AND LA_FLG_CRE_DEB=0
							
							END
						END
						
						ELSE IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV)
						BEGIN
							IF EXISTS (SELECT * FROM #INVOICEJOURNALTEMP WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND LA_FLG_CRE_DEB=1 AND [INVOICE NUMBER]=@INV)
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	ABS(@DIFF),	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',		0,			[INV_NUMBER],	0,			ABS(@DIFF),	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	ABS(@DIFF),		[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV AND LA_FLG_CRE_DEB=1
							END
							ELSE
							BEGIN
								INSERT INTO #INVOICEJOURNALTEMP([INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[DEBIT ACCOUNT],	[CREDIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	[AMOUNT],	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	[ACCMATRIXTYPE],	[LA_FLG_CRE_DEB],	[INV_NUMBER],	[CREDIT_AMOUNT],	[DEBIT_AMOUNT],	[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],	[DEBIT ACCOUNT VAT CODE(INVOICE)],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],	[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	[INVOICE AMOUNT 2],	[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2])
								SELECT TOP 1 [INVOICETYPE],	[TRANSACTION TYPE],	[POSTING DATE],	[VOUCHER NUMBER],	[VOUCHER DATE],	[VOUCHER TYPE],	[VOUCHER TEKST],	[DEPARTMENT],	[PROJECT],	[CREDIT ACCOUNT],	[DEBIT ACCOUNT],	[VAT CODE],	[CURRENCY CODE],	[EXCHANGE RATE],	[EXCHANGE AMOUNT],	ABS(@DIFF),	[COUNTERPART ACCOUNT],	[DUE DATE],	[CHAIN NO 1],	[QUANTITY],	[CUSTOMER IDENTIFICATION (CID)],	[TAXCLASSNO],	[SLACCOUNT],	[INVOICE NUMBER],	[REMITTANCE PROFILE NUMBER],	[PRODUCT NO],	[EMPLOYEE NO 1],	[EXTRA1],	[EXTRA2],	[EXTRA3],	[EXTRA4],	[CUSTOMER NO],	[CHAIN NO 2],	[CUSTOMER NAME],	[ADRESS 1],	[ADRESS 2],	[POSTCODE],	[PLACE],	[SKIPALFA],	[TELEPHONE],	[TELEFAX],	[SORTNAME],	[POSTACCOUNT],	[BANKACCOUNT],	[CREDIT LIMIT ON CUSTOMER],	[DELIVERY NAME],	[DEL.ADRESS 1],	[DEL.ADRESS 2],	[DEL. POSTCODE],	[DEL.PLACE],	[EMPLOYEE NO 2],	[DISTRICT NO],	[PAYMENT TERMS],	[SKIPNUM],	[CUSTOMER TYPE],	[DISCOUNTGROUP],	[CUSTOMERPROFILE],	[ACCOUNTNO],	[DEPT_ACCOUNT_NO],	'BALANCE',		1,			[INV_NUMBER],	ABS(@DIFF),		0,		[ACCMATRIXSLNO],	[VOUCHER NUMBER 2],	[VOUCHER TEXT 2],	[INVOICE DATE 2],	[CREDIT ACCOUNT PROJECT CODE],	[CREDIT ACCOUNT VAT CODE(CREDIT LINES)],[CREDIT ACCOUNT VAT CODE(INVOICE)],	[DEBIT ACCOUNT PROJECT CODE],	[DEBIT ACCOUNT VAT CODE(CREDIT LINES)],		[DEBIT ACCOUNT VAT CODE(INVOICE)],	[DUE DATE 2],	ABS(@DIFF),		[LOCATION],	[DEPARTMENT ACCOUNT NO],	[DIMENSION],	[PAYMENT TERMS 2]
								FROM #INVOICEJOURNALTEMP 
										WHERE #INVOICEJOURNALTEMP.INVOICETYPE LIKE 'SPARES' AND ACCMATRIXTYPE='SELLING' AND [INVOICE NUMBER]=@INV  AND LA_FLG_CRE_DEB=0
							
							END
						END
						
					END
				END
			END --BALANCE ISSUE END
		END
END	--BALANCE CHANGES (UPDATED) END		
--ROW 722



	

	SELECT #INVOICEJOURNALERRORTEMP1.[INVOICE NUMBER], CREDITSUM , DEBITSUM, INV_DIFFERENCE,DT_CREATED,CREATED_BY,DT_INVOICE,ID_SUBSIDERY,ID_INV_DEPT,ID_WO_NO,ID_WO_PREFIX 
	INTO #INVOICEJOURNALERRORTEMP
	FROM #INVOICEJOURNALERRORTEMP1 INNER JOIN #ORDERTEMP ON #INVOICEJOURNALERRORTEMP1.[INVOICE NUMBER]=#ORDERTEMP.ID_INV_NO


    IF (SELECT ISNULL(FLG_Exprt_Vald,0) FROM TBL_LA_CONFIG)=0
     BEGIN
	  DELETE FROM #INVOICEJOURNALERRORTEMP 
	  END
		INSERT INTO TBL_LA_ERROR_INVOICE_RECORDS   
		  (
		   TRANSACTION_ID,INVOICE_NUMBER,DT_INVOICE,CREDIT_SUM,DEBIT_SUM,INV_DIFFERENCE,IS_CORRECTED,ID_DEPT_INV,ID_SUBSIDIARY,DT_CREATED,CREATED_BY,ID_WO_NO,ID_WO_PREFIX
		  )
		 SELECT @TRANSRES,[Invoice number],DT_INVOICE, CREDITSUM,  DEBITSUM,[INV_DIFFERENCE],0,ID_SUBSIDERY,ID_INV_DEPT ,DT_CREATED, CREATED_BY ,ID_WO_NO,ID_WO_PREFIX
		 FROM #INVOICEJOURNALERRORTEMP
	
		--now not used
		--UPDATE LAERROR
		--SET IS_CORRECTED = 1
		--FROM TBL_LA_ERROR_INVOICE_RECORDS LAERROR
		--INNER JOIN #INVOICEJOURNALTEMP ITEMP
		--ON LAERROR.INVOICE_NUMBER = ITEMP.INV_NUMBER




/*CHANGE END*/
  
  
 /*Change to separate invoice prefix from series*/
 --UPDATE #INVOICEJOURNALTEMP
 --SET [Voucher number]=INV_SERIES
 --FROM TBL_INV_HEADER
 --WHERE [Voucher number]=ID_INV_NO AND [INVOICETYPE] = ''  
 
 --UPDATE #INVOICEJOURNALTEMP
 --SET [Voucher number]=CN_SERIES
 --FROM TBL_INV_HEADER
 --WHERE [Voucher number]=ID_CN_NO AND [INVOICETYPE] = '' 
 
 --UPDATE #INVOICEJOURNALTEMP
 --SET [Invoice number]=INV_SERIES
 --FROM TBL_INV_HEADER
 --WHERE [Invoice number]=ID_INV_NO 
 
 --UPDATE #INVOICEJOURNALTEMP
 --SET [Invoice number]=CN_SERIES
 --FROM TBL_INV_HEADER
 --WHERE [Invoice number]=ID_CN_NO 
 
 UPDATE #INVOICEJOURNALTEMP
 SET [Invoice number]=dbo.udf_GetNumeric([Invoice number])

 UPDATE #INVOICEJOURNALTEMP
 SET [Voucher number]=dbo.udf_GetNumeric([Voucher number])
 --WHERE [INVOICETYPE] = '' 
 
  UPDATE #INVOICEJOURNALTEMP
 SET [Voucher number 2]=dbo.udf_GetNumeric([Voucher number 2])
 /******Change End******/
 
  DECLARE @FILE_MODE VARCHAR(10)  
  
  SELECT @FILE_MODE = FILE_MODE   
  FROM TBL_MAS_TEMPLATE_CONFIGURATION   
  WHERE TEMPLATE_ID = @TEMPLATE_ID  
  
  DECLARE @UPDATECOLS VARCHAR(MAX)  
  SELECT @UPDATECOLS = COALESCE(@UPDATECOLS + ', ', '') + '['+ FN.FIELD_NAME + '] = ['+ FN.FIELD_NAME + '] / '+ CAST(FC.DECIMAL_DIVIDE AS VARCHAR(6)) + ''  
  FROM TBL_MAS_FIELD_NAMES FN, TBL_MAS_FIELD_CONFIGURATION FC   
  WHERE FN.FIELD_ID = FC.FIELD_ID   
 AND FC.DECIMAL_DIVIDE IS NOT NULL   
 AND FC.DECIMAL_DIVIDE > 0  
 AND FC.TEMPLATE_ID = @TEMPLATE_ID  
  

  IF @UPDATECOLS IS NOT NULL  
  BEGIN
	PRINT 'INSIDE UPDATE COLS'
	DECLARE @UPDATEQUERY AS NVARCHAR(MAX)  
	SET @UPDATEQUERY = N'UPDATE #INVOICEJOURNALTEMP SET ' + @UPDATECOLS + ''  

	SET ANSI_WARNINGS OFF   
	EXECUTE SP_EXECUTESQL @UPDATEQUERY   
	SET ANSI_WARNINGS ON   
  END   
  
  IF @FILE_MODE = 'FIXED'   
	BEGIN  
		PRINT 'INSDE FILE MODE'
	  DECLARE @ALTERCOLS VARCHAR(MAX)  
	  SELECT @ALTERCOLS = COALESCE(@ALTERCOLS + '; ', '') + 'ALTER TABLE #INVOICEJOURNALTEMP ALTER COLUMN ['+ FN.FIELD_NAME + '] CHAR('+ CAST(dbo.FnGetFieldLength(FC.TEMPLATE_ID,FC.FIELD_ID) AS VARCHAR(3))    +')'  
	  FROM TBL_MAS_FIELD_NAMES FN, TBL_MAS_FIELD_CONFIGURATION FC   
	  WHERE FN.FIELD_ID = FC.FIELD_ID  
	   AND FC.TEMPLATE_ID = @TEMPLATE_ID  
	   --AND FN.FIELD_NAME NOT IN ('Posting date', 'Voucher date', 'Due date')  
	  DECLARE @ALTERQUERY AS NVARCHAR(MAX)  
	  SET @ALTERQUERY = N'' + @ALTERCOLS + ''
	  PRINT @ALTERQUERY  
	  
	  SET ANSI_WARNINGS OFF   
	  EXECUTE SP_EXECUTESQL @ALTERQUERY  
	  SET ANSI_WARNINGS ON   
	END  

  DECLARE @PrefixFileName VARCHAR(50)
  DECLARE @InvJournalSeries INT
  DECLARE @SuffixFileName VARCHAR(20)

  SELECT TOP 1 @PrefixFileName = PrefixFileName_Export_InvJournal, 
	@InvJournalSeries = ISNULL(Exp_InvJournal_Cur_Series, Exp_InvJournal_Series), 
	@SuffixFileName = SuffixFileName_Export_InvJournal
  FROM TBL_LA_CONFIG_JOURN_EXPORT_SEQ 
  ORDER BY DT_EFF_FROM DESC 
  
    --select 'FROM #INVOICEJOURNALTEMP', * FROM #INVOICEJOURNALTEMP

  INSERT INTO TBL_LA_INVOICEJOURNAL   
  (   
	 TRANSACTION_TYPE, DT_CREATED, VOUCHER_NUMBER, DT_INVOICE, VOUCHER_TYPE, VOUCHER_TEXT, DEPARTMENT, PROJECT,   
	 DEBIT_ACCOUNT, CREDIT_ACCOUT, VAT_CODE, CURRENCY_CODE, EXCHANGE_RATE, EXCHANGE_AMOUNT, INVL_AMOUNT,   
	 COUNTERPART_ACC, DUE_DATE, CHAIN_NO, QUANTITY, CUSTOMER_ID_KID, TAXCLASSNO, SLACCOUNT, ID_INV_NO, REMITTANCE_NO,   
	 PRODUCT_NO, EMPLOYEE_NO, EXTRA1, EXTRA2, EXTRA3, EXTRA4, CUST_NO, CHAIN_NO2, CUST_NAME, CUST_ADDR1, CUST_ADDR2,   
	 POST_CODE, CUST_PLACE, SKIPALFA, CUST_PHONE, CUST_FAX, SORTNAME, POSTACCOUNT, BANKACCOUNT, CUST_CR_LIMIT,   
	 DELIVERY_NAME, DELIVERY_ADDR1, DELIVERY_ADDR2, DELIVERY_POST_CODE, DELIVERY_PLACE, EMPLOYEE_NO2, DISTRICT_NO,   
	 PAY_TERM, SKIPNO, CUST_TYPE, DISCOUNT_GRP, CUST_PROFILE, INV_TRANSACTIONID, CREATED_BY,   
	 ACCOUNTNO, DEPT_ACCOUNT_NO, ACCMATRIXTYPE, Flg_Cre_deb, INV_NUMBER, [CREDIT_AMOUNT], [DEBIT_AMOUNT],ACCMATRIXSLNO, 
	 PREFIXFILENAME, INVJOURNALSERIES, SUFFIXFILENAME,
	 VOUCHER_NUMBER2,
	 VOUCHER_TEXT2,
	 INVOICE_DATE2,
	 DEBIT_ACCOUNT_PROJECT_CODE,
	 DEBIT_ACCOUNT_VAT_CODE_CREDIT_LINES,
	 DEBIT_ACCOUNT_VAT_CODE_INVOICE,
	 CREDIT_ACCOUNT_PROJECT_CODE,
	 CREDIT_ACCOUNT_VAT_CODE_CREDIT_LINES, 
	 CREDIT_ACCOUNT_VAT_CODE_INVOICE,
	 DUE_DATE2,INVOICE_AMOUNT2,LOCATION,DEPARTMENT_ACCOUNT_NO,DIMENSION,PAYMENT_TERMS2,INVL_ACCCODE
  )   
   SELECT   
	 [Transaction type], CAST([Posting date] AS DATETIME) AS [Posting date], [Voucher number],   
	 CASE WHEN [Voucher date] ='' or [Voucher date] IS NULL THEN '' ELSE [Voucher date] END
	 AS [Voucher date], [Voucher type], [Voucher tekst],DEPT_ACCOUNT_NO, [Project],   
	 
	 CASE WHEN LA_FLG_CRE_DEB=0 THEN [Debit account] ELSE NULL END AS [Debit account], 
	 CASE WHEN LA_FLG_CRE_DEB=1 THEN [Credit account] ELSE NULL END AS [Credit account],
	 
	 [VAT code], [Currency code], [Exchange rate], [Exchange amount], [Amount],   
	 [Counterpart account], [Due date] AS [Due date], [Chain no 1], [Quantity],   
	 [Customer Identification (CID)], [TaxClassNo], [Slaccount], [INV_NUMBER], [Remittance profile number],   
	 [Product no], [Employee no 1], [Extra1], [Extra2], [Extra3], [Extra4], [Customer no], [Chain no 2],   
	 [Customer name], [Adress 1], [Adress 2], [Postcode], [Place], [Skipalfa], [Telephone], [Telefax], [Sortname],   
	 [PostAccount], [BankAccount], [Credit Limit on customer], [Delivery name], [Del.adress 1], [Del.adress 2],   
	 [Del. PostCode], [Del.Place], [Employee no 2], [District no], [Payment Terms], [Skipnum], [Customer Type],   
	 [DiscountGroup], [CustomerProfile], @TRANSRES, 'ADMIN', ACCOUNTNO, [Department] , ACCMATRIXTYPE, LA_FLG_CRE_DEB,   
	 [INV_NUMBER],--[CREDIT_AMOUNT], [DEBIT_AMOUNT],
	 --CASE WHEN LA_FLG_CRE_DEB=0 THEN [Amount] ELSE NULL END AS [Debit amount], 
	 --CASE WHEN LA_FLG_CRE_DEB=1 THEN [Amount] ELSE NULL END AS [Credit amount],
	 CASE WHEN LA_FLG_CRE_DEB=1 THEN [Amount] ELSE NULL END AS [CREDIT_AMOUNT],
	CASE WHEN LA_FLG_CRE_DEB=0 THEN [Amount] ELSE NULL END AS [DEBIT_AMOUNT], 
	 ACCMATRIXSLNO, @PrefixFileName, @InvJournalSeries + 1, @SuffixFileName,
	 [Voucher Number 2],[Voucher Text 2],
    [Invoice Date 2],[Debit Account Project code],[Debit Account Vat Code(Credit Lines)],[Debit Account Vat Code(Invoice)],[Credit Account Project code],[Credit Account Vat Code(Credit Lines)],[Credit Account Vat Code(Invoice)],[Due date 2],[Invoice Amount 2],[Location]
    ,[Department Account No],[Dimension],[Payment terms 2] ,INVOICETYPE
	 
  FROM #INVOICEJOURNALTEMP   
  
  

  DECLARE @FIELDS nvarchar(MAX)  
  
  IF @TEMPLATE_ID = 0  
	 SELECT @FIELDS = COALESCE(@FIELDS + ', ', '') + '['+ CAST(FldN.FIELD_NAME AS varchar(50)) + ']'  -- Increased the fieldname length to 40 from 30 for row-456
	 FROM TBL_MAS_FIELD_NAMES FldN  
	 WHERE FldN.[FILE_NAME] = 'InvoiceJournalExport.aspx'   
	 ORDER BY FldN.FIELD_ORDER   
  ELSE  
	 SELECT @FIELDS = COALESCE(@FIELDS + ', ', '') + '['+ CAST(FldN.FIELD_NAME AS varchar(50)) + ']'  
	 FROM TBL_MAS_FIELD_CONFIGURATION FldC, TBL_MAS_FIELD_NAMES FldN  
	 WHERE FldC.FIELD_ID = FldN.FIELD_ID   
		AND FldC.TEMPLATE_ID = @TEMPLATE_ID   
	 ORDER BY FldC.ORDER_IN_FILE, POSITION_FROM  


  IF EXISTS(SELECT TOP 1 * FROM #INVOICEJOURNALTEMP)  
  BEGIN  
 
	  UPDATE TBL_LA_CONFIG_JOURN_EXPORT_SEQ 
	  SET Exp_InvJournal_Cur_Series = CASE WHEN Exp_InvJournal_Cur_Series IS NULL THEN
										Exp_InvJournal_Series + 1 
									  ELSE
										Exp_InvJournal_Cur_Series + 1
									  END
	  WHERE ID_EXP_SEQ = (SELECT TOP 1 ID_EXP_SEQ FROM TBL_LA_CONFIG_JOURN_EXPORT_SEQ ORDER BY DT_EFF_FROM DESC) 
  
	   INSERT INTO TBL_LA_EXPORTEDFIELDS   
	   (   
		  INV_TRANSACTIONID, CHARACTER_SET, DECIMAL_DELIMITER, THOUSANDS_DELIMITER,   
		  DATE_FORMAT, TIME_FORMAT, DATA_SEPARATOR, EXPORTED_FIELDS   
	   )   
	   SELECT  
		 @TRANSRES, CHARACTER_SET, DECIMAL_DELIMITER, THOUSANDS_DELIMITER,   
		 DATE_FORMAT, TIME_FORMAT,   
	   CASE WHEN UPPER(DELIMITER) = 'OTHERS' THEN  
		 DELIMITER_OTHER  
	   ELSE  
	     DELIMITER  
	   END

  , @FIELDS   
   FROM TBL_MAS_TEMPLATE_CONFIGURATION   
   WHERE TEMPLATE_ID = @TEMPLATE_ID   
  END 


 IF @FILE_MODE <> 'FIXED' 
 BEGIN

  ALTER TABLE #INVOICEJOURNALTEMP ALTER COLUMN [Posting date] VARCHAR(20)  
  ALTER TABLE #INVOICEJOURNALTEMP ALTER COLUMN [Voucher date] VARCHAR(20)  
  ALTER TABLE #INVOICEJOURNALTEMP ALTER COLUMN [Due date] VARCHAR(20)  
  ALTER TABLE #INVOICEJOURNALTEMP ALTER COLUMN [Amount] VARCHAR(20) 
  ALTER TABLE #INVOICEJOURNALTEMP ALTER COLUMN [Invoice Amount 2] VARCHAR(20)
  END
 
 
 

 DECLARE @FLG_BL_SPAC As BIT
 DECLARE @NUM_BL_SPAC AS INT
 DECLARE @CTR AS INT
 SELECT @FLG_BL_SPAC=FLG_BL_SPACS,@NUM_BL_SPAC=BLAN_SPACS FROM  TBL_MAS_TEMPLATE_CONFIGURATION WHERE TEMPLATE_ID = @TEMPLATE_ID
 SET @CTR = 1
 
  select @FIELDS = replace(@FIELDS,'[Debit account]','CASE WHEN LA_FLG_CRE_DEB=0 THEN [Debit account] ELSE NULL END as [Debit account]')
  select @FIELDS = replace(@FIELDS,'[Credit account]','CASE WHEN LA_FLG_CRE_DEB=1 THEN [Credit account]ELSE NULL END as [Credit account]')
  IF @FLG_BL_SPAC = 1  
  BEGIN
	WHILE @CTR<=@NUM_BL_SPAC
		  BEGIN
		    set @FIELDS=@FIELDS+','''' '''+CONVERT(varchar,@ctr)+''''
			set @ctr=@ctr+1
		  END
  END
  


  DECLARE @QUERY AS NVARCHAR(MAX)  
  IF (SELECT TOP 1 Flg_Exp_Sort FROM TBL_LA_CONFIG)=1
  BEGIN
  SET @QUERY = N'SELECT ' + @FIELDS + ' FROM #INVOICEJOURNALTEMP ORDER BY [Invoice number],[INVOICETYPE] '
  END
  ELSE
  BEGIN
  SET @QUERY = N'SELECT ' + @FIELDS + ' FROM #INVOICEJOURNALTEMP' 
  END
  PRINT   @QUERY
  EXECUTE SP_EXECUTESQL @QUERY  
  
  -- CODING TO FETCH THE INVOICE JOURNAL NET                 
  SELECT                           
   DEPT_ACCOUNT_NO, ACCOUNTNO, DIMENSION,                          
   ISNULL(CREDIT_AMOUNT,0) AS CREDIT_AMOUNT ,                
   ISNULL(DEBIT_AMOUNT,0) AS DEBIT_AMOUNT                          
  FROM                           
   #INVOICEJOURNAL                              
  WHERE ACCOUNTNO IS NOT NULL                              
  
  SELECT                           
   DEPT_ACCOUNT_NO, ACCOUNTNO, DIMENSION,                          
   ISNULL(CREDIT_AMOUNT,0) AS CREDIT_AMOUNT,                
   ISNULL(DEBIT_AMOUNT,0) AS DEBIT_AMOUNT                          
  FROM                           
   #INVOICEJOURNAL                              
  WHERE ACCOUNTNO IS NULL                              
  
   --CODING TO SELECT THE INVOICE JOURNAL GROSS               
  SELECT                           
   DEPT_ACCOUNT_NO, ACCOUNTNO, DIMENSION,                          
   SUM(ISNULL(CREDIT_AMOUNT,0)) AS CREDIT_AMOUNT ,                
   SUM(ISNULL(DEBIT_AMOUNT,0))  AS DEBIT_AMOUNT                          
  FROM                    
   #INVOICEJOURNAL                          
  WHERE ACCOUNTNO IS NOT NULL                              
  GROUP BY                           
   DEPT_ACCOUNT_NO,ACCOUNTNO,DIMENSION                     
  
 IF @TEMPLATE_ID = 0   
 SELECT TBLCTRL.CAPTION, TBLLANG.LANG_NAME   
 FROM TBL_MAS_FIELD_NAMES TBLFLD   
 INNER JOIN TBL_ML_SCREEN_DETAILS TBLSCR ON TBLFLD.[FILE_NAME] = TBLSCR.SCRN_NAME AND   
   TBLFLD.CONTROL_ID = TBLSCR.CNTRLNAME   
  INNER JOIN TBL_ML_CTRL_DETAILS TBLCTRL ON TBLSCR.ID_SCRNO = TBLCTRL.ID_SCRNO   
  INNER JOIN TBL_MAS_LANGUAGE TBLLANG ON TBLLANG.ID_LANG = TBLCTRL.ID_LANG   
 WHERE TBLFLD.[FILE_NAME] = 'InvoiceJournalExport.aspx'   
 ORDER BY TBLFLD.FIELD_ORDER   
  ELSE  
 SELECT TBLCTRL.CAPTION, TBLLANG.LANG_NAME   
 FROM TBL_MAS_FIELD_NAMES TBLFLD   
  INNER JOIN TBL_MAS_FIELD_CONFIGURATION TBLFLDCON ON TBLFLD.FIELD_ID = TBLFLDCON.FIELD_ID   
  INNER JOIN TBL_ML_SCREEN_DETAILS TBLSCR ON TBLFLD.[FILE_NAME] = TBLSCR.SCRN_NAME AND   
   TBLFLD.CONTROL_ID = TBLSCR.CNTRLNAME   
  INNER JOIN TBL_ML_CTRL_DETAILS TBLCTRL ON TBLSCR.ID_SCRNO = TBLCTRL.ID_SCRNO   
  INNER JOIN TBL_MAS_LANGUAGE TBLLANG ON TBLLANG.ID_LANG = TBLCTRL.ID_LANG   
 WHERE TBLFLDCON.TEMPLATE_ID = @TEMPLATE_ID   
 ORDER BY TBLFLDCON.ORDER_IN_FILE, TBLFLDCON.POSITION_FROM   
  
 SELECT * FROM #INVOICEJOURNAL 
 SELECT * FROM #INVOICEJOURNALERRORTEMP
  
	DROP TABLE #INVOICEJOURNAL   
	DROP TABLE #INVOICEJOURNALTEMP
	DROP TABLE #INVOICEJOURNALERRORTEMP  
	DROP TABLE #INVOICEJOURNALERRORTEMP1
	DROP TABLE #ORDERTEMP
	DROP TABLE #INVOICEJOURNALTEMP2  
	DROP TABLE #INVLIST
	DROP TABLE #INVDIFF
      
END TRY                
 BEGIN CATCH                
  SELECT                                          
   ERROR_NUMBER() AS ERRORNUMBER,                                          
   ERROR_MESSAGE() AS ERRORMESSAGE;                
 END CATCH                
END

GO

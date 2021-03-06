/****** Object:  StoredProcedure [dbo].[USP_IN_CREATEINV_INSERT]    Script Date: 1/8/2018 1:29:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_CREATEINV_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_IN_CREATEINV_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_IN_CREATEINV_INSERT]    Script Date: 1/8/2018 1:29:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_CREATEINV_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_IN_CREATEINV_INSERT] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                                                              
* Module :                                                               
* File name : USP_IN_CREATEINV_INSERT                                                              
* Purpose   : To create invoice                        
* Author    : JAYAKRISHNAN                                                              
* Date      : 17:11:2006                                                           
*********************************************************************************************************************/                                                              
/*********************************************************************************************************************                                                                
I/P : -- Input Parameters                                                              
O/P :-- Output Parameters                                                              
Error Code                                                              
Description                                                              
INT.VerNO : NOV21.0                                                              
********************************************************************************************************************/                                                              
--''*********************************************************************************''*********************************                                                              
--''* Modified History :                                                                 
--''* S.No  RFC No/Bug ID   Date          Author                 Description                                                               
--*#0001#                                                 
--*#0001#                   31-Mar-2008  Supreetha N     bug_id 1541                           
--*#0002#                   23-Mar-2009  Manoj K             Modified to avoid fetching the records status as [DEL].                        
--''*********************************************************************************''*********************************                                                             
                            
------------------------------------------------------                                  
--Author :                                  
--Modified Date :                                  
--Description:Fixed bug_id 1541                                  
------------------------------------------------------                             
------------------------------------------------------                                  
--Author :  Smita                                
--Modified Date : 1/07/13                               
--Description:Row 631 -Invoice prefis issue                                 
------------------------------------------------------                              
                        
------------------------------------------------------                                  
--Author :  Praveen                                 
--Modified Date : 29/07/13                               
--Description:Row 636 - Duplicate invoice spare parts detail records incase of non-batch scenario                        
--         Added condition to temp table @TEMP_TBL_INV_HEADER to avoid duplicate records                                
------------------------------------------------------                               
                                  
ALTER PROCEDURE [dbo].[USP_IN_CREATEINV_INSERT]                                   
(                                  
 @IV_XMLDOC NTEXT,                                   
 @IV_CREATEDBY VARCHAR(20),                                  
 @OV_RETVALUE VARCHAR(10)OUTPUT,                                  
 @OV_INVLIST VARCHAR(7000) OUTPUT,                           
 @ID_WO_NOTINV VARCHAR(7000) OUTPUT,                        
 @OV_INVLIST_INTM VARCHAR(7000) OUTPUT                           
)                         
AS                                  
BEGIN                                   
DECLARE @NEW_GUID AS VARCHAR(MAX)                        
SET @NEW_GUID = NEWID()                        
                        
INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start CreateINV',getdate(),1,@NEW_GUID)                        
                   
 DECLARE @IDOC AS INT                                   
 DECLARE @RET_MESSAGE AS VARCHAR(10)                                  
DECLARE @COUNT_WARN AS INT                                  
 DECLARE @COUNT_OFL AS INT                         
 DECLARE @COUNT_ORD AS INT                   
                        
                                  
 CREATE TABLE #TEMPNOTINV                           
 (                          
  ID_NOTINV INT IDENTITY(1,1) NOT NULL,                    
  ID_WO_NOTINV VARCHAR(13)                          
 )                          
                                  
 DECLARE @JOB_DEB_LIST TABLE                                  
 (                                  
  ID_WO_NO VARCHAR(10),                                  
  ID_WO_PREFIX VARCHAR(3),                                  
  ID_WODET_SEQ INT,                                  
  ID_JOB_DEB VARCHAR(10),                                  
  FLG_BATCH BIT ,                            
  -- Modified Date: 24th march 2010                        
  -- Bug ID     : 45 issue in pending issues                               
  --IV_DATE DATETIME                         
  IV_DATE VARCHAR(10) ,                        
  ID_CUST_GRP INT                                 
 )                                   
 EXEC SP_XML_PREPAREDOCUMENT @IDOC OUTPUT,@IV_XMLDOC                                  
INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert JobDebList',getdate(),2,@NEW_GUID)                                   
 INSERT INTO @JOB_DEB_LIST                                   
 SELECT                                   
  ID_WO_NO ,                                  
  ID_WO_PREFIX ,                                  
  ID_WODET_SEQ ,                                  
  ID_JOB_DEB ,                                  
  FLG_BATCH ,                                  
  IV_DATE ,                        
  0                                 
 FROM                                   
  OPENXML(@IDOC,'ROOT/INV_GENERATE',1)                                   
  WITH                                   
  (                                  
   ID_WO_NO VARCHAR(10),                                  
   ID_WO_PREFIX VARCHAR(3),                                  
   ID_WODET_SEQ INT,                                  
   ID_JOB_DEB VARCHAR(10),                                   
   FLG_BATCH BIT,                                     
   IV_DATE VARCHAR(10)                                  
  )                                   
                                   
 EXEC SP_XML_REMOVEDOCUMENT @IDOC                          
                         
 /***CHANGES TO REMOVE ANY ORDERS IN THE JOB LIST FOR WHICH ACTIVE INVOICES ALREADY EXIST***/                        
 --select '@JOB_DEB_LIST',* from @JOB_DEB_LIST                        
                         
 select ID_WO_NO,ID_WO_PREFIX,ID_WODET_SEQ,ID_JOB_DEB,FLG_BATCH,IV_DATE,ID_CUST_GRP into #JOBLIST2 from @JOB_DEB_LIST B                         
   where (SELECT COUNT (*) AS ID_CN_NO from TBL_INV_HEADER INH INNER JOIN TBL_INV_DETAIL IND                        
  ON INH.ID_INV_NO = IND.ID_INV_NO                        
  INNER JOIN TBL_WO_DETAIL WOD                        
  ON WOD.ID_WO_NO = IND.ID_WO_NO AND WOD.ID_WO_PREFIX = IND.ID_WO_PREFIX AND WOD.ID_JOB = IND.id_job and WOD.ID_WODET_SEQ=B.ID_WODET_SEQ                        
  INNER JOIN TBL_WO_DEBITOR_DETAIL WDD                        
  ON WDD.ID_JOB_DEB =INH.ID_DEBITOR AND WOD.ID_WO_NO = WDD.ID_WO_NO AND WOD.ID_WO_PREFIX = WDD.ID_WO_PREFIX AND WOD.ID_JOB = WDD.ID_JOB_ID                        
  WHERE WDD.ID_WO_NO = B.ID_WO_NO AND WDD.ID_WO_PREFIX =B.ID_WO_PREFIX                         
   AND WDD.ID_JOB_ID=WOD.ID_JOB AND WDD.ID_JOB_DEB = B.ID_JOB_DEB AND ID_CN_NO IS NULL) = 0                                    
                         
 --select '#JOB_DEB_LIST',* from #joblist2                        
 --Double Invoicing issue        
 DECLARE @CNTDEB AS INT                        
 SELECT @CNTDEB = COUNT(*) FROM @JOB_DEB_LIST                        
                         
 DELETE FROM @JOB_DEB_LIST                        
 INSERT INTO @JOB_DEB_LIST SELECT ID_WO_NO,ID_WO_PREFIX,ID_WODET_SEQ,ID_JOB_DEB,FLG_BATCH,IV_DATE,ID_CUST_GRP from #joblist2                        
                         
 IF ((SELECT COUNT(*) FROM #JOBLIST2) = 0)                         
  BEGIN                        
   SET @COUNT_ORD = -1                        
  END                         
 ELSE IF ((@CNTDEB) = (SELECT COUNT(*) FROM #JOBLIST2))                         
  BEGIN                        
   SET @COUNT_ORD = 1                        
  END                        
  ELSE                        
  BEGIN                        
   SET @COUNT_ORD = 0                        
  END                         
                         
                         
 DROP TABLE #JOBLIST2                        
                         
                         
--select '@JOB_DEB_LIST2',* from @JOB_DEB_LIST                        
 /***CHANGE END***/                        
                        
 UPDATE  @JOB_DEB_LIST SET ID_CUST_GRP = CUST.ID_CUST_GROUP                        
 FROM TBL_MAS_CUSTOMER CUST WHERE ID_JOB_DEB = CUST.ID_CUSTOMER                        
                        
 UPDATE @JOB_DEB_LIST SET ID_CUST_GRP = HEADER.WO_CUST_GROUPID                        
 FROM TBL_WO_HEADER HEADER ,@JOB_DEB_LIST T , TBL_WO_DETAIL DET WHERE ID_JOB_DEB = HEADER.ID_CUST_WO                        
 AND T.ID_WO_NO = HEADER.ID_WO_NO AND T.ID_WO_PREFIX = HEADER.ID_WO_PREFIX                        
AND DET.ID_WODET_SEQ = T.ID_WODET_SEQ AND  DET.ID_WO_NO = T.ID_WO_NO AND                         
 DET.ID_WO_PREFIX = T.ID_WO_PREFIX                        
                         
 SELECT ID_JOB_DEB,FLG_BATCH,ID_CUST_GRP INTO #CASHCUST FROM @JOB_DEB_LIST WHERE ID_CUST_GRP IN (SELECT ID_CUST_GRP_SEQ FROM TBL_MAS_CUST_GROUP WHERE ID_PAY_TERM IN (SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS WHERE TERMS=0)) AND FLG_BATCH=1              
          
           
 SELECT Rank() over (Partition BY ID_JOB_DEB ORDER BY ID_WO_NO, ID_WO_PREFIX, ID_WODET_SEQ DESC ) AS RANK,ID_WO_NO, ID_WO_PREFIX, ID_WODET_SEQ,                        
  ID_JOB_DEB,FLG_BATCH,ID_CUST_GRP INTO #CREDITCUST FROM @JOB_DEB_LIST WHERE ID_CUST_GRP IN (SELECT ID_CUST_GRP_SEQ FROM TBL_MAS_CUST_GROUP WHERE ID_PAY_TERM IN (SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS WHERE TERMS<>0)) AND FLG_BATCH=1                 
  
    
      
       
                        
--SELECT * FROM #CASHCUST                        
--SELECT * FROM #CREDITCUST                        
--ID_WO_NO ID_WO_PREFIX ID_WODET_SEQ                        
                        
SELECT DISTINCT CD.ID_JOB_DEB,CD.FLG_BATCH,CD.ID_CUST_GRP INTO #UPDCUST FROM #CASHCUST CS                        
INNER JOIN #CREDITCUST CD ON CS.ID_JOB_DEB=CD.ID_JOB_DEB                         
AND CD.FLG_BATCH=1 AND CD.RANK=1                        
                        
--SELECT * FROM #UPDCUST                        
                        
UPDATE JD SET ID_CUST_GRP=UD.ID_CUST_GRP                        
FROM @JOB_DEB_LIST JD,#UPDCUST UD, #CASHCUST CS                        
WHERE JD.ID_JOB_DEB =UD.ID_JOB_DEB AND JD.FLG_BATCH=1 AND                         
JD.ID_JOB_DEB =CS.ID_JOB_DEB AND JD.ID_CUST_GRP=CS.ID_CUST_GRP                        
                        
                        
                        
DROP TABLE #CASHCUST                        
DROP TABLE #CREDITCUST                        
DROP TABLE #UPDCUST                        
                         
INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert JobDebList',getdate(),2,@NEW_GUID)                                    
 --SELECT * FROM @JOB_DEB_LIST                        
                                 
 --Block1: End                                  
 --select * into ##JOB_DEB_LIST from @JOB_DEB_LIST                                  
                                   
  --Coding test 1                                  
 -- print '##JOB_DEB_LIST'                                  
  -- select * into ##JOB_DEB_LIST from @JOB_DEB_LIST                                  
                                   
 --Coding to check if the count is equal to pay type                                  
  --First Check how many pay types are available in                                   
                                  
 DECLARE @ROWPAYTYPE AS INT                                  
 SET @ROWPAYTYPE = 0                                  
                                   
 --Block2: Dont know why this logic is checked..                                  
 SELECT @ROWPAYTYPE = COUNT(*)                               
 FROM TBL_MAS_SETTINGS                                   
 WHERE ID_CONFIG = 'PAYTYPE'                                  
                                   
                                   
                                    
 Declare @Actualcount as int                                  
 set @Actualcount = 0                                  
 SELECT @Actualcount = count(*)                                  
 FROM TBL_MAS_INV_CONFIGURATION                             
 WHERE DT_EFF_TO IS NULL                                   
  AND ID_SUBSIDERY_INV IN (                        
   SELECT DISTINCT(ID_SUBSIDERY)                                  
   FROM TBL_WO_HEADER                                   
   WHERE ID_WO_NO IN (SELECT ID_WO_NO FROM @JOB_DEB_LIST )                                  
  )                                   
  AND ID_DEPT_INV IN (                        
   SELECT DISTINCT(ID_DEPT)              
   FROM TBL_WO_HEADER                         
   WHERE ID_WO_NO IN (SELECT ID_WO_NO FROM @JOB_DEB_LIST )                                  
  )                                  
                                   
 Declare @DepCount as int                                  
 set @DepCount = 0;                                  
 SELECT @DepCount = COUNT(*)                                   
 FROM TBL_MAS_INV_NUMBER_CFG                                  
 WHERE ID_INV_CONFIG IN (                        
  SELECT ID_INV_CONFIG               
  FROM TBL_MAS_INV_CONFIGURATION                                   
  WHERE DT_EFF_TO IS NULL                                   
   AND ID_SUBSIDERY_INV IN (                        
    SELECT DISTINCT(ID_SUBSIDERY)                        
    FROM TBL_WO_HEADER                                   
    WHERE ID_WO_NO IN (                        
     SELECT ID_WO_NO FROM @JOB_DEB_LIST                         
    )                                  
   )                                   
   AND  ID_DEPT_INV IN (                        
    SELECT DISTINCT(ID_DEPT)                                  
    FROM TBL_WO_HEADER                         
    WHERE ID_WO_NO IN (                        
       SELECT ID_WO_NO FROM @JOB_DEB_LIST                        
    )                                   
   )                                  
  )                                   
                                   
                                   
 IF ((@ACTUALCOUNT * @DEPCOUNT) >= @ROWPAYTYPE)                                 
 BEGIN                                  
  PRINT 'VALID'                                  
 END                                   
 ELSE                                  
 BEGIN                              
                          
  IF (@COUNT_ORD <> -1)                          
  BEGIN            
   --print @ACTUALCOUNT                                  
   --print @DEPCOUNT                                  
   --print @ROWPAYTYPE                                  
   --print 'test3'                                   
   SET @OV_RETVALUE = 'INVWRNPAY'                        
   RETURN                        
  END                                       
 END                                  
 --Block2: End                         
 DECLARE @FLG TABLE(FLAG_BATCH BIT)                        
 INSERT INTO @FLG                        
 SELECT FLG_BATCH FROM @JOB_DEB_LIST                         
                         
                             
                        
                             
 --Changed as per row-136                        
    DECLARE @WO_TOT_SPARE_AMT TABLE(ID_WO_NO VARCHAR(10), ID_WO_PREFIX VARCHAR(3),ID_DEBITOR INT, WO_TOT_SPAREAMT INT,FLG_BATCH BIT)                        
 INSERT INTO @WO_TOT_SPARE_AMT                        
 SELECT DISTINCT WDD.ID_WO_NO, WDD.ID_WO_PREFIX ,WDD.ID_JOB_DEB,SUM(WDD.DBT_AMT),JDBL.FLG_BATCH FROM TBL_WO_DEBITOR_DETAIL WDD                     
 INNER JOIN TBL_WO_DETAIL WOD                        
 on WDD.ID_WO_NO = WOD.ID_WO_NO AND WDD.ID_WO_PREFIX =WOD.ID_WO_PREFIX AND WDD.ID_JOB_ID = WOD.ID_JOB                        
 INNER JOIN @JOB_DEB_LIST JDBL                        
 ON WDD.ID_WO_NO = JDBL.ID_WO_NO AND WDD.ID_WO_PREFIX = JDBL.ID_WO_PREFIX                         
 AND WDD.ID_JOB_DEB = JDBL.ID_JOB_DEB and WOD.ID_WODET_SEQ=JDBL.ID_WODET_SEQ                        
 GROUP BY WDD.ID_WO_NO, WDD.ID_WO_PREFIX,WDD.ID_JOB_DEB,JDBL.FLG_BATCH                         
                        
                        
            
 UPDATE @WO_TOT_SPARE_AMT                        
 SET WO_TOT_SPAREAMT =  Q.TOT                        
 FROM (                        
 SELECT SUM (WT.WO_TOT_SPAREAMT) AS TOT                        
 ,WT.ID_DEBITOR AS DEBITOR                        
 --, WT.ID_WO_NO,WT.ID_WO_PREFIX                             
 FROM @WO_TOT_SPARE_AMT WT INNER JOIN @WO_TOT_SPARE_AMT WTT                        
 ON WTT.ID_DEBITOR = WT.ID_DEBITOR AND WT.ID_WO_NO =WTT.ID_WO_NO AND WT.ID_WO_PREFIX =WTT.ID_WO_PREFIX                        
 AND WT.FLG_BATCH = 1                        
 GROUP BY WT.ID_DEBITOR                        
 )Q                        
 WHERE FLG_BATCH = 1 AND Q.DEBITOR =ID_DEBITOR                        
                         
                        
                         
 --Added for batch customer  for the same debitor-319                        
 DECLARE @WOTEST TABLE(ID_DEBITOR INT, WO_TOT_SPAREAMT INT)                        
 INSERT INTO @WOTEST                        
 SELECT DISTINCT ID_DEBITOR,WO_TOT_SPAREAMT FROM @WO_TOT_SPARE_AMT WHERE FLG_BATCH = 1                        
                         
 --Added for nonbatch customer  for the same debitor-319                        
 DECLARE @WOTESTNB TABLE(ID_WO_NO VARCHAR(10), ID_WO_PREFIX VARCHAR(3),ID_DEBITOR INT, WO_TOT_SPAREAMT INT)                        
 INSERT INTO @WOTESTNB                        
 SELECT ID_WO_NO,ID_WO_PREFIX,ID_DEBITOR ,WO_TOT_SPAREAMT FROM  @WO_TOT_SPARE_AMT WHERE FLG_BATCH = 0                        
                         
                         
                         
    --End of Change                             
                         
                        
                         
 DECLARE @TRANNAME VARCHAR(20);                                   
 SELECT @TRANNAME = 'INVOICE_INSERT'                                   
 BEGIN TRANSACTION @TRANNAME                                   
 --CREATE TEMP TABLE AND STORE ACCORDING TO THE INVOICE TBL_WO_HEADER FORMAT                                   
 DECLARE @INVOICETEMP TABLE                                   
 (                                
  ID_WO_NO VARCHAR(10),   ID_WO_PREFIX VARCHAR(3),                                  
  ID_WODET_SEQ INT,    ID_INV_NO VARCHAR(10),                                  
  ID_DEPT_INV INT,     ID_SUBSIDERY_INV INT,                                  
  DT_INVOICE DATETIME,    DEBITOR_TYPE CHAR(1),                                  
  ID_DEBITOR VARCHAR(10),   INV_AMT DECIMAL,                                  
  INV_KID VARCHAR(25),   ID_CN_NO VARCHAR(15),                                  
  FLG_BATCH_INV BIT, FLG_TRANS_TO_ACC BIT,                                  
  CREATED_BY VARCHAR(20),   DT_CREATED DATETIME,                                  
  INVPREFIX VARCHAR(10),   INVSERIES VARCHAR(7),                                   
  INVMAXNUM INT, INVWARNLEV INT,                                   
  WARN BIT,       OVERFLOW BIT,                                  
  WO_VEH_REG_NO VARCHAR(15),  WO_JOB_TXT TEXT,                                  
  WO_CUST_PERM_ADD1 VARCHAR(50), WO_CUST_PERM_ADD2 VARCHAR(50),                                  
  WO_CUST_NAME VARCHAR(100),                        
  WO_VEH_HRS DECIMAL(9,2),                        
  ID_JOB INT ,INVSEQ INT,                        
  TRANSFERREDVAT decimal(13,2),                        
  TRANSFERREDFROMCUSTID varchar(50),                        
  TRANSFERREDFROMCUSTName varchar(50),                        
  VATAMOUNT decimal(13,2),                        
  DEB_VAT_PER decimal(6,3)                         
                           
 )                        
                         
 --INSERT INTO THE TEMP TABLE@INVOICE TEMP                                  
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @INVOICETEMP',getdate(),3,@NEW_GUID)                                   
 INSERT INTO @INVOICETEMP                                  
 SELECT                               
  TEMP.ID_WO_NO ,                                  
  TEMP.ID_WO_PREFIX,                                  
  TEMP.ID_WODET_SEQ,                                  
  '' ,                                   
  WOHEADER.ID_DEPT,                                   
  WOHEADER.ID_SUBSIDERY,                                   
  CASE WHEN ((TEMP.IV_DATE is null) or (TEMP.IV_DATE = '')) THEN                        
   CONVERT(VARCHAR(10),GETDATE(),101)                                  
  ELSE                                  
   CONVERT(VARCHAR(10),TEMP.IV_DATE,101)                                     
  END,                                  
  ISNULL(DEBITOR_TYPE,'N') ,-- DEBITOR TYPE                                  
  ISNULL(WODEBDET.ID_JOB_DEB,0), -- ID DEBITOR                          
  NULL, --INVOICE AMOUNT                                  
  1, -- INVOICE KI                                   
  NULL, -- INVOICE CN NO                                   
  TEMP.FLG_BATCH, -- FLAG BATCH INVOICE                                  
  NULL, --FLAG TRANS ID NO                                   
  @IV_CREATEDBY, -- CREATED BY                                  
  GETDATE(),-- CREATED DATE                                  
  CASE WHEN WOHEADER.ID_DEPT IS NOT NULL AND WOHEADER.ID_SUBSIDERY IS NOT NULL THEN                        
   CASE WHEN TEMP.FLG_BATCH = 'TRUE' THEN                        
   CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN                          
   (SELECT INV_PREFIX                                   
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                           
      WHERE ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) --(                        
      AND ID_INV_CONFIG = (SELECT ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery                         
       AND ID_DEPT_INV=WOHEADER.ID_Dept                                         
       AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                         
                         
  ELSE            
  CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
 (SELECT INV_PREFIX                                   
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                           
      WHERE ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                       
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) --(                                             
      AND ID_INV_CONFIG = (SELECT ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery                         
       AND ID_DEPT_INV=WOHEADER.ID_Dept                                         
       AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                
  ELSE                        
     (SELECT INV_PREFIX                                   
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                           
      WHERE ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) --(                                             
      AND ID_INV_CONFIG = (SELECT ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery                         
       AND ID_DEPT_INV=WOHEADER.ID_Dept                                         
       AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                          
   END           
 END                          
  ELSE                        
                          
   CASE WHEN  WSPP.WO_TOT_SPAREAMT < 0 THEN                          
   (SELECT INV_PREFIX                    
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                           
      WHERE ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) --(                                             
      AND ID_INV_CONFIG = (SELECT ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                               
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery                         
       AND ID_DEPT_INV=WOHEADER.ID_Dept                                         
       AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                         
                        
  ELSE             
  CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
  (SELECT INV_PREFIX                    
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                           
      WHERE ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                              
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) --(                                             
      AND ID_INV_CONFIG = (SELECT ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery                         
       AND ID_DEPT_INV=WOHEADER.ID_Dept                                         
       AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))             
  ELSE                       
     (SELECT INV_PREFIX                        
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                           
      WHERE ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) --(                                             
      AND ID_INV_CONFIG = (SELECT ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery                         
       AND ID_DEPT_INV=WOHEADER.ID_Dept                         
    AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE()))))                          
   END                        
                          
  END                        
                           
  END                      
  ELSE                         
   'NO VALUE'                                  
  END AS 'PREFIX', -- PREFIX                           
                           
  CASE WHEN WOHEADER.ID_DEPT IS NOT NULL AND WOHEADER.ID_SUBSIDERY IS NOT NULL THEN                         
  CASE WHEN TEMP.FLG_BATCH = 'TRUE' THEN                        
  CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN                        
   (SELECT ISNULL(INV_STARTNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES =(SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                     
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                   
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                  
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))) )                        
                                
  ELSE             
  CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
 (SELECT ISNULL(INV_STARTNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES =(SELECT top 1 INV_CRENOSEREIES                             
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                  
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                   
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                  
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))) )            
  ELSE                        
  (SELECT ISNULL(INV_STARTNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                  
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                 
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                  
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) )))                        
  END                        
 END                         
  ELSE                        
  CASE WHEN  WSPP.WO_TOT_SPAREAMT < 0 THEN                        
   (SELECT ISNULL(INV_STARTNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES =(SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                  
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                   
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                  
        FROM TBL_MAS_SETTINGS                                  
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))) )                        
                                
  ELSE             
  CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
  (SELECT ISNULL(INV_STARTNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES =(SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                  
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY               
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                   
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                  
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))) )              
  ELSE                        
  (SELECT ISNULL(INV_STARTNO,0)               
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                  
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                   
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                  
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ) )))                       
  END                        
  END                        
 END                         
  ELSE                         
   'NO VALUE'                                  
  END AS 'SERIES',-- SERIES,                                          
  CASE WHEN WOHEADER.ID_DEPT IS NOT NULL AND WOHEADER.ID_SUBSIDERY IS NOT NULL THEN                         
  CASE WHEN TEMP.FLG_BATCH = 'TRUE' THEN                        
  CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN                        
   (SELECT ISNULL(INV_ENDNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                      
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))           
  ELSE             
    CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
  (SELECT ISNULL(INV_ENDNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                      
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                      
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))             
   ELSE                     
  (SELECT ISNULL(INV_ENDNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                  
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                         
   END             
  END                       
   ELSE                        
   CASE WHEN  WSPP.WO_TOT_SPAREAMT < 0 THEN                        
   (SELECT ISNULL(INV_ENDNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                        
  ELSE            
  CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
 (SELECT ISNULL(INV_ENDNO,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))               
  ELSE                        
  (SELECT ISNULL(INV_ENDNO,0)         
    FROM TBL_MAS_INV_PAYMENT_SERIES                                  
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
 FROM TBL_MAS_INV_CONFIGURATION                                   
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT)                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                  
       FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                         
   END                        
                           
   END                                  END                                       
  ELSE                         
   0                                  
  END AS 'INVMAXNUM',-- INVMAXNUM,                                  
  CASE WHEN WOHEADER.ID_DEPT IS NOT NULL AND WOHEADER.ID_SUBSIDERY IS NOT NULL THEN                        
  CASE WHEN TEMP.FLG_BATCH = 'TRUE' THEN                        
  CASE WHEN WSP.WO_TOT_SPAREAMT < 0 THEN                         
   (SELECT ISNULL(INV_WARNINGBEFORE,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT )                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                   
        FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                          
  ELSE            
  CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
  (SELECT ISNULL(INV_WARNINGBEFORE,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT )                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                   
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))            
  ELSE                        
  (SELECT ISNULL(INV_WARNINGBEFORE,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT )                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                   
 FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                              
  END             
 END                        
  ELSE                        
  CASE WHEN WSPP.WO_TOT_SPAREAMT < 0 THEN                         
   (SELECT ISNULL(INV_WARNINGBEFORE,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES             
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT )                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                   
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                     
              
   ELSE             
   CASE WHEN WOHEADER.WO_TYPE_WOH = 'KRE' THEN            
  (SELECT ISNULL(INV_WARNINGBEFORE,0)                                  
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_CRENOSEREIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT )                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                   
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))            
   ELSE                       
  (SELECT ISNULL(INV_WARNINGBEFORE,0)                         
    FROM TBL_MAS_INV_PAYMENT_SERIES                                   
    WHERE ID_PAYSERIES = (SELECT top 1 INV_INVNOSERIES                                   
      FROM TBL_MAS_INV_NUMBER_CFG                                   
      WHERE ID_INV_CONFIG = (SELECT top 1 ID_INV_CONFIG                                   
       FROM TBL_MAS_INV_CONFIGURATION                                  
       WHERE DT_EFF_TO IS NULL                         
       AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY                         
       AND ID_DEPT_INV = WOHEADER.ID_DEPT )                                  
       AND ID_SETTINGS = (SELECT top 1 ID_SETTINGS                                   
        FROM TBL_MAS_SETTINGS                                   
        WHERE ID_CONFIG = 'PAYTYPE'                                   
        AND ID_SETTINGS = (SELECT top 1 CUSTGRP.ID_PAY_TYPE                                   
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                                  
         WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_JOB_DEB,0)                                  
         AND TEMP.ID_CUST_GRP = CUSTGRP.ID_CUST_GRP_SEQ))))                              
  END                         
  END             
 END                             
                                         
  ELSE                         
   0                                  
  END AS 'INVWARNLEV',-- INV WARNING LEVEL,                                      
  'FALSE',                                  
  'FALSE',                         
  WOHEADER.WO_VEH_REG_NO,                                  
  WODET.WO_JOB_TXT,                         
  CASE WHEN (TEMP.ID_JOB_DEB = CUST.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = WOHEADER.ID_Dept and ID_SUBSIDERY_WO=WOHEADER.ID_Subsidery and DT_EFF_TO>=GETDATE()) = 0)  THEN                     
  
   
  ISNULL(CUST.CUST_PERM_ADD1,'')                         
    ELSE                        
   ISNULL(CUST.CUST_BILL_ADD1,'')                         
    END ,                        
  CASE WHEN (TEMP.ID_JOB_DEB = CUST.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = WOHEADER.ID_Dept and ID_SUBSIDERY_WO=WOHEADER.ID_Subsidery and DT_EFF_TO>=GETDATE()) = 0)  THEN             
   ISNULL(CUST.CUST_PERM_ADD2,'')                         
    ELSE                        
   ISNULL(CUST.CUST_BILL_ADD2,'')                         
    END,                        
  CASE WHEN WOHEADER.ID_CUST_WO = TEMP.ID_JOB_DEB THEN                        
    WOHEADER.WO_CUST_NAME                        
  ELSE                        
   CUST.CUST_NAME                        
  END ,                        
  WOHEADER.WO_VEH_HRS,                        
  WODET.ID_JOB ,                        
  --ROW_NUMBER() OVER(ORDER BY WODET.ID_JOB )AS ID_JOB                         
  CAST(ROW_NUMBER() OVER(PARTITION BY WODET.ID_WO_NO, WODET.ID_WO_PREFIX, WODEBDET.ID_JOB_DEB ORDER BY WODEBDET.ID_JOB_DEB DESC) AS VARCHAR),                        
  0,--CASE WHEN WODEBDET.ID_JOB_DEB = WODET.WO_OWN_CR_CUST THEN WODEBDET.TRANSFERREDVAT ELSE -1 * WODEBDET.TRANSFERREDVAT END AS 'TRANSFERREDVAT',                        
  0,--WODEBDET.TRANSFERREDFROMCUSTID,                        
  0,--WODEBDET.TRANSFERREDFROMCUSTName,                        
  0,--WODEBDET.JOB_VAT_AMOUNT,                        
  WODEBDET.DEBTOR_VAT_PERCENTAGE                        
 FROM @JOB_DEB_LIST TEMP                          
 INNER JOIN TBL_WO_DETAIL WODET                         
  ON TEMP.ID_WO_NO= WODET.ID_WO_NO                         
  AND TEMP.ID_WO_PREFIX = WODET.ID_WO_PREFIX                         
  AND TEMP.ID_WODET_SEQ = WODET.ID_WODET_SEQ                                   
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEBDET                                  
  ON WODET.ID_WO_NO = WODEBDET.ID_WO_NO                         
  AND WODET.ID_WO_PREFIX = WODEBDET.ID_WO_PREFIX                  
  AND WODET.ID_JOB= WODEBDET.ID_JOB_ID                         
  AND WODEBDET.ID_JOB_DEB= TEMP.ID_JOB_DEB                                   
 INNER JOIN TBL_WO_HEADER WOHEADER                                  
  ON WODEBDET.ID_WO_NO = WOHEADER.ID_WO_NO                         
  AND WODEBDET.ID_WO_PREFIX = WOHEADER.ID_WO_PREFIX                         
 INNER JOIN TBL_MAS_CUSTOMER CUST                         
  ON CUST.ID_CUSTOMER=TEMP.ID_JOB_DEB                         
   LEFT OUTER JOIN @WOTEST WSP                        
  --ON WSP.ID_WO_NO = TEMP.ID_WO_NO                         
  --AND WSP.ID_WO_PREFIX = TEMP.ID_WO_PREFIX                        
 ON WSP.ID_DEBITOR= WODEBDET.ID_JOB_DEB                        
 LEFT OUTER JOIN @WOTESTNB WSPP                        
 ON WSPP.ID_WO_NO = TEMP.ID_WO_NO                         
  AND WSPP.ID_WO_PREFIX = TEMP.ID_WO_PREFIX                        
  AND WSPP.ID_DEBITOR= WODEBDET.ID_JOB_DEB                         
 --INNER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBTINV                        
 -- ON WODEBDET.ID_DBT_SEQ = DBTINV.DEBTOR_SEQ                        
 -- AND WODEBDET.ID_JOB_DEB=DBTINV.DEBTOR_ID                  
                         
                        
--SELECT '@INVOICETEMP',* FROM @INVOICETEMP --X001                        
                        
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @INVOICETEMP',getdate(),3,@NEW_GUID)                         
 INSERT INTO #TEMPNOTINV                          
 SELECT ID_WO_PREFIX+ID_WO_NO                          
 FROM @INVOICETEMP                          
 WHERE INVPREFIX IS NULL                          
                           
 DELETE FROM @INVOICETEMP                          
 WHERE INVPREFIX IS NULL                          
                           
 DECLARE @RET_ID_WO_NOTINV AS VARCHAR(13)                        
 DECLARE @INDEX AS INT                          
 DECLARE @TOTCOUNT AS INT                          
                           
 SET @INDEX = 1                          
 SELECT @TOTCOUNT = COUNT(*) FROM #TEMPNOTINV                          
                           
 WHILE(@INDEX <= @TOTCOUNT)                          
 BEGIN                          
  SELECT @RET_ID_WO_NOTINV = ID_WO_NOTINV                           
  FROM #TEMPNOTINV                          
  WHERE ID_NOTINV = @INDEX                          
                           
  IF @INDEX = 1                          
  BEGIN                          
   SET @ID_WO_NOTINV = @RET_ID_WO_NOTINV                          
  END                          
  ELSE                          
  BEGIN                          
   SET @ID_WO_NOTINV = @ID_WO_NOTINV + ',' + @RET_ID_WO_NOTINV                          
  END                           
                           
  SET @INDEX = @INDEX + 1                          
 END                           
                    
 DROP TABLE #TEMPNOTINV                           
                               
 --print '##INVOICETEMP'                                  
 --select * into ##INVOICETEMP from @INVOICETEMP                                  
                                    
  -- INSERT INTO THE TBL_INVOICE HEADER BASED UPON BATCH PROPERTY                                  
  -- IF ITS BATCH INOVICE THEN SELECT DISTINCT DEBITOR IRRESPECT OF WORK ORDER AND GENEREATE INVOICE                                  
  -- CREATE ONE MORE TEMP TABLE TO INSERT WITH CODING NO BECAUSE THE EXISTING TEMP                                  
  -- TABLE WONT CONTAINS INVNO AND THIS TABLE IS USED FURTHER                                  
  --SELECT INVPREFIX  FROM @INVOICETEMP                        
                          
  --Changed As Per row-136                        
                           
   --select '@INVOICETEMP',* from @INVOICETEMP                        
                           
                                
  DECLARE @InvPrefix AS VARCHAR(4)                         
     DECLARE @InvSeries AS VARCHAR(10)                        
  SELECT @InvPrefix = INVPREFIX, @InvSeries = INVSERIES FROM @INVOICETEMP                         
  --PRINT @InvPrefix        
  DECLARE @INV_NUMBER AS  int                        
  SELECT @INV_NUMBER = dbo.ROWMAXIMUM(@InvPrefix, @InvSeries)                        
  DECLARE @CN_NUMBER AS  int                        
  SELECT @CN_NUMBER = dbo.ROWMAXIMUM_CREDIT(@InvPrefix, @InvSeries)                        
                         
 --END Of Change                          
                                   
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @INVOICETEMP1',getdate(),4,@NEW_GUID)                                    
                         
 DECLARE @INVOICETEMP1 TABLE                                   
 (                                  
  ID_WO_NO VARCHAR(10),                                   
  ID_WO_PREFIX VARCHAR(3),                                  
  ID_WODET_SEQ INT,                                  
  ID_INV_NO VARCHAR(10),                                   
  ID_DEPT_INV INT,                                  
  ID_SUBSIDERY_INV INT,                                  
  DT_INVOICE DATETIME,                                  
  DEBITOR_TYPE CHAR(1),                                  
  ID_DEBITOR VARCHAR(10),                                  
  INV_AMT DECIMAL,                                  
  INV_KID VARCHAR(25),                                  
  ID_CN_NO VARCHAR(15),                                  
  FLG_BATCH_INV BIT,                                   
  FLG_TRANS_TO_ACC BIT,                                  
  CREATED_BY VARCHAR(20),                                  
  DT_CREATED DATETIME,                                   
  INVPREFIX VARCHAR(10),                                  
  INVSERIES VARCHAR(7),                                  
  INVMAXNUM INT,                                   
  INVWARNLEV INT,                                   
  WARN BIT,                                  
  OVERFLOW BIT,                                   
  WO_VEH_REG_NO VARCHAR(15),                         
  WO_VEH_HRS DECIMAL(9,2),                                 
 WO_JOB_TXT TEXT,                        
  TRANSFERREDVAT decimal(13,2),                        
  TRANSFERREDFROMCUSTID varchar(50),                        
  TRANSFERREDFROMCUSTName varchar(50),                        
  VATAMOUNT decimal(13,2),                        
  DEB_VAT_PER decimal(6,3)                         
  )                        
 --Changed BY Smita                           
                                 
 IF @CN_NUMBER > @INV_NUMBER                        
 BEGIN                                 
  --INSERT INTO THE TEMP TABLE WITH INVOICE NO                                  
  INSERT INTO @INVOICETEMP1                                  
  (                                  
   ID_DEBITOR,                                  
   ID_INV_NO,                                  
   ID_WO_NO,                                  
   ID_WO_PREFIX,                                  
   ID_WODET_SEQ,                                   
   ID_DEPT_INV,                                  
   ID_SUBSIDERY_INV,                                   
   DT_INVOICE,                                  
   DEBITOR_TYPE,                                  
   INV_AMT ,                                  
   INV_KID ,                                  
   ID_CN_NO,                                  
   FLG_BATCH_INV,                           
   FLG_TRANS_TO_ACC ,                                   
   CREATED_BY ,                                   
   DT_CREATED ,                                  
   INVPREFIX,                                  
   INVSERIES,                                  
   INVMAXNUM,                                   
   INVWARNLEV,                                  
   WARN,                                  
   OVERFLOW,                          
   WO_VEH_REG_NO ,                        
   WO_VEH_HRS,                 TRANSFERREDVAT,                        
   TRANSFERREDFROMCUSTID,                        
   TRANSFERREDFROMCUSTName,                        
   VATAMOUNT,                        
   DEB_VAT_PER                         
  )                                  
  SELECT                                   
   DISTINCT ID_DEBITOR,                        
  --INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+                                  
   --CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR),                          
   CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
    (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
    ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   END,                                 
   ID_WO_NO ,                                   
   ID_WO_PREFIX,                                  
   ID_WODET_SEQ,                                   
   ID_DEPT_INV,                                  
   ID_SUBSIDERY_INV,                         
   DT_INVOICE,                         
   DEBITOR_TYPE,                                   
   ISNULL(INV_AMT,0),                                  
   INV_KID,                                  
   ID_CN_NO,                                  
   FLG_BATCH_INV,                                  
   FLG_TRANS_TO_ACC,                                  
   CREATED_BY,                                  
   DT_CREATED,                                   
   INVPREFIX,                                  
   INVSERIES,                                  
   INVMAXNUM,                                   
   INVWARNLEV,                                  
   CASE                         
    WHEN CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) AS INT) +                         
      CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= INVWARNLEV                         
    THEN 'TRUE'                                  
    ELSE 'FALSE'                                  
   END AS 'WARN',                                   
   CASE                         
    WHEN CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) AS INT) +              
      CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVMAXNUM)                         
    THEN 'TRUE'                                  
    ELSE 'FALSE'                                   
   END AS 'OVERFLOW',                        
    WO_VEH_REG_NO,                        
    WO_VEH_HRS,                        
    TRANSFERREDVAT,                        
    TRANSFERREDFROMCUSTID,                        
    TRANSFERREDFROMCUSTName,                        
    VATAMOUNT,                        
    DEB_VAT_PER                        
  FROM @INVOICETEMP                                   
  WHERE FLG_BATCH_INV = 'TRUE'                         
  order by ID_WO_PREFIX,ID_WO_NO,ID_DEBITOR                        
 END                        
 ELSE                        
 BEGIN                        
  INSERT INTO @INVOICETEMP1                              
  (                                  
   ID_DEBITOR,                                  
   ID_INV_NO,                                  
   ID_WO_NO,                                  
   ID_WO_PREFIX,                                  
   ID_WODET_SEQ,                                   
   ID_DEPT_INV,                                  
   ID_SUBSIDERY_INV,                                   
   DT_INVOICE,                                  
   DEBITOR_TYPE,                                  
   INV_AMT ,                                  
   INV_KID ,                                  
   ID_CN_NO,                                  
   FLG_BATCH_INV,                                  
   FLG_TRANS_TO_ACC ,                                   
   CREATED_BY ,                                   
   DT_CREATED ,                                  
   INVPREFIX,                                  
   INVSERIES,                                  
   INVMAXNUM,                                   
   INVWARNLEV,                                  
   WARN,                                  
   OVERFLOW,                          
   WO_VEH_REG_NO ,                        
 WO_VEH_HRS,                        
   TRANSFERREDVAT,                        
   TRANSFERREDFROMCUSTID,                        
   TRANSFERREDFROMCUSTName,                        
   VATAMOUNT,                        
   DEB_VAT_PER                         
   )                                  
  SELECT                                   
   DISTINCT                         
   ID_DEBITOR,                                  
   --INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+                                  
   --CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR),                        
   CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
    (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
    ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   END,                                   
   ID_WO_NO ,                                   
   ID_WO_PREFIX,                                  
   ID_WODET_SEQ,                                   
   ID_DEPT_INV,                                  
   ID_SUBSIDERY_INV,                         
   DT_INVOICE,                         
   DEBITOR_TYPE,                                   
   ISNULL(INV_AMT,0),                                  
   INV_KID,                                  
   ID_CN_NO,                                  
   FLG_BATCH_INV,                                  
   FLG_TRANS_TO_ACC,                                  
   CREATED_BY,                                  
   DT_CREATED,                                   
   INVPREFIX,                                  
INVSERIES,                                  
   INVMAXNUM,                                   
   INVWARNLEV,                                  
   CASE                         
    WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) +                         
      CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= INVWARNLEV        
    THEN 'TRUE'                                  
    ELSE 'FALSE'                                  
   END AS 'WARN',                                   
   CASE                         
    WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) +                                   
      CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVMAXNUM)                         
    THEN 'TRUE'                                  
    ELSE 'FALSE'                                   
   END AS 'OVERFLOW',                        
    WO_VEH_REG_NO,                        
    WO_VEH_HRS,                        
    TRANSFERREDVAT,                        
    TRANSFERREDFROMCUSTID,                        
    TRANSFERREDFROMCUSTName,                        
    VATAMOUNT,                        
    DEB_VAT_PER                        
  FROM @INVOICETEMP                                   
  WHERE FLG_BATCH_INV = 'TRUE'                        
  order by ID_WO_PREFIX,ID_WO_NO,ID_DEBITOR                        
   --Coding to check if the row count exists the maximum                                   
  SELECT @COUNT_WARN=COUNT(*)                                  
  FROM @INVOICETEMP1                                  
  WHERE WARN='TRUE'                                  
                                
  --select '@INVOICETEMP',* from @INVOICETEMP          
            
  --select '@INVOICETEMP1',* from @INVOICETEMP1             
  --select '@COUNT_OFL',@COUNT_OFL                  
                                  
                            
   --Coding to check if the over flow exists maximum                                   
  SELECT @COUNT_OFL=COUNT(*)                   
  FROM @INVOICETEMP1                                  
  WHERE OVERFLOW='TRUE'                                   
                                    
  IF @COUNT_WARN > 0             
  BEGIN                                  
   SET @RET_MESSAGE='WARN'                                  
  END                                  
                                    
  IF @COUNT_OFL > 0                                   
  BEGIN                                  
   ROLLBACK TRANSACTION @TRANNAME                                  
   print 'test'                                  
   SET @OV_RETVALUE = 'INVWRN'                                  
   RETURN                                   
  END                                  
  --print '@INVOICETEMP1'                                  
--SELECT '@INVOICETEMP1',* FROM @INVOICETEMP1 --X002                               
                                     
  --SELECT * FROM @INVOICETEMP1                                  
  --TEMP TABLE 2 FOR TESTING PURPOSE                          
 END                        
  --Coding to check if the row count exists the maximum                                   
 SELECT @COUNT_WARN=COUNT(*)                                  
 FROM @INVOICETEMP1                                  
 WHERE WARN='TRUE'                                  
                                    
  --Coding to check if the over flow exists maximum                                   
SELECT @COUNT_OFL=COUNT(*)                                  
 FROM @INVOICETEMP1                                  
 WHERE OVERFLOW='TRUE'                                   
                                   
 IF @COUNT_WARN > 0                                  
 BEGIN                                  
  SET @RET_MESSAGE='WARN'                                  
 END                                  
                                   
 IF @COUNT_OFL > 0                                   
 BEGIN      
  ROLLBACK TRANSACTION @TRANNAME                                  
  print 'test'                                  
  SET @OV_RETVALUE = 'INVWRN'                                  
  RETURN                                   
 END                                 
    INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @INVOICETEMP1',getdate(),4,@NEW_GUID)                        
                            
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @INVOICETEMP2',getdate(),2,@NEW_GUID)                                  
 DECLARE @INVOICETEMP2 TABLE                                   
 (                                   
 ID_WO_NO VARCHAR(10),                           
  ID_WO_PREFIX VARCHAR(3),                                  
  ID_INV_NO VARCHAR(10),                                  
  ID_DEPT_INV INT,                                  
  ID_SUBSIDERY_INV INT,                                  
  DT_INVOICE DATETIME,                                  
  DEBITOR_TYPE CHAR(1),                                  
  ID_DEBITOR VARCHAR(10),                                  
  INV_AMT DECIMAL,                                   
  INV_KID VARCHAR(25),                                   
  ID_CN_NO VARCHAR(15),                                  
  FLG_BATCH_INV BIT,                                  
  FLG_TRANS_TO_ACC BIT,                                  
  CREATED_BY VARCHAR(20),                                  
  DT_CREATED DATETIME,                                
  INVPREFIX VARCHAR(10),                                   
  INVSERIES VARCHAR(7),                                   
  INVMAXNUM INT,                                  
  INVWARNLEV INT,                                  
  WARN BIT,                                  
  OVERFLOW BIT,                                  
  WO_VEH_REG_NO VARCHAR(15),                                  
  WO_JOB_TXT TEXT,                        
  WO_CUST_PERM_ADD1 VARCHAR(50),                                  
  WO_CUST_PERM_ADD2 VARCHAR(50),                         
  WO_CUST_NAME VARCHAR(100),                        
  TRANSFERREDVAT decimal(13,2),                        
  TRANSFERREDFROMCUSTID varchar(50),                        
  TRANSFERREDFROMCUSTName varchar(50),                        
  VATAMOUNT decimal(13,2),                        
  DEB_VAT_PER decimal(6,3)                           
 )                    
                      
                       
                       
                         
 IF @CN_NUMBER > @INV_NUMBER                        
 BEGIN                                 
  --INSERT INTO THE TEMP TABLE WITH INVOICE NO                                  
 INSERT INTO @INVOICETEMP2                                   
 (                                   
  ID_DEBITOR,                        
  ID_WO_PREFIX,                                  
  ID_DEPT_INV,                                   
  ID_SUBSIDERY_INV,                                   
   DT_INVOICE,                                  
   DEBITOR_TYPE,                                  
  INV_AMT ,                                  
  INV_KID ,                                  
  ID_CN_NO,                                   
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC ,                                  
  CREATED_BY ,                                   
  DT_CREATED ,                                  
  INVPREFIX,                                  
  INVSERIES,                                  
  INVMAXNUM,                                   
  INVWARNLEV,                                  
  WARN,                                   
  OVERFLOW,                          
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                        
  WO_CUST_NAME,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                        
                       
 )                                  
 SELECT DISTINCT                                 
  ID_DEBITOR,                                
  TEMP.ID_WO_PREFIX,                                  
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                         
  DT_INVOICE,                                    
  'C',--DEBITOR_TYPE,                                  
  ISNULL(INV_AMT,0),                                   
  INV_KID,                                  
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC,                                  
  TEMP.CREATED_BY,                                  
  TEMP.DT_CREATED ,                                  
  INVPREFIX,                                  
  INVSERIES,                                  
  INVMAXNUM,                                   
  INVWARNLEV,                                  
  WARN,                                   
  OVERFLOW,                 
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                        
  WO_CUST_NAME,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                      
  --DEBINVDATA.LINE_VAT_AMOUNT ,                       
  DEB_VAT_PER                        
 FROM @INVOICETEMP  TEMP                      
 --INNER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINVDATA                      
 --ON TEMP.ID_WO_NO = DEBINVDATA.ID_WO_NO                      
 --AND TEMP.ID_WO_PREFIX = DEBINVDATA.ID_WO_PREFIX              
 --AND TEMP.ID_JOB = DEBINVDATA.ID_JOB_ID                
 WHERE FLG_BATCH_INV = 'TRUE'                          
 order by TEMP.ID_WO_PREFIX,TEMP.ID_DEBITOR                                 
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @INVOICETEMP2',getdate(),2,@NEW_GUID)                                  
                            
 --print '@INVOICETEMP2'                                   
--SELECT '@INVOICETEMP2',* FROM @INVOICETEMP2 --X003                        
                      
                               
 --AFTER INSERT                             
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert TBL_INV_HEADER',getdate(),6,@NEW_GUID)                                  
                             
 INSERT INTO TBL_INV_HEADER                                  
 (                                  
  ID_DEBITOR,              
  ID_INV_NO,                                  
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                                  
  DT_INVOICE,                                  
  DEBITOR_TYPE,                                  
  INV_AMT,                                  
  INV_KID,                                   
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC,                                  
  CREATED_BY,                                  
  DT_CREATED,                                 
  CUST_PERM_ADD1,                                  
  CUST_PERM_ADD2,                        
  CUST_NAME,                        
  INV_PREFIX,                        
  INV_SERIES,                       
  DUEDATE,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                   
 )                                  
 SELECT                                   
  DISTINCT ID_DEBITOR,                                  
  --INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+                                   
  --   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC ) AS VARCHAR) AS VARCHAR),                                  
  CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  END,                        
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                              
  DT_INVOICE,                                 
  DEBITOR_TYPE,                                  
  ISNULL(INV_AMT,0),                                  
  DBO.FNGETKID(ID_DEBITOR,CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)                                  
   + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR),                                  
   '0', ID_DEPT_INV, ID_SUBSIDERY_INV                                  
  ),                                  
  ID_CN_NO,FLG_BATCH_INV,                        
  FLG_TRANS_TO_ACC,                        
  CREATED_BY,                        
  DT_CREATED,                                
  WO_CUST_PERM_ADD1,         
  WO_CUST_PERM_ADD2,                         
  WO_CUST_NAME,                        
  INVPREFIX,                        
  CASE WHEN dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  END,                        
  CAST(CAST(dbo.FnGetDueDate(DT_INVOICE, ID_DEBITOR) AS VARCHAR(20)) AS DATETIME),                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                 
 FROM @INVOICETEMP2                                   
 WHERE FLG_BATCH_INV = 'TRUE'                         
  --AND debitor_type='C'                          
                        
 END                        
 ELSE                        
  BEGIN                        
  INSERT INTO @INVOICETEMP2                                   
 (                                   
  ID_DEBITOR,                        
  ID_WO_PREFIX,                                  
  ID_DEPT_INV,                                   
  ID_SUBSIDERY_INV,                                   
   DT_INVOICE,                                  
  DEBITOR_TYPE,                                  
 INV_AMT ,                                  
  INV_KID ,                                  
  ID_CN_NO,                                   
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC ,                                  
  CREATED_BY ,                                   
  DT_CREATED ,                                  
  INVPREFIX,                                  
  INVSERIES,                                  
  INVMAXNUM,                                   
  INVWARNLEV,                                  
  WARN,                                   
  OVERFLOW,                          
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                      
  WO_CUST_NAME,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                 
 )                                  
 SELECT                         
  DISTINCT                         
    ID_DEBITOR,                                
  TEMP.ID_WO_PREFIX,              
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                         
  DT_INVOICE,                                    
  'C',--DEBITOR_TYPE,                                  
  ISNULL(INV_AMT,0),                                   
  INV_KID,               
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC,                                  
  TEMP.CREATED_BY,                                  
  TEMP.DT_CREATED ,                                  
  INVPREFIX,                                  
  INVSERIES,                                  
  INVMAXNUM,                                   
  INVWARNLEV,                                  
  WARN,                                   
  OVERFLOW,                              
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                        
  WO_CUST_NAME,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                      
  --DEBINVDATA.LINE_VAT_AMOUNT ,                       
  DEB_VAT_PER                         
 FROM @INVOICETEMP TEMP                      
 --INNER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINVDATA                      
 --ON TEMP.ID_WO_NO = DEBINVDATA.ID_WO_NO                      
 --AND TEMP.ID_WO_PREFIX = DEBINVDATA.ID_WO_PREFIX              
 --AND TEMP.ID_JOB = DEBINVDATA.ID_JOB_ID                                   
 WHERE FLG_BATCH_INV = 'TRUE'                         
 order by TEMP.ID_WO_PREFIX,TEMP.ID_DEBITOR                                  
                                   
 --print '@INVOICETEMP2'                                   
 --select * into ##INVOICETEMP2 from @INVOICETEMP2                          
 --SELECT '@INVOICETEMP22',* FROM @INVOICETEMP2 --X003                        
                      
                               
 --AFTER INSERT                                  
 INSERT INTO TBL_INV_HEADER                                  
 (                                  
  ID_DEBITOR,                                  
  ID_INV_NO,                                  
  ID_DEPT_INV,                           
  ID_SUBSIDERY_INV,                                  
  DT_INVOICE,                                  
  DEBITOR_TYPE,                                  
  INV_AMT,                                  
  INV_KID,                                   
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC,                                  
  CREATED_BY,                                  
  DT_CREATED,                                 
  CUST_PERM_ADD1,                                  
  CUST_PERM_ADD2,                        
  CUST_NAME,                 
  INV_PREFIX,                        
  INV_SERIES,                        
  DUEDATE,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                   
 )                                  
 SELECT                                   
  DISTINCT ID_DEBITOR,                                  
  --INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+                                   
  --   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC ) AS VARCHAR) AS VARCHAR),                                  
  CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  END,                         
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                              
  DT_INVOICE,                                 
  DEBITOR_TYPE,                                  
  ISNULL(INV_AMT,0),                                  
  DBO.FNGETKID(ID_DEBITOR,CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)                                  
   + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR),                                  
   '0', ID_DEPT_INV, ID_SUBSIDERY_INV                                  
  ),                                  
  ID_CN_NO,FLG_BATCH_INV,                        
  FLG_TRANS_TO_ACC,                        
  CREATED_BY,                        
  DT_CREATED,                                
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                         
  WO_CUST_NAME,                        
  INVPREFIX,                        
  CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
  (CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  ELSE (CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  END  ,                        
  CAST(CAST(dbo.FnGetDueDate(DT_INVOICE, ID_DEBITOR) AS VARCHAR(20)) AS DATETIME),                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                
 FROM @INVOICETEMP2          
 WHERE FLG_BATCH_INV = 'TRUE'                         
  --AND debitor_type='C'                         
                        
                        
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert TBL_INV_HEADER',getdate(),6,@NEW_GUID)                                  
--SELECT '@INVOICETEMP22',* FROM @INVOICETEMP2 --X004                         
                          
 IF @@ERROR <> 0                                  
 BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                             
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                              
 RETURN                                   
 END                                
  END                               
               
                                   
 IF @@ERROR <> 0                          
 BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                   
 END                                   
                         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @INVOICENONBATCHINVOICE',getdate(),7,@NEW_GUID)                                  
                                  
 --print '##TBL_INV_HEADER'                                   
  --select * into ##TBL_INV_HEADERfrom TBL_INV_HEADER                             
  -- CODING FOR NON BATCH INVOICE                                  
 -- select * into ##INVOICETEMP from @INVOICETEMP                            
                 
                        
                                
 DECLARE @INVOICENONBATCHINVOICE TABLE                                   
 (                                  
 ID_WO_NO VARCHAR(10),                                  
 ID_WO_PREFIX VARCHAR(3),                                  
 ID_WODET_SEQ INT,                                  
 ID_INV_NO VARCHAR(10),                                  
 ID_DEPT_INV INT,                                  
 ID_SUBSIDERY_INV INT,                                   
 DT_INVOICE DATETIME,                                  
 DEBITOR_TYPE CHAR(1),                                  
 ID_DEBITOR VARCHAR(10),                                  
 INV_AMT DECIMAL,                                   
 INV_KID VARCHAR(25),                                  
 ID_CN_NO VARCHAR(15),                                  
 FLG_BATCH_INV BIT,                                  
 FLG_TRANS_TO_ACC BIT,                                   
 CREATED_BY VARCHAR(20),                                  
 DT_CREATED DATETIME,                                  
 INVPREFIX VARCHAR(10),                                  
 INVSERIES VARCHAR(7),                                  
  INVMAXNUM INT,                                  
 INVWARNLEV INT,                                   
 WARN BIT,                                  
 OVERFLOW BIT,                         
 WO_VEH_REG_NO VARCHAR(15) ,                        
 WO_VEH_HRS DECIMAL(9,2),                        
 TRANSFERREDVAT decimal(13,2),                        
 TRANSFERREDFROMCUSTID varchar(50),                        
 TRANSFERREDFROMCUSTName varchar(50),                        
 VATAMOUNT decimal(13,2),                        
 DEB_VAT_PER decimal(6,3)                        
 )                        
                           
 IF @CN_NUMBER > @INV_NUMBER                        
 BEGIN                          
                          
 INSERT INTO @INVOICENONBATCHINVOICE                                   
 (          
 ID_WO_NO,                                   
 ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                  
 ID_WODET_SEQ ,                    
 ID_INV_NO ,                                  
 ID_SUBSIDERY_INV,                                   
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 ID_DEBITOR,                                  
 INV_AMT,                                  
 INV_KID,                                   
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                                  
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 WARN,                                   
 OVERFLOW,                             
 WO_VEH_REG_NO,                        
 WO_VEH_HRS,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                             
 )                         
                         
 SELECT                                   
 DISTINCT  ID_WO_NO,ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                   
 ID_WODET_SEQ,                                  
 --INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+                                   
 --  CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR)                         
 --AS VARCHAR),                        
 CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 END ,                         
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 ID_DEBITOR,                                  
 ISNULL(INV_AMT,0),                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                               
 CREATED_BY,                                  
 DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                           
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 CASE                         
   WHEN CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) AS INT) +                         
     CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= INVWARNLEV                          
 THEN   'TRUE'                                  
 ELSE 'FALSE'                                   
 END AS 'WARN',                                   
 CASE                         
   WHEN CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) AS INT) +                                   
     CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVMAXNUM)                        
  THEN 'TRUE'                               
 ELSE 'FALSE'                                   
 END AS 'OVERFLOW',                                  
 WO_VEH_REG_NO,                        
 WO_VEH_HRS,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                            
 FROM                                   
 @INVOICETEMP                        
 WHERE                                  
 FLG_BATCH_INV = 'FALSE' AND  INVSEQ = 1                         
                         
 UNION ALL        
 SELECT                           
 DISTINCT ID_WO_NO,ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                   
 ID_WODET_SEQ,                                  
 NULL,                        
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 ID_DEBITOR,                                  
 ISNULL(INV_AMT,0),                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                                
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 NULL AS 'WARN',                                   
 NULL AS 'OVERFLOW',                                  
 WO_VEH_REG_NO,                        
 WO_VEH_HRS,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                         
  FROM                         
 @INVOICETEMP                                  
 WHERE                                  
 FLG_BATCH_INV = 'FALSE' AND  INVSEQ > 1                         
 order by ID_WO_PREFIX,ID_WO_NO,ID_DEBITOR                        
                         
 UPDATE T2                        
 SET T2.ID_INV_NO = T1.ID_INV_NO , T2.WARN = T1.WARN, T2.OVERFLOW = T1.OVERFLOW                        
 FROM @INVOICENONBATCHINVOICE T2                        
  INNER JOIN @INVOICENONBATCHINVOICE T1 on T2.ID_WO_NO = T1.ID_WO_NO AND T2.ID_WO_PREFIX = T1.ID_WO_PREFIX                         
   AND T2.ID_DEBITOR = T1.ID_DEBITOR                        
 WHERE T1.ID_INV_NO IS NOT NULL                        
 END                         
 ELSE                        
 BEGIN                        
 INSERT INTO @INVOICENONBATCHINVOICE                                   
 (                                  
 ID_WO_NO,                                   
 ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                  
 ID_WODET_SEQ ,                          
 ID_INV_NO ,                                
 ID_SUBSIDERY_INV,                                   
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 ID_DEBITOR,                                  
 INV_AMT,                                  
 INV_KID,                                   
 ID_CN_NO,                                   
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                                  
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 WARN,                          
 OVERFLOW,                             
 WO_VEH_REG_NO,                        
 WO_VEH_HRS,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                         
    )                          
                                 
 SELECT                                  
  ID_WO_NO,ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                   
 ID_WODET_SEQ,                            
 --INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+                                   
 --  CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR)                         
 --AS VARCHAR),                        
 CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 END ,                         
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
ID_DEBITOR,                                  
 ISNULL(INV_AMT,0),                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                                  
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 CASE                         
   WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) +                         
     CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= INVWARNLEV                          
 THEN   'TRUE'                                           
 ELSE 'FALSE'                                   
 END AS 'WARN',                                   
 CASE                         
   WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) +                                   
CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVMAXNUM)                        
  THEN 'TRUE'                                      
 ELSE 'FALSE'                                   
 END AS 'OVERFLOW',                                  
 WO_VEH_REG_NO,                        
 WO_VEH_HRS,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                         
 FROM                                   
 @INVOICETEMP                                  
 WHERE                                  
 FLG_BATCH_INV = 'FALSE'                        
 AND INVSEQ = 1                        
                          
 UNION ALL                        
 SELECT                                   
 DISTINCT ID_WO_NO,ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                   
 ID_WODET_SEQ,                             
 NULL,                        
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 ID_DEBITOR,                                  
 ISNULL(INV_AMT,0),                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                                  
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 NULL AS 'WARN',                                   
 NULL AS 'OVERFLOW',                               
 WO_VEH_REG_NO,                        
 WO_VEH_HRS,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                         
FROM                                   
 @INVOICETEMP                                  
 WHERE                                  
 FLG_BATCH_INV = 'FALSE' AND  INVSEQ > 1                         
 order by ID_WO_PREFIX,ID_WO_NO,ID_DEBITOR                        
                          
--select '@INVOICENONBATCHINVOICE',* from @INVOICENONBATCHINVOICE                          
                          
 UPDATE T2                    
 SET T2.ID_INV_NO = T1.ID_INV_NO , T2.WARN = T1.WARN, T2.OVERFLOW = T1.OVERFLOW                        
 FROM @INVOICENONBATCHINVOICE T2                        
  INNER JOIN @INVOICENONBATCHINVOICE T1 on T2.ID_WO_NO = T1.ID_WO_NO AND T2.ID_WO_PREFIX = T1.ID_WO_PREFIX                         
  AND T2.ID_DEBITOR = T1.ID_DEBITOR                        
 WHERE T1.ID_INV_NO IS NOT NULL                        
                          
 IF @@ERROR <> 0                                   
 BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                   
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                   
 END                                   
                                   
  SELECT                                   
 @COUNT_WARN=COUNT(*)                                  
  FROM                                   
 @INVOICENONBATCHINVOICE                                  
  WHERE                                  
 WARN='TRUE'                                  
                                    
  SELECT                                   
 @COUNT_OFL=COUNT(*)                                  
  FROM                                  
 @INVOICENONBATCHINVOICE                                  
  WHERE                                  
 OVERFLOW='TRUE'                                  
                                    
  IF @COUNT_WARN>0                                  
 BEGIN                                  
  SET @RET_MESSAGE='WARN'                              
 END                                  
          
--select '@COUNT_OFLnon',@COUNT_OFL                                    
          
  IF @COUNT_OFL>0                                   
 BEGIN                                  
  ROLLBACK TRANSACTION @TRANNAME                                
  print 'test1'                                   
  SET @OV_RETVALUE = 'INVWRN'                                  
  RETURN                                   
 END                                   
 END                        
                         
                                
                                    
 IF @@ERROR <> 0                                   
 BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                   
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                   
 END                                   
                                   
  SELECT                                   
 @COUNT_WARN=COUNT(*)                                  
  FROM                                   
 @INVOICENONBATCHINVOICE                                  
  WHERE                                  
 WARN='TRUE'                                  
                                    
  SELECT                                   
 @COUNT_OFL=COUNT(*)                                  
  FROM                                  
 @INVOICENONBATCHINVOICE                                  
  WHERE                                  
 OVERFLOW='TRUE'                                  
                                    
  IF @COUNT_WARN>0                                  
 BEGIN                                  
  SET @RET_MESSAGE='WARN'                                  
 END                                  
                                    
  IF @COUNT_OFL>0                                   
 BEGIN                                  
  ROLLBACK TRANSACTION @TRANNAME                                
  print 'test1'                                   
  SET @OV_RETVALUE = 'INVWRN'                   
  RETURN                                   
 END                                   
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @INVOICENONBATCHINVOICE',getdate(),7,@NEW_GUID)                                      
 --select * into ##INVOICENONBATCHINVOICE from @INVOICENONBATCHINVOICE                                   
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @INVOICETEMP3',getdate(),8,@NEW_GUID)                                      
                                  
    --SELECT '@INVOICENONBATCHINVOICE',* FROM @INVOICENONBATCHINVOICE --X005                                                       
 /* One more temp table which contains the detail about non batch invoice*/                                  
 DECLARE @INVOICETEMP3 TABLE                                  
 (                 
 ID_WO_NO VARCHAR(10),                                  
 ID_WO_PREFIX VARCHAR(3),                                  
 ID_INV_NO VARCHAR(10),                                  
 ID_DEPT_INV INT,                                  
 ID_SUBSIDERY_INV INT,                                  
 DT_INVOICE DATETIME,                                  
 DEBITOR_TYPE CHAR(1),                                  
 ID_DEBITOR VARCHAR(10),                                   
 INV_AMT DECIMAL,                                   
 INV_KID VARCHAR(25),                                  
 ID_CN_NO VARCHAR(15),                                  
  FLG_BATCH_INV BIT,                                   
 FLG_TRANS_TO_ACC BIT,                                  
 CREATED_BY VARCHAR(20),                                  
 DT_CREATED DATETIME,                                  
 INVPREFIX VARCHAR(10),                                  
 INVSERIES VARCHAR(7),                                   
 INVMAXNUM INT,                                  
 INVWARNLEV INT,                                   
 WARN BIT,                                  
 OVERFLOW BIT,                                  
 WO_VEH_REG_NO VARCHAR(15),                                  
 WO_JOB_TXT TEXT,                                  
 WO_CUST_PERM_ADD1 VARCHAR(50),                                  
 WO_CUST_PERM_ADD2 vARCHAR(50),                         
 WO_CUST_NAME VARCHAR(100),                         
 ID_WO_NO_KID VARCHAR(10),                        
 INVJOB INT,                        
 ID INT,                        
 TRANSFERREDVAT decimal(13,2),                        
 TRANSFERREDFROMCUSTID varchar(50),                        
 TRANSFERREDFROMCUSTName varchar(50),                        
 VATAMOUNT decimal(13,2),                        
 DEB_VAT_PER decimal(6,3)                         
  )                                  
                                   
 IF @CN_NUMBER > @INV_NUMBER                        
 BEGIN                                   
 INSERT INTO @INVOICETEMP3                                   
 (                                 
  ID_WO_PREFIX,                                   
  ID_DEPT_INV ,                                  
  ID_SUBSIDERY_INV,                                  
  DT_INVOICE,                                  
  DEBITOR_TYPE,                                   
  ID_DEBITOR,                                  
  INV_AMT,                                  
  INV_KID,                                  
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC ,                                  
  CREATED_BY,                                  
  DT_CREATED,                                  
  INVPREFIX,                                  
  INVSERIES,                                  
  INVMAXNUM,                                   
  INVWARNLEV,                                   
  WARN,                                  
  OVERFLOW,                                  
  --Change by Manoj K                                  
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                         
  WO_CUST_NAME,                                 
  ID_WO_NO_KID,                        
  INVJOB,                        
  ID,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER,                        
  ID_WO_NO,                        
  ID_INV_NO                        
                                 
 )                                  
 SELECT DISTINCT                        
 INVT.ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                      
 ID_SUBSIDERY_INV,                                  
  DT_INVOICE,                 'C',                             
 ID_DEBITOR,                                  
 ISNULL(INV_AMT,0),                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                
 INVT.CREATED_BY,                                  
 INVT.DT_CREATED,                                  
 INVPREFIX,                                  
 INVSERIES,                                  
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 WARN,                              
 OVERFLOW,                                  
 WO_CUST_PERM_ADD1,                                  
 WO_CUST_PERM_ADD2,                         
 WO_CUST_NAME,                                 
 INVT.ID_WO_NO,                        
 CAST(ROW_NUMBER() OVER(PARTITION BY INVT.ID_WO_NO, INVT.ID_WO_PREFIX, ID_DEBITOR ORDER BY ID_DEBITOR DESC) AS INT),                        
 ROW_NUMBER() OVER(ORDER BY INVT.DT_CREATED),                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 --VATAMOUNT,                       
 DEBINVDATA.LINE_VAT_AMOUNT,                       
 DEB_VAT_PER ,                        
 INVT.ID_WO_NO,                        
  CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 END                                       
 FROM                                   
 @INVOICETEMP   INVT                       
  INNER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINVDATA                      
 ON INVT.ID_WO_NO = DEBINVDATA.ID_WO_NO                      
 AND INVT.ID_WO_PREFIX = DEBINVDATA.ID_WO_PREFIX              
 AND INVT.ID_JOB = DEBINVDATA.ID_JOB_ID                                  
 WHERE                                   
 FLG_BATCH_INV = 'FALSE'                        
 order by INVT.ID_WO_PREFIX,INVT.ID_WO_NO,INVT.ID_DEBITOR                        
                          
 DELETE   FROM f                        
 FROM  @INVOICETEMP3 AS f INNER JOIN @INVOICETEMP3 AS g                        
 ON g.ID_WO_NO_KID = f.ID_WO_NO_KID AND g.ID_WO_PREFIX = f.ID_WO_PREFIX AND g.ID_DEBITOR = f.ID_DEBITOR                        
 AND f.ID < g.ID                        
                                  
  --SELECT * INTOTESTINGINVOICE FROM @INVOICETEMP3                        
  -- SELECT * FROM @INVOICENONBATCHINVOICE                                  
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @INVOICETEMP3',getdate(),8,@NEW_GUID)                                      
                            
                             
  -- INSERT INTO THE TBL_INV_HEADER FOR NON BATCH INVOICE                                   
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert TBL_INV_HEADER 2',getdate(),9,@NEW_GUID)                                      
                                 
  INSERT INTO TBL_INV_HEADER                                   
  (                                  
 ID_DEBITOR,                                  
 ID_INV_NO,                                  
 ID_DEPT_INV,                                  
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 INV_AMT,                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 CUST_PERM_ADD1,            
 CUST_PERM_ADD2,                         
 CUST_NAME,     
 INV_PREFIX,                        
 INV_SERIES,                   
 DUEDATE,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                                                    
  )                                  
                                    
  SELECT DISTINCT                          
 ID_DEBITOR,                                  
 --INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+                                   
 -- CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY ID DESC) AS VARCHAR) AS VARCHAR),                          
 --CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
 --  (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 --  ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 --END ,                          
 ID_INV_NO,                                
 ID_DEPT_INV,ID_SUBSIDERY_INV,                                  
 DT_INVOICE,DEBITOR_TYPE,INV_AMT,                                  
 DBO.FNGETKID(                                  
 ID_DEBITOR,                                  
  CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)                     
 + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY ID DESC) AS VARCHAR) AS VARCHAR),                                  
 ID_WO_NO_KID,                                  
 ID_DEPT_INV,                                   
 ID_SUBSIDERY_INV                                  
 ),                                  
  ID_CN_NO,FLG_BATCH_INV,FLG_TRANS_TO_ACC,CREATED_BY,DT_CREATED,                         
 WO_CUST_PERM_ADD1,                                  
 WO_CUST_PERM_ADD2,                         
 WO_CUST_NAME,                        
 INVPREFIX,                        
 CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
  (CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 ELSE                         
  (CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 END,                        
 CAST(CAST(dbo.FnGetDueDate(DT_INVOICE, ID_DEBITOR) AS VARCHAR(20)) AS DATETIME),                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
VATAMOUNT,                        
 DEB_VAT_PER                                                    
  FROM                                  
  @INVOICETEMP3                                   
  WHERE                                  
  FLG_BATCH_INV = 'FALSE'                          
                          
                          
  END                        
  ELSE                        
  BEGIN                        
  INSERT INTO @INVOICETEMP3                                   
 (                                 
  ID_WO_PREFIX,                                   
  ID_DEPT_INV ,                                  
  ID_SUBSIDERY_INV,                                  
  DT_INVOICE,                                  
  DEBITOR_TYPE,                                   
  ID_DEBITOR,                                  
  INV_AMT,                                  
  INV_KID,                                  
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC ,                            
  CREATED_BY,                                  
  DT_CREATED,                                  
  INVPREFIX,                                  
  INVSERIES,        
  INVMAXNUM,                                   
  INVWARNLEV,                                   
  WARN,                                  
  OVERFLOW,                                  
  --Change by Manoj K                                  
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                         
  WO_CUST_NAME,                                 
  ID_WO_NO_KID ,                        
  INVJOB,                        
  ID,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER,                        
  ID_WO_NO,                        
  ID_INV_NO                                          
 )                                  
 SELECT  DISTINCT                             
 INVT.ID_WO_PREFIX,                                  
 ID_DEPT_INV ,                                 
 ID_SUBSIDERY_INV,                                  
  DT_INVOICE,                                  
 'C',                                  
 ID_DEBITOR,                                  
 ISNULL(INV_AMT,0),                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC ,                                   
 INVT.CREATED_BY,                                  
 INVT.DT_CREATED,                                  
INVPREFIX,                                  
 INVSERIES,                                  
 INVMAXNUM,                                  
 INVWARNLEV,                                   
 WARN,                                  
 OVERFLOW,                                  
 WO_CUST_PERM_ADD1,                                  
 WO_CUST_PERM_ADD2,                         
 WO_CUST_NAME,                                 
 INVT.ID_WO_NO,                        
 CAST(ROW_NUMBER() OVER(PARTITION BY INVT.ID_WO_NO, INVT.ID_WO_PREFIX, ID_DEBITOR ORDER BY ID_DEBITOR DESC) AS INT),                        
 ROW_NUMBER() OVER(ORDER BY INVT.DT_CREATED),                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 --VATAMOUNT,                        
 DEBINVDATA.LINE_VAT_AMOUNT,                      
 DEB_VAT_PER ,                        
 INVT.ID_WO_NO,                        
 NULL                        
 --CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
 --  (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 --  ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
 --END                                               
 FROM                              
 @INVOICETEMP INVT                        
INNER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINVDATA                      
 ON INVT.ID_WO_NO = DEBINVDATA.ID_WO_NO                      
 AND INVT.ID_WO_PREFIX = DEBINVDATA.ID_WO_PREFIX              
 AND INVT.ID_JOB = DEBINVDATA.ID_JOB_ID              
 WHERE                                   
 FLG_BATCH_INV = 'FALSE'                         
 order by INVT.ID_WO_PREFIX,INVT.ID_WO_NO,INVT.ID_DEBITOR                        
                       
                      
                       
 UPDATE @INVOICETEMP3                        
 SET VATAMOUNT =  Q.TOT                        
 FROM (                        
 SELECT SUM (WT.VATAMOUNT) AS TOT                       
 FROM @INVOICETEMP3 WT                       
 GROUP BY WT.ID_WO_NO,WT.ID_WO_PREFIX                      
 )Q                        
 --WHERE FLG_BATCH = 1 AND Q.DEBITOR =ID_DEBITOR                        
                       
                      
                       
                           
 DELETE   FROM f                        
 FROM  @INVOICETEMP3 AS f INNER JOIN @INVOICETEMP3 AS g                       
 ON g.ID_WO_NO_KID = f.ID_WO_NO_KID AND g.ID_WO_PREFIX = f.ID_WO_PREFIX AND g.ID_DEBITOR = f.ID_DEBITOR                        
 AND f.ID < g.ID                        
 --AND f.ID > g.ID    --UPDATED TO GREATER THAN TO KEEP THE FIRST GENERATED INVOICE NUMBER                        
                         
  --SELECT * INTOTESTINGINVOICE FROM @INVOICETEMP3                                  
                        
/*Adding new temp table to generate Invoice NUmber since the records sorting while inserting to Invoice Header table may not match @invoicetemp table order - 20-Dec-15*/                        
select *,                        
CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
   (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
   ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
                           
 END                           
 as ID_INV_NO_TEMP                        
 into #invtemp3 from @INVOICETEMP3                         
                        
                      
                        
                             
                    
  -- INSERT INTO THE TBL_INV_HEADER FOR NON BATCH INVOICE                                   
                                    
  INSERT INTO TBL_INV_HEADER                                   
  (                                  
 ID_DEBITOR,                                  
 ID_INV_NO,                                  
 ID_DEPT_INV,                                  
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
 DEBITOR_TYPE,                                  
 INV_AMT,                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC,                                  
 CREATED_BY,                                  
 DT_CREATED,                                  
 CUST_PERM_ADD1,                                  
 CUST_PERM_ADD2,                         
 CUST_NAME,                        
 INV_PREFIX,                           
 INV_SERIES,                        
 DUEDATE,                        
 TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                                                  
  )                                  
                                    
  SELECT                                  
  ID_DEBITOR,                                  
  --INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+                                   
  -- CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY ID ASC) AS VARCHAR) AS VARCHAR),                            
  --CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
  --  (INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  --  ELSE (INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  --END ,                            
  ID_INV_NO_TEMP,    /*Assigning invoice number from temp table*/                        
  ID_DEPT_INV,ID_SUBSIDERY_INV,                                  
  DT_INVOICE,DEBITOR_TYPE,INV_AMT,                                  
  DBO.FNGETKID(                                  
  ID_DEBITOR,                                  
   CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)                                   
  + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY ID ASC) AS VARCHAR) AS VARCHAR),                              
  ID_WO_NO_KID,                                  
  ID_DEPT_INV,                                   
  ID_SUBSIDERY_INV                                  
  ),                                  
   ID_CN_NO,FLG_BATCH_INV,FLG_TRANS_TO_ACC,CREATED_BY,DT_CREATED,                         
  WO_CUST_PERM_ADD1,                                  
  WO_CUST_PERM_ADD2,                         
  WO_CUST_NAME,                        
  INVPREFIX,                        
  CASE WHEN   dbo.ROWMAXIMUM_CREDIT(INVPREFIX, INVSERIES) > dbo.ROWMAXIMUM(INVPREFIX, INVSERIES) THEN                        
    (CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
    ELSE (CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+ CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS VARCHAR))                        
  END,                        
  CAST(CAST(dbo.FnGetDueDate(DT_INVOICE, ID_DEBITOR) AS VARCHAR(20)) AS DATETIME),                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,         
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                                    
  FROM                                  
  --@INVOICETEMP3                                   
  #invtemp3                        
  WHERE                                  
  FLG_BATCH_INV = 'FALSE' ORDER BY ID                        
  IF @@ERROR <> 0                                   
  BEGIN                                  
   ROLLBACK TRANSACTION @TRANNAME                                  
   SET @OV_RETVALUE = 'INSFLG'                                   
    IF @COUNT_ORD = 0                        
   BEGIN                        
     SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
   END                        
   ELSE IF @COUNT_ORD = -1                        
   BEGIN                        
     SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
   END                        
   RETURN                                  
  END                             
  END                             
                         
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert TBL_INV_HEADER 2',getdate(),9,@NEW_GUID)                                      
                                   
  IF @@ERROR <> 0                                   
  BEGIN                                  
  ROLLBACK TRANSACTION @TRANNAME                                  
  SET @OV_RETVALUE = 'INSFLG'                                   
   IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
  RETURN                                  
  END                                   
                                   
   --End of change by smita                                 
  ---INSERT INTO THE TEMPTABLE1 WITH NONBATCH INVOICE                                   
  -- INSERT INTO THE TBL_INV_HEADER FOR NON BATCH INVOICE                           
                        
                          
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @INVOICETEMP1',getdate(),10,@NEW_GUID)                                      
    --SELECT '@INVOICETEMP3',* FROM @INVOICETEMP3 --X006                        
                           
  INSERT INTO @INVOICETEMP1                                  
  (                                  
  ID_DEBITOR,                                   
  ID_INV_NO,                                  
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                                  
  ID_WO_NO ,                                  
  ID_WO_PREFIX,                                   
  DT_INVOICE,         
  DEBITOR_TYPE,                                  
  INV_AMT,                                  
  INV_KID,                                  
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                  
  FLG_TRANS_TO_ACC,                       
  CREATED_BY,                                  
  DT_CREATED,                                  
  ID_WODET_SEQ,                                
  WO_VEH_REG_NO ,                        
  WO_VEH_HRS,                        
  TRANSFERREDVAT,                        
  TRANSFERREDFROMCUSTID,                        
  TRANSFERREDFROMCUSTName,                        
  VATAMOUNT,                        
  DEB_VAT_PER                                           
  )                                  
  SELECT DISTINCT                                  
 ID_DEBITOR,ID_INV_NO,                                  
 ID_DEPT_INV,ID_SUBSIDERY_INV,                                   
 ID_WO_NO ,ID_WO_PREFIX,                          
 DT_INVOICE,DEBITOR_TYPE,INV_AMT,INV_KID,ID_CN_NO,FLG_BATCH_INV,FLG_TRANS_TO_ACC,CREATED_BY,DT_CREATED ,                                  
 ID_WODET_SEQ,                                
 WO_VEH_REG_NO  ,WO_VEH_HRS, TRANSFERREDVAT,                        
 TRANSFERREDFROMCUSTID,                        
 TRANSFERREDFROMCUSTName,                        
 VATAMOUNT,                        
 DEB_VAT_PER                                          
  FROM                                   
 @INVOICENONBATCHINVOICE                                   
  WHERE                                  
  FLG_BATCH_INV = 'FALSE'                                   
                                   
                        
                                   
  SELECT                             
 A.ID_INV_NO,ID_WODET_SEQ,WO_VEH_REG_NO,                                   
 WO_JOB_TXT,                                  
 @IV_CREATEDBY,GETDATE ()FROM TBL_INV_HEADER A                                  
 LEFT OUTER JOIN @INVOICETEMP1 B                                  
 ON A.ID_DEBITOR = B.ID_DEBITOR                                   
  WHERE                                  
 A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                                  
                                   
                                    
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @INVOICETEMP1',getdate(),10,@NEW_GUID)                                      
                           
  --select 'test1',* from @INVOICETEMP1                                  
                                    
 --CODING TO INSERT INTO THETBL_INV_DETAIL                                  
  declare @idjob as int                                  
  set @idjob = 0                                  
  SELECT @idjob =                                  
 case when ID_WODET_SEQ is not null then                                  
 (SELECT ID_JOB FROM TBL_WO_DETAIL where ID_WODET_SEQ = b.ID_WODET_SEQ)                                  
 else 0                                  
 end                                  
  FROM TBL_INV_HEADER A                                  
 LEFT OUTER JOIN @INVOICETEMP1 B                                  
 ON A.ID_DEBITOR = B.ID_DEBITOR                                   
 WHERE                                  
 A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                        
                         
         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert TBL_INV_DETAIL',getdate(),11,@NEW_GUID)             
                                   
  --print cast(@idjob as char(2))                                   
 --select * into ##INVOICETEMP1 from @INVOICETEMP1                                   
 --print 'tesing'                                  
                                 
 INSERT INTO                                  
 TBL_INV_DETAIL                                   
 (ID_INV_NO,                          
  ID_WODET_INV,                                   
  VEH_REG_NO,                          
  WO_VEH_HRS,                                
  WO_JOB_TXT,                                  
  CREATED_BY,             
  DT_CREATED,ID_WO_NO,ID_WO_PREFIX,ID_JOB,                                  
  INVD_GM_ACCCODE,INVD_GM_VAT,INVD_VAT_ACCOUNTCODE,                                  
  INVD_VAT_PERCENTAGE,WO_VEH_MILEAGE                                
 ,WO_ANNOT                         
 ,INVD_FIXEDAMT                        
 ,OWNERPAYVATJOB                        
 ,OWNERPAYVAT                        
 ,OWNPAYVAT1                        
 ,TOTALAMOUNT                        
 ,BARCODE                        
 ,PRICE                        
 ,VAT_LABOUR                        
 ,VEHICLEOWNERID                        
 ,OWNERNAME                        
 ,GARAGEMATERIALAMT                        
 ,OWNRISKAMOUNT                        
 ,OWNRISKVAT                        
 ,DELDQTY_TIME                        
 ,LABOUR_DISCOUNT                        
 ,GM_DISCOUNT             
 ,VAT_GM                        
 ,FIXEDAMT                        
 ,VAT_FIXED                        
 ,IN_DEB_JOB_AMT
 ,WO_TYPE_WOH            
 )                                  
 SELECT                          
 A.ID_INV_NO,B.ID_WODET_SEQ,B.WO_VEH_REG_NO, B.WO_VEH_HRS,                                  
 B.WO_JOB_TXT,                                  
 @IV_CREATEDBY,GETDATE (),B.ID_WO_no,B.ID_WO_PREFIX,                                  
 case when B.ID_WODET_SEQ is not null then                                  
  DET.ID_JOB                                  
 else                         
  0                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material Account Code                                   
  isnull(DET.WO_GM_ACCCODE,'')                        
 else                         
  ''                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material VAT Code                                   
  isnull(DET.WO_GM_VAT,'')                         
 else                         
  ''                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material VAT Account Code                                   
  isnull(DET.WO_VAT_ACCCODE,'')                         
 else                         
  ''                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material VAT Percentage                                   
  isnull(DET.WO_VAT_PERCENTAGE,0)                        
 else                         
  0                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Inserting Milage Value                                   
  WOH.WO_VEH_MILEAGE                         
 else                         
  0                                   
 end,                               
 case when B.ID_WODET_SEQ is not null then --for Inserting Milage Value                       
  WOH.WO_ANNOT                         
 else                         
  ''                                  
 end,                                   
 case when B.ID_WODET_SEQ is not null then --for Inserting Milage Value                                  
DET.WO_FIXED_PRICE                         
 else                   
  0                                  
 end,                        
 CASE WHEN ISNULL(DET.WO_OWN_PAY_VAT,0)=1 OR ABS(ISNULL(DET.WO_OWN_RISK_AMT,0))>0 THEN                        
  1                        
 ELSE                        
  0                        
 END AS OWNERPAYVATJOB,                        
 CASE WHEN ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN                        
  1                        
 ELSE                        
  0                        
 END                        
 AS   OWNERPAYVAT,                        
 CASE WHEN ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN                        
  1                        
 ELSE                        
  0                        
 END                        
 AS   OWNPAYVAT1,             
DBINVOR.JOBSUM            
 AS TOTALAMOUNT,                        
 dbo.FN_BARCODE_ENCODE(WOH.ID_WO_PREFIX +';'+ WOH.ID_WO_NO + ';' + cast(isnull(DET.ID_JOB,'0') as varchar(10)))  AS BARCODE,                        
 0 AS PRICE,                        
 0 AS VAT_LABOUR,                        
 (SELECT ID_CUSTOMER_VEH FROM TBL_MAS_VEHICLE VEH WHERE WOH.ID_VEH_SEQ_WO= VEH.ID_VEH_SEQ) AS VEHICLEOWNERID,                        
 (SELECT CUST_NAME FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER IN (SELECT ID_CUSTOMER_VEH FROM TBL_MAS_VEHICLE VEH WHERE WOH.ID_VEH_SEQ_WO= VEH.ID_VEH_SEQ)) AS OWNERNAME,                        
0 AS GARAGEMATERIALAMT,                        
 ISNULL(DBINVOR.LINE_AMOUNT_NET,0)                       
 AS OWNRISKAMOUNT,                        
 ISNULL(DBINVOR.LINE_VAT_AMOUNT,0)                       
 AS OWNRISKVAT,                        
 DET.WO_CHRG_TIME AS DELDQTY_TIME,                        
 0 AS LABOUR_DISCOUNT,                        
 0 AS GM_DISCOUNT,                        
 0 AS VAT_GM,                        
 0 AS FIXEDAMT,                        
 0 AS VAT_FIXED,                        
 0 AS IN_DEB_JOB_AMT,
 WOH.WO_TYPE_WOH AS WO_TYPE_WOH            
  FROM TBL_INV_HEADER A                                  
 LEFT OUTER JOIN @INVOICETEMP1 B                                  
  ON A.ID_DEBITOR = B.ID_DEBITOR                        
 LEFT OUTER JOIN TBL_WO_DETAIL DET                        
  ON B.ID_WODET_SEQ=DET.ID_WODET_SEQ                        
 LEFT OUTER JOIN TBL_WO_HEADER WOH                        
  ON WOH.ID_WO_NO = b.ID_WO_NO AND WOH.ID_WO_PREFIX = b.ID_WO_PREFIX                        
 LEFT OUTER JOIN TBL_WO_DEBITOR_DETAIL DBDET                        
  ON DBDET.ID_WO_NO=DET.ID_WO_NO AND DBDET.ID_WO_PREFIX=DET.ID_WO_PREFIX AND DBDET.ID_JOB_ID=DET.ID_JOB AND A.ID_DEBITOR=DBDET.ID_JOB_DEB                        
 --LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBINV                        
 -- ON DBINV.DEBTOR_SEQ = DBDET.ID_DBT_SEQ AND DBINV.LINE_TYPE='LABOUR'                            
 --LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBINVGM                        
 -- ON DBINVGM.DEBTOR_SEQ = DBDET.ID_DBT_SEQ AND DBINVGM.LINE_TYPE='GM'               
 LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBINVOR                     
  ON DBINVOR.DEBTOR_SEQ = DBDET.ID_DBT_SEQ AND DBINVOR.LINE_TYPE='OWNRISK'                                  
 WHERE                                   
 A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                                  
  and B.FLG_BATCH_INV = 'TRUE'                         
  AND A.FLG_BATCH_INV = 'TRUE'            
                     
                                     
 INSERT INTO                                   
 TBL_INV_DETAIL                                  
 (ID_INV_NO,                                  
  ID_WODET_INV,                                  
  VEH_REG_NO,                              
  WO_JOB_TXT,                                  
  CREATED_BY,                                  
  DT_CREATED,ID_WO_NO,ID_WO_PREFIX,ID_JOB,                                  
 INVD_GM_ACCCODE,INVD_GM_VAT,INVD_VAT_ACCOUNTCODE,                                  
  INVD_VAT_PERCENTAGE,WO_VEH_MILEAGE                          
 ,WO_ANNOT                                    
 ,INVD_FIXEDAMT                   
 ,OWNERPAYVATJOB                        
 ,OWNERPAYVAT                        
 ,OWNPAYVAT1                        
 ,TOTALAMOUNT                        
 ,BARCODE                        
 ,PRICE                       
 ,VAT_LABOUR                        
 ,VEHICLEOWNERID                        
 ,OWNERNAME                        
 ,GARAGEMATERIALAMT                        
 ,OWNRISKAMOUNT                        
 ,OWNRISKVAT                        
 ,DELDQTY_TIME                        
 ,LABOUR_DISCOUNT                        
 ,GM_DISCOUNT                        
 ,VAT_GM                        
 ,FIXEDAMT                        
 ,VAT_FIXED                        
 ,IN_DEB_JOB_AMT 
 ,WO_TYPE_WOH            
 )                                  
 SELECT                      
  A.ID_INV_NO,B.ID_WODET_SEQ,B.WO_VEH_REG_NO,                                  
 --ID_INV_NO,ID_WODET_SEQ,WO_VEH_REG_NO,                                   
 B.WO_JOB_TXT,                                  
 @IV_CREATEDBY,GETDATE (),B.ID_WO_no,B.ID_WO_PREFIX,                                 case when B.ID_WODET_SEQ is not null then                                  
  DET.ID_JOB                        
 else                         
  0                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material Account Code                                   
  isnull(DET.WO_GM_ACCCODE,'')                         
 else                         
  ''                                  
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material VAT Code                                   
  isnull(DET.WO_GM_VAT,'')                         
 else                         
  ''                                   
 end,                               
 case when B.ID_WODET_SEQ is not null then --for Garage Material VAT Account Code                                   
  isnull(DET.WO_VAT_ACCCODE,'')                         
 else                         
  ''                                   
 end,                                  
 case when B.ID_WODET_SEQ is not null then --for Garage Material VAT Percentage                                  
  isnull(DET.WO_VAT_PERCENTAGE,0)                        
 else                         
  0                                
 end,                           
 case when B.ID_WODET_SEQ is not null then --for Inserting Milage Value                                   
  WOH.WO_VEH_MILEAGE                         
 else                         
  0                                   
 end,                                   
 case when B.ID_WODET_SEQ is not null then --for Inserting Milage Value                                   
  WOH.WO_ANNOT                         
 else                         
  ''                                  
 end,                                   
 case when B.ID_WODET_SEQ is not null then --for Inserting Milage Value                                  
  DET.WO_FIXED_PRICE                         
 else                         
  0                                  
 end,                        
 CASE WHEN ISNULL(DET.WO_OWN_PAY_VAT,0)=1 OR ABS(ISNULL(DET.WO_OWN_RISK_AMT,0))>0 THEN                        
  1                        
 ELSE                        
  0                        
 END AS OWNERPAYVATJOB,                        
 CASE WHEN ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN           
  1                        
 ELSE                        
  0                        
 END                        
 AS   OWNERPAYVAT,                        
 CASE WHEN ISNULL(DET.WO_OWN_PAY_VAT,0)=1 THEN                        
  1                        
 ELSE                        
  0                        
 END                        
 AS   OWNPAYVAT1,                        
 --CASE WHEN ISNULL(DET.WO_FIXED_PRICE,0)<>0 THEN                         
 -- DBINV.FIXED_PRICE+DBINV.FIXED_PRICE_VAT                        
 --ELSE                         
 -- DBINV.LINE_AMOUNT_NET -- -DBINV.LINE_DISCOUNT                         
 --END                        
 --AS TOTALAMOUNT,                     
 0 AS TOTALAMOUNT,                       
 dbo.FN_BARCODE_ENCODE(WOH.ID_WO_PREFIX +';'+ WOH.ID_WO_NO + ';' + cast(isnull(DET.ID_JOB,'0') as varchar(10)))  AS BARCODE,                        
 --DBINV.PRICE AS PRICE,                     
 0 AS PRICE,                       
 --DBINV.LINE_VAT_AMOUNT AS VAT_LABOUR,                     
 0 AS  VAT_LABOUR ,                     
 (SELECT ID_CUSTOMER_VEH FROM TBL_MAS_VEHICLE VEH WHERE WOH.ID_VEH_SEQ_WO= VEH.ID_VEH_SEQ) AS VEHICLEOWNERID,                      
 (SELECT CUST_NAME FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER IN (SELECT ID_CUSTOMER_VEH FROM TBL_MAS_VEHICLE VEH WHERE WOH.ID_VEH_SEQ_WO= VEH.ID_VEH_SEQ)) AS OWNERNAME,                        
                     
 --DBINVGM.LINE_AMOUNT_NET-DBINVGM.LINE_DISCOUNT AS GARAGEMATERIALAMT,                     
 0 AS GARAGEMATERIALAMT,                    
 --CASE WHEN DET.WO_OWN_CR_CUST=DBDET.ID_JOB_DEB THEN                         
 -- ISNULL(DET.WO_OWN_RISK_AMT,0)                         
 --ELSE                        
 -- -1 * ISNULL(DET.WO_OWN_RISK_AMT,0) *0.01*DBDET.DBT_PER                           
 --END                        
 --AS OWNRISKAMOUNT,                     
 ISNULL(DBINVOR.LINE_AMOUNT_NET,0) AS OWNRISKAMOUNT,                       
 --CASE WHEN DET.WO_OWN_CR_CUST=DBDET.ID_JOB_DEB THEN                         
 -- ISNULL(DET.OwnRiskVATAmt,0)                         
 --ELSE                        
 -- -1 * ISNULL(DET.OwnRiskVATAmt,0)                           
 --END                         
 --AS OWNRISKVAT,                     
 ISNULL(DBINVOR.LINE_VAT_AMOUNT,0) AS OWNRISKVAT,                       
 DET.WO_CHRG_TIME AS DELDQTY_TIME,                        
 --DBINV.LINE_DISCOUNT AS LABOUR_DISCOUNT,                     
 0 AS LABOUR_DISCOUNT,                       
 --DBINVGM.LINE_DISCOUNT AS GM_DISCOUNT,                     
 0 AS GM_DISCOUNT,                      
 --DBINVGM.LINE_VAT_AMOUNT AS VAT_GM,                     
 0 AS VAT_GM,                      
 --DBINV.FIXED_PRICE AS FIXEDAMT,                    
 0 AS FIXEDAMT,                        
 --DBINV.FIXED_PRICE_VAT AS VAT_FIXED,                    
 0 AS  VAT_FIXED,                      
 ISNULL(DBDET.JOB_TOTAL,0) - ISNULL(DBDET.JOB_VAT_AMOUNT,0) AS IN_DEB_JOB_AMT,
 WOH.WO_TYPE_WOH AS WO_TYPE_WOH
 --FROM @INVOICETEMP1 B where B.FLG_BATCH_INV = 'false'         
 FROM TBL_INV_HEADER A                                  
 LEFT OUTER JOIN @INVOICETEMP1 B                                  
  ON A.ID_INV_NO = B.ID_INV_NO   --AND  A.ID_DEBITOR = B.ID_DEBITOR                                
 LEFT OUTER JOIN TBL_WO_DETAIL DET                        
  ON B.ID_WODET_SEQ=DET.ID_WODET_SEQ                        
 LEFT OUTER JOIN TBL_WO_HEADER WOH                        
  ON WOH.ID_WO_NO = b.ID_WO_NO AND WOH.ID_WO_PREFIX = b.ID_WO_PREFIX                        
 LEFT OUTER JOIN TBL_WO_DEBITOR_DETAIL DBDET                        
  ON DBDET.ID_WO_NO=DET.ID_WO_NO AND DBDET.ID_WO_PREFIX=DET.ID_WO_PREFIX AND DBDET.ID_JOB_ID=DET.ID_JOB                         
  AND A.ID_DEBITOR=DBDET.ID_JOB_DEB  --- AND A.ID_DEBITOR=DBDET.ID_JOB_DEB  'Batch-NonBatch Invoice Issue                        
 --LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBINV                        
 -- ON DBINV.DEBTOR_SEQ = DBDET.ID_DBT_SEQ AND DBINV.LINE_TYPE='LABOUR'                            
 --LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBINVGM                        
 -- ON DBINVGM.DEBTOR_SEQ = DBDET.ID_DBT_SEQ AND DBINVGM.LINE_TYPE='GM'                              
 LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DBINVOR                       
  ON DBINVOR.DEBTOR_SEQ = DBDET.ID_DBT_SEQ AND DBINVOR.LINE_TYPE='OWNRISK'          
 WHERE                                   
 A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
  and                         
  B.FLG_BATCH_INV = 'FALSE'                         
 AND A.FLG_BATCH_INV = 'FALSE'                   
                     
                     
                     
  SELECT SUM(LINE_AMOUNT)AS LABOURSUM,SUM(LINE_DISCOUNT)AS LABOURDISCSUM,SUM(LINE_VAT_AMOUNT)AS LABOURVATSUM, DBINV.ID_WO_NO,DBINV.ID_WO_PREFIX,ID_JOB_ID,DEBTOR_ID,WOHEAD.WO_TYPE_WOH                        
  INTO #LABOURSUM                        
  FROM TBL_WO_DEBTOR_INVOICE_DATA DBINV                      
  INNER JOIN @INVOICETEMP TEMP                    
  ON TEMP.ID_WO_NO = DBINV.ID_WO_NO AND TEMP.ID_WO_PREFIX = DBINV.ID_WO_PREFIX              
  AND TEMP.ID_JOB = DBINV.ID_JOB_ID            
  INNER JOIN TBL_WO_HEADER WOHEAD            
  ON WOHEAD.ID_WO_NO = TEMP.ID_WO_NO AND WOHEAD.ID_WO_PREFIX = TEMP.ID_WO_PREFIX   --new add                
  WHERE DBINV.LINE_TYPE = 'LABOUR'                    
 GROUP BY DBINV.DEBTOR_ID,DBINV.ID_WO_NO,DBINV.ID_WO_PREFIX,DBINV.ID_JOB_ID,WOHEAD.WO_TYPE_WOH                         
                         
                         
  SELECT SUM(LINE_AMOUNT)AS GARAAGEMATSUM,SUM(LINE_DISCOUNT)AS GARAGEDISCSUM,SUM(LINE_VAT_AMOUNT)AS GARAGEVATSUM, DBINV.ID_WO_NO,DBINV.ID_WO_PREFIX,ID_JOB_ID,DEBTOR_ID,WOHEAD.WO_TYPE_WOH                         
  INTO #GARAGEMATSUM                        
  FROM TBL_WO_DEBTOR_INVOICE_DATA DBINV                      
  INNER JOIN @INVOICETEMP TEMP                    
  ON TEMP.ID_WO_NO = DBINV.ID_WO_NO AND TEMP.ID_WO_PREFIX = DBINV.ID_WO_PREFIX              
    AND TEMP.ID_JOB = DBINV.ID_JOB_ID              
   INNER JOIN TBL_WO_HEADER WOHEAD            
  ON WOHEAD.ID_WO_NO = TEMP.ID_WO_NO AND WOHEAD.ID_WO_PREFIX = TEMP.ID_WO_PREFIX   --new add                    
  WHERE DBINV.LINE_TYPE = 'GM'                    
 GROUP BY DBINV.DEBTOR_ID,DBINV.ID_WO_NO,DBINV.ID_WO_PREFIX ,DBINV.ID_JOB_ID,WOHEAD.WO_TYPE_WOH                     
                     
        
 --Commented to check---       
            
 --UPDATE INVDATA                           
 --SET TOTALAMOUNT =  ISNULL(INVDATA.WO_TYPE_FACTOR,0) * LABSUM.LABOURSUM,                    
 --PRICE =  ISNULL(INVDATA.WO_TYPE_FACTOR,0) * LABSUM.LABOURSUM,                    
 --VAT_LABOUR = ISNULL(INVDATA.WO_TYPE_FACTOR,0) * LABSUM.LABOURVATSUM,                    
 --LABOUR_DISCOUNT = ISNULL(INVDATA.WO_TYPE_FACTOR,0) * LABSUM.LABOURDISCSUM                         
 --FROM TBL_INV_DETAIL INVDATA                           
 --INNER JOIN  #LABOURSUM LABSUM                          
 --ON INVDATA.ID_WO_NO = LABSUM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = LABSUM.ID_WO_PREFIX                           
 --AND INVDATA.VEHICLEOWNERID = LABSUM.DEBTOR_ID  AND INVDATA.ID_JOB = LABSUM.ID_JOB_ID                         
                     
                     
 --UPDATE INVDATA                            
 --SET GARAGEMATERIALAMT =  ISNULL(INVDATA.WO_TYPE_FACTOR,0) * GMSUM.GARAAGEMATSUM,                    
 --VAT_GM = ISNULL(INVDATA.WO_TYPE_FACTOR,0) * GMSUM.GARAGEVATSUM,                    
 --GM_DISCOUNT = ISNULL(INVDATA.WO_TYPE_FACTOR,0) * GMSUM.GARAGEDISCSUM                        
 --FROM TBL_INV_DETAIL INVDATA                           
 --INNER JOIN  #GARAGEMATSUM GMSUM                          
 --ON INVDATA.ID_WO_NO = GMSUM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = GMSUM.ID_WO_PREFIX                           
 --AND INVDATA.VEHICLEOWNERID = GMSUM.DEBTOR_ID  AND INVDATA.ID_JOB = GMSUM.ID_JOB_ID             
            
  --Commented to check---                   
               
                                 
  SELECT                                   
  TEMPA.ID_INV_NO,ID_WODET_SEQ,WO_VEH_REG_NO,                                   
  WO_JOB_TXT,                                  
  @IV_CREATEDBY,GETDATE ()                                  
 FROM @INVOICETEMP1 TEMPA,TBL_INV_HEADER B                                  
 WHERE TEMPA.ID_DEBITOR = B.ID_DEBITOR                                   
  ORDER BY B.DT_CREATED DESC              
              
                          
 --select 2                                  
 IF @@ERROR <> 0                
 BEGIN                                   
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                  
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                  
 END                                   
                         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert TBL_INV_DETAIL',getdate(),11,@NEW_GUID)                                      
                        
   --select '@INVOICETEMP1,* from TBL_INV_DETAIL where ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                        
                                   
  --CODING TO INSERT IN TO TBL_INV_DETAIL_LINES                                  
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert @TEMP_TBL_INV_HEADER',getdate(),12,@NEW_GUID)                                      
                                                   
 --FIRST INSERT INTO THE TBL_INV_DETAIL_LINES BASED UPON THE ITEM                                  
--CREATE ONE TEMP TABLE SIMILAR TO TBL_INV_HEADER                                   
 -- ADD IT FROM THE TEMP TABLE                                  
  DECLARE @TEMP_TBL_INV_HEADER TABLE                                  
  (                                   
  ID_INV_NO VARCHAR(10),                                  
 ID_DEPT_INV INT,                                  
  ID_SUBSIDERY_INV INT,                                   
  DT_INVOICE DATETIME,                                   
  DEBITOR_TYPE CHAR(1),                                   
  ID_DEBITOR VARCHAR(10),                                  
  INV_AMT DECIMAL,                                  
  INV_KID VARCHAR(25),                                   
  ID_CN_NO VARCHAR(15),                                   
  FLG_BATCH_INV BIT,                                  
  FLG_TRANS_TO_ACC BIT,                                  
  CREATED_BY VARCHAR(20),                                  
  DT_CREATED DATETIME,                                  
  MODIFIED_BY VARCHAR(20),                                  
  DT_MODIFIED DATETIME,                                  
  ID_WODET_SEQ INT                                  
  )                                   
                                   
  INSERT INTO @TEMP_TBL_INV_HEADER                              
  (                                  
  ID_DEBITOR,                                  
  ID_INV_NO,                                  
  ID_DEPT_INV,                                  
  ID_SUBSIDERY_INV,                  
  DT_INVOICE,                                  
  DEBITOR_TYPE,                                  
  INV_AMT,                                  
  INV_KID,                                   
  ID_CN_NO,                                  
  FLG_BATCH_INV,                                   
  FLG_TRANS_TO_ACC,                                  
  CREATED_BY,                                  
  DT_CREATED,                                  
  ID_WODET_SEQ                                   
  )                                  
  SELECT                                   
  DISTINCT B.ID_DEBITOR,A.ID_INV_NO,                                  
  B.ID_DEPT_INV,B.ID_SUBSIDERY_INV,                                  
  B.DT_INVOICE,B.DEBITOR_TYPE,B.INV_AMT,B.INV_KID,                                  
  B.ID_CN_NO,B.FLG_BATCH_INV,B.FLG_TRANS_TO_ACC,B.CREATED_BY,B.DT_CREATED,B.ID_WODET_SEQ                                 
  FROM                                   
 TBL_INV_HEADER A                                  
 LEFT OUTER JOIN @INVOICETEMP1 B                                  
 ON A.ID_DEBITOR = B.ID_DEBITOR --AND A.ID_INV_NO = B.ID_INV_NO                                  
 WHERE                       
 B.FLG_BATCH_INV = 'TRUE'                                   
 AND A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
                                    
 IF @@ERROR <> 0                                  
 BEGIN                                   
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                  
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                     
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                   
 END                                  
                                    
 --CODING FOR NON BATCH INVOICE                                   
 INSERT INTO @TEMP_TBL_INV_HEADER                                  
 (                                  
 ID_DEBITOR,                                  
 ID_INV_NO,                                   
 ID_DEPT_INV,                                   
 ID_SUBSIDERY_INV,                                  
 DT_INVOICE,                                  
  DEBITOR_TYPE,                                  
 INV_AMT,                                  
 INV_KID,                                  
 ID_CN_NO,                                  
 FLG_BATCH_INV,                                  
 FLG_TRANS_TO_ACC,                                  
 CREATED_BY,                     
 DT_CREATED ,                                  
 ID_WODET_SEQ                                  
 )                                  
 SELECT                                   
 B.ID_DEBITOR,A.ID_INV_NO,                                  
 B.ID_DEPT_INV,B.ID_SUBSIDERY_INV,                                  
 B.DT_INVOICE,B.DEBITOR_TYPE,B.INV_AMT,B.INV_KID,                                  
 B.ID_CN_NO,B.FLG_BATCH_INV,B.FLG_TRANS_TO_ACC,B.CREATED_BY,B.DT_CREATED,B.ID_WODET_SEQ                                   
 FROM TBL_INV_HEADER A                                  
  LEFT OUTER JOIN @INVOICETEMP1 B                                  
  ON A.ID_DEBITOR = B.ID_DEBITOR                          
  AND  A.ID_INV_NO = B.ID_INV_NO    --636                            
  WHERE                                  
 B.FLG_BATCH_INV = 'FALSE'                                   
 AND A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                                  
                        
                                   
  IF @@ERROR <> 0                   
  BEGIN                                   
  ROLLBACK TRANSACTION @TRANNAME                                  
  SET @OV_RETVALUE = 'INSFLG'                                  
   IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
  RETURN                                   
  END                          
                         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert @TEMP_TBL_INV_HEADER',getdate(),12,@NEW_GUID)                                      
   INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert TBL_INV_DETAIL_LINES',getdate(),13,@NEW_GUID)                                      
                        
  INSERT INTO TBL_INV_DETAIL_LINES                                   
  (                                  
  ID_INV_NO,                                  
  ID_WODET_INVL,                                  
  FLG_ITEM,                                   
  ID_WOITEM_SEQ,                                  
  ID_WH_INVL,                                  
ID_ITEM_INVL,                                  
  --ADDED VMSSANTHOSH 07-MAY-2008                                  
  ID_MAKE,                                  
  ID_WAREHOUSE,                                  
  --ADDED END                                  
  INVL_DESCRIPTION,                       
  INVL_AVERAGECOST,                                   
  INVL_DELIVER_QTY,                                  
  INVL_PRICE,                                  
  INVL_DIS,                                  
  --INVL_VAT,                                  
  INVL_DEB_CONTRIB,                                  
  CREATED_BY,                
  DT_CREATED ,                                  
  INVL_LINETYPE, --Newly added for Spares                                  
  INVL_VAT_ACCCODE,                                   
  INVL_VAT_CODE,                                  
  INVL_VAT_PER,                                  
  INVL_SPARES_ACCOUNTCODE,                                  
  INVL_BFAMOUNT,                                  
  INVL_AMOUNT,                                  
  INVL_VAT,                        
  TOTALAMOUNT,                        
  LINE_TYPE,                        
  SPAREPARTNAME,                        
  PRICE,                        
  DISCOUNT,                        
  QTYNOTDELIVERED,                        
  ORDEREDQTY,                        
  VATAMOUNT                                  
  )                                  
 SELECT                                   
  DISTINCT                                   
 TEMPA.ID_INV_NO,TEMPA.ID_WODET_SEQ,'TRUE',                                  
 JODBETAIL.ID_WOITEM_SEQ,NULL,JODBETAIL.ID_ITEM_JOB,                                  
 --ADDED VMSSANTHOSH 07-MAY-2008                                  
 JODBETAIL.ID_MAKE_JOB,                                 
 JODBETAIL.ID_WAREHOUSE,                                  
 --ADDED END                                   
  case when JODBETAIL.ID_ITEM_JOB is not null then                                  
 (select ITEM_DESC from TBL_MAS_ITEM_MASTER where ID_ITEM = JODBETAIL.ID_ITEM_JOB AND TBL_MAS_ITEM_MASTER.ID_MAKE = JODBETAIL.ID_MAKE_JOB AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM = JODBETAIL.ID_WAREHOUSE)                                  
  else ''                                  
  end ,                                  
 case when JODBETAIL.ID_ITEM_JOB is not null then                                  
 --(select ISNULL(COST_PRICE1,0) from TBL_MAS_ITEM_MASTER where ID_ITEM = JODBETAIL.ID_ITEM_JOB AND TBL_MAS_ITEM_MASTER.ID_MAKE = JODBETAIL.ID_MAKE_JOB AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM = JODBETAIL.ID_WAREHOUSE)                                   
  ISNULL(JODBETAIL.JOBI_COST_PRICE,0)                                 
  else 0                                  
  end                        
  ,JODBETAIL.JOBI_DELIVER_QTY,                        
 CASE WHEN CUST.costprice >0 AND JODBETAIL.SPARE_TYPE<>'EFD' and ISNULL(JODBETAIL.FLG_EDIT_SP,0) = 0                        
 THEN                        
     (ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))                        
    ELSE                        
      DEBINV.PRICE                      
    END                        
   ,                         
 --JODBETAIL.JOBI_DIS_PER,                      
 DEBINV.DISC_PERCENT,                                
 DEBITORDETAIL.DBT_PER,                               
 @IV_CREATEDBY,GETDATE() ,'Spares' ,JOB_VAT_ACCCODE,                                  
  JOB_VAT,                             
 --JODBETAIL.JOBI_VAT_PER,                       
 DEBINV.LINE_VAT_PERCENTAGE ,                      
 job_spares_accountcode,                                  
                          
  case when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE <>0 and                                  
 JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY <> 0) then                                   
 CASE WHEN CUST.costprice >0 AND JODBETAIL.SPARE_TYPE<>'EFD' and ISNULL(JODBETAIL.FLG_EDIT_SP,0) = 0                        
 THEN                        
            ((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0))                        
    else                        
           JODBETAIL.JOBI_SELL_PRICE* JODBETAIL.JOBI_DELIVER_QTY                          
    end                                  
  else 0                                  
  end ,                        
 --DEBINV.LINE_AMOUNT_NET,                                  
  case when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE <>0 and                         
 JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY <>0) then                         
 CASE WHEN CUST.costprice >0 AND JODBETAIL.SPARE_TYPE<>'EFD' and ISNULL(JODBETAIL.FLG_EDIT_SP,0) = 0                        
 THEN                           
                                   
  ( (((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0))* 0.01  * DEBITORDETAIL.DBT_PER )                          
 -((((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0)) * 0.01  * DEBITORDETAIL.DBT_PER)                          
 *(0.01 * JODBETAIL.JOBI_DIS_PER) )                           
 )                                   
  + ( (((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0))* 0.01  * DEBITORDETAIL.DBT_PER -((((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0)) * 0.01  * DEBITORDETAIL.DBT_PER)                                  
 *(0.01 * JODBETAIL.JOBI_DIS_PER) ))* (0.01 * ISNULL(JOBI_VAT_PER,0)) )                         
 else                        
                                    
  ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER )                          
 -((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER)                          
 *(0.01 * JODBETAIL.JOBI_DIS_PER) )                           
 )                                   
  + ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER -((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER)                                  
 *(0.01 * JODBETAIL.JOBI_DIS_PER) ))* (0.01 * ISNULL(JOBI_VAT_PER,0)) )                         
 end                        
                         
                                   
 when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE <>0 and                                  
 isnull(WOJDD.DBT_DIS_PER,0) = 0 and                                  
 JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY >0) then                         
 CASE WHEN CUST.costprice >0 AND JODBETAIL.SPARE_TYPE<>'EFD' and ISNULL(JODBETAIL.FLG_EDIT_SP,0) = 0                        
 THEN                                 
 (((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0))* 0.01  * DEBITORDETAIL.DBT_PER)                                   
 + ( (((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0)) * 0.01  * DEBITORDETAIL.DBT_PER )* (0.01 * ISNULL(JOBI_VAT_PER,0)) )                         
 else                        
  (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER)                                   
 + ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER )* (0.01 * ISNULL(JOBI_VAT_PER,0)) )                        
 end                        
                                   
  else 0                                  
  end                        
 --CASE WHEN DEBITORDETAIL.DBT_PER >0                        
 -- THEN                        
 -- (DEBINV.LINE_AMOUNT*(100/DEBITORDETAIL.DBT_PER))+(DEBINV.LINE_VAT_AMOUNT*(100/DEBITORDETAIL.DBT_PER))                        
 -- ELSE                        
 -- (DEBINV.LINE_AMOUNT)+(DEBINV.LINE_VAT_AMOUNT)                        
 -- END                        
 ,                        
                                   
 case                         
  when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE <> 0                         
   and DEBITORDETAIL.WO_SPR_DISCPER is not null                         
   and DEBITORDETAIL.WO_SPR_DISCPER >= 0                         
   and DEBITORDETAIL.WO_VAT_PERCENTAGE is not null                         
   and DEBITORDETAIL.WO_VAT_PERCENTAGE >= 0                         
   and JODBETAIL.JOBI_DELIVER_QTY is not null                         
   and JODBETAIL.JOBI_DELIVER_QTY <> 0                         
   AND JODBETAIL.JOBI_SELL_PRICE is not null                         
   and JODBETAIL.JOBI_SELL_PRICE <>0                         
   and DEBITORDETAIL.WO_VAT_PERCENTAGE is not null                         
   and DEBITORDETAIL.WO_VAT_PERCENTAGE > 0                         
   and JODBETAIL.JOBI_DELIVER_QTY is not null                         
   and JODBETAIL.JOBI_DELIVER_QTY <> 0)                         
  then                             
  --(((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY) - (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * JODBETAIL.JOBI_DIS_PER)) * (0.01  * DEBITORDETAIL.DBT_PER)) * (0.01 * JODBETAIL.JOBI_VAT_PER)                        
    CASE WHEN CUST.costprice >0 AND JODBETAIL.SPARE_TYPE<>'EFD' and ISNULL(JODBETAIL.FLG_EDIT_SP,0) = 0                        
             THEN             
     ((( ((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0))                        
             ) - (((ISNULL(JODBETAIL.JOBI_COST_PRICE,0)+(Isnull(JODBETAIL.JOBI_COST_PRICE,0)*ISNULL((CUST.costprice)/100,0)))*ISNULL(JODBETAIL.JOBI_DELIVER_QTY,0))                        
           * 0.01  * JODBETAIL.JOBI_DIS_PER)) * (0.01  * DEBITORDETAIL.DBT_PER)) * (0.01 * JODBETAIL.JOBI_VAT_PER)                        
     else                        
  (((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY) - (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * JODBETAIL.JOBI_DIS_PER)) * (0.01  * DEBITORDETAIL.DBT_PER)) * (0.01 * JODBETAIL.JOBI_VAT_PER)                        
                        
     end                        
  else 0                                  
  end ,                        
 --DEBINV.LINE_VAT_AMOUNT,                        
  DEBINV.LINE_AMOUNT_NET,                        
  case when JODBETAIL.[TEXT] <> '' and JODBETAIL.[TEXT] is not null then                        
  'TEXT'                        
  ELSE                        
  'SPAREPART'                        
  END,                        
  JODBETAIL.ITEM_DESC,                        
  DEBINV.PRICE,                        
  DEBINV.LINE_DISCOUNT,                        
  JODBETAIL.JOBI_ORDER_QTY - JODBETAIL.JOBI_DELIVER_QTY,                        
  JODBETAIL.JOBI_ORDER_QTY,                        
  DEBINV.LINE_VAT_AMOUNT                         
                                    
  FROM                         
 @TEMP_TBL_INV_HEADER TEMPA,TBL_WO_DETAIL WODETAIL                                 
 INNER JOIN                                   
 TBL_WO_JOB_DETAIL JODBETAIL ON                                   
 WODETAIL.ID_WODET_SEQ = JODBETAIL.ID_WODET_SEQ_JOB                                  
 LEFT OUTER JOIN                                  
 TBL_WO_DEBITOR_DETAIL DEBITORDETAIL ON                                  
 WODETAIL.ID_WO_NO = DEBITORDETAIL.ID_WO_NO AND                                   
 WODETAIL.ID_WO_PREFIX = DEBITORDETAIL.ID_WO_PREFIX AND                               
 WODETAIL.ID_JOB = DEBITORDETAIL.ID_JOB_ID                                   
 LEFT OUTER JOIN TBL_WO_JOB_DEBITOR_DISCOUNT WOJDD ON                                   
 WODETAIL.ID_WO_NO = WOJDD.ID_WO_NO AND                                   
 WODETAIL.ID_WO_PREFIX = WOJDD.ID_WO_PREFIX AND                                   
 WODETAIL.ID_JOB = WOJDD.ID_JOB_ID AND                                  
 DEBITORDETAIL.ID_JOB_DEB=WOJDD.ID_DEB AND                                  
 JODBETAIL.ID_ITEM_JOB = WOJDD.ID_ITEM_JOB                            
 LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINV ON                        
 DEBINV.DEBTOR_SEQ = DEBITORDETAIL.ID_DBT_SEQ and                        
 DEBINV.ID_WO_NO = DEBITORDETAIL.ID_WO_NO and                        
 DEBINV.ID_WO_PREFIX= DEBITORDETAIL.ID_WO_PREFIX and                        
 DEBINV.ID_JOB_ID = DEBITORDETAIL.ID_JOB_ID and                        
 DEBINV.ID_WOITEM_SEQ = JODBETAIL.ID_WOITEM_SEQ                        
 AND DEBINV.LINE_TYPE = 'SPARES'                        
 LEFT OUTER JOIN                         
 TBL_MAS_CUSTOMER CUST ON                        
  CUST.ID_CUSTOMER =  DEBITORDETAIL.ID_JOB_DEB                        
 WHERE                                   
 TEMPA.ID_WODET_SEQ = WODETAIL.ID_WODET_SEQ AND                                   
 DEBITORDETAIL.ID_JOB_DEB = TEMPA.ID_DEBITOR              
              
       
 --Check------      
             
 --UPDATE INVDETLINES            
 -- SET  PRICE =  ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.PRICE,          
 -- INVL_PRICE =  ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.INVL_PRICE,            
 -- INVL_AMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.INVL_AMOUNT,            
 -- INVL_BFAMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.INVL_BFAMOUNT,            
 -- INVL_VAT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.INVL_VAT,            
 -- VATAMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.VATAMOUNT,          
 -- TOTALAMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINES.TOTALAMOUNT          
 -- FROM TBL_INV_DETAIL_LINES INVDETLINES            
 -- INNER JOIN @INVOICETEMP1 TEMP ON INVDETLINES.ID_INV_NO = TEMP.ID_INV_NO            
 -- INNER JOIN TBL_WO_HEADER WOHEAD ON TEMP.ID_WO_NO = WOHEAD.ID_WO_NO AND TEMP.ID_WO_PREFIX = WOHEAD.ID_WO_PREFIX                      
 -- INNER JOIN TBL_INV_DETAIL INVDET ON INVDET.ID_WODET_INV = INVDETLINES.ID_WODET_INVL AND INVDET.ID_INV_NO = INVDETLINES.ID_INV_NO          
        
        
 --Check------                       
                         
 /********************X010***********************/                        
 --SELECT '@TEMP_TBL_INV_HEADER',* FROM @TEMP_TBL_INV_HEADER                        
                         
 --SELECT                                   
 -- DISTINCT  'SPARETEST',                                 
 --TEMPA.ID_INV_NO,TEMPA.ID_WODET_SEQ,'TRUE',                                  
 --JODBETAIL.ID_WOITEM_SEQ,NULL,JODBETAIL.ID_ITEM_JOB,                                  
 ----ADDED VMSSANTHOSH 07-MAY-2008                                  
 --JODBETAIL.ID_MAKE_JOB,                                  
 --JODBETAIL.ID_WAREHOUSE,                                  
 ----ADDED END                                   
 -- case when JODBETAIL.ID_ITEM_JOB is not null then                                  
 --(select ITEM_DESC from TBL_MAS_ITEM_MASTER where ID_ITEM = JODBETAIL.ID_ITEM_JOB AND TBL_MAS_ITEM_MASTER.ID_MAKE = JODBETAIL.ID_MAKE_JOB AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM = JODBETAIL.ID_WAREHOUSE)                                  
 -- else ''                                  
 -- end ,                                  
 --case when JODBETAIL.ID_ITEM_JOB is not null then                                  
 ----(select ISNULL(COST_PRICE1,0) from TBL_MAS_ITEM_MASTER where ID_ITEM = JODBETAIL.ID_ITEM_JOB AND TBL_MAS_ITEM_MASTER.ID_MAKE = JODBETAIL.ID_MAKE_JOB AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM = JODBETAIL.ID_WAREHOUSE)                                   
 -- ISNULL(JODBETAIL.JOBI_COST_PRICE,0)                                 
 -- else 0                        
 -- end                           
                              
 -- ,JODBETAIL.JOBI_DELIVER_QTY,JODBETAIL.JOBI_SELL_PRICE,                        
 --JODBETAIL.JOBI_DIS_PER,                                
 --DEBITORDETAIL.DBT_PER,                               
 --@IV_CREATEDBY,GETDATE() ,'Spares' ,JOB_VAT_ACCCODE,                                  
 -- JOB_VAT,                             
 --JODBETAIL.JOBI_VAT_PER,                        
 --job_spares_accountcode,                                  
                          
 -- case when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 and                                  
 --JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY <> 0) then                                   
 --JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY                          
 -- else 0                                  
 -- end ,                                  
 -- case when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 and                         
 --JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY <>0) then                                   
 -- ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER )                          
 ---((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER)                          
 --*(0.01 * JODBETAIL.JOBI_DIS_PER) )                           
 --)                                   
 -- + ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER -((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER)                                  
 --*(0.01 * JODBETAIL.JOBI_DIS_PER) ))* (0.01 * ISNULL(JOBI_VAT_PER,0)) )                                   
 --when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 and            
 --isnull(WOJDD.DBT_DIS_PER,0) = 0 and                                  
 --JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY >0) then                                  
 --(JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER)                                   
 --+ ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * DEBITORDETAIL.DBT_PER )* (0.01 * ISNULL(JOBI_VAT_PER,0)) )                                   
 -- else 0                                  
 -- end,                        
                                   
 --case                         
 -- when (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE > 0                         
 --  and DEBITORDETAIL.WO_SPR_DISCPER is not null                         
 --  and DEBITORDETAIL.WO_SPR_DISCPER >= 0                         
 --  and DEBITORDETAIL.WO_VAT_PERCENTAGE is not null                         
 --  and DEBITORDETAIL.WO_VAT_PERCENTAGE >= 0                         
 --  and JODBETAIL.JOBI_DELIVER_QTY is not null                         
 --  and JODBETAIL.JOBI_DELIVER_QTY <> 0                         
 --  AND JODBETAIL.JOBI_SELL_PRICE is not null                         
 --  and JODBETAIL.JOBI_SELL_PRICE >0                         
 --  and DEBITORDETAIL.WO_VAT_PERCENTAGE is not null                         
 --  and DEBITORDETAIL.WO_VAT_PERCENTAGE > 0                         
 --  and JODBETAIL.JOBI_DELIVER_QTY is not null                         
 --  and JODBETAIL.JOBI_DELIVER_QTY <> 0)                         
 -- then                             
 -- (((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY) - (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 0.01  * JODBETAIL.JOBI_DIS_PER)) * (0.01  * DEBITORDETAIL.DBT_PER)) * (0.01 * JODBETAIL.JOBI_VAT_PER)                        
 -- else 0                                  
 -- end ,                        
 -- 0,--DEBINV.LINE_AMOUNT_NET,                        
 -- case when JODBETAIL.[TEXT] <> '' and JODBETAIL.[TEXT] is not null then                        
 -- 'TEXT'                        
 -- ELSE                        
 -- 'SPAREPART'                        
 -- END,                        
 -- JODBETAIL.ITEM_DESC,                        
 -- 0,--DEBINV.PRICE,                        
 -- 0,--DEBINV.LINE_DISCOUNT,                        
 -- JODBETAIL.JOBI_ORDER_QTY - JODBETAIL.JOBI_DELIVER_QTY,                        
 -- JODBETAIL.JOBI_ORDER_QTY,                        
 -- 0--DEBINV.LINE_VAT_AMOUNT                         
                                    
 -- FROM                         
 --@TEMP_TBL_INV_HEADER TEMPA                        
 --INNER JOIN TBL_WO_DETAIL WODETAIL                              
 --ON    WODETAIL.ID_WODET_SEQ = TEMPA.ID_WODET_SEQ                        
 --INNER JOIN                                   
 --TBL_WO_JOB_DETAIL JODBETAIL ON                                   
 --WODETAIL.ID_WODET_SEQ = JODBETAIL.ID_WODET_SEQ_JOB                                  
 --LEFT OUTER JOIN                                  
 --TBL_WO_DEBITOR_DETAIL DEBITORDETAIL ON                                  
 --WODETAIL.ID_WO_NO = DEBITORDETAIL.ID_WO_NO AND                                   
 --WODETAIL.ID_WO_PREFIX = DEBITORDETAIL.ID_WO_PREFIX AND                                   
 --WODETAIL.ID_JOB = DEBITORDETAIL.ID_JOB_ID                                   
 --LEFT OUTER JOIN TBL_WO_JOB_DEBITOR_DISCOUNT WOJDD ON                                   
 --WODETAIL.ID_WO_NO = WOJDD.ID_WO_NO AND                                   
 --WODETAIL.ID_WO_PREFIX = WOJDD.ID_WO_PREFIX AND                                   
 --WODETAIL.ID_JOB = WOJDD.ID_JOB_ID AND                                  
 --DEBITORDETAIL.ID_JOB_DEB=WOJDD.ID_DEB AND                                  
 --JODBETAIL.ID_ITEM_JOB = WOJDD.ID_ITEM_JOB                            
 ----LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINV ON                        
 ----DEBINV.DEBTOR_SEQ = DEBITORDETAIL.ID_DBT_SEQ and   ----DEBINV.ID_WO_NO = DEBITORDETAIL.ID_WO_NO and                        
 ----DEBINV.ID_WO_PREFIX= DEBITORDETAIL.ID_WO_PREFIX and                        
 ----DEBINV.ID_JOB_ID = DEBITORDETAIL.ID_JOB_ID and                        
 ----DEBINV.ID_WOITEM_SEQ = JODBETAIL.ID_WOITEM_SEQ                        
 ----AND DEBINV.LINE_TYPE = 'SPARES'                        
 --WHERE                                   
 --TEMPA.ID_WODET_SEQ = WODETAIL.ID_WODET_SEQ AND                                   
 --DEBITORDETAIL.ID_JOB_DEB = TEMPA.ID_DEBITOR                         
                         
 /******************************************************/            
                         
                         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert TBL_INV_DETAIL_LINES',getdate(),13,@NEW_GUID)                                      
                        
   INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert #TEMP_ITEM_AVAIL_QTY',getdate(),14,@NEW_GUID)                                      
                        
 CREATE TABLE #TEMP_ITEM_AVAIL_QTY                              
 (                              
  TEMP_DELIVER_QTY DECIMAL(13,2)                              
  ,TEMP_ITEM VARCHAR(30)                              
  ,TEMP_MAKE VARCHAR(10)                         
  ,TEMP_WAREHOUSE INT                             
 )                              
                        
 INSERT INTO #TEMP_ITEM_AVAIL_QTY                              
 SELECT                              
 JODBETAIL.JOBI_DELIVER_QTY                            
 ,JODBETAIL.ID_ITEM_JOB                           
 ,JODBETAIL.ID_MAKE_JOB                               
 ,JODBETAIL.ID_WAREHOUSE                              
 FROM                              
 @TEMP_TBL_INV_HEADER TEMPA,TBL_WO_DETAIL WODETAIL                                 
 INNER JOIN                                   
 TBL_WO_JOB_DETAIL JODBETAIL ON                                   
 WODETAIL.ID_WODET_SEQ = JODBETAIL.ID_WODET_SEQ_JOB                        
 WHERE                                   
 TEMPA.ID_WODET_SEQ = WODETAIL.ID_WODET_SEQ                        
                         
                         
 UPDATE TBL_MAS_ITEM_MASTER                                  
 SET                               
  ITEM_AVAIL_QTY = CASE WHEN #TEMP_ITEM_AVAIL_QTY.TEMP_DELIVER_QTY < 0 THEN                                    
       (ITEM_AVAIL_QTY - #TEMP_ITEM_AVAIL_QTY.TEMP_DELIVER_QTY)                     
        ELSE ITEM_AVAIL_QTY END                        
 FROM                               
  #TEMP_ITEM_AVAIL_QTY                                         
 WHERE                          
  TBL_MAS_ITEM_MASTER.ID_ITEM COLLATE database_default= #TEMP_ITEM_AVAIL_QTY.TEMP_ITEM COLLATE database_default                                       
  AND TBL_MAS_ITEM_MASTER.SUPP_CURRENTNO COLLATE database_default = #TEMP_ITEM_AVAIL_QTY.TEMP_MAKE COLLATE database_default                                       
  AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM = #TEMP_ITEM_AVAIL_QTY.TEMP_WAREHOUSE                        
                            
                                 
 IF @@ERROR <> 0                   
 BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                  
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                   
 END                           
                         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert #TEMP_ITEM_AVAIL_QTY',getdate(),14,@NEW_GUID)                                      
                          
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Insert TBL_INV_DETAIL_LINES_LABOUR',getdate(),15,@NEW_GUID)                                      
                            
                            
          
 INSERT INTO TBL_INV_DETAIL_LINES_LABOUR                                   
 (ID_INV_NO,ID_WODET_INVL,FLG_ITEM,                                  
  ID_WH_INVL,INVL_IDLOGIN,                                  
  INVL_DESCRIPTION,INVL_MECH_HOUR,INVL_MECH_HOURLY_PRICE,                                  
  INVL_STTime,INVL_DEB_CONTRIB,CREATED_BY,                                  
  DT_CREATED,INVL_LINETYPE,INVL_VAT_ACCCODE,                                  
  INVL_VAT_CODE,INVL_VAT_PER,INVL_Labour_ACCOUNTCODE,                                   
  INVL_STHour,INVL_AMOUNT,INVL_VAT,INVL_DIS,                        
  TOTALAMOUNT,                        
  PRICE,                        
  DISCOUNT,                        
  VATAMOUNT,              
  ID_WOLAB_SEQ                                   
 )                                  
 SELECT                                   
 TEMPA.ID_INV_NO,TEMPA.ID_WODET_SEQ,'FALSE',                                   
 NULL,ID_LOGIN,                                  
 --CASE WHEN ID_LOGIN IS NOT NULL AND ISNULL((SELECT TOP 1 FLG_DUSER FROM TBL_MAS_USERS USR WHERE USR.ID_LOGIN=WOLABOURDET.ID_LOGIN),0)=1 THEN                                  
 --  ( SELECT                                   
 --  ISNULL(FIRST_NAME,' ')+ SPACE(1) + ISNULL(LAST_NAME,'')                                  
 --  FROM                                   
 --  TBL_MAS_USERS                                   
 --  WHERE                                   
 -- ID_LOGIN = WOLABOURDET.ID_LOGIN)              
 --ELSE              
      ISNULL(WOLABOURDET.WO_LABOUR_DESC,'')              
 --END              
 ,ISNULL(WO_LABOUR_HOURS,0),ISNULL(WOLABOURDET.WO_HOURLEY_PRICE,0),                                  
 CASE WHEN TEMPA.ID_WODET_SEQ IS NOT NULL THEN                                  
  (                           
 SELECT CASE WHEN WO_STD_TIME <> '' THEN                                  
  ISNULL(CAST(REPLACE(WO_STD_TIME,':','.')AS NUMERIC(12,2)),0)                        
 ELSE                                  
  0.00                                  
 END                                 
  FROM TBL_WO_DETAIL WHERE ID_WODET_SEQ = TEMPA.ID_WODET_SEQ)                                  
  ELSE 0                                  
  END,0,@IV_CREATEDBY,                                  
  GETDATE(),'LABOUR',WOLABOURDET.WO_vat_ACCCODE,                                  
  WO_VAT_CODE,WO_LABOURVAT_PERCENTAGE,WO_LABOUR_ACCOUNTCODE,                                  
  0,0,0 ,0 ,                        
  DEBINV.LINE_AMOUNT_NET,                        
  DEBINV.PRICE,                        
  DEBINV.LINE_DISCOUNT,                        
  DEBINV.LINE_VAT_AMOUNT,              
  WOLABOURDET.ID_WOLAB_SEQ                              
 FROM                                   
 @TEMP_TBL_INV_HEADER TEMPA,TBL_WO_LABOUR_DETAIL WOLABOURDET , TBL_WO_DEBITOR_DETAIL DEBDET, TBL_WO_DEBTOR_INVOICE_DATA DEBINV,TBL_WO_DETAIL WODET                        
 WHERE                                   
 TEMPA.ID_WODET_SEQ = WOLABOURDET.ID_WODET_SEQ AND                        
 TEMPA.ID_WODET_SEQ = WODET.ID_WODET_SEQ AND                        
 DEBDET.ID_JOB_DEB = TEMPA.ID_DEBITOR and                        
 DEBINV.DEBTOR_SEQ = DEBDET.ID_DBT_SEQ and                        
 DEBINV.ID_WO_NO = WODET.ID_WO_NO and                        
 DEBINV.ID_WO_PREFIX= WODET.ID_WO_PREFIX and                   DEBINV.ID_JOB_ID = WODET.ID_JOB and                          
 DEBINV.LINE_TYPE='LABOUR' and                        
 DEBINV.DEBTOR_ID = TEMPA.ID_DEBITOR and              
 DEBINV.ID_WOLAB_SEQ = WOLABOURDET.ID_WOLAB_SEQ              
                             
                         
                                   
  IF @@ERROR <> 0                                  
  BEGIN                                  
  ROLLBACK TRANSACTION @TRANNAME                                  
  SET @OV_RETVALUE = 'INSFLG'                                   
   IF @COUNT_ORD = 0                        
  BEGIN                        
  SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1             
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
  RETURN                                  
  END                                  
                          
                          
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Insert TBL_INV_DETAIL_LINES_LABOUR',getdate(),15,@NEW_GUID)                                      
                                 
 --TO UPDATE TOTAL AMOUNT                                  
   INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start  UPDATE TOTAL AMOUNTS ',getdate(),16,@NEW_GUID)                                      
                                 
 UPDATE TBL_INV_DETAIL_LINES_LABOUR SET INVL_STHOUR= B.INVL_MECH_HOURLY_PRICE                                  
 FROM TBL_INV_DETAIL_LINES_LABOUR B                                  
  WHERE INVL_MECH_HOURLY_PRICE =                                   
 (SELECT MAX(INVL_MECH_HOURLY_PRICE) FROM TBL_INV_DETAIL_LINES_LABOUR A                                   
 WHERE A.ID_WODET_INVL = B.ID_WODET_INVL )                                  
  AND INVL_STTime > 0                         
                          
 UPDATE TBL_INV_DETAIL_LINES_LABOUR SET  INVL_BFAMOUNT = TBL_WO_DETAIL.WO_TOT_LAB_AMT                        
 FROM TBL_WO_DETAIL WHERE ID_WODET_INVL = ID_WODET_SEQ                        
                          
 UPDATE TBL_INV_DETAIL_LINES_LABOUR SET INVL_DIS = TBL_WO_DETAIL.WO_DISCOUNT                        
 FROM TBL_WO_DETAIL WHERE ID_WODET_INVL = ID_WODET_SEQ                        
                        
                        
 UPDATE TBL_INV_DETAIL_LINES_LABOUR SET INVL_VAT = (ISNULL(INVL_BFAMOUNT,0)-(ISNULL(INVL_BFAMOUNT,0)* 0.01 *INVL_DIS)) * (0.01* ISNULL(INVL_VAT_PER,0))                                  
 UPDATE TBL_INV_DETAIL_LINES_LABOUR SET INVL_AMOUNT = ISNULL(INVL_BFAMOUNT,0) + ISNULL(INVL_VAT,0) -(ISNULL(INVL_BFAMOUNT,0)* 0.01 *INVL_DIS)                                  
                
                                  
 IF @@ERROR <> 0                                  
 BEGIN                                   
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                  
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                       
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                  
 END                                   
                         
                         
  --KRE ORDER TYPE UPDATE TBL_INV_DETAIL_LINES_LABOUR          
  -- UPDATE INVDETLINESLAB            
  --SET            
  --INVL_AMOUNT =  ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.INVL_AMOUNT,          
  --PRICE =  ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.PRICE,          
  --INVL_MECh_Hourly_Price =  ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.INVL_MECh_Hourly_Price,            
  --INVL_AMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.INVL_AMOUNT,            
  --INVL_BFAMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.INVL_BFAMOUNT,            
  --INVL_VAT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.INVL_VAT,            
  --VATAMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.VATAMOUNT,          
  --TOTALAMOUNT = ISNULL(INVDET.WO_TYPE_FACTOR,0) * INVDETLINESLAB.TOTALAMOUNT          
  --FROM TBL_INV_DETAIL_LINES_LABOUR INVDETLINESLAB            
  --INNER JOIN @INVOICETEMP1 TEMP ON INVDETLINESLAB.ID_INV_NO = TEMP.ID_INV_NO            
  --INNER JOIN TBL_WO_HEADER WOHEAD ON TEMP.ID_WO_NO = WOHEAD.ID_WO_NO AND TEMP.ID_WO_PREFIX = WOHEAD.ID_WO_PREFIX                      
  --INNER JOIN TBL_INV_DETAIL INVDET ON INVDET.ID_WODET_INV = INVDETLINESLAB.ID_WODET_INVL AND INVDET.ID_INV_NO = INVDETLINESLAB.ID_INV_NO                        
                         
    --KRE ORDER TYPE UPDATE TBL_INV_DETAIL_LINES_LABOUR                       
                         
                         
                         
 SELECT                         
TEMPA.ID_INV_NO,                                
    TEMPA.ID_WODET_SEQ AS ID_WODET_INVL,                           
  DEBITORDETAIL.DBT_PER AS INVL_DEB_CONTRIB,                         
  CASE WHEN ISNULL(DEBITORDETAIL.DBT_PER,0)=0 AND WODETAIL.WO_OWN_CR_CUST IS NULL THEN 1 ELSE 0 END AS WO_SPLIT_CUST                        
  INTO #TBL_INV_DETAIL_LINES                        
 FROM                        
   @TEMP_TBL_INV_HEADER TEMPA,                            
   TBL_WO_DETAIL WODETAIL                            
   LEFT JOIN TBL_WO_JOB_DETAIL JODBETAIL                             
    ON WODETAIL.ID_WODET_SEQ = JODBETAIL.ID_WODET_SEQ_JOB                              
   LEFT OUTER JOIN TBL_WO_DEBITOR_DETAIL DEBITORDETAIL                             
    ON WODETAIL.ID_WO_NO = DEBITORDETAIL.ID_WO_NO                             
  AND WODETAIL.ID_WO_PREFIX = DEBITORDETAIL.ID_WO_PREFIX                             
  AND WODETAIL.ID_JOB = DEBITORDETAIL.ID_JOB_ID                         
  WHERE TEMPA.ID_WODET_SEQ = WODETAIL.ID_WODET_SEQ                            
   AND DEBITORDETAIL.ID_JOB_DEB = TEMPA.ID_DEBITOR                          
  --CHANGE END                  
                        
 UPDATE                                   
 TBL_INV_DETAIL                                   
 SET                                   
 /*IN_DEB_JOB_AMT =                                   
 DBO.FNINVJOBAMT(TBL_INV_DETAIL.ID_INV_NO,TBL_INV_DETAIL.ID_WODET_INV),*/ --NOT NECESSARY 18-OCT-13                        
 FLG_FIXED_PRICE =                                   
 CASE WHEN WO_FIXED_PRICE IS NULL OR WO_FIXED_PRICE=0 THEN                                  
  'FALSE'                                  
  ELSE                                   
  'TRUE'                                  
 END,                         
                         
 INVD_FIXEDAMT =                                   
 CASE WHEN ISNULL(INVD_FIXEDAMT,0) > 0 AND (select count(*) FROM #TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_WODET_INVL= ID_WODET_SEQ) > 0 THEN                                  
 (SELECT top 1                                 
  CASE WHEN INVL_DEB_CONTRIB > 0 and INVL_DEB_CONTRIB is not null THEN                          
   (INVD_FIXEDAMT * (0.01* (ISNULL(INVL_DEB_CONTRIB,0))))                            
  ELSE                              
   CASE WHEN WO_SPLIT_CUST=1 THEN                         
    0                        
   ELSE                        
    INVD_FIXEDAMT                           
   END                          
  END                        
  FROM #TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_INV_NO COLLATE database_default= TBL_INV_DETAIL.ID_INV_NO COLLATE database_default                                  
  AND INVDL.ID_WODET_INVL= B.ID_WODET_SEQ)                                   
 ELSE                              
  INVD_FIXEDAMT                                  
 END,                         
 -- End OF Modification                         
                                    
                                
 IN_DEB_GM_AMT =                                   
 CASE WHEN WO_TOT_GM_AMT IS NOT NULL and (select count(*) FROM #TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_WODET_INVL= ID_WODET_SEQ) > 0 THEN                                  
 (SELECT top 1                                 
  CASE WHEN INVL_DEB_CONTRIB > 0 and INVL_DEB_CONTRIB is not null THEN                                
                                  
 CAST((B.WO_TOT_GM_AMT - (B.WO_TOT_GM_AMT* 0.01 * ISNULL(B.WO_DISCOUNT,0))) * (0.01* (ISNULL(INVDL.INVL_DEB_CONTRIB,0))) AS NUMERIC (12,4))                                 
                             
                               
  else CAST((B.WO_TOT_GM_AMT   - (B.WO_TOT_GM_AMT* 0.01 * ISNULL(B.WO_DISCOUNT,0)))AS NUMERIC (12,4))                               
 -- else 0                                 
  end                                   
  FROM #TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_INV_NO COLLATE database_default= TBL_INV_DETAIL.ID_INV_NO COLLATE database_default                                  
  AND INVDL.ID_WODET_INVL= B.ID_WODET_SEQ)                                   
  ELSE                                  
 WO_TOT_GM_AMT                                  
  END,                        
  IN_DEB_GM_AMT_FP =        /*ADDED FOR ROW 475 - 25JAN13*/                           
  CASE WHEN WO_TOT_GM_AMT_FP IS NOT NULL and (select count(*) FROM #TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_WODET_INVL= ID_WODET_SEQ) > 0 THEN                                  
   (SELECT top 1                                 
    CASE WHEN INVL_DEB_CONTRIB > 0 and INVL_DEB_CONTRIB is not null THEN                                
            CAST((B.WO_TOT_GM_AMT_FP - (B.WO_TOT_GM_AMT_FP* 0.01 * ISNULL(B.WO_DISCOUNT,0))) * (0.01* (ISNULL(INVDL.INVL_DEB_CONTRIB,0))) AS NUMERIC (12,4))                                 
    else                         
     CAST((B.WO_TOT_GM_AMT_FP   - (B.WO_TOT_GM_AMT_FP* 0.01 * ISNULL(B.WO_DISCOUNT,0)))AS NUMERIC (12,4))                               
    end                                   
   FROM #TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_INV_NO COLLATE database_default= TBL_INV_DETAIL.ID_INV_NO COLLATE database_default                                  
    AND INVDL.ID_WODET_INVL= B.ID_WODET_SEQ)                                   
  ELSE                                  
   WO_TOT_GM_AMT_FP                                  
  END                                              
 FROM TBL_WO_DETAIL B                                  
  WHERE TBL_INV_DETAIL.ID_INV_NO IN                                  
 (SELECT ID_INV_NO FROM @INVOICETEMP1)                                  
 AND TBL_INV_DETAIL.ID_WODET_INV = B.ID_WODET_SEQ                         
 --change end                        
                        
 DROP TABLE #TBL_INV_DETAIL_LINES                        
                         
 UPDATE                                   
 TBL_INV_DETAIL                                   
 SET INVD_VAT_AMOUNT =                                  
  CASE WHEN INVD_VAT_PERCENTAGE IS NOT NULL AND IN_DEB_GM_AMT IS NOT NULL THEN                                  
                         
 CAST((WO_TOT_GM_AMT - (WO_TOT_GM_AMT * 0.01 * TBL_WO_DETAIL.WO_DISCOUNT)) * (0.01* (ISNULL(INVD_VAT_PERCENTAGE,0)))AS NUMERIC(12,2))                                  
  ELSE 0                                  
  END,                        
  INVD_VAT_AMOUNT_FP =       /*ADDED FOR ROW 475 - 25JAN13*/                
  CASE WHEN INVD_VAT_PERCENTAGE IS NOT NULL AND IN_DEB_GM_AMT_FP IS NOT NULL THEN                                  
  CAST((WO_TOT_GM_AMT_FP - (WO_TOT_GM_AMT_FP * 0.01 * TBL_WO_DETAIL.WO_DISCOUNT)) * (0.01* (ISNULL(INVD_VAT_PERCENTAGE,0)))AS NUMERIC(12,2))                                  
  ELSE                         
  0                                  
  END                          
 FROM TBL_WO_DETAIL                                 
 WHERE TBL_INV_DETAIL.ID_INV_NO IN                                  
 (SELECT ID_INV_NO FROM @INVOICETEMP1) AND                         
  ID_WODET_INV = ID_WODET_SEQ                        
                        
 --to update gm amount after including vat                                  
 update TBL_INV_DETAIL                                  
 set IN_DEB_GM_AMT = isnull(IN_DEB_GM_AMT,0) +isnull(INVD_VAT_AMOUNT,0),                                  
 /*IN_DEB_JOB_AMT = isnull(IN_DEB_JOB_AMT,0) +isnull(INVD_VAT_AMOUNT,0),          */--NOT NECESSARY 18-OCT-13                        
 IN_DEB_GM_AMT_FP = isnull(IN_DEB_GM_AMT_FP,0) +isnull(INVD_VAT_AMOUNT_FP,0) /*ADDED FOR ROW 475 - 25JAN13*/                             
 WHERE TBL_INV_DETAIL.ID_INV_NO IN                                  
 (SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
                                   
 IF @@ERROR <> 0                                  
 BEGIN                                   
 ROLLBACK TRANSACTION @TRANNAME                                  
  SET @OV_RETVALUE = 'INSFLG'                                   
   IF @COUNT_ORD = 0                        
  BEGIN                    
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                       
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                  
 END                                  
                         
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End UPDATE TOTAL AMOUNTS ',getdate(),16,@NEW_GUID)                                      
                                 
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start VAT AMOUNTS ',getdate(),17,@NEW_GUID)                                      
                                  
 DECLARE @TEMPVAT as table                                  
 (                                  
  ID_INV_NO NCHAR(20),                                  
  ID_WODET_INV INT,                                   
  INVL_VAT_ACCCODE VARCHAR(20),                                  
  INVL_VAT_AMOUNT NUMERIC(12,2)             
 )                         
                                   
 --Labour                                  
 INSERT INTO @TEMPVAT                                  
 SELECT ID_INV_NO,ID_WODET_INVL,INVL_VAT_ACCCODE,sum(INVL_VAT) from TBL_INV_DETAIL_LINES_LABOUR A                       
 WHERE A.ID_INV_NO IN                                  
 (SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
  group by ID_INV_NO,ID_WODET_INVL,INVL_VAT_ACCCODE                                  
 --Spares                                  
 INSERT INTO @TEMPVAT                                  
 SELECT ID_INV_NO,ID_WODET_INVL,INVL_VAT_ACCCODE,sum(INVL_VAT) from TBL_INV_DETAIL_LINES A                                  
 WHERE A.ID_INV_NO IN                                  
 (SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
  group by ID_INV_NO,ID_WODET_INVL,INVL_VAT_ACCCODE                                  
                         
 INSERT INTO @TEMPVAT                        
 SELECT ID_INV_NO,ID_WODET_INV,INVD_VAT_ACCOUNTCODE,sum(INVD_VAT_AMOUNT) from TBL_INV_DETAIL A                                  
 WHERE A.ID_INV_NO IN                                  
 (SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
  group by ID_INV_NO,ID_WODET_INV,INVD_VAT_ACCOUNTCODE                                  
                                   
 --INSERT INTO VAT TABLE                                  
 INSERT INTO TBL_INV_DETAIL_LINES_VAT                                  
 SELECT                                   
 ID_INV_NO,                                  
 ID_WODET_INV,                                  
 INVL_VAT_ACCCODE,                                  
 SUM(INVL_VAT_AMOUNT)                                  
 FROM                                   
 @TEMPVAT                                  
 GROUP BY                                   
 ID_INV_NO,                                  
 ID_WODET_INV,                                  
 INVL_VAT_ACCCODE                             
                               
 DECLARE @INVOICESUM TABLE                                  
 (ID_INV_NO VARCHAR(10),                  
  INV_AMT DECIMAL)                                   
                               
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End VAT AMOUNTS ',getdate(),17,@NEW_GUID)                                      
                            
    INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start INSERT @INVOICESUM',getdate(),18,@NEW_GUID)                                      
                              
 --for Garage Material                                  
 INSERT INTO @INVOICESUM                             
 SELECT B.ID_INV_NO, SUM(ISNULL(IN_DEB_GM_AMT,0))                                   
 FROM TBL_INV_HEADER B,TBL_INV_DETAIL A                                  
 WHERE B.ID_INV_NO = A.ID_INV_NO AND                                   
 B.ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICETEMP1)                                  
 GROUP BY B.ID_INV_NO               
                                   
 --for Labour                                  
 INSERT INTO @INVOICESUM                                  
 SELECT B.ID_INV_NO, SUM(ISNULL(INVL_AMOUNT,0))                                   
 FROM TBL_INV_HEADER B,TBL_INV_DETAIL_LINES_LABOUR A                                  
 WHERE B.ID_INV_NO = A.ID_INV_NO AND                                  
 B.ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICETEMP1)                                   
 GROUP BY B.ID_INV_NO                                   
                                   
 --for Spares                                  
 INSERT INTO @INVOICESUM                                  
 SELECT B.ID_INV_NO, SUM(ISNULL(INVL_AMOUNT,0))                                   
 FROM TBL_INV_HEADER B,TBL_INV_DETAIL_LINES A                                  
 WHERE B.ID_INV_NO = A.ID_INV_NO AND                                  
 B.ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICETEMP1)                    
 GROUP BY B.ID_INV_NO                                  
                                   
    INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End INSERT @INVOICESUM',getdate(),18,@NEW_GUID)                                      
                         
    INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start INSERT @INVOICESUM1',getdate(),19,@NEW_GUID)                                      
                    
 DECLARE @INVOICESUM1 TABLE                                  
 (ID_INV_NO VARCHAR(10),                                   
  INV_AMT DECIMAL)                                  
                                   
  INSERT INTO @INVOICESUM1                                  
 select ID_INV_NO,SUM(ISNULL(INV_AMT,0))                                  
 from @INVOICESUM                                  
 GROUP BY ID_INV_NO                                  
                                   
 --select * from @INVOICESUM1                            INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End INSERT @INVOICESUM1',getdate(),19,@NEW_GUID)                                      
                                  
                                   
 UPDATE TBL_INV_HEADER SET INV_AMT = isnull(A.INV_AMT ,0) FROM @INVOICESUM1 A                               
 WHERE TBL_INV_HEADER.ID_INV_NO = A.ID_INV_NO                     
                         
 --224                         
   UPDATE TBL_INV_HEADER                        
   SET INV_FEES_AMT = CASE WHEN ISNULL(INVF.FLG_INV_FEES,0) = 0 THEN 0 ELSE ISNULL(INVF.INV_FEES_AMT,0) END, -- added condition if flag is 0 then 0                        
   INV_FEES_ACC_CODE = INVF.INV_FEES_ACC_CODE ,                        
   INV_FEES_VAT_PERCENTAGE =dbo.FnGetVATByCustID(TBL_INV_HEADER.ID_DEBITOR)                        
   FROM TBL_MAS_INV_FEES_SETTINGS INVF,@INVOICESUM1 A                          
   WHERE [TBL_INV_HEADER].ID_DEPT_INV = INVF.ID_DEPT AND                         
   [TBL_INV_HEADER].ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY                        
   AND A.ID_INV_NO = TBL_INV_HEADER.ID_INV_NO                        
                           
                         
                           
   --When orderhead cust is same as debitor then check for payment term from order head else from customer                        
   UPDATE TBL_INV_HEADER                        
   SET INV_FEES_AMT =                         
   CASE WHEN wh.ID_CUST_WO = [TBL_INV_HEADER].ID_DEBITOR THEN                        
    CASE WHEN wh.ID_PAY_TERMS_WO IN(SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0) OR ISNULL(INVF.FLG_INV_FEES,0)  = 0 or mc.FLG_CUST_IGNOREINV = 1                        
     THEN 0                         
 ELSE ISNULL(INVF.INV_FEES_AMT,0)                         
    END                        
   ELSE                        
    CASE WHEN mc.ID_CUST_PAY_TERM IN(SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0) OR ISNULL(INVF.FLG_INV_FEES,0) = 0 or mc.FLG_CUST_IGNOREINV = 1                        
     THEN 0                         
    ELSE ISNULL(INVF.INV_FEES_AMT,0)                         
    END        
   END -- added condition if flag is 0 then 0                        
   --CASE WHEN                         
   --  (                        
   -- ( select DISTINCT COUNT(wh.ID_WO_NO)                        
   --   FROM TBL_MAS_INV_FEES_SETTINGS INVF,@INVOICESUM1 A ,TBL_WO_HEADER wh,TBL_INV_DETAIL id ,TBL_MAS_CUSTOMER mc                        
   --   WHERE [TBL_INV_HEADER].ID_DEPT_INV = INVF.ID_DEPT AND                         
   --   [TBL_INV_HEADER].ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY                        
   --   AND A.ID_INV_NO = TBL_INV_HEADER.ID_INV_NO                        
   --   AND wh.ID_WO_NO = id.ID_WO_NO and wh.ID_WO_PREFIX = id.ID_WO_PREFIX                        
   --   AND id.ID_INV_NO = A.ID_INV_NO and mc.ID_CUSTOMER = [TBL_INV_HEADER].ID_DEBITOR                        
   -- )                        
   -- = (   
   --     select DISTINCT COUNT(woh.ID_WO_NO)                         
   --     from TBL_WO_HEADER woh, @INVOICESUM1 I ,TBL_INV_DETAIL ivd ,TBL_INV_HEADER ivh                        
   --     where  woh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )                        
   --     AND ivh.ID_DEPT_INV = INVF.ID_DEPT AND                         
   --     ivh.ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY                        
   --     AND I.ID_INV_NO = ivh.ID_INV_NO                        
   --     AND woh.ID_WO_NO = ivd.ID_WO_NO and woh.ID_WO_PREFIX = ivd.ID_WO_PREFIX                        
   --     AND ivd.ID_INV_NO = I.ID_INV_NO                        
   --    )                         
   -- )                        
   --THEN                         
   -- 0                         
   --ELSE                        
   -- CASE WHEN wh.ID_CUST_WO = [TBL_INV_HEADER].ID_DEBITOR THEN                        
   --  CASE WHEN wh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 ) OR INVF.FLG_INV_FEES = 0                         
   --   THEN 0                         
   --  ELSE INVF.INV_FEES_AMT                         
   --  END                        
   -- ELSE                        
   --  CASE WHEN mc.ID_CUST_PAY_TERM IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 ) OR INVF.FLG_INV_FEES = 0                         
   --   THEN 0                         
   --  ELSE INVF.INV_FEES_AMT                         
   --  END                        
                        
   -- END                         
   -- --INVF.INV_FEES_AMT                         
   --END                        
   FROM TBL_MAS_INV_FEES_SETTINGS INVF,@INVOICESUM1 A ,TBL_WO_HEADER wh,TBL_INV_DETAIL id ,TBL_MAS_CUSTOMER mc                        
   WHERE [TBL_INV_HEADER].ID_DEPT_INV = INVF.ID_DEPT AND                         
   [TBL_INV_HEADER].ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY                        
   AND A.ID_INV_NO = TBL_INV_HEADER.ID_INV_NO                        
   AND wh.ID_WO_NO = id.ID_WO_NO and wh.ID_WO_PREFIX = id.ID_WO_PREFIX                        
   AND id.ID_INV_NO = A.ID_INV_NO and mc.ID_CUSTOMER = [TBL_INV_HEADER].ID_DEBITOR                        
                        
                           
   UPDATE TBL_INV_HEADER                        
   SET  INV_FEES_VAT_AMT = (dbo.FnGetVATByCustID(TBL_INV_HEADER.ID_DEBITOR) * ISNULL(TBL_INV_HEADER.INV_FEES_AMT,0) / 100)                         
   FROM TBL_MAS_INV_FEES_SETTINGS INVF,@INVOICESUM1 A                          
   WHERE [TBL_INV_HEADER].ID_DEPT_INV = INVF.ID_DEPT AND                         
   [TBL_INV_HEADER].ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY                        
   AND A.ID_INV_NO = TBL_INV_HEADER.ID_INV_NO                        
                         
                                
                                   
 --Coding for rounding function Included on 04/04/2007                                  
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Rounding',getdate(),20,@NEW_GUID)                                
                               
 update tbl_inv_header                         
 set                         
  INV_AMT=                                   
  case when inv_amt > 0 then                                   
  (select                                  
   case when INV_PRICE_RND_FN= 'Flr' and INV_RND_DECIMAL > 0 then                                   
     floor((inv_amt/convert(decimal(7,2),INV_RND_DECIMAL)) *INV_RND_DECIMAL)                        
    when INV_PRICE_RND_FN= 'Rnd' and INV_RND_DECIMAL > 0 then                                  
     floor(inv_amt/INV_RND_DECIMAL + (1 - (INV_PRICE_RND_VAL_PER/ 100 ))*INV_RND_DECIMAL )                                 
    when INV_PRICE_RND_FN= 'Clg' and INV_RND_DECIMAL > 0 then                                  
     Ceiling((inv_amt/INV_RND_DECIMAL)*INV_RND_DECIMAL)                        
   else inv_amt                                   
end                                  
  from                                   
   TBL_MAS_INV_CONFIGURATION where DT_EFF_TO is null and ID_DEPT_INV = tbl_inv_header.ID_Dept_Inv                                  
   and ID_SUBSIDERY_INV = tbl_inv_header.ID_Subsidery_Inv )                        
  else 0                                  
 end                                  
 where inv_amt > 0 and                                   
 ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICETEMP1)                           
 INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Rounding',getdate(),20,@NEW_GUID)                           
                         
   INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'Start Other Functions',getdate(),21,@NEW_GUID)                           
                                      
 --newly added by subramanian for Invoice header Transferred to Accounting system and customer Group                                  
 update tbl_inv_header set FLG_TRANS_TO_ACC = 0,                                  
 Inv_CUST_GROUP =                                  
 case when ID_DEBITOR is not null then                                  
 --(select ID_CUST_GROUP from tbl_mas_customer where ID_CUSTOMER = tbl_inv_header.ID_DEBITOR)                                  
 (SELECT TOP 1 ID_CUST_GRP FROM @JOB_DEB_LIST WHERE ID_JOB_DEB = tbl_inv_header.ID_DEBITOR )                        
 end                         
 WHERE ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICETEMP1)                        
                         
  ----616----                        
  ----new temp table to store transferred vat data and total vat                        
 --select '@INVOICETEMP11',* from @INVOICETEMP1 --X020                         
 --update invoicetemp1                        
                         
 SELECT DISTINCT ID_INV_NO INTO #INVNUM FROM @INVOICETEMP1 --IN ORDER TO AVOID REPEATING INVOICE NUMBERS IN THE INVOICE TEMP TABLE                        
                          
 SELECT SUM(JOB_VAT_AMOUNT)+ ISNULL(IH.INV_FEES_VAT_AMT,0) INVOICEVAT,TMP.ID_INV_NO INTO #VATTEMP FROM TBL_WO_DEBITOR_DETAIL WDB                         
 INNER JOIN TBL_INV_DETAIL ID ON WDB.ID_WO_NO=ID.ID_WO_NO AND WDB.ID_WO_PREFIX=ID.ID_WO_PREFIX AND WDB.ID_JOB_ID=ID.id_job                        
 INNER JOIN TBL_INV_HEADER IH ON IH.ID_DEBITOR = WDB.ID_JOB_DEB AND ID.ID_INV_NO=IH.ID_INV_NO                        
 INNER JOIN #INVNUM TMP ON TMP.ID_INV_NO=IH.ID_INV_NO                        
 GROUP BY TMP.ID_INV_NO,IH.INV_FEES_VAT_AMT                        
                         
 SELECT IH.ID_INV_NO,IH.ID_DEBITOR,ID.ID_WODET_INV AS 'ID_WODET_SEQ',IH.TRANSFERREDFROMCUSTID,IH.TRANSFERREDFROMCUSTName,IH.TRANSFERREDVAT                         
  INTO #TEMPINV FROM #VATTEMP TMP                        
  INNER JOIN TBL_INV_DETAIL ID ON TMP.ID_INV_NO = ID.ID_INV_NO                        
  INNER JOIN TBL_INV_HEADER IH ON ID.ID_INV_NO=IH.ID_INV_NO                        
                        
        UPDATE TMP SET TMP.TRANSFERREDVAT=                        
   (CASE WHEN WODEBDET.ID_JOB_DEB = isnull(WODET.WO_OWN_CR_CUST,0) THEN WODEBDET.TRANSFERREDVAT ELSE -1 * WODEBDET.TRANSFERREDVAT END),                        
   TMP.TRANSFERREDFROMCUSTID = WODEBDET.TRANSFERREDFROMCUSTID,                        
   TMP.TRANSFERREDFROMCUSTName = WODEBDET.TRANSFERREDFROMCUSTName                        
 FROM #TEMPINV TMP                      
 INNER JOIN TBL_WO_DETAIL WODET ON TMP.ID_WODET_SEQ = WODET.ID_WODET_SEQ                        
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEBDET ON WODEBDET.ID_WO_NO = WODET.ID_WO_NO                         
   AND WODEBDET.ID_WO_PREFIX = WODET.ID_WO_PREFIX                         
   AND WODEBDET.ID_JOB_ID = WODET.ID_JOB AND TMP.ID_DEBITOR = WODEBDET.ID_JOB_DEB and isnull(WODET.WO_OWN_PAY_VAT,0)=1                        
 /*                        
  CASE WHEN WODEBDET.ID_JOB_DEB = WODET.WO_OWN_CR_CUST THEN WODEBDET.TRANSFERREDVAT ELSE -1 * WODEBDET.TRANSFERREDVAT END AS 'TRANSFERREDVAT',                        
  WODEBDET.TRANSFERREDFROMCUSTID,                        
  WODEBDET.TRANSFERREDFROMCUSTName,                        
 */                        
 --                         
                          
 DECLARE @INVOICETOT TABLE                        
 (                        
   ID_INV_NO VARCHAR(10),                   
   TRANSFERREDVAT decimal(13,2),                        
   TRANSFERREDFROMCUSTID varchar(50),                        
      TRANSFERREDFROMCUSTName varchar(50),                        
      VATAMOUNT decimal(13,2)                         
 )                        
                         
 INSERT INTO @INVOICETOT                         
 (                        
 ID_INV_NO,TRANSFERREDVAT                        
 )                        
 SELECT ID_INV_NO,SUM(TRANSFERREDVAT)                        
 FROM #TEMPINV GROUP BY ID_INV_NO                        
                         
 --select '@INVOICETOT1',* from @INVOICETOT --X008                        
                         
 UPDATE TOT                         
 SET VATAMOUNT = INVOICEVAT                        
 FROM @INVOICETOT TOT,#VATTEMP TMP WHERE TOT.ID_INV_NO=TMP.ID_INV_NO                        
                         
 UPDATE TOT SET TRANSFERREDFROMCUSTID=(SELECT TOP 1 TRANSFERREDFROMCUSTID FROM #TEMPINV TMP WHERE TOT.ID_INV_NO=TMP.ID_INV_NO and isnull(TRANSFERREDFROMCUSTID,0)<>0)                        
 FROM @INVOICETOT TOT                        
 UPDATE TOT SET TRANSFERREDFROMCUSTName=(SELECT TOP 1 TRANSFERREDFROMCUSTName FROM #TEMPINV TMP WHERE TOT.TRANSFERREDFROMCUSTID=TMP.TRANSFERREDFROMCUSTID)                        
 FROM @INVOICETOT TOT                        
--select '@INVOICETEMP1',* from @INVOICETEMP1 --X000                        
--select '#VATTEMP',* from #VATTEMP --X000                        
--select '#INVNUM',* from #INVNUM --X007                        
--select '@INVOICETOT',* from @INVOICETOT --X008                        
                         
--check vat                       
UPDATE TMP SET TMP.TRANSFERREDVAT=TOT.TRANSFERREDVAT,                        
  TMP.TRANSFERREDFROMCUSTID=TOT.TRANSFERREDFROMCUSTID,                        
  TMP.TRANSFERREDFROMCUSTName=TOT.TRANSFERREDFROMCUSTName                        
  --,TMP.VATAMOUNT=TOT.VATAMOUNT  commented as already vatamount is calculated for tbl_inv_header in @invoicetemp2 and @invoicetemp3                      
FROM TBL_INV_HEADER TMP,@INVOICETOT TOT WHERE TOT.ID_INV_NO=TMP.ID_INV_NO                        
                          
  ----616----                                 
                                  
                                   
 --SELECT * INTO TESTINGINVOICE FROM @TEMP_TBL_INV_HEADER                                  
 IF @@ERROR <> 0                                   
BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                          
  END                        
 RETURN                                  
 END                                  
                                   
 DECLARE @INVXML VARCHAR(7000)                                  
 SET @INVXML=''                                  
 SELECT @INVXML=@INVXML+'<INVNO ID_INV_NO="'                                
  + ID_INV_NO +'" FLG_INVORCN="FALSE" />' FROM @INVOICESUM                                  
 SET @OV_INVLIST = '<ROOT><OPTIONS FLG_COPYTEXT="FALSE" />'+@INVXML + '</ROOT>'                          
 SET @OV_INVLIST_INTM = @INVXML                                
                                    
  IF @@ERROR <> 0                                  
 BEGIN                                 
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                 
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                  
 END                                   
     --updating parent inv column                        
                        
  UPDATE TBL_INV_HEADER SET ID_PARENT_INV_NO=                        
  (SELECT TOP 1 ID_INV_NO FROM @INVOICESUM)                      
  WHERE ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICESUM)                        
                       
   --   -- Update kid number for non batch                        
      UPDATE TBL_INV_HEADER SET INV_KID=(SELECT                         
      DBO.FNGETKID(INH.ID_DEBITOR,LTRIM(RTRIM(SUBSTRING((INVSUM.ID_INV_NO),LEN(INH.INV_PREFIX)+1,LEN(INVSUM.ID_INV_NO)))),                                  
   IND.ID_WO_NO, INH.ID_DEPT_INV, INH.ID_SUBSIDERY_INV ))                        
   FROM @INVOICESUM INVSUM ,TBL_INV_HEADER INH INNER JOIN TBL_INV_DETAIL IND                        
   ON INH.ID_INV_NO=IND.ID_INV_NO                         
     WHERE INH.ID_INV_NO =INVSUM.ID_INV_NO                        
   AND FLG_BATCH_INV='FALSE'                        
                          
      -- Update kid number for batch                        
                        
      UPDATE TBL_INV_HEADER SET INV_KID=(SELECT                         
      DBO.FNGETKID(INH.ID_DEBITOR,LTRIM(RTRIM(SUBSTRING((INVSUM.ID_INV_NO),LEN(INH.INV_PREFIX)+1,LEN(INVSUM.ID_INV_NO)))),                                  
   '0', INH.ID_DEPT_INV, INH.ID_SUBSIDERY_INV ))                        
   FROM @INVOICESUM INVSUM INNER JOIN TBL_INV_HEADER INH                         
   ON INVSUM.ID_INV_NO=INH.ID_INV_NO                        
   WHERE INH.ID_INV_NO =INVSUM.ID_INV_NO                        
   AND FLG_BATCH_INV='TRUE'                        
                           
                           
  ------616-----new tables----------------------------------------------------------------------------------------------                        
                        
 --   SELECT '@INVOICETEMP',* FROM @INVOICETEMP                         
 --SELECT '@INVOICETEMP1',* FROM @INVOICETEMP1                         
 --SELECT '@INVOICETEMP2',* FROM @INVOICETEMP2                        
 --SELECT '@INVOICETEMP3',* FROM @INVOICETEMP3                        
                         
 INSERT INTO TBL_INV_ADDRESS_HEADER                        
    (                         
  ID_INV_NO,                        
  CUSTOMERNAME,                        
  CUSTOMERADDRESS1,                        
  CUSTOMERADDRESS2,                        
  CUSTOMERCITY,                        
  CUSTOMERSTATE,                        
  CUSTOMERCOUNTRY,                        
  CUSTOMERZIPCODE,                        
  CUSTOMERPHONE1,       
  CUSTOMERPHONE2,                        
  CUSTOMERMOBILE,                        
  DELIVERY_ADDRESS_NAME,                        
  DELIVERY_ADDRESS_LINE1,                        
  DELIVERY_ADDRESS_LINE2,                        
  DELIVERY_COUNTRY,                       
  DELIVERY_CITY,                        
  DELIVERY_ZIPCODE,                        
  DELIVERY_STATE,                        
  DT_CREATED,                        
  CREATED_BY,             
  DT_MODIFIED,                        
  MODIFIED_BY                        
 )                        
    SELECT                         
  DISTINCT TMP.ID_INV_NO,                        
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN                        
   ISNULL(wh.WO_CUST_NAME,'')                         
  ELSE                        
   ISNULL(mc.CUST_NAME,'')                        
  END                        
  AS 'CUSTOMERNAME',                        
    CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND (ISNULL(WC.USE_DELV_ADDRESS,0) = 0)  THEN                        
   ISNULL(mc.CUST_PERM_ADD1,'')                         
  ELSE                        
   ISNULL(mc.CUST_BILL_ADD1,'')                         
  END                        
  AS 'CUSTOMERADDRESS1',                         
                        
  CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND (ISNULL(WC.USE_DELV_ADDRESS,0) = 0)  THEN                        
   ISNULL(mc.CUST_PERM_ADD2,'')                         
  ELSE                        
   ISNULL(mc.CUST_BILL_ADD2,'')                         
  END                        
  AS 'CUSTOMERADDRESS2',                         
  CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND (ISNULL(WC.USE_DELV_ADDRESS,0) = 0) THEN                        
   ISNULL(mzCustomerPerm.ZIP_CITY,'')                         
  ELSE                        
   ISNULL(mzCustomerPerm2.ZIP_CITY,'')                         
  END                        
  AS 'CUSTOMERCITY',                         
                           
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN                        
   ISNULL(mcdCustomerState.DESCRIPTION,'')                         
  ELSE                        
   ISNULL(mcdCustomerState2.DESCRIPTION,'')                         
  END                        
  AS 'CUSTOMERSTATE',                         
                            
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN                        
   ISNULL(mcdCustomerCountry.DESCRIPTION,'')                         
  ELSE                        
   ISNULL(mcdCustomerCountry2.DESCRIPTION,'')                         
  END                        
  AS 'CUSTOMERCOUNTRY',                              
                           
     CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND (ISNULL(WC.USE_DELV_ADDRESS,0) = 0) THEN                        
   ISNULL(mc.ID_CUST_PERM_ZIPCODE,'')                         
  ELSE                        
   ISNULL(mc.ID_CUST_BILL_ZIPCODE,'')                         
  END                        
  AS 'CUSTOMERZIPCODE',                        
    CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN                        
   ISNULL(wh.WO_CUST_PHONE_OFF,'')                         
  ELSE                        
   ISNULL(mc.CUST_PHONE_OFF,'')                         
  END                        
  AS 'CUSTOMERPHONE1',                         
                            
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN                   
   ISNULL(wh.WO_CUST_PHONE_HOME,'')                         
  ELSE                         
   ISNULL(mc.CUST_PHONE_HOME,'')                         
  END                        
  AS 'CUSTOMERPHONE2',                         
                            
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN                        
   ISNULL(wh.WO_CUST_PHONE_MOBILE,'')                         
  ELSE                        
   ISNULL(mc.CUST_PHONE_MOBILE,'')                         
  END                        
  AS 'CUSTOMERMOBILE',                        
  ISNULL(wh.DELIVERY_ADDRESS_NAME,'') AS 'DELIVERY_ADDRESS_NAME',                                      
  ISNULL(wh.DELIVERY_ADDRESS_LINE1,'') AS 'DELIVERY_ADDRESS_LINE1',                            
  ISNULL(wh.DELIVERY_ADDRESS_LINE2,'') AS 'DELIVERY_ADDRESS_LINE2',                                      
  ISNULL(wh.DELIVERY_COUNTRY,'') AS 'DELIVERY_COUNTRY',           
  ISNULL(mzCustomerDelivery.ZIP_CITY,'') AS 'DELIVERY_CITY',                              ISNULL(mzCustomerDelivery.ZIP_ZIPCODE,'') AS 'DELIVERY_ZIPCODE',                        
  ISNULL(mcdCustomerStateDelivery.DESCRIPTION,'') AS 'DELIVERY_STATE',                        
  IH.DT_CREATED,                        
  IH.CREATED_BY,                        
  NULL,                        
  NULL                        
    FROM @INVOICETEMP1 TMP                        
    INNER JOIN TBL_WO_HEADER WH                         
   ON WH.ID_WO_NO = TMP.ID_WO_NO AND WH.ID_WO_PREFIX = TMP.ID_WO_PREFIX                              
 INNER JOIN TBL_INV_HEADER IH                         
   ON IH.ID_INV_NO = TMP.ID_INV_NO                        
 INNER JOIN TBL_MAS_CUSTOMER MC                         
   ON MC.ID_CUSTOMER = IH.ID_DEBITOR                        
 LEFT OUTER JOIN TBL_MAS_WO_CONFIGURATION WC                         
   ON WC.ID_SUBSIDERY_WO = IH.ID_Subsidery_Inv AND WC.ID_DEPT_WO = IH.ID_Dept_Inv AND DT_EFF_TO>GETDATE()                        
 LEFT OUTER JOIN TBL_MAS_ZIPCODE mzCustomerPerm  WITH(NOLOCK)                                    
  ON mc.ID_CUST_PERM_ZIPCODE = mzCustomerPerm.ZIP_ZIPCODE                                      
 LEFT OUTER JOIN TBL_MAS_ZIPCODE mzCustomerPerm2 WITH(NOLOCK)                        
  ON mc.ID_CUST_BILL_ZIPCODE = mzCustomerPerm2.ZIP_ZIPCODE                         
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerState   WITH(NOLOCK)                                   
  ON mzCustomerPerm.ZIP_ID_STATE = mcdCustomerState.ID_PARAM                                      
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerState2 WITH(NOLOCK)                        
  ON mzCustomerPerm2.ZIP_ID_STATE = mcdCustomerState2.ID_PARAM                         
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerCountry  WITH(NOLOCK)                                    
  ON mzCustomerPerm.ZIP_ID_COUNTRY = mcdCustomerCountry.ID_PARAM                                      
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerCountry2 WITH(NOLOCK)                        
  ON mzCustomerPerm2.ZIP_ID_COUNTRY = mcdCustomerCountry2.ID_PARAM                         
 LEFT OUTER JOIN TBL_MAS_ZIPCODE mzCustomerDelivery  WITH(NOLOCK)                                    
  ON wh.DELIVERY_ADDRESS_ZIPCODE = mzCustomerDelivery.ZIP_ZIPCODE                       
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerStateDelivery WITH(NOLOCK)                            
  ON mzCustomerDelivery.ZIP_ID_STATE = mcdCustomerStateDelivery.ID_PARAM                            
                        
                         
 INSERT INTO TBL_INV_DETAIL_VEH                        
 (                        
  ID_INV_NO,                        
  VEHICLEOWNERID,                        
  OWNERNAME,                        
  ID_VEH_SEQ,                        
  VEH_REG_NO,                        
  WO_VEH_MILEAGE,                        
  WO_VEH_HRS,                        
  VEH_INTERN_NO,                        
  DT_VEH_ERGN,                        
  VEH_VIN,                        
  VEH_TYPE,                        
  DT_CREATED,                        
  CREATED_BY,                        
  ID_WO_NO,                        
  ID_WO_PREFIX                        
                          
 )                         
                         
 SELECT DISTINCT                         
 INVDET.ID_INV_NO,                        
 INVDET.VEHICLEOWNERID,                        
 INVDET.OWNERNAME,                        
 VEH.ID_VEH_SEQ,                        
 VEH.VEH_REG_NO,                        
 VEH.VEH_MILEAGE,                        
 VEH.VEH_HRS,                        
 VEH.VEH_INTERN_NO,                        
 VEH.DT_VEH_ERGN,                        
 VEH.VEH_VIN,                        
 VEH.VEH_TYPE,                        
 INVDET.DT_CREATED,                         
 INVDET.CREATED_BY,                        
 WH.ID_WO_NO,                        
 WH.ID_WO_PREFIX                        
 FROM TBL_INV_DETAIL INVDET                        
 INNER JOIN TBL_WO_HEADER WH                         
   ON WH.ID_WO_NO = INVDET.ID_WO_NO AND WH.ID_WO_PREFIX = INVDET.ID_WO_PREFIX                              
 INNER JOIN TBL_MAS_VEHICLE VEH                        
   ON VEH.ID_VEH_SEQ = WH.ID_VEH_SEQ_WO                        
 where INVDET.ID_INV_NO in (select ID_INV_NO from @INVOICETEMP1)                         
                           
                           
 INSERT INTO TBL_INV_ADDRESS_SUB_DEP                        
 (                        
  ID_INV_NO,                        
  SUBSIDIARYNAME,                        
  SUBSIDIARYADDRESS1,                        
  SUBSIDIARYADDRESS2,                        
  SUBSIDIARYZIPCODE,                        
  SUBSIDIARYCITY,                        
  SUBSIDIARYSTATE,                        
  SUBSIDIARYCOUNTRY,                        
  SUBSIDIARYPHONE1,                        
  SUBSIDIARYPHONE2,                        
  SUBSIDIARYMOBILE,                        
  SUBSIDIARYFAX,                        
  SUBSIDIARYEMAIL,                        
  SUBSIDIARYORGANIZATIONNO,                        
  SUBSIDIARYBANKACCOUNT,                        
  SUBSIDIARYIBAN,                        
  SUBSIDIARYSWIFT,                        
  DEPARTMENTNAME,                        
  DEPARTMENTADDRESS1,                        
  DEPARTMENTADDRESS2,                        
  DEPARTMENTZIPCODE,                        
  DEPARTMENTCITY,                        
  DEPARTMENTSTATE,                        
  DEPARTMENTCOUNTRY,                        
  DEPARTMENTPHONE,                        
  DEPARTMENTMOBILE,                        
  --DEPARTMENTFAX,                        
  DEPARTMENTORGANIZATIONNO,                        
  DEPARTMENTBANKACCOUNT,                        
  DEPARTMENTIBAN,                        
  DEPARTMENTSWIFT,                        
  DT_CREATED,                        
  CREATED_BY                        
 )                
 select DISTINCT ih.ID_INV_NO,                          
  ISNULL(ms.SS_NAME,'') ,           ISNULL(ms.SS_ADDRESS1,'') ,                                      
  ISNULL(ms.SS_ADDRESS2,'') ,                      ISNULL(mzSubsidiary.ZIP_ZIPCODE,'') ,                           
  ISNULL(mzSubsidiary.ZIP_CITY,'') ,              ISNULL(mcdSubsidiaryState.DESCRIPTION,'') ,                        
  ISNULL(mcdSubsidiaryCountry.DESCRIPTION,'') ,  ISNULL(ms.SS_PHONE1,'') ,                                      
  ISNULL(ms.SS_PHONE2,'') ,       ISNULL(ms.SS_PHONE_MOBILE,'') ,                                      
  ISNULL(ms.SS_FAX,'') ,                              ISNULL(ms.ID_EMAIL_SUBSID,'') ,              
  ISNULL(ms.SS_ORGANIZATIONNO,'') ,     ISNULL(ms.SS_BANKACCOUNT,'') ,                                          
  ISNULL(ms.SS_IBAN,'') ,                             ISNULL(ms.SS_SWIFT,'') ,                                       
                                           
  --Department Information                                      
  ISNULL(md.DPT_Name,'') ,                         ISNULL(md.DPT_Address1,'') ,                                      
  ISNULL(md.DPT_Address2,''),          ISNULL(mzDepartment.ZIP_ZIPCODE,''),                        
  ISNULL(mzDepartment.ZIP_CITY,'') ,     ISNULL(mcdDepartmentState.DESCRIPTION,'') ,                                      
  ISNULL(mcdDepartmentCountry.DESCRIPTION,'') ,  ISNULL(md.DPT_PHONE,'') ,                                      
  ISNULL(md.DPT_PHONE_MOBILE,'') ,                    ISNULL(ms.SS_ORGANIZATIONNO,''),                                      
  ISNULL(ms.SS_BANKACCOUNT,''),      ISNULL(ms.SS_IBAN ,''),                                          
  ISNULL(ms.SS_SWIFT,'') ,                        
  IH.DT_CREATED,IH.CREATED_BY                                                                             
                                           
   FROM @INVOICETEMP1 TMP                        
    INNER JOIN TBL_WO_HEADER WH                         
   ON WH.ID_WO_NO = TMP.ID_WO_NO AND WH.ID_WO_PREFIX = TMP.ID_WO_PREFIX                              
 INNER JOIN TBL_INV_HEADER IH                         
   ON IH.ID_INV_NO = TMP.ID_INV_NO                        
 LEFT OUTER JOIN TBL_MAS_SUBSIDERY ms   WITH(NOLOCK)                              
   ON ms.ID_SUBSIDERY=ih.ID_SUBSIDERY_INV                        
 LEFT OUTER JOIN TBL_MAS_ZIPCODE mzSubsidiary  WITH(NOLOCK)                                    
   ON ms.SS_ID_ZIPCODE = mzSubsidiary.ZIP_ZIPCODE           
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdSubsidiaryState WITH(NOLOCK)                                     
   ON mzSubsidiary.ZIP_ID_STATE = mcdSubsidiaryState.ID_PARAM                                      
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdSubsidiaryCountry  WITH(NOLOCK)                                    
   ON mzSubsidiary.ZIP_ID_COUNTRY = mcdSubsidiaryCountry.ID_PARAM                                      
 LEFT OUTER JOIN TBL_MAS_DEPT md  WITH(NOLOCK)                                    
   ON md.ID_DEPT = ih.ID_DEPT_INV                                      
 LEFT OUTER JOIN TBL_MAS_ZIPCODE mzDepartment  WITH(NOLOCK)                                    
   ON md.DPT_ID_ZIPCODE = mzDepartment.ZIP_ZIPCODE                                      
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdDepartmentState  WITH(NOLOCK)                                    
   ON mzDepartment.ZIP_ID_STATE = mcdDepartmentState.ID_PARAM                                      
 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdDepartmentCountry  WITH(NOLOCK)                                    
   ON mzDepartment.ZIP_ID_COUNTRY = mcdDepartmentCountry.ID_PARAM                          
                         
                           
-------------------------------------------------------------------------------------------------------------                        
   ----------------------------------------------------------------------------------------------------------------------------                     
                           
                           
 -- CHANGE JOB STATUS                                  
 DECLARE @JOBLIST TABLE                                   
 (                                  
  ID_WODET_SEQ INT,                                  
  ID_JOB_DEB VARCHAR(10)                                   
 )                                   
                                    
 INSERT INTO @JOBLIST                                  
(ID_WODET_SEQ,ID_JOB_DEB)                                  
 SELECT ID_WODET_SEQ,ID_JOB_DEB                                  
  FROM                                   
  TBL_WO_DETAIL WOD RIGHT OUTER JOIN TBL_WO_DEBITOR_DETAIL WODEB                                  
  ON WOD.ID_WO_NO= WODEB.ID_WO_NO AND                                  
  WOD.ID_WO_PREFIX = WODEB.ID_WO_PREFIX AND                                  
  WOD.ID_JOB=WODEB.ID_JOB_ID                                   
 WHERE                                   
 WOD.ID_WODET_SEQ IN (SELECT ID_WODET_SEQ FROM @TEMP_TBL_INV_HEADER)                                  
                        
 --Select 1111,* from @JOBLIST                        
                         
 DELETE @JOBLIST FROM                                  
 (SELECT IND.ID_WODET_INV, INH.ID_DEBITOR                                   
 FROM                                  
 TBL_INV_DETAIL IND INNER JOIN TBL_INV_HEADER INH                                   
 ON IND.ID_INV_NO = INH.ID_INV_NO AND INH.ID_CN_NO IS NULL) AS T1 INNER JOIN @JOBLIST J2                                  
 ON J2.ID_WODET_SEQ = T1.ID_WODET_INV AND J2.ID_JOB_DEB= T1.ID_DEBITOR                                  
                           
 --Select 2222,* from @JOBLIST                        
                                   
 -- FIRST CHANGE STATUS OF ALL JOBS (SPECIFIED IN XML FILE) TO INV                                  
 UPDATE                                   
 TBL_WO_DETAIL                                  
 SET                                   
 JOB_STATUS = 'INV'                                   
 WHERE                          
 ID_WODET_SEQ IN (SELECT DISTINCT ID_WODET_SEQ FROM @TEMP_TBL_INV_HEADER)                                  
                                   
 -- THEN CHANGE JOB STATUS TO 'PINV' FOR THOSE JOBS WHICH ARE NOT FULLY INVOICED                                  
 UPDATE                                  
 TBL_WO_DETAIL                                  
 SET            
 JOB_STATUS = 'PINV'                                  
 WHERE                                   
 ID_WODET_SEQ IN ( SELECT DISTINCT ID_WODET_SEQ FROM @JOBLIST)                                  
                                    
                                    
                                    
 IF @@ERROR <> 0                                  
 BEGIN                                  
 ROLLBACK TRANSACTION @TRANNAME                                   
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                  
 END                                   
 ---- CHANGE JOB STATUS FINISHED                                  
                                   
 -- CHANGE WORK ORDER STATUS                                  
 DECLARE @ORDERLIST TABLE                                  
 (                                  
 ID_WO_NO VARCHAR(10),                                  
  ID_WO_PREFIX VARCHAR(3),                                  
  JOB_STATUS VARCHAR(10)                                  
 )                                
                               
 INSERT INTO @ORDERLIST                                  
 SELECT DISTINCT WOD.ID_WO_NO,WOD.ID_WO_PREFIX, WOD.JOB_STATUS                                  
 FROM                                   
 TBL_WO_HEADER WOH INNER JOIN TBL_WO_DETAIL WOD                                  
 ON WOH.ID_WO_NO=WOD.ID_WO_NO AND WOH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                                   
 WHERE                                   
 WOD.ID_WODET_SEQ IN (SELECT ID_WODET_SEQ FROM @TEMP_TBL_INV_HEADER)                          
 AND WOD.JOB_STATUS <> 'DEL'                               
                                   
 INSERT INTO @ORDERLIST                                  
 SELECT DISTINCT WOD.ID_WO_NO,WOD.ID_WO_PREFIX, WOD.JOB_STATUS                                  
 FROM                                   
 TBL_WO_HEADER WOH INNER JOIN TBL_WO_DETAIL WOD                                  
 ON WOH.ID_WO_NO=WOD.ID_WO_NO AND WOH.ID_WO_PREFIX=WOD.ID_WO_PREFIX                                  
 INNER JOIN @ORDERLIST OL                                  
 ON WOH.ID_WO_NO=OL.ID_WO_NO AND WOH.ID_WO_PREFIX=OL.ID_WO_PREFIX                                  
 AND WOD.JOB_STATUS <> 'DEL'                         
                         
                                 
  UPDATE                                   
 TBL_WO_HEADER                                   
 SET                             
 WO_STATUS='INV'                                  
 FROM                                   
 @ORDERLIST OL                           
 WHERE                                  
 TBL_WO_HEADER.ID_WO_NO=OL.ID_WO_NO                                   
 AND                                  
  TBL_WO_HEADER.ID_WO_PREFIX=OL.ID_WO_PREFIX                                  
               
                    

       
 INSERT INTO TBL_INVOICE_DATA(DEBTOR_SEQ,LINE_AMOUNT ,LINE_TYPE ,LINE_VAT_AMOUNT,DISC_PERCENT,PRICE,JOBSUM,INVOICESUM                   
 ,ID_WOLAB_SEQ,DEBTOR_ID,LINE_ID,LINE_AMOUNT_NET,LINE_DISCOUNT,LINE_VAT_PERCENTAGE,CREATED_BY,DT_CREATED,MODIFIED_BY,DT_MODIFIED,ID_WO_PREFIX,              
  ID_WO_NO,ID_JOB_ID,ID_WOITEM_SEQ,FIXED_PRICE,FIXED_PRICE_VAT,DEL_QTY,CALCULATEDFROM,FINDVAT,VATAMOUNT,VAT_TRANSFER,ID_INV_NO)              
  SELECT NULL,LINE_AMOUNT ,LINE_TYPE ,LINE_VAT_AMOUNT,DISC_PERCENT,DEBINV.PRICE,JOBSUM,INVOICESUM                   
 ,DEBINV.ID_WOLAB_SEQ,DEBTOR_ID,LINE_ID,LINE_AMOUNT_NET,LINE_DISCOUNT,LINE_VAT_PERCENTAGE,DEBINV.CREATED_BY,DEBINV.DT_CREATED,DEBINV.MODIFIED_BY,DEBINV.DT_MODIFIED,DEBINV.ID_WO_PREFIX,              
 DEBINV.ID_WO_NO,DEBINV.ID_JOB_ID,DEBINV.ID_WOITEM_SEQ,FIXED_PRICE,FIXED_PRICE_VAT,DEL_QTY,CALCULATEDFROM,FINDVAT,DEBINV.VATAMOUNT,VAT_TRANSFER,A.ID_INV_NO               
   FROM TBL_INV_HEADER A                                
 LEFT OUTER JOIN @INVOICETEMP1 B                                  
  ON A.ID_DEBITOR = B.ID_DEBITOR                        
 LEFT OUTER JOIN TBL_WO_DETAIL DET                        
  ON B.ID_WODET_SEQ=DET.ID_WODET_SEQ                        
 LEFT OUTER JOIN TBL_WO_HEADER WOH                        
  ON WOH.ID_WO_NO = b.ID_WO_NO AND WOH.ID_WO_PREFIX = b.ID_WO_PREFIX                        
 LEFT OUTER JOIN TBL_WO_DEBITOR_DETAIL DBDET                        
  ON DBDET.ID_WO_NO=DET.ID_WO_NO AND DBDET.ID_WO_PREFIX=DET.ID_WO_PREFIX AND DBDET.ID_JOB_ID=DET.ID_JOB AND A.ID_DEBITOR=DBDET.ID_JOB_DEB                        
 LEFT OUTER JOIN TBL_WO_DEBTOR_INVOICE_DATA DEBINV                        
  ON DEBINV.DEBTOR_SEQ = DBDET.ID_DBT_SEQ                  
 WHERE                                   
 A.ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)                              

SELECT DISTINCT ID_INV_NO,INVOICESUM,CALCULATEDFROM,FINDVAT,VATAMOUNT INTO #TEMP FROM TBL_INVOICE_DATA 
WHERE ID_INV_NO IN(SELECT ID_INV_NO FROM @INVOICETEMP1)    

SELECT ID_INV_NO,SUM(INVOICESUM) INVOICESUM,SUM(CALCULATEDFROM) CALCULATEDFROM,SUM(FINDVAT) FINDVAT,SUM(VATAMOUNT) VATAMOUNT INTO #SUM FROM #TEMP
GROUP BY ID_INV_NO

UPDATE INVDT SET INVDT.INVOICESUM=TOT.INVOICESUM,INVDT.CALCULATEDFROM=TOT.CALCULATEDFROM,INVDT.FINDVAT=TOT.FINDVAT,INVDT.VATAMOUNT=TOT.VATAMOUNT
FROM TBL_INVOICE_DATA INVDT INNER JOIN #SUM TOT 
ON TOT.ID_INV_NO=INVDT.ID_INV_NO

 update tbl_inv_header set                                 
 INV_TOT = dbo.FnGetInvoiceAmount(ID_INV_NO)                        
 ,INV_RD_AMT = dbo.FnGetRoundingamount(ID_INV_NO)                           
 WHERE ID_INV_NO IN (SELECT ID_INV_NO FROM @INVOICETEMP1)   

DROP TABLE #TEMP
DROP TABLE #SUM

                                      
 IF @@ERROR <> 0                                  
 BEGIN                              
 ROLLBACK TRANSACTION @TRANNAME                                  
 SET @OV_RETVALUE = 'INSFLG'                                   
  IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                        
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
 RETURN                                  
 END                            
 --SELECT * FROM@ORDERLIST                                   
 DELETE FROM @ORDERLIST                                  
 WHERE                                   
 JOB_STATUS = 'INV'                                  
                                   
 --SELECT * FROM@ORDERLIST                                  
 UPDATE                                   
 TBL_WO_HEADER                                  
 SET                                  
 WO_STATUS='PINV'                                  
 FROM                                   
 @ORDERLIST OL                                   
 WHERE                                   
 TBL_WO_HEADER.ID_WO_NO=OL.ID_WO_NO                                   
 AND                                   
 TBL_WO_HEADER.ID_WO_PREFIX=OL.ID_WO_PREFIX                                   
                                   
 -- CHANGE WORK ORDER STATUS FINISHED                                  
 --                                 
                           
                        
                                 
 IF @@ERROR = 0                                   
  BEGIN                             
   COMMIT TRANSACTION @TRANNAME                                           
                        
 --INSERT THE SALES JOURNAL RECORD                        
                        
 DECLARE @INVOICENUM AS NCHAR(10)                        
                        
 BEGIN TRY                        
  DECLARE SALESJOURNALINS CURSOR FOR                        
  SELECT                                   
   DISTINCT ID_INV_NO                        
  FROM                         
   @INVOICESUM                        
                        
  OPEN SALESJOURNALINS                        
  FETCH NEXT FROM SALESJOURNALINS INTO @INVOICENUM                        
  WHILE @@FETCH_STATUS <> -1                        
  BEGIN                        
   EXEC [USP_INSERT_SALES_JOURNAL] @INVOICENUM                        
   FETCH NEXT FROM SALESJOURNALINS INTO @INVOICENUM                        
  END                        
                        
  CLOSE SALESJOURNALINS                        
  DEALLOCATE SALESJOURNALINS                        
 END TRY                        
 BEGIN CATCH                        
  CLOSE SALESJOURNALINS                        
  DEALLOCATE SALESJOURNALINS                        
 END CATCH                        
                        
 --END OF SALES JOURNAL INSERTION              
                        
INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End Other Functions',getdate(),21,@NEW_GUID)                             
  INSERT INTO TBL_INV_CREATE_TRACK values (@IV_XMLDOC,'End CreateINV',getdate(),1,@NEW_GUID)                        
                        
   IF @RET_MESSAGE='WARN'                                  
    BEGIN                                  
  SET @OV_RETVALUE = 'WARN'                                   
    END                                   
   ELSE                                  
    BEGIN                                  
  SET @OV_RETVALUE = '0'                                   
                            
    --print '@OV_RETVALUE'           
    --print @OV_RETVALUE                        
    --print @COUNT_ORD                        
     IF @COUNT_ORD = 0                        
   bEGIN                        
     SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
   END                        
   ELSE IF @COUNT_ORD = -1                        
   BEGIN                        
     SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
   END                        
  END                         
  RETURN                                   
  END                                  
 ELSE                                  
  BEGIN                                 
   ROLLBACK TRANSACTION @TRANNAME                                   
   SET @OV_RETVALUE = 'INSFLG'                         
                           
   IF @COUNT_ORD = 0                        
  BEGIN                        
    SET @OV_RETVALUE = 'INC_INV' -- INCOMPLETE INVOICING                         
  END                        
  ELSE IF @COUNT_ORD = -1                   
  BEGIN                        
    SET @OV_RETVALUE = 'NONE_INV' -- NO ORDERS WHERE INVOICED                        
  END                        
                           
  RETURN                                  
  END                           
                        
END 
GO

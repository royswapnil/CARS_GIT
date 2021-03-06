/****** Object:  StoredProcedure [dbo].[USP_REP_INVOICE_BASIS]    Script Date: 8/7/2017 1:17:20 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_INVOICE_BASIS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_REP_INVOICE_BASIS]
GO
/****** Object:  StoredProcedure [dbo].[USP_REP_INVOICE_BASIS]    Script Date: 8/7/2017 1:17:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_INVOICE_BASIS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_REP_INVOICE_BASIS] AS' 
END
GO
-- =============================================                  
-- Author:      Rajaram Ganjikunta                  
-- Create date: 14-Oct-2008                  
-- Description: Generate Invoice Basis                 
----------------------------------------------------        
-- Author: Praveen K        
-- Date: 27-Jun-2013        
-- Description: ROW 625 Added condition to check for fixed for Labour Line         
-- =============================================                 
ALTER PROCEDURE [dbo].[USP_REP_INVOICE_BASIS]                
(                
  @IV_XMLDOC XML = '<ROOT><INV_GENERATE  ID_WO_PREFIX="WO"  ID_WO_NO="1019"            
ID_WODET_SEQ="4"  ID_JOB_DEB="993" FLG_BATCH="True" /></ROOT>',              
  @TYPE VARCHAR(50)  = 'INVOICEBASIS'            
)            
AS            
BEGIN            
 SET NOCOUNT ON            
 DECLARE @TRANNAME VARCHAR(20), @IDOC AS INT            
 DECLARE @JOB_DEB_LIST TABLE            
 (            
  ID_WO_NO VARCHAR(10),            
  ID_WO_PREFIX VARCHAR(3),            
  ID_WODET_SEQ INT,            
  ID_JOB_DEB VARCHAR(10),            
  FLG_BATCH BIT   ,        
  IV_DATE DATETIME          
 )            
 DECLARE @INVOICETEMP TABLE            
 (            
  ID_WO_NO VARCHAR(10),            
  ID_WO_PREFIX        VARCHAR(3),            
  ID_WODET_SEQ        INT,            
  ID_INV_NO           VARCHAR(10),            
  ID_DEPT_INV       INT,            
  ID_SUBSIDERY_INV    INT,            
  DT_INVOICE          DATETIME,            
  DEBITOR_TYPE        CHAR(1),            
  ID_DEBITOR          VARCHAR(10),            
  INV_AMT DECIMAL,            
  INV_KID VARCHAR(25),            
  ID_CN_NO VARCHAR(15),            
  FLG_BATCH_INV       BIT,            
  FLG_TRANS_TO_ACC    BIT,            
  CREATED_BY          VARCHAR(20),            
  DT_CREATED          DATETIME,            
  INVPREFIX           VARCHAR(10),            
  INVSERIES           VARCHAR(7),            
  INVMAXNUM   INT,            
  INVWARNLEV   INT,            
  WARN    BIT,            
  OVERFLOW   BIT,            
     WO_VEH_REG_NO       VARCHAR(15),            
     WO_JOB_TXT          TEXT,            
  CUST_PERM_ADD1  VARCHAR(50),            
     CUST_PERM_ADD2 VARCHAR(50),            
  WO_CUST_NAME   VARCHAR(100),        
  ID_JOB INT,        
  INVSEQ INT             
 )                 
         
 DECLARE @TBL_INV_HEADER TABLE            
 (            
    ID_DEBITOR varchar(10),            
    ID_INV_NO nchar(20),            
    ID_DEPT_INV int,            
    ID_SUBSIDERY_INV int,            
    DT_INVOICE datetime,            
    DEBITOR_TYPE char(1),            
    INV_AMT decimal(15,2),            
    INV_KID varchar(25),            
    ID_CN_NO varchar(15),            
    FLG_BATCH_INV bit,            
    FLG_TRANS_TO_ACC bit,            
    CREATED_BY varchar(20),            
    DT_CREATED datetime,                       
    CUST_PERM_ADD1 varchar(50),                      
    CUST_PERM_ADD2 varchar(50),                
    CUST_NAME varchar(100),                
    INV_CUST_GROUP INT,        
    INV_FEES_AMT DECIMAL(20,2),        
    FLG_INV_FEES BIT                    
 )           
           
 DECLARE @TBL_INV_DETAIL TABLE            
 (                
    [ID_INV_NO] [nchar](10),                
    [ID_WODET_INV] [int] ,                
    [VEH_REG_NO] [varchar](15),                
    [CREATED_BY] [varchar](20) ,                
    [DT_CREATED] [datetime] ,                
    ID_WO_NO [varchar](10),                
    ID_WO_PREFIX [varchar](3),                
    ID_JOB [int],                
    [INVD_GM_ACCCODE] [varchar](10),                
    [INVD_GM_VAT] [varchar](10),                
    [INVD_VAT_ACCOUNTCODE] [varchar](20),                
    [INVD_VAT_AMOUNT] [numeric](15, 2),                
    INVD_VAT_PERCENTAGE [numeric](5, 2),                
    [WO_JOB_TXT] [text],                
    [IN_DEB_JOB_AMT] [decimal](15, 2),                
    [FLG_FIXED_PRICE] [bit],                
    [IN_DEB_GM_AMT] [decimal](15, 2),                
    [WO_VEH_MILEAGE] int--,            
 )                
         
 DECLARE @TBL_INV_DETAIL_LINES TABLE                
 (                
    [ID_INV_NO] [nchar](10) ,            
    [ID_WODET_INVL] [int] ,            
    [FLG_ITEM] [bit] ,            
    [ID_WOITEM_SEQ] [int] ,                
    [ID_WH_INVL] [int] ,            
    [ID_ITEM_INVL] [varchar](30) ,            
    [INVL_Description] [varchar](100) ,            
  [INVL_AVERAGECOST] [numeric](15, 2),            
    [INVL_DELIVER_QTY] [decimal](15, 5),                
    [INVL_Price] [decimal](15, 2),                
    [INVL_DIS] [decimal](15, 2),                
    [INVL_DEB_CONTRIB] [decimal](15, 5),                
    [CREATED_BY] [nchar](20),                
    [DT_CREATED] [datetime],                
    [INVL_LINETYPE] [varchar](15),                
    [INVL_VAT_ACCCODE] [varchar](10),                
    [INVL_VAT_CODE] [varchar](10),                
    [INVL_VAT_PER] [numeric](5, 2),                
    [INVL_SPARES_ACCOUNTCODE] [varchar](20),                
    [INVL_BFAMOUNT] [numeric](15, 2),                
    [INVL_AMOUNT] [numeric](15, 2),                
    [INVL_VAT] [decimal](15, 2),                
    [ID_MAKE] [VARCHAR](10),                
    [ID_WAREHOUSE] [INT]                
 )            
             
 DECLARE @TBL_INV_DETAIL_LINES_LABOUR TABLE                
 (                
    [ID_INV_NO] [nchar](10),            
    [ID_WODET_INVL] [int],            
    [FLG_ITEM] [bit],            
    [ID_WH_INVL] [int],            
    [INVL_IDLOGIN] [varchar](20),            
    [INVL_Description] [varchar](50) ,            
    [INVL_Mech_hour] [decimal](15, 5) ,            
    [INVL_MECh_Hourly_Price] [decimal](15, 2),            
    [INVL_STTime] [numeric](15, 2),            
    [INVL_DEB_CONTRIB] [decimal](15, 5),            
    [CREATED_BY] [nchar](20),            
    [DT_CREATED] [datetime],            
    [INVL_LINETYPE] [varchar](15),            
    [INVL_VAT_ACCCODE] [varchar](10),            
    [INVL_VAT_CODE] [varchar](10),            
    [INVL_VAT_PER] [numeric](5, 2),            
    [INVL_Labour_ACCOUNTCODE] [varchar](20),            
    [INVL_STHour] [numeric](15, 2) ,            
    [INVL_AMOUNT] [numeric](15, 2) ,            
    [INVL_VAT] [decimal](15, 2) ,            
    [INVL_DIS] [decimal](15, 2),            
    [INVL_BFAMOUNT] [numeric](15, 2)          
 )                
         
 DECLARE @TBL_INV_DETAIL_LINES_VAT TABLE                
 (                
    [ID_INV_NO] [nchar](20),            
    [ID_WODET_INV] [int],            
    [INVL_VAT_ACCCODE] [varchar](20),            
    [INVL_VAT_AMOUNT] [numeric](15, 2)            
 )         
        
         
 SELECT @TRANNAME = 'INVOICE_INSERT'            
                 
 BEGIN TRANSACTION @TRANNAME                    
  EXEC SP_XML_PREPAREDOCUMENT @IDOC OUTPUT,@IV_XMLDOC            
  INSERT INTO @JOB_DEB_LIST              
  SELECT            
   ID_WO_NO ,              
   ID_WO_PREFIX ,            
   ID_WODET_SEQ ,            
   ID_JOB_DEB ,            
   FLG_BATCH ,        
   IV_DATE           
  FROM OPENXML(@IDOC,'ROOT/INV_GENERATE',1)            
  WITH            
  (            
   ID_WO_NO VARCHAR(10),            
   ID_WO_PREFIX VARCHAR(3),            
   ID_WODET_SEQ INT,            
   ID_JOB_DEB VARCHAR(10),            
   FLG_BATCH BIT,        
   IV_DATE DATETIME             
  )            
          
  EXEC SP_XML_REMOVEDOCUMENT @IDOC          
         
 /**********UPDATE TO HANDLE DIFFERENT BATCH STATUS ON CUSTOMERS**************/        
  --BATCH STATUS DOES NOT MAKE A DIFFERENCE ON INVOICE BASIS SINCE IT IS USED ONLY IN PAYMENT SUMMARY        
  UPDATE @JOB_DEB_LIST SET FLG_BATCH=1        
 /*****END*****/        
         
 --Changed as per row-136        
 DECLARE @WO_TOT_SPARE_AMT TABLE(ID_WO_NO VARCHAR(10), ID_WO_PREFIX VARCHAR(3),ID_DEBITOR INT, WO_TOT_SPAREAMT INT,FLG_BATCH BIT)        
 INSERT INTO @WO_TOT_SPARE_AMT        
 SELECT DISTINCT WDD.ID_WO_NO, WDD.ID_WO_PREFIX ,WDD.ID_JOB_DEB,SUM(WDD.DBT_AMT),JDBL.FLG_BATCH FROM TBL_WO_DEBITOR_DETAIL WDD        
 INNER JOIN TBL_WO_DETAIL WOD        
 on WDD.ID_WO_NO = WOD.ID_WO_NO AND WDD.ID_WO_PREFIX =WOD.ID_WO_PREFIX AND WDD.ID_JOB_ID = WOD.ID_JOB        
 INNER JOIN @JOB_DEB_LIST JDBL        
 ON WDD.ID_WO_NO = JDBL.ID_WO_NO AND WDD.ID_WO_PREFIX = JDBL.ID_WO_PREFIX         
 AND WDD.ID_JOB_DEB = JDBL.ID_JOB_DEB        
 GROUP BY WDD.ID_WO_NO, WDD.ID_WO_PREFIX,WDD.ID_JOB_DEB,JDBL.FLG_BATCH         
         
 --Added as per row--205         
 update @WO_TOT_SPARE_AMT        
 set WO_TOT_SPAREAMT =  q.tot        
 from (select sum (wt.WO_TOT_SPAREAMT) as tot,WT.ID_DEBITOR   FROM @WO_TOT_SPARE_AMT WT INNER JOIN        
 @WO_TOT_SPARE_AMT WTT        
 on WTT.ID_DEBITOR = WT.ID_DEBITOR AND WT.ID_WO_NO =WTT.ID_WO_NO AND WT.ID_WO_PREFIX =WTT.ID_WO_PREFIX        
 GROUP BY WT.ID_DEBITOR )q        
 where FLG_BATCH = 1        
  --End of Change         
         
            
  INSERT INTO @INVOICETEMP            
    SELECT             
     TEMP.ID_WO_NO ,            
     TEMP.ID_WO_PREFIX,            
     TEMP.ID_WODET_SEQ,            
     '' ,            
     WOHEADER.ID_DEPT,            
     WOHEADER.ID_SUBSIDERY,            
     CASE         
    WHEN ((TEMP.IV_DATE is null) or (TEMP.IV_DATE = ''))                   
    THEN                  
     --Bug ID:-3029              
     -- Date  :-18-Aug-2008            
     --GETDATE()              
     CONVERT(VARCHAR(10),GETDATE(),101)                  
     --change end              
    ELSE                  
     --Bug ID:-3029              
     -- Date  :-18-Aug-2008              
     --CONVERT(DATETIME,TEMP.IV_DATE,103)                  
     CONVERT(VARCHAR(10),TEMP.IV_DATE,101)                  
     --CHANGE END              
   END,              
     ISNULL(DEBITOR_TYPE,'N') ,            
     --'N',            
     ISNULL(DEBITORDETAIL.ID_JOB_DEB,0),            
     NULL,            
     1,             
     NULL,             
     TEMP.FLG_BATCH,               
     NULL,             
     'admin',             
     GETDATE(),             
     CASE           
    WHEN WOHEADER.ID_DEPT IS NOT NULL AND WOHEADER.ID_SUBSIDERY IS NOT NULL THEN          
    CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN                      
     (                   
     SELECT INV_PREFIX                     
     FROM TBL_MAS_INV_PAYMENT_SERIES                     
     WHERE ID_PAYSERIES = (          
      SELECT top 1 INV_CRENOSEREIES                     
      FROM TBL_MAS_INV_NUMBER_CFG                          
      WHERE ID_SETTINGS = (                          
       SELECT ID_PAY_TYPE           
       FROM TBL_MAS_CUST_GROUP MCG                          
       WHERE MCG.ID_CUST_GRP_SEQ=WO_CUST_GROUPID                          
      )                          
      AND ID_INV_CONFIG = (          
       SELECT ID_INV_CONFIG                     
       FROM TBL_MAS_INV_CONFIGURATION                     
       WHERE ID_SUBSIDERY_INV=WOHEADER.ID_Subsidery           
        AND ID_DEPT_INV=WOHEADER.ID_Dept                           
        AND WOHEADER.DT_CREATED BETWEEN DT_CREATED AND ISNULL(DT_EFF_TO,GETDATE())                         
      )                          
     )                          
    )           
    ELSE          
     (                   
    SELECT INV_PREFIX                    
     FROM TBL_MAS_INV_PAYMENT_SERIES                    
     WHERE ID_PAYSERIES = (          
      SELECT top 1 INV_INVNOSERIES                     
      FROM TBL_MAS_INV_NUMBER_CFG                     
      WHERE ID_INV_CONFIG = (                    
       SELECT top 1 ID_INV_CONFIG                    
       FROM TBL_MAS_INV_CONFIGURATION                    
       WHERE DT_EFF_TO IS NULL           
        AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY           
        AND ID_DEPT_INV = WOHEADER.ID_DEPT                     
      )                     
      AND ID_SETTINGS = (                    
       SELECT top 1 ID_SETTINGS                     
FROM TBL_MAS_SETTINGS                    
       WHERE ID_CONFIG = 'PAYTYPE'                     
        AND ID_SETTINGS = (                    
         SELECT top 1 CUSTGRP.ID_PAY_TYPE                    
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                    
         WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)                    
          AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                     
        )                     
      ) --END FOR ID SETTINGS                    
     ) --END FOR WHERE                         
    )               
    END                   
    ELSE 'NO VALUE'                    
   END AS 'PREFIX',   -- PREFIX          
     CASE                   
    WHEN WOHEADER.ID_DEPT IS NOT NULL         
     AND WOHEADER.ID_SUBSIDERY IS NOT NULL THEN        
    CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN          
     (                   
     SELECT ISNULL(INV_STARTNO,0)                  
     FROM TBL_MAS_INV_PAYMENT_SERIES                  
     WHERE ID_PAYSERIES = (        
      SELECT top 1 INV_CRENOSEREIES                   
      FROM TBL_MAS_INV_NUMBER_CFG                   
      WHERE ID_INV_CONFIG = (                  
       SELECT top 1 ID_INV_CONFIG                  
       FROM TBL_MAS_INV_CONFIGURATION                  
       WHERE DT_EFF_TO IS NULL         
        AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY         
        AND ID_DEPT_INV = WOHEADER.ID_DEPT                   
      )                   
      AND ID_SETTINGS = (                  
       SELECT top 1 ID_SETTINGS                   
       FROM TBL_MAS_SETTINGS                  
       WHERE ID_CONFIG = 'PAYTYPE'                   
        AND ID_SETTINGS = (                  
         SELECT top 1 CUSTGRP.ID_PAY_TYPE                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                  
         WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)                  
          AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                   
        )                   
      ) --END FOR ID SETTINGS                  
     ) --END FOR WHERE                  
    )--END FOR SELECT         
    ELSE        
     (                   
     SELECT ISNULL(INV_STARTNO,0)                  
     FROM TBL_MAS_INV_PAYMENT_SERIES                  
     WHERE ID_PAYSERIES = (        
      SELECT top 1 INV_INVNOSERIES                   
      FROM TBL_MAS_INV_NUMBER_CFG                   
      WHERE ID_INV_CONFIG = (                  
       SELECT top 1 ID_INV_CONFIG                  
       FROM TBL_MAS_INV_CONFIGURATION                  
       WHERE DT_EFF_TO IS NULL         
        AND ID_SUBSIDERY_INV =WOHEADER.ID_SUBSIDERY         
        AND ID_DEPT_INV = WOHEADER.ID_DEPT                   
      )                   
      AND ID_SETTINGS = (                  
       SELECT top 1 ID_SETTINGS                   
       FROM TBL_MAS_SETTINGS                  
       WHERE ID_CONFIG = 'PAYTYPE'                   
        AND ID_SETTINGS = (                  
         SELECT top 1 CUSTGRP.ID_PAY_TYPE                  
         FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                  
         WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)                  
          AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                   
        )                   
      ) --END FOR ID SETTINGS                  
     ) --END FOR WHERE                  
    )--END FOR SELECT          
    END               
    ELSE 'NO VALUE'                  
   END AS 'SERIES',  -- SERIES,             
     CASE             
   WHEN WOHEADER.ID_DEPT IS NOT NULL AND WOHEADER.ID_SUBSIDERY IS NOT NULL  THEN         
   CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN              
     (SELECT  ISNULL(INV_ENDNO,0) FROM  TBL_MAS_INV_PAYMENT_SERIES WHERE                 
   ID_PAYSERIES =                    
    (                    
     SELECT  INV_CRENOSEREIES FROM TBL_MAS_INV_NUMBER_CFG WHERE            
     ID_INV_CONFIG =            
      (                    
    SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION              
    WHERE DT_EFF_TO IS NULL AND ID_SUBSIDERY_INV =  WOHEADER.ID_SUBSIDERY AND              
    ID_DEPT_INV = WOHEADER.ID_DEPT             
      )            
    AND ID_SETTINGS =            
      (                    
     SELECT ID_SETTINGS FROM TBL_MAS_SETTINGS            
     WHERE ID_CONFIG = 'PAYTYPE'            
     AND ID_SETTINGS =                    
      (                    
     SELECT CUSTGRP.ID_PAY_TYPE            
     FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                    
     WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)                    
     AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                        )                    
    ) --END FOR ID SETTINGS                    
     ) --END FOR WHERE                    
    )--END FOR SELECT             
    ELSE        
     (SELECT  ISNULL(INV_ENDNO,0) FROM  TBL_MAS_INV_PAYMENT_SERIES WHERE                 
   ID_PAYSERIES =                    
    (                    
     SELECT  INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG WHERE            
     ID_INV_CONFIG =            
      (                    
    SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION              
    WHERE DT_EFF_TO IS NULL AND ID_SUBSIDERY_INV =  WOHEADER.ID_SUBSIDERY AND              
    ID_DEPT_INV = WOHEADER.ID_DEPT             
      )            
    AND ID_SETTINGS =            
      (                    
     SELECT ID_SETTINGS FROM TBL_MAS_SETTINGS            
     WHERE ID_CONFIG = 'PAYTYPE'            
     AND ID_SETTINGS =                    
      (                    
     SELECT CUSTGRP.ID_PAY_TYPE            
     FROM TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                    
     WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)                    
     AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                    
      )                    
    ) --END FOR ID SETTINGS                    
     ) --END FOR WHERE                    
    )--END FOR SELECT               
   END               
   ELSE 0              
     END AS 'INVMAXNUM',  -- INVMAXNUM,             
     CASE                 
     WHEN WOHEADER.ID_DEPT IS NOT NULL  AND WOHEADER.ID_SUBSIDERY IS NOT NULL  THEN           
     CASE WHEN  WSP.WO_TOT_SPAREAMT < 0 THEN              
     (SELECT ISNULL(INV_WARNINGBEFORE,0) FROM TBL_MAS_INV_PAYMENT_SERIES WHERE                 
    ID_PAYSERIES = (                   
      SELECT INV_CRENOSEREIES FROM TBL_MAS_INV_NUMBER_CFG WHERE            
      ID_INV_CONFIG =            
      (                    
     SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION             
     WHERE DT_EFF_TO IS NULL AND ID_SUBSIDERY_INV =  WOHEADER.ID_SUBSIDERY AND              
     ID_DEPT_INV = WOHEADER.ID_DEPT            
      )            
     AND ID_SETTINGS =            
      (                    
      SELECT ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE            
      ID_CONFIG = 'PAYTYPE'            
      AND ID_SETTINGS =                    
      (                    
      SELECT CUSTGRP.ID_PAY_TYPE FROM            
      TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                  
      WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)             
      AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                    
      )                    
      )                
     )                   
     )          
     ELSE        
                  
     (SELECT ISNULL(INV_WARNINGBEFORE,0) FROM TBL_MAS_INV_PAYMENT_SERIES WHERE                 
    ID_PAYSERIES = (                   
      SELECT INV_INVNOSERIES FROM TBL_MAS_INV_NUMBER_CFG WHERE            
      ID_INV_CONFIG =            
      (                    
     SELECT ID_INV_CONFIG FROM TBL_MAS_INV_CONFIGURATION             
     WHERE DT_EFF_TO IS NULL AND ID_SUBSIDERY_INV =  WOHEADER.ID_SUBSIDERY AND              
     ID_DEPT_INV = WOHEADER.ID_DEPT            
      )            
     AND ID_SETTINGS =            
      (                    
      SELECT ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE            
      ID_CONFIG = 'PAYTYPE'            
      AND ID_SETTINGS =                    
      (                    
      SELECT CUSTGRP.ID_PAY_TYPE FROM            
      TBL_MAS_CUSTOMER CUST,TBL_MAS_CUST_GROUP CUSTGRP                  
      WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)             
      AND CUST.ID_CUST_GROUP = CUSTGRP.ID_CUST_GRP_SEQ                    
      )                    
      )                
     )                   
     )             
     END                 
     ELSE 0              
     END AS 'INVWARNLEV',            
     'FALSE' as WARN,             
     'FALSE' as OVERFLOW,             
     WOHEADER.WO_VEH_REG_NO,            
     WODET.WO_JOB_TXT,                
     (SELECT WOHEADER.WO_CUST_PERM_ADD1 FROM TBL_MAS_CUSTOMER CUST WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)),                       
     (SELECT WOHEADER.WO_CUST_PERM_ADD2 FROM TBL_MAS_CUSTOMER CUST WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0)),                 
  --   CASE                 
  --      WHEN WODEBDET.DEBITOR_TYPE = 'C' THEN            
  --      WOHEADER.WO_CUST_NAME             
  --      ELSE            
  --      (             
  --     SELECT CUST.CUST_NAME FROM TBL_MAS_CUSTOMER CUST WHERE CUST.ID_CUSTOMER = ISNULL(WODEBDET.ID_CUST_WO,0)             
  --      )            
  --   END             
     (SELECT CUST.CUST_NAME FROM TBL_MAS_CUSTOMER CUST WHERE CUST.ID_CUSTOMER = ISNULL(DEBITORDETAIL.ID_JOB_DEB,0) ),        
    WODET.ID_JOB ,        
  --ROW_NUMBER() OVER(ORDER BY WODET.ID_JOB )AS ID_JOB         
  CAST(ROW_NUMBER() OVER(PARTITION BY WODET.ID_WO_NO, WODET.ID_WO_PREFIX, DEBITORDETAIL.ID_JOB_DEB ORDER BY WODET.ID_WO_NO, WODET.ID_WO_PREFIX,DEBITORDETAIL.ID_JOB_DEB DESC) AS VARCHAR)              
    FROM @JOB_DEB_LIST TEMP          
   INNER JOIN          
   TBL_WO_DETAIL WODET          
   ON  TEMP.ID_WO_NO  = WODET.ID_WO_NO          
    AND TEMP.ID_WO_PREFIX = WODET.ID_WO_PREFIX          
    AND TEMP.ID_WODET_SEQ = WODET.ID_WODET_SEQ          
    INNER JOIN               
   TBL_WO_HEADER WOHEADER            
    ON WODET.ID_WO_NO = WOHEADER.ID_WO_NO           
    AND WODET.ID_WO_PREFIX = WOHEADER.ID_WO_PREFIX          
    INNER JOIN           
     TBL_WO_DEBITOR_DETAIL DEBITORDETAIL           
    ON           
     WODET.ID_WO_NO = DEBITORDETAIL.ID_WO_NO           
     AND WODET.ID_WO_PREFIX = DEBITORDETAIL.ID_WO_PREFIX           
    AND WODET.ID_JOB = DEBITORDETAIL.ID_JOB_ID        
   --Bug ID:- Invoice Basis Problem         
   --date  :- 18-NOV-2008        
   --Desc  :- Mapping not perfect         
    and TEMP.ID_JOB_DEB=DEBITORDETAIL.ID_JOB_DEB        
   --change end        
  INNER JOIN TBL_MAS_CUSTOMER CUST         
   ON CUST.ID_CUSTOMER=TEMP.ID_JOB_DEB           
        JOIN @WO_TOT_SPARE_AMT WSP        
  ON WSP.ID_WO_NO = TEMP.ID_WO_NO         
  AND WSP.ID_WO_PREFIX = TEMP.ID_WO_PREFIX        
 AND WSP.ID_DEBITOR= DEBITORDETAIL.ID_JOB_DEB        
            
               
CREATE TABLE #TEMPNOTINV_Basis           
(          
 ID_NOTINV INT IDENTITY(1,1) NOT NULL,        
 ID_WO_NOTINV VARCHAR(13)          
)          
        
          
DECLARE @RET_ID_WO_NOTINV AS VARCHAR(13)          
DECLARE @INDEX AS INT          
DECLARE @TOTCOUNT AS INT          
DECLARE @ID_WO_NOTINV AS NVARCHAR(MAX)        
        
        
        
        
INSERT INTO #TEMPNOTINV_Basis          
SELECT ID_WO_PREFIX+ID_WO_NO          
FROM @INVOICETEMP          
WHERE INVPREFIX IS NULL          
          
DELETE FROM @INVOICETEMP          
WHERE INVPREFIX IS NULL          
        
          
SET @INDEX = 1          
SELECT @TOTCOUNT = COUNT(*) FROM #TEMPNOTINV_Basis          
        
WHILE(@INDEX <= @TOTCOUNT)          
BEGIN          
 SELECT @RET_ID_WO_NOTINV = ID_WO_NOTINV           
 FROM #TEMPNOTINV_Basis          
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
          
          
DROP TABLE #TEMPNOTINV_Basis          
        
        
        
--TO BE REMOVED        
--SELECT '@INVOICETEMPT',* FROM @INVOICETEMP        
--REMOVED END        
           
  -- INSERT INTO THE TBL_INVOICE HEADER BASED UPON BATCH PROPERTY            
  -- IF ITS BATCH INOVICE THEN SELECT DISTINCT DEBITOR IRRESPECT OF WORK ORDER AND GENEREATE INVOICE            
  -- CREATE ONE MORE TEMP TABLE TO INSERT WITH CODING NO BECAUSE THE EXISTING TEMP             
  -- TABLE WONT CONTAINS INVNO AND THIS TABLE IS USED FURTHER          
          
          
   --Changed As Per row-136        
                
  DECLARE @INVPREFIX AS VARCHAR(4)         
     DECLARE @INVSERIES AS VARCHAR(10)        
  SELECT @INVPREFIX = INVPREFIX, @INVSERIES = INVSERIES FROM @INVOICETEMP         
  --PRINT @InvPrefix         
  DECLARE @INV_NUMBER AS  INT        
  SELECT @INV_NUMBER = dbo.ROWMAXIMUM(@INVPREFIX, @INVSERIES)        
  DECLARE @CN_NUMBER AS  INT        
  SELECT @CN_NUMBER = dbo.ROWMAXIMUM_CREDIT(@INVPREFIX, @INVSERIES)        
         
 --END Of Change           
            
  DECLARE @INVOICETEMP1 TABLE            
  (            
    ID_WO_NO VARCHAR(10),            
    ID_WO_PREFIX        VARCHAR(3),            
    ID_WODET_SEQ        INT,            
    ID_INV_NO           VARCHAR(10),            
    ID_DEPT_INV         INT,            
    ID_SUBSIDERY_INV    INT,            
    DT_INVOICE          DATETIME,            
    DEBITOR_TYPE        CHAR(1),            
    ID_DEBITOR          VARCHAR(10),            
    INV_AMT DECIMAL,            
    INV_KID VARCHAR(25),            
    ID_CN_NO VARCHAR(15),            
    FLG_BATCH_INV   BIT,                  
    FLG_TRANS_TO_ACC    BIT,            
    CREATED_BY          VARCHAR(20),                    
    DT_CREATED          DATETIME,            
    INVPREFIX           VARCHAR(10),                  
    INVSERIES           VARCHAR(7),            
    INVMAXNUM   INT,            
    INVWARNLEV   INT,            
    WARN    BIT,            
    OVERFLOW   BIT,               
    WO_VEH_REG_NO       VARCHAR(15),            
    WO_JOB_TXT          TEXT,                      
    CUST_PERM_ADD1 VARCHAR(50),                      
    CUST_PERM_ADD2 VARCHAR(50),                
    WO_CUST_NAME  VARCHAR(100)                
  )                
         
             
  --INSERT INTO THE TEMP TABLE WITH INVOICE NO         
  IF @CN_NUMBER > @INV_NUMBER        
  BEGIN               
  INSERT INTO @INVOICETEMP1             
  (            
    ID_DEBITOR,            
    ID_INV_NO,             
    ID_WO_NO ,            
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
    CUST_PERM_ADD1  ,                      
    CUST_PERM_ADD2 ,                
    WO_CUST_NAME,            
    WO_VEH_REG_NO                 
  )                       
  SELECT DISTINCT                
   ID_DEBITOR,            
   INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+               
   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),                
   ID_WO_NO ,            
   ID_WO_PREFIX,            
   ID_WODET_SEQ,            
   ID_DEPT_INV,            
   ID_SUBSIDERY_INV,              
   DT_INVOICE,            
   DEBITOR_TYPE,            
   ISNULL(INV_AMT,0),         INV_KID,            
   ID_CN_NO,            
   FLG_BATCH_INV,            
   FLG_TRANS_TO_ACC,            
   CREATED_BY,                   
   DT_CREATED ,            
   INVPREFIX,            
   INVSERIES,            
   INVMAXNUM,              
   INVWARNLEV,               
   CASE                 
    WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVWARNLEV)                
      THEN 'TRUE'                  
    ELSE 'FALSE'            
   END AS 'WARN',            
   CASE WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVMAXNUM)                
     THEN 'TRUE'                 
    ELSE 'FALSE'             
   END AS 'OVERFLOW',                       
   CUST_PERM_ADD1,                      
   CUST_PERM_ADD2,                
   WO_CUST_NAME ,            
   WO_VEH_REG_NO                
  FROM  @INVOICETEMP             
     WHERE  FLG_BATCH_INV = 'TRUE'            
  END        
    ELSE        
      BEGIN        
     INSERT INTO @INVOICETEMP1             
  (            
    ID_DEBITOR,            
    ID_INV_NO,             
    ID_WO_NO ,            
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
    CUST_PERM_ADD1  ,                      
    CUST_PERM_ADD2 ,                
    WO_CUST_NAME,            
    WO_VEH_REG_NO                 
  )                       
  SELECT DISTINCT                
   ID_DEBITOR,            
   INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+               
   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),                
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
   DT_CREATED ,            
   INVPREFIX,            
   INVSERIES,            
   INVMAXNUM,              
   INVWARNLEV,               
   CASE                 
    WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVWARNLEV)                
      THEN 'TRUE'                  
    ELSE 'FALSE'            
   END AS 'WARN',            
   CASE WHEN CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT) >= (INVMAXNUM)                
     THEN 'TRUE'                 
    ELSE 'FALSE'             
   END AS 'OVERFLOW',                       
   CUST_PERM_ADD1,                      
   CUST_PERM_ADD2,                
   WO_CUST_NAME ,            
   WO_VEH_REG_NO                
  FROM  @INVOICETEMP             
  WHERE  FLG_BATCH_INV = 'TRUE'         
      END        
                 
  --CODING TO INSERT INTO THE TEMP TABLE AND THEN INSERT INTO THE TBL INVOICE HEADER                 
        
--TO BE REMOVED        
--SELECT '@INVOICETEMPT1',* FROM @INVOICETEMP1        
--REMOVED END        
              
          
     --TEMP TABLE 2 FOR TESTING PURPOSE             
  DECLARE @INVOICETEMP2 TABLE             
  (                  
     ID_WO_NO           VARCHAR(10),              
     ID_WO_PREFIX       VARCHAR(3),                     
     ID_INV_NO         VARCHAR(10),            
     ID_DEPT_INV        INT,            
     ID_SUBSIDERY_INV   INT,                     
     DT_INVOICE         DATETIME,            
     DEBITOR_TYPE       CHAR(1),            
     ID_DEBITOR         VARCHAR(10),            
     INV_AMT DECIMAL,            
     INV_KID VARCHAR(25),            
     ID_CN_NO           VARCHAR(15),            
     FLG_BATCH_INV      BIT,            
     FLG_TRANS_TO_ACC   BIT,            
     CREATED_BY         VARCHAR(20),            
     DT_CREATED         DATETIME,            
     INVPREFIX          VARCHAR(10),                     
     INVSERIES VARCHAR(7),              
     INVMAXNUM   INT,            
   INVWARNLEV   INT,            
     WARN    BIT,            
     OVERFLOW   BIT,              
     WO_VEH_REG_NO      VARCHAR(15),            
     WO_JOB_TXT         TEXT,                       
     CUST_PERM_ADD1 VARCHAR(50),                      
     CUST_PERM_ADD2 VARCHAR(50),                       
     WO_CUST_NAME       VARCHAR(100)                
  )              
  --INSERT INTO THE TEMP TABLE WITH INVOICE NO         
  IF @CN_NUMBER > @INV_NUMBER        
  BEGIN             
  INSERT INTO @INVOICETEMP2            
  (                 
   ID_DEBITOR,             
  -- ID_WO_NO ,            
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
   CUST_PERM_ADD1,                      
   CUST_PERM_ADD2,                
   WO_CUST_NAME                
  )            
  SELECT DISTINCT                
   ID_DEBITOR,            
  -- ID_WO_NO ,            
   ID_WO_PREFIX,             
   ID_DEPT_INV,            
   ID_SUBSIDERY_INV,            
   convert(varchar(10),getdate(),101),            
   'C',--DEBITOR_TYPE,            
   ISNULL(INV_AMT,0),            
   INV_KID,            
   ID_CN_NO,            
   FLG_BATCH_INV,            
   FLG_TRANS_TO_ACC,            
   CREATED_BY,              
   DT_CREATED ,            
   INVPREFIX,            
   INVSERIES,            
   INVMAXNUM,              
   INVWARNLEV,               
   WARN,            
   OVERFLOW,                       
   CUST_PERM_ADD1,                      
   CUST_PERM_ADD2,                
   WO_CUST_NAME            
  FROM @INVOICETEMP            
    WHERE FLG_BATCH_INV = 'TRUE'           
         
             
  INSERT INTO @TBL_INV_HEADER            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   CUST_NAME--,                
  -- INV_CUST_GROUP              
 ,INV_FEES_AMT          
  )            
  SELECT DISTINCT                 
   temp.ID_DEBITOR,            
   INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+             
   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC ) AS VARCHAR) AS  VARCHAR),                
   ID_DEPT_INV,            
   ID_SUBSIDERY_INV,            
   DT_INVOICE,            
   DEBITOR_TYPE,            
   ISNULL(INV_AMT,0),              
   DBO.FNGETKID( ID_DEBITOR,            
        CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)            
        + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),            
        '0',            
       ID_DEPT_INV,            
          ID_SUBSIDERY_INV            
         ),            
   temp.ID_CN_NO,temp.FLG_BATCH_INV,            
   temp.FLG_TRANS_TO_ACC,            
   temp.CREATED_BY,            
   temp.DT_CREATED,                       
   temp.CUST_PERM_ADD1  ,                      
   temp.CUST_PERM_ADD2 ,                      
   temp.WO_CUST_NAME--,                
  -- mas.ID_CUST_GROUP         
  ,NULL --INV_FEES_AMT                    
  FROM @INVOICETEMP2 temp             
--     LEFT OUTER JOIN            
--    TBL_MAS_CUSTOMER mas                
--     ON             
--    mas.id_customer = temp.ID_DEBITOR                  
  WHERE temp.FLG_BATCH_INV = 'TRUE'            
      -- AND debitor_type='C'        
        
        
  END        
          
  ELSE        
  BEGIN        
    INSERT INTO @INVOICETEMP2            
  (                 
   ID_DEBITOR,             
  -- ID_WO_NO ,            
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
   CUST_PERM_ADD1,                      
   CUST_PERM_ADD2,                
   WO_CUST_NAME                
  )            
  SELECT DISTINCT                
   ID_DEBITOR,            
  -- ID_WO_NO ,            
   ID_WO_PREFIX,             
   ID_DEPT_INV,            
   ID_SUBSIDERY_INV,            
   convert(varchar(10),getdate(),101),            
   'C',--DEBITOR_TYPE,            
   ISNULL(INV_AMT,0),            
   INV_KID,            
   ID_CN_NO,            
   FLG_BATCH_INV,            
   FLG_TRANS_TO_ACC,            
   CREATED_BY,              
   DT_CREATED ,            
   INVPREFIX,            
   INVSERIES,            
   INVMAXNUM,              
   INVWARNLEV,               
   WARN,            
   OVERFLOW,                       
   CUST_PERM_ADD1,                      
   CUST_PERM_ADD2,                
   WO_CUST_NAME            
  FROM @INVOICETEMP            
    WHERE FLG_BATCH_INV = 'TRUE'           
        
             
  INSERT INTO @TBL_INV_HEADER            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   CUST_NAME--,                
  -- INV_CUST_GROUP          
  ,INV_FEES_AMT                     
  )            
  SELECT DISTINCT                 
   temp.ID_DEBITOR,            
   INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+             
   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC ) AS VARCHAR) AS  VARCHAR),                
   ID_DEPT_INV,            
   ID_SUBSIDERY_INV,            
   DT_INVOICE,            
   DEBITOR_TYPE,            
   ISNULL(INV_AMT,0),              
   DBO.FNGETKID( ID_DEBITOR,            
        CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)            
        + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),            
        '0',            
       ID_DEPT_INV,            
          ID_SUBSIDERY_INV            
         ),            
   temp.ID_CN_NO,temp.FLG_BATCH_INV,            
   temp.FLG_TRANS_TO_ACC,            
   temp.CREATED_BY,            
   temp.DT_CREATED,                       
   temp.CUST_PERM_ADD1  ,                      
   temp.CUST_PERM_ADD2 ,                      
   temp.WO_CUST_NAME--,                
  -- mas.ID_CUST_GROUP          
  ,NULL  --INV_FEES_AMT         
  FROM @INVOICETEMP2 temp           
--     LEFT OUTER JOIN            
--    TBL_MAS_CUSTOMER mas       
--     ON             
--    mas.id_customer = temp.ID_DEBITOR                  
  WHERE temp.FLG_BATCH_INV = 'TRUE'            
      -- AND debitor_type='C'        
        
          
  IF @@ERROR <> 0            
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME            
   RETURN            
  END         
  END               
           
   IF @@ERROR <> 0            
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME            
   RETURN            
  END         
          
        
              
  -- CODING FOR NON BATCH INVOICE            
                 
  DECLARE @INVOICENONBATCHINVOICE TABLE            
  (            
   ID_WO_NO VARCHAR(10),            
   ID_WO_PREFIX        VARCHAR(3),            
   ID_WODET_SEQ        INT,            
   ID_INV_NO           VARCHAR(10),            
   ID_DEPT_INV         INT,            
   ID_SUBSIDERY_INV    INT,            
   DT_INVOICE          DATETIME,            
   DEBITOR_TYPE        CHAR(1),              
   ID_DEBITOR          VARCHAR(10),            
   INV_AMT DECIMAL,            
   INV_KID VARCHAR(25),            
   ID_CN_NO VARCHAR(15),            
   FLG_BATCH_INV       BIT,            
   FLG_TRANS_TO_ACC    BIT,            
   CREATED_BY          VARCHAR(20),            
   DT_CREATED          DATETIME,            
   INVPREFIX    VARCHAR(10),            
   INVSERIES           VARCHAR(7),            
   INVMAXNUM   INT,            
   INVWARNLEV    INT,                  
   WARN    BIT,            
   OVERFLOW  BIT,                       
   CUST_PERM_ADD1 VARCHAR(50),                      
   CUST_PERM_ADD2 VARCHAR(50),                 
   WO_CUST_NAME VARCHAR(100),            
   WO_VEH_REG_NO VARCHAR(50)                   
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,          
   WO_CUST_NAME,            
   WO_VEH_REG_NO                      
  )            
  SELECT DISTINCT                 
   ID_WO_NO,            
   ID_WO_PREFIX,            
   ID_DEPT_INV ,               
   ID_WODET_SEQ,            
   INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)+             
   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),                 
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
    WHEN  CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) AS INT) +  CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT)  >= (INVWARNLEV)                 
    THEN 'true'            
    ELSE 'false'            
   END AS 'WARN',            
   CASE                 
    WHEN  CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES) AS INT) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT)  >= (INVMAXNUM)                
    THEN 'TRUE'               
   END AS 'OVERFLOW',            
   CUST_PERM_ADD1 ,                     
   CUST_PERM_ADD2 ,                     
   WO_CUST_NAME,            
   WO_VEH_REG_NO                       
   FROM @INVOICETEMP             
     WHERE FLG_BATCH_INV = 'FALSE' AND INVSEQ = 1         
     UNION ALL        
     SELECT DISTINCT                 
   ID_WO_NO,            
   ID_WO_PREFIX,            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                     
   WO_CUST_NAME,            
   WO_VEH_REG_NO                       
   FROM @INVOICETEMP             
     WHERE FLG_BATCH_INV = 'FALSE' AND INVSEQ > 1                 
            
            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   WO_CUST_NAME,            
   WO_VEH_REG_NO                      
  )          
         
  SELECT DISTINCT                 
   ID_WO_NO,            
   ID_WO_PREFIX,            
   ID_DEPT_INV ,               
   ID_WODET_SEQ,            
   INVPREFIX +CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)+             
   CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),                 
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
    WHEN  CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) +  CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT)  >= (INVWARNLEV)                 
    THEN 'true'            
    ELSE 'false'            
   END AS 'WARN',            
   CASE                 
    WHEN  CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES) AS INT) + CAST(ROW_NUMBER() OVER(PARTITION BY INVPREFIX ORDER BY INVPREFIX DESC) AS INT)  >= (INVMAXNUM)                
    THEN 'TRUE'               
   END AS 'OVERFLOW',            
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                     
   WO_CUST_NAME,            
   WO_VEH_REG_NO                       
   FROM @INVOICETEMP             
     WHERE FLG_BATCH_INV = 'FALSE' AND INVSEQ = 1         
     UNION ALL        
     SELECT DISTINCT                 
   ID_WO_NO,            
   ID_WO_PREFIX,            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                     
   WO_CUST_NAME,            
   WO_VEH_REG_NO                       
   FROM @INVOICETEMP             
     WHERE FLG_BATCH_INV = 'FALSE' AND INVSEQ > 1            
                  
   --SELECT '@INVOICETEMP', * from @INVOICETEMP        
   --SELECT '@INVOICENONBATCHINVOICE', * from @INVOICENONBATCHINVOICE        
          
 UPDATE T2        
 SET T2.ID_INV_NO = T1.ID_INV_NO , T2.WARN = T1.WARN, T2.OVERFLOW = T1.OVERFLOW        
 FROM @INVOICENONBATCHINVOICE T2        
  INNER JOIN @INVOICENONBATCHINVOICE T1 on T2.ID_WO_NO = T1.ID_WO_NO AND T2.ID_WO_PREFIX = T1.ID_WO_PREFIX        
  AND T2.ID_DEBITOR = T1.ID_DEBITOR        
 WHERE T1.ID_INV_NO IS NOT NULL        
          
     --SELECT '@INVOICENONBATCHINVOICE', * from @INVOICENONBATCHINVOICE         
         
          
  IF @@ERROR <> 0                
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME              
   RETURN            
  END                 
 END        
          
  IF @@ERROR <> 0                
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME              
   RETURN            
  END                 
                
    /* One more temp table which contains the detail about non batch invoice*/                      
  DECLARE @INVOICETEMP3 TABLE             
  (              
   ID_WO_NO           VARCHAR(10),              
   ID_WO_PREFIX       VARCHAR(3),              
   ID_INV_NO          VARCHAR(10),            
   ID_DEPT_INV        INT,            
   ID_SUBSIDERY_INV   INT,            
   DT_INVOICE        DATETIME,            
   DEBITOR_TYPE       CHAR(1),            
   ID_DEBITOR         VARCHAR(10),            
   INV_AMT DECIMAL,            
   INV_KID        VARCHAR(25),                   
   ID_CN_NO           VARCHAR(15),            
   FLG_BATCH_INV      BIT,            
   FLG_TRANS_TO_ACC   BIT,            
   CREATED_BY         VARCHAR(20),            
   DT_CREATED         DATETIME,            
   INVPREFIX VARCHAR(10),            
   INVSERIES          VARCHAR(7),              
   INVMAXNUM   INT,            
   INVWARNLEV   INT,            
   WARN    BIT,            
   OVERFLOW   BIT,            
   WO_VEH_REG_NO      VARCHAR(15),            
   WO_JOB_TXT         TEXT,                       
   CUST_PERM_ADD1 VARCHAR(50),                      
   CUST_PERM_ADD2 VARCHAR(50),                
   WO_CUST_NAME   VARCHAR(100)                
  )                    
  --Insert into the Temp table for non batch invoice         
  IF @CN_NUMBER > @INV_NUMBER        
  BEGIN                
  INSERT INTO @INVOICETEMP3            
  (            
   --ID_WO_NO,            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   WO_CUST_NAME            
  )            
  SELECT DISTINCT                 
   --ID_WO_NO,            
   ID_WO_PREFIX,           
   ID_DEPT_INV ,            
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
   WARN,            
   OVERFLOW,                 
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                 
   WO_CUST_NAME                       
  FROM @INVOICETEMP             
    WHERE FLG_BATCH_INV = 'FALSE'               
        
          
  -- INSERT INTO THE TBL_INV_HEADER FOR NON BATCH INVOICE                
  INSERT INTO @TBL_INV_HEADER             
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   CUST_NAME,                
   INV_CUST_GROUP           
   ,INV_FEES_AMT               
  )            
  SELECT DISTINCT            
   temp.ID_DEBITOR,                  
    temp.INVPREFIX +CAST(DBO.ROWMAXIMUM_CREDIT(temp.INVPREFIX,temp.INVSERIES)+             
    CAST(ROW_NUMBER() OVER(PARTITION BY temp.INVPREFIX ORDER BY temp.INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),              
   temp.ID_DEPT_INV,temp.ID_SUBSIDERY_INV,                 
   temp.DT_INVOICE,temp.DEBITOR_TYPE,temp.INV_AMT,            
   DBO.FNGETKID(            
   ID_DEBITOR,            
   CAST(DBO.ROWMAXIMUM_CREDIT(INVPREFIX,INVSERIES)             
   + CAST(ROW_NUMBER() OVER(PARTITION BY temp.INVPREFIX ORDER BY temp.INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),            
   temp.ID_WO_NO,            
   temp.ID_DEPT_INV,            
   temp.ID_SUBSIDERY_INV            
   ),            
   temp.ID_CN_NO,temp.FLG_BATCH_INV,temp.FLG_TRANS_TO_ACC,temp.CREATED_BY,temp.DT_CREATED,            
   temp.CUST_PERM_ADD1 ,                      
   temp.CUST_PERM_ADD2 ,                
   temp.WO_CUST_NAME,                
   mas.ID_CUST_GROUP,        
   NULL --INV_FEES_AMT                 
  FROM @INVOICETEMP3 temp             
    LEFT OUTER JOIN            
    TBL_MAS_CUSTOMER mas                
   ON             
    mas.id_customer = temp.ID_DEBITOR                 
  WHERE FLG_BATCH_INV = 'FALSE'            
 END        
 ELSE        
 BEGIN        
   INSERT INTO @INVOICETEMP3            
  (            
   --ID_WO_NO,            
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   WO_CUST_NAME            
  )            
  SELECT DISTINCT                 
   --ID_WO_NO,            
   ID_WO_PREFIX,           
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
   CREATED_BY,            
   DT_CREATED,                    
   INVPREFIX,            
   INVSERIES,            
   INVMAXNUM,              
   INVWARNLEV,            
   WARN,            
   OVERFLOW,                 
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                 
   WO_CUST_NAME                       
  FROM @INVOICETEMP             
    WHERE FLG_BATCH_INV = 'FALSE'            
              
          
--to be removed          
--select '@INVOICETEMP' as Header,* from @INVOICETEMP  WHERE FLG_BATCH_INV = 'FALSE'         
--select '@INVOICETEMP3' as Header,* from @INVOICETEMP3          
--removed end          
          
  -- INSERT INTO THE TBL_INV_HEADER FOR NON BATCH INVOICE                
  INSERT INTO @TBL_INV_HEADER             
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
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   CUST_NAME,                
   INV_CUST_GROUP ,        
   INV_FEES_AMT                    
  )            
  SELECT DISTINCT            
   temp.ID_DEBITOR,                  
    temp.INVPREFIX +CAST(DBO.ROWMAXIMUM(temp.INVPREFIX,temp.INVSERIES)+             
    CAST(ROW_NUMBER() OVER(PARTITION BY temp.INVPREFIX ORDER BY temp.INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),              
   temp.ID_DEPT_INV,temp.ID_SUBSIDERY_INV,                 
   temp.DT_INVOICE,temp.DEBITOR_TYPE,temp.INV_AMT,            
   DBO.FNGETKID(            
   ID_DEBITOR,            
   CAST(DBO.ROWMAXIMUM(INVPREFIX,INVSERIES)             
   + CAST(ROW_NUMBER() OVER(PARTITION BY temp.INVPREFIX ORDER BY temp.INVPREFIX DESC) AS VARCHAR) AS  VARCHAR),            
   temp.ID_WO_NO,            
   temp.ID_DEPT_INV,            
   temp.ID_SUBSIDERY_INV            
   ),            
   temp.ID_CN_NO,temp.FLG_BATCH_INV,temp.FLG_TRANS_TO_ACC,temp.CREATED_BY,temp.DT_CREATED,            
   temp.CUST_PERM_ADD1 ,                      
   temp.CUST_PERM_ADD2 ,                
   temp.WO_CUST_NAME,                
   mas.ID_CUST_GROUP,        
   NULL --INV_FEES_AMT        
  FROM @INVOICETEMP3 temp             
    LEFT OUTER JOIN            
    TBL_MAS_CUSTOMER mas               ON             
    mas.id_customer = temp.ID_DEBITOR                 
  WHERE FLG_BATCH_INV = 'FALSE'            
            
  --ROW 224          
  IF EXISTS (select *  FROM TBL_MAS_INV_FEES_SETTINGS INVF,@TBL_INV_HEADER         
   WHERE [@TBL_INV_HEADER].ID_DEPT_INV = INVF.ID_DEPT AND [@TBL_INV_HEADER].ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY  )        
  BEGIN        
   UPDATE @TBL_INV_HEADER        
   SET INV_FEES_AMT=INVF.INV_FEES_AMT,FLG_INV_FEES =INVF.FLG_INV_FEES        
   FROM TBL_MAS_INV_FEES_SETTINGS INVF,@TBL_INV_HEADER         
   WHERE [@TBL_INV_HEADER].ID_DEPT_INV = INVF.ID_DEPT AND [@TBL_INV_HEADER].ID_SUBSIDERY_INV = INVF.ID_SUBSIDIARY        
  END        
        
        
               
  IF @@ERROR <> 0                     
  BEGIN             
   ROLLBACK TRANSACTION @TRANNAME               
   RETURN            
  END           
 END        
        
               
  IF @@ERROR <> 0                     
  BEGIN             
   ROLLBACK TRANSACTION @TRANNAME               
   RETURN            
  END             
  ---INSERT INTO THE TEMPTABLE1 WITH NONBATCH INVOICE                 
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
   DT_CREATED  ,                
   ID_WODET_SEQ,                       
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   WO_CUST_NAME,            
   WO_VEH_REG_NO                       
  )            
  SELECT DISTINCT                ID_DEBITOR,            
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
   DT_CREATED ,                    
   ID_WODET_SEQ,                       
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   WO_CUST_NAME,WO_VEH_REG_NO                      
  FROM @INVOICENONBATCHINVOICE             
    WHERE FLG_BATCH_INV = 'FALSE'           
            
            
             
          
--TO BE REMOVED          
--SELECT '@INVOICETEMP1' AS hEADER,* FROM @INVOICETEMP1          
--REMOVED END          
          
  --CODING TO INSERT INTO THE  TBL_INV_DETAIL               
  DECLARE @IDJOB AS INT                  
  SET @IDJOB = 0                  
  SELECT  @IDJOB = CASE                 
       WHEN ID_WODET_SEQ IS NOT NULL            
        THEN                  
         (SELECT ID_JOB FROM TBL_WO_DETAIL WHERE  ID_WODET_SEQ = B.ID_WODET_SEQ)                  
       ELSE 0                   
       END                  
  FROM @TBL_INV_HEADER A             
    LEFT OUTER JOIN            
    @INVOICETEMP1 B            
    ON             
    A.ID_DEBITOR = B.ID_DEBITOR              
  WHERE A.ID_INV_NO IN            
       (SELECT ID_INV_NO FROM @INVOICETEMP1)             
            
            
             
  INSERT INTO   @TBL_INV_DETAIL             
  (                
   ID_INV_NO,               
   ID_WODET_INV,               
   VEH_REG_NO,                 
   WO_JOB_TXT,               
   CREATED_BY,               
   DT_CREATED,                
   ID_WO_NO,                
   ID_WO_PREFIX,                
   ID_JOB,                
   INVD_GM_ACCCODE,                
   INVD_GM_VAT,                
   INVD_VAT_ACCOUNTCODE,                
   INVD_VAT_PERCENTAGE,                
   [WO_VEH_MILEAGE]--,          
 --Bug ID:- Inovice Basis         
 --Date  :-04-Feb-209        
 --desc  :- @Tbl_Inv_Details inserting 2 records because of VehHours                
  --[WO_VEH_HRS]               
 --change end        
  )                  
  SELECT  DISTINCT                    
   A.ID_INV_NO,                
   ID_WODET_SEQ,                
   WO_VEH_REG_NO,            
   --WO_JOB_TXT,            
   '',            
   'admin',            
   GETDATE (),                
   B.ID_WO_no,                
   B.ID_WO_PREFIX,                   
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN                 
     (SELECT ID_JOB FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)       
    ELSE 0                  
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN   --for Garage Material Account Code              
     (SELECT isnull(WO_GM_ACCCODE,'') FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)             
    ELSE ''                 
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN   --for Garage Material VAT Code              
     (SELECT isnull(WO_GM_VAT,'') FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)                 
    ELSE ''                  
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ is not null THEN   --for Garage Material VAT Account Code              
     (SELECT isnull(WO_VAT_ACCCODE,'') FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)             
    ELSE ''                  
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN   --for Garage Material VAT Percentage              
     (SELECT isnull(WO_VAT_PERCENTAGE,0) FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)             
    ELSE 0                  
   END,             
 --Bug ID:- Inovice Basis         
 --Date  :-04-Feb-209        
 --desc  :- @Tbl_Inv_Details inserting 2 records because of VehHours             
 case when ID_WODET_SEQ is not null then --for Inserting Milage Value                   
  (SELECT WO_VEH_MILEAGE FROM TBL_WO_HEADER where ID_WO_NO = b.ID_WO_NO AND ID_WO_PREFIX = b.ID_WO_PREFIX)                   
 else 0                   
 end        
    -- vehmas.VEH_MILEAGE,                
    -- vehmas.VEH_HRS                  
 --change end        
  FROM @TBL_INV_HEADER A             
    LEFT OUTER JOIN            
    @INVOICETEMP1 B             
    ON             
    A.ID_DEBITOR = B.ID_DEBITOR                 
   LEFT OUTER JOIN             
    TBL_MAS_VEHICLE vehmas             
   ON              
    vehmas.VEH_REG_NO =  WO_VEH_REG_NO                
  WHERE A.ID_INV_NO IN            
       (SELECT ID_INV_NO FROM @INVOICETEMP1)           
AND B.FLG_BATCH_INV='TRUE'          
        
        
          
--CODE ADDED FOR NON BATCH INVOICE          
INSERT INTO   @TBL_INV_DETAIL             
  (                
   ID_INV_NO,               
   ID_WODET_INV,               
   VEH_REG_NO,                 
   WO_JOB_TXT,               
   CREATED_BY,               
   DT_CREATED,                
   ID_WO_NO,                
   ID_WO_PREFIX,                
   ID_JOB,                
   INVD_GM_ACCCODE,                
   INVD_GM_VAT,                
   INVD_VAT_ACCOUNTCODE,                
   INVD_VAT_PERCENTAGE,                
   [WO_VEH_MILEAGE]--,          
 --Bug ID:- Inovice Basis         
 --Date  :-04-Feb-209        
 --desc  :- @Tbl_Inv_Details inserting 2 records because of VehHours                
  --[WO_VEH_HRS]               
 --change end        
  )                  
  SELECT  DISTINCT                     
   A.ID_INV_NO,                
   ID_WODET_SEQ,                
   WO_VEH_REG_NO,            
   --WO_JOB_TXT,            
   '',            
   'admin',            
   GETDATE (),                
   B.ID_WO_no,                
   B.ID_WO_PREFIX,                   
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN                 
     (SELECT TOP 1 ID_JOB FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)                
    ELSE 0                  
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN   --for Garage Material Account Code              
     (SELECT TOP 1 isnull(WO_GM_ACCCODE,'') FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)             
    ELSE ''                 
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN   --for Garage Material VAT Code              
     (SELECT TOP 1  isnull(WO_GM_VAT,'') FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)                 
    ELSE ''                  
 END  ,                
   CASE                 
    WHEN ID_WODET_SEQ is not null THEN   --for Garage Material VAT Account Code              
     (SELECT TOP 1 isnull(WO_VAT_ACCCODE,'') FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)             
    ELSE ''                  
   END  ,                
   CASE                 
    WHEN ID_WODET_SEQ IS NOT NULL THEN   --for Garage Material VAT Percentage              
     (SELECT TOP 1 isnull(WO_VAT_PERCENTAGE,0) FROM TBL_WO_DETAIL where  ID_WODET_SEQ = b.ID_WODET_SEQ)             
    ELSE 0                  
   END,           
 --Bug ID:- Inovice Basis         
 --Date  :-04-Feb-209        
 --desc  :- @Tbl_Inv_Details inserting 2 records because of VehHours          
  case when ID_WODET_SEQ is not null then --for Inserting Milage Value                   
  (SELECT TOP 1 WO_VEH_MILEAGE FROM TBL_WO_HEADER where ID_WO_NO = b.ID_WO_NO AND ID_WO_PREFIX = b.ID_WO_PREFIX)                 
 else 0                   
 end             
     --vehmas.VEH_MILEAGE,                
     --vehmas.VEH_HRS                  
 --change end        
  FROM @TBL_INV_HEADER A--@INVOICETEMP1 B              
    LEFT OUTER JOIN            
    @INVOICETEMP1 B             
    ON             
    A.ID_DEBITOR = B.ID_DEBITOR                 
  LEFT OUTER JOIN             
    TBL_MAS_VEHICLE vehmas             
   ON              
    vehmas.VEH_REG_NO =  WO_VEH_REG_NO                
WHERE A.ID_INV_NO IN            
       (SELECT ID_INV_NO FROM @INVOICETEMP1)           
AND B.FLG_BATCH_INV='FALSE'             
--CODE END FOR ADDING NON BATCH INVOICE            
            
  update @TBL_INV_DETAIL             
  set WO_JOB_TXT = B.WO_JOB_TXT            
  from @INVOICETEMP1 B            
  where ID_DEBITOR = B.ID_DEBITOR            
          
--TO BE REMOVED          
--SELECT '@TBL_INV_DETAIL' AS hEADER,* FROM @TBL_INV_DETAIL          
--REMOVED END          
                 
  IF @@ERROR <> 0            
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME              
   RETURN                 
  END             
            
  --CODING TO INSERT IN TO TBL_INV_DETAIL_LINES            
  --FIRST INSERT INTO THE TBL_INV_DETAIL_LINES BASED UPON THE ITEM            
  --CREATE ONE TEMP TABLE SIMILAR TO TBL_INV_HEADER            
             
  -- ADD IT FROM THE TEMP TABLE              
  DECLARE @TEMP_TBL_INV_HEADER TABLE              
  (                    
   ID_INV_NO VARCHAR(10),              
   ID_DEPT_INV          INT,               
   ID_SUBSIDERY_INV     INT,              
   DT_INVOICE      DATETIME,              
   DEBITOR_TYPE         CHAR(1),              
   ID_DEBITOR           VARCHAR(10),              
   INV_AMT  DECIMAL,              
   INV_KID  VARCHAR(25),            
   ID_CN_NO VARCHAR(15),              
   FLG_BATCH_INV        BIT,              
   FLG_TRANS_TO_ACC     BIT,              
   CREATED_BY           VARCHAR(20),               
   DT_CREATED           DATETIME,              
   MODIFIED_BY          VARCHAR(20),              
   DT_MODIFIED          DATETIME,             
   ID_WODET_SEQ         INT,                       
   CUST_PERM_ADD1 VARCHAR(50),                      
   CUST_PERM_ADD2 VARCHAR(50),                
   WO_CUST_NAME    VARCHAR(100)                
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
   ID_WODET_SEQ,            
   CUST_PERM_ADD1 ,                      
   CUST_PERM_ADD2 ,                
   WO_CUST_NAME                       
  )            
  SELECT DISTINCT                 
   B.ID_DEBITOR,                
   A.ID_INV_NO,             
   B.ID_DEPT_INV,                
   B.ID_SUBSIDERY_INV,               
   B.DT_INVOICE,                
   B.DEBITOR_TYPE,                
   B.INV_AMT,                
   B.INV_KID,            
   B.ID_CN_NO,                
   B.FLG_BATCH_INV,                
   B.FLG_TRANS_TO_ACC,                
   B.CREATED_BY,                
   B.DT_CREATED,                
   B.ID_WODET_SEQ,                      
   A.CUST_PERM_ADD1 ,                      
   A.CUST_PERM_ADD2,                
   A.CUST_NAME                 
  FROM @TBL_INV_HEADER A             
    LEFT OUTER JOIN              
    @INVOICETEMP1  B             
   ON A.ID_DEBITOR = B.ID_DEBITOR                
  WHERE B.FLG_BATCH_INV = 'TRUE'                  
     AND A.ID_INV_NO IN            
        (SELECT ID_INV_NO FROM @INVOICETEMP1)             
                
  IF @@ERROR <> 0            
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME              
   RETURN                  
  END                
                
  --CODING FOR NON BATCH INVOICE                 
--    SELECT * FROM @TBL_INV_HEADER           
--SELECT * FROM @INVOICETEMP1           
--          
--SELECT B.ID_DEBITOR,                
--   A.ID_INV_NO,             
--   B.ID_DEPT_INV,                
--   B.ID_SUBSIDERY_INV,            
--   B.DT_INVOICE           
--FROM @TBL_INV_HEADER A             
--    LEFT OUTER JOIN            
--    @INVOICETEMP1  B             
--   ON             
--    A.ID_DEBITOR = B.ID_DEBITOR            
--  WHERE B.FLG_BATCH_INV = 'FALSE'             
--     AND A.ID_INV_NO = b. ID_INV_NO          
          
          
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
   ID_WODET_SEQ,                      
   CUST_PERM_ADD1 ,                    
   CUST_PERM_ADD2 ,                 
   WO_CUST_NAME                       
  )               
  SELECT            
   B.ID_DEBITOR,                
   A.ID_INV_NO,             
   B.ID_DEPT_INV,                
   B.ID_SUBSIDERY_INV,            
   B.DT_INVOICE,                
   B.DEBITOR_TYPE,                
   B.INV_AMT,                
   B.INV_KID,             
   B.ID_CN_NO,                
 B.FLG_BATCH_INV,                
   B.FLG_TRANS_TO_ACC,                
   B.CREATED_BY,                
   B.DT_CREATED,                
   B.ID_WODET_SEQ,                      
   A.CUST_PERM_ADD1 ,                      
   A.CUST_PERM_ADD2 ,                
   A.CUST_NAME               
  FROM @TBL_INV_HEADER A             
    LEFT OUTER JOIN            
    @INVOICETEMP1  B             
   ON             
    A.ID_DEBITOR = B.ID_DEBITOR            
  WHERE B.FLG_BATCH_INV = 'FALSE'             
     AND A.ID_INV_NO = B. ID_INV_NO          
        --(SELECT ID_INV_NO FROM @INVOICETEMP1)               
            
                 
  IF @@ERROR <> 0               
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME               
   RETURN            
  END                
          
            
  INSERT INTO @TBL_INV_DETAIL_LINES            
  (            
   ID_INV_NO,               
   ID_WODET_INVL,               
   FLG_ITEM,            
   ID_WOITEM_SEQ,            
   ID_WH_INVL,               
   ID_ITEM_INVL,                
   INVL_DESCRIPTION,              
   INVL_AVERAGECOST,              
   INVL_DELIVER_QTY,                 
   INVL_PRICE,                 
   INVL_DIS,               
   INVL_DEB_CONTRIB,                 
   CREATED_BY,               
   DT_CREATED   ,                  
   INVL_LINETYPE,                    
   INVL_VAT_ACCCODE,                
   INVL_VAT_CODE,                
   INVL_VAT_PER,                
   INVL_SPARES_ACCOUNTCODE,                
   INVL_BFAMOUNT,                
   INVL_AMOUNT,                
   INVL_VAT,                
   ID_MAKE,                
   ID_WAREHOUSE            
  )              
  SELECT DISTINCT              
   TEMPA.ID_INV_NO,                
   TEMPA.ID_WODET_SEQ,                
   'TRUE',              
   JODBETAIL.ID_WOITEM_SEQ,                
   NULL,                
   JODBETAIL.ID_ITEM_JOB,                 
   CASE                     
    WHEN JODBETAIL.ID_ITEM_JOB IS NOT NULL THEN                    
     (SELECT ITEM_DESC FROM TBL_MAS_ITEM_MASTER         
   WHERE ID_ITEM = JODBETAIL.ID_ITEM_JOB AND ID_WH_ITEM= JODBETAIL.ID_WAREHOUSE         
   AND SUPP_CURRENTNO = JODBETAIL.ID_MAKE_JOB)                    
    ELSE ''                    
   END ,             
   CASE                     
    WHEN JODBETAIL.ID_ITEM_JOB IS NOT NULL THEN                    
     (SELECT ISNULL(COST_PRICE1,0) FROM TBL_MAS_ITEM_MASTER         
  WHERE ID_ITEM = JODBETAIL.ID_ITEM_JOB AND ID_WH_ITEM= JODBETAIL.ID_WAREHOUSE         
  AND SUPP_CURRENTNO = JODBETAIL.ID_MAKE_JOB)                    
    ELSE 0                  
   END,                
   JODBETAIL.JOBI_DELIVER_QTY,                
   JODBETAIL.JOBI_SELL_PRICE,                 
   --DEBITORDETAIL.WO_SPR_DISCPER,            
   JODBETAIL.JOBI_DIS_PER,                
   DEBITORDETAIL.DBT_PER,             
   'admin',            
   GETDATE() ,                
   'Spares',                
   JOB_VAT_ACCCODE,                
   JOB_VAT,JOBI_VAT_PER,                
  JOB_SPARES_ACCOUNTCODE,                
   CASE                 
    WHEN (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 AND JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY >0)                
 THEN  JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY                 
    ELSE 0                
   END,                
   CASE WHEN (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 and JODBETAIL.JOBI_DIS_PER is not null and JODBETAIL.JOBI_DIS_PER > 0  AND  JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY >0)                
     THEN    (            
         (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01) -                  
         ((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01) *(0.01 * JODBETAIL.JOBI_DIS_PER) )            
       )               
       +              
       ( (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01) -                  
         ((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01) *(0.01 * JODBETAIL.JOBI_DIS_PER) )            
       )    * (0.01 * JOBI_VAT_PER)                       
    WHEN (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 AND ISNULL(JODBETAIL.JOBI_DIS_PER,0) = 0 AND JODBETAIL.JOBI_DELIVER_QTY IS NOT NULL AND JODBETAIL.JOBI_DELIVER_QTY >0)                
     THEN   (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01)               
       + ((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01)* (0.01 * JOBI_VAT_PER) )                 
    ELSE 0                
   END    ,                
   CASE                 
    WHEN   (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 and JODBETAIL.JOBI_DIS_PER is not null and JODBETAIL.JOBI_DIS_PER > 0  and                
      JOBI_VAT_PER is not null and JOBI_VAT_PER > 0 and JODBETAIL.JOBI_DELIVER_QTY is not          
 null and JODBETAIL.JOBI_DELIVER_QTY >0)                
     THEN                
      (             
       (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 ) -                
       ((JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 )                
       *(0.01 *JODBETAIL.JOBI_DIS_PER) )            
      ) * (0.01 * JOBI_VAT_PER)                
    WHEN (JODBETAIL.JOBI_SELL_PRICE is not null and JODBETAIL.JOBI_SELL_PRICE >0 AND isnull(JODBETAIL.JOBI_DIS_PER,0) = 0 and                
      JOBI_VAT_PER is not null and JOBI_VAT_PER > 0 and                
      JODBETAIL.JOBI_DELIVER_QTY is not null and JODBETAIL.JOBI_DELIVER_QTY >0)                
     THEN             
      --(JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1 * 0.01) * (0.01 * JOBI_VAT_PER)            
      (JODBETAIL.JOBI_SELL_PRICE * JODBETAIL.JOBI_DELIVER_QTY * 1) * (0.01 * JOBI_VAT_PER)            
    ELSE 0                
   END,                
   JODBETAIL.ID_MAKE_JOB,                
   JODBETAIL.ID_WAREHOUSE                       
  FROM               
  @TEMP_TBL_INV_HEADER TEMPA,            
  TBL_WO_DETAIL WODETAIL            
  LEFT JOIN TBL_WO_JOB_DETAIL JODBETAIL             
   ON WODETAIL.ID_WODET_SEQ = JODBETAIL.ID_WODET_SEQ_JOB              
  LEFT OUTER JOIN TBL_WO_DEBITOR_DETAIL DEBITORDETAIL             
   ON WODETAIL.ID_WO_NO = DEBITORDETAIL.ID_WO_NO             
    AND WODETAIL.ID_WO_PREFIX = DEBITORDETAIL.ID_WO_PREFIX             
    AND WODETAIL.ID_JOB = DEBITORDETAIL.ID_JOB_ID           
-- LEFT  JOIN @TBL_INV_DETAIL INVDET           
-- ON INVDET.ID_INV_NO=TEMPA.ID_INV_NO          
           
--  LEFT OUTER JOIN                 
--   TBL_WO_JOB_DEBITOR_DISCOUNT WOJDD            
--  ON            
--   WODETAIL.ID_WO_NO = WOJDD.ID_WO_NO            
--   AND WODETAIL.ID_WO_PREFIX = WOJDD.ID_WO_PREFIX                    
--   AND WODETAIL.ID_JOB = WOJDD.ID_JOB_ID               
--   --AND DEBITORDETAIL.ID_JOB_DEB=WOJDD.ID_DEB                      
--   AND JODBETAIL.ID_ITEM_JOB = WOJDD.ID_ITEM_JOB            
                   
  WHERE TEMPA.ID_WODET_SEQ = WODETAIL.ID_WODET_SEQ            
        
 --Bug ID:- Only Single Debitor        
 --AND JODBETAIL.ID_JOB_DEB = TEMPA.ID_DEBITOR           
   AND DEBITORDETAIL.ID_JOB_DEB = TEMPA.ID_DEBITOR          
 --change end        
         
                  
              
  IF @@ERROR <> 0            
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME                 
   RETURN            
  END                
               
--to be removed        
 --select 'invoice header',* From @TEMP_TBL_INV_HEADER              
--  select 'invoice detail',* From @TBL_INV_DETAIL_LINES        
--  select 'WODETAIL',* from TBL_WO_DETAIL where id_wo_no='6' and id_wo_prefix='ss'        
--  select 'JODBETAIL',* from TBL_WO_JOB_DETAIL where id_wo_no='6' and id_wo_prefix='ss'        
--  select 'DEBITORDETAIL',* from TBL_WO_DEBITOR_DETAIL where id_wo_no='6' and id_wo_prefix='ss'        
        
--removed end            
        
  -- INSERT INTO TBL_INV_DETAIL_LINES_LABOUR                
  INSERT INTO @TBL_INV_DETAIL_LINES_LABOUR               
  (                
   ID_INV_NO,            
   ID_WODET_INVL,            
   FLG_ITEM,              
   ID_WH_INVL,            
   INVL_IDLOGIN,              
   INVL_DESCRIPTION,            
   INVL_Mech_hour,            
   INVL_MECh_Hourly_Price,             
   INVL_STTime,            
   INVL_DEB_CONTRIB,CREATED_BY,               
   DT_CREATED,            
   INVL_LINETYPE,            
   INVL_VAT_ACCCODE,                
   INVL_VAT_CODE,            
   INVL_VAT_PER,            
   INVL_Labour_ACCOUNTCODE,                
   INVL_STHour,            
   INVL_AMOUNT,            
   INVL_VAT,            
   INVL_DIS               
  )                
  SELECT             
   TEMPA.ID_INV_NO,            
   TEMPA.ID_WODET_SEQ,            
   'FALSE',                  
   NULL,           
            
   ID_LOGIN,              
   CASE                 
    WHEN ID_LOGIN IS NOT NULL                
     THEN ( SELECT ISNULL(FIRST_NAME,' ')+ SPACE(1) + ISNULL(LAST_NAME,'') FROM  TBL_MAS_USERS WHERE ID_LOGIN = WOLABOURDET.ID_LOGIN)                 
   END,                
   ISNULL(WO_LABOUR_HOURS,0),            
   ISNULL(WOLABOURDET.WO_HOURLEY_PRICE,0),                       
   CASE                 
    WHEN TEMPA.ID_WODET_SEQ IS NOT NULL                 
     THEN  (SELECT ISNULL(CAST(REPLACE((CASE WHEN WO_STD_TIME = '' THEN '0.00' ELSE WO_STD_TIME END),':','.')AS NUMERIC(15,2)),0) FROM TBL_WO_DETAIL WHERE  ID_WODET_SEQ = TEMPA.ID_WODET_SEQ)                
    ELSE 0                
   END,                
   0,            
   'admin',                
   GETDATE(),            
   'LABOUR',            
   WOLABOURDET.WO_VAT_ACCCODE,                
   WO_VAT_CODE,            
   --WO_LABOURVAT_PERCENTAGE,            
   debinv.LINE_VAT_PERCENTAGE as 'WO_LABOURVAT_PERCENTAGE',         
   WO_LABOUR_ACCOUNTCODE,                
   0,            
   0,            
   0,            
   0               
  FROM               
   @TEMP_TBL_INV_HEADER TEMPA            
   inner join TBL_WO_LABOUR_DETAIL WOLABOURDET on TEMPA.ID_WODET_SEQ = WOLABOURDET.ID_WODET_SEQ         
   inner join TBL_WO_DETAIL wod on wod.ID_WODET_SEQ=  TEMPA.ID_WODET_SEQ               
   inner join TBL_WO_DEBITOR_DETAIL debdet on debdet.ID_WO_NO=wod.ID_WO_NO and debdet.ID_WO_PREFIX=wod.ID_WO_PREFIX and debdet.ID_JOB_DEB = TEMPA.ID_DEBITOR        
   inner join TBL_WO_DEBTOR_INVOICE_DATA debinv on debinv.DEBTOR_SEQ = debdet.ID_DBT_SEQ and debinv.LINE_TYPE = 'LABOUR'            
                 
  IF @@ERROR <> 0            
  BEGIN             
   ROLLBACK TRANSACTION @TRANNAME                   
   RETURN                  
  END            
          
  --SELECT * FROM @TBL_INV_DETAIL        
  --SELECT * FROM @TBL_INV_DETAIL_LINES_LABOUR            
            
  --TO UPDATE TOTAL AMOUNT           
          
  --UPDATE @TBL_INV_DETAIL_LINES_LABOUR             
  --SET ID_COUNT = (SELECT COUNT(*) FROM TBL_WO_LABOUR_DETAIL WHERE         
                
  UPDATE  @TBL_INV_DETAIL_LINES_LABOUR                
       SET  INVL_STHOUR  = B.INVL_MECH_HOURLY_PRICE               
  FROM @TBL_INV_DETAIL_LINES_LABOUR B                
  WHERE INVL_MECH_HOURLY_PRICE =             
         (            
          SELECT MAX(INVL_MECH_HOURLY_PRICE)             
          FROM TBL_INV_DETAIL_LINES_LABOUR A                 
          WHERE A.ID_WODET_INVL = B.ID_WODET_INVL            
    )                
  AND INVL_STTime > 0                 
                
  --TO UPDATE AMOUNT BEFORE VAT                
  UPDATE @TBL_INV_DETAIL_LINES_LABOUR             
    SET INVL_BFAMOUNT = CASE                 
          WHEN INVL_STTime > 0                
           THEN ISNULL(INVL_STTime,0) * ISNULL(INVL_STHOUR ,0)                
          ELSE                 
           ISNULL(INVL_MECH_HOUR,0)* ISNULL(INVL_MECH_HOURLY_PRICE ,0)                
         END                
  --TO UPDATE VAT                
  UPDATE @TBL_INV_DETAIL_LINES_LABOUR            
     SET INVL_VAT = ISNULL(INVL_BFAMOUNT,0) *(0.01* ISNULL(INVL_VAT_PER,0))                
                
  UPDATE @TBL_INV_DETAIL_LINES_LABOUR             
    SET INVL_AMOUNT = ISNULL(INVL_BFAMOUNT,0) + ISNULL(INVL_VAT,0)                
              
  IF @@ERROR <> 0            
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME            
   RETURN             
  END                
                
        
        
  UPDATE @TBL_INV_DETAIL            
      SET  FLG_FIXED_PRICE = CASE             
          WHEN WO_FIXED_PRICE IS NULL OR WO_FIXED_PRICE=0            
           THEN 'FALSE'                  
          ELSE 'TRUE'                  
          END,               
     IN_DEB_GM_AMT = CASE             
          WHEN WO_TOT_GM_AMT  IS NOT NULL  AND (select count(*) FROM @TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_WODET_INVL = B.ID_WODET_SEQ) > 0                 
           THEN             
            ( SELECT TOP 1            
              CASE             
               WHEN INVL_DEB_CONTRIB > 0 AND INVL_DEB_CONTRIB is not null            
                THEN         
    --B.WO_TOT_GM_AMT*(0.01* (ISNULL(INVDL.INVL_DEB_CONTRIB,0)))                   
     (B.WO_TOT_GM_AMT  -        
       (B.WO_TOT_GM_AMT* 0.01 * ISNULL(B.WO_DISCOUNT,0)))        
          *        
      (0.01* (ISNULL(INVDL.INVL_DEB_CONTRIB,0)))         
               ELSE         
     --B.WO_TOT_GM_AMT                 
     (B.WO_TOT_GM_AMT   - (B.WO_TOT_GM_AMT* 0.01 * ISNULL(B.WO_DISCOUNT,0)))         
              END                 
             FROM @TBL_INV_DETAIL_LINES INVDL             
             WHERE INVDL.ID_INV_NO = [@TBL_INV_DETAIL].ID_INV_NO             
                AND INVDL.ID_WODET_INVL = B.ID_WODET_SEQ             
             )                
          ELSE         
    B.WO_TOT_GM_AMT              
         END                
  FROM TBL_WO_DETAIL B        
--,@INVOICETEMP1 TMP1            
  WHERE [@TBL_INV_DETAIL].ID_INV_NO             
      IN (SELECT ID_INV_NO FROM @INVOICETEMP1)             
     AND [@TBL_INV_DETAIL].ID_WODET_INV = B.ID_WODET_SEQ            
            
    --to be removed        
--select * from @TBL_INV_DETAIL        
--select * from @TBL_INV_DETAIL_LINES        
--removed end        
        
        
        
--Added on 09-Jan-2008        
UPDATE                   
@TBL_INV_DETAIL                   
SET                   
FLG_FIXED_PRICE =                   
CASE WHEN WO_FIXED_PRICE IS NULL OR WO_FIXED_PRICE=0 THEN                  
 'FALSE'                  
 ELSE                   
 'TRUE'                  
END,                   
--IN_DEB_GM_AMT = ISNULL(WO_TOT_GM_AMT,0)                  
IN_DEB_GM_AMT =                   
CASE WHEN WO_TOT_GM_AMT IS NOT NULL and (select count(*) FROM @TBL_INV_DETAIL_LINES INVDL WHERE INVDL.ID_WODET_INVL = ID_WODET_SEQ) > 0 THEN                  
        
           
 (              
  (B.WO_TOT_GM_AMT - (B.WO_TOT_GM_AMT* 0.01 * ISNULL(B.WO_DISCOUNT,0))) * (0.01* (ISNULL(INVDL.INVL_DEB_CONTRIB,0)))                  
 )        
                 
 ELSE                  
                
  (B.WO_TOT_GM_AMT   - (B.WO_TOT_GM_AMT* 0.01 * ISNULL(B.WO_DISCOUNT,0)))         
 END                   
FROM TBL_WO_DETAIL B,TBL_INV_DETAIL_LINES INVDL                 
 WHERE [@TBL_INV_DETAIL].ID_INV_NO=INVDL.ID_INV_NO        
                
AND [@TBL_INV_DETAIL].ID_WODET_INV = B.ID_WODET_SEQ         
--change end        
        
        
--to be removed        
--select * from @TBL_INV_DETAIL        
--removed end        
        
            
  UPDATE @TBL_INV_DETAIL            
      SET  INVD_VAT_AMOUNT = CASE             
          WHEN INVD_VAT_PERCENTAGE IS NOT NULL AND  IN_DEB_GM_AMT IS NOT NULL                
           THEN IN_DEB_GM_AMT  * (0.01* (ISNULL(INVD_VAT_PERCENTAGE,0)))                
          ELSE 0                
          END                 
  WHERE [@TBL_INV_DETAIL].ID_INV_NO IN             
    (SELECT ID_INV_NO FROM @INVOICETEMP1)            
                 
  --TO UPDATE GM AMOUNT AFTER INCLUDING VAT                 
  UPDATE @TBL_INV_DETAIL                       
   SET  IN_DEB_GM_AMT = isnull(IN_DEB_GM_AMT,0) +  isnull(INVD_VAT_AMOUNT,0),                 
    IN_DEB_JOB_AMT = isnull(IN_DEB_JOB_AMT,0) +  isnull(INVD_VAT_AMOUNT,0)                 
  WHERE [@TBL_INV_DETAIL].ID_INV_NO IN             
     (SELECT ID_INV_NO FROM @INVOICETEMP1)                  
                
  IF @@ERROR <> 0            
  BEGIN             
   ROLLBACK TRANSACTION @TRANNAME               
   RETURN            
  END                
                
  DECLARE @TEMPVAT as table              
  (              
   ID_INV_NO NCHAR(20),              
   ID_WODET_INV INT,              
   INVL_VAT_ACCCODE VARCHAR(20),              
   INVL_VAT_AMOUNT NUMERIC(15,2)              
  )              
 -- VAT FOR LABOUR DETAILS                
 --LABOUR             
  INSERT INTO @TEMPVAT              
  SELECT             
   ID_INV_NO,            
   ID_WODET_INVL,            
   INVL_VAT_ACCCODE,            
   SUM(INVL_VAT)             
  FROM             
   @TBL_INV_DETAIL_LINES_LABOUR A                
  WHERE A.ID_INV_NO IN             
    (SELECT ID_INV_NO FROM @INVOICETEMP1)                   
  GROUP BY ID_INV_NO,ID_WODET_INVL,INVL_VAT_ACCCODE                
  --Spares            
  INSERT INTO @TEMPVAT              
  SELECT ID_INV_NO,            
      ID_WODET_INVL,            
      INVL_VAT_ACCCODE,            
      SUM(INVL_VAT)             
  FROM             
   @TBL_INV_DETAIL_LINES A            
   WHERE A.ID_INV_NO IN             
      (SELECT ID_INV_NO FROM @INVOICETEMP1)                   
  GROUP BY ID_INV_NO,ID_WODET_INVL,INVL_VAT_ACCCODE                
  --GarageMaterial                
  INSERT INTO @TEMPVAT              
  SELECT ID_INV_NO,            
      ID_WODET_INV,            
  INVD_VAT_ACCOUNTCODE,            
   SUM(INVD_VAT_AMOUNT)             
  FROM @TBL_INV_DETAIL A               
  WHERE A.ID_INV_NO IN             
       (SELECT ID_INV_NO FROM @INVOICETEMP1)                   
  GROUP BY ID_INV_NO,ID_WODET_INV,INVD_VAT_ACCOUNTCODE            
                
  --INSERT INTO VAT TABLE              
  INSERT INTO @TBL_INV_DETAIL_LINES_VAT             
  SELECT               
   ID_INV_NO,              
   ID_WODET_INV,              
   INVL_VAT_ACCCODE,              
   SUM(INVL_VAT_AMOUNT)              
  FROM @TEMPVAT              
  GROUP BY ID_INV_NO ,ID_WODET_INV,INVL_VAT_ACCCODE              
                    
  --CODING TO UPDATE THE INVOICE AMT             
  DECLARE @INVOICESUM TABLE (ID_INV_NO VARCHAR(10), INV_AMT DECIMAL)             
                 
  /* TBL_INV_HEADER ,TBL_INV_DETAIL has to be changed into temp table */                
  INSERT INTO @INVOICESUM             
  SELECT                  
   B.ID_INV_NO,            
   SUM(ISNULL(IN_DEB_JOB_AMT,0))                 
  FROM @TBL_INV_HEADER B,@TBL_INV_DETAIL A             
  WHERE B.ID_INV_NO = A.ID_INV_NO AND             
     B.ID_INV_NO IN             
       (SELECT ID_INV_NO FROM @INVOICETEMP1)              
  GROUP BY B.ID_INV_NO            
       
  UPDATE @TBL_INV_HEADER            
      SET INV_AMT = A.INV_AMT FROM @INVOICESUM A             
  WHERE [@TBL_INV_HEADER].ID_INV_NO = A.ID_INV_NO                 
                      
  IF @@ERROR <> 0                
  BEGIN            
   ROLLBACK TRANSACTION @TRANNAME              
   RETURN            
  END                
               
  --CODING TO GENERATE THE INVOICE BASED ON TEMP TABLE                 
  DECLARE @TEMPTAB TABLE                  
  (                  
   ID_INV_NO VARCHAR(10),                  
   FLG_INVORCN BIT                  
  )             
  --INSERT INTO THE TEMP TABLE THE CORRESPONDING INVOICE NO                 
                 
  INSERT INTO @TEMPTAB             
  SELECT ID_INV_NO,            
      0            
  FROM @TBL_INV_HEADER         
          
      
              
            
           
           
--select * From @TBL_INV_DETAIL_LINES            
            
--to be removed          
--select * from @TBL_INV_HEADER          
--select * from @TBL_INV_DETAIL          
--select '@TBL_INV_DETAIL_LINES_LABOUR', * from @TBL_INV_DETAIL_LINES_LABOUR          
--select * from @TBL_INV_DETAIL_LINES          
--select * from TBL_WO_JOB_DETAIL where ID_WOITEM_SEQ in (43062,43063)          
--select * from TBL_WO_DETAIL where ID_WODET_SEQ in (17767,17768)          
--select * from TBL_WO_HEADER where id_wo_no='191' and id_wo_prefix='fa'          
--select * from TBL_WO_DEBITOR_DETAIL where id_wo_no='191' and id_wo_prefix='fa'          
--removed end          
  --select * from @TEMPTAB            
        
 DECLARE @TBL_WO_DEBTOR_INVOICE_DATA_GM TABLE            
 (            
    DEBTOR_SEQ INT,            
    LINE_VAT_PERCENTAGE decimal(20,2),         
    LINE_AMOUNT decimal(20,2),         
    LINE_TYPE varchar(20),         
    LINE_VAT_AMOUNT decimal(15,2)        
    , DISC_PERCENT decimal(15,2)           
    ,PRICE DECIMAL(20,2)      
 ,JOBSUM DECIMAL(20,2)      
 ,INVOICESUM DECIMAL(20,2)   
 ,WO_LABOUR_DESC VARCHAR(100)  
 ,ID_WOLAB_SEQ INT         
 )           
  
 INSERT INTO @TBL_WO_DEBTOR_INVOICE_DATA_GM        
 SELECT DEBTOR_SEQ,        
 (LINE_VAT_PERCENTAGE) LINE_VAT_PERCENTAGE,        
 (LINE_AMOUNT) LINE_AMOUNT,        
 LINE_TYPE,        
 (LINE_VAT_AMOUNT) LINE_VAT_AMOUNT,        
 (DISC_PERCENT) DISC_PERCENT,        
 (PRICE) PRICE,      
 JOBSUM,INVOICESUM  
 ,LD.WO_LABOUR_DESC  
 ,LD.ID_WOLAB_SEQ        
  FROM TBL_WO_DEBTOR_INVOICE_DATA DEBINV        
  INNER JOIN TBL_WO_DETAIL WD ON DEBINV.ID_WO_NO = WD.ID_WO_NO AND DEBINV.ID_WO_PREFIX=WD.ID_WO_PREFIX AND WD.ID_JOB = DEBINV.ID_JOB_ID        
  INNER JOIN @INVOICETEMP1 TEMP        
  ON DEBINV.ID_WO_NO = TEMP.ID_WO_NO AND DEBINV.ID_WO_PREFIX=TEMP.ID_WO_PREFIX  AND DEBINV.DEBTOR_ID=TEMP.ID_DEBITOR AND WD.ID_WODET_SEQ=TEMP.ID_WODET_SEQ        
  INNER JOIN TBL_WO_LABOUR_DETAIL LD ON LD.ID_WODET_SEQ = WD.ID_WODET_SEQ AND DEBINV.ID_WOLAB_SEQ = LD.ID_WOLAB_SEQ     
 WHERE  DEBINV.LINE_TYPE IN ('GM') AND WD.JOB_STATUS <> 'DEL'         
 -- GROUP BY LINE_TYPE,DEBTOR_SEQ,DEBINV.ID_JOB_ID,JOBSUM,INVOICESUM        
        
 DECLARE @TBL_WO_DEBTOR_INVOICE_DATA TABLE            
 (            
 ID_DEB_INV_SEQ INT,   
 DEBTOR_SEQ INT,            
    LINE_VAT_PERCENTAGE decimal(20,2),         
    LINE_AMOUNT decimal(20,2),         
    LINE_AMOUNT_NET decimal(20,2),        
    LINE_TYPE varchar(20),         
    LINE_VAT_AMOUNT decimal(15,2)        
    , DISC_PERCENT decimal(15,2)          
    ,PRICE DECIMAL(20,2)        
    ,DEL_QTY decimal(15,2)        
    ,GM_AMOUNT DECIMAL(20,2)        
    ,GM_VAT_AMOUNT DECIMAL(20,2)       
    ,JOBSUM DECIMAL(20,2)      
    ,INVOICESUM DECIMAL(20,2)      
    ,VATCALCULATEDFROM DECIMAL(20,2)  
    ,TOTALVATAMOUNT DECIMAL(20,2)    
    ,VATTRANSFERREDDEBTOR INT  
    ,WO_LABOUR_DESC VARCHAR(100)         
 )          
    
INSERT INTO @TBL_WO_DEBTOR_INVOICE_DATA        
SELECT DEBINV.ID_DEB_INV_SEQ,  
DEBINV.DEBTOR_SEQ,        
MAX(DEBINV.LINE_VAT_PERCENTAGE) LINE_VAT_PERCENTAGE,        
SUM(DEBINV.LINE_AMOUNT) LINE_AMOUNT,        
SUM(LINE_AMOUNT_NET) LINE_AMOUNT_NET,        
DEBINV.LINE_TYPE,        
SUM(DEBINV.LINE_VAT_AMOUNT) LINE_VAT_AMOUNT,        
MAX(DEBINV.DISC_PERCENT) DISC_PERCENT,        
MAX(DEBINV.PRICE) PRICE,        
SUM(DEBINV.DEL_QTY) DEL_QTY,        
DG.LINE_AMOUNT,DG.LINE_VAT_AMOUNT,      
DEBINV.JOBSUM,DEBINV.INVOICESUM      
,DEBINV.CALCULATEDFROM VATCALCULATEDFROM      
,DEBINV.FINDVAT TOTALVATAMOUNT      
,DEBINV.VAT_TRANSFER VATTRANSFERREDDEBTOR  
,LD.WO_LABOUR_DESC          
  FROM TBL_WO_DEBTOR_INVOICE_DATA DEBINV         
  INNER JOIN TBL_WO_DETAIL WD ON DEBINV.ID_WO_NO = WD.ID_WO_NO AND DEBINV.ID_WO_PREFIX=WD.ID_WO_PREFIX AND WD.ID_JOB = DEBINV.ID_JOB_ID        
  INNER JOIN TBL_WO_LABOUR_DETAIL LD ON LD.ID_WODET_SEQ = WD.ID_WODET_SEQ AND DEBINV.ID_WOLAB_SEQ = LD.ID_WOLAB_SEQ     
  INNER JOIN @TBL_WO_DEBTOR_INVOICE_DATA_GM DG        
  ON DG.DEBTOR_SEQ = DEBINV.DEBTOR_SEQ AND LD.ID_WOLAB_SEQ = DG.ID_WOLAB_SEQ  
  INNER JOIN @INVOICETEMP1 TEMP        
  ON DEBINV.ID_WO_NO = TEMP.ID_WO_NO AND DEBINV.ID_WO_PREFIX=TEMP.ID_WO_PREFIX  AND DEBINV.DEBTOR_ID=TEMP.ID_DEBITOR AND WD.ID_WODET_SEQ=TEMP.ID_WODET_SEQ        
  WHERE  DEBINV.LINE_TYPE IN ('LABOUR') AND WD.JOB_STATUS <> 'DEL'        
  GROUP BY DEBINV.ID_DEB_INV_SEQ,DEBINV.LINE_TYPE,DEBINV.DEBTOR_SEQ,DG.LINE_AMOUNT,DG.LINE_VAT_AMOUNT,DEBINV.LINE_ID,DEBINV.ID_JOB_ID,DEBINV.JOBSUM,DEBINV.INVOICESUM,DEBINV.CALCULATEDFROM      
  ,DEBINV.FINDVAT,DEBINV.VATAMOUNT,DEBINV.VAT_TRANSFER,LD.WO_LABOUR_DESC          
        
 DECLARE @TBL_WO_DEBTOR_INVOICE_DATA_SPR TABLE            
 (            
    DEBTOR_SEQ INT,            
    LINE_VAT_PERCENTAGE decimal(20,2),         
    LINE_AMOUNT decimal(20,2),         
    LINE_AMOUNT_NET decimal(20,2),        
    LINE_TYPE varchar(20),         
    LINE_VAT_AMOUNT decimal(15,2)        
    , DISC_PERCENT decimal(15,2)         
    ,PRICE DECIMAL(20,2)        
    ,LINE_ID varchar(100)      
 ,ID_MAKE varchar(100)      
 ,ID_WH varchar(50)      
 ,JOBSUM DECIMAL(20,2)      
 ,INVOICESUM DECIMAL(20,2)      
 ,VATCALCULATEDFROM DECIMAL(20,2),      
 TOTALVATAMOUNT DECIMAL(20,2),      
 VATTRANSFERREDDEBTOR INT,
 ID_WOITEM_SEQ INT         
 )           
        
INSERT INTO @TBL_WO_DEBTOR_INVOICE_DATA_SPR        
 SELECT DEBINV.DEBTOR_SEQ,        
  DEBINV.LINE_VAT_PERCENTAGE,        
  DEBINV.LINE_AMOUNT,        
  DEBINV.LINE_AMOUNT_NET,        
  DEBINV.LINE_TYPE,        
  DEBINV.LINE_VAT_AMOUNT,        
  DEBINV.DISC_PERCENT,        
  DEBINV.PRICE,        
  DEBINV.LINE_ID,      
  WJD.ID_MAKE_JOB,      
  WJD.ID_WAREHOUSE,      
  DEBINV.JOBSUM,DEBINV.INVOICESUM      
  ,DEBINV.CALCULATEDFROM VATCALCULATEDFROM      
  ,DEBINV.FINDVAT TOTALVATAMOUNT      
  ,DEBINV.VAT_TRANSFER VATTRANSFERREDDEBTOR
  ,DEBINV.ID_WOITEM_SEQ      
  FROM TBL_WO_DEBTOR_INVOICE_DATA DEBINV       
  inner join TBL_WO_DETAIL WD on DEBINV.ID_WO_NO = WD.ID_WO_NO AND DEBINV.ID_WO_PREFIX=WD.ID_WO_PREFIX and wd.ID_JOB = debinv.ID_JOB_ID      
  inner join @INVOICETEMP1 TEMP      
  on DEBINV.ID_WO_NO = TEMP.ID_WO_NO AND DEBINV.ID_WO_PREFIX=TEMP.ID_WO_PREFIX  AND DEBINV.DEBTOR_ID=TEMP.ID_DEBITOR and wd.ID_WODET_SEQ=temp.ID_WODET_SEQ      
  inner join TBL_WO_JOB_DETAIL WJD ON WJD.ID_WOITEM_SEQ = DEBINV.ID_WOITEM_SEQ      
  where  DEBINV.LINE_TYPE IN ('SPARES') AND WD.JOB_STATUS <> 'DEL'      
        
        
  SELECT                
  'Spares' as [Type] ,                  
--   --Subsidiary Information              
  ISNULL(ms.SS_NAME,'') AS 'SUBSIDIARYNAME',              
  ISNULL(ms.SS_ADDRESS1,'') AS 'SUBSIDIARYADDRESS1',              
  ISNULL(ms.SS_ADDRESS2,'') AS 'SUBSIDIARYADDRESS2',             
  ISNULL(mzSubsidiary.ZIP_CITY,'') AS 'SUBSIDIARYCITY',              
  ISNULL(mzSubsidiary.ZIP_ZIPCODE,'') AS 'SUBSIDIARYZIPCODE',        
  ISNULL(mcdSubsidiaryState.DESCRIPTION,'') AS 'SUBSIDIARYSTATE',              
  ISNULL(mcdSubsidiaryCountry.DESCRIPTION,'') AS 'SUBSIDIARYCOUNTRY',            
  ISNULL(ms.SS_PHONE1,'') AS 'SUBSIDIARYPHONE1',              
  ISNULL(ms.SS_PHONE2,'') AS 'SUBSIDIARYPHONE2',          
  ISNULL(ms.SS_PHONE_MOBILE,'') AS 'SUBSIDIARYMOBILE',              
  ISNULL(ms.SS_FAX,'') AS 'SUBSIDIARYFAX',         
  ISNULL(ms.ID_EMAIL_SUBSID,'') AS 'SUBSIDIARYEMAIL',              
  ISNULL(ms.SS_ORGANIZATIONNO,'') AS 'SUBSIDIARYORGANIZATIONNO',                 
  ISNULL(ms.SS_BANKACCOUNT,'') AS 'SUBSIDIARYBANKACCOUNT',                  
  ISNULL(ms.SS_IBAN,'') AS 'SUBSIDIARYIBAN',              
  ISNULL(ms.SS_SWIFT,'') AS 'SUBSIDIARYSWIFT',               
                
  --Department Information              
  ISNULL(md.DPT_Name,'') AS 'DEPARTMENTNAME',             
  ISNULL(md.DPT_Address1,'') AS 'DEPARTMENTADDRESS1',              
  ISNULL(md.DPT_Address2,'') AS 'DEPARTMENTADDRESS2',            
  ISNULL(mzDepartment.ZIP_CITY,'') AS 'DEPARTMENTCITY',              
  ISNULL(mzDepartment.ZIP_ZIPCODE,'') AS 'DEPARTMENTZIPCODE',        
  ISNULL(mcdDepartmentState.DESCRIPTION,'') AS 'DEPARTMENTSTATE',              
  ISNULL(mcdDepartmentCountry.DESCRIPTION,'') AS 'DEPARTMENTCOUNTRY',            
  ISNULL(md.DPT_PHONE,'') AS 'DEPARTMENTPHONE',              
  ISNULL(md.DPT_PHONE_MOBILE,'') AS 'DEPARTMENTMOBILE',          
  ISNULL(ms.SS_ORGANIZATIONNO,'') AS 'DEPARTMENTORGANIZATIONNO',              
  ISNULL(ms.SS_BANKACCOUNT,'') AS 'DEPARTMENTBANKACCOUNT',           
  ISNULL(ms.SS_IBAN ,'')AS 'DEPARTMENTIBAN',                  
  ISNULL(ms.SS_SWIFT,'') AS 'DEPARTMENTSWIFT',              

  --Header Information                  
  ih.ID_INV_NO AS 'INVOICENO',          
  CAST(cast ((ih.DT_INVOICE + mcp.TERMS) As Varchar(20))AS DATETIME) AS 'DUEDATE',                  
  ih.DT_INVOICE AS 'INVOICEDATE',              
  ih.INV_KID AS 'KIDNO',                  
  wh.ID_WO_PREFIX AS 'WORKORDERPREFIX',        
  wh.ID_WO_NO AS 'WORKORDERNO',                  
  wh.DT_ORDER AS 'ORDERDATE',           
  wh.CREATED_BY AS 'USER',                  
  ih.ID_DEBITOR AS 'CUSTOMERID',        
  wd.WO_OWN_CR_CUST AS 'VEHICLEOWNERID',                  
  wh.WO_ANNOT AS 'ANNOTATION',        
  (SELECT T.CUST_NAME FROM TBL_MAS_CUSTOMER T WHERE T.ID_CUSTOMER = WD.WO_OWN_CR_CUST ) AS 'OWNERNAME',   --ih.INV_AMT  AS 'ROUNDEDAMOUNT',                
  CASE WHEN (SELECT COUNT(*) FROM TBL_WO_LABOUR_DETAIL LABOUR WHERE WD.id_wodet_seq = LABOUR.id_wodet_seq) > 1           
 THEN                  
  DBO.fnGetINVRoundAMT(ih.INV_AMT   * idl.invl_deb_contrib/100,mic.INV_RND_DECIMAL,mic.INV_PRICE_RND_VAL_PER,mic.INV_PRICE_RND_FN)                              
    ELSE                        
  DBO.fnGetINVRoundAMT((ih.INV_AMT + ((wd.WO_CHRG_TIME) * wd.WO_HOURLEY_PRICE - ((wd.WO_CHRG_TIME) * wd.WO_HOURLEY_PRICE * wd.WO_DISCOUNT/100))     * idl.invl_deb_contrib/100),mic.INV_RND_DECIMAL,mic.INV_PRICE_RND_VAL_PER,mic.INV_PRICE_RND_FN)           
 END AS 'ROUNDEDAMOUNT',            
            
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN        
 ISNULL(wh.WO_CUST_NAME,'')         
  ELSE        
 ISNULL(mc.CUST_NAME,'')        
  END        
  AS 'CUSTOMERNAME',         
         
  CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0)  THEN        
 ISNULL(mc.CUST_PERM_ADD1,'')         
  ELSE        
 ISNULL(mc.CUST_BILL_ADD1,'')         
  END        
   AS 'CUSTOMERADDRESS1',         
        
  CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0)  THEN        
 ISNULL(mc.CUST_PERM_ADD2,'')         
  ELSE        
 ISNULL(mc.CUST_BILL_ADD2,'')         
  END        
  AS 'CUSTOMERADDRESS2',         
        
 CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0 ) THEN        
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
          
 CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0 ) THEN        
 ISNULL(mc.ID_CUST_PERM_ZIPCODE,'')         
  ELSE        
 ISNULL(mc.ID_CUST_BILL_ZIPCODE,'')         
  END        
  AS 'CUSTOMERZIPCODE',         
          
  ISNULL(wh.DELIVERY_ADDRESS_NAME,'') AS 'CUSTOMERDELIVERYADDRESSNAME',              
  ISNULL(wh.DELIVERY_ADDRESS_LINE1,'') AS 'CUSTOMERDELIVERYADDRESS1',            
  ISNULL(wh.DELIVERY_ADDRESS_LINE2,'') AS 'CUSTOMERDELIVERYADDRESS2',              
  ISNULL(mzCustomerDelivery.ZIP_CITY,'') AS 'CUSTOMERDELIVERYCITY',              
  ISNULL(mcdCustomerStateDelivery.DESCRIPTION,'') AS 'CUSTOMERDELIVERYSTATE',              
  ISNULL(wh.DELIVERY_COUNTRY,'') AS 'CUSTOMERDELIVERYCOUNTRY',                   
  ISNULL(mzCustomerDelivery.ZIP_ZIPCODE,'') AS 'CUSTOMERDELIVERYZIPCODE',                      
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
  --Vehicle Information                  
  id.VEH_REG_NO AS 'VEHICLEREGISTRATIONNO',          
   mv.VEH_INTERN_NO AS 'INTERNALNO',                  
  mv.VEH_VIN AS 'VIN',         
  mv.DT_VEH_ERGN AS 'FIRSTREGISTRATIONDATE',                  
  id.WO_VEH_MILEAGE AS 'VEHICLEMILEAGE',        
  mv.VEH_TYPE AS 'SHOWTYPE',         
   ISNULL(wd.WO_OWN_PAY_VAT, 0) AS 'OWNERPAYVATJOB',              
 CASE WHEN EXISTS(SELECT ID_WODET_SEQ FROM TBL_WO_DETAIL WHERE ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX AND WO_OWN_PAY_VAT = 1 and id_job IN (select ID_JOB_ID from TBL_WO_DEBITOR_DETAIL where ID_JOB_DEB=ih.ID_DEBITOR and ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX)) THEN        
 CAST(1 AS BIT)        
  ELSE        
 CAST(0 AS BIT)        
  END  AS 'OWNERPAYVAT',         
         
  dbo.fnGetTransferredVAT(id.ID_WO_NO, id.ID_WO_PREFIX) AS 'TRANSFERREDVAT',        
  wd.WO_VAT_PERCENTAGE AS 'VATPERCENTAGE',        
          
 (SELECT CAST(MAX(CAST(WO_OWN_PAY_VAT AS INT)) AS BIT) FROM TBL_WO_DETAIL         
  WHERE ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX and id_job IN (select ID_JOB_ID from TBL_WO_DEBITOR_DETAIL where ID_JOB_DEB=ih.ID_DEBITOR and ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX)) AS 'OWNPAYVAT1',        
        
  CAST(dbo.fnGetVATTransFromCustID(id.ID_WO_NO, id.ID_WO_PREFIX) AS VARCHAR(10)) AS 'TRANSFERREDFROMCUSTID',        
  dbo.fnGetVATTransFromCustName(id.ID_WO_NO, id.ID_WO_PREFIX) AS 'TRANSFERREDFROMCUSTName',        
  WH.WO_VEH_HRS AS 'VEHICLEHOURS',        
                    
  --Spare Part / Labour Information                  
  idl.ID_MAKE AS 'MAKEID',              
  idl.ID_WAREHOUSE AS 'WAREHOUSEID',                  
  isnull(idl.ID_ITEM_INVL,'') AS 'SPAREPARTNO/LABOURID',         
         
               
  CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN wjd.[TEXT] ELSE wjd.ITEM_DESC END AS 'SPAREPARTNAME/LABOUR',                  
  CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN NULL ELSE idl.INVL_DELIVER_QTY END AS 'DELIVEREDQTY/TIME',                  
  CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN NULL ELSE JOBI_ORDER_QTY - ISNULL(idl.INVL_DELIVER_QTY,0)END AS 'QTYNOTDELIVERED',                  
  CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN NULL ELSE wjd.JOBI_ORDER_QTY END AS 'ORDEREDQTY',          
  mim.LOCATION,                  
  DEBINVSPR.PRICE AS 'PRICE',            
          
   DEBINVSPR.LINE_AMOUNT_NET AS 'SHOWTOTALPRICEBEFOREDISCOUNT',        
  DEBINVSPR.DISC_PERCENT AS  'DISCOUNT',        
    DEBINVSPR.LINE_AMOUNT AS 'TOTALAMOUNT',        
    DEBINVSPR.LINE_VAT_PERCENTAGE AS 'VATPER',         
  0 AS 'GARAGEMATERIALAMT',                
                    
  --Job Information                  
  id.ID_JOB AS 'JOBNUMBER',             
  NULL AS 'STDTIME',                  
  workCodeDesc.DESCRIPTION AS 'WORKCODE',             
  mrc.RP_REPCODE_DES AS 'REPAIRCODE',                  
  wd.WO_JOB_TXT AS 'JOBTEXT',            
 DEBINVSPR.LINE_VAT_AMOUNT AS 'VATAM0UNT',         
   (wd.WO_FIXED_PRICE * (DEBDET.DBT_PER/100))  AS 'FIXEDAMOUNT',          
    id.IN_DEB_JOB_AMT AS 'JOBAMOUNT',                  
  --id.FLG_FIXED_PRICE AS 'FLAGFIXEDPRICE',          
  CASE WHEN ISNULL(wd.WO_FIXED_PRICE,0.00) = 0.00 THEN 0 ELSE 1 END AS 'FLAGFIXEDPRICE',          
  wd.FLG_CHRG_STD_TIME AS 'FLAGCHARGESTDTIME',                  
                    
  --Image Information                  
  riHeader.IMAGE AS 'HEADERIMAGE',             
  riFOOTER.IMAGE AS 'FOOTERIMAGE',                  
                    
  --Rounding Information                  
  CASE WHEN mic.INV_RND_DECIMAL=0 THEN 1 ELSE mic.INV_RND_DECIMAL END AS 'ROUNDDECIMAL',      mic.INV_PRICE_RND_FN AS 'ROUNDFUNCTION',                  
  mic.INV_PRICE_RND_VAL_PER AS 'ROUNDPERCENTAGE',            
  CASE WHEN ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0) > 0            
   THEN         
 ISNULL((dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR) - wd.OwnRiskVATAmt),0)            
         
  ELSE             
  ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0)            
  END  AS 'OWNRISKAMOUNT',             
  CASE WHEN ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0) > 0            
    THEN ISNULL(wd.OwnRiskVATAmt,0)            
    ELSE 0            
  END AS 'OWNRISKVAT',        
  -- 11th jan        
  FLG_BATCH_INV ,              
  -- 11th jan        
  dbo.fnGetHeader(id.ID_WO_NO, id.ID_WO_PREFIX,@TYPE) AS 'HEADERTITLE',dbo.FN_BARCODE_ENCODE(wh.ID_WO_PREFIX +';'+ wh.ID_WO_NO + ';' + cast(isnull(wd.ID_JOB,'0') as varchar(10))) AS BARCODE,'0' AS BARCODE_DISP, --Added barcode as it is used for job cards.
  
    
                     
  CASE WHEN (SELECT rds.DISPLAY FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID            
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'            
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT          
     AND REF LIKE 'chkCommercialText') = 1  THEN           
   (SELECT rds.COMMERCIALTEXT FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID            
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'            
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT          
     AND REF LIKE 'chkCommercialText')        
  ELSE         
   NULL         
   END as  'COMMERCIALTEXT',        
   ISNULL(wd.SALESMAN,null) AS 'SHOWSALESMAN',---SHOWSALESMAN        
   wh.WO_TYPE_WOH AS 'ORDERTYPE',        
   CASE WHEN wh.ID_CUST_WO = ih.ID_DEBITOR THEN         
    CASE WHEN ( wh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)         
     THEN 0         
    ELSE ISNULL(ih.INV_FEES_AMT,0)         
    End         
   ELSE        
    CASE WHEN ( mc.ID_CUST_PAY_TERM IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)         
     THEN 0         
    ELSE ISNULL(ih.INV_FEES_AMT,0)         
    End         
   END          
   AS INV_FEES_AMT,        
   isnull((dbo.FnGetVATByCustID(wh.ID_CUST_WO) * isnull(INV_FEES_AMT,0) / 100),0) as INV_FEES_VAT_AMT,      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
 ELSE      
   CASE WHEN DEBDET.CUST_TYPE = 'MISC' THEN      
    0      
   ELSE      
    -1 * (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
   END      
 END AS 'REDUCTION_AMOUNT',      
 DEBINVSPR.JOBSUM AS 'JOBSUM',      
 DEBINVSPR.INVOICESUM AS 'INVOICESUM',      
 DEBINVSPR.VATCALCULATEDFROM      
 +       
 (      
  CASE WHEN wh.ID_CUST_WO = ih.ID_DEBITOR THEN       
   CASE WHEN ( wh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)       
    THEN 0       
   ELSE ISNULL(ih.INV_FEES_AMT,0)       
   End       
  ELSE      
   CASE WHEN ( mc.ID_CUST_PAY_TERM IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)       
    THEN 0       
   ELSE ISNULL(ih.INV_FEES_AMT,0)       
   End       
  END        
 )      
  AS 'VATCALCULATEDFROM',      
 DEBINVSPR.TOTALVATAMOUNT + (isnull((dbo.FnGetVATByCustID(wh.ID_CUST_WO) * isnull(INV_FEES_AMT,0) / 100),0))  AS 'TOTALVATAMOUNT',      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  DEBINVSPR.VATTRANSFERREDDEBTOR       
 ELSE      
  NULL      
 END      
 AS 'VATTRANSFERREDTODEBTOR'      
  FROM                   
  @TBL_INV_HEADER ih                  
  LEFT OUTER JOIN @TBL_INV_DETAIL id                  
   ON id.ID_INV_NO = ih.ID_INV_NO         
  LEFT OUTER JOIN @TBL_INV_DETAIL_LINES idl                  
   ON id.ID_WODET_INV = idl.ID_WODET_INVL                   
    AND id.ID_INV_NO = idl.ID_INV_NO                  
  LEFT OUTER JOIN TBL_WO_JOB_DETAIL wjd                   
   ON wjd.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ                  
  LEFT OUTER JOIN TBL_WO_DETAIL wd                  
 ON wd.ID_WODET_SEQ = id.ID_WODET_INV               
 and wd.id_job=  id.id_job             
  LEFT OUTER JOIN TBL_WO_HEADER wh                  
   ON id.ID_WO_NO = wh.ID_WO_NO                  
    AND id.ID_WO_PREFIX = wh.ID_WO_PREFIX              
               
--            
 left outer join TBL_WO_DEBITOR_DETAIL DEBDET                   
 ON DEBDET.ID_WO_NO= wd.ID_WO_NO AND                   
  DEBDET.ID_WO_PREFIX= wd.ID_WO_PREFIX AND                   
 ih.ID_DEBITOR=DEBDET.ID_JOB_DEB              
 and id.id_job=DEBDET.id_job_id          
        
 left outer join @TBL_WO_DEBTOR_INVOICE_DATA_SPR DEBINVSPR      
  ON DEBDET.ID_DBT_SEQ = DEBINVSPR.DEBTOR_SEQ        
  AND idl.ID_ITEM_INVL = DEBINVSPR.LINE_ID       
  AND idl.ID_MAKE = DEBINVSPR.ID_MAKE      
  AND idl.ID_WAREHOUSE = DEBINVSPR.ID_WH
  AND IDL.ID_WOITEM_SEQ = DEBINVSPR.ID_WOITEM_SEQ         
--            
  LEFT OUTER JOIN TBL_MAS_CUSTOMER mc                  
   ON ih.ID_DEBITOR = mc.ID_CUSTOMER         
  LEFT OUTER JOIN TBL_MAS_ZIPCODE mzCustomerPerm                  
   ON mc.ID_CUST_PERM_ZIPCODE = mzCustomerPerm.ZIP_ZIPCODE                    
  LEFT OUTER JOIN TBL_MAS_ZIPCODE mzCustomerPerm2         
   ON mc.ID_CUST_BILL_ZIPCODE = mzCustomerPerm2.ZIP_ZIPCODE         
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerState                  
   ON mzCustomerPerm.ZIP_ID_STATE = mcdCustomerState.ID_PARAM                  
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerState2         
   ON mzCustomerPerm2.ZIP_ID_STATE = mcdCustomerState2.ID_PARAM         
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerCountry                  
   ON mzCustomerPerm.ZIP_ID_COUNTRY = mcdCustomerCountry.ID_PARAM                  
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerCountry2         
   ON mzCustomerPerm2.ZIP_ID_COUNTRY = mcdCustomerCountry2.ID_PARAM         
  LEFT OUTER JOIN TBL_MAS_ZIPCODE mzCustomerDelivery                  
   ON wh.DELIVERY_ADDRESS_ZIPCODE = mzCustomerDelivery.ZIP_ZIPCODE                  
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdCustomerStateDelivery                  
   ON mzCustomerDelivery.ZIP_ID_STATE = mcdCustomerStateDelivery.ID_PARAM                  
  LEFT OUTER JOIN TBL_MAS_VEHICLE mv                  
   ON mv.ID_VEH_SEQ = wh.ID_VEH_SEQ_WO                  
  LEFT OUTER JOIN TBL_MAS_ITEM_MASTER mim                   
   ON idl.ID_ITEM_INVL = mim.ID_ITEM                  
    AND idl.ID_MAKE = mim.SUPP_CURRENTNO                  
    AND idl.ID_WAREHOUSE = mim.ID_WH_ITEM                  
  LEFT OUTER JOIN TBL_MAS_SETTINGS workCodeDesc                  
   ON workCodeDesc.ID_SETTINGS = wd.ID_WORK_CODE_WO                  
  LEFT OUTER JOIN TBL_MAS_REPAIRCODE mrc                  
   ON wd.ID_REP_CODE_WO = mrc.ID_REP_CODE                  
  LEFT OUTER JOIN TBL_MAS_CUST_GROUP mcg                  
   ON ih.INV_CUST_GROUP = mcg.ID_CUST_GRP_SEQ                  
  LEFT OUTER JOIN TBL_MAS_CUST_PAYTERMS mcp                  
   ON mcp.ID_PT_SEQ = mcg.ID_PAY_TERM            
  LEFT OUTER JOIN TBL_MAS_SUBSIDERY ms                  
   ON ms.ID_SUBSIDERY=ih.ID_SUBSIDERY_INV                 
  LEFT OUTER JOIN TBL_MAS_ZIPCODE mzSubsidiary                  
   ON ms.SS_ID_ZIPCODE = mzSubsidiary.ZIP_ZIPCODE                  
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdSubsidiaryState                  
   ON mzSubsidiary.ZIP_ID_STATE = mcdSubsidiaryState.ID_PARAM                 
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdSubsidiaryCountry                  
   ON mzSubsidiary.ZIP_ID_COUNTRY = mcdSubsidiaryCountry.ID_PARAM                  
  LEFT OUTER JOIN TBL_MAS_DEPT md                  
   ON md.ID_DEPT = ih.ID_DEPT_INV                  
  LEFT OUTER JOIN TBL_MAS_ZIPCODE mzDepartment                  
   ON md.DPT_ID_ZIPCODE = mzDepartment.ZIP_ZIPCODE                  
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdDepartmentState                  
   ON mzDepartment.ZIP_ID_STATE = mcdDepartmentState.ID_PARAM                  
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS mcdDepartmentCountry                  
   ON mzDepartment.ZIP_ID_COUNTRY = mcdDepartmentCountry.ID_PARAM                  
  LEFT OUTER JOIN TBL_REP_IMAGES riHeader                  
   ON riHeader.SUBSIDIARY = ih.ID_SUBSIDERY_INV                  
    AND riHeader.DEPARTMENT = ih.ID_DEPT_INV                  
      AND riHeader.REPORTID = 'INVOICEPRINT'                 
    AND riHeader.DISPLAYAREA = 'LOGO'                  
    AND riHeader.REPORTTYPE =  @TYPE                 
  LEFT OUTER JOIN TBL_REP_IMAGES riFooter                  
   ON riFooter.SUBSIDIARY = ih.ID_SUBSIDERY_INV                  
    AND riFooter.DEPARTMENT = ih.ID_DEPT_INV                  
    AND riFooter.REPORTID = 'INVOICEPRINT'                
    AND riFooter.DISPLAYAREA = 'FOOTER'                  
    AND riFooter.REPORTTYPE = @TYPE                  
  LEFT OUTER JOIN TBL_MAS_INV_CONFIGURATION mic                  
   ON mic.ID_SUBSIDERY_INV = ih.ID_SUBSIDERY_INV                  
    AND mic.ID_DEPT_INV = ih.ID_DEPT_INV                  
    AND mic.DT_EFF_TO IS NULL         
                   
  WHERE                  
   ih.ID_INV_NO IN (SELECT  ID_INV_NO FROM @TEMPTAB WHERE FLG_INVORCN='FALSE')                     
   AND DEBINVSPR.LINE_TYPE = 'SPARES'              
                  
  UNION ALL            
   SELECT               
  'Labour' AS [Type],                  
                
   --Subsidiary Information              
  ISNULL(ms.SS_NAME,'') AS 'SUBSIDIARYNAME',              
  ISNULL(ms.SS_ADDRESS1,'') AS 'SUBSIDIARYADDRESS1',              
  ISNULL(ms.SS_ADDRESS2,'') AS 'SUBSIDIARYADDRESS2',             
  ISNULL(mzSubsidiary.ZIP_CITY,'') AS 'SUBSIDIARYCITY',              
  ISNULL(mzSubsidiary.ZIP_ZIPCODE,'') AS 'SUBSIDIARYZIPCODE',        
  ISNULL(mcdSubsidiaryState.DESCRIPTION,'') AS 'SUBSIDIARYSTATE',              
  ISNULL(mcdSubsidiaryCountry.DESCRIPTION,'') AS 'SUBSIDIARYCOUNTRY',            
  ISNULL(ms.SS_PHONE1,'') AS 'SUBSIDIARYPHONE1',              
  ISNULL(ms.SS_PHONE2,'') AS 'SUBSIDIARYPHONE2',          
  ISNULL(ms.SS_PHONE_MOBILE,'') AS 'SUBSIDIARYMOBILE',              
  ISNULL(ms.SS_FAX,'') AS 'SUBSIDIARYFAX',         
  ISNULL(ms.ID_EMAIL_SUBSID,'') AS 'SUBSIDIARYEMAIL',              
  ISNULL(ms.SS_ORGANIZATIONNO,'') AS 'SUBSIDIARYORGANIZATIONNO',                 
  ISNULL(ms.SS_BANKACCOUNT,'') AS 'SUBSIDIARYBANKACCOUNT',                  
  ISNULL(ms.SS_IBAN,'') AS 'SUBSIDIARYIBAN',              
  ISNULL(ms.SS_SWIFT,'') AS 'SUBSIDIARYSWIFT',               
                
  --Department Information              
  ISNULL(md.DPT_Name,'') AS 'DEPARTMENTNAME',             
  ISNULL(md.DPT_Address1,'') AS 'DEPARTMENTADDRESS1',              
  ISNULL(md.DPT_Address2,'') AS 'DEPARTMENTADDRESS2',            
  ISNULL(mzDepartment.ZIP_CITY,'') AS 'DEPARTMENTCITY',              
  ISNULL(mzDepartment.ZIP_ZIPCODE,'') AS 'DEPARTMENTZIPCODE',        
  ISNULL(mcdDepartmentState.DESCRIPTION,'') AS 'DEPARTMENTSTATE',              
  ISNULL(mcdDepartmentCountry.DESCRIPTION,'') AS 'DEPARTMENTCOUNTRY',            
  ISNULL(md.DPT_PHONE,'') AS 'DEPARTMENTPHONE',              
  ISNULL(md.DPT_PHONE_MOBILE,'') AS 'DEPARTMENTMOBILE',          
  ISNULL(ms.SS_ORGANIZATIONNO,'') AS 'DEPARTMENTORGANIZATIONNO',              
  ISNULL(ms.SS_BANKACCOUNT,'') AS 'DEPARTMENTBANKACCOUNT',           
  ISNULL(ms.SS_IBAN ,'')AS 'DEPARTMENTIBAN',                  
  ISNULL(ms.SS_SWIFT,'') AS 'DEPARTMENTSWIFT',                
                
  --Header   Information                  
  ih.ID_INV_NO AS 'INVOICENO',                
  cast(cast ((ih.DT_INVOICE + mcp.TERMS) As Varchar(20))AS datetime) AS 'DUEDATE',                  
  ih.DT_INVOICE AS 'INVOICEDATE',          
  ih.INV_KID AS 'KIDNO',                  
  wh.ID_WO_PREFIX AS 'WORKORDERPREFIX',              
  wh.ID_WO_NO AS 'WORKORDERNO',                  
  wh.DT_ORDER AS 'ORDERDATE',        
  wh.CREATED_BY AS 'USER',                  
  ih.ID_DEBITOR AS 'CUSTOMERID',             
   wd.WO_OWN_CR_CUST AS 'VEHICLEOWNERID',                  
  wh.WO_ANNOT AS 'ANNOTATION',         
  (SELECT T.CUST_NAME FROM TBL_MAS_CUSTOMER T WHERE T.ID_CUSTOMER = WD.WO_OWN_CR_CUST )  AS 'OWNERNAME',                
       
   DBO.fnGetINVRoundAMT(ih.INV_AMT   * DEBDET.DBT_PER/100,mic.INV_RND_DECIMAL,mic.INV_PRICE_RND_VAL_PER,mic.INV_PRICE_RND_FN)                               
   AS 'ROUNDEDAMOUNT',            
                
  CASE WHEN wh.ID_CUST_WO = mc.ID_CUSTOMER THEN        
 ISNULL(wh.WO_CUST_NAME,'')         
  ELSE        
 ISNULL(mc.CUST_NAME,'')        
  END        
  AS 'CUSTOMERNAME',         
         
  CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0)  THEN        
 ISNULL(mc.CUST_PERM_ADD1,'')         
  ELSE        
 ISNULL(mc.CUST_BILL_ADD1,'')         
  END        
   AS 'CUSTOMERADDRESS1',         
        
   CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0 ) THEN        
 ISNULL(mc.CUST_PERM_ADD2,'')         
  ELSE        
 ISNULL(mc.CUST_BILL_ADD2,'')         
  END        
  AS 'CUSTOMERADDRESS2',         
        
   CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0 ) THEN        
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
          
   CASE WHEN (ih.ID_DEBITOR = mc.ID_CUSTOMER) AND ((SELECT ISNULL(USE_DELV_ADDRESS,0) FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = ih.ID_DEPT_INV and ID_SUBSIDERY_WO=ih.ID_SUBSIDERY_INV AND DT_EFF_TO>GETDATE()) = 0 ) THEN        
 ISNULL(mc.ID_CUST_PERM_ZIPCODE,'')         
  ELSE        
 ISNULL(mc.ID_CUST_BILL_ZIPCODE,'')         
  END        
  AS 'CUSTOMERZIPCODE',         
        
  ISNULL(wh.DELIVERY_ADDRESS_NAME,'') AS 'CUSTOMERDELIVERYADDRESSNAME',              
  ISNULL(wh.DELIVERY_ADDRESS_LINE1,'') AS 'CUSTOMERDELIVERYADDRESS1',            
  ISNULL(wh.DELIVERY_ADDRESS_LINE2,'') AS 'CUSTOMERDELIVERYADDRESS2',              
  ISNULL(mzCustomerDelivery.ZIP_CITY,'') AS 'CUSTOMERDELIVERYCITY',              
  ISNULL(mcdCustomerStateDelivery.DESCRIPTION,'') AS 'CUSTOMERDELIVERYSTATE',              
  ISNULL(wh.DELIVERY_COUNTRY,'') AS 'CUSTOMERDELIVERYCOUNTRY',                   
  ISNULL(mzCustomerDelivery.ZIP_ZIPCODE,'') AS 'CUSTOMERDELIVERYZIPCODE',                      
        
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
                   
  --Vehicle   Information                  
  id.VEH_REG_NO AS 'VEHICLEREGISTRATIONNO',          
  mv.VEH_INTERN_NO AS 'INTERNALNO',                  
  mv.VEH_VIN AS 'VIN',        
  mv.DT_VEH_ERGN AS 'FIRSTREGISTRATIONDATE',                  
  id.WO_VEH_MILEAGE AS 'VEHICLEMILEAGE',        
  mv.VEH_TYPE AS 'SHOWTYPE',         ISNULL(wd.WO_OWN_PAY_VAT, 0) AS 'OWNERPAYVATJOB',         
  CASE WHEN EXISTS(SELECT ID_WODET_SEQ FROM TBL_WO_DETAIL WHERE ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX AND WO_OWN_PAY_VAT = 1 and id_job IN (select ID_JOB_ID from TBL_WO_DEBITOR_DETAIL where ID_JOB_DEB=ih.ID_DEBITOR and ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX)) THEN        
 CAST(1 AS BIT)        
  ELSE        
 CAST(0 AS BIT)        
  END  AS 'OWNERPAYVAT',        
  dbo.fnGetTransferredVAT(id.ID_WO_NO, id.ID_WO_PREFIX) AS 'TRANSFERREDVAT',        
          
   wd.WO_VAT_PERCENTAGE AS 'VATPERCENTAGE',        
  (SELECT CAST(MAX(CAST(WO_OWN_PAY_VAT AS INT)) AS BIT) FROM TBL_WO_DETAIL         
    WHERE ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX and id_job IN (select ID_JOB_ID from TBL_WO_DEBITOR_DETAIL where ID_JOB_DEB=ih.ID_DEBITOR and ID_WO_NO = id.ID_WO_NO AND ID_WO_PREFIX = id.ID_WO_PREFIX)) AS 'OWNPAYVAT1',        
          
  CAST(dbo.fnGetVATTransFromCustID(id.ID_WO_NO, id.ID_WO_PREFIX) AS VARCHAR(10)) AS 'TRANSFERREDFROMCUSTID',        
  dbo.fnGetVATTransFromCustName(id.ID_WO_NO, id.ID_WO_PREFIX) AS 'TRANSFERREDFROMCUSTName',        
 WH.WO_VEH_HRS AS 'VEHICLEHOURS',        
  NULL AS 'MAKEID',          
  NULL AS 'WAREHOUSEID',                  
          
  '' AS 'SPAREPARTNO/LABOURID',         
  ISNULL(WO_LABOUR_DESC,'') AS 'SPAREPARTNAME/LABOUR',              
  DEBINV.DEL_QTY AS 'DELIVEREDQTY/TIME',        
  NULL AS 'QTYNOTDELIVERED',                  
  NULL AS 'ORDEREDQTY',              
  NULL AS LOCATION,                  
  DEBINV.PRICE AS 'PRICE',        
    DEBINV.LINE_AMOUNT_NET AS 'SHOWTOTALPRICEBEFOREDISCOUNT',           
  DEBINV.DISC_PERCENT        
  AS 'DISCOUNT',            
  DEBINV.LINE_AMOUNT AS 'TOTALAMOUNT',        
  DEBINV.LINE_VAT_PERCENTAGE AS 'VATPER',             
  DEBINV.GM_AMOUNT AS 'GARAGEMATERIALAMT',            
  wd.ID_JOB AS 'JOBNUMBER',        
  wd.WO_STD_TIME  AS 'STDTIME',            
  workCodeDesc.DESCRIPTION  AS 'WORKCODE',            
  mrc.RP_REPCODE_DES AS 'REPAIRCODE',                  
  wd.WO_JOB_TXT AS 'JOBTEXT',           
 DEBINV.LINE_VAT_AMOUNT+DEBINV.GM_VAT_AMOUNT AS 'VATAM0UNT',               
 (wd.WO_FIXED_PRICE * (DEBDET.DBT_PER/100))  AS 'FIXEDAMOUNT',           
 id.IN_DEB_JOB_AMT AS 'JOBAMOUNT',        
  CASE WHEN  ISNULL(wd.WO_FIXED_PRICE,0.00) = 0.00 THEN 0 ELSE 1 END AS 'FLAGFIXEDPRICE',             
  wd.FLG_CHRG_STD_TIME AS 'FLAGCHARGESTDTIME',                  
                    
  --Image Information                  
  riHeader.IMAGE AS 'HEADERIMAGE',             
  riFOOTER.IMAGE AS 'FOOTERIMAGE',                  
                
  --Rounding Information                  
  CASE WHEN mic.INV_RND_DECIMAL=0 THEN 1 ELSE mic.INV_RND_DECIMAL END AS 'ROUNDDECIMAL',              
  mic.INV_PRICE_RND_FN AS 'ROUNDFUNCTION',                  
  mic.INV_PRICE_RND_VAL_PER AS 'ROUNDPERCENTAGE',            
  CASE WHEN ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0) > 0            
   THEN         
  CASE WHEN (select count(*) from @TBL_INV_DETAIL_LINES_LABOUR lb where  wd.ID_WODET_seq = lb.ID_WODET_INVl) > 0 THEN           
   ISNULL((dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR) - wd.OwnRiskVATAmt),0)        
  ELSE        
   ISNULL((dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR) - wd.OwnRiskVATAmt),0)             
  END        
  ELSE            
  CASE WHEN (select count(*) from @TBL_INV_DETAIL_LINES_LABOUR lb where  wd.ID_WODET_seq = lb.ID_WODET_INVl) > 0 THEN           
     ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0)         
  ELSE        
   ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0)            
  END        
  END AS 'OWNRISKAMOUNT',             
  CASE WHEN ISNULL(dbo.[FETCHOWNRISKAMOUNT](wh.ID_WO_NO,wh.ID_WO_PREFIX,wd.ID_JOB,ih.ID_DEBITOR),0) > 0            
    THEN ISNULL(wd.OwnRiskVATAmt,0)            
    ELSE 0            
  END AS 'OWNRISKVAT',        
  -- 11th jan        
  FLG_BATCH_INV,        
  -- 11th jan        
  dbo.fnGetHeader(id.ID_WO_NO, id.ID_WO_PREFIX,@TYPE) AS 'HEADERTITLE',dbo.FN_BARCODE_ENCODE(wh.ID_WO_PREFIX +';'+ wh.ID_WO_NO + ';' + cast(isnull(wd.ID_JOB,'0') as varchar(10))) AS BARCODE,'0' AS BARCODE_DISP, --Added barcode as it is used for job cards.  
  CASE WHEN (SELECT rds.DISPLAY FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID            
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'            
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT          
     AND REF LIKE 'chkCommercialText') = 1  THEN           
   (SELECT rds.COMMERCIALTEXT FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID            
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'            
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT          
     AND REF LIKE 'chkCommercialText')        
  ELSE         
   NULL         
   END as  'COMMERCIALTEXT',        
   ISNULL(wd.SALESMAN,null) AS 'SHOWSALESMAN',--SHOWSALESMAN        
   wh.WO_TYPE_WOH AS 'ORDERTYPE',        
   CASE WHEN wh.ID_CUST_WO = ih.ID_DEBITOR THEN         
    CASE WHEN ( wh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)         
     THEN 0         
    ELSE ISNULL(ih.INV_FEES_AMT,0)         
    End         
   ELSE        
    CASE WHEN ( mc.ID_CUST_PAY_TERM IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)         
     THEN 0         
    ELSE ISNULL(ih.INV_FEES_AMT,0)         
    End         
   END          
   AS INV_FEES_AMT,        
           
   isnull((dbo.FnGetVATByCustID(wh.ID_CUST_WO) * isnull(INV_FEES_AMT,0) / 100),0) as INV_FEES_VAT_AMT,      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
 ELSE      
   CASE WHEN DEBDET.CUST_TYPE = 'MISC' THEN      
    0      
   ELSE      
    -1 * (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
   END      
 END AS 'REDUCTION_AMOUNT',      
    DEBINV.JOBSUM AS 'JOBSUM',      
 DEBINV.INVOICESUM AS 'INVOICESUM',      
  DEBINV.VATCALCULATEDFROM      
 +       
 (      
  CASE WHEN wh.ID_CUST_WO = ih.ID_DEBITOR THEN       
   CASE WHEN ( wh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)       
    THEN 0       
   ELSE ISNULL(ih.INV_FEES_AMT,0)       
   End       
  ELSE      
   CASE WHEN ( mc.ID_CUST_PAY_TERM IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or mc.FLG_CUST_IGNOREINV = 1 or isnull(ih.FLG_INV_FEES,0) = 0)       
    THEN 0       
   ELSE ISNULL(ih.INV_FEES_AMT,0)       
   End       
  END        
 )      
  AS 'VATCALCULATEDFROM',      
 DEBINV.TOTALVATAMOUNT + (isnull((dbo.FnGetVATByCustID(wh.ID_CUST_WO) * isnull(INV_FEES_AMT,0) / 100),0))  AS 'TOTALVATAMOUNT',      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  DEBINV.VATTRANSFERREDDEBTOR       
 ELSE      
  NULL      
 END      
 AS 'VATTRANSFERREDTODEBTOR'      
  FROM                     
  @TBL_INV_HEADER ih                  
  LEFT OUTER JOIN @TBL_INV_DETAIL id                  
   ON id.ID_INV_NO = ih.ID_INV_NO            
  LEFT OUTER JOIN TBL_WO_HEADER   wh                 
    ON id.ID_WO_NO = wh.ID_WO_NO            
    AND id.ID_WO_PREFIX = wh.ID_WO_PREFIX                  
  LEFT OUTER JOIN TBL_WO_DETAIL wd                  
    ON wd.ID_WODET_SEQ = id.ID_WODET_INV            
--                  
 left outer join TBL_WO_DEBITOR_DETAIL DEBDET                   
 ON DEBDET.ID_WO_NO= wd.ID_WO_NO AND                   
  DEBDET.ID_WO_PREFIX= wd.ID_WO_PREFIX AND                   
 ih.ID_DEBITOR=DEBDET.ID_JOB_DEB            
 and id.id_job=DEBDET.id_job_id           
        
 left outer join @TBL_WO_DEBTOR_INVOICE_DATA DEBINV        
  ON DEBDET.ID_DBT_SEQ = DEBINV.DEBTOR_SEQ             
--                      
  LEFT OUTER JOIN TBL_MAS_SETTINGS workCodeDesc                  
   ON workCodeDesc.ID_SETTINGS = wd.ID_WORK_CODE_WO                  
  LEFT OUTER JOIN TBL_MAS_REPAIRCODE mrc                  
   ON wd.ID_REP_CODE_WO = mrc.ID_REP_CODE                      
  LEFT OUTER JOIN TBL_MAS_CUSTOMER   mc            
    ON ih.ID_DEBITOR = mc.ID_CUSTOMER            
  LEFT OUTER JOIN TBL_MAS_ZIPCODE   mzCustomerPerm            
    ON mc.ID_CUST_PERM_ZIPCODE = mzCustomerPerm.ZIP_ZIPCODE           
  LEFT OUTER JOIN TBL_MAS_ZIPCODE   mzCustomerPerm2         
    ON mc.ID_CUST_BILL_ZIPCODE = mzCustomerPerm2.ZIP_ZIPCODE         
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdCustomerState            
    ON mzCustomerPerm.ZIP_ID_STATE = mcdCustomerState.ID_PARAM         
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdCustomerState2            
    ON mzCustomerPerm2.ZIP_ID_STATE = mcdCustomerState2.ID_PARAM         
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdCustomerCountry            
    ON mzCustomerPerm.ZIP_ID_COUNTRY = mcdCustomerCountry.ID_PARAM         
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdCustomerCountry2     
    ON mzCustomerPerm2.ZIP_ID_COUNTRY = mcdCustomerCountry2.ID_PARAM          
  LEFT OUTER JOIN TBL_MAS_ZIPCODE   mzCustomerDelivery            
    ON wh.DELIVERY_ADDRESS_ZIPCODE = mzCustomerDelivery.ZIP_ZIPCODE            
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdCustomerStateDelivery            
    ON mzCustomerDelivery.ZIP_ID_STATE = mcdCustomerStateDelivery.ID_PARAM            
  LEFT OUTER JOIN TBL_MAS_VEHICLE   mv            
    ON mv.ID_VEH_SEQ = wh.ID_VEH_SEQ_WO                  
  LEFT OUTER JOIN TBL_MAS_CUST_GROUP   mcg            
    ON ih.INV_CUST_GROUP = mcg.ID_CUST_GRP_SEQ            
  LEFT OUTER JOIN TBL_MAS_CUST_PAYTERMS   mcp            
    ON mcp.ID_PT_SEQ = mcg.ID_PAY_TERM                 
  LEFT OUTER JOIN TBL_MAS_SUBSIDERY   ms            
    ON ms.ID_SUBSIDERY=ih.ID_SUBSIDERY_INV            
  LEFT OUTER JOIN TBL_MAS_ZIPCODE   mzSubsidiary            
    ON ms.SS_ID_ZIPCODE = mzSubsidiary.ZIP_ZIPCODE            
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdSubsidiaryState            
    ON mzSubsidiary.ZIP_ID_STATE = mcdSubsidiaryState.ID_PARAM            
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdSubsidiaryCountry            
    ON mzSubsidiary.ZIP_ID_COUNTRY = mcdSubsidiaryCountry.ID_PARAM            
  LEFT OUTER JOIN TBL_MAS_DEPT   md            
    ON md.ID_DEPT = ih.ID_DEPT_INV            
  LEFT OUTER JOIN TBL_MAS_ZIPCODE   mzDepartment            
    ON md.DPT_ID_ZIPCODE = mzDepartment.ZIP_ZIPCODE            
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdDepartmentState            
    ON mzDepartment.ZIP_ID_STATE = mcdDepartmentState.ID_PARAM            
  LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS   mcdDepartmentCountry            
    ON mzDepartment.ZIP_ID_COUNTRY = mcdDepartmentCountry.ID_PARAM                  
  LEFT OUTER JOIN TBL_REP_IMAGES riHeader                  
   ON riHeader.SUBSIDIARY = ih.ID_SUBSIDERY_INV                  
    AND riHeader.DEPARTMENT = ih.ID_DEPT_INV                  
    AND riHeader.REPORTID = 'INVOICEPRINT'                  
    AND riHeader.DISPLAYAREA = 'LOGO'                  
    AND riHeader.REPORTTYPE = @TYPE                 
  LEFT OUTER JOIN TBL_REP_IMAGES riFooter                  
   ON riFooter.SUBSIDIARY = ih.ID_SUBSIDERY_INV                  
    AND riFooter.DEPARTMENT = ih.ID_DEPT_INV                  
    AND riFooter.REPORTID = 'INVOICEPRINT'                 
    AND riFooter.DISPLAYAREA = 'FOOTER'                  
    AND riFooter.REPORTTYPE = @TYPE                    
  LEFT OUTER JOIN TBL_MAS_INV_CONFIGURATION mic                  
   ON mic.ID_SUBSIDERY_INV = ih.ID_SUBSIDERY_INV                  
    AND mic.ID_DEPT_INV = ih.ID_DEPT_INV                  
    AND mic.DT_EFF_TO IS NULL                      
  WHERE                    
   ih.ID_INV_NO IN (SELECT ID_INV_NO FROM @TEMPTAB WHERE FLG_INVORCN='FALSE')            
   AND DEBINV.LINE_TYPE = 'LABOUR'        
        
                 
  IF @@ERROR = 0                     
  BEGIN            
   COMMIT TRANSACTION @TRANNAME             
   RETURN            
  END            
  ELSE            
  BEGIN                
   ROLLBACK TRANSACTION @TRANNAME               
   RETURN                 
  END                
END 

GO

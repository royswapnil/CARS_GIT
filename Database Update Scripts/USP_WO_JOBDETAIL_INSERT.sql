/****** Object:  StoredProcedure [dbo].[USP_WO_JOBDETAIL_INSERT]    Script Date: 10/5/2017 3:34:54 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_JOBDETAIL_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_JOBDETAIL_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_JOBDETAIL_INSERT]    Script Date: 10/5/2017 3:34:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_JOBDETAIL_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_JOBDETAIL_INSERT] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                                      
* Module : Master                                      
* File name : USP_WO_JOBDETAIL_INSERT.PRC                                      
* Purpose : To Insert the Job Details.                                       
* Author : M.Thiyagarajan.                                      
* Date  : 12.10.2006                                      
*********************************************************************************************************************/                                      
/*********************************************************************************************************************                                        
I/P : -- Input Parameters                                      
O/P : -- Output Parameters                                      
Error Code                                      
Description      INT.VerNO : NOV21.0                                  
                                      
********************************************************************************************************************/                                      
--'*********************************************************************************'*********************************                                      
--'* Modified History :                                         
--'* S.No  RFC No/Bug ID   Date        Author  Description                                       
                                   
                                   
--'*********************************************************************************'*********************************                                      
                                  
ALTER PROC [dbo].[USP_WO_JOBDETAIL_INSERT]                                    
(                                            
  @IV_XMLDOC    NTEXT,                                            
  @IV_ID_WODET_SEQ_JOB INT,                                          
  @IV_CREATED_BY   VARCHAR(20),                                          
  @IV_ID_WO_NO   VARCHAR(10),                                          
  @IV_ID_WO_PREFIX  VARCHAR(3),                                          
  @OV_RETVALUE   VARCHAR(10)  OUTPUT                                            
)                                            
AS                                            
BEGIN                                              
 DECLARE @DOCHANDLE   INT                                               
 DECLARE @CONFIGLISTCNI AS VARCHAR(2000)                                              
 DECLARE @CFGLSTINSERTED AS VARCHAR(2000)                                              
 EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @IV_XMLDOC                                              
 DECLARE @INSERT_LIST TABLE                                              
 (                                              
  ID_WAREHOUSE    INT,                                            
  ID_MAKE_JOB    VARCHAR(10),                                            
  ID_ITEM_CATG_JOB   VARCHAR(10),                          
  JOBI_ORDER_QTY   DECIMAL(15,2),                                            
  ID_ITEM_JOB    VARCHAR(30),                                            
  JOBI_DELIVER_QTY   DECIMAL(15,2),                                            
  JOBI_BO_QTY    DECIMAL(15,2),                                            
  JOBI_SELL_PRICE   DECIMAL(15,2),            
  JOBI_DIS_PER    VARCHAR(100), --DECIMAL,   -- Bug #4464                                         
  JOBI_VAT_PER    VARCHAR(100), --DECIMAL,   -- Bug #4464                                       
  ORDER_LINE_TEXT   VARCHAR(500) ,                                   
  JOB_SPARES_ACCOUNTCODE VARCHAR(20),                                   
  JOB_VAT_ACCCODE   VARCHAR(20),                                     
  JOB_VAT     VARCHAR(10) ,                                  
  CUST_VAT     VARCHAR(10),                                  
  VECHICLE_VAT    VARCHAR(10)                  
  ,ID_CUST_WO VARCHAR(10)                  
  ,TD_CALC BIT                  
  ,[TEXT] VARCHAR(2000)                  
  ,ITEM_DESC VARCHAR(100)                  
  ,[JOBI_COST_PRICE] DECIMAL(15,2),                
  PICKINGLIST_PREV_PRINTED BIT,        DELIVERYNOTE_PREV_PRINTED BIT,            
  PREV_PICKED DECIMAL(13,2),                  
  SPARE_TYPE VARCHAR(20),            
  FLG_FORCE_VAT BIT,            
  FLG_EDIT_SP BIT,            
  EXPORT_TYPE VARCHAR(10) ,          
  SL_NO INT,        
  SPARE_DISCOUNT INT            
 )                                              
 INSERT INTO @INSERT_LIST                                      
 SELECT                               
  ID_WAREHOUSE,                              
  ID_MAKE_JOB,                                              
  ID_ITEM_CATG_JOB,                                            
  JOBI_ORDER_QTY ,                                            
  ID_ITEM_JOB ,                                            
  JOBI_DELIVER_QTY,                                            
  JOBI_BO_QTY,                                            
  JOBI_SELL_PRICE,                                            
  JOBI_DIS_PER,            
  JOBI_VAT_PER,              
  ORDER_LINE_TEXT  ,                                    
  NULL, --SPARES ACCOUNT CODE                                  
  NULL, --VAT ACCOUNT CODE                                
  NULL, --JOB VAT                                  
  NULL, -- CUST VAT                                  
  NULL  -- VEHICLE VAT                   
  ,ID_CUST_WO                   
  ,TD_CALC                   
  ,[TEXT]                   
  ,ITEM_DESC                  
  ,[JOBI_COST_PRICE]                    
  ,PICKINGLIST_PREV_PRINTED             
  ,DELIVERYNOTE_PREV_PRINTED             
  ,PREV_PICKED                 
  ,SPARE_TYPE             
  ,FLG_FORCE_VAT             
  ,FLG_EDIT_SP            
  ,EXPORT_TYPE            
  ,Id_Sl_No        
  ,SPARE_DISCOUNT           
 FROM OPENXML (@docHandle,'root/insert',1) with                                               
 (                                
  ID_WAREHOUSE  INT,                                              
  ID_MAKE_JOB          VARCHAR(10),                                            
  ID_ITEM_CATG_JOB     VARCHAR(10),                            
  JOBI_ORDER_QTY       DECIMAL(15,2),                                            
  ID_ITEM_JOB          VARCHAR(30),                                            
  JOBI_DELIVER_QTY     DECIMAL(15,2),                                            
  JOBI_BO_QTY          DECIMAL(15,2),                                            
  JOBI_SELL_PRICE      DECIMAL(15,2),                                     
  JOBI_DIS_PER         VARCHAR(100), --DECIMAL,    -- Bug #4464                                   
  JOBI_VAT_PER         VARCHAR(100), --DECIMAL,    -- Bug #4464                                    
  ORDER_LINE_TEXT      VARCHAR(500)  ,                                   
  JOB_SPARES_ACCOUNTCODE VARCHAR(20) ,                                  
  JOB_VAT_ACCCODE   VARCHAR(20),                                     
  JOB_VAT     VARCHAR(10)  ,                                  
  CUST_VAT    VARCHAR(10),                                  
  VECHICLE_VAT   VARCHAR(10)                    
  ,ID_CUST_WO VARCHAR(10)                  
  ,TD_CALC BIT                  
  ,[TEXT] VARCHAR(2000)                  
  ,ITEM_DESC VARCHAR(100)                  
  ,[JOBI_COST_PRICE] DECIMAL(15,2)                  
  --END OF MODOFICATION                
  ,PICKINGLIST_PREV_PRINTED  BIT            
  ,DELIVERYNOTE_PREV_PRINTED BIT                
  ,PREV_PICKED DECIMAL(15,2)              
  ,SPARE_TYPE VARCHAR(20)               
  ,FLG_FORCE_VAT BIT            
  ,FLG_EDIT_SP BIT            
  ,EXPORT_TYPE VARCHAR(10)          
  ,Id_Sl_No INT        
  ,SPARE_DISCOUNT INT            
 )                                                  
 EXEC SP_XML_REMOVEDOCUMENT @docHandle              
            
 UPDATE @INSERT_LIST             
 SET SPARE_TYPE =Null            
 WHERE SPARE_TYPE =''            
            
 --------ZSL Changes related to TBl_MAS_ITEM_MASTER Composite Key 12-Dec-07---------                       
 UPDATE @INSERT_LIST                                            
 SET ID_ITEM_CATG_JOB = CATG.ID_ITEM_CATG ,                                      
 JOB_SPARES_ACCOUNTCODE = ISNULL(ACCOUNT_CODE,CATG.ACCOUNTCODE),                
--341            
 JOB_VAT =             
  CASE WHEN TEMP.SPARE_TYPE='EFD' THEN (SELECT VAT_CODE FROM TBL_MAS_ENVFEESETTINGS WHERE TBL_MAS_ENVFEESETTINGS.ID_ITEM=TEMP.ID_ITEM_JOB   AND TBL_MAS_ENVFEESETTINGS.ID_MAKE=TEMP.ID_MAKE_JOB AND TBL_MAS_ENVFEESETTINGS.ID_WAREHOUSE=TEMP.ID_WAREHOUSE)     
 
     
      
       
 ELSE            
  VATCODE         
 END            
 FROM                               
  TBL_MAS_ITEM_MASTER MAS,                                    
  @INSERT_LIST TEMP,TBL_MAS_ITEM_CATG CATG                                           
 WHERE                               
  MAS.ID_ITEM=TEMP.ID_ITEM_JOB                               
  AND MAS.SUPP_CURRENTNO=TEMP.ID_MAKE_JOB                               
  AND MAS.ID_WH_ITEM= TEMP.ID_WAREHOUSE                   
  AND CATG.ID_ITEM_CATG=MAS.ID_ITEM_CATG                    
 -------------------------------ZSL Changes End--------------------------------------                                 
            
 --Coding to check for Spares Account code and vatcode                                    
 DECLARE @ACTUALCOUNT AS INT                                    
 SET @ACTUALCOUNT = 0                      
 SELECT @ACTUALCOUNT = COUNT(*) FROM @INSERT_LIST                                    
            
 DECLARE @VATCOUNT AS INT                                    
 SET @VATCOUNT = 0                                    
 SELECT @VATCOUNT = COUNT(*) FROM @INSERT_LIST WHERE LTRIM(RTRIM(JOB_VAT))<> ''                                      
             
 DECLARE @SPARESACCOUNTCODE AS INT                                    
 SET @SPARESACCOUNTCODE = 0                                    
 SELECT @SPARESACCOUNTCODE = COUNT(*) FROM @INSERT_LIST WHERE LTRIM(RTRIM(JOB_SPARES_ACCOUNTCODE))<> ''                                      
            
 UPDATE @INSERT_LIST                         
 SET  CUST_VAT = ID_VAT_CD                         
 FROM TBL_MAS_CUST_GROUP                           
 WHERE ID_CUST_GRP_SEQ IN (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER             
 WHERE ID_CUSTOMER =ID_CUST_WO)            
            
 DECLARE @CUSTVAT AS INT                                    
 SET @CUSTVAT = 0                                    
 SELECT @CUSTVAT = COUNT(*) FROM @INSERT_LIST WHERE LTRIM(RTRIM(CUST_VAT))<> ''                                      
            
 UPDATE @INSERT_LIST                                 
 SET  VECHICLE_VAT =  ID_VAT_CD                                 
 FROM   TBL_MAS_VEHICLE                                 
 WHERE  ID_VEH_SEQ IN (SELECT ID_VEH_SEQ_WO FROM TBL_WO_HEADER WH                                
 WHERE  WH.ID_WO_NO  = @IV_ID_WO_NO AND                                  
 WH.ID_WO_PREFIX = @IV_ID_WO_PREFIX)                                
            
 DECLARE @VEHVAT AS INT                                    
 SET @VEHVAT = 0                                    
 SELECT @VEHVAT = COUNT(*) FROM @INSERT_LIST WHERE LTRIM(RTRIM(VECHICLE_VAT))<> ''                                  
 SELECT * from     @INSERT_LIST                                
            
            
 IF OBJECT_ID (N'TEMPINSERT_LIST', N'U') IS NOT NULL                                  
 DROP TABLE DBO.TEMPINSERT_LIST                                  
            
            
 SELECT * INTO TEMPINSERT_LIST FROM @INSERT_LIST                
                               
 SELECT CUST_VAT ,                                 
 CASE WHEN CUST_VAT IS NOT NULL THEN                                
  (SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = TEMPINSERT_LIST.CUST_VAT)                                
 ELSE NULL                                
 END AS 'CV',                                 
 TEMPINSERT_LIST.VECHICLE_VAT ,                                
 CASE WHEN VECHICLE_VAT IS NOT NULL THEN                                
  (SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = TEMPINSERT_LIST.VECHICLE_VAT)                
 ELSE NULL                                
 END AS 'VV',                                 
 TEMPINSERT_LIST.JOB_VAT,                                
 CASE WHEN JOB_VAT IS NOT NULL THEN                                
  (SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = TEMPINSERT_LIST.JOB_VAT)                                
 ELSE NULL                                
 END AS 'JV'                                
 FROM TEMPINSERT_LIST                                
            
            
 --382            
 DECLARE @WO_TYPE_WOH VARCHAR(20)            
 SELECT @WO_TYPE_WOH = WO_TYPE_WOH             
 FROM TBL_WO_HEADER             
 WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX             
             
 IF @WO_TYPE_WOH <> 'CRSL'            
 BEGIN            
  UPDATE TEMPINSERT_LIST                                 
  SET  JOBI_VAT_PER = VAT_PER                                  
   --,JOB_VAT_ACCCODE = VAT_ACCCODE                                  
  FROM TBL_VAT_DETAIL                                 
  WHERE VAT_CUST =TEMPINSERT_LIST.CUST_VAT                                 
  AND  ISNULL(VAT_VEH,0) = ISNULL(TEMPINSERT_LIST.VECHICLE_VAT,0)            
  AND   VAT_ITEM =TEMPINSERT_LIST.JOB_VAT                                
  AND GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                           
 END            
            
  UPDATE TEMPINSERT_LIST                                 
  SET  JOB_VAT_ACCCODE  = VAT_ACCCODE                                  
  FROM TBL_VAT_DETAIL                       
  WHERE VAT_CUST =TEMPINSERT_LIST.CUST_VAT                                 
  AND  ISNULL(VAT_VEH,0) = ISNULL(TEMPINSERT_LIST.VECHICLE_VAT,0)            
  AND   VAT_ITEM =TEMPINSERT_LIST.JOB_VAT                                
  AND GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                
            
            
 DECLARE @JOBVATPER AS INT                                    
 SET @JOBVATPER = 0                                    
 SELECT @JOBVATPER = COUNT(*) FROM TEMPINSERT_LIST WHERE LTRIM(RTRIM(JOBI_VAT_PER))<> ''                                      
            
 DECLARE @JOBACCCODE AS INT                                    
 SET @JOBACCCODE = 0                                    
 SELECT @JOBACCCODE = COUNT(*) FROM TEMPINSERT_LIST WHERE LTRIM(RTRIM(JOB_VAT_ACCCODE))<> ''                                      
            
 --------ZSL Changes related to TBl_MAS_ITEM_MASTER Composite Key 12-Dec-07---------                                             
 DECLARE @IV_ID_ITEM_CATG_JOB AS VARCHAR(10)                                            
 SELECT @IV_ID_ITEM_CATG_JOB = ID_ITEM_CATG_JOB                                 
 FROM    TBL_MAS_ITEM_MASTER MAS,                                            
 @INSERT_LIST TEMP                                            
 WHERE MAS.ID_ITEM=TEMP.ID_ITEM_JOB AND MAS.SUPP_CURRENTNO=TEMP.ID_MAKE_JOB                                          
 -------------------------------ZSL Changes End--------------------------------------                                           
            
 DECLARE @JVACC AS VARCHAR(20)                                
 DECLARE @JVAT  AS VARCHAR(10)                                
 DECLARE @JSACC AS VARCHAR(20)                                
            
 SELECT @JVACC = JOB_VAT_ACCCODE,                                    
 @JVAT  = JOB_VAT     ,                                
 @JSACC = JOB_SPARES_ACCOUNTCODE                                        
 FROM    TEMPINSERT_LIST  A                                  
--select 1            
            
  /* Update the cost price of the exchange vehicle with selling price of spare part line  */            
              
  UPDATE TBL_MAS_VEHICLE SET COST_PRICE = A.JOBI_SELL_PRICE            
  FROM TEMPINSERT_LIST A            
  WHERE A.ITEM_DESC = TBL_MAS_VEHICLE.VEH_REG_NO AND A.SPARE_TYPE='EXV'            
              
  /* Update the cost price of the exchange vehicle with selling price of spare part line  */                         
            
 INSERT INTO TBL_WO_JOB_DETAIL                                              
 (                                              
  ID_WAREHOUSE,                                     
  ID_WODET_SEQ_JOB,                         
  ID_MAKE_JOB,                                            
  ID_ITEM_CATG_JOB,                                            
  ID_ITEM_JOB,                                            
  JOBI_ORDER_QTY,                                            
  JOBI_DELIVER_QTY,                                            
  JOBI_BO_QTY,                                            
  JOBI_SELL_PRICE,                                            
  JOBI_DIS_PER,                                            
  JOBI_VAT_PER,            
  ORDER_LINE_TEXT,                                            
  CREATED_BY,                                            
  DT_CREATED,                                            
  ID_WO_NO,                                  
  ID_WO_PREFIX  ,                                    
  JOB_VAT_ACCCODE,                                    
  JOB_VAT  ,                                
  JOB_SPARES_ACCOUNTCODE                    
  ,ID_CUST_WO                  
  ,TD_CALC                  
  ,[TEXT]                  
  ,ITEM_DESC                  
  ,[JOBI_COST_PRICE]                    
  ,PICKINGLIST_PREV_PRINTED             
  ,DELIVERYNOTE_PREV_PRINTED,            
  PICKINGLIST_PREV_PICKED            
  ,SPARE_TYPE            
  ,FLG_FORCE_VAT             
  ,FLG_EDIT_SP            
  ,EXPORT_TYPE            
  ,SL_NO        
  ,SPARE_DISCOUNT                                    
 )                                              
 SELECT                               
  A.ID_WAREHOUSE,                              
  @IV_ID_WODET_SEQ_JOB,                                               
  CASE WHEN [TEXT] <> '' THEN NULL ELSE A.ID_MAKE_JOB END,                                           
  CASE WHEN [TEXT] <> '' THEN NULL ELSE ID_ITEM_CATG_JOB END,                                             
  CASE WHEN A.ID_ITEM_JOB = '' THEN NULL ELSE A.ID_ITEM_JOB END,                                             
  A.JOBI_ORDER_QTY,           
  A.JOBI_DELIVER_QTY,                                            
  A.JOBI_BO_QTY,                                            
  A.JOBI_SELL_PRICE,                                            
  A.JOBI_DIS_PER,                                            
  CASE WHEN A.ID_ITEM_JOB = '' THEN '0' ELSE A.JOBI_VAT_PER END,                                               
  A.ORDER_LINE_TEXT ,                                        
  @IV_CREATED_BY,                                            
  GETDATE(),                                            
  @IV_ID_WO_NO,                                            
  @IV_ID_WO_PREFIX,                                    
  JOB_VAT_ACCCODE,                                    
  JOB_VAT     ,                                
  JOB_SPARES_ACCOUNTCODE                  
  ,ID_CUST_WO                  
  ,TD_CALC                  
  ,[TEXT]                  
  ,ITEM_DESC                  
  ,[JOBI_COST_PRICE]               
  ,PICKINGLIST_PREV_PRINTED             
  ,DELIVERYNOTE_PREV_PRINTED             
  ,PREV_PICKED            
  ,SPARE_TYPE            
  ,FLG_FORCE_VAT               
  ,FLG_EDIT_SP            
  ,EXPORT_TYPE            
  ,SL_NO        
  ,SPARE_DISCOUNT           
  FROM  TEMPINSERT_LIST  A                     
              
                                 
 IF @@ROWCOUNT > 0                                
 BEGIN                            
  CREATE TABLE #TEMP_ITEM_AVAIL_QTY                  
  (                  
  TEMP_DELIVER_QTY DECIMAL(15,2)                  
  ,TEMP_ITEM VARCHAR(30)                  
  ,TEMP_MAKE VARCHAR(10)                   
  ,TEMP_WAREHOUSE INT             
  ,TEMP_SPARE_TYPE VARCHAR(10)                
  )                  
            
  INSERT INTO #TEMP_ITEM_AVAIL_QTY                  
  SELECT                  
  SUM(TEMPINSERT_LIST.JOBI_DELIVER_QTY)                  
  ,TEMPINSERT_LIST.ID_ITEM_JOB                   
  ,TEMPINSERT_LIST.ID_MAKE_JOB                   
  ,TEMPINSERT_LIST.ID_WAREHOUSE             
  ,TEMPINSERT_LIST.SPARE_TYPE                
  FROM                  
  TEMPINSERT_LIST                  
  GROUP BY                  
  TEMPINSERT_LIST.ID_ITEM_JOB                   
  ,TEMPINSERT_LIST.ID_MAKE_JOB                   
  ,TEMPINSERT_LIST.ID_WAREHOUSE             
  ,TEMPINSERT_LIST.SPARE_TYPE            
            
            
            
   DECLARE @USE_MANUAL_RWRK AS BIT             
         DECLARE @SUBID AS INT            
         DECLARE @DEPTID AS INT            
         SELECT @SUBID = ID_SUBSIDERY_USER,@DEPTID=ID_DEPT_USER FROM  TBL_MAS_USERS                                      
      WHERE ID_LOGIN = @IV_CREATED_BY              
   SELECT @USE_MANUAL_RWRK = USE_MANUAL_RWRK             
   FROM             
   TBL_MAS_WO_CONFIGURATION            
   WHERE             
   ID_SUBSIDERY_WO = @SUBID AND             
   ID_DEPT_WO  = @DEPTID  AND            
   DT_EFF_TO > getdate()            
                 
  IF @USE_MANUAL_RWRK = 0            
     BEGIN              
          DECLARE @STA AS VARCHAR(10)            
                 
    SELECT @STA = JOB_STATUS FROM TBL_WO_DETAIL             
    WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX             
    and ID_WODET_SEQ =@IV_ID_WODET_SEQ_JOB              
               
      SELECT @STA            
      IF @STA = 'CSA'  OR @STA = 'RWRK'            
              
                          
       BEGIN            
                   
    DECLARE @STOCKITEM AS INT            
    DECLARE @TOTALCNT AS INT            
    DECLARE @BOJQTY AS INT             
    DECLARE @RSTATUSCOUNT INT, @WOJOBCOUNT INT            
                 
            
     SELECT @TOTALCNT = COUNT(WOJ.ID_WODET_SEQ_JOB) FROM TBL_MAS_ITEM_MASTER MSTR            
     INNER JOIN TBL_WO_JOB_DETAIL WOJ             
     ON MSTR.ID_ITEM = WOJ.ID_ITEM_JOB             
     AND MSTR.ID_ITEM_CATG = WOJ.ID_ITEM_CATG_JOB            
     WHERE  WOJ.ID_WO_NO = @IV_ID_WO_NO AND WOJ.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WOJ.ID_WODET_SEQ_JOB=@IV_ID_WODET_SEQ_JOB            
             
             
    SELECT @STOCKITEM =COUNT(FLG_STOCKITEM) FROM TBL_MAS_ITEM_MASTER MSTR            
    INNER JOIN TBL_WO_JOB_DETAIL WOJ             
    ON MSTR.ID_ITEM = WOJ.ID_ITEM_JOB             
    AND MSTR.ID_ITEM_CATG = WOJ.ID_ITEM_CATG_JOB            
    WHERE  WOJ.ID_WO_NO = @IV_ID_WO_NO AND WOJ.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WOJ.ID_WODET_SEQ_JOB=@IV_ID_WODET_SEQ_JOB AND MSTR.FLG_STOCKITEM = 1            
                   
                          
                         
     SELECT @BOJQTY= SUM(JOBI_BO_QTY)                 
     FROM TBL_WO_JOB_DETAIL JOB WHERE ID_WO_NO = @IV_ID_WO_NO                   
      AND ID_WO_PREFIX = @IV_ID_WO_PREFIX             
      AND ID_WODET_SEQ_JOB = @IV_ID_WODET_SEQ_JOB               
      GROUP BY ID_WODET_SEQ_JOB            
             
                       
    SET @BOJQTY =ISNULL(@BOJQTY,0)            
               
                
                
      IF @TOTALCNT = @STOCKITEM             
      BEGIN            
     --select '@@BOJQTY1',@BOJQTY,@IV_WODET_SEQ_JOB            
         IF @BOJQTY = 0            
           BEGIN            
      IF ISNULL(@IV_ID_WODET_SEQ_JOB,0) = 0            
      BEGIN            
       UPDATE TBL_WO_DETAIL            
       SET JOB_STATUS = 'RWRK'            
       WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX            
      END            
      ELSE            
      BEGIN            
       UPDATE TBL_WO_DETAIL            
       SET JOB_STATUS = 'RWRK'            
       WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ_JOB            
      END            
                         
           END            
          ELSE            
     BEGIN            
      UPDATE TBL_WO_DETAIL            
      SET JOB_STATUS = 'CSA'            
      WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ_JOB            
     END            
                   
       END            
       ELSE            
     BEGIN            
      UPDATE TBL_WO_DETAIL            
      SET JOB_STATUS = 'CSA'            
      WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ_JOB            
     END            
                   
                     
   SELECT @WOJOBCOUNT = COUNT(*) FROM TBL_WO_DETAIL              
   WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX            
             
   SELECT @RSTATUSCOUNT = COUNT(*) FROM TBL_WO_DETAIL              
   WHERE  ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND JOB_STATUS = 'RWRK'             
                     
                     
             UPDATE                           
    TBL_WO_HEADER                            
    SET                    
    WO_STATUS  = CASE WHEN (@RSTATUSCOUNT = @WOJOBCOUNT ) THEN 'RWRK' ELSE 'CSA'   END                      
    WHERE                     
    ID_WO_NO = @IV_ID_WO_NO                           
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX            
   END            
               
   END                   
            
            
 /*For Bargain Order Fix*/            
 DECLARE @WO_TYPE VARCHAR(20)            
 SELECT @WO_TYPE = WO_TYPE_WOH             
 FROM TBL_WO_HEADER             
 WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX             
            
  UPDATE TBL_MAS_ITEM_MASTER                      
  SET                   
   ITEM_AVAIL_QTY = CASE WHEN ISNULL(TBL_MAS_ITEM_MASTER.FLG_STOCKITEM_STATUS,1) =1 THEN            
        CASE WHEN #TEMP_ITEM_AVAIL_QTY.TEMP_SPARE_TYPE <> 'EFD' THEN            
        CASE WHEN #TEMP_ITEM_AVAIL_QTY.TEMP_DELIVER_QTY > 0 THEN             
        CASE WHEN (@WO_TYPE <> 'BAR' AND @WO_TYPE <> 'KRE') THEN            
         CASE WHEN (ITEM_AVAIL_QTY - #TEMP_ITEM_AVAIL_QTY.TEMP_DELIVER_QTY) > 0 THEN                   
          (ITEM_AVAIL_QTY - #TEMP_ITEM_AVAIL_QTY.TEMP_DELIVER_QTY)                   
         ELSE 0 END             
        ELSE ITEM_AVAIL_QTY END             
       ELSE ITEM_AVAIL_QTY END            
       ELSE ITEM_AVAIL_QTY END            
       ELSE ITEM_AVAIL_QTY END             
  FROM                   
   #TEMP_ITEM_AVAIL_QTY                             
  WHERE                   
   TBL_MAS_ITEM_MASTER.ID_ITEM COLLATE database_default= #TEMP_ITEM_AVAIL_QTY.TEMP_ITEM COLLATE database_default                           
   AND TBL_MAS_ITEM_MASTER.SUPP_CURRENTNO COLLATE database_default = #TEMP_ITEM_AVAIL_QTY.TEMP_MAKE COLLATE database_default                           
   AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM = #TEMP_ITEM_AVAIL_QTY.TEMP_WAREHOUSE            
            
  DROP TABLE #TEMP_ITEM_AVAIL_QTY                  
 END                        
 --ADDED END                            
             
             
/***********************************CREATE ORDER - TEMP TABLE************/            
DECLARE @sparelist TABLE                                              
 (               
                 
     ROWNUM   INT,                                       
  ID_WAREHOUSE    INT,                                            
  ID_MAKE_JOB    VARCHAR(10),                                            
  ID_ITEM_CATG_JOB   VARCHAR(10),                          
  JOBI_ORDER_QTY   DECIMAL(15,2),                                            
  ID_ITEM_JOB    VARCHAR(30),                                            
  JOBI_DELIVER_QTY   DECIMAL(15,2),                                            
  JOBI_BO_QTY    DECIMAL(15,2),                                            
  JOBI_SELL_PRICE   DECIMAL(15,2),            
  JOBI_DIS_PER    VARCHAR(100), --DECIMAL,   -- Bug #4464                                         
  JOBI_VAT_PER    VARCHAR(100), --DECIMAL,   -- Bug #4464                                       
  ORDER_LINE_TEXT   VARCHAR(500) ,                                   
  JOB_SPARES_ACCOUNTCODE VARCHAR(20),                                   
  JOB_VAT_ACCCODE   VARCHAR(20),                                  
  JOB_VAT     VARCHAR(10) ,                                  
  CUST_VAT     VARCHAR(10),                                  
  VECHICLE_VAT    VARCHAR(10)                  
  ,ID_CUST_WO VARCHAR(10)                  
  ,TD_CALC BIT                  
  ,[TEXT] VARCHAR(2000)                  
  ,ITEM_DESC VARCHAR(100)                  
  ,[JOBI_COST_PRICE] DECIMAL(15,2),                
  PICKINGLIST_PREV_PRINTED BIT,            
  DELIVERYNOTE_PREV_PRINTED BIT,            
  PREV_PICKED DECIMAL(13,2),            
  SPARE_TYPE VARCHAR(20),            
  FLG_FORCE_VAT BIT            
  ,FLG_EDIT_SP BIT            
  ,EXPORT_TYPE VARCHAR(10)            
 )                 
            
INSERT into @sparelist              
SELECT  ROW_NUMBER() OVER(ORDER BY ID_ITEM_JOB) AS 'ROWNUM',            
  ID_WAREHOUSE,                              
  ID_MAKE_JOB,                                              
  ID_ITEM_CATG_JOB,                                            
  JOBI_ORDER_QTY ,                                            
  ID_ITEM_JOB ,                                            
  JOBI_DELIVER_QTY,                                            
  JOBI_BO_QTY,                                            
  JOBI_SELL_PRICE,                                            
  JOBI_DIS_PER,            
  JOBI_VAT_PER,              
  ORDER_LINE_TEXT  ,                                    
  NULL, --SPARES ACCOUNT CODE                                  
  NULL, --VAT ACCOUNT CODE                                
  NULL, --JOB VAT                                  
  NULL, -- CUST VAT                                  
  NULL  -- VEHICLE VAT                   
  ,ID_CUST_WO                   
  ,TD_CALC                   
  ,[TEXT]                   
  ,ITEM_DESC                  
  ,[JOBI_COST_PRICE]                    
  ,PICKINGLIST_PREV_PRINTED             
  ,DELIVERYNOTE_PREV_PRINTED             
  ,PREV_PICKED,            
  SPARE_TYPE,            
  FLG_FORCE_VAT,            
  FLG_EDIT_SP,            
  EXPORT_TYPE               
                
  FROM TEMPINSERT_LIST WHERE ITEM_DESC IS NOT NULL AND ISNULL(SPARE_TYPE,'') = 'EXV' /**TO MODIFY**/            
/***********************************CREATE ORDER - TEMP TABLE************/            
            
            
 IF OBJECT_ID (N'TEMPINSERT_LIST', N'U') IS NOT NULL                                  
  DROP TABLE DBO.TEMPINSERT_LIST                      
              
/************CREATE ORDER -START*******************/             
            
DECLARE @ROWS INT            
SET @ROWS=1            
DECLARE @TOTROWS INT            
SET @TOTROWS=0            
            
             
SELECT @TOTROWS=COUNT(*) FROM @sparelist            
            
--SELECT @ROWS 'ROWS',@TOTROWS 'TOTROWS'            
--SELECT 'TEMPINSERT_LIST',* FROM TEMPINSERT_LIST              
--select '@sparelist' 'sparelist1',* from @sparelist             
IF @TOTROWS<>0            
BEGIN  ----BEGIN IF            
WHILE @ROWS<=@TOTROWS            
BEGIN -----BEGIN WHILE            
            
            
            
--select '@sparelist2' 'sparelist2',* from @sparelist WHERE ROWNUM=@ROWS            
            
--SELECT @ROWS,@TOTROWS            
            
            
            
/*****ORDER HEAD*****/            
            
/*VARIABLES FOR PROCEDURE*/            
DECLARE @va_created_by VARCHAR(50)            
DECLARE @va_cust_country VARCHAR(50)            
DECLARE @va_cust_group VARCHAR(50)            
DECLARE @va_cust_name VARCHAR(50)            
DECLARE @va_cust_perm_add1 VARCHAR(50)            
DECLARE @va_cust_perm_add2 VARCHAR(50)            
DECLARE @va_cust_phone_home VARCHAR(50)            
DECLARE @va_cust_phone_mobile VARCHAR(50)            
DECLARE @va_cust_phone_off VARCHAR(50)            
DECLARE @va_cust_state VARCHAR(50)            
DECLARE @va_cust_wo VARCHAR(50)            
DECLARE @va_dept_acc_num VARCHAR(50)            
DECLARE @va_payterms VARCHAR(50)            
DECLARE @va_paytype VARCHAR(50)            
DECLARE @va_veh_hrs VARCHAR(50)            
DECLARE @va_veh_intern_num VARCHAR(50)            
DECLARE @va_veh_make VARCHAR(50)            
DECLARE @va_veh_mileage VARCHAR(50)            
DECLARE @va_veh_model VARCHAR(50)            
DECLARE @va_veh_reg_no VARCHAR(50)            
DECLARE @va_veh_seq VARCHAR(50)            
DECLARE @va_veh_vin VARCHAR(50)            
DECLARE @va_zipcode_wo VARCHAR(50)            
DECLARE @va_veh_model_map INT            
            
/*FOR ORDER DETAILS*/            
DECLARE @NEW_WO_PREFIX VARCHAR(20)            
DECLARE @NEW_WO_NUMBER VARCHAR(20)            
DECLARE @ID_REP_CODE VARCHAR(20)            
DECLARE @ID_WO_CODE VARCHAR(20)            
--DECLARE @ID_CUST VARCHAR(20) /*@va_cust_wo CAN BE USED*/            
DECLARE @WO_GM_VAT_PER DECIMAL(15,2)            
DECLARE @WO_LAB_VAT_PER DECIMAL(15,2)            
DECLARE @PREV_SALESMAN VARCHAR(100)            
DECLARE @FLG_VATFREE BIT            
DECLARE @WO_COST DECIMAL(15,2)            
DECLARE @ID_SUBREPCODE_WO VARCHAR(20)            
/***FOR ORDER DETAILS***/            
            
DECLARE @VA_COST_PRICE DECIMAL(13,2)            
DECLARE @VA_SELL_PRICE DECIMAL(13,2)            
            
            
            
SELECT @va_cust_wo=ID_CUST_WO,            
@va_cust_group=WO_CUST_GROUPID,            
@va_cust_name=WO_CUST_NAME,            
@va_cust_perm_add1=WO_CUST_PERM_ADD1,            
@va_cust_perm_add2=WO_CUST_PERM_ADD2,            
@va_cust_phone_home=WO_CUST_PHONE_MOBILE,            
@va_cust_phone_mobile=WO_CUST_PHONE_HOME,            
@va_cust_phone_off=WO_CUST_PHONE_OFF,            
@va_dept_acc_num=LA_DEPT_ACCOUNT_NO,            
@va_payterms=ID_PAY_TERMS_WO,            
@va_paytype=ID_PAY_TYPE_WO,            
@va_zipcode_wo=ID_ZIPCODE_WO            
 FROM TBL_WO_HEADER WHERE ID_WO_NO=@IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX            
             
          /*ROW 382c*/              
   DECLARE @USE_DEF_CUST AS BIT            
   DECLARE @CONFIG_ID_CUSTOMER AS VARCHAR(10)            
   DECLARE @USE_DELV_ADD AS BIT            
   SELECT @USE_DEF_CUST = USE_DEF_CUST ,@CONFIG_ID_CUSTOMER =ID_CUSTOMER, @USE_DELV_ADD = USE_DELV_ADDRESS            
   FROM             
   TBL_MAS_WO_CONFIGURATION            
   WHERE             
   ID_SUBSIDERY_WO = @SUBID AND             
   ID_DEPT_WO  = @DEPTID  AND            
   DT_EFF_TO > getdate()             
               
   IF @USE_DEF_CUST = 1            
   BEGIN            
               
   SELECT @va_cust_wo=WCF.ID_CUSTOMER,            
   @va_cust_group=ID_CUST_GROUP,            
   @va_cust_name=CUST_NAME,            
   @va_cust_perm_add1=CUST_PERM_ADD1,            
   @va_cust_perm_add2=CUST_PERM_ADD2,            
   @va_cust_phone_home=CUST_PHONE_MOBILE,            
   @va_cust_phone_mobile=CUST_PHONE_HOME,            
   @va_cust_phone_off=CUST_PHONE_OFF,            
   --@va_dept_acc_num=LA_DEPT_ACCOUNT_NO,            
   @va_payterms=ID_CUST_PAY_TERM,            
   @va_paytype=ID_CUST_PAY_TYPE,            
   @va_zipcode_wo = CASE WHEN @USE_DELV_ADD = 1 THEN MC.ID_CUST_BILL_ZIPCODE   ELSE MC.ID_CUST_PERM_ZIPCODE    END              
   FROM TBL_MAS_CUSTOMER MC            
   INNER JOIN TBL_MAS_CUST_GROUP CG            
   ON MC.ID_CUST_GROUP = CG.ID_CUST_GRP_SEQ            
   INNER JOIN TBL_MAS_WO_CONFIGURATION WCF            
   ON WCF.ID_CUSTOMER = MC.ID_CUSTOMER            
   WHERE MC.ID_CUSTOMER = @CONFIG_ID_CUSTOMER            
                
   END            
             
select @va_veh_reg_no=ITEM_DESC,@WO_COST=JOBI_SELL_PRICE from @sparelist WHERE ROWNUM=@ROWS  /**TO MODIFY**/            
             
SELECT TOP 1 @va_veh_seq=ID_VEH_SEQ,            
@va_veh_hrs=VEH_HRS,            
@va_veh_intern_num=VEH_INTERN_NO,            
@va_veh_mileage=VEH_MILEAGE,            
@va_veh_reg_no=VEH_REG_NO,            
@va_veh_vin=VEH_VIN,            
@va_veh_model=ID_MODEL_VEH,            
@va_veh_make=ID_MAKE_VEH,            
@VA_COST_PRICE = COST_PRICE,            
@VA_SELL_PRICE = SELL_PRICE            
FROM TBL_MAS_VEHICLE WHERE VEH_REG_NO=@va_veh_reg_no            
            
--SELECT @va_veh_reg_no,@WO_COST,@va_veh_seq,            
--@va_veh_hrs,            
--@va_veh_intern_num,            
--@va_veh_mileage,            
--@va_veh_reg_no,            
--@va_veh_vin,            
--@va_veh_model,            
--@va_veh_make            
---select 999            
            
SELECT @va_veh_model_map=ID_MG_SEQ FROM TBL_MAS_MODELGROUP_MAKE_MAP WHERE MG_ID_MODEL_GRP=@va_veh_model AND MG_ID_MAKE=@va_veh_make            
            
            
 DECLARE @LAST_VA_ORDER VARCHAR(20)            
 SELECT TOP 1 @LAST_VA_ORDER = ID_WO_PREFIX+ID_WO_NO FROM TBL_WO_HEADER WHERE WO_TYPE_WOH ='CRSL'             
 AND ID_VEH_SEQ_WO = @va_veh_seq order by DT_CREATED desc            
            
--SELECT @va_cust_group,            
--@va_cust_name,            
--@va_cust_perm_add1,            
--@va_cust_perm_add2,            
--@va_cust_phone_home,            
--@va_cust_phone_mobile,            
--@va_cust_phone_off,            
--@va_cust_state,            
--@va_cust_wo,            
--@va_dept_acc_num,            
--@va_payterms,            
--@va_paytype,            
--@va_veh_hrs,            
--@va_veh_intern_num,            
--@va_veh_make,            
--@va_veh_mileage,            
--@va_veh_model,      
--@va_veh_reg_no,            
--@va_veh_seq,            
--@va_veh_vin,            
--@va_zipcode_wo            
            
DECLARE @DATE_CR DATETIME            
SET @DATE_CR=CONVERT(VARCHAR(30),getdate(),121)            
            
exec usp_WO_HEADER_INSERT             
@iv_CREATED_BY=@IV_CREATED_BY,     /*CURRENT CREATED BY*/            
@id_DT_DELIVERY=NULL,     /*--NULL*/            
@id_DT_FINISH=NULL,      /*--NULL */               
@id_DT_ORDER=@DATE_CR,   /*--GETDATE()*/            
@iv_ID_CUST_WO=@va_cust_wo,     /*FROM ORDER*/            
@iv_CUST_GROUP_ID=@va_cust_group,     /*FROM ORDER*/            
@iv_ID_PAY_TERMS_WO=@va_payterms,    /*FROM ORDER*/            
@iv_ID_PAY_TYPE_WO=@va_paytype,    /*FROM ORDER*/            
@iv_ID_VEH_SEQ_WO=@va_veh_seq,     /*FROM SPARE DESC*/            
@iv_ID_WO_NO='',      /*--EMPTY*/            
@ii_ID_ZIPCODE_WO=@va_zipcode_wo,    /*FROM ORDER*/            
@iv_WO_ANNOT='',      /*--EMPTY*/            
@iv_WO_CUST_NAME=@va_cust_name, /*FROM ORDER*/            
@iv_WO_CUST_PERM_ADD1=@va_cust_perm_add1,    /*FROM ORDER*/            
@iv_WO_CUST_PERM_ADD2=@va_cust_perm_add2,    /*FROM ORDER*/            
@iv_WO_CUST_PHONE_HOME=@va_cust_phone_home,  /*FROM ORDER*/            
@iv_WO_CUST_PHONE_MOBILE=@va_cust_phone_mobile, /*FROM ORDER*/            
@iv_WO_CUST_PHONE_OFF=@va_cust_phone_off,   /*FROM ORDER*/            
@iv_WO_STATUS='STR',     /*--STORAGE*/            
@iv_WO_TM_DELIV='',      /*--EMPTY*/            
@iv_WO_TYPE_WOH='CRSL',     /*--CAR SALE*/            
@id_WO_VEH_HRS=@va_veh_hrs,      /*FROM SPARE DESC*/            
@id_WO_VEH_INTERN_NO=@va_veh_intern_num,    /*FROM SPARE DESC*/            
@id_WO_VEH_MILEAGE=@va_veh_mileage,     /*FROM SPARE DESC*/            
@iv_WO_VEH_REG_NO=@va_veh_reg_no,   /*FROM SPARE DESC*/            
@iv_WO_VEH_VIN=@va_veh_vin,  /*FROM SPARE DESC*/            
@ii_WO_VEH_Model=@va_veh_model_map,      /*FROM SPARE DESC*/            
@iv_WO_VEH_Make=@va_veh_make,     /*FROM SPARE DESC*/            
@IV_CUSTPSTATE='',     /*--EMPTY*/            
@IV_CUSTPCOUNTRY='',     /*--EMPTY*/            
@0V_RETVALUE='INSFLAG',     /*--INSFLAG*/            
@0V_RETWONO='',  /*--COMPOSE?*/            
@IV_PKKDate=NULL,      /*--NULL*/            
@BUS_PEK_PREVIOUS_NUM='',    /*--EMPTY*/            
@BUS_PEK_CONTROL_NUM='',    /*--EMPTY*/            
@UPDATE_VEH_FLAG=0,      /*--0*/            
@FLG_CONFIGZIPCODE=1,     /*--1*/            
@IV_DEPT_ACCNT_NUM=@va_dept_acc_num ,    /*FROM ORDER*/            
@VA_COST_PRICE = @VA_COST_PRICE ,            
@VA_SELL_PRICE = @VA_SELL_PRICE,            
@VA_NUMBER = @LAST_VA_ORDER,            
@REGN_DATE =null,            
@VEH_TYPE = null,            
@VEH_GRP_DESC =null,            
@FLG_UPD_MILEAGE = 0,            
@IV_INT_NOTE = NULL            
            
            
/*****ORDER HEAD*****/            
            
            
/*****ORDER DETAILS*****/            
            
DECLARE @va_xmlwoDoc NVARCHAR(4000)            
set @va_xmlwoDoc = '<root>'+'<insert ID_DETAIL="'+ISNULL(@va_cust_wo,'')+'" DEBITOR_TYPE="C" DBT_AMT="0" DBT_PER="100"  PWO_VAT_PERCENTAGE="1" PWO_GM_PER="1" PWO_GM_VATPER="1" PWO_LBR_VATPER="1" PWO_SPR_DISCPER="1" PWO_FIXED_VATPER="1" ORG_PER="100"/></r
  
    
      
        
          
oot>'            
            
SELECT @ID_REP_CODE=ID_REP_CODE_WO,            
@ID_WO_CODE=ID_WORK_CODE_WO,            
@WO_GM_VAT_PER=WO_LBR_VATPER,            
@WO_LAB_VAT_PER=WO_GM_VATPER,            
@PREV_SALESMAN=SALESMAN,            
@FLG_VATFREE=FLG_VAT_FREE,            
@ID_SUBREPCODE_WO=ID_SUB_REP_CODE            
FROM TBL_WO_DETAIL WHERE ID_WO_NO=@IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX            
            
            
SELECT TOP 1 @NEW_WO_PREFIX=ID_WO_PREFIX,@NEW_WO_NUMBER=ID_WO_NO  FROM TBL_WO_HEADER             
 WHERE ID_CUST_WO=@va_cust_wo AND ID_VEH_SEQ_WO=@va_veh_seq AND WO_TYPE_WOH='CRSL' ORDER BY DT_CREATED DESC            
/*ROW-382c            
exec USP_WO_INSERT             
@iv_xmljobDoc=N'<root></root>',            
@iv_xmlwoDoc=@va_xmlwoDoc,            
--'<root>'+'<insert ID_DETAIL="'+ISNULL(@va_cust_wo,'0')+'" DEBITOR_TYPE="C" DBT_AMT="0" DBT_PER="100" PWO_VAT_PERCENTAGE="1" PWO_GM_PER="1" PWO_GM_VATPER="1" PWO_LBR_VATPER="1" PWO_SPR_DISCPER="1" PWO_FIXED_VATPER="1" ORG_PER="100"/></root>',            
@iv_ID_WODET_SEQ=1,            
@iv_ID_WO_NO=@NEW_WO_NUMBER,            
@iv_ID_WO_PREFIX=@NEW_WO_PREFIX,            
@iv_ID_RPG_CATG_WO=NULL,            
@iv_ID_RPG_CODE_WO=NULL,            
@iv_ID_REP_CODE_WO=@ID_REP_CODE,            
@iv_ID_WORK_CODE_WO=@ID_WO_CODE,            
@iv_WO_FIXED_PRICE=0,            
@iv_ID_JOBPCD_WO='0',            
@iv_WO_PLANNED_TIME='0',            
@iv_WO_HOURLEY_PRICE=0,            
@iv_WO_CLK_TIME='',            
@iv_WO_CHRG_TIME='1',            
@iv_FLG_CHRG_STD_TIME=1,            
@iv_WO_STD_TIME='01:00',            
@iv_FLG_STAT_REQ=0,            
@iv_WO_JOB_TXT='',            
@iv_WO_OWN_RISK_AMT=0,            
@iv_WO_TOT_LAB_AMT=0,            
@iv_WO_TOT_SPARE_AMT=0,            
@iv_WO_TOT_GM_AMT=0,            
@iv_WO_TOT_VAT_AMT=0,            
@iv_WO_TOT_DISC_AMT=0,            
@iv_JOB_STATUS='CON',            
@iv_CREATED_BY='VA_EXV_AUTOCREATE',            
--@IV_CREATED_BY,            
@iv_DT_CREATED=@DATE_CR,            
@OV_RETVALUE=NULL,            
@iv_ID_JOB=1,            
@ib_WO_OWN_PAY_VAT=0,            
@id_WO_DT_PLANNED=NULL,            
@iv_XMLDISDOC=N'<root></root>',            
@II_ID_DEF_SEQ=0,            
@iv_TOTALAMT=0,            
@iv_XMLMECHDOC=NULL,            
@ii_ID_MECH_COMP='0',            
@iv_WO_OWN_RISK_CUST=@va_cust_wo,            
@iv_WO_OWN_CR_CUST=NULL,            
@ii_ID_SER_CALLNO=0,            
@II_WO_GM_PER=0,            
@II_WO_GM_VATPER=@WO_GM_VAT_PER,            
@II_WO_LBR_VATPER=@WO_LAB_VAT_PER,            
@BUS_PEK_CONTROL_NUM='',            
@IV_PKKDATE=NULL,            
@WO_INCL_VAT=0,            
@WO_DISCOUNT=0,            
@ID_SUBREP_CODE_WO=0,            
@WO_OWNRISKVAT=0,            
@IV_FLG_SPRSTS=0,            
@SALESMAN=@PREV_SALESMAN,            
@FLG_VAT_FREE=@FLG_VATFREE,            
@COST_PRICE=@WO_COST,            
@WO_FINAL_TOTAL=0,            
@WO_FINAL_VAT=0,            
@WO_FINAL_DISCOUNT=0,            
@ID_JOB=1            
*/            
            
/*****ORDER DETAILS*****/            
            
SET @ROWS=@ROWS+1            
END  -----END WHILE            
END     -----END IF            
/************CREATE ORDER -  END*******************/             
              
                              
 IF @@ERROR <> 0                                         
  SET @OV_RETVALUE = @@ERROR                                            
 ELSE                                            
  SET @OV_RETVALUE = '0'                                                  
                               
END 
GO

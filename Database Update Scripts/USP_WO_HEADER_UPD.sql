/****** Object:  StoredProcedure [dbo].[USP_WO_HEADER_UPD]    Script Date: 6/15/2017 12:32:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_HEADER_UPD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_HEADER_UPD]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_HEADER_UPD]    Script Date: 6/15/2017 12:32:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_HEADER_UPD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_HEADER_UPD] AS' 
END
GO
    
/*************************************** Application: MSG *************************************************************          
* Module : Work Order         
* File name : usp_WO_HEADER_UPD.PRC        
* Purpose :         
* Author : M.Thiyagarajan         
* Date  : 27.10.2006        
*********************************************************************************************************************/          
/*********************************************************************************************************************            
I/P : -- Input Parameters          
O/P : -- Output Parameters          
Error Code          
Description          
INT.VerNO : NOV21.0          
********************************************************************************************************************/          
--'*********************************************************************************'*********************************          
--'* Modified History :             
--'* S.No  RFC No/Bug ID   Date        Author  Description           
--*#0001#           
-- Bug ID:- MSG_Issues_Analysis_01Apr09_ZSL07Apr09 53 Desc:- Vehicle Mileage,Hours should update only when changed    
--   Date  :- 08-Apr-2009    
--bUG id:-5061,date :- 25-July-2009    
--'*********************************************************************************'*********************************          
        
ALTER PROCEDURE [dbo].[USP_WO_HEADER_UPD]             
(            
  @IV_MODIFIED_BY   VARCHAR(20) ,            
  @ID_DT_DELIVERY   VARCHAR(30) ,            
  @ID_DT_FINISH    VARCHAR(30) ,            
  @ID_DT_ORDER    VARCHAR(30) ,            
  @IV_ID_CUST_WO   VARCHAR(10) ,            
  @IV_CUST_GROUP_ID   VARCHAR(10) ,            
  @IV_ID_PAY_TERMS_WO       VARCHAR(10) ,            
  @IV_ID_PAY_TYPE_WO        VARCHAR(10) ,            
  @IV_ID_VEH_SEQ_WO   INT   ,            
  @IV_ID_WO_NO    VARCHAR(10) ,            
  @II_ID_ZIPCODE_WO         VARCHAR(10)   ,            
  @IV_WO_ANNOT    VARCHAR(200),            
  @IV_WO_CUST_NAME   VARCHAR(100) ,            
  @IV_WO_CUST_PERM_ADD1     VARCHAR(50) ,            
  @IV_WO_CUST_PERM_ADD2     VARCHAR(50) ,            
  @IV_WO_CUST_PHONE_HOME    VARCHAR(20) ,            
  @IV_WO_CUST_PHONE_MOBILE  VARCHAR(20) ,            
  @IV_WO_CUST_PHONE_OFF     VARCHAR(20) ,            
  @IV_WO_STATUS    VARCHAR(20) ,            
  @IV_WO_TM_DELIV   VARCHAR(10) ,            
  @IV_WO_TYPE_WOH   VARCHAR(20) ,            
  @ID_WO_VEH_HRS   DECIMAL(9,2)  ,            
  @ID_WO_VEH_INTERN_NO      VARCHAR(15) ,            
  @ID_WO_VEH_MILEAGE        INT   ,            
  @IV_WO_VEH_REG_NO   VARCHAR(15) ,            
  @IV_WO_VEH_VIN   VARCHAR(20) ,            
  @II_WO_VEH_MODEL   VARCHAR(10) ,            
  @IV_WO_VEH_MAKE   VARCHAR(10) ,            
  @IV_CUSTPCOUNTRY   VARCHAR(50) ,            
  @IV_CUSTPSTATE   VARCHAR(50) ,            
  @0V_RETVALUE    VARCHAR(10)   OUTPUT,            
  @IV_ID_WO_PREFIX          VARCHAR(3),    
--BUG ID:-IF PKK Button Active,     
--then insert mvr date or general rule date    
--date :- 10-Sept-2008    
 @IV_PKKDate       VARCHAR(50),        
--change end                
-- MODIFIED DATE: 11 SEP 2008    
-- COMMENTS: BUSPEK - CONTROL NO    
 @BUS_PEK_PREVIOUS_NUM VARCHAR(10) = NULL,    
 @BUS_PEK_CONTROL_NUM VARCHAR(20),    
-- END OF MODIFICATION    
 @UPDATE_VEH_FLAG BIT,    
 @FLG_CONFIGZIPCODE  BIT,    
  @IV_DEPT_ACCNT_NUM VARCHAR(50),    
 @VA_COST_PRICE decimal(13,2),    
 @VA_SELL_PRICE decimal(13,2),    
 @VA_NUMBER VARCHAR(20),    
  @REGN_DATE VARCHAR(30),    
 @VEH_TYPE VARCHAR(30),    
 @VEH_GRP_DESC VARCHAR(10),     
 @FLG_UPD_MILEAGE BIT,    
 @IV_INT_NOTE VARCHAR(200)             
)            
AS            
BEGIN              
    
  IF @IV_WO_STATUS <>'PINV'  -- ROW 388    
   BEGIN    
 DECLARE @CNT INT              
 DECLARE @IVDT_ORD VARCHAR(20)              
 DECLARE @GEN_TYPE VARCHAR(2)              
 DECLARE @IV_ID_PRICE_CD VARCHAR(10)              
 DECLARE @OV_ZIPID VARCHAR(10)      /*Changed to handle varchar zipcode*/              
 DECLARE @TRANNAME VARCHAR(20)              
 DECLARE @IV_CUSTPCITY VARCHAR(50)     
 DECLARE @PREV_CUSTID VARCHAR(10)     
 DECLARE @ID_DEPT INT    
     
 SET @IV_CUSTPCITY = @IV_CUSTPSTATE               
 SET @0V_RETVALUE = 0              
    
 DECLARE @ID_WO_VEH_INTERN_NO1   VARCHAR(15)               
 DECLARE @IV_WO_VEH_VIN1   VARCHAR(20)                    
 DECLARE @IV_WO_VEH_REG_NO1   VARCHAR(15)           
 DECLARE @IV_ID_VEH_SEQ_WO1   INT          
 DECLARE @II_WO_VEH_MODEL1    VARCHAR(10)          
 SET  @ID_WO_VEH_INTERN_NO1 = REPLACE(@ID_WO_VEH_INTERN_NO,'%','')         
 SET  @IV_WO_VEH_REG_NO1  = REPLACE(@IV_WO_VEH_REG_NO,'%','')         
 SET  @IV_WO_VEH_VIN1  = REPLACE(@IV_WO_VEH_VIN,'%','')     
 SET  @IV_ID_VEH_SEQ_WO1  = @IV_ID_VEH_SEQ_WO        
 SET  @II_WO_VEH_MODEL1  = @II_WO_VEH_MODEL         
    
 /*For Bargain Order Fix*/    
 DECLARE @WO_OLD_TYPE VARCHAR(20)    
 SELECT @WO_OLD_TYPE = WO_TYPE_WOH     
 FROM TBL_WO_HEADER     
 WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX     
    
  IF REPLACE(@ID_WO_VEH_INTERN_NO,'%','') = '' AND REPLACE(@IV_WO_VEH_REG_NO,'%','') ='' AND REPLACE(@IV_WO_VEH_VIN,'%','') =''            
 BEGIN          
  SET @ID_WO_VEH_INTERN_NO1 = NULL          
  SET @IV_WO_VEH_REG_NO1  = NULL          
  SET @IV_WO_VEH_VIN1   = NULL          
  SET @IV_ID_VEH_SEQ_WO1  = NULL          
  SET @II_WO_VEH_MODEL1  = NULL          
 END            
  DECLARE @SUBID AS INT     
            DECLARE @DEPTID AS INT     
   SELECT @SUBID = ID_SUBSIDERY_USER ,    
       @DEPTID =ID_Dept_User                              
      FROM TBL_MAS_USERS                              
      WHERE ID_LOGIN = @IV_MODIFIED_BY    
 --select @ID_WO_VEH_INTERN_NO,@ID_WO_VEH_INTERN_NO1     
    
 BEGIN TRY             
 SELECT @TRANNAME = 'WOUPDTRANS'                
 -- Check whether zip exist for the addresss and return the new zipcode               
 BEGIN TRANSACTION @TRANNAME                
 IF @II_ID_ZIPCODE_WO IS NOT NULL AND @FLG_CONFIGZIPCODE = 1                   
 BEGIN              
  EXEC DBO.USP_CONFIG_ZIPCODE_RETRIVE  @II_ID_ZIPCODE_WO,  @IV_CUSTPCOUNTRY, '', @IV_CUSTPCITY,          
    @IV_MODIFIED_BY, @0V_RETVALUE  OUTPUT, @OV_ZIPID  OUTPUT                 
  SET @0V_RETVALUE=0       
               
  --IF @OV_ZIPID > 0     /*Changed to handle varchar zipcode*/    
  --SET @II_ID_ZIPCODE_WO = @OV_ZIPID                    
   IF @@ERROR <> 0                      
   BEGIN                
    SET @0V_RETVALUE = @@ERROR                  
    ROLLBACK TRANSACTION @TRANNAME                
   END                    
 END        
          
 SELECT @CNT=COUNT(ID_CUSTOMER) FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = @IV_ID_CUST_WO              
 BEGIN               
 IF @IV_ID_CUST_WO IS NULL               
 BEGIN              
  SET @GEN_TYPE ='A'              
  SELECT   @IV_ID_CUST_WO =ISNULL(MAX(CAST(ID_CUSTOMER AS INT))+ 1,        
     (SELECT CUST_START_NO FROM TBL_MAS_CUST_CONFIG))         
  FROM TBL_MAS_CUSTOMER         
  WHERE CUST_GEN_TYPE ='A'              
  --SET @0V_RETVALUE = 0               
  IF @@ERROR <> 0                   
  BEGIN                
   SET @0V_RETVALUE = @@ERROR                  
   ROLLBACK TRANSACTION @TRANNAME                
  END                  
 END              
 ELSE              
  SET @GEN_TYPE ='U'              
 END       
            
 IF @CNT = 0               
 BEGIN                       
  --Pay Details for Customer              
  SELECT @IV_ID_PAY_TYPE_WO = ID_PAY_TYPE ,        
   @IV_ID_PAY_TERMS_WO = ID_PAY_TERM  ,              
   @IV_ID_PRICE_CD  = ID_PRICE_CD                          
  FROM    TBL_MAS_CUST_GROUP              
  WHERE ID_CUST_GRP_SEQ  = @IV_CUST_GROUP_ID              
   ----------Insert Customer If not Exist----------------               
  INSERT INTO TBL_MAS_CUSTOMER              
  (              
   ID_CUSTOMER   ,              
   CUST_NAME   ,              
   CUST_GEN_TYPE  ,              
   ID_CUST_GROUP  ,              
   CUST_PHONE_OFF  ,     
   CUST_PHONE_HOME  ,              
   CUST_PHONE_MOBILE ,              
   CUST_PERM_ADD1  ,              
   CUST_PERM_ADD2  ,              
   ID_CUST_PERM_ZIPCODE,              
   CREATED_BY   ,              
   DT_CREATED   ,              
   ID_CUST_PAY_TYPE ,               
   ID_CUST_PAY_TERM ,              
   ID_CUST_PC_CODE              
  )              
  VALUES              
  (        
   @IV_ID_CUST_WO    ,              
   @IV_WO_CUST_NAME   ,              
   @GEN_TYPE     ,              
   @IV_CUST_GROUP_ID   ,              
   @IV_WO_CUST_PHONE_OFF  ,                   
   @IV_WO_CUST_PHONE_HOME  ,                  
   @IV_WO_CUST_PHONE_MOBILE   ,              
   @IV_WO_CUST_PERM_ADD1      ,              
   @IV_WO_CUST_PERM_ADD2  ,              
   @II_ID_ZIPCODE_WO          ,              
   @IV_MODIFIED_BY   ,              
   GETDATE()     ,              
   @IV_ID_PAY_TYPE_WO   ,              
   @IV_ID_PAY_TERMS_WO  ,              
   @IV_ID_PRICE_CD                       
  )              
  SET @0V_RETVALUE = 0       
            
  IF @@ERROR <> 0                    
  BEGIN                
   SET @0V_RETVALUE = @@ERROR                  
   ROLLBACK TRANSACTION @TRANNAME                
  END                  
 END              
 ELSE              
  UPDATE TBL_MAS_CUSTOMER SET CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME                 
  WHERE   CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME           
  AND  ID_CUSTOMER = @IV_ID_CUST_WO              
             
  UPDATE  TBL_MAS_CUSTOMER   SET CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME                 
  WHERE   CUST_PHONE_OFF = @IV_WO_CUST_PHONE_OFF           
  AND  ID_CUSTOMER = @IV_ID_CUST_WO              
             
  UPDATE TBL_MAS_CUSTOMER   SET CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME                 
  WHERE   CUST_PHONE_MOBILE = @IV_WO_CUST_PHONE_MOBILE           
  AND  ID_CUSTOMER = @IV_ID_CUST_WO               
    
  ------UPDATING ORDER QUANTITY , DELIVAR QUANTITY, BO QUANTITY-----            
  IF(@IV_WO_TYPE_WOH = 'OPRG')            
  BEGIN            
   IF((SELECT WO_TYPE_WOH FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO           
   AND ID_WO_PREFIX=@IV_ID_WO_PREFIX) <> @IV_WO_TYPE_WOH)            
   BEGIN            
    EXEC USP_WO_QUANTITY_UPDATE @IV_ID_WO_NO,@IV_ID_WO_PREFIX            
    UPDATE TBL_WO_DETAIL  SET JOB_STATUS = 'CRT'            
    WHERE ID_WO_NO = @IV_ID_WO_NO            
    AND  ID_WO_PREFIX=@IV_ID_WO_PREFIX            
   END            
   IF @@ERROR <> 0                   
   BEGIN                
    SET @0V_RETVALUE = @@ERROR                  
    ROLLBACK TRANSACTION @TRANNAME                
   END                  
  END               
                
 ------------------- WHEN CHANGEING STATUS OF WO THEN WE HAVE TO REVERT THE qUANTITY -----            
  IF(@IV_WO_STATUS='DEL')            
  BEGIN            
   DECLARE @WO_TYPE VARCHAR(10)            
   SELECT @WO_TYPE=WO_TYPE_WOH FROM TBL_WO_HEADER         
   WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX            
         
   IF  (@WO_TYPE = 'ORPG' OR @WO_TYPE = 'OPRC' )            
   BEGIN            
    --------ZSL Changes related to TBl_MAS_ITEM_MASTER Composite Key 12-Dec-07---------           
    /* SELECT ID_ITEM_JOB, SUM(JOBI_DELIVER_QTY) AS DELIVAR_QTY  INTO #TMP         
    FROM TBL_WO_JOB_DETAIL JOB WHERE ID_WO_NO = @IV_ID_WO_NO         
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX         
    GROUP BY ID_ITEM_JOB       */            
    
    SELECT ID_ITEM_JOB, SUM(JOBI_DELIVER_QTY) AS DELIVAR_QTY,ID_MAKE_JOB  INTO #TMP           
    FROM TBL_WO_JOB_DETAIL JOB WHERE ID_WO_NO = @IV_ID_WO_NO           
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX           
    GROUP BY ID_ITEM_JOB,ID_MAKE_JOB           
    -------------------------------ZSL Changes End-------------------------------------          
    
    --------ZSL Changes related to TBl_MAS_ITEM_MASTER Composite Key 12-Dec-07---------           
    /*   UPDATE TBL_MAS_ITEM_MASTER            
    SET  ITEM_AVAIL_QTY  = ITEM_AVAIL_QTY+(SELECT MIN(DELIVAR_QTY) FROM #TMP WHERE #TMP.ID_ITEM_JOB =T.ID_ITEM_JOB)            
    FROM #TMP T            
    WHERE TBL_MAS_ITEM_MASTER.ID_ITEM = T.ID_ITEM_JOB      */             
    
    UPDATE TBL_MAS_ITEM_MASTER              
    SET  ITEM_AVAIL_QTY  = ITEM_AVAIL_QTY+(SELECT MIN(DELIVAR_QTY) FROM #TMP         
     WHERE #TMP.ID_ITEM_JOB COLLATE database_default =T.ID_ITEM_JOB COLLATE database_default     
    and #TMP.ID_MAKE_JOB COLLATE database_default =T.ID_MAKE_JOB COLLATE database_default)              
    FROM #TMP T              
    WHERE TBL_MAS_ITEM_MASTER.ID_ITEM = T.ID_ITEM_JOB and TBL_MAS_ITEM_MASTER.ID_MAKE = T.ID_MAKE_JOB              
    -------------------------------ZSL Changes End-------------------------------------            
    
    DROP TABLE #TMP            
    IF @@ERROR <> 0                   
    BEGIN                
     SET @0V_RETVALUE = @@ERROR                  
     ROLLBACK TRANSACTION @TRANNAME                
    END             
   END                  
  END            
 ---------Inserting Vehicle Information-----------------------              
  BEGIN              
  DECLARE @COUNT INT,@II_ID_VEH_OWNER INT              
  SET @COUNT =0         
  BEGIN            
  IF REPLACE(@ID_WO_VEH_INTERN_NO,'%','') = '' AND REPLACE(@IV_WO_VEH_REG_NO,'%','') ='' AND REPLACE(@IV_WO_VEH_VIN,'%','') =''            
  SET @COUNT =  2          
  END            
  DECLARE @COUNT1 INT        
  SELECT @COUNT1 = COUNT(*) FROM TBL_MAS_VEHICLE         
  WHERE ID_VEH_SEQ =  @IV_ID_VEH_SEQ_WO    
      
  DECLARE @VEH_GRP AS INT    
   SELECT @VEH_GRP = ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = 'VEH-GROUP'     
   AND DESCRIPTION = @VEH_GRP_DESC           
                
  IF @COUNT1 <> 1  AND @COUNT <> 2          
       
  --  IF @COUNT <> 1               
  BEGIN    
      DECLARE @VA_ACC_CODE VARCHAR(10)    
   DECLARE @USE_VA_ACC_CODE VARCHAR(3)     
   /*ADDED THE CHECK TO UPDATE VA ACC CODE VEHICLE FOR ANY ORDERS BASED ON CONFIG SETTINGS*/     
    SELECT @USE_VA_ACC_CODE =ISNULL(USE_VA_ACC_CODE,0) ,@VA_ACC_CODE =  ISNULL(VA_ACC_CODE,'') FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = @DEPTID AND ID_SUBSIDERY_WO = @SUBID AND MODIFIED_BY =@IV_MODIFIED_BY    
    IF @USE_VA_ACC_CODE = '1'    
     BEGIN              
   INSERT INTO TBL_MAS_VEHICLE         
   (               
      VEH_REG_NO   ,              
      VEH_INTERN_NO  ,                  
      VEH_VIN    ,              
      ID_MAKE_VEH   ,              
      ID_MODEL_VEH  ,              
      VEH_MILEAGE   ,              
      VEH_HRS    ,              
      ID_CUSTOMER_VEH  ,              
      CERATED_BY   ,              
      DT_CREATED     
    ,DT_VEH_MIL_REGN    
    ,DT_VEH_HRS_ERGN    
    ,VA_ACC_CODE    
    ,DT_VEH_ERGN    
    ,VEH_TYPE    
    ,ID_GROUP_VEH     
   )              
   VALUES              
   (              
    REPLACE(@IV_WO_VEH_REG_NO,'%','') ,                        
    REPLACE(@ID_WO_VEH_INTERN_NO,'%','') ,                        
    REPLACE(@IV_WO_VEH_VIN,'%','')  ,                
    @IV_WO_VEH_MAKE        ,              
    null,--@II_WO_VEH_MODEL       ,              
    @ID_WO_VEH_MILEAGE     ,              
    @ID_WO_VEH_HRS         ,              
    @IV_ID_CUST_WO         ,              
    @IV_MODIFIED_BY        ,              
    GETDATE()      
    ,CASE WHEN @ID_WO_VEH_MILEAGE = 0 OR LTRIM(RTRIM(@ID_WO_VEH_MILEAGE)) = ''    
     THEN ''    
    ELSE GETDATE() END                      
    ,CASE WHEN @ID_WO_VEH_HRS = 0 OR LTRIM(RTRIM(@ID_WO_VEH_HRS)) = ''    
     THEN ''    
    ELSE GETDATE() END     
    ,@VA_ACC_CODE    
    ,@REGN_DATE    
    ,@VEH_TYPE    
    ,@VEH_GRP                            
   )     
   END    
   ELSE    
   BEGIN    
     INSERT INTO TBL_MAS_VEHICLE         
   (               
      VEH_REG_NO   ,              
      VEH_INTERN_NO  ,                  
      VEH_VIN    ,              
      ID_MAKE_VEH   ,              
      ID_MODEL_VEH  ,              
      VEH_MILEAGE   ,              
      VEH_HRS    ,           
      ID_CUSTOMER_VEH  ,              
      CERATED_BY   ,              
      DT_CREATED     
    ,DT_VEH_MIL_REGN    
    ,DT_VEH_HRS_ERGN    
   )              
   VALUES              
   (              
    REPLACE(@IV_WO_VEH_REG_NO,'%','') ,                        
    REPLACE(@ID_WO_VEH_INTERN_NO,'%','') ,                        
    REPLACE(@IV_WO_VEH_VIN,'%','')  ,                
    @IV_WO_VEH_MAKE        ,              
    null,--@II_WO_VEH_MODEL       ,              
    @ID_WO_VEH_MILEAGE     ,              
    @ID_WO_VEH_HRS         ,              
    @IV_ID_CUST_WO         ,              
    @IV_MODIFIED_BY        ,              
    GETDATE()      
    ,CASE WHEN @ID_WO_VEH_MILEAGE = 0 OR LTRIM(RTRIM(@ID_WO_VEH_MILEAGE)) = ''    
     THEN ''    
    ELSE GETDATE() END                   
    ,CASE WHEN @ID_WO_VEH_HRS = 0 OR LTRIM(RTRIM(@ID_WO_VEH_HRS)) = ''    
     THEN ''    
    ELSE GETDATE() END     
   )      
   END           
    
   SELECT  @IV_ID_VEH_SEQ_WO1 = ID_VEH_SEQ                                    
   FROM    TBL_MAS_VEHICLE                                     
   WHERE   VEH_REG_NO = REPLACE(@IV_WO_VEH_REG_NO,'%','')        
   AND  VEH_INTERN_NO = REPLACE(@ID_WO_VEH_INTERN_NO,'%','')           
   AND    VEH_VIN = REPLACE(@IV_WO_VEH_VIN,'%','')                                                   
    
   DECLARE @VEH_MAKEMODEL1 AS VARCHAR(10)    
   --SELECT @VEH_MAKEMODEL1 = MG_ID_MODEL_GRP FROM TBL_MAS_MODELGROUP_MAKE_MAP     
   --WHERE ID_MG_SEQ = @ii_WO_VEH_Model  
   
   SELECT 1,@ii_WO_VEH_Model  
   SELECT @VEH_MAKEMODEL1 = @ii_WO_VEH_Model   
      
   UPDATE TBL_MAS_VEHICLE         
   SET  ID_MODEL_VEH = @II_WO_VEH_MODEL    
   WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1     
    
   EXEC USP_MAS_VEHICLE_OWNERHISTORY_INSERT  @IV_ID_VEH_SEQ_WO1, @IV_WO_VEH_REG_NO, '',         
    @IV_ID_CUST_WO, NULL, @IV_MODIFIED_BY,NULL                   
    
         
   --SET @0V_RETVALUE = 0               
   IF @@ERROR <> 0                              
   BEGIN                
    SET @0V_RETVALUE = @@ERROR                  
    ROLLBACK TRANSACTION @TranName                
   END                  
   --   SELECT @IV_ID_VEH_SEQ_WO = MAX(ID_VEH_SEQ) FROM TBL_MAS_VEHICLE              
  END     
      
  /*For Bargain Order Fix*/    
  IF @WO_OLD_TYPE = 'BAR' AND @IV_WO_TYPE_WOH <> 'BAR'    
  BEGIN    
   EXEC USP_UPDATE_BARGAIN_WO @IV_ID_WO_NO, @IV_ID_WO_PREFIX     
  END    
 END              
    
 DECLARE @REG_MIL_DATE1 AS VARCHAR(30)            
 DECLARE @REG_HRS_DATE1 AS VARCHAR(30)            
 DECLARE @OV_RETVALUE_HIST AS  VARCHAR(10)            
    
 SELECT @REG_MIL_DATE1 = DT_VEH_MIL_REGN,                                            
 @REG_HRS_DATE1 = DT_VEH_HRS_ERGN              
 FROM    TBL_MAS_VEHICLE            
 WHERE   ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1          
    
 DECLARE @REG_MIL AS INT            
 DECLARE @REG_HRS AS DECIMAL     
 DECLARE @VEH_MAKE AS VARCHAR(10)    
 DECLARE @VEH_MODEL AS VARCHAR(10)    
     
 SELECT @REG_MIL = VEH_MILEAGE, @REG_HRS =  VEH_HRS ,    
     @VEH_MAKE = ID_MAKE_VEH, @VEH_MODEL = ID_MODEL_VEH       
 FROM    TBL_MAS_VEHICLE            
 WHERE   ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1             
         
 --SELECT @REG_MIL, @REG_HRS, @ID_WO_VEH_MILEAGE, @ID_WO_VEH_HRS        
      
 SET  @REG_HRS_DATE1 = GETDATE()        
 IF @REG_MIL <> @ID_WO_VEH_MILEAGE        
 BEGIN        
  SET  @ID_WO_VEH_MILEAGE = @ID_WO_VEH_MILEAGE        
  SET  @REG_MIL_DATE1 = GETDATE()       
     
--  SELECT 'USP_MAS_VEH_MILEG_HIST_INSERT', @IV_ID_VEH_SEQ_WO1, @ID_WO_VEH_MILEAGE, @REG_MIL_DATE1,         
--   @REG_HRS, @REG_HRS_DATE1, @IV_MODIFIED_BY        
    
  EXEC USP_MAS_VEH_MILEG_HIST_INSERT @IV_ID_VEH_SEQ_WO1, @ID_WO_VEH_MILEAGE, @REG_MIL_DATE1,         
   @REG_HRS, @REG_HRS_DATE1, @IV_MODIFIED_BY,@OV_RETVALUE_HIST OUTPUT          
 END        
       
 SET  @REG_HRS_DATE1 = GETDATE()      
      
-- SELECT 'USP_MAS_VEH_MILEG_HIST_UPDATE', @IV_ID_VEH_SEQ_WO1, @ID_WO_VEH_MILEAGE, @REG_HRS_DATE1,         
-- @ID_WO_VEH_HRS, @REG_HRS_DATE1, @IV_MODIFIED_BY       
     
 EXEC USP_MAS_VEH_MILEG_HIST_UPDATE @IV_ID_VEH_SEQ_WO1, @ID_WO_VEH_MILEAGE, @REG_HRS_DATE1,         
 @ID_WO_VEH_HRS, @REG_HRS_DATE1, @IV_MODIFIED_BY,@OV_RETVALUE_HIST OUTPUT          
    
  IF @UPDATE_VEH_FLAG = 1     
  BEGIN    
   IF @REG_MIL <> @ID_WO_VEH_MILEAGE    
   BEGIN    
    UPDATE TBL_MAS_VEHICLE SET     
    VEH_MILEAGE = @ID_WO_VEH_MILEAGE,         
    VEH_HRS  = @ID_WO_VEH_HRS,        
    DT_VEH_MIL_REGN  = GETDATE()        
    WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1     
        
    --Setting the mileage,hours field updated date    
    UPDATE TBL_WO_HEADER    
    SET DT_MILEAGE_UPDATE = GETDATE(),    
    DT_HOURS_UPDATE = GETDATE()    
    WHERE ID_WO_NO = @IV_ID_WO_NO AND              
    ID_WO_PREFIX = @IV_ID_WO_PREFIX     
          
   END    
        
   IF @REG_HRS <> @ID_WO_VEH_HRS    
   BEGIN    
    UPDATE TBL_MAS_VEHICLE SET        
    VEH_MILEAGE = @ID_WO_VEH_MILEAGE,         
    VEH_HRS  = @ID_WO_VEH_HRS,        
    DT_VEH_HRS_ERGN  = GETDATE()        
    WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1     
        
    --Setting the mileage,hours field updated date    
    UPDATE TBL_WO_HEADER    
    SET DT_MILEAGE_UPDATE = GETDATE(),    
    DT_HOURS_UPDATE = GETDATE()    
    WHERE ID_WO_NO = @IV_ID_WO_NO AND              
    ID_WO_PREFIX = @IV_ID_WO_PREFIX     
    
   END    
  END       
  -- Modified Date : 23rd Feb 2010    
  -- Description :  Vehicle Make and Model should save in    
      -- vehicle details table if changed    
  IF @VEH_MAKE <> @iv_WO_VEH_Make    
  BEGIN    
   UPDATE TBL_MAS_VEHICLE         
   SET  ID_MAKE_VEH = @iv_WO_VEH_Make    
   WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1     
  END    
      
  DECLARE @VEH_MAKEMODEL AS VARCHAR(10)    
  --SELECT @VEH_MAKEMODEL = MG_ID_MODEL_GRP FROM TBL_MAS_MODELGROUP_MAKE_MAP     
  --WHERE ID_MG_SEQ = @ii_WO_VEH_Model    
    
  SELECT @VEH_MAKEMODEL = @ii_WO_VEH_Model  
      
  IF @VEH_MAKEMODEL <> @VEH_MODEL    
  BEGIN     
   UPDATE TBL_MAS_VEHICLE         
   SET  ID_MODEL_VEH = @VEH_MAKEMODEL    
   WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1     
  END    
 -- End OF Modification ***********************    
  IF @UPDATE_VEH_FLAG = 1     
  BEGIN    
   UPDATE TBL_MAS_VEHICLE         
   SET  VEH_MILEAGE = @ID_WO_VEH_MILEAGE,         
   VEH_HRS  = @ID_WO_VEH_HRS          
   WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1    
       
   --Setting the mileage,hours field updated date    
    UPDATE TBL_WO_HEADER    
    SET DT_MILEAGE_UPDATE = GETDATE(),    
    DT_HOURS_UPDATE = GETDATE()    
    WHERE ID_WO_NO = @IV_ID_WO_NO AND              
    ID_WO_PREFIX = @IV_ID_WO_PREFIX     
        
  END 
     
  UPDATE TBL_MAS_VEHICLE         
  SET ID_MAKE_VEH = @IV_WO_VEH_MAKE ,              
   ID_MODEL_VEH =   @II_WO_VEH_MODEL         
  WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1   
      
    
 SET @0V_RETVALUE =''       
    
           
 SELECT @PREV_CUSTID = ID_CUST_WO,@ID_DEPT = ID_Dept FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX    
       
       
               
          
   DECLARE @USE_MANUAL_RWRK AS BIT    
   SELECT @USE_MANUAL_RWRK = USE_MANUAL_RWRK FROM     
        
   TBL_MAS_WO_CONFIGURATION    
         WHERE     
   ID_SUBSIDERY_WO = @SUBID AND     
   ID_DEPT_WO  = @DEPTID  AND    
   DT_EFF_TO > getdate()    
       
   IF @USE_MANUAL_RWRK = 0    
   BEGIN    
       
       
              DECLARE @BOQTY AS INT     
               SELECT @BOQTY= SUM(JOBI_BO_QTY)         
    FROM TBL_WO_JOB_DETAIL JOB WHERE ID_WO_NO = @IV_ID_WO_NO           
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX           
    GROUP BY ID_ITEM_JOB    
     
     
 SET @BOQTY =ISNULL(@BOQTY,0)    
    
     
 UPDATE TBL_WO_HEADER SET               
 WO_CUST_GROUPID      = @IV_CUST_GROUP_ID       ,              
 WO_TYPE_WOH   = @IV_WO_TYPE_WOH       ,              
 WO_STATUS   = CASE WHEN (@BOQTY =0 AND (@iv_WO_STATUS = 'CSA'OR @iv_WO_STATUS = 'RES') ) THEN 'RWRK' ELSE @IV_WO_STATUS   END     ,              
 DT_DELIVERY   = DBO.FN_DATEFORMAT(@ID_DT_DELIVERY)  ,              
 WO_TM_DELIV   = @IV_WO_TM_DELIV       ,              
 DT_FINISH   = DBO.FN_DATEFORMAT(@ID_DT_FINISH)   ,              
 ID_PAY_TYPE_WO  = @IV_ID_PAY_TYPE_WO      ,              
 ID_PAY_TERMS_WO  = @IV_ID_PAY_TERMS_WO      ,           
 WO_ANNOT    = @IV_WO_ANNOT        ,              
 ID_CUST_WO   = @IV_ID_CUST_WO       ,              
 WO_CUST_NAME   = @IV_WO_CUST_NAME       ,              
 WO_CUST_PERM_ADD1 = @IV_WO_CUST_PERM_ADD1      ,              
 WO_CUST_PERM_ADD2 = @IV_WO_CUST_PERM_ADD2      ,              
 ID_ZIPCODE_WO  = @II_ID_ZIPCODE_WO       ,              
 WO_CUST_PHONE_OFF = @IV_WO_CUST_PHONE_OFF      ,              
 WO_CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME     ,              
 WO_CUST_PHONE_MOBILE = @IV_WO_CUST_PHONE_MOBILE     ,              
 ID_VEH_SEQ_WO  = @IV_ID_VEH_SEQ_WO1      ,              
 WO_VEH_REG_NO  = @IV_WO_VEH_REG_NO1      ,              
 WO_VEH_INTERN_NO  = @ID_WO_VEH_INTERN_NO1      ,              
 WO_VEH_VIN   = @IV_WO_VEH_VIN1       ,              
 WO_VEH_MILEAGE  = @ID_WO_VEH_MILEAGE      ,              
 WO_VEH_HRS   = @ID_WO_VEH_HRS       ,              
 WO_VEH_MAK_MOD_MAP = @II_WO_VEH_MODEL1       ,              
 MODIFIED_BY   = @IV_MODIFIED_BY       ,              
 DT_MODIFIED   = GETDATE(),    
 --BUG ID:-IF PKK Button Active,     
 --then insert mvr date or general rule date    
 --date :- 10-Sept-2008    
 WO_PKKDATE=@IV_PKKDate,    
 --change end             
    
 -- MODIFIED DATE: 11 SEP 2008    
 -- COMMENTS: BUSPEK - CONTROL NO    
 BUS_PEK_PREVIOUS_NUM = @BUS_PEK_PREVIOUS_NUM,    
 BUS_PEK_CONTROL_NUM = @BUS_PEK_CONTROL_NUM ,    
 LA_DEPT_ACCOUNT_NO = @IV_DEPT_ACCNT_NUM,    
 VA_COST_PRICE = @VA_COST_PRICE ,    
 VA_SELL_PRICE = @VA_SELL_PRICE ,    
 VA_NUMBER = @VA_NUMBER,    
 INT_NOTE = @IV_INT_NOTE    
                 
 -- END OF MODIFICATION    
 WHERE       ID_WO_NO  = @IV_ID_WO_NO AND              
 ID_WO_PREFIX =   @IV_ID_WO_PREFIX       
    
 -- ***************************************************      
 -- Modified Date : 01st September 2008      
 -- Bug Id   : 3585      
     
 UPDATE TBL_WO_DETAIL SET JOB_STATUS = CASE WHEN (@BOQTY =0 AND (@iv_WO_STATUS = 'CSA'OR @iv_WO_STATUS = 'RES') ) THEN 'RWRK' ELSE @IV_WO_STATUS   END        
 WHERE  ID_WO_NO  = @IV_ID_WO_NO AND              
 ID_WO_PREFIX =   @IV_ID_WO_PREFIX AND      
 JOB_STATUS = 'BAR'      
     
 -- *********** End Of Modification *******************      
 END    
 ELSE    
 BEGIN    
 UPDATE TBL_WO_HEADER SET               
 WO_CUST_GROUPID      = @IV_CUST_GROUP_ID       ,              
 WO_TYPE_WOH   = @IV_WO_TYPE_WOH       ,              
 WO_STATUS   =  @IV_WO_STATUS      ,              
 DT_DELIVERY   = DBO.FN_DATEFORMAT(@ID_DT_DELIVERY)  ,              
 WO_TM_DELIV   = @IV_WO_TM_DELIV       ,              
 DT_FINISH   = DBO.FN_DATEFORMAT(@ID_DT_FINISH)   ,              
 ID_PAY_TYPE_WO  = @IV_ID_PAY_TYPE_WO      ,              
 ID_PAY_TERMS_WO  = @IV_ID_PAY_TERMS_WO      ,              
 WO_ANNOT    = @IV_WO_ANNOT        ,              
 ID_CUST_WO   = @IV_ID_CUST_WO       ,              
 WO_CUST_NAME   = @IV_WO_CUST_NAME       ,              
 WO_CUST_PERM_ADD1 = @IV_WO_CUST_PERM_ADD1      ,              
 WO_CUST_PERM_ADD2 = @IV_WO_CUST_PERM_ADD2      ,              
 ID_ZIPCODE_WO  = @II_ID_ZIPCODE_WO       ,              
 WO_CUST_PHONE_OFF = @IV_WO_CUST_PHONE_OFF      ,              
 WO_CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME     ,              
 WO_CUST_PHONE_MOBILE = @IV_WO_CUST_PHONE_MOBILE     ,              
 ID_VEH_SEQ_WO  = @IV_ID_VEH_SEQ_WO1      ,              
 WO_VEH_REG_NO  = @IV_WO_VEH_REG_NO1      ,              
 WO_VEH_INTERN_NO  = @ID_WO_VEH_INTERN_NO1      ,              
 WO_VEH_VIN   = @IV_WO_VEH_VIN1       ,              
 WO_VEH_MILEAGE  = @ID_WO_VEH_MILEAGE      ,              
 WO_VEH_HRS   = @ID_WO_VEH_HRS       ,              
 WO_VEH_MAK_MOD_MAP = @II_WO_VEH_MODEL1       ,              
 MODIFIED_BY   = @IV_MODIFIED_BY       ,              
 DT_MODIFIED   = GETDATE(),    
 WO_PKKDATE=@IV_PKKDate,    
 BUS_PEK_PREVIOUS_NUM = @BUS_PEK_PREVIOUS_NUM,    
 BUS_PEK_CONTROL_NUM = @BUS_PEK_CONTROL_NUM ,    
 LA_DEPT_ACCOUNT_NO = @IV_DEPT_ACCNT_NUM,    
 VA_COST_PRICE = @VA_COST_PRICE ,    
 VA_SELL_PRICE = @VA_SELL_PRICE,    
 VA_NUMBER = @VA_NUMBER,    
 INT_NOTE = @IV_INT_NOTE      
 WHERE ID_WO_NO = @IV_ID_WO_NO AND              
 ID_WO_PREFIX =   @IV_ID_WO_PREFIX       
    
     
 UPDATE TBL_WO_DETAIL SET JOB_STATUS =  @IV_WO_STATUS        
 WHERE  ID_WO_NO  = @IV_ID_WO_NO AND              
 ID_WO_PREFIX =   @IV_ID_WO_PREFIX AND      
 JOB_STATUS = 'BAR'     
 END    
     
     
 /* 654 - Set the FLG_UPD_MILEAGE if the mileage is updated */    
 UPDATE TBL_WO_HEADER    
 SET FLG_UPD_MILEAGE = @FLG_UPD_MILEAGE    
 WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 AND ISNULL(FLG_UPD_MILEAGE,0) = 0    
 /* 654 - Set the FLG_UPD_MILEAGE if the mileage is updated */    
      
 ----------------------Updating the CUSTOMER DETAILS if the Customer is changed-----------------    
     
     
 --TO GET ALL THE JOBS FOR THE CORRESPONDING WORKORDER AND CUSTOMER    
  SELECT * INTO #TEMP_JOBDETAILS FROM TBL_WO_DETAIL     
  WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND     
  ID_JOB IN(SELECT ID_JOB_ID FROM TBL_WO_DEBITOR_DETAIL      
  WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB_DEB=@PREV_CUSTID)    
    
 IF(@PREV_CUSTID <> @IV_ID_CUST_WO)    
 BEGIN    
     
  UPDATE TBL_WO_DEBITOR_DETAIL     
  SET ID_JOB_DEB = @IV_ID_CUST_WO, ID_DETAIL=@IV_ID_CUST_WO,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
  WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB_DEB = @PREV_CUSTID AND ID_JOB_ID    
  NOT IN (SELECT ID_JOB_ID FROM TBL_WO_DEBITOR_DETAIL WOD WHERE WOD.ID_WO_NO=@IV_ID_WO_NO AND WOD.ID_WO_PREFIX=@IV_ID_WO_PREFIX AND WOD.ID_JOB_DEB=@IV_ID_CUST_WO)    
     
       
  UPDATE TBL_WO_DETAIL    
  SET WO_OWN_CR_CUST = @IV_ID_CUST_WO,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
  WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WO_OWN_CR_CUST = @PREV_CUSTID     
  AND(isnull(WO_OWN_RISK_CUST,0) <> @IV_ID_CUST_WO )    
      
  UPDATE TBL_WO_DETAIL    
  SET WO_OWN_RISK_CUST = @IV_ID_CUST_WO,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
  WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WO_OWN_RISK_CUST = @PREV_CUSTID    
  AND (isnull(WO_OWN_CR_CUST,0) <> @IV_ID_CUST_WO )    
      
  UPDATE TBL_WO_JOB_DEBITOR_DISCOUNT    
  SET ID_DEB = @IV_ID_CUST_WO,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
  WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_DEB = @PREV_CUSTID    
      
  UPDATE TBL_WO_JOB_DETAIL    
  SET ID_CUST_WO = @IV_ID_CUST_WO,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
  WHERE ID_CUST_WO = @PREV_CUSTID AND ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX    
      
  UPDATE TBL_WO_DEBTOR_INVOICE_DATA     
  SET DEBTOR_ID = @IV_ID_CUST_WO,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
  WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND DEBTOR_ID = @PREV_CUSTID AND ID_JOB_ID    
  NOT IN (SELECT ID_JOB_ID FROM TBL_WO_DEBTOR_INVOICE_DATA WOD WHERE WOD.ID_WO_NO=@IV_ID_WO_NO AND WOD.ID_WO_PREFIX=@IV_ID_WO_PREFIX AND WOD.DEBTOR_ID=@IV_ID_CUST_WO)    
      
 -- -----------Calculation of VAT -------------------------    
      
  DECLARE @MAX INT , @MIN  INT,@WO_GM_VAT VARCHAR(10),@IV_ID_HPVAT VARCHAR(10),@iv_ID_RPPCD_HP INT,@IV_ID_VEH_GRP VARCHAR(10)    
  DECLARE @MAX_SPAREPART INT,@MIN_SPAREPART INT,@IV_ID_ITEM VARCHAR(100), @IV_ID_MAKE VARCHAR(10)    
  DECLARE @iv_ID_JOBPCD_HP VARCHAR(10),@iv_ID_MECHPCD_HP VARCHAR(10),@JOB_ID INT,@NO_OF_DEB INT,@OWNER_PAY_VAT VARCHAR(10)    
     
  DECLARE @WO_OWN_RISK_CUST VARCHAR(30),@GM_VAT DECIMAL(10,2),@HP_VAT DECIMAL(10,2),@VAT_ACCOUNTCODE VARCHAR(10),@FIXED_VAT DECIMAL(10,2),@OWN_RISK_VAT DECIMAL(10,2)    
  DECLARE @WOGMVAT VARCHAR(10),@GP_ACCODE VARCHAR(10),@SP_VAT_ACCOUNTCODE VARCHAR(10),@SP_VAT DECIMAL(10,2),@HP_VAT_ACCOUNTCODE VARCHAR(10)    
  DECLARE @TOT_LAB_VAT DECIMAL(10,2),@TOT_GM_VAT DECIMAL(10,2),@TOT_SP_VAT DECIMAL(10,2),@TOT_FIXED_VAT DECIMAL(10,2)    
    
      
  DECLARE  @TEMP_SPAREPARTDETAILS TABLE    
  (ID_WOITEM_SEQ VARCHAR(10),ID_ITEM_JOB VARCHAR(100),IV_ID_MAKE VARCHAR(10))    
      
  SELECT @IV_ID_VEH_GRP = ID_GROUP_VEH FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO    
      
  SELECT @WOGMVAT = ISNULL(ID_VAT,''),@GP_ACCODE = ISNULL(GP_ACCCODE,'')     
  FROM TBL_MAS_CUST_GRP_GM_PRICE_MAP     
  WHERE ID_DEPT = @ID_DEPT  AND ID_CUST_GRP_SEQ = @IV_CUST_GROUP_ID AND GETDATE()  BETWEEN  DT_EFF_FROM AND DT_EFF_TO     
    
  -- TO UPDATE ONLY THE SPARE PART TABLE    
  CREATE TABLE #TEMP_JOBDETAILS1(SPARE_PART_NUMBER INT,JOB_ID INT,CUST_ID VARCHAR(10),SP_ITEM VARCHAR(100),    
  HP_VAT DECIMAL(13,2),GM_VAT DECIMAL(13,2),SP_VAT DECIMAL(13,2),     
  Fixed_VAT DECIMAL(13,2),OwnRisk_VAT DECIMAL(13,2),SS3_SP_VAT DECIMAL(13,2),VAT_ACCOUNTCODE VARCHAR(10),SP_VAT_ACCOUNTCODE VARCHAR(10),HP_VAT_ACCOUNTCODE VARCHAR(10))    
     
  -- TO UPDATE ONLY THE WO DETAIL THAT IS JOB TABLE    
  CREATE TABLE #TEMP_JOBDETAILS2(JOB_ID INT,CUST_ID VARCHAR(10),SP_ITEM VARCHAR(100),    
  HP_VAT DECIMAL(13,2),GM_VAT DECIMAL(13,2),SP_VAT DECIMAL(13,2),     
  Fixed_VAT DECIMAL(13,2),OwnRisk_VAT DECIMAL(13,2),SS3_SP_VAT DECIMAL(13,2),VAT_ACCOUNTCODE VARCHAR(10),SP_VAT_ACCOUNTCODE VARCHAR(10),HP_VAT_ACCOUNTCODE VARCHAR(10))    
    
  SELECT @MAX = MAX(ID_WODET_SEQ),@MIN = MIN(ID_WODET_SEQ)  FROM #TEMP_JOBDETAILS     
    
  WHILE  @MIN <=  @MAX     
  BEGIN    
      
   --FOR EACH JOB ITS SHD ADD ALL SP VATS    
   SET @TOT_SP_VAT = 0    
       
   --FOR SPARE PARTS OF EACH JOB    
   INSERT INTO @TEMP_SPAREPARTDETAILS     
   SELECT ID_WOITEM_SEQ,ID_ITEM_JOB,ID_MAKE_JOB FROM TBL_WO_JOB_DETAIL     
   WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_WODET_SEQ_JOB = @MIN    
       
   SELECT @MAX_SPAREPART = MAX(ID_WOITEM_SEQ),@MIN_SPAREPART = MIN(ID_WOITEM_SEQ) FROM @TEMP_SPAREPARTDETAILS    
       
   SELECT @WO_GM_VAT =  WO_GM_VAT,@iv_ID_RPPCD_HP = ID_RPG_CODE_WO,@iv_ID_JOBPCD_HP = ID_JOBPCD_WO,@JOB_ID = ID_JOB     
   FROM #TEMP_JOBDETAILS  WHERE ID_WODET_SEQ = @MIN    
       
   SELECT @WO_OWN_RISK_CUST = WO_OWN_RISK_CUST FROM TBL_WO_DETAIL     
   WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @JOB_ID    
       
   SET @iv_ID_MECHPCD_HP = NULL    
   --SET @SPARE_VAT_EXISTS = 0    
       
   SELECT @IV_ID_HPVAT = dbo.UFN_WO_HEAD_GetHPPrice(@IV_MODIFIED_BY,@IV_WO_VEH_MAKE,@IV_ID_CUST_WO,@iv_ID_RPPCD_HP,@iv_ID_JOBPCD_HP,@IV_ID_VEH_GRP,@iv_ID_MECHPCD_HP)        
       
   WHILE(@MIN_SPAREPART IS NOT NULL AND @MIN_SPAREPART <= @MAX_SPAREPART)    
   BEGIN    
       
    SELECT @IV_ID_ITEM = ID_ITEM_JOB,@IV_ID_MAKE =IV_ID_MAKE FROM @TEMP_SPAREPARTDETAILS WHERE ID_WOITEM_SEQ = @MIN_SPAREPART    
        
    INSERT INTO #TEMP_JOBDETAILS1     
    SELECT @MIN_SPAREPART,@JOB_ID,*     
    FROM UFN_WO_HEAD_GET_VAT_USERS(@IV_ID_CUST_WO,@IV_ID_VEH_SEQ_WO,@IV_ID_HPVAT,@WO_GM_VAT,@IV_MODIFIED_BY,@IV_ID_ITEM,@IV_ID_MAKE)    
    
    SELECT @GM_VAT = GM_VAT,@VAT_ACCOUNTCODE = VAT_ACCOUNTCODE,@HP_VAT = HP_VAT,@OWN_RISK_VAT = OwnRisk_VAT,    
    @SP_VAT_ACCOUNTCODE = SP_VAT_ACCOUNTCODE ,@SP_VAT = SP_VAT ,@FIXED_VAT = Fixed_VAT,@HP_VAT_ACCOUNTCODE = HP_VAT_ACCOUNTCODE    
    FROM #TEMP_JOBDETAILS1 WHERE SPARE_PART_NUMBER = @MIN_SPAREPART     
    
    --CHECK IF THE WO_OWN_RISK_CUST IS SAME AS THE CURRENT CUSTOMER    
    IF (@WO_OWN_RISK_CUST = @IV_ID_CUST_WO)    
    BEGIN    
     UPDATE TBL_WO_JOB_DETAIL    
     SET JOBI_VAT_PER = @SP_VAT ,JOB_VAT_ACCCODE = @SP_VAT_ACCOUNTCODE,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
     WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_WOITEM_SEQ = @MIN_SPAREPART    
         
     --set @IV_ID_WO_PREFIX = @IV_ID_WO_PREFIX    
    END    
    
    ----------TOT_VAT    
    DECLARE @PER_SP_VAT DECIMAL(10,2)    
    
    --SPARE PART VAT    
    SELECT @PER_SP_VAT =     
    case when ISNULL(FLG_FORCE_VAT,0)=0 then    
    0    
    else    
        
    ((JOBI_SELL_PRICE * JOBI_DELIVER_QTY)-((JOBI_SELL_PRICE * JOBI_DELIVER_QTY)*JOBI_DIS_PER/100))* JOBI_VAT_PER/100    
    end    
    FROM TBL_WO_JOB_DETAIL WHERE    
    ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_WOITEM_SEQ = @MIN_SPAREPART    
        
    SET @TOT_SP_VAT = @TOT_SP_VAT + @PER_SP_VAT    
    
    SET @MIN_SPAREPART = @MIN_SPAREPART +1 --loop through spare parts    
   END      
    
    --------------    
    
    SELECT @OWNER_PAY_VAT = WO_OWN_PAY_VAT FROM TBL_WO_DETAIL WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @JOB_ID    
    SELECT @NO_OF_DEB = COUNT(*) FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB_ID = @JOB_ID    
        
    INSERT INTO #TEMP_JOBDETAILS2    
    SELECT @JOB_ID,*     
    FROM UFN_WO_HEAD_GET_VAT_USERS(@IV_ID_CUST_WO,@IV_ID_VEH_SEQ_WO,@IV_ID_HPVAT,@WO_GM_VAT,@IV_MODIFIED_BY,null,null)    
    
    SELECT @GM_VAT = GM_VAT,@VAT_ACCOUNTCODE = VAT_ACCOUNTCODE,@HP_VAT = HP_VAT,@FIXED_VAT = Fixed_VAT,@OWN_RISK_VAT = OwnRisk_VAT,    
    @SP_VAT_ACCOUNTCODE = SP_VAT_ACCOUNTCODE ,@SP_VAT = SP_VAT,@HP_VAT_ACCOUNTCODE = HP_VAT_ACCOUNTCODE     
    FROM #TEMP_JOBDETAILS2 WHERE JOB_ID = @JOB_ID    
       
    --CHECK FOR ID_JOB_DEB IS SAME CURR CUST AND IF THERE MORE THAN 1 DEBT IN JOB AND OWNER_PAY_VAT =0 ONLY THEN UPDATE THE COL    
    IF(@NO_OF_DEB > 1 AND @OWNER_PAY_VAT = 0)    
    BEGIN    
     UPDATE TBL_WO_DEBITOR_DETAIL    
     SET WO_GM_VATPER = @GM_VAT,WO_VAT_PERCENTAGE = @GM_VAT,    
     WO_LBR_VATPER = @HP_VAT,    
     WO_FIXED_VATPER = @FIXED_VAT,DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY    
     WHERE ID_JOB_DEB = @IV_ID_CUST_WO AND ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX     
     AND ID_JOB_ID = @JOB_ID    
    
    END    
       
       
   --CHECK IF THE WO_OWN_RISK_CUST IS SAME AS THE CURRENT CUSTOMER    
    IF (@WO_OWN_RISK_CUST = @IV_ID_CUST_WO)    
    BEGIN    
     UPDATE TBL_WO_DETAIL SET     
     DT_MODIFIED = GETDATE(),MODIFIED_BY = @IV_MODIFIED_BY,    
     WO_GM_VAT = @WOGMVAT,WO_GM_ACCCODE = @GP_ACCODE,WO_VAT_ACCCODE = @VAT_ACCOUNTCODE,WO_VAT_PERCENTAGE = @GM_VAT,    
     WO_GM_VATPER = @GM_VAT,WO_LBR_VATPER = @HP_VAT,OwnRiskVATAmt = @OWN_RISK_VAT * WO_OWN_RISK_AMT     
     WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX    
     AND ID_JOB = @JOB_ID    
         
     UPDATE TBL_WO_LABOUR_DETAIL    
     SET WO_VAT_Code = @IV_ID_HPVAT,    
     WO_vat_ACCCODE = @HP_VAT_ACCOUNTCODE,    
     WO_LABOURVAT_PERCENTAGE = @HP_VAT    
     WHERE ID_WODET_SEQ = @MIN    
         
    END     
       
    --select * FROM #TEMP_JOBDETAILS  WHERE ID_WODET_SEQ = @MIN    
       
    SELECT @TOT_LAB_VAT = case when isnull(FLG_VAT_FREE,0)=1 then    
    0    
    else    
         
    (WO_TOT_LAB_AMT - (WO_TOT_LAB_AMT * WO_DISCOUNT/100))*(WO_LBR_VATPER/100)    
    end    
    ,    
    @TOT_GM_VAT =     
    case when isnull(FLG_VAT_FREE,0)=1 then    
    0    
    else    
    (WO_TOT_GM_AMT - (WO_TOT_GM_AMT * WO_DISCOUNT/100))*(WO_GM_VATPER/100)    
    end    
    FROM TBL_WO_DETAIL  WHERE ID_WODET_SEQ = @MIN    
        
    --select 'bef', @TOT_LAB_VAT , @TOT_GM_VAT  ,@TOT_SP_VAT    
       
   ---------------------    
   IF (@WO_OWN_RISK_CUST = @IV_ID_CUST_WO)    
    BEGIN    
     IF (SELECT WO_FIXED_PRICE FROM TBL_WO_DETAIL WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_WODET_SEQ = @MIN) = 0    
      BEGIN    
       --select 'upd',@TOT_LAB_VAT , @TOT_GM_VAT  ,@TOT_SP_VAT    
           
       UPDATE TBL_WO_DETAIL    
       SET WO_TOT_VAT_AMT = isnull((@TOT_LAB_VAT + @TOT_GM_VAT + @TOT_SP_VAT),0)    
       WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX    
       AND ID_JOB = @JOB_ID AND ID_WODET_SEQ = @MIN    
      END    
     ELSE    
      BEGIN    
       IF(SELECT WO_INCL_VAT FROM TBL_WO_DETAIL WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_WODET_SEQ = @MIN) = 0    
        BEGIN    
         UPDATE TBL_WO_DETAIL    
         SET WO_TOT_VAT_AMT = isnull((WO_FIXED_PRICE * @FIXED_VAT/100),0)    
         WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX    
         AND ID_JOB = @JOB_ID AND ID_WODET_SEQ = @MIN    
        END    
       ELSE    
        BEGIN    
         UPDATE TBL_WO_DETAIL    
         SET WO_FIXED_PRICE = isnull((WO_FIXED_PRICE + WO_TOT_VAT_AMT),0)    
         WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX    
         AND ID_JOB = @JOB_ID AND ID_WODET_SEQ = @MIN    
             
         UPDATE TBL_WO_DETAIL    
         SET WO_FIXED_PRICE = (WO_FIXED_PRICE / (1 + (@FIXED_VAT/100)))    
         WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX    
         AND ID_JOB = @JOB_ID AND ID_WODET_SEQ = @MIN    
             
         UPDATE TBL_WO_DETAIL    
         SET     
         WO_TOT_VAT_AMT = isnull((WO_FIXED_PRICE * @FIXED_VAT/100),0)    
         WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX    
         AND ID_JOB = @JOB_ID AND ID_WODET_SEQ = @MIN    
        END    
      END    
    END    
       
     
   -----------------    
   SET @MIN = @MIN + 1 -- loop through JOB     
       
   DELETE @TEMP_SPAREPARTDETAILS    
   DELETE #TEMP_JOBDETAILS1    
   DELETE #TEMP_JOBDETAILS2    
  END    
 DROP TABLE #TEMP_JOBDETAILS    
 DROP TABLE #TEMP_JOBDETAILS1    
 DROP TABLE #TEMP_JOBDETAILS2    
 END    
    
     
   ------------------------------------------------------------------------------------------------    
 ---Update the Tbl_mas_Configuration----------              
 IF @@ERROR <> 0                   
 BEGIN                
  SET @0V_RETVALUE = @@ERROR                  
  ROLLBACK TRANSACTION @TranName                
 END                  
 ELSE                
 BEGIN                
  --Update TBL_MAS_WO_CONFIGURATION set WO_CUR_SERIES = @IV_ID_WO_NO              
  --Where GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO           
      
       
  /* 382-d Updating the vehicle cost price and selling price */    
  DECLARE @WO_ORD_TYPE VARCHAR(10)    
  SELECT @WO_ORD_TYPE = WO_TYPE_WOH FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX       
      
  UPDATE TBL_MAS_VEHICLE    
  SET COST_PRICE = @VA_COST_PRICE, SELL_PRICE = @VA_SELL_PRICE     
  WHERE VEH_REG_NO = @IV_WO_VEH_REG_NO1 and ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1 AND @WO_ORD_TYPE = 'CRSL'    
      
  /* Updating the vehicle cost price and selling price */    
      
         
  COMMIT TRANSACTION @TranName                 
  SET @0V_RETVALUE = 'UPDFLG'              
  --SET @0V_RETWONO =  @IV_ID_WO_NO                
 END              
 END TRY                    
 BEGIN CATCH                  
  SET @0V_RETVALUE = @@ERROR --'ERRFLG'                
  ROLLBACK TRANSACTION @TRANNAME                  
 END CATCH          
       
  END     
  ELSE    
  BEGIN  -- ROW 388    
 UPDATE TBL_WO_HEADER SET               
 DT_DELIVERY   = DBO.FN_DATEFORMAT(@ID_DT_DELIVERY) ,              
 WO_TM_DELIV   = @IV_WO_TM_DELIV ,              
 DT_FINISH   = DBO.FN_DATEFORMAT(@ID_DT_FINISH) ,       
 WO_ANNOT    = @IV_WO_ANNOT,    
 LA_DEPT_ACCOUNT_NO = @IV_DEPT_ACCNT_NUM,          
 MODIFIED_BY   = @IV_MODIFIED_BY ,              
 DT_MODIFIED   = GETDATE(),    
 INT_NOTE = @IV_INT_NOTE           
 WHERE ID_WO_NO  = @IV_ID_WO_NO AND              
 ID_WO_PREFIX = @IV_ID_WO_PREFIX       
     
 SET @0V_RETVALUE = 'UPDFLG'        
     
  END    
      
    
END 
GO

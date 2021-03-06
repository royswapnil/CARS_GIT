/****** Object:  StoredProcedure [dbo].[USP_WO_INSERT]    Script Date: 9/22/2017 4:01:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_INSERT]    Script Date: 9/22/2017 4:01:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_INSERT] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                              
* Module : Master                              
* File name : USP_WO_INSERT.PRC                              
* Purpose : To INSERT JOB DETAILS IN WORK ORDER.                               
* Author : M.Thiyagarajan.                              
* Date  : 20.08.2006                              
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
--'* S.No  RFC No/Bug ID   Date        Author     Description                               
--*#0001#         25/04/07   M.Thiyagarajan       Added Station Type                          
--*#0002#         05/05/07   M.Thiyagarajan       Jobwithout Spares                          
--*#0003#      06/02/08   P. Dhanunjaya rao   Bug 4346 for Job Planned Date                           
---TBL_MAS_CUST_CONFIG                            
--'*********************************************************************************'*********************************                              
                              
ALTER PROC [dbo].[USP_WO_INSERT]                                    
(                                                
 @IV_XMLJOBDOC   NTEXT,                          
 @IV_XMLWODOC   NTEXT,                           
 @IV_ID_WODET_SEQ  INT ,                                           
 @IV_ID_WO_NO   VARCHAR(10),                                  
 @IV_ID_WO_PREFIX       VARCHAR(3) ,                                    
 @IV_ID_RPG_CATG_WO     VARCHAR(10) ,                                   
 @IV_ID_RPG_CODE_WO     VARCHAR(10)   ,                                 
 @IV_ID_REP_CODE_WO     INT   ,                                         
 @IV_ID_WORK_CODE_WO    VARCHAR(10) ,                                   
 @IV_WO_FIXED_PRICE     DECIMAL(13,2),                                      
 @IV_ID_JOBPCD_WO       VARCHAR(10) ,                                   
 @IV_WO_PLANNED_TIME    VARCHAR(8) ,                                    
 @IV_WO_HOURLEY_PRICE   DECIMAL(13,2)  ,                                      
 @IV_WO_CLK_TIME        VARCHAR(8) ,                                    
 @IV_WO_CHRG_TIME       VARCHAR(8) ,   --15                                 
 @IV_FLG_CHRG_STD_TIME  BIT   ,                                         
 @IV_WO_STD_TIME        VARCHAR(8) ,                                    
 @IV_FLG_STAT_REQ       INT   ,                                         
 @IV_WO_JOB_TXT         TEXT  ,                                         
 @IV_WO_OWN_RISK_AMT    DECIMAL(15,2)  ,  --20                                    
 @IV_WO_TOT_LAB_AMT     DECIMAL(15,2)  ,                                      
 @IV_WO_TOT_SPARE_AMT   DECIMAL(15,2)  ,   --22                                   
 @IV_WO_TOT_GM_AMT      DECIMAL(15,2)  ,                                      
 @IV_WO_TOT_VAT_AMT     DECIMAL(15,2)  ,  --24                                    
 @IV_WO_TOT_DISC_AMT    DECIMAL(15,2)  ,                                      
 @IV_JOB_STATUS         VARCHAR(10) ,  --26                                 
 @IV_CREATED_BY         VARCHAR(20) ,           
 @IV_DT_CREATED         VARCHAR(10) ,  --28                                 
 @OV_RETVALUE   VARCHAR(15)   OUTPUT ,                          
 @IV_ID_JOB    INT     OUTPUT ,                          
 @IB_WO_OWN_PAY_VAT  BIT   ,       --31                                  
 @ID_WO_DT_PLANNED  VARCHAR(10) ,             
 @IV_XMLDISDOC   NTEXT,                           
 @II_ID_DEF_SEQ   INT    ,                                        
 @IV_TOTALAMT   DECIMAL(15,2),                                    
 @IV_XMLMECHDOC   NTEXT   ,                                    
 @II_ID_MECH_COMP  VARCHAR(10), --37                               
 @IV_WO_OWN_RISK_CUST VARCHAR(10),                                
 @IV_WO_OWN_CR_CUST  VARCHAR(10),                              
 @II_ID_SER_CALLNO  INT,                 
 @II_WO_GM_PER DECIMAL(5,2),                    
 @II_WO_GM_VATPER DECIMAL(5,2),                    
 @II_WO_LBR_VATPER DECIMAL(5,2) ,                  
 @BUS_PEK_CONTROL_NUM VARCHAR(20),                 
 @IV_PKKDATE VARCHAR(50),                
 @WO_INCL_VAT BIT,                
 @WO_DISCOUNT DECIMAL(20,2),                
 @ID_SUBREP_CODE_WO INT,                
 @WO_OWNRISKVAT DECIMAL(13,2),                
 @IV_FLG_SPRSTS  BIT,                
 @SALESMAN VARCHAR(59),                
 @FLG_VAT_FREE BIT,                
 @COST_PRICE DECIMAL(15,2),                
 @WO_FINAL_TOTAL DECIMAL(15,2),                
 @WO_FINAL_VAT DECIMAL(15,2),                
 @WO_FINAL_DISCOUNT DECIMAL(15,2),                
 @ID_JOB INT,                
 @iv_WO_CHRG_TIME_FP VARCHAR(10),                
 @iv_WO_TOT_LAB_AMT_FP DECIMAL(15,2),                
 @iv_WO_TOT_SPARE_AMT_FP DECIMAL(15,2),                
 @iv_WO_TOT_GM_AMT_FP DECIMAL(15,2),                
 @iv_WO_TOT_VAT_AMT_FP DECIMAL(15,2),                
 @iv_WO_TOT_DISC_AMT_FP DECIMAL(15,2),                
 @iv_WO_INT_NOTE VARCHAR(200), --762,                
 @iv_WO_ID_MECHANIC VARCHAR(100) ,        
 @iv_WO_OWN_RISK_DESC VARCHAR(100),      
 @iv_WO_OWN_RISK_SL_NO INT                      
 )                                                
AS                                                
BEGIN                    
 SET XACT_ABORT ON;                                 
 DECLARE @DEPID AS INT                                          
 DECLARE @SUBID AS INT                                                                                   
 DECLARE @OV_JOBNO  AS INT                                                      
 DECLARE @IV_JOBNO  AS INT                                   
 DECLARE @II_ID_SER_CALLNO1 AS INT                                                 
 DECLARE @OV_JOBINSERT AS VARCHAR(10)                                                      
 DECLARE @OV_DEBINSERT AS VARCHAR(10)                                         
 DECLARE @OV_MECINSERT AS VARCHAR(10)                                
 DECLARE @TRANNAME  AS VARCHAR(20)                                    
 DECLARE @IV_ID_JOBPCD_WOTEMP AS VARCHAR(10)                                         
 DECLARE @IV_FLG_STAT_REQ1 AS INT                                 
 DECLARE @IV_JOB_STATUS1    AS VARCHAR(10)                  
 DECLARE @OV_JOBDEBUPDATE AS VARCHAR(10)                       
                 
 --654                
 DECLARE @FLG_VAL_STDTIME  AS VARCHAR(20)                   
 DECLARE @FLG_VAL_MILEAGE  AS VARCHAR(20)                   
 DECLARE @FLG_SAVEUPDDP  AS VARCHAR(20)                   
  DECLARE @FLG_EDTCHRGTIME AS VARCHAR(20)                                      
                                     
 SELECT @TRANNAME = 'WOJOBINS'                             
 SET @II_ID_SER_CALLNO1 = @II_ID_SER_CALLNO                                
 IF  @II_ID_SER_CALLNO = 0                              
  SET @II_ID_SER_CALLNO1 = NULL                                      
  SET @IV_FLG_STAT_REQ1 = @IV_FLG_STAT_REQ                  
                          
 IF  @IV_FLG_STAT_REQ = 0                                        
  SET @IV_FLG_STAT_REQ1 =NULL      
  SELECT @DEPID = ID_DEPT_USER,                          
  @SUBID = ID_SUBSIDERY_USER                                           
  FROM TBL_MAS_USERS                                          
  WHERE ID_LOGIN = @IV_CREATED_BY                  
         
 IF @BUS_PEK_CONTROL_NUM = ''                  
 BEGIN                  
  SET @BUS_PEK_CONTROL_NUM = NULL                  
 END                     
                 
   DECLARE @ORDER_TYPE AS VARCHAR(20)                 
   DECLARE @ORDER_STATUS AS VARCHAR(20)                     
   --CONTRACT STATUS for VA ORDER                
 SELECT @ORDER_TYPE = WO_TYPE_WOH,@ORDER_STATUS=WO_STATUS  FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO  AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                 
                
 --654                
 SELECT @FLG_EDTCHRGTIME = [DESCRIPTION] FROM [dbo].[TBL_MAS_SETTINGS]                      
 WHERE  ID_Config= 'EDTCHGTIME'  and Description <> ''                    
 ORDER BY Description                 
                 
 SELECT @FLG_VAL_STDTIME = [DESCRIPTION] FROM [dbo].[TBL_MAS_SETTINGS]                      
 WHERE  ID_Config= 'VLDSTDTIME'  and Description <> ''                    
 ORDER BY Description                 
                 
 SELECT @FLG_VAL_MILEAGE = [DESCRIPTION] FROM [dbo].[TBL_MAS_SETTINGS]                      
 WHERE  ID_Config= 'VLDMILEAGE'  and Description <> ''                    
 ORDER BY Description                 
                 
 SELECT @FLG_SAVEUPDDP = [DESCRIPTION] FROM [dbo].[TBL_MAS_SETTINGS]                      
 WHERE  ID_Config= 'SAVEUPDDP'  and Description <> ''                    
 ORDER BY Description                 
 --654                
                
                 
 BEGIN TRY                                             
  BEGIN TRANSACTION @TRANNAME                 
                  
   SELECT @IV_JOB_STATUS1 = WO_STATUS                                 
   FROM TBL_WO_HEADER                                
   WHERE   ID_SUBSIDERY = @SUBID                         
   AND  ID_DEPT      = @DEPID                          
   AND  ID_WO_NO     = @IV_ID_WO_NO                                  
   AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                                
                
   IF @IV_JOB_STATUS1 = 'BAR'                                 
    SET @IV_JOB_STATUS = 'BAR'                           
                
   --  QUERY TO GET THE MAXIMUM VALUE                             
   --SELECT @OV_JOBNO = ISNULL(MAX(ISNULL(ID_JOB,0)),0) +1                                                       
   --FROM    TBL_WO_DETAIL                                                      
   --WHERE   ID_WO_NO = @IV_ID_WO_NO                           
   --AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                    
  IF @ID_JOB=0                
         BEGIN                   
            EXEC USP_WO_JOBMAXID  @IV_ID_WO_NO,@IV_ID_WO_PREFIX,@OV_JOBNO                      
               SELECT @OV_JOBNO=isnull(CUST_ID,'0') FROM ##TBL_tmp                    
                DROP TABLE ##tbl_tmp                  
            END                                 
           IF @ID_JOB<>0                
      BEGIN                
		SET @OV_JOBNO=@ID_JOB                
      END                 
                
                         
   SET @IV_ID_JOBPCD_WOTEMP = @IV_ID_JOBPCD_WO                                                 
   IF @IV_ID_JOBPCD_WO = '0'                                           
   BEGIN                                          
    SELECT  @IV_ID_JOBPCD_WOTEMP = ID_SETTINGS                                              
    FROM TBL_MAS_SETTINGS                                              
    WHERE ID_CONFIG = 'HP-JOB-PC'                            
    AND  DESCRIPTION = ''                                          
   END                                
                
   DECLARE @DEPTID AS INT                            
   DECLARE @IDCUST AS VARCHAR(10)                            
   DECLARE @CUSTGROUP AS INT                            
   DECLARE @VEHICLESEQ AS INT                            
   DECLARE @VEHVATCODE AS VARCHAR(10)                            
                
   SET @DEPTID = 0                            
   SET @IDCUST = ''                            
   SET @CUSTGROUP = 0                            
   SET @VEHICLESEQ = 0                            
   SET @VEHVATCODE  = ''                  
              
   DECLARE @VATID INT                
   DECLARE @MAKECODE AS VARCHAR(20)                
   DECLARE @VATCDE AS VARCHAR(20)                
                
   SELECT @VATID = ID_VAT_CD FROM TBL_MAS_VEHICLE,TBL_WO_HEADER WHERE TBL_MAS_VEHICLE.ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO                  
   AND ID_WO_NO = @IV_ID_WO_NO                           
   AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX       
                
   IF @VATID IS NULL                
   BEGIN                
    SELECT @MAKECODE = ID_MAKE_VEH FROM TBL_MAS_VEHICLE,TBL_WO_HEADER WHERE  TBL_MAS_VEHICLE.ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO                  
    AND ID_WO_NO = @IV_ID_WO_NO                           
    AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                 
    SELECT @VATCDE = MAKE_VATCODE FROM TBL_MAS_MAKE WHERE ID_MAKE = @MAKECODE                
    SELECT @VATID = ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE DESCRIPTION  = @VATCDE AND ID_CONFIG = 'VAT'                
   END                
                
   
   SELECT                 
    @DEPTID= ID_DEPT,                          
    @IDCUST= ID_CUST_WO,                          
    @CUSTGROUP = CASE WHEN ID_CUST_WO IS NOT NULL THEN                            
    (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER                           
    WHERE ID_CUSTOMER = TBL_WO_HEADER.ID_CUST_WO)                            
    END,                            
    @VEHICLESEQ = ID_VEH_SEQ_WO,           
    @VEHVATCODE = @VATID                
   FROM TBL_WO_HEADER                             
   WHERE ID_WO_NO = @IV_ID_WO_NO                           
   AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX        
   
   --select @VEHVATCODE = @VATID              
                   
   --Code if the corresponding Vat Account code is not in the  tbl_mas_vehicle                          
   IF LTRIM(RTRIM(@VEHVATCODE)) = '' OR @VEHVATCODE IS NULL                          
   BEGIN                          
    SET @OV_RETVALUE = 'VEHVAT'  --Corresponding Vehicle VAT Code is not present in tbl_mas_vehicle 
    ROLLBACK TRANSACTION @TRANNAME                                   
    RETURN 1          
                
   END          
   
                   
   --coding to fetch the garage material account code and vat code                             
   DECLARE @VATCODE AS VARCHAR(10)                            
   DECLARE @GMACCOUNTCODE AS VARCHAR(20)                            
                
   SELECT                 
    @VATCODE = ISNULL(ID_VAT,''),                          
    @GMACCOUNTCODE = ISNULL(GP_ACCCODE,'')                            
   FROM TBL_MAS_CUST_GRP_GM_PRICE_MAP                           
 WHERE ID_DEPT =  @DEPTID                            
   AND  ID_CUST_GRP_SEQ = @CUSTGROUP                    
   AND GETDATE()  BETWEEN  DT_EFF_FROM AND DT_EFF_TO                     
   DECLARE @VATPER AS DECIMAL                            
   DECLARE @VATACCOUNTCODE AS VARCHAR(20)                            
                
   SET @VATPER = 0                            
   SET @VATACCOUNTCODE = ''                            
                
   SELECT @VATPER = ISNULL(VAT_PER,0),                          
   @VATACCOUNTCODE= ISNULL(VAT_ACCCODE,'')                           
   FROM TBL_VAT_DETAIL                            
   WHERE VAT_CUST = (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP                           
   WHERE ID_CUST_GRP_SEQ = @CUSTGROUP)                            
   AND  VAT_VEH = @VEHVATCODE                            
   AND  VAT_ITEM = @VATCODE                    
   AND GETDATE()  BETWEEN  DT_EFF_FROM AND DT_EFF_TO                     
                
   IF LTRIM(RTRIM(@VATCODE)) = ''                           
    SET @VATCODE = NULL                        
                       
   IF LTRIM(RTRIM(@GMACCOUNTCODE)) = ''                           
    SET @GMACCOUNTCODE = NULL                      
                         
   IF LTRIM(RTRIM(@VATACCOUNTCODE)) = ''                           
    SET @VATACCOUNTCODE = NULL                           
    DECLARE @WO_FLG_PLND  AS BIT                  
                   
                   
   DECLARE @WO_TYPE VARCHAR(20)         
   SELECT @WO_TYPE = WO_TYPE_WOH FROM TBL_WO_HEADER                 
   WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX                
                    
                            
   IF @ID_WO_DT_PLANNED IS NOT NULL                           
    SET @WO_FLG_PLND = 'TRUE'                
   BEGIN                          
    INSERT INTO TBL_WO_DETAIL                                                        
    (                           
     ID_WO_NO,  ID_WO_PREFIX,  ID_JOB,                                                      
     ID_RPG_CATG_WO, ID_RPG_CODE_WO,  ID_REP_CODE_WO,                          
     ID_WORK_CODE_WO,WO_FIXED_PRICE,  ID_JOBPCD_WO,                          
     WO_STD_TIME, WO_PLANNED_TIME,    WO_HOURLEY_PRICE,                          
     WO_CLK_TIME, WO_CHRG_TIME,  FLG_CHRG_STD_TIME,                          
     ID_STYPE_WO, WO_JOB_TXT,   WO_OWN_RISK_AMT,                          
     WO_TOT_LAB_AMT, WO_TOT_SPARE_AMT,   WO_TOT_GM_AMT,                          
     WO_TOT_VAT_AMT, WO_TOT_DISC_AMT, JOB_STATUS,                                                      
     CREATED_BY,  DT_CREATED,   WO_OWN_PAY_VAT,                          
     DT_PLANNED,  ID_MECH_COMP,  WO_OWN_RISK_CUST,                                    
     WO_OWN_CR_CUST, ID_SERV_CALL,  WO_GM_VAT,                          
     WO_GM_ACCCODE, WO_VAT_ACCCODE,  WO_VAT_PERCENTAGE  ,                          
     WO_FLG_PLANNED,     -- Bug 4346                    
     WO_GM_PER,WO_GM_VATPER,WO_LBR_VATPER                    
     ,WO_INCL_VAT                 
     ,WO_DISCOUNT                
     ,ID_SUBREP_CODE_WO                 
     ,OwnRiskVATAmt                
     ,USERNAME                
     ,WO_FLG_EDIT                
     ,FLG_SPRSTATUS                
     ,SALESMAN                
     ,FLG_VAT_FREE                
     ,COST_PRICE                
     ,WO_FINAL_TOTAL                
     ,WO_FINAL_VAT                
     ,WO_FINAL_DISCOUNT                
     ,WO_CHRG_TIME_FP                
     ,WO_TOT_LAB_AMT_FP                
     ,WO_TOT_SPARE_AMT_FP                
     ,WO_TOT_GM_AMT_FP                
     ,WO_TOT_VAT_AMT_FP                
     ,WO_TOT_DISC_AMT_FP                
     ,FLG_VAL_STDTIME                
     ,FLG_VAL_MILEAGE                
     ,FLG_SAVEUPDDP                
     ,FLG_EDTCHGTIME                
     ,WO_INT_NOTE          
     ,ID_MECHANIC          
     ,WO_OWN_RISK_DESC      
     ,WO_OWN_RISK_SL_NO                       
    )                                               
    VALUES                                                        
    (                                                        
     @IV_ID_WO_NO,  @IV_ID_WO_PREFIX, @OV_JOBNO,                                                      
     @IV_ID_RPG_CATG_WO, @IV_ID_RPG_CODE_WO, @IV_ID_REP_CODE_WO,                          
     @IV_ID_WORK_CODE_WO,@IV_WO_FIXED_PRICE, @IV_ID_JOBPCD_WOTEMP,                          
     @IV_WO_STD_TIME, @IV_WO_PLANNED_TIME,@IV_WO_HOURLEY_PRICE,                          
     @IV_WO_CLK_TIME, @IV_WO_CHRG_TIME, @IV_FLG_CHRG_STD_TIME,                          
     @IV_FLG_STAT_REQ1, @IV_WO_JOB_TXT,  @IV_WO_OWN_RISK_AMT,                          
     @IV_WO_TOT_LAB_AMT, @IV_WO_TOT_SPARE_AMT, @IV_WO_TOT_GM_AMT,                          
     @IV_WO_TOT_VAT_AMT, @IV_WO_TOT_DISC_AMT, @IV_JOB_STATUS,                                                      
    @IV_CREATED_BY,  GETDATE(),   @IB_WO_OWN_PAY_VAT,                          
     DBO.FN_DATEFORMAT(@ID_WO_DT_PLANNED), @II_ID_MECH_COMP, @IV_WO_OWN_RISK_CUST,                          
     @IV_WO_OWN_CR_CUST, @II_ID_SER_CALLNO1, @VATCODE,                          
     @GMACCOUNTCODE,  @VATACCOUNTCODE,                
     CASE WHEN @WO_TYPE = 'CRSL' THEN  -- ROW 533                
      CASE WHEN ISNULL(@FLG_VAT_FREE,0) = 1 THEN                 
       0                
      ELSE                
       @II_WO_GM_VATPER                
      END                
     ELSE                
       @II_WO_GM_VATPER                
     END                 
     ,                
                     
     @WO_FLG_PLND,       -- Bug 4346                                        
     @II_WO_GM_PER,@II_WO_GM_VATPER,@II_WO_LBR_VATPER                    
     ,@WO_INCL_VAT                 
     ,@WO_DISCOUNT                
     ,@ID_SUBREP_CODE_WO                 
     ,@WO_OWNRISKVAT                
     ,Null                
     ,0                
     ,@IV_FLG_SPRSTS                
     ,@SALESMAN                
     ,@FLG_VAT_FREE                
     ,@COST_PRICE                
     ,@WO_FINAL_TOTAL                
     ,@WO_FINAL_VAT                
     ,@WO_FINAL_DISCOUNT                
     ,@iv_WO_CHRG_TIME_FP                
     ,@iv_WO_TOT_LAB_AMT_FP                
     ,@iv_WO_TOT_SPARE_AMT_FP                
     ,@iv_WO_TOT_GM_AMT_FP                
     ,@iv_WO_TOT_VAT_AMT_FP                
     ,@iv_WO_TOT_DISC_AMT_FP                
     ,@FLG_VAL_STDTIME                
     ,@FLG_VAL_MILEAGE                
     ,@FLG_SAVEUPDDP                
     ,@FLG_EDTCHRGTIME                
     ,@iv_WO_INT_NOTE          
     ,@iv_WO_ID_MECHANIC           
     ,@iv_WO_OWN_RISK_DESC      
     ,@iv_WO_OWN_RISK_SL_NO              
    )                 
   END                   
                   
                          
   IF @@ERROR <> 0                                                                 
   BEGIN                                                      
    SET @OV_RETVALUE = @@ERROR                                                    
    --  ROLLBACK TRANSACTION @TRANNAME                                                              
   END                                        
   ELSE                                                        
   BEGIN                            
    SET @OV_RETVALUE = 'INSFLG'                 
                            
    --PROCEDURE TO INSERT THE JOB DETAILS                                                      
    SELECT  @IV_ID_WODET_SEQ=ID_WODET_SEQ                                               
    FROM    TBL_WO_DETAIL                                               
    WHERE   ID_WO_NO = @IV_ID_WO_NO                                         
    AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                                                      
    AND  ID_JOB = @OV_JOBNO                                                    
                
    IF  @IV_XMLJOBDOC IS NOT NULL                                      
    BEGIN                      
     IF @IV_CREATED_BY<>'VA_EXV_AUTOCREATE'  --ADDED TO SKIP PROCEDURE CALL ON AUTO CREATE FROM VA                                   
      EXEC USP_WO_JOBDETAIL_INSERT @IV_XMLJOBDOC, @IV_ID_WODET_SEQ, @IV_CREATED_BY,                                              
      @IV_ID_WO_NO, @IV_ID_WO_PREFIX, @OV_JOBINSERT OUTPUT                             
                
      SELECT @OV_JOBINSERT  , 'Dhanunjj'                          
     IF @OV_JOBINSERT <> '0'                                                      
     BEGIN                    
      SET @OV_RETVALUE = @OV_JOBINSERT  --Corresponding Vehicle VAT Code is not present in tbl_mas_vehicle                                
      ROLLBACK TRANSACTION @TRANNAME                                   
      RETURN 1                                                        
     END                                       
    END                            
    EXEC USP_WO_DEBITORDETIAL_INSERT @IV_XMLWODOC, @IV_ID_WO_PREFIX, @OV_JOBNO, @IV_ID_WO_NO,                                              
    @IV_CREATED_BY, @IV_WO_OWN_RISK_AMT, @IV_TOTALAMT, @OV_DEBINSERT OUTPUT                               
                                     
    IF @OV_DEBINSERT <> '0'                                                      
    BEGIN                              
     SET @OV_RETVALUE = @@ERROR                                                     
     --ROLLBACK TRANSACTION @TRANNAME                                                           
    END                                                      
    ELSE                  
     EXEC [USP_WO_SPARESDEBITOR_UPDATE] @IV_ID_WO_NO, @IV_ID_WO_PREFIX, @OV_JOBNO, @OV_JOBDEBUPDATE OUTPUT                  
                     
    IF @OV_JOBDEBUPDATE <> '0'                
    BEGIN                
     SET @OV_RETVALUE = @@ERROR                   
    END                
    ELSE                
    BEGIN                               
     IF  @IV_XMLDISDOC IS NOT NULL                                         
     BEGIN                                         
      EXEC USP_WO_JOB_DEBITOR_DISCOUNT_INSERT @IV_XMLDISDOC, @IV_ID_WO_NO,                           
      @IV_ID_WO_PREFIX, @OV_JOBNO, @OV_DEBINSERT OUTPUT                                                    
      IF @OV_DEBINSERT <> '0'                                     
      BEGIN                                                      
       SET @OV_RETVALUE = @@ERROR                                                     
      END                                      
     END                                                      
                
     BEGIN             
     EXEC USP_VEH_DEFECT_DET @IV_ID_WO_PREFIX, @IV_ID_WO_NO,                           
     @II_ID_DEF_SEQ, @IV_CREATED_BY, @OV_DEBINSERT OUTPUT                                               
     IF @OV_DEBINSERT <> '0'                                                      
     BEGIN                                                      
      SET @OV_RETVALUE = @@ERROR                                                     
     END                                                  
     ELSE                                        
     BEGIN                          
      IF @IV_XMLMECHDOC IS NOT NULL                                        
      BEGIN                                  
       EXEC USP_WO_InsertMech @IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_CREATED_BY,                          
       @OV_JOBNO,@IV_XMLMECHDOC,@OV_MECINSERT  OUTPUT                                 
       -- SELECT @OV_MECINSERT                                   
       IF @OV_MECINSERT <> '0'                                                      
       BEGIN                                              
        SET @OV_RETVALUE = @@ERROR                                                     
        --ROLLBACK TRANSACTION @TRANNAME                                                  
       END                                          
      END                                           
     END                          
     BEGIN                 
      DECLARE @Temp_Wo_Status as varchar(10)                          
      SET @Temp_Wo_Status=(SELECT DBO.FN_WO_STATUS(@IV_ID_WO_PREFIX ,@IV_ID_WO_NO))                          
      --Change end by Manoj K                          
      UPDATE TBL_WO_HEADER                                  
      SET  WO_STATUS=(SELECT DBO.FN_WO_STATUS(@IV_ID_WO_PREFIX,@IV_ID_WO_NO))                                   
      ,BUS_PEK_CONTROL_NUM  = @BUS_PEK_CONTROL_NUM                       
      ,WO_PKKDATE=@IV_PKKDATE                
      WHERE ID_SUBSIDERY = @SUBID                                   
      AND  ID_DEPT      = @DEPID                                  
      AND  ID_WO_NO     = @IV_ID_WO_NO                                  
      AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                                   
      AND  WO_STATUS <> 'BAR'                            
      AND  @Temp_Wo_Status <> ''                                      
                
      IF @II_ID_SER_CALLNO > 0                               
      BEGIN                          
       UPDATE TBL_MAS_SP_GENERATECALL                              
       SET  WO_SERV_STATUS = 1                              
       WHERE ID_CALLNO = @II_ID_SER_CALLNO                              
      END                           
                
      set @OV_RETVALUE = 'INSFLG'                            
      COMMIT TRANSACTION  @TRANNAME                                                
     END                                
    END -- END FOR DEBITOR DISCOUNT INSERT                                               
   END     -- END FOR SECOND  FOR WORK ORDER JOB DETAIL                            
  END -- END FOR FIRST ELSE WORK ORDER                        
      
       exec USP_WO_DEBITOR_INVOICEDATA_INSERT @IV_ID_WO_PREFIX,@ID_JOB,@IV_ID_WO_NO,@IV_CREATED_BY                    
    
      
                
 UPDATE TBL_WO_DETAIL                 
 SET                 
  LUNCH_WITHDRAW = DEPT.LUNCH_WITHDRAW,                
  FROM_TIME = DEPT.FROM_TIME,                
  TO_TIME = DEPT.TO_TIME                 
 FROM                 
  TBL_MAS_DEPT DEPT                
 WHERE                   
 DEPT.ID_DEPT = @DEPID AND                
  ID_WO_NO = @IV_ID_WO_NO  AND                  
  ID_WO_PREFIX = @IV_ID_WO_PREFIX AND                     
  ID_JOB = @OV_JOBNO                 
                  
                    
   DECLARE @USE_MANUAL_RWRK AS BIT                 
   SELECT @USE_MANUAL_RWRK = USE_MANUAL_RWRK                 
   FROM                 
   TBL_MAS_WO_CONFIGURATION                
   WHERE                 
   ID_SUBSIDERY_WO = @SUBID AND                 
   ID_DEPT_WO  = @DEPTID  AND                
   DT_EFF_TO > getdate()                
                     
  IF @USE_MANUAL_RWRK = 0                
     BEGIN                
                  
         DECLARE @IV_WODET_SEQ_JOB AS INT                
         DECLARE @STA AS VARCHAR(10)                
         DECLARE @FLG_SPRSTS AS VARCHAR(3)                
                         
          SELECT @IV_WODET_SEQ_JOB = ID_WODET_SEQ FROM TBL_WO_DETAIL                 
    WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX                 
    AND ID_JOB=@OV_JOBNO                
                    
    --select '@OV_JOBNO',@OV_JOBNO,@IV_WODET_SEQ_JOB                
                    
    SELECT @STA = JOB_STATUS FROM TBL_WO_DETAIL                 
    WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX                 
    AND ID_JOB=@OV_JOBNO and ID_WODET_SEQ =@IV_WODET_SEQ_JOB                  
                   
       SELECT @FLG_SPRSTS = FLG_SPRSTATUS FROM TBL_WO_DETAIL                 
    WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX                 
    AND ID_JOB=@OV_JOBNO and ID_WODET_SEQ =@IV_WODET_SEQ_JOB                
                     
      IF @STA = 'CSA'  OR @STA = 'RWRK'                
      BEGIN                
         IF @FLG_SPRSTS = '1'                
         BEGIN                
            UPDATE TBL_WO_DETAIL                
         SET JOB_STATUS = 'CSA'                
      WHERE ID_WODET_SEQ = @IV_WODET_SEQ_JOB                
         END                
              ELSE                
              BEGIN                
                      
                       
    DECLARE @STOCKITEM AS INT                
    DECLARE @TOTALCNT AS INT                
    DECLARE @BOJQTY AS INT                 
    DECLARE @RSTATUSCOUNT INT, @WOJOBCOUNT INT                
                     
                
     SELECT @TOTALCNT = COUNT(WOJ.ID_WODET_SEQ_JOB) FROM TBL_MAS_ITEM_MASTER MSTR                
     INNER JOIN TBL_WO_JOB_DETAIL WOJ                 
     ON MSTR.ID_ITEM = WOJ.ID_ITEM_JOB                 
     AND MSTR.ID_ITEM_CATG = WOJ.ID_ITEM_CATG_JOB                
     AND MSTR.ID_WH_ITEM = WOJ.ID_WAREHOUSE            
     WHERE  WOJ.ID_WO_NO = @IV_ID_WO_NO AND WOJ.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WOJ.ID_WODET_SEQ_JOB=@IV_WODET_SEQ_JOB                
                 
                 
    SELECT @STOCKITEM =COUNT(FLG_STOCKITEM) FROM TBL_MAS_ITEM_MASTER MSTR                
    INNER JOIN TBL_WO_JOB_DETAIL WOJ                 
    ON MSTR.ID_ITEM = WOJ.ID_ITEM_JOB                 
    AND MSTR.ID_ITEM_CATG = WOJ.ID_ITEM_CATG_JOB                
    AND MSTR.ID_WH_ITEM = WOJ.ID_WAREHOUSE                
    WHERE  WOJ.ID_WO_NO = @IV_ID_WO_NO AND WOJ.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WOJ.ID_WODET_SEQ_JOB=@IV_WODET_SEQ_JOB AND MSTR.FLG_STOCKITEM = 1                
                       
                
                             
     SELECT @BOJQTY= SUM(JOBI_BO_QTY)                     
     FROM TBL_WO_JOB_DETAIL JOB WHERE ID_WO_NO = @IV_ID_WO_NO                       
      AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                 
      AND ID_WODET_SEQ_JOB = @IV_WODET_SEQ_JOB                   
      GROUP BY ID_WODET_SEQ_JOB                
                                
                      
    --SELECT @BOQTY= SUM(JOBI_BO_QTY)                     
    --FROM TBL_WO_JOB_DETAIL JOB WHERE ID_WO_NO = @IV_ID_WO_NO                       
    --     AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                 
    --            GROUP BY ID_WO_NO,ID_WO_PREFIX                
                
                          
                
                         
    SET @BOJQTY =ISNULL(@BOJQTY,0)                
    --SET @BOQTY =ISNULL(@BOQTY,0)                
                    
    --IF @BOQTY  = 0                 
    -- BEGIN                   
    -- --select '@BOQTY',@BOQTY                              
    --  UPDATE TBL_WO_HEADER                
    --  SET WO_STATUS = 'RWRK'                
    --  WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX =@IV_ID_WO_PREFIX                
    -- END                
    --select '@TOTALCNT',@TOTALCNT,@STOCKITEM                
                     
      IF @TOTALCNT = @STOCKITEM                 
      BEGIN                
     --select '@@BOJQTY1',@BOJQTY,@IV_WODET_SEQ_JOB                
         IF @BOJQTY = 0                
           BEGIN                
           IF ISNULL(@IV_WODET_SEQ_JOB,0) = 0                
           BEGIN                
            UPDATE TBL_WO_DETAIL                
         SET JOB_STATUS = 'RWRK'            WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                
           END                
           ELSE                
BEGIN                
                
            UPDATE TBL_WO_DETAIL                
         SET JOB_STATUS = 'RWRK'                
      WHERE ID_WODET_SEQ = @IV_WODET_SEQ_JOB                
           END                
                             
           END                
          ELSE                
     BEGIN                
      UPDATE TBL_WO_DETAIL                
      SET JOB_STATUS = 'CSA'                
      WHERE ID_WODET_SEQ = @IV_WODET_SEQ_JOB                
     END                
       END                
      END                
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
    AND WO_STATUS<>'BAR'                
       --END                
     
     END                                  
   IF @ORDER_TYPE ='CRSL'                
   BEGIN                
    UPDATE TBL_WO_DETAIL                
    SET JOB_STATUS = 'CON'                
    WHERE ID_WODET_SEQ = @IV_WODET_SEQ_JOB                
                    
    --UPDATE TBL_WO_HEADER                                
    --SET WO_STATUS  = 'CON'                
    --WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                
                    
    IF @ORDER_STATUS ='CON' OR @ORDER_STATUS ='STR'                
    BEGIN                 
     UPDATE TBL_WO_HEADER                                
     SET WO_STATUS  = @ORDER_STATUS                
     WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                
    END                
   END                
                   
                                      
 END TRY                                          
 BEGIN CATCH                    
  SELECT ERROR_MESSAGE()                                    
  SELECT @OV_RETVALUE = 'ERRFLG'                   
  ROLLBACK TRANSACTION @TRANNAME                                        
 END CATCH                              
END -- END  FOR PROCEDURE                                             
/**                                     
                          
--BEGIN TRAN                          
DECLARE  @OV_RETVALUE   VARCHAR(15)                             
DECLARE  @IV_ID_JOB    INT                               
exec USP_WO_INSERT                                                  
'<root><insert ID_ITEM_JOB="0000000000" ID_MAKE_JOB="105" ID_ITEM_CATG_JOB="" JOBI_ORDER_QTY="2" JOBI_DELIVER_QTY="1" JOBI_BO_QTY="0" JOBI_DIS_PER="0" JOBI_VAT_PER="0" ORDER_LINE_TEXT="" JOBI_SELL_PRICE="2.00"/></root>',                          
'<root><insert ID_DETAIL="1040" DEBITOR_TYPE="C" DBT_AMT="4" DBT_PER="100"/></root>',                          
1,'182','WOT',                          
'514','112',13,                          
'759',0,'0',                          
'0',0,'',                          
'0','False','1:00',                          
0,'Sample Test',                          
0,0,4,0,0,0,                          
'CSA','admin','12/18/2007 1:09:09 PM',                          
@OV_RETVALUE output,@IV_ID_JOB output,                          
'False','12:00:00 AM',                          
'<root><insert ID_DEBTOR="1040" ID_ITEM="0000000000" DBT_VAT_AMOUNT="0" DBT_DIS_AMT="0" JOB_VAT_PER="0" JOB_VAT_SEQ="32" JOB_DIS_SEQ="108" JOB_DIS_PER="0"/></root>',                          
0,4,NULL,Null,Null,Null,0                          
SELECT @OV_RETVALUE,@IV_ID_JOB,'Dhanu completed'                          
--ROLLBACK TRAN                          
                          
*/                             
                          
                          
--DECLARE  @OV_RETVALUE   VARCHAR(15)                             
--DECLARE  @IV_ID_JOB    INT                               
--exec USP_WO_INSERT                          
--'<root><insert ID_ITEM_JOB="20" ID_MAKE_JOB="Mercedes" ID_ITEM_CATG_JOB="" JOBI_ORDER_QTY="67"                           
--JOBI_DELIVER_QTY="50" JOBI_BO_QTY="0" JOBI_DIS_PER="20.00;0.00" JOBI_VAT_PER="false" ORDER_LINE_TEXT=""                           
--JOBI_SELL_PRICE="250"/></root>',                          
--'<root><insert ID_DETAIL="999" DEBITOR_TYPE="C" DBT_AMT="5307.74" DBT_PER="34"/>                          
--<insert ID_DETAIL="1005" DEBITOR_TYPE="D" DBT_AMT="3746.64" DBT_PER="24"/></root>',                          
--'1','274','onu','','','1','170','0','0','0','0','','0','true','','0','','0','0','16750','0','0','1139','CSA','admin',                          
--'4/2/2008 10:46:15 AM',@OV_RETVALUE output,@IV_ID_JOB output,'false','',                          
--'<root><insert ID_DEBTOR="999" ID_ITEM="20" DBT_VAT_AMOUNT="0" DBT_DIS_AMT="0" JOB_VAT_PER="0.000"                           
--JOB_VAT_SEQ="0" JOB_DIS_SEQ="2" JOB_DIS_PER="20.00"/>                          
--<insert ID_DEBTOR="1005" ID_ITEM="20" DBT_VAT_AMOUNT="0" DBT_DIS_AMT="0" JOB_VAT_PER="0.000"                           
--JOB_VAT_SEQ="0" JOB_DIS_SEQ="0" JOB_DIS_PER="0.00"/></root>',                          
--'0','15611','','','','','0'                          
--SELECT @OV_RETVALUE,@IV_ID_JOB,'Manoj completed' 
GO

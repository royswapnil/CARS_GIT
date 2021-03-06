/****** Object:  StoredProcedure [dbo].[USP_WO_DETAILS_UPDATE]    Script Date: 3/30/2017 11:52:12 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DETAILS_UPDATE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DETAILS_UPDATE]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DETAILS_UPDATE]    Script Date: 3/30/2017 11:52:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DETAILS_UPDATE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DETAILS_UPDATE] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                                                                  
* Module : Work Order                                                                   
* File name : USP_WO_DETAILS_UPDATE.PRC                                                                  
* Purpose : To UPDATE WORK ORDER DETAILS IN WO DETAILS                                                                
* Author : THIYAGARAJAN /SUBRAMANIAN                                                                  
* Date  : 16.09.2006                                                                  
*********************************************************************************************************************/                                                                  
/*********************************************************************************************************************                                                                    
I/P : -- Input Parameters                                                                  
 @iv_xmlDoc - Valid XML document contaning values to be UPDATE                                                                  
                                                                  
O/P : -- Output Parameters                                                                  
 @OV_RETVALUE - 'INSFLG' if error, 'OK' otherwise                                                                  
 @ov_CannotDelete - List of configuration items which cannot be inserted as they already exists.                                                                  
                                                                  
Error Code                                                                  
Description                                                   
INT.VerNO : NOV21.0                                                                   
********************************************************************************************************************/                                                                  
--'*********************************************************************************'*********************************                                                                  
--'* Modified History :                                                                     
--'* S.No  RFC No/Bug ID   Date        Author    Description                                                                   
--* #0001#  2015           02/03/2007    M.Thiyagarajan                                                  
--* #0002#       09/03/2007    M.Thiyagarajan @id_WO_DT_PLANNED   datatype has been chnaged from varchar(10) to        datetime                                                  
--* #0003# 4197   04/11/2008 S.Sudhakar Modified Station type filed to update                                    
--'*********************************************************************************'*********************************                                                                  
ALTER PROC [dbo].[USP_WO_DETAILS_UPDATE]                                                                    
(                                    
 @IV_XMLJOBDOC  NTEXT,                                                   
 @IV_XMLWODOC  NTEXT,                                                    
 @IV_ID_WODET_SEQ INT,                                                   
 @IV_ID_WO_NO   VARCHAR(10),                                                  
 @IV_ID_WO_PREFIX      VARCHAR(3),                                                                          
 @IV_ID_RPG_CATG_WO    VARCHAR(10),                                                                          
 @IV_ID_RPG_CODE_WO    VARCHAR(10),                                                   
 @IV_ID_REP_CODE_WO    INT,           
 @IV_ID_WORK_CODE_WO   VARCHAR(10),                                                
 @IV_WO_FIXED_PRICE    DECIMAL(15,2),         
 @IV_ID_JOBPCD_WO      VARCHAR(10),                                    
 @IV_WO_PLANNED_TIME   VARCHAR(8),                                                          
 @IV_WO_HOURLEY_PRICE  DECIMAL(15,2),                                                                          
 @IV_WO_CLK_TIME       VARCHAR(8),                                                                          
 @IV_WO_CHRG_TIME      VARCHAR(8),                                                                          
 @IV_FLG_CHRG_STD_TIME BIT,                                                                          
 @IV_WO_STD_TIME       VARCHAR(8),                                                                          
 @IV_FLG_STAT_REQ      INT,                                                                          
 @IV_WO_JOB_TXT    TEXT,                                                                          
 @IV_WO_OWN_RISK_AMT   DECIMAL(15,2),                                                                          
 @IV_WO_TOT_LAB_AMT    DECIMAL(15,2),                                                                 
 @IV_WO_TOT_SPARE_AMT  DECIMAL(15,2),                                                  
 @IV_WO_TOT_GM_AMT     DECIMAL(15,2),                                                                          
 @IV_WO_TOT_VAT_AMT    DECIMAL(15,2),                                            
 @IV_WO_TOT_DISC_AMT   DECIMAL(15,2),                                                       
 @IV_JOB_STATUS        VARCHAR(10),                                                                          
 @IV_MODIFIED_BY       VARCHAR(20),                                                                          
 @IV_DT_MODIFIED       VARCHAR(30),                                                                          
 @IV_ID_JOB    INT,                                                                    
 @OV_RETVALUE   VARCHAR(10)   OUTPUT    ,                                                                
 @IV_XMLDISDOC   NTEXT,                                                    
 @ID_WO_DT_PLANNED  VARCHAR(10),                                                            
 @IV_TOTALAMT   DECIMAL(15,2)    ,                                          
 @IV_XMLMECHDOC   NTEXT   ,                                                              
 @IB_WO_OWN_PAY_VAT  BIT        ,                                                            
 @II_ID_DEF_SEQ   INT ,                                                          
 @II_ID_MECH_COMP  VARCHAR(10) ,                                                    
 @IV_WO_OWN_RISK_CUST VARCHAR(10),                                                    
 @IV_WO_OWN_CR_CUST  VARCHAR(10),                                                  
 @II_ID_SER_CALLNO  INT,                                                 
 @II_WO_GM_PER DECIMAL(5,2),                                                
 @II_WO_GM_VATPER DECIMAL(5,2),                                                
 @II_WO_LBR_VATPER DECIMAL(5,2),                                                     
 @BUS_PEK_CONTROL_NUM VARCHAR(20)                                                
 ,@IV_PKKDATE VARCHAR(50)                                           
 ,@WO_INCL_VAT BIT                                        
 ,@WO_DISCOUNT DECIMAL(20,2)                                        
 ,@ID_SUBREP_CODE_WO INT                                         
 ,@WO_OWNRISKVAT DECIMAL(15,2)                                    
 ,@IV_FLG_SPRSTS  BIT                                    
 ,@SALESMAN VARCHAR(59)                                    
 ,@FLG_VAT_FREE BIT                                    
 ,@COST_PRICE DECIMAL(15,2)                                    
 ,@WO_FINAL_TOTAL DECIMAL(15,2)                                    
 ,@WO_FINAL_VAT DECIMAL(15,2)                                    
 ,@WO_FINAL_DISCOUNT DECIMAL(15,2)                                    
 ,@iv_WO_CHRG_TIME_FP VARCHAR(10),                                    
 @iv_WO_TOT_LAB_AMT_FP DECIMAL(15,2),                                    
 @iv_WO_TOT_SPARE_AMT_FP DECIMAL(15,2),                                    
 @iv_WO_TOT_GM_AMT_FP DECIMAL(15,2),                       
 @iv_WO_TOT_VAT_AMT_FP DECIMAL(15,2),                                    
 @iv_WO_TOT_DISC_AMT_FP DECIMAL(15,2),                                    
 @iv_WO_INT_NOTE VARCHAR(200), --762                
 @iv_WO_ID_MECHANIC VARCHAR(100),            
 @iv_WO_OWN_RISK_DESC VARCHAR(100),          
 @iv_WO_OWN_RISK_SL_NO INT                                     
 )                                                                                         
AS                                  
BEGIN                                          
                                    
 SET XACT_ABORT ON                                    
 --changes as per new jobdetails page 4.5                                  
 DECLARE @docHandle int                      
                                      
 EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_XMLMECHDOC                                              
      Declare @INSERT_LIST Table                                          
      (                            
    ID_RANK INT,                                         
    LineType VARCHAR(20)                                     
   )                                           
     INSERT INTO @INSERT_LIST                                          
       Select ROW_NUMBER() OVER (ORDER BY LineType), LineType                                      
       FROM OPENXML (@docHandle,'root/insert',1) with                                             
    (                              
    ID_RANK INT,                                          
       LineType VARCHAR(20)                                   
    )                  
    where  LineType <> 'LT'                  
                                              
    EXEC SP_XML_REMOVEDOCUMENT @docHandle                                  
                                      
                                      
                                      
    EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_XMLMECHDOC                         
      Declare @LABOURDET_LIST Table                                          
      (                              
      ROWID  INT,                                          
      ID_MECH VARCHAR(20) ,                                  
      ID_WOLAB_SEQ INT,                                  
      LabourDesc VARCHAR(100),                                  
      Wo_Lab_Hrs decimal(9,2),                                  
      HourlyPr   decimal(9,2),                    
      WO_Lab_Discount Decimal(13,2),                  
      LineType VARCHAR(20),              
      SL_NO INT                  
   )                                           
       INSERT INTO @LABOURDET_LIST                                          
       Select ROW_NUMBER() OVER (ORDER BY ID_MECH),ID_MECH, ID_WOLAB_SEQ ,LabourDesc,Wo_Lab_Hrs, HourlyPr,WO_Lab_Discount,LineType,Id_Sl_No                                    
       FROM OPENXML (@docHandle,'root/insert',1) with                                             
    (                               
   ROWID INT,                                         
   ID_MECH VARCHAR(20) ,                                  
   ID_WOLAB_SEQ INT,                                  
   LabourDesc VARCHAR(100),                                   
   Wo_Lab_Hrs DECIMAL(9,2),                                  
   HourlyPr DECIMAL(9,2),                    
   WO_Lab_Discount Decimal(13,2),                  
   LineType VARCHAR(20),              
   Id_Sl_No INT                                       
    )                  
    where  LineType <> 'LT'                                          
    EXEC SP_XML_REMOVEDOCUMENT @docHandle                                  
           
                                   
  ---changes as per new jobdetails page 4.5                                              
 DECLARE @LINE_TYPE as varchar(10)                                  
 DECLARE @ID_MECH AS VARCHAR(10)                                  
 DECLARE @ID_WOLAB_SEQ INT                                  
 DECLARE @OV_JOBNO   AS INT                                                                         
 DECLARE @IV_JOBNO   AS INT                                                                                  
 DECLARE @OV_JOBUPDATE  AS VARCHAR(10)                                                           
 DECLARE @OV_DEBUPDATE  AS VARCHAR(10)                                                                         
 DECLARE @OV_DEBDISUPDATE AS VARCHAR(10)                                               
 DECLARE @OV_DEFUPDATE AS VARCHAR(10)                                                   
 DECLARE @IV_ID_JOBPCD_WOTEMP AS VARCHAR(10)                                                                  
 DECLARE @TRANNAME AS VARCHAR(20)                                            
 DECLARE @OV_MECUPDERT AS VARCHAR(10)                                         
 DECLARE @OV_JOBDEBUPDATE AS VARCHAR(10)                                      
 DECLARE @ORDER_TYPE AS VARCHAR(20)                                              
                                      
 --654                                    
 DECLARE @FLG_VAL_STDTIME  AS VARCHAR(20)             
 DECLARE @FLG_VAL_MILEAGE  AS VARCHAR(20)                                       
 DECLARE @FLG_SAVEUPDDP  AS VARCHAR(20)                                       
  DECLARE @FLG_EDTCHRGTIME AS VARCHAR(20)                                                    
                                                          
 DECLARE @IV_FLG_STAT_REQ1 AS INT                                                      
 SET @IV_FLG_STAT_REQ1 = @IV_FLG_STAT_REQ                                                      
 BEGIN                                                      
 IF @IV_FLG_STAT_REQ = 0                                                      
  SET @IV_FLG_STAT_REQ1 =NULL                                                        
 END                                              
                                     
 IF @BUS_PEK_CONTROL_NUM = ''                                            
 BEGIN                        
  SET @BUS_PEK_CONTROL_NUM = NULL                                            
 END                                                
                                     
 --CONTRACT STATUS for VA ORDER                                    
 DECLARE @ORDER_STATUS AS VARCHAR(20)                                        
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
                                        
 --SELECT   @IV_WO_FIXED_PRICE                                   
                                
  --SELECT @ID_MECH = ID_MECH ,  @ID_WOLAB_SEQ  = ID_WOLAB_SEQ FROM @LABOURDET_LIST             
                                                                                                  
 SELECT @TRANNAME = 'WOJOBUPD'                                                               
 BEGIN TRY                                                                      
  BEGIN TRANSACTION @TRANNAME                                                      
   DECLARE @IV_ID_RPG_CODE_WO1 AS VARCHAR(10)                                                    
   SET  @IV_ID_RPG_CODE_WO1 = @IV_ID_RPG_CODE_WO                                                                   
                                       
   SELECT  @IV_ID_WODET_SEQ = ID_WODET_SEQ                                      
   FROM    TBL_WO_DETAIL                                          
   WHERE   ID_WO_NO = @IV_ID_WO_NO                                           
   AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                                                   
   AND     ID_JOB = @IV_ID_JOB                                                                           
                                       
   --CHECKING FOR JOB PRICE CODE HAS VALUE                                        
   SET @IV_ID_JOBPCD_WOTEMP = @IV_ID_JOBPCD_WO                                        
   IF @IV_ID_JOBPCD_WO = '0'                                                   
   BEGIN                                                              
    SELECT @IV_ID_JOBPCD_WOTEMP = ID_SETTINGS                                                                  
    FROM    TBL_MAS_SETTINGS                                                                  
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
                           
   SELECT @DEPTID= ID_DEPT,                                                  
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
                                            
                                               
                                    
   IF LEN(@IV_PKKDATE) > 0                                        
   BEGIN                                      
    UPDATE                                                   
    TBL_WO_HEADER                                                    
    SET                                            
    BUS_PEK_CONTROL_NUM  = @BUS_PEK_CONTROL_NUM                                      
    ,WO_PKKDATE=@IV_PKKDATE                                     
    WHERE                                             
    ID_WO_NO = @IV_ID_WO_NO                                                   
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                     
   END                              
   ELSE                                          
   BEGIN                                          
    UPDATE                                                   
    TBL_WO_HEADER                                                    
    SET                                            
    BUS_PEK_CONTROL_NUM  = @BUS_PEK_CONTROL_NUM                                             
    WHERE                                             
    ID_WO_NO = @IV_ID_WO_NO                
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                    
   END                                            
                                                   
   DECLARE @VATCODE AS VARCHAR(10)                                                    
   DECLARE @GMACCOUNTCODE AS VARCHAR(20)                                                 
                                         
   SELECT @VATCODE = ISNULL(ID_VAT,''),                                                  
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
                                             
   DECLARE @WO_TYPE VARCHAR(20)                                    
   SELECT @WO_TYPE = WO_TYPE_WOH FROM TBL_WO_HEADER                                     
   WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX                                    
                                              
   UPDATE TBL_WO_DETAIL                                                                                 
   SET  ID_RPG_CATG_WO   = @IV_ID_RPG_CATG_WO ,                                                                           
   ID_RPG_CODE_WO   = @IV_ID_RPG_CODE_WO1 ,                                                                          
   ID_REP_CODE_WO   = @IV_ID_REP_CODE_WO ,                                                                                
   ID_WORK_CODE_WO  = @IV_ID_WORK_CODE_WO ,                                                          
   WO_FIXED_PRICE  = @IV_WO_FIXED_PRICE ,                                                                                
   ID_JOBPCD_WO  = @IV_ID_JOBPCD_WOTEMP ,                                                                           WO_STD_TIME   = @IV_WO_STD_TIME   ,                                                                                
   WO_PLANNED_TIME  = @IV_WO_PLANNED_TIME ,                                                            
   WO_HOURLEY_PRICE = @IV_WO_HOURLEY_PRICE,                                                                                
   WO_CLK_TIME   = @IV_WO_CLK_TIME   ,                                                                                
   WO_CHRG_TIME  = @IV_WO_CHRG_TIME  ,                                     
   --JOB_STATUS = @IV_JOB_STATUS,                                               
   FLG_CHRG_STD_TIME = @IV_FLG_CHRG_STD_TIME,                                                                                   
   ID_STYPE_WO  = @IV_FLG_STAT_REQ1,                                    
   WO_JOB_TXT   = @IV_WO_JOB_TXT,                                                                                
   WO_OWN_RISK_AMT  = @IV_WO_OWN_RISK_AMT,                                                       
   WO_TOT_LAB_AMT  = @IV_WO_TOT_LAB_AMT,                                                                                
   WO_TOT_SPARE_AMT = @IV_WO_TOT_SPARE_AMT,                                                                                  
   WO_TOT_GM_AMT  = @IV_WO_TOT_GM_AMT,                                                                                
   WO_TOT_VAT_AMT  = @IV_WO_TOT_VAT_AMT,                                                       
   WO_TOT_DISC_AMT  = @IV_WO_TOT_DISC_AMT,                                                                                
   ID_MECH_COMP  = @II_ID_MECH_COMP    ,                                                                    
   WO_OWN_RISK_CUST  = @IV_WO_OWN_RISK_CUST,                                                    
   WO_OWN_CR_CUST    = @IV_WO_OWN_CR_CUST ,                                                                    
   MODIFIED_BY   = @IV_MODIFIED_BY,                                                                                
   DT_MODIFIED   = GETDATE()    ,                                                                    
   WO_OWN_PAY_VAT  = @IB_WO_OWN_PAY_VAT,                                                                    
   DT_PLANNED   = DBO.FN_DATEFORMAT(@ID_WO_DT_PLANNED),                                                     
   WO_GM_VAT   = @VATCODE,                                                    
   WO_GM_ACCCODE  = @GMACCOUNTCODE,                                                  
   WO_VAT_ACCCODE  = @VATACCOUNTCODE,                                                     
   WO_VAT_PERCENTAGE =                                     
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
   WO_GM_PER=@II_WO_GM_PER,                                                
   WO_GM_VATPER=@II_WO_GM_VATPER,                                                
   WO_LBR_VATPER=@II_WO_LBR_VATPER                                                    
   ,WO_INCL_VAT = @WO_INCL_VAT                                         
   ,WO_DISCOUNT = @WO_DISCOUNT                                        
   ,ID_SUBREP_CODE_WO = @ID_SUBREP_CODE_WO                                         
   ,OwnRiskVATAmt = @WO_OWNRISKVAT                                     
   ,USERNAME =null                                    
   ,WO_FLG_EDIT = 0                                    
   ,SALESMAN = @SALESMAN                                    
   ,FLG_VAT_FREE = @FLG_VAT_FREE                                    
   ,FLG_SPRSTATUS = @IV_FLG_SPRSTS                                    
   ,COST_PRICE = @COST_PRICE                                      
   ,WO_FINAL_TOTAL = @WO_FINAL_TOTAL                                    
   ,WO_FINAL_VAT = @WO_FINAL_VAT                                    
   ,WO_FINAL_DISCOUNT = @WO_FINAL_DISCOUNT                                    
   ,WO_CHRG_TIME_FP =@iv_WO_CHRG_TIME_FP             
   ,WO_TOT_LAB_AMT_FP = @iv_WO_TOT_LAB_AMT_FP                                    
   ,WO_TOT_SPARE_AMT_FP = @iv_WO_TOT_SPARE_AMT_FP                                    
   ,WO_TOT_GM_AMT_FP = @iv_WO_TOT_GM_AMT_FP                                    
   ,WO_TOT_VAT_AMT_FP = @iv_WO_TOT_VAT_AMT_FP                                    
   ,WO_TOT_DISC_AMT_FP = @iv_WO_TOT_DISC_AMT_FP                                    
   ,FLG_VAL_STDTIME = ISNULL(@FLG_VAL_STDTIME,0)                                    
   ,FLG_VAL_MILEAGE = ISNULL(@FLG_VAL_MILEAGE,0)                                    
   ,FLG_SAVEUPDDP =   ISNULL(@FLG_SAVEUPDDP,0)                                    
   ,FLG_EDTCHGTIME = ISNULL(@FLG_EDTCHRGTIME,0)                                    
   ,WO_INT_NOTE = @iv_WO_INT_NOTE  --762                
   ,ID_MECHANIC = @iv_WO_ID_MECHANIC              
   ,WO_OWN_RISK_DESC = @iv_WO_OWN_RISK_DESC           
   ,WO_OWN_RISK_SL_NO = @iv_WO_OWN_RISK_SL_NO                                 
   WHERE ID_WO_NO = @IV_ID_WO_NO                                                   
   AND   ID_WO_PREFIX = @IV_ID_WO_PREFIX                                                
   AND   ID_JOB = @IV_ID_JOB                                      
                                       
                                                               
                                       
   IF @@ERROR <> 0                                                                                       
   BEGIN                                                                                  
    SET @OV_RETVALUE = @@ERROR                                                                       
    ROLLBACK TRANSACTION @TRANNAME                                                                                              
    SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                    
    RETURN 1                                                      
   END --END FOR IF                                                                                
   ELSE                                                                                    
   BEGIN                                                
    SET @OV_RETVALUE = 'UPDFLG'                                                                                   
    SET @OV_JOBNO  = @IV_ID_JOB                                                                
   IF  @IV_XMLJOBDOC IS NOT NULL                                                   
   BEGIN                                     
      EXEC USP_WO_JOBDETAIL_UPDATE @IV_XMLJOBDOC, @IV_ID_WODET_SEQ, @OV_JOBNO,                                                                  
    @IV_MODIFIED_BY, @IV_ID_WO_NO, @IV_ID_WO_PREFIX, @OV_JOBUPDATE OUTPUT                                                    
                                         
                       
    IF @OV_JOBUPDATE <> '0'                                                                                  
    BEGIN                                                                                  
     SET @OV_RETVALUE =  @OV_JOBUPDATE                                                                       
     ROLLBACK TRANSACTION @TRANNAME                                                                     
     RETURN 1                                                                            
    END                                     
                                                    
   END                                      
                                       
                                  
   EXEC USP_WO_DEBITORDETIAL_UPDATE @IV_XMLWODOC, @IV_ID_WO_PREFIX, @OV_JOBNO, @IV_ID_WO_NO,                                                                  
   @IV_MODIFIED_BY, @IV_WO_OWN_RISK_AMT, @IV_TOTALAMT, @OV_DEBUPDATE OUTPUT            
       
   --print @IV_XMLWODOC    
   --print @IV_ID_WO_PREFIX, @OV_JOBNO, @IV_ID_WO_NO, @IV_MODIFIED_BY, @IV_WO_OWN_RISK_AMT, @IV_TOTALAMT, @OV_DEBUPDATE                                                                     
                                
   IF @OV_DEBUPDATE <> '0'                                                                                  
   BEGIN                                                                                  
    SET @OV_RETVALUE = @OV_DEBUPDATE                                                                      
    ROLLBACK TRANSACTION @TRANNAME                                                     
    SELECT @@ERROR,  @OV_RETVALUE                                                 
   RETURN 1                                                                                                      
   END                            
                                    
   EXEC [USP_WO_SPARESDEBITOR_UPDATE] @IV_ID_WO_NO, @IV_ID_WO_PREFIX, @OV_JOBNO, @OV_JOBDEBUPDATE OUTPUT                                          
   IF @OV_JOBDEBUPDATE <> '0'                                        
   BEGIN                                        
    SET @OV_RETVALUE = @OV_JOBDEBUPDATE                                          
    ROLLBACK TRANSACTION @TRANNAME                
    SELECT @@ERROR,  @OV_RETVALUE AS 'JOBDEB_UPD_ERR'                                                  
    RETURN 1                                      
   END                                        
   ELSE                                                   
    IF  @IV_XMLDISDOC IS NOT NULL --OR  datalength(@IV_XMLDISDOC) <>0                                         
    BEGIN                                                    
     EXEC USP_WO_JOB_DEBITOR_DISCOUNT_UPDATE @IV_XMLDISDOC, @IV_ID_WO_NO, @IV_ID_WO_PREFIX,                                                  
     @OV_JOBNO, @OV_DEBDISUPDATE OUTPUT                                                                 
                                                                  
     IF @OV_DEBDISUPDATE <> '0'                                    
     BEGIN                                                                                  
      SET @OV_RETVALUE = @OV_DEBDISUPDATE                                                                      
      ROLLBACK TRANSACTION @TRANNAME                                                    
      SELECT @@ERROR,  @OV_RETVALUE                                                   
      RETURN 1                                                                
     END                                              
    END                                        
    EXEC USP_VEH_DEFECT_DET  @IV_ID_WO_PREFIX, @IV_ID_WO_NO, @II_ID_DEF_SEQ,                                                   
    @IV_MODIFIED_BY,@OV_DEFUPDATE OUTPUT                                                                        
    SELECT @OV_DEFUPDATE                                                                     
                                                          
   IF @OV_DEBDISUPDATE <> '0'                                                                    
    BEGIN                                                          
    SET @OV_RETVALUE = @OV_DEFUPDATE                                                                      
    ROLLBACK TRANSACTION @TRANNAME                                                     
    SELECT @@ERROR,  @OV_RETVALUE                                            
    RETURN 1                                                                                                       
    END                                                                      
   ELSE                                    
   BEGIN                               
                            
    EXEC USP_WO_InsertMech @IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_MODIFIED_BY,                                                
 @OV_JOBNO,@IV_XMLMECHDOC,@OV_MECUPDERT  OUTPUT                              
                                 
 --  DECLARE @INDEX AS INT                               
 --  DECLARE @IDX AS INT                                   
 --  DECLARE @TOTCOUNTLLIST AS INT                               
 --  DECLARE @TOTALCNTLT AS INT                               
                                 
 --  SET @INDEX = 1                                
 --  SET @IDX = 1                                 
 --  SELECT @TOTALCNTLT = COUNT(*) FROM @INSERT_LIST                               
 --  SELECT @TOTCOUNTLLIST = COUNT(*) FROM @LABOURDET_LIST                              
                             
 --  WHILE(@IDX <= @TOTALCNTLT)                              
 --  BEGIN                               
 --   SELECT @LINE_TYPE =  LineType FROM @INSERT_LIST WHERE  ID_RANK  = @IDX                              
 --   IF @LINE_TYPE = 'L'                                  
 --   BEGIN                              
 --  WHILE(@INDEX <= @TOTCOUNTLLIST)                                  
 --  BEGIN                                
                                   
 --   SELECT  @ID_WOLAB_SEQ  = ID_WOLAB_SEQ FROM @LABOURDET_LIST WHERE ROWID = @INDEX                                
 -- IF @ID_WOLAB_SEQ <> '0'                                  
 --   BEGIN         
 --  EXEC USP_WO_UPDMECH @IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_MODIFIED_BY,                                                  
 --  @OV_JOBNO,@IV_XMLMECHDOC,@OV_MECUPDERT  OUTPUT                     END                                  
 -- ELSE                                  
 -- BEGIN                                  
 --  --EXEC USP_WO_InsertMech @IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_MODIFIED_BY,                                                
 --  --@OV_JOBNO,@IV_XMLMECHDOC,@OV_MECUPDERT  OUTPUT                         
 --  SELECT 1                                      
 -- END                                                     
 -- IF @OV_MECUPDERT <> '0'                                                                              
 --    BEGIN                                                                              
 --  SET @OV_RETVALUE = @@ERROR                
 --    END                    
 -- SET @INDEX = @INDEX + 1                                           
 -- END                               
 --   END                              
 --   SET @IDX = @IDX + 1                               
                               
                             
 --END                                 
                               
   COMMIT TRANSACTION @TRANNAME                                   
   SET @OV_RETVALUE = 'UPDFLG'                                                    
   SELECT @@ERROR,  @OV_RETVALUE AS 'UPD'                                
                                                    
   END -- END TO DEBITOR                                                    
  END  --END FOR  WO DETAIL ELSE                                       
                               
                              
    DECLARE @INDEXLABLIST AS INT                               
    DECLARE @IDXINS AS INT                                   
    DECLARE @TOTCOUNTLABLIST AS INT                               
    DECLARE @TOTALCNTINS AS INT                               
    DECLARE @Wo_Lab_Hrs   decimal(9,2)                                  
    DECLARE @HourlyPr decimal(9,2)                      
    DECLARE @LAB_DESC VARCHAR(100)                    
    DECLARE @WO_Lab_Discount Decimal(13,2)               
    DECLARE @SL_NO  INT                   
                                    
    SET @INDEXLABLIST = 1                                
    SET @IDXINS = 1                                 
    SELECT @TOTALCNTINS = COUNT(*) FROM @INSERT_LIST                               
    SELECT @TOTCOUNTLABLIST = COUNT(*) FROM @LABOURDET_LIST                              
                                 
    WHILE(@IDXINS <= @TOTALCNTINS)                              
    BEGIN                               
    SELECT @LINE_TYPE =  LineType FROM @INSERT_LIST WHERE  ID_RANK  = @IDXINS                              
    IF @LINE_TYPE = 'L'                                  
   BEGIN                              
     WHILE(@INDEXLABLIST <= @TOTCOUNTLABLIST)                                  
     BEGIN                              
                                     
     SELECT  @LAB_DESC = LabourDesc , @Wo_Lab_Hrs = Wo_Lab_Hrs , @HourlyPr = HourlyPr, @ID_MECH = ID_MECH ,  @ID_WOLAB_SEQ  = ID_WOLAB_SEQ ,@WO_Lab_Discount = WO_Lab_Discount                     
     ,@SL_NO = SL_NO              
     FROM @LABOURDET_LIST                     
     WHERE ROWID = @INDEXLABLIST                                 
                                        
     SELECT ID_WOLAB_SEQ,ID_LOGIN,WO_LABOUR_HOURS,dbo.SumTimeDiffTEMP((@IV_ID_WO_PREFIX + @IV_ID_WO_NO),@iv_ID_JOB,ID_LOGIN)AS LABOUR_HOURS                                     
     INTO #LABTEMP                                    
     FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ  AND ID_WOLAB_SEQ = @ID_WOLAB_SEQ                                  
                                      
                          
    IF (SELECT COUNT(*) FROM #LABTEMP) > 0                                    
    BEGIN                                    
     --UPDATE TBL_WO_LABOUR_DETAIL SET WO_LABOUR_HOURS = CONVERT(DECIMAL(9,2),T.LABOUR_HOURS)                                    
     --FROM #LABTEMP T WHERE TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ = T.ID_WOLAB_SEQ  AND  TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ = @ID_WOLAB_SEQ                                  
     UPDATE TBL_WO_LABOUR_DETAIL SET WO_LABOUR_HOURS = @Wo_Lab_Hrs ,WO_LABOUR_DESC = @LAB_DESC  ,WO_Lab_Discount =@WO_Lab_Discount                               
     WHERE TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ =  @ID_WOLAB_SEQ                                   
                                         
                                         
     DECLARE @VAT_MCODE AS INT                                    
     SELECT @VAT_MCODE = ID_SETTINGS FROM TBL_MAS_SETTINGS MAS                                     
     INNER JOIN TBL_MAS_MAKE MAK                                     
     ON  MAS.[DESCRIPTION] = MAKE_VATCODE AND ID_CONFIG = 'VAT'         
     INNER JOIN TBL_MAS_VEHICLE VH ON VH.ID_MAKE_VEH = MAK.ID_MAKE                                     
     INNER JOIN TBL_WO_HEADER ON ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO                                    
     WHERE ID_WO_NO = @iv_ID_WO_NO AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX                                     
                                         
                                         
     DECLARE @iv_ID_MAKE_PC_HP varchar(10)                                     
     DECLARE @CUS_PC INT                          
     DECLARE @iv_ID_VEHGRP_PC_HP varchar(10)                                     
     DECLARE @RP_CODE INT                                    
     DECLARE @MakePcd varchar(30),@MechPcd varchar(10),@RepPkgPCD varchar(10),@CustPcd varchar(10), @VehGrpPcd varchar(10), @JobPcd varchar(10),@CustVATCode VARCHAR(10)                                       
     DECLARE @WO_CREATED_BY VARCHAR(20)                                    
     DECLARE @MECH_ID VARCHAR(10)                                    
     DECLARE @MIN_LABOUR_SEQ INT, @MAX_LABOUR_SEQ INT                                    
     SELECT @MIN_LABOUR_SEQ = MIN(ID_WOLAB_SEQ), @MAX_LABOUR_SEQ = MAX(ID_WOLAB_SEQ) FROM #LABTEMP                                    
     SELECT @MECH_ID = ID_LOGIN FROM #LABTEMP                
     WHERE                                     
     ID_WOLAB_SEQ = @MIN_LABOUR_SEQ                                    
                                         
     SELECT @MechPcd = MAX(ID_MECPCD) FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @MECH_ID                                    
                                         
                                         
     SELECT                                                   
        @MakePcd=ID_MAKE,                                                                                           
        @CustPcd = ID_CUSTOMER,                          
        @VehVatCode = ISNULL(mv.ID_VAT_CD,@VAT_MCODE),                                                  
        @CustVATCode = mcg.ID_VAT_CD                                                  
     FROM                                                   
        TBL_WO_HEADER wh                                                   
        JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                                                   
       JOIN TBL_MAS_MAKE mm ON mm.ID_MAKE = mv.ID_MAKE_VEH              
        JOIN TBL_MAS_CUSTOMER mc ON mc.ID_CUSTOMER = wh.ID_CUST_WO                                                  
        JOIN TBL_MAS_CUST_GROUP mcg ON mcg.ID_CUST_GRP_SEQ = mc.ID_CUST_GROUP                                                   
     WHERE                                                   
        wh.ID_WO_NO = @IV_ID_WO_NO                                                  
        AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                            
                                
     --Query for Fetching  Vehicle Group ID                                            
                                      
     SELECT @VehGrpPcd = VH_GROUP_ID--,@WO_CREATED_BY=wh.CREATED_BY                                                 
     FROM TBL_WO_HEADER wh                                                   
     JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                                                   
     JOIN TBL_MAS_VHGROUPPC mvgp ON mv.ID_GROUP_VEH = mvgp.VH_GROUP_ID                                                  
     WHERE  wh.ID_WO_NO = @IV_ID_WO_NO                                                  
     AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                       
                                            
     SELECT @WO_CREATED_BY=wh.CREATED_BY                                                 
     FROM TBL_WO_HEADER wh                                                   
     WHERE  wh.ID_WO_NO = @IV_ID_WO_NO                                                  
     AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                        
                                   
                       
     SELECT @RepPkgPCD = ID_RPKG_SEQ,@JobPcd = ID_JOBPCD_WO                                     
     FROM TBL_WO_DETAIL wd                                    
     JOIN TBL_WO_HEADER wh ON wh.ID_WO_NO =  wd.ID_WO_NO                                     
     AND wh.ID_WO_PREFIX = wd.ID_WO_PREFIX                                                  
     LEFT JOIN TBL_MAS_REP_PACKAGE mrp ON mrp.ID_RPKG_SEQ = wd.ID_RPG_CODE_WO                                                  
     WHERE wh.ID_WO_NO = @IV_ID_WO_NO                                                  
     AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                             
     AND wd.ID_JOB = @IV_ID_JOB                                      
                                                  
                                     
                                                
                                 
                                              
    SELECT  @iv_ID_MAKE_PC_HP=ID_MAKE_PRICECODE  FROM  TBL_MAS_MAKE  WHERE  ID_MAKE=@MakePcd                                        
    select @CUS_PC  = ID_CUST_PC_CODE FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@CustPcd                                     
    SELECT  @iv_ID_VEHGRP_PC_HP=VH_GROUP_PRICECODE FROM  TBL_MAS_VHGROUPPC  WHERE VH_GROUP_ID=@VehGrpPcd                                           
    SELECT  @RP_CODE = ID_RP_PRC_GRP FROM TBL_MAS_REP_PACKAGE  WHERE ID_RPKG_SEQ = @RepPkgPCD                                     
                                              
                                      
                                         
     UPDATE TBL_WO_LABOUR_DETAIL                                                             
     SET                                      
                                         
     WO_LABOURVAT_PERCENTAGE =                                     
                                        
     (SELECT TOP 1 VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = (SELECT                                     
   CASE WHEN TBL_WO_HEADER.ID_CUST_WO IS NOT NULL THEN                                                                         
    (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP                                     
      FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = WODEBDET.ID_JOB_DEB ))                       
   END                                           
   FROM TBL_WO_HEADER INNER JOIN TBL_WO_DETAIL WODET                                     
    ON TBL_WO_HEADER.ID_WO_NO= WODET.ID_WO_NO                                     
    AND TBL_WO_HEADER.ID_WO_PREFIX = WODET.ID_WO_PREFIX                          
    INNER JOIN TBL_WO_DEBITOR_DETAIL WODEBDET                                              
    ON WODET.ID_WO_NO = WODEBDET.ID_WO_NO                                     
    AND WODET.ID_WO_PREFIX = WODEBDET.ID_WO_PREFIX                                     
    AND WODET.ID_JOB= WODEBDET.ID_JOB_ID                                         
    AND WODEBDET.DEBITOR_TYPE = 'C' AND DBT_PER > 0.00                                                                                      
   WHERE TBL_WO_HEADER.ID_WO_NO = @iv_ID_WO_NO AND TBL_WO_HEADER.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @iv_ID_JOB)                                            
    AND ISNULL(CONVERT(VARCHAR,VAT_VEH),'-')  = (SELECT                                                                          
    CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                                                            
     (SELECT ISNULL(ID_VAT_CD,@VAT_MCODE) FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                                                            
    END                                                                            
    FROM TBL_WO_HEADER                             
    WHERE ID_WO_NO = @iv_ID_WO_NO AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX  )                             
     AND ISNULL(CONVERT(VARCHAR,VAT_ITEM),'-') = (Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE                                             
   ID_DEPT_HP = @DEPTID                                               
       AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                                                
       AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                                                
       AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                                                
       AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                                                
       AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                                              
       AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')                                              
       AND DT_EFF_TO is null)                                     
       AND DT_EFF_TO >= GETDATE()                                    
       )                                                              
   FROM #LABTEMP T WHERE TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ = T.ID_WOLAB_SEQ  AND TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ = @ID_WOLAB_SEQ                                  
                                      
     --DROP TABLE #LABTEMP              
    END                                    
                                  
                                        
    ----------------UPDATING THE HOURLY PRICE------------------------------                                    
    SELECT *                                     
    INTO #LABOUR_TEMP                                    
    FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ  AND ID_WOLAB_SEQ = @ID_WOLAB_SEQ                                  
                                        
    --DECLARE @MIN_LABOUR_SEQ INT, @MAX_LABOUR_SEQ INT                                    
    --DECLARE @WO_CREATED_BY VARCHAR(20)                                    
    --DECLARE @MECH_ID VARCHAR(10)                                    
    --DECLARE @MakePcd varchar(30),@MechPcd varchar(10),@RepPkgPCD varchar(10),@CustPcd varchar(10), @VehGrpPcd varchar(10), @JobPcd varchar(10),@CustVATCode VARCHAR(10)                                                   
    DECLARE @HOURLYPRICE DECIMAL(11,2),@HPVAT VARCHAR(500)                                       
                                        
    SELECT @MIN_LABOUR_SEQ = MIN(ID_WOLAB_SEQ), @MAX_LABOUR_SEQ = MAX(ID_WOLAB_SEQ) FROM #LABOUR_TEMP                                    
    --select '#LABOUR_TEMP',* from #LABOUR_TEMP                                    
    --select '@MIN_LABOUR_SEQ',@MIN_LABOUR_SEQ,@MAX_LABOUR_SEQ                                    
     --Commented as update shud happen for single line                                   
    WHILE (@MIN_LABOUR_SEQ <= @MAX_LABOUR_SEQ)              
    BEGIN                                      
                                      
     SELECT @MECH_ID = ID_LOGIN FROM #LABOUR_TEMP                                     
     WHERE --ID_WODET_SEQ = @MIN_LABOUR_SEQ -- ROW 280                                    
     ID_WOLAB_SEQ = @MIN_LABOUR_SEQ                                    
                              
     SELECT @VAT_MCODE = ID_SETTINGS                                     
     FROM TBL_MAS_SETTINGS MAS                                     
     INNER JOIN TBL_MAS_MAKE MAK                                     
     ON  MAS.[DESCRIPTION] = MAKE_VATCODE AND ID_CONFIG = 'VAT'                                     
     INNER JOIN TBL_MAS_VEHICLE VH ON VH.ID_MAKE_VEH = MAK.ID_MAKE                                     
     INNER JOIN TBL_WO_HEADER ON ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO                                    
     WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX                                    
                                      
     SELECT @MechPcd = MAX(ID_MECPCD) FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @MECH_ID                                                  
                                      
     --select '@MECH_ID',@MECH_ID,@MechPcd,@IV_ID_WODET_SEQ                                    
     --Query for Fetching other then Vehicle Group ID                                              
     SELECT                                                   
        @MakePcd=ID_MAKE,                                                                              
        @CustPcd = ID_CUSTOMER,                                                  
        @VehVatCode = ISNULL(mv.ID_VAT_CD,@VAT_MCODE),                                                  
        @CustVATCode = mcg.ID_VAT_CD                                                  
     FROM                                                   
        TBL_WO_HEADER wh                                                   
        JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                                                   
        JOIN TBL_MAS_MAKE mm ON mm.ID_MAKE = mv.ID_MAKE_VEH                                                                                      
        JOIN TBL_MAS_CUSTOMER mc ON mc.ID_CUSTOMER = wh.ID_CUST_WO                                                  
     JOIN TBL_MAS_CUST_GROUP mcg ON mcg.ID_CUST_GRP_SEQ = mc.ID_CUST_GROUP                                                   
     WHERE                                                   
        wh.ID_WO_NO = @IV_ID_WO_NO                                                  
        AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                            
                                      
     --Query for Fetching  Vehicle Group ID                                            
                                      
     SELECT @VehGrpPcd = VH_GROUP_ID--,@WO_CREATED_BY=wh.CREATED_BY                                   
     FROM TBL_WO_HEADER wh                                                   
     JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                                                   
     JOIN TBL_MAS_VHGROUPPC mvgp ON mv.ID_GROUP_VEH = mvgp.VH_GROUP_ID                                                  
     WHERE  wh.ID_WO_NO = @IV_ID_WO_NO                                                  
     AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                       
                                             
     SELECT @WO_CREATED_BY=wh.CREATED_BY                                                 
     FROM TBL_WO_HEADER wh                                                   
     WHERE  wh.ID_WO_NO = @IV_ID_WO_NO                                                  
     AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                        
                                          
                                      
     SELECT @RepPkgPCD = ID_RPKG_SEQ,@JobPcd = ID_JOBPCD_WO                           
     FROM TBL_WO_DETAIL wd                                    
     JOIN TBL_WO_HEADER wh ON wh.ID_WO_NO =  wd.ID_WO_NO                                     
     AND wh.ID_WO_PREFIX = wd.ID_WO_PREFIX                                                  
     LEFT JOIN TBL_MAS_REP_PACKAGE mrp ON mrp.ID_RPKG_SEQ = wd.ID_RPG_CODE_WO                                                 
     WHERE wh.ID_WO_NO = @IV_ID_WO_NO                                                  
     AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                                                  
     AND wd.ID_JOB = @IV_ID_JOB                                 
                                      
     EXEC [USP_WO_GetHPPrice] @WO_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE OUTPUT, @HPVAT OUTPUT                                                
     --SELECT '@HOURLYPRICE',@WO_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE,@HPVAT                                    
     SELECT TOP 1 @VATPer = VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = @CustVATCode AND VAT_VEH = @VehVatCode AND VAT_ITEM = @HPVAT                                                  
     AND DT_EFF_TO = '9999-12-31 23:59:59.000' Order by DT_EFF_FROM DESC                                    
                                      
                                                   
     UPDATE TBL_WO_LABOUR_DETAIL                                  
     SET WO_HOURLEY_PRICE = @HourlyPr ,                                
     ID_LOGIN = @ID_MECH,              
     SL_NO = @SL_NO                                 
     WHERE TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ = @ID_WOLAB_SEQ                                    
     AND ID_WODET_SEQ = @IV_ID_WODET_SEQ                                    
                                         
     SET @MIN_LABOUR_SEQ = @MIN_LABOUR_SEQ + 1                                    
                                         
    END 
    
      exec USP_WO_DEBITOR_INVOICEDATA_INSERT @IV_ID_WO_PREFIX,@IV_ID_JOB ,@IV_ID_WO_NO,@IV_MODIFIED_BY                                       
                                  
    --Commented As update shud happen for single line                                 
    --Already a update statement is there so commented the below update as it is going wrong                                
                                  
   --UPDATE TBL_WO_LABOUR_DETAIL                                     
   --SET WO_HOURLEY_PRICE = 250.00 ,                                
   --ID_LOGIN = @ID_MECH                                      
   --WHERE  ID_WODET_SEQ = @IV_ID_WODET_SEQ  AND ID_WOLAB_SEQ = @ID_WOLAB_SEQ                         
   DROP TABLE #LABTEMP                                 
     DROP TABLE #LABOUR_TEMP                            
                                 
 SET @INDEXLABLIST = @INDEXLABLIST + 1                                           
 END                               
   END                              
   SET @IDXINS = @IDXINS + 1                             
                                 
  END                               
                                   
   --SELECT @HOURLYPRICE = WO_HOURLEY_PRICE FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ                                    
   --ROW 636 in SS2 when the hourly price on clocked time is different from the hourly price on std time the gm amount is being calculated on invoice based on the std time hourly price even if the order is charged based on clocked time.                  
  
    
      
        
          
            
              
                
                  
                                    
   DECLARE @TOT_GM_AMT AS DECIMAL(13,2)                                    
   DECLARE @TOT_LAB_AMT AS DECIMAL(13,2)                                    
   DECLARE @GM_PER AS DECIMAL(13,2)                        
   SELECT @GM_PER = WO_GM_PER FROM TBL_WO_DETAIL WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ                                    
   SELECT @TOT_GM_AMT = SUM(WO_LABOUR_HOURS * WO_HOURLEY_PRICE * (@GM_PER/100)) FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ                                      
   SELECT @TOT_LAB_AMT = SUM(WO_LABOUR_HOURS * WO_HOURLEY_PRICE ) FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ                                     
   IF (((SELECT FLG_CHRG_STD_TIME FROM TBL_WO_DETAIL  WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ) = 0)and ((SELECT WO_FIXED_PRICE FROM TBL_WO_DETAIL  WHERE ID_WODET_SEQ = @IV_ID_WODET_SEQ) = 0.0))                                    
    BEGIN                    
                                        
    --654                                    
    IF @FLG_EDTCHRGTIME<>'TRUE'                                    
    BEGIN                                    
     UPDATE TBL_WO_DETAIL                                 
     SET WO_TOT_GM_AMT = @TOT_GM_AMT,                                    
     WO_TOT_LAB_AMT = @TOT_LAB_AMT                                    
     WHERE  ID_WODET_SEQ = @IV_ID_WODET_SEQ                                    
    END                                    
   END                                     
                                    
                                      
  ---------------END OF HOURLY PRICE CHANGES-------------------------------                                    
                                      
  UPDATE TBL_WO_DETAIL                                     
  SET                                     
   LUNCH_WITHDRAW = DEPT.LUNCH_WITHDRAW,                               
   FROM_TIME = DEPT.FROM_TIME,                                    
   TO_TIME = DEPT.TO_TIME                                     
  FROM                                 
   TBL_MAS_DEPT DEPT                                    
  WHERE                                       
   DEPT.ID_DEPT = @DEPTID AND                                    
   ID_WO_NO = @IV_ID_WO_NO  AND                                      
   ID_WO_PREFIX = @IV_ID_WO_PREFIX AND                                         
   ID_JOB = @IV_ID_JOB                                     
                                    
                                    
                                    
         DECLARE @STA AS VARCHAR(10)                                    
          DECLARE @FLG_SPRSTS AS VARCHAR(3)                                    
         DECLARE @IV_WODET_SEQ_JOB AS INT                                    
         SELECT @IV_WODET_SEQ_JOB = ID_WODET_SEQ,@STA = JOB_STATUS FROM TBL_WO_DETAIL                                     
      WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX                                     
      AND ID_JOB=@OV_JOBNO                                    
                                          
    SELECT @FLG_SPRSTS = FLG_SPRSTATUS FROM TBL_WO_DETAIL                                     
    WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX                                     
    AND ID_JOB=@OV_JOBNO and ID_WODET_SEQ =@IV_WODET_SEQ_JOB                                    
/*Change to update status for TBL_PLAN_JOB_DETAIL*/                                    
if exists(select * from TBL_PLAN_JOB_DETAIL where ID_WO_NO_JOB = @IV_ID_WO_NO AND ID_WO_PREFIX  = @IV_ID_WO_PREFIX AND ID_JOB = @OV_JOBNO)                                      
 BEGIN                                    
  if (@STA = 'RWRK')                                     
   begin                                    
    UPDATE  TBL_PLAN_JOB_DETAIL                                     
   SET STATUS = 'RWRK'                                    
    WHERE                     
    ID_WO_NO_JOB      = @IV_ID_WO_NO                                      
    AND ID_WO_PREFIX  = @IV_ID_WO_PREFIX                                      
    AND ID_JOB = @OV_JOBNO                                                    
   end                                    
  else                                     
   begin                                    
    if (@STA = 'CSA')                                     
     begin                                    
      UPDATE  TBL_PLAN_JOB_DETAIL                                     
        SET STATUS = 'PLND'                                    
      WHERE                                        
      ID_WO_NO_JOB      = @IV_ID_WO_NO                                      
AND ID_WO_PREFIX  = @IV_ID_WO_PREFIX                                      
      AND ID_JOB = @OV_JOBNO                                                    
     end                                    
   end                                    
end                                    
                                    
/****Change End****/                                      
                                      
                                             
      DECLARE @USE_MANUAL_RWRK AS BIT                                     
      DECLARE @SUBID AS INT                                    
       SELECT @SUBID = ID_SUBSIDERY_USER,@DEPTID=ID_DEPT_USER FROM  TBL_MAS_USERS                                                              
      WHERE ID_LOGIN = @IV_MODIFIED_BY                                      
   SELECT @USE_MANUAL_RWRK = USE_MANUAL_RWRK                
   FROM                                     
   TBL_MAS_WO_CONFIGURATION                                    
   WHERE                                     
   ID_SUBSIDERY_WO = @SUBID AND                          
   ID_DEPT_WO  = @DEPTID  AND                                    
   DT_EFF_TO > getdate()                                    
                                         
  IF @USE_MANUAL_RWRK = 0                                    
     BEGIN                                    
                                             
                                        
                                      
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
    --select '@TOTALCNT',@TOTALCNT,@STOCKITEM,@BOJQTY     
                                         
      IF @TOTALCNT = @STOCKITEM                                     
      BEGIN                                    
                                       
                                        
         IF @BOJQTY = 0                                    
      BEGIN                                    
      IF ISNULL(@IV_WODET_SEQ_JOB,0) = 0                                    
      BEGIN                                    
                                          
       UPDATE TBL_WO_DETAIL                                    
       SET JOB_STATUS = 'RWRK'                                    
       WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                    
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
                                       
   --select @WOJOBCOUNT as '@WOJOBCOUNT',@RSTATUSCOUNT as '@RSTATUSCOUNT'                                    
                                             
             UPDATE                                                   
    TBL_WO_HEADER                                                    
    SET                                            
    WO_STATUS  = CASE WHEN (@RSTATUSCOUNT = @WOJOBCOUNT) THEN 'RWRK' ELSE (SELECT WO_STATUS FROM TBL_WO_HEADER WHERE  ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX)   END                                              
    WHERE                                             
    ID_WO_NO = @IV_ID_WO_NO                                                   
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                    
     END                                    
   --END                                    
                                       
                                       
   IF @ORDER_TYPE ='CRSL'                                    
   BEGIN                                    
    UPDATE TBL_WO_DETAIL                                    
    SET JOB_STATUS = 'CON'                                    
    WHERE ID_WODET_SEQ = @IV_WODET_SEQ_JOB                                    
                                        
    --UPDATE TBL_WO_HEADER                                     
    --SET WO_STATUS  = 'CON'                                    
    --WHERE ID_WO_NO = @IV_ID_WO_NO  AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                      
                                        
IF @ORDER_STATUS ='CON' OR @ORDER_STATUS ='STR'                                    
    BEGIN                             
     UPDATE TBL_WO_HEADER                            
     SET WO_STATUS  = @ORDER_STATUS             
     WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                    
    END                                    
   END                                    
                                       
                                               
 END TRY                                                              
 BEGIN CATCH                                             
  SET @OV_RETVALUE = @@ERROR                                                         
                                                    
  SELECT @@ERROR,  @OV_RETVALUE AS 'Roll'                                       
  pRINT ERROR_MESSAGE()                              
  ROLLBACK TRANSACTION @TRANNAME                                                       
 END CATCH                                                  
 SELECT @OV_RETVALUE                                                                             
 END                                                              
                                                  
/**                                                                             
declare @xml1 as varchar(4000)                                                     
declare @r1 as varchar(20)                                                                       
EXEC USP_WO_DETAILS_UPDATE                                                   
'<root><insert ID_ITEM_JOB="00001109N7" ID_MAKE_JOB="Fo" ID_WODET_SEQ_JOB="0" ID_ITEM_CATG_JOB="" JOBI_ORDER_QTY="1" JOBI_DELIVER_QTY="0" JOBI_BO_QTY="0" JOBI_DIS_PER="0" JOBI_VAT_PER="0" ORDER_LINE_TEXT="" ID_WOITEM_SEQ="0" JOBI_SELL_PRICE="2500"/><inse 
 
    
      
        
           
           
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                    
                                      
                                         
                                        
                                           
                                     
                                             
rt ID_ITEM_JOB="115-MWQ12-12L" ID_MAKE_JOB="Fo" ID_WODET_SEQ_JOB="95" ID_ITEM_CATG_JOB="01" JOBI_ORDER_QTY="1" JOBI_DELIVER_QTY="0" JOBI_BO_QTY="0" JOBI_DIS_PER="0" JOBI_VAT_PER="0" ORDER_LINE_TEXT="" ID_WOITEM_SEQ="80" JOBI_SELL_PRICE="2500"/></root>',  
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                    
                                      
                                        
                                          
                                            
                                              
                                                
'<root><insert ID_DETAIL="10005" ID_DBT_SEQ="57" DEBITOR_TYPE="C" DBT_AMT="2525" DBT_PER="100"/></root>',                                                  
1,'103','TS',                                                  
null,'0',1,                                                  
'6',0,'0',                                                  
'0',0,'0.0',                                                  
                                                  
                                                  
'20',                                                  
                                                                            
true,'1:00',                                                  
0,'',0,                                                  
0,2525,0,                                                  
0,0,'CSA',                                                  
'admin','11/6/2007 6:15:25 PM',                                                  
3,                                                  
                                 
                                                  
@r1 output,                                                  
                                                  
null,'12:00:00 AM',                                                  
2525.04,false,0,null,null,null,0                                                  
select @r1                                                  
*/ 
GO

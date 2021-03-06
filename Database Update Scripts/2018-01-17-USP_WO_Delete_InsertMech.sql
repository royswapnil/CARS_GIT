/****** Object:  StoredProcedure [dbo].[USP_WO_Delete_InsertMech]    Script Date: 1/17/2018 3:48:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_Delete_InsertMech]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_Delete_InsertMech]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_Delete_InsertMech]    Script Date: 1/17/2018 3:48:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_Delete_InsertMech]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_Delete_InsertMech] AS' 
END
GO
                                 
ALTER Proc [dbo].[USP_WO_Delete_InsertMech]                                
(                                
 @iv_ID_WO_NO  varchar(10)  ,                                      
 @iv_ID_WO_PREFIX varchar(3) ,                                      
 @iv_ID_USERID  VARCHAR(10) ,                                
 @iv_ID_JOB   INT   ,                                
 @iv_XMLMECHDOC  NTEXT   ,                                
 @OV_RETVALUE        VARCHAR(10)  OUTPUT                                  
)                                
As                                
Begin                                
   DECLARE @DepID AS INT                                      
   DECLARE @SubID AS INT                                
   DECLARE @docHandle int                                       
      DECLARE @CONFIGLISTCNI AS VARCHAR(2000)                                      
      DECLARE @CFGLSTINSERTED AS VARCHAR(2000)                                      
                                      
      ---UPDATE @INSERT_LIST                                
   --- SET ID_ITEM_CATG_JOB                                
   SELECT @DepID=ID_Dept_User,@SubID = ID_Subsidery_User                                       
      FROM TBL_MAS_USERS                                      
      WHERE ID_Login=@iv_ID_USERID                                 
                                
   EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_XMLMECHDOC                                    
      Declare @INSERT_LIST Table                                
      (                                
  --ID_DEPT  INT   ,                  
   ROWID  INT,                                
   ID_MECH VARCHAR(20)                           
  ,SL_NO INT                      
  ,LabourDesc VARCHAR(100)                       
  ,Wo_Lab_Hrs decimal(9,2)                       
  ,HourlyPr   decimal(9,2)               
  ,ID_WOLAB_SEQ  int     
  ,LineType VARCHAR(10)    
  ,WO_Lab_Discount Decimal(13,2)                      
      )                                 
    INSERT INTO @INSERT_LIST                                
    Select ROW_NUMBER() OVER (ORDER BY ID_MECH),                   
  ID_MECH                       
  ,Id_Sl_No                       
  ,LabourDesc                       
  ,Wo_Lab_Hrs                       
  ,HourlyPr               
  ,ID_WOLAB_SEQ    
  ,LineType     
  ,WO_Lab_Discount     
    FROM OPENXML (@docHandle,'root/insert',1) with                                   
    (                                
    --ID_DEPT  INT   ,                  
    ROWID  INT,                                
    ID_MECH VARCHAR(20),                          
    Id_Sl_No INT ,                      
    LabourDesc VARCHAR(100),                      
    Wo_Lab_Hrs   decimal(9,2) ,                      
    HourlyPr  decimal(9,2),    
    ID_WOLAB_SEQ  int,    
    LineType VARCHAR(10),    
    WO_Lab_Discount Decimal(13,2)                         
    )                    
    --where  ID_WOLAB_SEQ = 0                             
                  
    EXEC SP_XML_REMOVEDOCUMENT @docHandle                                
    Insert into tbl_plan_job_detail                                
   (                                
    ID_DEPT,                                
    ID_SPLIT_SEQ,                                
    ID_WO_NO_JOB,                                
    ID_WO_PREFIX,                                
    ID_JOB,                                
    ID_MEC_PLAN,                               
    DT_PLAN,                              
    PLAN_TIME_FROM,                                
    PLAN_TIME_TO,                                
    STATUS,                                
    SRC_INITIATION,                                
    CREATED_BY,                                
    DT_CREATED                                
   )                                
 SELECT                                
    @DepID,                                
    0,                                
    @iv_ID_WO_NO,                                
    @iv_ID_WO_PREFIX,                                
    @iv_ID_JOB,                                
    ID_MECH,                                  getdate(),                
    '0:0',                                
    '0:0',                                
    'PLND',                                
    'W',                                
    @iv_ID_USERID,                                
    getdate()                                
   FROM                           
      @INSERT_LIST                   
      WHERE ID_MECH <> 'DUSER'                             
                        
                            
    --Insert into tbl_wo_labour_detail                            
  DECLARE @MechPcd As varchar(10)                              
  DECLARE @MakePcd As varchar(30)                              
  DECLARE @CustPcd As varchar(10)           
  DECLARE @VehVatCode As varchar(10)                             
  DECLARE @CustVATCode As varchar(10)                             
  DECLARE @VehGrpPcd As varchar(10)                            
  DECLARE @RepPkgPCD As varchar(10)                            
  DECLARE @JobPcd As varchar(10)                             
  Declare @HOURLYPRICE As decimal(11,2)                            
  Declare @VATPer As decimal(5,2)                            
  Declare @HPVAT As varchar(500)                         
  DECLARE @ID_WO_DETSEQ AS INT                             
  Declare @WO_CREATED_BY As varchar(20)                            
  Declare @VAT_MCODE As int                            
  DECLARE @IV_ID_MEC_TR As varchar(20)                            
  DECLARE @iv_ID_MAKE_PC_HP varchar(10)                             
  DECLARE @CUS_PC INT                               
  DECLARE @iv_ID_VEHGRP_PC_HP varchar(10)                             
  DECLARE @RP_CODE INT                            
  DECLARE @SL_NO INT                        
  DECLARE @LAB_DESC VARCHAR(100)                      
  DECLARE @Wo_Lab_Hrs   decimal(9,2)                      
  DECLARE @HourlyPr decimal(9,2)                  
  DECLARE @INDEXLABLIST AS INT                   
  DECLARE @IDXINS AS INT                       
  DECLARE @TOTCOUNTLABLIST AS INT             
  DECLARE @ID_WO_LAB_SEQ AS INT    
  DECLARE @LINETYPE VARCHAR(10)     
  DECLARE @WO_Lab_Discount decimal(13,2)                             
                  
 SET @INDEXLABLIST = 1                    
    SELECT @TOTCOUNTLABLIST = COUNT(*) FROM @INSERT_LIST                  
            
    SELECT @ID_WO_DETSEQ = ID_WODET_SEQ,@WO_CREATED_BY = Created_by                            
 FROM TBL_WO_DETAIL                             
 WHERE ID_WO_NO  = @iv_ID_WO_NO                                                           
    AND  ID_WO_PREFIX = @iv_ID_WO_PREFIX                             
    AND  ID_JOB   = @iv_ID_JOB          
                
    IF(@TOTCOUNTLABLIST=0)      
 BEGIN      
    --SELECT 'AFTER',* FROM TBL_WO_LABOUR_DETAIL      
    DELETE FROM TBL_WO_LABOUR_DETAIL      
    WHERE ID_WOLAB_SEQ NOT IN (SELECT ID_WOLAB_SEQ FROM @INSERT_LIST)                                
    AND ID_WODET_SEQ = @ID_WO_DETSEQ       
 END      
   ELSE      
    BEGIN      
    DELETE FROM TBL_WO_LABOUR_DETAIL                                 
     WHERE ID_WODET_SEQ = @ID_WO_DETSEQ     
     --AND ID_WOLAB_SEQ IN (SELECT ID_WOLAB_SEQ FROM @INSERT_LIST)                                
          
    END                 
                       
 WHILE(@INDEXLABLIST <= @TOTCOUNTLABLIST)                      
 BEGIN        
                   
   SELECT @IV_ID_MEC_TR = ID_MECH ,@SL_NO = SL_NO ,@LAB_DESC = LabourDesc , @Wo_Lab_Hrs = Wo_Lab_Hrs , @HourlyPr = HourlyPr ,@ID_WO_LAB_SEQ = ID_WOLAB_SEQ,@LINETYPE=LINETYPE,@WO_Lab_Discount=WO_Lab_Discount      
   FROM @INSERT_LIST                   
   WHERE  ROWID  = @INDEXLABLIST               
               
    --IF @ID_WO_LAB_SEQ = '0'            
    BEGIN                            
     SELECT @VAT_MCODE = ID_SETTINGS        
       FROM         
     TBL_MAS_SETTINGS MAS                             
     INNER JOIN TBL_MAS_MAKE MAK ON  MAS.[DESCRIPTION] = MAKE_VATCODE AND ID_CONFIG = 'VAT'                             
     INNER JOIN TBL_MAS_VEHICLE VH ON VH.ID_MAKE_VEH = MAK.ID_MAKE                             
     INNER JOIN TBL_WO_HEADER ON ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO                            
       WHERE         
   ID_WO_NO = @iv_ID_WO_NO AND ID_WO_PREFIX =  @iv_ID_WO_PREFIX                              
                                 
     SELECT @MechPcd = MAX(ID_MECPCD) FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @IV_ID_MEC_TR                                      
                                    
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
  wh.ID_WO_NO = @iv_ID_WO_NO                                          
  AND wh.ID_WO_PREFIX = @iv_ID_WO_PREFIX                                    
                                
        --Query for Fetching  Vehicle Group ID                                    
    SELECT                              
  @VehGrpPcd = VH_GROUP_ID,@WO_CREATED_BY=wh.CREATED_BY                                        
    FROM                                           
  TBL_WO_HEADER wh                                           
  JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                                           
  JOIN TBL_MAS_VHGROUPPC mvgp ON mv.ID_GROUP_VEH = mvgp.VH_GROUP_ID                                          
    WHERE                             
  wh.ID_WO_NO = @iv_ID_WO_NO                                          
  AND wh.ID_WO_PREFIX = @iv_ID_WO_PREFIX                                           
                                
    SELECT                                           
  @RepPkgPCD = ID_RPKG_SEQ,                                          
  @JobPcd = ID_JOBPCD_WO                                          
    FROM                                          
  TBL_WO_DETAIL wd                                           
  JOIN TBL_WO_HEADER wh ON wh.ID_WO_NO =  wd.ID_WO_NO AND wh.ID_WO_PREFIX = wd.ID_WO_PREFIX                                          
  LEFT JOIN TBL_MAS_REP_PACKAGE mrp ON mrp.ID_RPKG_SEQ = wd.ID_RPG_CODE_WO                                         
    WHERE                                         
  wh.ID_WO_NO = @iv_ID_WO_NO                                          
  AND wh.ID_WO_PREFIX = @iv_ID_WO_PREFIX                                          
  AND wd.ID_JOB = @iv_ID_JOB                               
                                
                                
    --select @WO_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd                               
                                
    EXEC [USP_WO_GetHPPrice] @WO_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE OUTPUT, @HPVAT OUTPUT                              
    SELECT @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE , @HPVAT,'TEST'                                           
    SELECT TOP 1 @VATPer = VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = @CustVATCode AND VAT_VEH = @VehVatCode AND VAT_ITEM = @HPVAT                                          
    AND DT_EFF_TO = '9999-12-31 23:59:59.000' Order by DT_EFF_FROM DESC                                         
                                
        --Select 'TBL_WO_LABOUR_DETAIL',@IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@II_ID_JOB_PREV                            
        --Added to fetch correct vat percentage,vatcode and vatacccode                            
    SELECT @DepID=ID_Dept_User FROM TBL_MAS_USERS                                     
    WHERE ID_Login=@WO_CREATED_BY                              
                                
    SELECT  @iv_ID_MAKE_PC_HP=ID_MAKE_PRICECODE  FROM  TBL_MAS_MAKE  WHERE  ID_MAKE=@MakePcd        
    SELECT @CUS_PC  = ID_CUST_PC_CODE FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@CustPcd        
    SELECT  @iv_ID_VEHGRP_PC_HP=VH_GROUP_PRICECODE FROM  TBL_MAS_VHGROUPPC  WHERE VH_GROUP_ID=@VehGrpPcd        
    SELECT  @RP_CODE = ID_RP_PRC_GRP FROM TBL_MAS_REP_PACKAGE  WHERE ID_RPKG_SEQ = @RepPkgPCD        
                                 
        ---------Hourly Price and labour vat -------------                                          
    DECLARE @CLOCKEDTIME1 AS DECIMAL(9,2)                            
    DECLARE @TIME2 AS VARCHAR(10)                            
    IF (@iv_ID_WO_NO IS NOT NULL AND @iv_ID_WO_PREFIX IS NOT NULL AND @iv_ID_JOB IS NOT NULL)                             
  BEGIN                            
   SET @CLOCKEDTIME1 = @Wo_Lab_Hrs                            
  END                            
                                       
        INSERT INTO TBL_WO_LABOUR_DETAIL                                                         
        SELECT                       
     CASE WHEN (@iv_ID_WO_NO IS NOT NULL AND @iv_ID_WO_PREFIX IS NOT NULL AND @iv_ID_JOB IS NOT NULL) THEN                                                          
      (SELECT ID_WODET_SEQ  FROM TBL_WO_DETAIL WHERE ID_WO_NO= @iv_ID_WO_NO AND ID_WO_PREFIX = @iv_ID_WO_PREFIX                                                           
    AND ID_JOB= @iv_ID_JOB)                                                          
     END AS 'WO_SEQ',                                                         
   @IV_ID_MEC_TR,                                                          
   CASE WHEN (@iv_ID_WO_NO IS NOT NULL AND @iv_ID_WO_PREFIX IS NOT NULL AND @iv_ID_JOB IS NOT NULL) THEN                                                                  
      @CLOCKEDTIME1                                     
   END AS 'TIME',                                                       
   --@HOURLYPRICE AS 'HP PRICE',                      
   @HourlyPr AS 'HP PRICE',                                       
     CASE WHEN @HPVAT='' THEN                                       
      NULL                                      
     ELSE                                      
      @HPVAT                             
     END AS 'HP VATCODE',                                            
     (SELECT VAT_ACCCODE FROM TBL_VAT_DETAIL WHERE VAT_CUST =                                                                 
      (SELECT                                        
     CASE WHEN ID_CUST_WO IS NOT NULL THEN                                                                    
        (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ =                                                                    
        (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER                                                                 
        WHERE ID_CUSTOMER = TBL_WO_HEADER.ID_CUST_WO ))                                    
     END                                                                    
      FROM TBL_WO_HEADER                                                                    
      WHERE ID_WO_NO = @iv_ID_WO_NO  AND ID_WO_PREFIX = @iv_ID_WO_PREFIX )                                                                    
      AND VAT_VEH  = (SELECT                                                               
    CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                                                    
    (SELECT ISNULL(ID_VAT_CD,@VAT_MCODE) FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                                                    
      END                                                                    
     FROM TBL_WO_HEADER                                                                    
     WHERE ID_WO_NO = @iv_ID_WO_NO AND ID_WO_PREFIX =  @iv_ID_WO_PREFIX  )                                                      
     AND VAT_ITEM =(Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE                                     
     ID_DEPT_HP = @DepID                                       
     AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                                        
     AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                                        
     AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                                        
     AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                                        
     AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                                      
     AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')              
     AND DT_EFF_TO is null     )                                      
     AND getdate() BETWEEN dt_eff_from AND dt_eff_to) ,                             
     (SELECT TOP 1 HP_ACC_CODE FROM  TBL_MAS_HP_RATE                                                      
     WHERE  DT_EFF_FROM = (SELECT   MAX(DT_EFF_FROM)                                                       
     FROM   TBL_MAS_HP_RATE where  ID_MECHPCD_HP = (SELECT TOP 1 ID_MECPCD FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @IV_ID_MEC_TR))),                                      
     @VATPer  ,                          
     @LAB_DESC,                          
     @SL_NO,    
     @WO_Lab_Discount                                   
                                
   update TBL_WO_LABOUR_DETAIL                                                     
   set                    
    WO_LABOURVAT_PERCENTAGE = (SELECT TOP 1 VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = (SELECT                                         
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
     WHERE TBL_WO_HEADER.ID_WO_NO = @iv_ID_WO_NO AND TBL_WO_HEADER.ID_WO_PREFIX = @iv_ID_WO_PREFIX                             
     AND ID_JOB = @iv_ID_JOB) AND ISNULL(CONVERT(VARCHAR,VAT_VEH),'-')  = (SELECT                                                                  
   CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                                                    
    (SELECT ISNULL(ID_VAT_CD,@VAT_MCODE) FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                                     
   END                                                                   
     FROM TBL_WO_HEADER                                                                 
     WHERE ID_WO_NO = @iv_ID_WO_NO AND ID_WO_PREFIX =  @iv_ID_WO_PREFIX  )                                                
     AND ISNULL(CONVERT(VARCHAR,VAT_ITEM),'-') = (Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE                                     
      ID_DEPT_HP = @DepID                                       
      AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                                        
      AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                                        
      AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                                        
      AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                                        
      AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                                      
      AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')                                      
      AND DT_EFF_TO is null     )                            
     AND DT_EFF_TO >= GETDATE())                                                      
    WHERE  ID_WODET_SEQ = @ID_WO_DETSEQ          
                                      
     END                
                         
     SET @INDEXLABLIST = @INDEXLABLIST + 1                   
  END        
                           
                                  
                                    
      IF @@ERROR <> 0                                  
   SET @OV_RETVALUE = @@ERROR                                      
                      
  IF @@ERROR <> 0                                 
   SET @OV_RETVALUE = @@ERROR                                      
                             
                              
   IF @@ERROR <> 0                                 
   SET @OV_RETVALUE = @@ERROR                                 
   ELSE                                
   SET @OV_RETVALUE = '0'                                     
End                                
                                
/*                                
exec USP_WO_InsMech '121','WO','admin',1,'<root><insert ID_MECH="Admin"/></root>'                                
                          
select * from TBL_WO_DETAIL                                 
select * from tbl_plan_job_detail                           
<root><insert ID_MECH="Admin"</root>                                
*/ 
GO

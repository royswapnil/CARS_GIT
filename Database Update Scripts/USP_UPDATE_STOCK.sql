/****** Object:  StoredProcedure [dbo].[USP_UPDATE_STOCK]    Script Date: 10/5/2017 3:51:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_UPDATE_STOCK]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_UPDATE_STOCK]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_STOCK]    Script Date: 10/5/2017 3:51:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_UPDATE_STOCK]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_UPDATE_STOCK] AS' 
END
GO
ALTER PROCEDURE [dbo].[USP_UPDATE_STOCK]               
(              
 @IV_XMLDOC NTEXT,             
 @IV_CREATEDBY VARCHAR(20),            
 @OV_RETVALUE VARCHAR(10)OUTPUT               
    
)              
AS              
BEGIN  
DECLARE @IDOC AS INT    
 EXEC SP_XML_PREPAREDOCUMENT @IDOC OUTPUT,@IV_XMLDOC  
 DECLARE @WO_NO_LIST TABLE            
 (    
     ID_SL_NO INT,          
  ID_WO_NO VARCHAR(10),            
  ID_WO_PREFIX VARCHAR(3),            
  ID_WODET_SEQ INT,            
  ID_JOB_DEB VARCHAR(10),            
  FLG_BATCH BIT ,      
  IV_DATE VARCHAR(10)       
 )   
   
 INSERT INTO @WO_NO_LIST             
 SELECT  
  ROW_NUMBER() OVER (ORDER BY ID_WODET_SEQ DESC),             
  ID_WO_NO ,            
  ID_WO_PREFIX ,            
  ID_WODET_SEQ ,            
  ID_JOB_DEB ,            
  FLG_BATCH ,            
  IV_DATE    
 FROM             
  OPENXML(@IDOC,'ROOT/INV_GENERATE',1)             
  WITH             
  (  
      ID_SL_NO INT,            
   ID_WO_NO VARCHAR(10),            
   ID_WO_PREFIX VARCHAR(3),            
   ID_WODET_SEQ INT,            
   ID_JOB_DEB VARCHAR(10),             
   FLG_BATCH BIT,               
   IV_DATE VARCHAR(10)            
  )             
             
 EXEC SP_XML_REMOVEDOCUMENT @IDOC   
   
 DECLARE @CNTWO AS INT  
 SELECT @CNTWO = COUNT(*) FROM @WO_NO_LIST  
 DECLARE @IDX AS INT  
 SET @IDX = 1  
   
 WHILE @IDX <= @CNTWO  
  BEGIN  
  DECLARE @WO_TYPE VARCHAR(20)  
  SELECT @WO_TYPE = WO_TYPE_WOH   
  FROM TBL_WO_HEADER WOH  
  INNER JOIN @WO_NO_LIST WL  
  ON WOH.ID_WO_NO = WL.ID_WO_NO AND WOH.ID_WO_PREFIX = WL.ID_WO_PREFIX  
  WHERE WL.ID_SL_NO = @IDX  
    
  UPDATE TEMP_IM    
  SET TEMP_IM.ITEM_AVAIL_QTY = (TEMP_IM.ITEM_AVAIL_QTY) + (JOBDET.JOBI_DELIVER_QTY)    
  FROM TBL_MAS_ITEM_MASTER TEMP_IM     
  INNER JOIN TBL_WO_JOB_DETAIL JOBDET ON TEMP_IM.ID_ITEM=JOBDET.ID_ITEM_JOB AND TEMP_IM.ID_WH_ITEM = JOBDET.ID_WAREHOUSE AND JOBDET.ID_MAKE_JOB=TEMP_IM.SUPP_CURRENTNO    
  INNER JOIN TBL_WO_HEADER WH ON WH.ID_WO_NO = JOBDET.ID_WO_NO AND WH.ID_WO_PREFIX = JOBDET.ID_WO_PREFIX AND WH.WO_TYPE_WOH='KRE' AND ISNULL(TEMP_IM.FLG_STOCKITEM_STATUS,1) = 1   
  AND ISNULL(JOBDET.SPARE_TYPE,'ORD') <> 'EFD'   
  INNER JOIN @WO_NO_LIST WL  
  ON WL.ID_WO_NO = JOBDET.ID_WO_NO AND WL.ID_WO_PREFIX = JOBDET.ID_WO_PREFIX  
  --WHERE JOBDET.ID_WO_NO=@IV_ID_WO_NO AND JOBDET.ID_WO_PREFIX = @IV_ID_WO_PREFIX    
    
  SET @IDX = @IDX + 1  
    
  END  
   
   
    
END 
GO

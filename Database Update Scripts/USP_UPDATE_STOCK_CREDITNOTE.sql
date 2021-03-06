/****** Object:  StoredProcedure [dbo].[USP_UPDATE_STOCK_CREDITNOTE]    Script Date: 10/5/2017 3:48:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_UPDATE_STOCK_CREDITNOTE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_UPDATE_STOCK_CREDITNOTE]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_STOCK_CREDITNOTE]    Script Date: 10/5/2017 3:48:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_UPDATE_STOCK_CREDITNOTE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_UPDATE_STOCK_CREDITNOTE] AS' 
END
GO
    
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: The stock should be updated back ( put back the delivered qty )only when KRE Orders are invoiced    
-- =============================================    
ALTER PROCEDURE [dbo].[USP_UPDATE_STOCK_CREDITNOTE]     
    @IV_ID_WO_NO   VARCHAR(10),                                          
    @IV_ID_WO_PREFIX  VARCHAR(3),    
    @CREATED_BY VARCHAR(100),                                        
    @OV_RETVALUE   VARCHAR(100)  OUTPUT       
AS    
BEGIN    
    
 DECLARE @TRANNAME VARCHAR(20);                               
 SELECT @TRANNAME = 'UPDATE_STOCK'                               
 BEGIN TRANSACTION @TRANNAME    
     
  --SELECT JOBDET.* INTO #TEMPSPARELIST     
  --FROM TBL_WO_JOB_DETAIL JOBDET    
  --INNER JOIN TBL_WO_HEADER WH ON WH.ID_WO_NO = JOBDET.ID_WO_NO AND WH.ID_WO_PREFIX = JOBDET.ID_WO_PREFIX AND WH.WO_TYPE_WOH='KRE'    
  --WHERE JOBDET.ID_WO_NO=@IV_ID_WO_NO AND JOBDET.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
    
  --UPDATE THEM BACK TO STOCK BASED ON CONDITIONS    
    
  UPDATE TEMP_IM    
  SET TEMP_IM.ITEM_AVAIL_QTY = (TEMP_IM.ITEM_AVAIL_QTY) + (JOBDET.JOBI_DELIVER_QTY)    
  FROM TBL_MAS_ITEM_MASTER TEMP_IM     
  INNER JOIN TBL_WO_JOB_DETAIL JOBDET ON TEMP_IM.ID_ITEM=JOBDET.ID_ITEM_JOB AND TEMP_IM.ID_WH_ITEM = JOBDET.ID_WAREHOUSE AND JOBDET.ID_MAKE_JOB=TEMP_IM.SUPP_CURRENTNO    
  INNER JOIN TBL_WO_HEADER WH ON WH.ID_WO_NO = JOBDET.ID_WO_NO AND WH.ID_WO_PREFIX = JOBDET.ID_WO_PREFIX AND WH.WO_TYPE_WOH='KRE' AND ISNULL(TEMP_IM.FLG_STOCKITEM_STATUS,1) = 1     
  AND ISNULL(JOBDET.SPARE_TYPE,'ORD') <> 'EFD'     
  WHERE JOBDET.ID_WO_NO=@IV_ID_WO_NO AND JOBDET.ID_WO_PREFIX = @IV_ID_WO_PREFIX    
     
 -- SET RETURN VALUE    
  IF @@ERROR <> 0                              
    BEGIN                              
   ROLLBACK TRANSACTION @TRANNAME                              
     SET @OV_RETVALUE = 'ERROR'                         
     RETURN                               
    END    
  ELSE IF @@ERROR=0    
    BEGIN    
  COMMIT TRANSACTION @TRANNAME    
  SET @OV_RETVALUE = 'UPDATED_STOCK'     
  RETURN    
    END                            
     
END 
GO

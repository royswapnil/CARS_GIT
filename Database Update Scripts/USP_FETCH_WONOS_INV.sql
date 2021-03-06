/****** Object:  StoredProcedure [dbo].[USP_FETCH_WONOS_INV]    Script Date: 10/11/2017 5:47:43 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_WONOS_INV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_WONOS_INV]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_WONOS_INV]    Script Date: 10/11/2017 5:47:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_WONOS_INV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_WONOS_INV] AS' 
END
GO
/*************************************** Application: MSG *************************************************************              
* Module : INVOICE              
* File name : USP_FETCH_WO_INV.PRC              
* Purpose : To Fetch Work Orders from Invoice .               
* Author : Smita m              
* Date  : 13.09.2017              
*********************************************************************************************************************/                
              
ALTER PROCEDURE [dbo].[USP_FETCH_WONOS_INV]               
(         
@ID_INV_NO VARCHAR(50),      
@OV_RETVAL VARCHAR(7000) OUTPUT         
)        
AS        
BEGIN        
         
 SELECT DISTINCT ID_WO_NO,ID_WO_PREFIX,CREATED_BY INTO #TEMP        
     FROM TBL_INV_DETAIL         
     WHERE ID_INV_NO = @ID_INV_NO        
    ---SELECT '#TEMP',* FROM #TEMP  INCLUDE JOBID    
    
  SELECT ROW_NUMBER() OVER (ORDER BY ID_WO_NO) AS ID_SL_NO, ID_WO_NO,ID_WO_PREFIX,CREATED_BY INTO #TEMPWO  
  FROM #TEMP 
             
DECLARE @INDEX INT        
DECLARE @TOTALCNT INT      
DECLARE @OV_INVLIST VARCHAR(7000) =''           
DECLARE @OV_INVL VARCHAR(7000) =''      
SET @INDEX = 1     
      
SELECT @TOTALCNT = COUNT(*) FROM #TEMPWO        
        
WHILE @INDEX <= @TOTALCNT        
BEGIN        
 DECLARE @ID_WO_NO VARCHAR(30)        
 DECLARE @ID_WO_PREFIX VARCHAR(10)        
 DECLARE @CREATEDBY VARCHAR(20)        
         
 SELECT @ID_WO_NO = ID_WO_NO,@ID_WO_PREFIX = ID_WO_PREFIX,@CREATEDBY = CREATED_BY FROM #TEMPWO WHERE ID_SL_NO = @INDEX         
 --SELECT @ID_WO_NO ,@ID_WO_PREFIX ,@CREATEDBY        
 EXEC USP_CREATE_DUP_WO @ID_WO_NO,@ID_WO_PREFIX,@CREATEDBY,@OV_INVLIST OUTPUT        
 SET @OV_INVL = @OV_INVL + @OV_INVLIST      
        
 SET @INDEX = @INDEX + 1      
END       
      
--print @OV_INVL      
--SELECT '@OV_INVL',@OV_INVL 

UPDATE TBL_INV_HEADER
SET FLG_KRE_ORD = 1
WHERE ID_INV_NO = @ID_INV_NO       
      
SET @OV_INVL = '<ROOT>'+ @OV_INVL + '</ROOT>'      
      
--print @OV_INVL      
 SET @OV_RETVAL = @OV_INVL      
 DROP TABLE #TEMP        
        
END
GO

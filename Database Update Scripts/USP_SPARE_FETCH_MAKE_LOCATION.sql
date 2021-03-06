/****** Object:  StoredProcedure [dbo].[USP_SPARE_FETCH_MAKE_LOCATION]    Script Date: 11/17/2016 11:22:13 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPARE_FETCH_MAKE_LOCATION]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPARE_FETCH_MAKE_LOCATION]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPARE_FETCH_MAKE_LOCATION]    Script Date: 11/17/2016 11:22:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPARE_FETCH_MAKE_LOCATION]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPARE_FETCH_MAKE_LOCATION] AS' 
END
GO
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
ALTER PROCEDURE [dbo].[USP_SPARE_FETCH_MAKE_LOCATION]   
@ID_MAKE VARCHAR(10)  
AS  
BEGIN  
   
 SET NOCOUNT ON;  
 SELECT         
        UPPER(ID_MAKE) AS ID_SETTINGS,ID_MAKE + '   -   ' + ID_MAKE_NAME AS ID_PARAM,MAKE_VATCODE        
    FROM         
        TBL_MAS_MAKE     
    WHERE ID_MAKE LIKE @ID_MAKE +'%'      
    ORDER BY ID_SETTINGS    
      
    SELECT DISTINCT LOCATION FROM TBL_MAS_ITEM_MASTER WHERE LOCATION LIKE @ID_MAKE + '%'  
      
    --Default Settings  
     
      SELECT ID_SP_SETT,ID_MAKE,ID_SUPPLIER,LOCATION,FLG_STOCK_ITEM,FLG_STOCKITEM_STATUS,FLG_NONSTOCKITEM_STATUS FROM TBL_SPR_SETTINGS       
       
END  
  
  
GO

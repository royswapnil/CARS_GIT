/****** Object:  StoredProcedure [dbo].[USP_SAMPLE_ORDER_FETCH]    Script Date: 2/2/2018 2:42:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SAMPLE_ORDER_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SAMPLE_ORDER_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_SAMPLE_ORDER_FETCH]    Script Date: 2/2/2018 2:42:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SAMPLE_ORDER_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SAMPLE_ORDER_FETCH] AS' 
END
GO
    
    
-- =============================================    
-- Author:  <Thomas Won Nyheim>    
-- Create date: <24/04/2015>    
-- Description: <Fetches search result for orders with order head data>    
-- =============================================    
ALTER PROCEDURE [dbo].[USP_SAMPLE_ORDER_FETCH]     
@ID_SEARCH VARCHAR(50)    
AS    
BEGIN    
 SET NOCOUNT ON;   
 IF LEN(@ID_SEARCH)>=2                    
	BEGIN  
	  SELECT TOP 50 ID_WO_PREFIX + ID_WO_NO as ORDERNO, ID_WO_PREFIX + ID_WO_NO + '-' +  WO_CUST_NAME + '-' +  WO_VEH_REG_NO + '-' +  WO_CUST_PHONE_MOBILE + '-' +  WO_CUST_PERM_ADD1 AS ORDERDATA, WO_CUST_NAME, WO_CUST_PERM_ADD1, WO_VEH_REG_NO, WO_STATUS, ID_WO_NO, ID_WO_PREFIX FROM TBL_WO_HEADER    
	  WHERE ID_WO_PREFIX+ID_WO_NO+WO_CUST_NAME+ID_CUST_WO+WO_VEH_REG_NO LIKE '%' + @ID_SEARCH + '%' and WO_STATUS not in('INV', 'DEL') and ID_Dept in('22', '10')    
	  ORDER BY ID_WO_PREFIX+ID_WO_NO    
	END 
END   
    
--EXEC USP_SAMPLE_ORDER_FETCH @ID_SEARCH = 'OMNES D10' 
GO

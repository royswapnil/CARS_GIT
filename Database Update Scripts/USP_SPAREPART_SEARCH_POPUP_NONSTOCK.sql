/****** Object:  StoredProcedure [dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK]    Script Date: 10/25/2017 2:59:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK]    Script Date: 10/25/2017 2:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK] AS' 
END
GO
   
  
ALTER PROCEDURE [dbo].[USP_SPAREPART_SEARCH_POPUP_NONSTOCK]     
@ID_SEARCH VARCHAR(255),  
@SUPPLIER AS VARCHAR(50)=NULL  
  
AS    
  
BEGIN  
  
 DECLARE @MAINQRY AS NVARCHAR(MAX)  
 DECLARE @CQRY AS NVARCHAR(MAX)  
  
 SET @MAINQRY = N'SELECT [ID_ITEM]   
      ,[ITEM_DESC_NAME2]  
      ,[ID_UNIT_ITEM]  
      ,[ITEM_DESC]  
      ,[ID_MAKE]  
      ,[ID_ITEM_MODEL]  
      ,[ID_ITEM_CATG]  
      ,[ITEM_REORDER_LEVEL]  
      ,[ITEM_DISC_CODE]  
      ,[ITEM_DISC_CODE_BUY]  
      ,[BASIC_PRICE]  
      ,[ITEM_PRICE]  
      ,[COST_PRICE1]  
      ,[COST_PRICE2]  
      ,[PACKAGE_QTY]  
      ,[ID_VAT_CODE]  
      ,[ACCOUNT_CODE]  
      ,[FLG_CALC_PRICE]  
      ,[FLG_DUTY]  
      ,[CREATED_BY]  
      ,[DT_CREATED]  
      ,[MODIFIED_BY]  
      ,[DT_MODIFIED]  
      ,[ID_CURRENCY]  
      ,[ID_SPCATEGORY]  
      ,[SUPP_CURRENTNO]    
   FROM [dbo].[TBL_SPR_GLOBALSPAREPART] '  
    
    
 SET @CQRY = 'WHERE (ID_MAKE like ''%' + @ID_SEARCH + '%'' or ID_ITEM like ''%' + @ID_SEARCH + '%'' or ITEM_DESC like ''%' + @ID_SEARCH + '%'')'  
  
 IF @SUPPLIER IS NOT NULL AND @SUPPLIER <> '' AND @SUPPLIER <>'%'  
  SET @CQRY = @CQRY + ' AND SUPP_CURRENTNO LIKE ''%' + @SUPPLIER + '%'''  
  
  
 SET @MAINQRY = @MAINQRY + @CQRY  
  
 PRINT @MAINQRY  
  
 EXEC (@MAINQRY)  
  
END
GO

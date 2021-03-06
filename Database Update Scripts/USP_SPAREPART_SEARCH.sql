/****** Object:  StoredProcedure [dbo].[USP_SPAREPART_SEARCH]    Script Date: 5/12/2017 3:30:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPAREPART_SEARCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPAREPART_SEARCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPAREPART_SEARCH]    Script Date: 5/12/2017 3:30:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPAREPART_SEARCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPAREPART_SEARCH] AS' 
END
GO
    
      
ALTER PROCEDURE [dbo].[USP_SPAREPART_SEARCH]       
@ID_SEARCH VARCHAR(255)      
AS      
      
SELECT [ID_ITEM]    
      ,[ITEM_DESC]    
      ,[ITEM_DESC_NAME2]    
      ,[ID_UNIT_ITEM]    
      ,[ID_MAKE]    
      ,[ID_ITEM_MODEL]    
      ,[ID_ITEM_CATG]    
      ,[ID_SUPPLIER_ITEM]    
      ,[ITEM_AVAIL_QTY]    
      ,[ID_WH_ITEM]    
      ,[ITEM_REORDER_LEVEL]    
      ,[ITEM_DISC_CODE]    
      ,[ITEM_DISC_CODE_BUY]    
      ,[BASIC_PRICE]    
      ,[ITEM_PRICE]    
      ,[COST_PRICE1]    
      ,[COST_PRICE2]    
      ,[LOCATION]    
      ,[PACKAGE_QTY]    
      ,[ID_VAT_CODE]    
      ,[ACCOUNT_CODE]    
      ,[FLG_ALLOW_BCKORD]    
      ,[FLG_CALC_PRICE]    
      ,[FLG_CNT_STOCK]    
      ,[FLG_DUTY]    
      ,[CREATED_BY]    
      ,[DT_CREATED]    
      ,[MODIFIED_BY]    
      ,[DT_MODIFIED]    
      ,[Class_Code]    
      ,[ID_SPCATEGORY]    
      ,[AVG_PRICE]    
      ,[QTY_NOT_DELIVERED]    
      ,[QTY_BO_SUPPLIER]    
      ,[LAST_BUY_PRICE]    
      ,[DT_LAST_BUY]    
      ,[MIN_STOCK]    
      ,[MAX_STOCK]    
      ,[FLG_BLOCK_AUTO_ORD]    
      ,[TD_CALC]    
      ,[FLG_STOCKITEM]    
      ,[VA_EXCHANGE_VEH]    
      ,[VA_ORDER_COST]    
      ,[FLG_STOCKITEM_STATUS]    
      ,[ENV_ID_ITEM]    
      ,[ENV_ID_MAKE]    
      ,[ENV_ID_WAREHOUSE]    
      ,[FLG_EFD]    
      ,[ALT_LOCATION]    
      ,[ANNOTATION]    
      ,[FLG_VAT_INCL]    
      ,[FLG_OBTAIN_SPARE]    
      ,[FLG_OBSOLETE_SPARE]    
      ,[FLG_AUTOADJUST_PRICE]    
      ,[FLG_LABELS]    
      ,[FLG_ALLOW_DISCOUNT]    
      ,[DISCOUNT]    
      ,[LAST_COST_PRICE]
      ,[SUPP_CURRENTNO]    
  FROM [dbo].[TBL_MAS_ITEM_MASTER]    
  WHERE ID_MAKE like '%' + @ID_SEARCH + '%' or ID_ITEM like '%' + @ID_SEARCH + '%' or ITEM_DESC like '%' + @ID_SEARCH + '%' or LOCATION like '%' + @ID_SEARCH + '%' or ID_SUPPLIER_ITEM like '%' + @ID_SEARCH + '%'    
      
-- SELECT * FROM #tmp_res ORDER BY VEH_REG_NO ASC -- Matches all results from all queries      
    
      

GO

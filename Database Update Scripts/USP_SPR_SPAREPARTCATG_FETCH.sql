/****** Object:  StoredProcedure [dbo].[USP_SPR_SPAREPARTCATG_FETCH]    Script Date: 5/24/2017 2:40:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_SPAREPARTCATG_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPR_SPAREPARTCATG_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_SPAREPARTCATG_FETCH]    Script Date: 5/24/2017 2:40:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_SPAREPARTCATG_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPR_SPAREPARTCATG_FETCH] AS' 
END
GO
/*************************************** Application: MSG *************************************************************      
* Module : SPAREPARTS      
* File name : USP_SPR_SPAREPARTCATG_FETCH      
* Purpose : To FETCH THE SPARE PART CATEGORY DETAIL      
* Author : MAHESHWARAAN S      
* Date  : 25/10/07      
*********************************************************************************************************************/      
/*********************************************************************************************************************        
I/P : --       
O/P :--       
Error Code      
Description      
INT.VerNO :        
********************************************************************************************************************/      
--'*********************************************************************************'*********************************      
--'* Modified History :         
--'* S.No  RFC No/Bug ID   Date        Author  Description       
--*#0001#      
--'*********************************************************************************'*********************************      
ALTER PROCEDURE [dbo].[USP_SPR_SPAREPARTCATG_FETCH]      
@IV_Lang VARCHAR(30)='ENGLISH'      
AS      
BEGIN      
      
SET NOCOUNT ON      
      
BEGIN TRY      
  DECLARE @LANG INT        
  SELECT @LANG=ID_LANG FROM TBL_MAS_LANGUAGE WHERE LANG_NAME=@iv_Lang      
      
      
  DECLARE @TRUE AS VARCHAR(50)      
  SELECT @TRUE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_TRUE' AND ISDATA=1      
      
  DECLARE @FALSE AS VARCHAR(50)      
  SELECT @FALSE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_FALSE' AND ISDATA=1      
      
  SELECT       
   S.ID_ITEM_CATG,      
   D1.DISCOUNTCODE AS 'DISCOUNTBUY',      
   S.ID_DISCOUNTCODEBUY,      
   D2.DISCOUNTCODE AS 'DISCOUNTSELL',      
   S.ID_DISCOUNTCODESELL,      
   SU.SUP_NAME AS 'SUPPLIER',      
   S.ID_SUPPLIER,      
   M.ID_MAKE,      
   M.ID_MAKE_NAME,      
   S.CATG_DESC AS CATEGORY,      
   S.DESCRIPTION,      
   S.INITIALCLASSCODE,      
   V.DESCRIPTION AS 'VATCODE',      
   S.VATCODE AS 'ID_VATCODE',      
   S.ACCOUNTCODE,      
   S.FLG_ALLOWBO AS FLG_ALLOWBO_L,      
   S.FLG_COUNTSTOCK AS FLG_COUNTSTOCK_L,      
   S.FLG_ALLOWCLASS AS FLG_ALLOWCLASS_L,      
   CASE WHEN S.FLG_ALLOWBO =1 THEN @TRUE ELSE @FALSE END AS FLG_ALLOWBO,      
   CASE WHEN S.FLG_COUNTSTOCK =1 THEN @TRUE ELSE @FALSE END AS FLG_COUNTSTOCK,      
   CASE WHEN S.FLG_ALLOWCLASS =1 THEN @TRUE ELSE @FALSE  END AS FLG_ALLOWCLASS,    
   S.SUPP_CURRENTNO AS 'SUPP_CURRENTNO'      
  FROM TBL_MAS_ITEM_CATG S      
  LEFT JOIN TBL_MAS_MAKE M ON M.ID_MAKE = S.ID_MAKE        
  LEFT JOIN TBL_SPR_DISCOUNTCODE D1 ON D1.ID_DISCOUNTCODE = S.ID_DISCOUNTCODEBUY      
  LEFT JOIN TBL_SPR_DISCOUNTCODE D2 ON D2.ID_DISCOUNTCODE =  S.ID_DISCOUNTCODESELL      
  LEFT JOIN TBL_MAS_SUPPLIER SU ON SU.ID_SUPPLIER = S.ID_SUPPLIER      
  LEFT JOIN TBL_MAS_SETTINGS V ON V.ID_SETTINGS = S.VATCODE      
  order by  s.ID_ITEM_CATG      
      
END TRY      
 BEGIN CATCH      
  -- Execute error retrieval routine.      
  EXECUTE usp_GetErrorInfo;      
END CATCH;        
END      
      
      
      
      
      
      
      
      
      
GO

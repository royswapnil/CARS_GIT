/****** Object:  StoredProcedure [dbo].[USP_FETCH_ENVSEARCHDETAILS]    Script Date: 5/12/2017 3:28:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_ENVSEARCHDETAILS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_ENVSEARCHDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_ENVSEARCHDETAILS]    Script Date: 5/12/2017 3:28:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_ENVSEARCHDETAILS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_ENVSEARCHDETAILS] AS' 
END
GO
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: SEARCH RESULTS OF ENV FEES    
-- =============================================    
ALTER PROCEDURE [dbo].[USP_FETCH_ENVSEARCHDETAILS]    
@ID_WH INT,    
@SPAREPART VARCHAR(50),    
@NAME VARCHAR(20),    
@IV_ID_LOGIN VARCHAR(20)    
AS    
BEGIN    
SET NOCOUNT ON;    
 BEGIN TRY    
  DECLARE @DEP_NAME VARCHAR(20)    
 SELECT @DEP_NAME=DPT_Name from TBL_MAS_DEPT where ID_Dept IN(SELECT ID_Dept_User from TBL_MAS_USERS     
 WHERE ID_Login=@IV_ID_LOGIN)     
   SELECT    
  ROW_NUMBER() OVER(ORDER BY ENV.ID_ENVFEE ) AS SLNO,    
  ENV.ID_WAREHOUSE AS WAREHOUSE,     
  ENV.ID_ITEM,    
  ENV.MIN_AMT,    
  ENV.MAX_AMT,    
  ENV.ADDED_FEE_PERCENTAGE,    
  ENV.NAME,    
  MAS.[DESCRIPTION] AS VAT_CODE,    
  ENV.ID_MAKE,    
  ENV.ID_WAREHOUSE,  
  isNULL(ENV.SUPP_CURRENTNO,'') as SUPP_CURRENTNO    
  FROM TBL_MAS_ENVFEESETTINGS ENV    
  INNER JOIN TBL_MAS_SETTINGS MAS    
  ON ENV.VAT_CODE=MAS.ID_SETTINGS    
  --LEFT OUTER JOIN     
  --TBL_MAS_DEPT DEPT ON    
  --ENV.ID_DEPARTMENT=DEPT.ID_Dept    
  WHERE    
  ENV.ID_ITEM LIKE '' + @SPAREPART + '%'    
  AND ENV.NAME LIKE '' + @NAME + '%'    
  AND ENV.ID_WAREHOUSE=@ID_WH    
      
 END TRY    
 BEGIN CATCH    
     
  EXECUTE usp_GetErrorInfo;    
 END CATCH;     
    
END    
    

GO

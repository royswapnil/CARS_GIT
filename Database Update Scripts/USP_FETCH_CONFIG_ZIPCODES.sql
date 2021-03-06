/****** Object:  StoredProcedure [dbo].[USP_FETCH_CONFIG_ZIPCODES]    Script Date: 06/19/2015 11:40:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_CONFIG_ZIPCODES]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_CONFIG_ZIPCODES]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_CONFIG_ZIPCODES]    Script Date: 06/19/2015 11:40:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_CONFIG_ZIPCODES]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Praveen
-- Create date: <Create Date,,>
-- Description:	To fetch the zipcodes
-- =============================================
CREATE PROCEDURE [dbo].[USP_FETCH_CONFIG_ZIPCODES] 
 @IV_ZIPCODE  VARCHAR(50),            
 @IV_ID_LOGIN VARCHAR(20)AS
BEGIN                  
     
if @IV_ZIPCODE <>''''       
      
	SELECT 
		  [ZIP_ZIPCODE] AS  ''Zip Code''      
		  , CNTRY.DESCRIPTION as ''Country''      
		  ,STATE.DESCRIPTION  as ''State''      
		  ,[ZIP_CITY] as ''City''	           
	 FROM TBL_MAS_ZIPCODE zip      
	 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS CNTRY ON zip.ZIP_ID_COUNTRY=CNTRY.ID_PARAM      
	 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS STATE ON zip.ZIP_ID_STATE = state.ID_PARAM   
	 WHERE zip.ZIP_ZIPCODE like   @IV_ZIPCODE +''%''    
ELSE      
	SELECT 
		  [ZIP_ZIPCODE]  as ''Zip Code'',
		  CNTRY.[DESCRIPTION] as ''Country'',      
		  [STATE].[DESCRIPTION] as ''State'',      
		  [ZIP_CITY] as ''City''      
	 FROM TBL_MAS_ZIPCODE zip      
	 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS CNTRY ON zip.ZIP_ID_COUNTRY=CNTRY.ID_PARAM      
	 LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS STATE ON zip.ZIP_ID_STATE = state.ID_PARAM    
     
 END    
' 
END
GO

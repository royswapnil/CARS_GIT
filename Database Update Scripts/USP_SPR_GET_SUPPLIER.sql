/****** Object:  StoredProcedure [dbo].[USP_SPR_GET_SUPPLIER]    Script Date: 10/28/2016 4:46:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_GET_SUPPLIER]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPR_GET_SUPPLIER]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_GET_SUPPLIER]    Script Date: 10/28/2016 4:46:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_GET_SUPPLIER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPR_GET_SUPPLIER] AS' 
END
GO


/*************************************** APPLICATION: MSG *************************************************************  
* MODULE	: SS3  
* FILE NAME : USP_INSERT_EXPORT_IR.PRC  
* PURPOSE	: Get Supplier By ID or Name			
* AUTHOR	: ----------
* DATE		: 19.OCT.2009  
*********************************************************************************************************************/ 
 --USP_GET_SUPPLIER '%'
ALTER PROCEDURE [dbo].[USP_SPR_GET_SUPPLIER] (
	@SUPPLIER VARCHAR(50)=''
	
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
	SET NOCOUNT ON;  

	SELECT  
			SUPP_CURRENTNO  + '-' + SUP_NAME  as 'SUPPLIER' ,ID_SUPPLIER AS 'SUPPLIER ID',SUPP_CURRENTNO as 'SUPPLIER_NO'
	FROM 
			TBL_MAS_SUPPLIER
	WHERE 
			(SUPP_CURRENTNO 	LIKE '' + @SUPPLIER + '%'
			   OR SUP_NAME LIKE '' + @SUPPLIER + '%'
			)	   
	ORDER BY 
			SUPP_CURRENTNO  
    SET NOCOUNT OFF;  
END






GO

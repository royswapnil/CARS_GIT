/****** Object:  StoredProcedure [dbo].[USP_FETCH_INVOICENOS]    Script Date: 11/15/2017 11:44:28 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_INVOICENOS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_INVOICENOS]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_INVOICENOS]    Script Date: 11/15/2017 11:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_INVOICENOS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_INVOICENOS] AS' 
END
GO

ALTER PROCEDURE [dbo].[USP_FETCH_INVOICENOS]                          
 @ID_WO_NO VARCHAR(30),      
 @ID_WO_PREFIX VARCHAR(10)        
                              
AS                          
BEGIN 
	CREATE TABLE #TEMPINV                             
	 (                            
	  ID_NOTINV INT IDENTITY(1,1) NOT NULL,                      
	  ID_INV_NO VARCHAR(50)                            
	 )
	 INSERT INTO #TEMPINV
	 SELECT ID_INV_NO FROM TBL_INV_DETAIL WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX 
	 
	 SELECT ID_INV_NO FROM #TEMPINV
	 
END
GO

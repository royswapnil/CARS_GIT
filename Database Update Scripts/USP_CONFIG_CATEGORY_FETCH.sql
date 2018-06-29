USE [CARSDEV]
GO

/****** Object:  StoredProcedure [dbo].[USP_CONFIG_CATEGORY_FETCH]    Script Date: 03.10.2017 11:15:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




    
  
  
/*************************************** Application: PPMS *************************************************************  
* Module : Configuration  
* File name : USP_CONFIG_MAKE_FETCH.sql  
* Purpose : To get Configuration Details.   
* Author : Krishnaveni  
* Date  : 20.07.2006  
*********************************************************************************************************************/  
/*********************************************************************************************************************    
I/P : -- Input Parameters  
O/P :-- Output Parameters  
Error Code  
Description  
  INT.VerNO : NOV21.0 
********************************************************************************************************************/  
--'*********************************************************************************'*********************************  
--'* Modified History :     
--'* S.No  RFC No/Bug ID   Date        Author  Description   
--*#0001#  
--'*********************************************************************************'*********************************  
  
  
CREATE PROCEDURE [dbo].[USP_CONFIG_CATEGORY_FETCH]
@ID_SUPPLIER	VARCHAR(50)  
AS  
BEGIN
	IF @ID_SUPPLIER =   ''
		select ID_ITEM_CATG, CATG_DESC, SUPP_CURRENTNO
		from TBL_MAS_ITEM_CATG
		ORDER BY CATG_DESC ASC
	ELSE
		select ID_ITEM_CATG, CATG_DESC, SUPP_CURRENTNO
		from TBL_MAS_ITEM_CATG
		WHERE SUPP_CURRENTNO = @ID_SUPPLIER
		ORDER BY CATG_DESC ASC
		     
END  
  
/*  
exec USP_CONFIG_MAKE_FETCH   
  
  
*/  
  
  



GO


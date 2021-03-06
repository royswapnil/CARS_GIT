/****** Object:  StoredProcedure [dbo].[USP_TR_FETCH_JOB]    Script Date: 1/30/2018 5:30:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_TR_FETCH_JOB]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_TR_FETCH_JOB]
GO
/****** Object:  StoredProcedure [dbo].[USP_TR_FETCH_JOB]    Script Date: 1/30/2018 5:30:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_TR_FETCH_JOB]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_TR_FETCH_JOB] AS' 
END
GO
  
  
/*************************************** APPLICATION: MSG *************************************************************  
* MODULE : TRANSACTION  
* FILE NAME : USP_TR_FETCH_WO.PRC  
* PURPOSE : To fetch all the orders in the garage  
* AUTHOR : Jayakrishnan PR  
* DATE  : 09.08.2006  
*********************************************************************************************************************/  
/*********************************************************************************************************************    
I/P : -- INPUT PARAMETERS  
O/P : -- OUTPUT PARAMETERS  
ERROR CODE  
DESCRIPTION  
INT.VerNO : NOV21.0   
********************************************************************************************************************/  
--'*********************************************************************************'*********************************  
--'* MODIFIED HISTORY :     
--'* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION   
--*#0001#   Bug # 3161    14Jul07    Dhanu       Fixed
--'*********************************************************************************'*********************************  
  
ALTER PROC [dbo].[USP_TR_FETCH_JOB]  
  
 (  
  @iv_WO_NO  VARCHAR(10)  
 )  
  
AS  
BEGIN  
  
	SELECT DISTINCT ID_JOB  
	FROM TBL_TR_JOB_ACTUAL 
	WHERE ID_WO_PREFIX + ID_WO_NO = @iv_WO_NO   --Bug # 3161 
  
END  
  
  
  
  
  
  
  
/*  
  
EXEC USP_TR_FETCH_JOB 'WO101'
  
*/  
  

GO

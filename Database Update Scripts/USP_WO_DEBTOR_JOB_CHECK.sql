/****** Object:  StoredProcedure [dbo].[USP_WO_DEBTOR_JOB_CHECK]    Script Date: 2/24/2017 11:36:23 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBTOR_JOB_CHECK]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DEBTOR_JOB_CHECK]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DEBTOR_JOB_CHECK]    Script Date: 2/24/2017 11:36:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBTOR_JOB_CHECK]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DEBTOR_JOB_CHECK] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                  
* Module : Work Order                 
* File name : USP_WO_DEBTOR_JOB_CHECK                  
* Purpose : To find the list of debtors and jobs who do not have jobs belonging to main debtor      
* Author : Swapnil Roy       
* Date  : 14.02.2017                
*********************************************************************************************************************/                  
/*********************************************************************************************************************                    
I/P : -- Input Parameters                  
O/P : -- Output Parameters                  
Error Code                  
Description          
Limitations: Cannot handle any scenario where more than one debtor of the same type exists in the same order.              
 INT.VerNO :                    
********************************************************************************************************************/                  
--'*********************************************************************************'*********************************                    
--'* Modified History :                       
--'* S.No  RFC No/Bug ID   Date        Author             Description                     
--*      
--'*********************************************************************************'*********************************                    
                
ALTER PROC [dbo].[USP_WO_DEBTOR_JOB_CHECK]                 
(                 
 @ID_WO_PREFIX AS varchar(10),                
 @ID_WO_NO  VARCHAR(10) ,                    
 @ID_USER  VARCHAR(50)       
)                
AS                  
BEGIN                 
      
  DECLARE @DEB1 VARCHAR(50)      
  DECLARE @DEB2 VARCHAR(50)      
  DECLARE @DEBTYPE1 VARCHAR(50)      
  DECLARE @DEBTYPE2 VARCHAR(50)      
        
  SELECT ID_JOB_DEB,ID_JOB_ID,CUST_TYPE ,DEB_STATUS 
  INTO #MAINCUST 
  FROM TBL_WO_DEBITOR_DETAIL 
  WHERE ID_WO_PREFIX=@ID_WO_PREFIX AND ID_WO_NO=@ID_WO_NO AND CUST_TYPE='OHC'  
      
  --SELECT * FROM #MAINCUST      
      
      
  SELECT DISTINCT ID_JOB_DEB,ID_JOB_ID,CUST_TYPE,DEB_STATUS  
  INTO #DEB1 
  FROM TBL_WO_DEBITOR_DETAIL 
  WHERE CUST_TYPE IN ('INSC','INTC') AND ID_WO_PREFIX=@ID_WO_PREFIX AND ID_WO_NO=@ID_WO_NO      
  
  --SELECT * FROM #DEB1      
  
  SET @DEB1 = (SELECT TOP 1 ID_JOB_DEB FROM #DEB1)      
  SET @DEBTYPE1 = (SELECT TOP 1 CUST_TYPE FROM #DEB1)      
  
  --SELECT DISTINCT @DEB1 'ID_CUSTOMER',@DEBTYPE1 'CUST_TYPE',ID_JOB_ID 
  --FROM #MAINCUST 
  --WHERE ID_JOB_ID NOT IN (SELECT ID_JOB_ID FROM #DEB1 WHERE DEB_STATUS <>'DEL')  
  
  SELECT DISTINCT @DEB1 'ID_CUSTOMER',@DEBTYPE1 'CUST_TYPE',ID_JOB_ID ,DEB_STATUS
  FROM #DEB1
  WHERE ID_JOB_ID IN (SELECT ID_JOB_ID FROM #MAINCUST ) AND   DEB_STATUS ='DEL'
  
      
      
  SELECT DISTINCT ID_JOB_DEB,ID_JOB_ID,CUST_TYPE ,DEB_STATUS INTO #DEB2 
  FROM TBL_WO_DEBITOR_DETAIL 
  WHERE CUST_TYPE IN ('MISC','CLA') AND ID_WO_PREFIX=@ID_WO_PREFIX AND ID_WO_NO=@ID_WO_NO      
  
  --SELECT * FROM #DEB2      
  
  SET @DEB2 = (SELECT TOP 1 ID_JOB_DEB FROM #DEB2)      
  SET @DEBTYPE2 = (SELECT TOP 1 CUST_TYPE FROM #DEB2)      
  
  --SELECT DISTINCT @DEB2 'ID_CUSTOMER',@DEBTYPE2 'CUST_TYPE',ID_JOB_ID 
  --FROM #MAINCUST 
  --WHERE ID_JOB_ID NOT IN (SELECT ID_JOB_ID FROM #DEB2 WHERE DEB_STATUS <>'DEL')    
  
  SELECT DISTINCT @DEB2 'ID_CUSTOMER',@DEBTYPE2 'CUST_TYPE',ID_JOB_ID,DEB_STATUS 
  FROM #DEB2 
  WHERE ID_JOB_ID  IN 
  (SELECT ID_JOB_ID 
  FROM #MAINCUST  )AND DEB_STATUS ='DEL'
  
      
  DROP TABLE #MAINCUST      
  DROP TABLE #DEB1      
  DROP TABLE #DEB2        
                    
END          
        
                   
/*                  
EXEC USP_WO_DEBTOR_JOB_CHECK 'V22','54827','22admin'                            
*/ 
GO

/****** Object:  StoredProcedure [dbo].[USP_WO_TOTAL_VIEW_NEW]    Script Date: 2/16/2017 5:53:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_TOTAL_VIEW_NEW]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_TOTAL_VIEW_NEW]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_TOTAL_VIEW_NEW]    Script Date: 2/16/2017 5:53:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_TOTAL_VIEW_NEW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_TOTAL_VIEW_NEW] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                    
* Module : Work Order                   
* File name : USP_WO_TOTAL_VIEW_NEW .prc                    
* Purpose :                   
* Author : M.Thiyagarajan                  
* Date  : 27.10.2006                  
*********************************************************************************************************************/                    
/*********************************************************************************************************************                      
I/P : -- Input Parameters                    
O/P : -- Output Parameters                    
Error Code                    
Description                    
INT.VerNO : NOV21.0                      
********************************************************************************************************************/                    
--'*********************************************************************************'*********************************                    
--'* Modified History :                       
--'* S.No  RFC No/Bug ID   Date        Author  Description                     
--#0004#    19/11/2008 S.Sudhakar Reddy  Added DEPT.FLG_DPT_Warehouse = 0 to display based on dept.                            
--'*********************************************************************************'*********************************                    
                  
ALTER PROCEDURE [dbo].[USP_WO_TOTAL_VIEW_NEW]                            
(                                     
 @ID_WO_NO  VARCHAR(10),                      
 @ID_WO_PREFIX VARCHAR(3),                      
 @ID_JOB   INT                         
)                            
AS                            
BEGIN                            
 DECLARE @ID_WODET_SEQ AS INT                       
                         
 SELECT @ID_WODET_SEQ = ID_WODET_SEQ                       
 FROM    TBL_WO_DETAIL WD            
 INNER JOIN TBL_WO_HEADER WH ON WH.ID_WO_NO  = WD.ID_WO_NO AND WH.ID_WO_PREFIX = WH.ID_WO_PREFIX            
 INNER JOIN TBL_MAS_DEPT DEPT ON DEPT.ID_DEPT = WH.ID_DEPT  AND DEPT.FLG_DPT_Warehouse = 0             
 WHERE   WD.ID_WO_NO =@ID_WO_NO                   
 AND     WD.ID_WO_PREFIX = @ID_WO_PREFIX                   
 AND     WD.ID_JOB   = @ID_JOB                            
                             
 EXEC USP_WO_VIEW @ID_WODET_SEQ                            
                  
 EXEC USP_WO_JOBDETAIL_VIEW_SAFE @ID_WODET_SEQ, @ID_JOB                  
                  
 EXEC USP_WO_DEBITOR_DETAIL_VIEW @ID_WO_PREFIX, @ID_WO_NO,@ID_JOB                          
                  
 EXEC USP_WO_DEBITOR_DISCOUNT_VIEW @ID_WO_PREFIX, @ID_WO_NO,@ID_JOB                   
                       
 SELECT ID_MEC_PLAN as ID_Login,                  
   CASE WHEN ID_MEC_PLAN IS NOT NULL  THEN                  
    (SELECT FIRST_NAME FROM TBL_MAS_USERS  WHERE ID_LOGIN = PLAN_JOB.ID_MEC_PLAN)                  
   END AS MECHANICNAME,ROW_NUMBER() OVER(ORDER BY ID_PLAN_SEQ) AS ID_SEQ,                  
   CASE WHEN UPPER(SRC_INITIATION) = 'W' THEN                  
    'TRUE'                  
   ELSE 'FALSE'                  
   END AS SRC_INITIATION                  
 FROM TBL_PLAN_JOB_DETAIL PLAN_JOB                   
 WHERE ID_WO_PREFIX  = @ID_WO_PREFIX                  
 AND  ID_WO_NO_JOB = @ID_WO_NO                  
 AND  ID_JOB   = @ID_JOB                   
END                            
                            
                
--Bug ID:-Update Mech                
--Date  :-01-Oct-2008                
SELECT ID_PLAN_SEQ                
FROM TBL_PLAN_JOB_DETAIL JOBDET,TBL_WO_DETAIL DET                
WHERE                 
JOBDET.ID_WO_PREFIX=@ID_WO_PREFIX AND DET.ID_WO_PREFIX=JOBDET.ID_WO_PREFIX AND                
JOBDET.ID_WO_NO_JOB=@ID_WO_NO AND DET.ID_WO_NO=JOBDET.ID_WO_NO_JOB AND                
JOBDET.ID_JOB=@ID_JOB AND DET.ID_JOB=JOBDET.ID_JOB AND                
PLAN_TIME_FROM='0.0' AND DET.JOB_STATUS <> 'INV' AND                
PLAN_TIME_TO='0.0'                
                
            
EXEC USP_WO_VIEW_LABOUR_DETAILS @ID_WODET_SEQ     
    
    
SELECT                                
    ID_DBT_SEQ,                               
    ROW_NUMBER() OVER(ORDER BY ID_DBT_SEQ ) AS SLNO,                               
    ID_WO_PREFIX,                                
    ID_WO_NO,                                
    ID_JOB_ID,                                
    ISNULL(ID_JOB_DEB,'') AS 'ID_JOB_DEB',                                
    CASE WHEN ID_JOB_DEB IS NOT NULL THEN                                
  CASE WHEN DEBITOR_TYPE ='C' AND DBT_PER > 0 THEN                      
  --Change by manoj k Bug ID:- 2458                          
   (                          
-- SELECT                                   
--  ISNULL(WO_CUST_NAME,'INVALID CUSTOMER')                                  
-- FROM                                   
--  TBL_WO_HEADER                                   
-- WHERE                                   
--  ID_CUST_WO = ID_JOB_DEB and                           
--  ID_WO_PREFIX = @ID_WO_PREFIX and                          
--  ID_WO_NO  = @ID_WO_NO                          
                    
 SELECT                                   
         ISNULL(CUST_NAME,'INVALID CUSTOMER')                                  
 FROM                                   
  TBL_MAS_CUSTOMER                                   
 WHERE                                   
  ID_CUSTOMER = ID_JOB_DEB                      
   )                      
  ELSE                            
   (SELECT                                   
         ISNULL(CUST_NAME,'INVALID CUSTOMER')                                  
   FROM                                   
    TBL_MAS_CUSTOMER                                   
  WHERE                                   
    ID_CUSTOMER = ID_JOB_DEB )                                   
  END                             
--Change End                        
    ELSE 'INVALID DEBITOR'                                
    END AS 'JOB_DEB_NAME',                                
    ISNULL(DEBITOR_TYPE,'') AS 'DEBITOR_TYPE',                                
    ISNULL(DBT_PER,0) AS 'DBT_PER',                                
    ISNULL(DBT_AMT,0) AS 'DBT_AMT'                                
,ISNULL(CUST_TYPE,'OHC')AS CUST_TYPE                  
,ISNULL(WO_OWN_RISK_DESC,'')AS WO_OWN_RISK_DESC              
,ISNULL(REDUCTION_PER,0)AS REDUCTION_PER               
,ISNULL(REDUCTION_BEFORE_OR,0)AS REDUCTION_BEFORE_OR                
,ISNULL(REDUCTION_AFTER_OR,0)AS REDUCTION_AFTER_OR                
,ISNULL(REDUCTION_AMOUNT,0)AS REDUCTION_AMOUNT      
  
,(SELECT                                   
         ISNULL(CUST_DISC_GENERAL,0)                                  
 FROM                                   
  TBL_MAS_CUSTOMER                                   
 WHERE                                   
  ID_CUSTOMER = ID_JOB_DEB ) AS 'CUST_DISC_GENERAL'      
 ,(SELECT                                   
         ISNULL(CUST_DISC_LABOUR,0)                                  
 FROM                                   
  TBL_MAS_CUSTOMER                                   
 WHERE                                   
  ID_CUSTOMER = ID_JOB_DEB ) AS 'CUST_DISC_LABOUR'     
   ,(SELECT                                   
         ISNULL(CUST_DISC_SPARES,0)                                  
 FROM                                   
  TBL_MAS_CUSTOMER                                   
 WHERE                                   
  ID_CUSTOMER = ID_JOB_DEB ) AS 'CUST_DISC_SPARES'     
 --END OF MODIFICATION                    
   FROM                                 
    TBL_WO_DEBITOR_DETAIL                                  
   WHERE                                 
    ID_WO_PREFIX = @ID_WO_PREFIX AND                                
    ID_WO_NO  = @ID_WO_NO AND                                
    ID_JOB_ID  = @ID_JOB           
    ORDER BY SLNO asc    
         
        
--SELECT FIRST_NAME FROM TBL_MAS_USERS  WHERE ID_LOGIN = (SELECT ID_LOGIN FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @ID_WODET_SEQ)        
          
            
--change end                
                            
/*                            
  EXEC USP_WO_TOTAL_VIEW 132                            
  EXEC USP_WO_TOTAL_VIEW_NEW '2828','SRS',1                      
  EXEC USP_WO_JOBDETAIL_VIEW_SAFE 95, 3                  
                  
*/ 

GO

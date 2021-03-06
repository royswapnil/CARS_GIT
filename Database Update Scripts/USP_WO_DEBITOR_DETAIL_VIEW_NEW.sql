/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW]    Script Date: 3/17/2017 7:12:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW]    Script Date: 3/17/2017 7:12:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                                          
* Module : Work Order                                           
* File name : USP_WO_DEBITOR_DETAIL_VIEW_NEW.PRC                                          
* Purpose : To VIEW WORK ORDER DETAILS                                     
* Author : THIYAGARAJAN /SUBRAMANIAN                                          
* Date  : 29.09.2006                                          
*********************************************************************************************************************/                                          
/*********************************************************************************************************************                                            
I/P : -- Input Parameters                                          
 @iv_xmlDoc - Valid XML document contaning values to be inserted                                          
                                          
O/P : -- Output Parameters                                          
 @ov_RetValue - 'INSFLG' if error, 'OK' otherwise                                          
 @ov_CannotDelete - List of configuration items which cannot be inserted as they already exists.                                          
                                          
Error Code                                          
Description     INT.VerNO : NOV21.0                                       
********************************************************************************************************************/                                          
--'*********************************************************************************'*********************************                                          
--'* Modified History :                                             
--'* S.No  RFC No/Bug ID   Date        Author  Description                                           
--* #0001#                                          
--'*********************************************************************************'*********************************                                          
ALTER PROCEDURE [dbo].[USP_WO_DEBITOR_DETAIL_VIEW_NEW]                                    
 (                                  
    @ID_WO_PREFIX VARCHAR(3),                                  
    @ID_WO_NO VARCHAR(10),                                  
    @ID_JOB INT                                  
 )                                  
AS                                     
BEGIN                         
                                
   SELECT                                  
    ID_DBT_SEQ,                                 
    ROW_NUMBER() OVER(ORDER BY ID_DBT_SEQ ) AS SLNO,                                 
    WODB.ID_WO_PREFIX,                                  
    WODB.ID_WO_NO,                                  
    WODB.ID_JOB_ID,                                  
    ISNULL(WODB.ID_JOB_DEB,'') AS 'ID_JOB_DEB',                                  
    CASE WHEN WODB.ID_JOB_DEB IS NOT NULL THEN                                  
  CASE WHEN DEBITOR_TYPE ='C' AND DBT_PER > 0 THEN                        
   (                            
	 SELECT                                     
			 ISNULL(CUST_NAME,'INVALID CUSTOMER')                                    
	 FROM                                     
	  TBL_MAS_CUSTOMER                                     
	 WHERE                                     
	  ID_CUSTOMER = WODB.ID_JOB_DEB                        
   )                        
  ELSE                              
   (
	   SELECT                                     
			 ISNULL(CUST_NAME,'INVALID CUSTOMER')                                    
	   FROM                                     
		TBL_MAS_CUSTOMER                                     
	  WHERE                                     
		ID_CUSTOMER = WODB.ID_JOB_DEB 
   )                                     
  END                               
    ELSE 'INVALID DEBITOR'                                  
    END AS 'JOB_DEB_NAME',                                  
    ISNULL(DEBITOR_TYPE,'') AS 'DEBITOR_TYPE',                                  
    ISNULL(ID_DETAIL,'') AS 'DETAIL',                                  
    ISNULL(DBT_PER,0) AS 'DBT_PER',                                  
    ISNULL(DBT_AMT,0) AS 'DBT_AMT',                                  
    ISNULL(WODB.CREATED_BY,'NO NAME') AS 'CREATED BY',                          
    CONVERT(CHAR(10),WODB.DT_CREATED,103) AS 'CREATED DATE',                                  
    ISNULL(WODB.MODIFIED_BY,'NOT MODIFIED') AS 'MODIFIED BY',                         
    CONVERT(CHAR(10),WODB.DT_MODIFIED,103) AS 'MODIFIED DATE',                                  
    ISNULL(DBT_DIS_PER,0) AS 'DISCOUNT PERCENTAGE',                      
    ISNULL(WODB.WO_VAT_PERCENTAGE,0) AS 'WO_VAT_PERCENTAGE',                      
    ISNULL(WODB.WO_GM_PER,0) AS 'WO_GM_PER',                      
    ISNULL(WODB.WO_GM_VATPER,0) AS 'WO_GM_VATPER',                      
    ISNULL(WODB.WO_LBR_VATPER,0) AS 'WO_LBR_VATPER',                      
    ISNULL(WODB.WO_SPR_DISCPER,0) AS 'WO_SPR_DISCPER',
  (
	 SELECT                                  
	  COUNT(*)                      
	 FROM                                   
	  TBL_WO_JOB_DETAIL                                    
	 WHERE                                   
	  ID_DBT_SEQ = WODB.ID_DBT_SEQ
   ) AS 'SPARECOUNT'                      
 ,ISNULL(ORG_PER,0) AS 'ORGPERCENT'                      
 ,ISNULL(WO_FIXED_VATPER,0) AS 'WO_FIXED_VATPER'                      
 ,ISNULL(JOB_VAT_AMOUNT,0) AS 'JOB VAT'                      
 ,ISNULL(LABOUR_AMOUNT,0) AS 'LABOUR AMOUNT'                      
 ,ISNULL(LABOUR_DISCOUNT,0)AS 'LABOUR DISCOUNT'                      
 ,ISNULL(GM_AMOUNT,0)AS 'GM AMOUNT'                      
 ,ISNULL(GM_DISCOUNT,0)AS 'GM DISCOUNT'                      
 ,ISNULL(OWN_RISK_AMOUNT,0)AS 'OWN RISK AMOUNT'                      
 ,ISNULL(SP_VAT,0)AS 'SP_VAT'                      
 ,ISNULL(SP_AMT_DEB,0)AS 'SP_AMT_DEB'                     
 ,ISNULL(CUST_TYPE,'OHC')AS CUST_TYPE                    
 ,ISNULL(WODB.WO_OWN_RISK_DESC,'')AS WO_OWN_RISK_DESC                
 ,ISNULL(REDUCTION_PER,0)AS REDUCTION_PER                 
 ,ISNULL(REDUCTION_BEFORE_OR,0)AS REDUCTION_BEFORE_OR                  
 ,ISNULL(REDUCTION_AFTER_OR,0)AS REDUCTION_AFTER_OR                  
 ,ISNULL(REDUCTION_AMOUNT,0)AS REDUCTION_AMOUNT        
 ,ISNULL(WODB.CUST_DISC_GENERAL,0)AS CUST_GENERAL_DISC        
 ,ISNULL(WODB.CUST_DISC_LABOUR,0)AS CUST_LABOUR_DISC        
 ,ISNULL(WODB.CUST_DISC_SPARES,0)AS CUST_SPARE_DISC       
 ,ISNULL(DEB_STATUS ,'') AS   DEB_STATUS
 ,WOD.ID_WODET_SEQ
 ,CS.FLG_CUST_BATCHINV                            
   FROM                                   
    TBL_WO_DEBITOR_DETAIL WODB
	INNER JOIN TBL_WO_DETAIL WOD ON WOD.ID_WO_PREFIX = WODB.ID_WO_PREFIX AND WOD.ID_WO_NO = WODB.ID_WO_NO AND WOD.ID_JOB = WODB.ID_JOB_ID 
	INNER JOIN TBL_MAS_CUSTOMER CS ON CS.ID_CUSTOMER = WODB.ID_JOB_DEB
   WHERE                                   
    WODB.ID_WO_PREFIX = @ID_WO_PREFIX AND                                  
    WODB.ID_WO_NO  = @ID_WO_NO AND                                  
    WODB.ID_JOB_ID  = @ID_JOB    
    ORDER BY SLNO asc                                 
END                                    
                                   
                                  
/*                                  
 SELECT * FROM TBL_WO_DEBITOR_DETAIL                                  
 SELECT ISNULL(CUST_NAME,'INVALID CUSTOMER'),* FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = '1040'                                  
 EXEC USP_WO_DEBITOR_DETAIL_VIEW 'WO','0110','1'                                 
*/ 
GO

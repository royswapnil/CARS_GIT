/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITOR_DETAIL_VIEW]    Script Date: 4/13/2017 4:56:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITOR_DETAIL_VIEW]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DEBITOR_DETAIL_VIEW]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITOR_DETAIL_VIEW]    Script Date: 4/13/2017 4:56:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITOR_DETAIL_VIEW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DEBITOR_DETAIL_VIEW] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                                            
* Module : Work Order                                             
* File name : USE_WO_DEBITOR_DETAILS_VIEW.PRC                                            
* Purpose : To VIEW WORK ORDER  TDETAILS                                       
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
ALTER PROCEDURE [dbo].[USP_WO_DEBITOR_DETAIL_VIEW]                                      
 (                                    
    @ID_WO_PREFIX VARCHAR(3),                                    
    @ID_WO_NO VARCHAR(10),                                    
    @ID_JOB_ID INT                                    
 )                                    
AS                                       
BEGIN                           
                                  
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
    ISNULL(ID_DETAIL,'') AS 'DETAIL',                                    
    ISNULL(DBT_PER,0) AS 'DBT_PER',                                    
    ISNULL(DBT_AMT,0) AS 'DBT_AMT',                                    
    ISNULL(CREATED_BY,'NO NAME') AS 'CREATED BY',                            
    CONVERT(CHAR(10),DT_CREATED,103) AS 'CREATED DATE',                                    
    ISNULL(MODIFIED_BY,'NOT MODIFIED') AS 'MODIFIED BY',                           
    CONVERT(CHAR(10),DT_MODIFIED,103) AS 'MODIFIED DATE',                                    
    ISNULL(DBT_DIS_PER,0) AS 'DISCOUNT PERCENTAGE',                        
                            
    --Bug ID :- Owner Per Vat                        
 --Date   :- 15-Aug-2008                        
 --Desc  :- while updating                        
 ISNULL(WO_VAT_PERCENTAGE,0) AS 'WO_VAT_PERCENTAGE',                        
    ISNULL(WO_GM_PER,0) AS 'WO_GM_PER',                        
 ISNULL(WO_GM_VATPER,0) AS 'WO_GM_VATPER',                        
 ISNULL(WO_LBR_VATPER,0) AS 'WO_LBR_VATPER',                        
 ISNULL(WO_SPR_DISCPER,0) AS 'WO_SPR_DISCPER'                          
 --MODIFIED DATE: 10 OCT 2008                        
 --COMMENTS: WORK ORDER - DEBITOR ONLINE CHANGE                        
 ,(SELECT                                    
  COUNT(*)                        
 FROM                                     
  TBL_WO_JOB_DETAIL                                      
 WHERE                                     
  ID_DBT_SEQ = TBL_WO_DEBITOR_DETAIL.ID_DBT_SEQ) AS 'SPARECOUNT'                        
 --MODIFIED DATE: 17 NOV 2008                        
 --COMMENTS: WORK ORDER - ORIGINAL SPLIT PERCENTAGE                        
 ,ISNULL(ORG_PER,0) AS 'ORGPERCENT'                        
 --,ISNULL(DBT_PER,0) AS 'ORGPERCENT'                        
 --END OF MODIFICATION                         
 --END OF MODIFICATION                        
 --MODIFIED DATE: 23 OCT 2008                        
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                        
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
,ISNULL(WO_OWN_RISK_DESC,'')AS WO_OWN_RISK_DESC                  
,ISNULL(REDUCTION_PER,0)AS REDUCTION_PER                   
,ISNULL(REDUCTION_BEFORE_OR,0)AS REDUCTION_BEFORE_OR                    
,ISNULL(REDUCTION_AFTER_OR,0)AS REDUCTION_AFTER_OR                    
,ISNULL(REDUCTION_AMOUNT,0)AS REDUCTION_AMOUNT          
,ISNULL(CUST_DISC_GENERAL,0)AS CUST_GENERAL_DISC          
,ISNULL(CUST_DISC_LABOUR,0)AS CUST_LABOUR_DISC          
,ISNULL(CUST_DISC_SPARES,0)AS CUST_SPARE_DISC         
,ISNULL(DEB_STATUS ,'') AS   DEB_STATUS
,ISNULL (DEBTOR_VAT_PERCENTAGE ,0) AS  DEBTOR_VAT_PERCENTAGE                             
         
 --END OF MODIFICATION                        
   FROM                                     
    TBL_WO_DEBITOR_DETAIL                                    
   WHERE                                     
    ID_WO_PREFIX = @ID_WO_PREFIX AND                                    
    ID_WO_NO  = @ID_WO_NO AND                                    
    ID_JOB_ID  = @ID_JOB_ID      
    --AND ISNULL(DEB_STATUS,'') <> 'DEL'             
    ORDER BY SLNO asc                                   
END                                      
                                     
                                    
/*                                    
 SELECT * FROM TBL_WO_DEBITOR_DETAIL                                    
 SELECT ISNULL(CUST_NAME,'INVALID CUSTOMER'),* FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = '1040'                                    
 EXEC USP_WO_DEBITOR_DETAIL_VIEW 'WO','0110','1'                                   
*/ 
GO

/****** Object:  StoredProcedure [dbo].[USP_ORDER_SEARCH]    Script Date: 9/28/2017 3:57:38 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_ORDER_SEARCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_ORDER_SEARCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_ORDER_SEARCH]    Script Date: 9/28/2017 3:57:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_ORDER_SEARCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_ORDER_SEARCH] AS' 
END
GO
             
                 
/*************************************** APPLICATION: MSG *************************************************************                  
* MODULE : MASTER                  
* FILE NAME : USP_MAS_VEHICLE_SEARCH.PRC                  
* PURPOSE : TO SEARCH VEHICLE INFORMATION.                   
* AUTHOR : MARTIN OMNES                  
* DATE  : 29.04.2016                  
*********************************************************************************************************************/                  
/*********************************************************************************************************************                    
I/P : -@ID_SEARCH- INPUT PARAMETERS                  
O/P : -- OUTPUT PARAMETERS                  
ERROR CODE                  
DESCRIPTION                  
INT.VerNO : NOV21.0                  
********************************************************************************************************************/                  
--'*********************************************************************************'*********************************                  
--'* MODIFIED HISTORY :                     
--'* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION                   
--*#0001#                  
--'*********************************************************************************'*********************************                  
ALTER PROCEDURE [dbo].[USP_ORDER_SEARCH]                  
(                      
 @ID_SEARCH   VARCHAR(10)                        
)                  
AS                  
BEGIN                  
              
IF LEN(@ID_SEARCH)>=3              
BEGIN              
 SELECT DISTINCT                    
  WH.ID_WO_PREFIX+WH.ID_WO_NO AS ID_WO_NO,              
  WH.ID_WO_PREFIX AS WO_PREFIX,              
  WH.ID_WO_NO AS WO_NO,              
  DT_ORDER,                  
  ID_CUST_WO,                  
  WO_CUST_NAME,                
  WO_CUST_PERM_ADD1,                
  ID_ZIPCODE_WO,                
  WO_CUST_PHONE_MOBILE,                
  WO_VEH_INTERN_NO,                
  WO_VEH_REG_NO,              
  INV.ID_INV_NO,              
  IH.DT_INVOICE,          
  WH.WO_STATUS,          
  WH.WO_TYPE_WOH,          
  PT.TERMS,      
  CASE WHEN (WH.WO_STATUS ='INV')  THEN       
  'F'      
   WHEN (WH.WO_TYPE_WOH='BAR' AND WH.WO_STATUS <> 'INV') THEN      
  'T'      
   WHEN (WH.WO_TYPE_WOH='KRE' AND WH.WO_STATUS <> 'INV') THEN      
  'K'       
   WHEN (WH.WO_TYPE_WOH='ORD') AND (WH.WO_STATUS = 'JCD' or WH.WO_STATUS = 'RWRK' or WH.WO_STATUS = 'CSA' or WH.WO_STATUS = 'RINV' or WH.WO_STATUS = 'PINV' )  THEN      
  'O'       
  END AS ORDERSTATUS        
   FROM                 
    TBL_WO_HEADER WH           
    left outer JOIN TBL_INV_DETAIL INV ON INV.ID_WO_PREFIX+INV.ID_WO_NO = WH.ID_WO_PREFIX+WH.ID_WO_NO              
    left outer JOIN TBL_INV_HEADER IH ON IH.ID_INV_NO = INV.ID_INV_NO                   
 INNER JOIN TBL_MAS_CUST_PAYTERMS PT ON PT.ID_PT_SEQ = WH.ID_PAY_TERMS_WO          
 WHERE                  
  (WH.ID_WO_NO LIKE '%'+@ID_SEARCH+'%' OR WH.ID_WO_PREFIX+WH.ID_WO_NO LIKE '%'+@ID_SEARCH+'%' OR ID_CUST_WO LIKE '%'+@ID_SEARCH+'%' OR               
  WO_CUST_NAME LIKE '%'+@ID_SEARCH+'%' OR WO_CUST_PERM_ADD1 LIKE '%'+@ID_SEARCH+'%'               
  OR ID_ZIPCODE_WO LIKE '%'+@ID_SEARCH+'%' OR WO_VEH_INTERN_NO LIKE '%'+@ID_SEARCH+'%'               
  OR WO_VEH_REG_NO LIKE '%'+@ID_SEARCH+'%' )         
  AND WH.WO_STATUS <> 'DEL'             
              
              
END                 
END                  
                  
                  
                  
--ID_CONFIG,DESCRIPTION                  
--EXEC USP_MAS_VEHICLE_SEARCH 'CS001',NULL                  
                  
--SELECT * FROM TBL_MAS_VEHICLE                  
--SELECT * FROM TBL_MAS_CUSTOMER                  
--SELECT * FROM TBL_MAS_SETTINGS                  
                  
--,ID_MAKE_VEH,ID_MODEL_VEH                  
--SELECT * FROM TBL_MAS_CUST_GROUP                  
                  
                   
                  
--SELECT * FROM TBL_MAS_CUSTOMER                  
--SELECT * FROM TBL_MAS_VEHICLE 
GO

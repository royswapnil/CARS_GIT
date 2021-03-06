/****** Object:  StoredProcedure [dbo].[usp_WO_HEADER_FETCH]    Script Date: 10/5/2017 3:40:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_HEADER_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WO_HEADER_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[usp_WO_HEADER_FETCH]    Script Date: 10/5/2017 3:40:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_HEADER_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_WO_HEADER_FETCH] AS' 
END
GO
  
/*************************************** Application: MSG *************************************************************          
* Module : Work Order         
* File name : usp_WO_HEADER_FETCH .prc          
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
--*#0001#           
--'*********************************************************************************'*********************************          
       -- ******************************************      
  -- Modified Date : 09th October 2008      
  -- Bug No   : 3734       
--Modified Date: 19 Sep 2008      
  --Comments: BUSPEK Changes    
 --End of Modification       
  --Modified Date : 06 Oct 2008      
  --SS3 Order type   
  
 --bUG id :- System text for Data, Date 12-May-2009, Original on 11-May-2009, Commented portion moved to Top  
  
ALTER PROCEDURE [dbo].[usp_WO_HEADER_FETCH]              
(                  
 @IV_ID_WO_NO  VARCHAR(10)   ,                
 @IV_ID_PR_NO  VARCHAR(3)    ,            
 @iv_UserID   VARCHAR(20)    ,  
 @IV_LANG     VARCHAR(30)  ='ENGLISH'           
)                  
AS        
BEGIN     
  
 BEGIN TRY    
                     
 DECLARE @IV_CUSTID VARCHAR(10)                    
 DECLARE @IV_VECH VARCHAR(10)                    
 DECLARE @DT_ORDER1 VARCHAR(10)  
 DECLARE @INTERNAL_NOTE VARCHAR(10)   
 SELECT @INTERNAL_NOTE = ISNULL(DESCRIPTION,'FALSE') FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='INT-NOTE'   
                  
 SELECT                     
  ID_WO_NO   ,                    
  ID_WO_PREFIX  ,                      
  WO_TYPE_WOH  ,                    
  WO_STATUS  ,                     
  WO_TM_DELIV  ,             
  CASE WHEN DT_FINISH IS NOT NULL THEN                     
    CONVERT(CHAR(10),DT_FINISH,101)                  
  END AS DT_FINISH  ,                       
  ID_PAY_TYPE_WO  ,                    
  ID_PAY_TERMS_WO  ,                    
  WO_ANNOT       ,                    
  IV_CUSTID = ID_CUST_WO ,                    
  ID_CUST_WO     ,                    
  WO_CUST_NAME    ,                    
  WO_CUST_PERM_ADD1   ,                    
  WO_CUST_PERM_ADD2   ,                    
  ID_ZIPCODE_WO    ,                     
  WO_CUST_PHONE_OFF   ,                    
  WO_CUST_PHONE_HOME  ,                    
  WO_CUST_PHONE_MOBILE     ,                    
  ID_VEH_SEQ_WO    ,                    
  WO_VEH_REG_NO    ,                    
  WO_VEH_INTERN_NO   ,                    
  WO_VEH_VIN    ,                    
  WO_VEH_MILEAGE   ,                    
  CONVERT(INT,ISNULL(WO_VEH_HRS,0)) AS WO_VEH_HRS,                   
  WO_VEH_MAK_MOD_MAP  ,                 
  CASE WHEN DT_ORDER IS NOT NULL THEN                  
    CONVERT(CHAR(10),DT_ORDER,101)                 
  END AS DT_ORDER   ,                   
  CASE WHEN DT_DELIVERY IS NOT NULL THEN              
    CONVERT(CHAR(10),DT_DELIVERY,101)                         
  END AS DT_DELIVERY  ,                   
  CASE WHEN WO_TYPE_WOH IS NOT NULL AND WO_TYPE_WOH ='ORD'  THEN   
    'ORDER'                   
   WHEN WO_TYPE_WOH IS NOT NULL AND WO_TYPE_WOH = 'BAR' THEN   
    'BARGAIN'                  
  ELSE          
  WO_TYPE_WOH                    
  END AS WOH_TYPE,    
      WO_STATUS                  
   AS WOH_STATUS,  --Not Using                            
  CASE WHEN ID_ZIPCODE_WO IS NOT NULL THEN                    
  (SELECT ISNULL(ZIP_ZIPCODE,'') FROM TBL_MAS_ZIPCODE         
     WHERE  ZIP_ZIPCODE = WOHEADER.ID_ZIPCODE_WO)                    
   ELSE ''           
  END AS PZIPCODE   ,                    
  CASE WHEN ID_ZIPCODE_WO IS NOT NULL THEN                    
  (SELECT ISNULL(DESCRIPTION,'') FROM TBL_MAS_CONFIG_DETAILS A, TBL_MAS_ZIPCODE B                 
   WHERE  A.ID_PARAM = B.ZIP_ID_STATE AND B.ZIP_ZIPCODE = WOHEADER.ID_ZIPCODE_WO)                    
   ELSE  ''                    
  END AS PSTATE    ,                    
  CASE WHEN ID_ZIPCODE_WO IS NOT NULL THEN             
   (SELECT ISNULL(DESCRIPTION,'') FROM TBL_MAS_CONFIG_DETAILS A, TBL_MAS_ZIPCODE B                 
   WHERE A.ID_PARAM = B.ZIP_ID_COUNTRY AND B.ZIP_ZIPCODE = WOHEADER.ID_ZIPCODE_WO )                    
   ELSE  ''                    
  END AS PCOUNTRY,       
  CASE WHEN ID_ZIPCODE_WO IS NOT NULL THEN             
   (SELECT ISNULL(ZIP_CITY,'') FROM TBL_MAS_ZIPCODE B                 
   WHERE B.ZIP_ZIPCODE = WOHEADER.ID_ZIPCODE_WO )                    
   ELSE  ''                    
  END AS PCITY,        
  CASE WHEN ID_PAY_TERMS_WO IS NOT NULL THEN                       
   (SELECT CAST(TERMS AS VARCHAR) + ' - ' + ISNULL(DESCRIPTION,'')    DESCRIPTION                    
   FROM  TBL_MAS_CUST_PAYTERMS A WHERE A.ID_PT_SEQ = WOHEADER.ID_PAY_TERMS_WO)                    
   ELSE ''                    
  END AS PAYTERM,                    
  CASE WHEN ID_PAY_TYPE_WO IS NOT NULL THEN                    
   (SELECT ISNULL(DESCRIPTION,'') FROM TBL_MAS_SETTINGS A                    
   WHERE   A.ID_SETTINGS = WOHEADER.ID_PAY_TYPE_WO)                    
   ELSE  ''                    
  END AS PAYTYPE,                   
  CASE WHEN WO_VEH_MAK_MOD_MAP IS NOT NULL THEN                    
   (SELECT ISNULL(MG_ID_MODEL_GRP,'') FROM TBL_MAS_MODELGROUP_MAKE_MAP A                    
   WHERE A.ID_MG_SEQ = WOHEADER.WO_VEH_MAK_MOD_MAP)                    
   ELSE ''                    
  END AS MAKE_MAP ,              
  WOHEADER.CREATED_BY    ,          
  WOHEADER.DT_CREATED ,        
  WOHEADER.MODIFIED_BY    ,          
  WOHEADER.DT_MODIFIED,            
  WO_CUST_GROUPID  ,   
  BUS_PEK_CONTROL_NUM,   
  DELIVERY_CODE,      
  DELIVERY_METHOD,      
  DELIVERY_ADDRESS_NAME,      
  DELIVERY_ADDRESS_LINE1,      
  DELIVERY_ADDRESS_LINE2,    
  DELIVERY_ADDRESS_ZIPCODE,    
  CASE WHEN DELIVERY_ADDRESS_ZIPCODE IS NOT NULL THEN                      
   (SELECT ISNULL(ZIP_ZIPCODE,'') FROM TBL_MAS_ZIPCODE           
   WHERE  ZIP_ZIPCODE = WOHEADER.DELIVERY_ADDRESS_ZIPCODE)                      
   ELSE ''      
  END AS PDELIVERY_ADDRESS_ZIPCODE,   
  CASE WHEN DELIVERY_ADDRESS_ZIPCODE IS NOT NULL THEN                      
   --(SELECT ISNULL(DESCRIPTION,'') FROM TBL_MAS_CONFIG_DETAILS A, TBL_MAS_ZIPCODE B                   
   --WHERE  A.ID_PARAM = B.ZIP_ID_STATE AND B.ZIP_ZIPCODE = WOHEADER.DELIVERY_ADDRESS_ZIPCODE)   
   (SELECT ISNULL(ZIP_CITY,'') FROM TBL_MAS_ZIPCODE B                 
   WHERE B.ZIP_ZIPCODE = WOHEADER.DELIVERY_ADDRESS_ZIPCODE )                       
   ELSE  ''                      
  END AS DELIVERY_ADDRESS,     
  CASE WHEN DELIVERY_ADDRESS_ZIPCODE IS NOT NULL THEN               
   (SELECT ISNULL(DESCRIPTION,'') FROM TBL_MAS_CONFIG_DETAILS A, TBL_MAS_ZIPCODE B                   
   WHERE A.ID_PARAM = B.ZIP_ID_COUNTRY AND B.ZIP_ZIPCODE = WOHEADER.DELIVERY_ADDRESS_ZIPCODE )                      
   ELSE  ''                      
  END AS DELIVERY_COUNTRY,DT_MILEAGE_UPDATE , DT_HOURS_UPDATE,  
  LA_DEPT_ACCOUNT_NO,  
  DBS_FLNAME,  
  VA_COST_PRICE,  
  VA_SELL_PRICE,VA_NUMBER,  
  INT_NOTE,  
  @INTERNAL_NOTE AS FLG_DISP_INT_NOTE -- FLAG on General Settings page 
  ,WO_REF_NO 
  --,MG_ID_MAKE,  
  --MG_ID_MODEL_GRP   
  FROM TBL_WO_HEADER WOHEADER  
  --LEFT OUTER JOIN TBL_MAS_MODELGROUP_MAKE_MAP MAP  
  --ON MAP.ID_MG_SEQ  = WOHEADER.WO_VEH_MAK_MOD_MAP  
  WHERE ID_WO_NO = @IV_ID_WO_NO AND   
     ID_WO_PREFIX = @IV_ID_PR_NO    
  
  SELECT @IV_CUSTID = ID_CUST_WO       
  FROM TBL_WO_HEADER WOHEADER                    
  WHERE ID_WO_NO = @IV_ID_WO_NO AND  
     ID_WO_PREFIX = @IV_ID_PR_NO     
          
  EXEC USP_MAS_CUSTOMER_FETCH @IV_CUSTID                    
             
  --SELECT THE VEHICLE DETAILS---                    
  SELECT @IV_VECH= ID_VEH_SEQ_WO FROM TBL_WO_HEADER                     
  WHERE ID_WO_NO = @IV_ID_WO_NO  AND   
     ID_WO_PREFIX = @IV_ID_PR_NO                   
             
  EXEC USP_WO_SEL_VEHDET @IV_VECH                   
  
  --FETCHING THE JOB DETAILS---                     
  EXEC USP_WO_HEADER_JOBS @IV_ID_WO_NO,@IV_ID_PR_NO,@iv_UserID,@IV_LANG                 
             
  
  --FETCHING THE MECHANIC DETAILS                
  EXEC USP_WO_CLOCKTIME_ORDER_FETCH   @IV_ID_WO_NO,@IV_ID_PR_NO,@IV_LANG      
  
 END TRY  
 BEGIN CATCH  
  -- Execute error retrieval routine.  
  EXECUTE usp_GetErrorInfo;  
 END CATCH;          
END                    
GO

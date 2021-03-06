/****** Object:  StoredProcedure [dbo].[usp_WO_Sel_UsrDet]    Script Date: 2/16/2017 5:50:42 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_Sel_UsrDet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WO_Sel_UsrDet]
GO
/****** Object:  StoredProcedure [dbo].[usp_WO_Sel_UsrDet]    Script Date: 2/16/2017 5:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_Sel_UsrDet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_WO_Sel_UsrDet] AS' 
END
GO
/*************************************** Application: MSG *************************************************************        
* Module : Work Order       
* File name : usp_WO_Sel_UsrDet .prc        
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
----*#0001#       CR    20/06/07    M.Thiyagarajan As Per Client Request Form has modified Refer Approved SB         
--'*********************************************************************************'*********************************        
      
ALTER PROCEDURE [dbo].[usp_WO_Sel_UsrDet]        
(        
 @IVCUSTID  VARCHAR(10)       
)        
AS        
BEGIN            
   SELECT             
   ID_CUSTOMER    ,            
   CUST_NAME    ,            
   CUST_CONTACT_PERSON  ,            
   CUST_PHONE_OFF   ,            
   CUST_PHONE_HOME   ,            
   CUST_PHONE_MOBILE  ,            
   CUST_FAX    ,            
   CUST_ID_EMAIL   ,            
   CUST_PERM_ADD1   ,            
   CUST_PERM_ADD2   ,            
   CUST_BILL_ADD1   ,            
   CUST_BILL_ADD2   ,            
   CUST_ACCOUNT_NO   ,            
   ID_CUST_PAY_TYPE  ,            
   ID_CUST_PAY_TERM  ,         
   CUST_CREDIT_LIMIT,          
   ID_CUST_PERM_ZIPCODE,         
   CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(ZIP_ZIPCODE,'') FROM TBL_MAS_ZIPCODE             
  WHERE ZIP_ZIPCODE = Customer.ID_CUST_PERM_ZIPCODE)            
   Else ''            
   END AS PZIPCODE,            
   CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_CONFIG_DETAILS A,            
  TBL_MAS_ZIPCODE B WHERE A.ID_PARAM = B.ZIP_ID_STATE             
  AND B.ZIP_ZIPCODE = Customer.ID_CUST_PERM_ZIPCODE )            
   ELSE            
    ''            
   END AS PState,            
   CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_CONFIG_DETAILS A,            
  TBL_MAS_ZIPCODE B WHERE A.ID_PARAM = B.ZIP_ID_COUNTRY             
  AND B.ZIP_ZIPCODE = Customer.ID_CUST_PERM_ZIPCODE )            
   ELSE            
    ''            
   END AS PCountry,       
-- ******************************************      
 -- Modified Date : 09th October 2008      
 -- Bug No   : 3734         
   CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(ZIP_CITY,'') FROM  TBL_MAS_ZIPCODE B       
 WHERE B.ZIP_ZIPCODE = Customer.ID_CUST_PERM_ZIPCODE )            
   ELSE            
    ''            
   END AS PCITY,        
   ID_CUST_BILL_ZIPCODE,      
-- *********** End Of Modification ************                 
   CASE WHEN ID_CUST_BILL_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(ZIP_ZIPCODE,'') FROM TBL_MAS_ZIPCODE             
  WHERE ZIP_ZIPCODE = Customer.ID_CUST_BILL_ZIPCODE)            
   ELSE ''            
   END AS BZipCode,            
   CASE WHEN ID_CUST_BILL_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_CONFIG_DETAILS A,            
  TBL_MAS_ZIPCODE B WHERE A.ID_PARAM = B.ZIP_ID_STATE             
  AND B.ZIP_ZIPCODE = Customer.ID_CUST_BILL_ZIPCODE )            
   ELSE ''            
   END AS BState,            
   CASE WHEN ID_CUST_BILL_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_CONFIG_DETAILS A,            
  TBL_MAS_ZIPCODE B WHERE A.ID_PARAM = B.ZIP_ID_COUNTRY             
  AND B.ZIP_ZIPCODE = Customer.ID_CUST_BILL_ZIPCODE )            
   ELSE ''            
   END AS BCOUNTRY,      
    CASE WHEN ID_CUST_BILL_ZIPCODE IS NOT NULL THEN            
    (SELECT ISNULL(ZIP_CITY,'') FROM  TBL_MAS_ZIPCODE B       
 WHERE B.ZIP_ZIPCODE = Customer.ID_CUST_BILL_ZIPCODE )            
   ELSE            
    ''            
   END AS BCITY,            
   CASE WHEN ID_CUST_DISC_CD IS NOT NULL THEN               
 --START      
   --(SELECT  ISNULL(ID_SETTINGS + ' - ' + DESCRIPTION,'') DESCRIPTION                     
 (SELECT  ISNULL(DESCRIPTION,'') DESCRIPTION                     
    FROM  TBL_MAS_SETTINGS A                    
    WHERE A.ID_SETTINGS = Customer.ID_CUST_DISC_CD)                    
   ELSE                    
   ''                    
   END AS DISCOUNT,            
   CASE WHEN ID_CUST_GROUP IS NOT NULL THEN            
  (SELECT ISNULL(CUSG_DESCRIPTION,'') FROM  TBL_MAS_CUST_GROUP A            
   WHERE A.ID_CUST_GRP_SEQ = Customer.ID_CUST_GROUP)            
   ELSE ''            
   END AS CGROUP,            
   CASE WHEN ID_Cust_Pay_Term IS NOT NULL THEN            
  (SELECT CAST(TERMS AS VARCHAR) + ' - ' + ISNULL(DESCRIPTION,'') DESCRIPTION            
  FROM  TBL_MAS_CUST_PAYTERMS A            
   WHERE A.ID_PT_SEQ = Customer.ID_Cust_Pay_Term)            
    ELSE ''            
   END AS PayTerm,ID_Cust_Pay_Term,            
   CASE WHEN ID_CUST_PAY_TYPE IS NOT NULL THEN            
  (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_SETTINGS A            
   WHERE A.ID_SETTINGS = Customer.ID_CUST_PAY_TYPE)            
   ELSE ''            
   END AS PayType ,        
   CASE WHEN ID_CUST_PC_CODE IS NOT NULL THEN                 
   (SELECT  ISNULL(DESCRIPTION,'') DESCRIPTION                       
    FROM  TBL_MAS_SETTINGS A                      
    WHERE A.ID_SETTINGS = Customer.ID_CUST_PC_CODE)                      
    ELSE ''                      
    END AS ID_CUST_PC_CODE,CUST_ACCOUNT_NO,    
    CUST_COMPANY_NO,    
    CUST_COMPANY_DESCRIPTION,  
    ISNULL(FLG_PRIVATE_COMP,0) FLG_PRIVATE_COMP,  
    CUST_LAST_NAME,
    isnull(CUST_DISC_GENERAL,0) as CUST_DISC_GENERAL,
	isnull(CUST_DISC_LABOUR,0) as CUST_DISC_LABOUR,
	isnull(CUST_DISC_SPARES,0) as CUST_DISC_SPARES
  FROM           
  TBL_MAS_CUSTOMER Customer            
  WHERE           
  ID_CUSTOMER = @IVCUSTID            
              
  SELECT             
  VEH_REG_NO,             
  VEH_INTERN_NO,            
  VEH_VIN,            
  ID_VEH_SEQ,            
  CASE WHEN ID_MAKE_VEH IS NOT NULL THEN            
    (SELECT ISNULL(ID_MAKE + '   -   ' + ID_MAKE_NAME,'') FROM TBL_MAS_MAKE             
    WHERE ID_MAKE = TBL_MAS_VEHICLE.ID_MAKE_VEH)            
  ELSE ''            
  END AS MAKE,            
  CASE WHEN  ID_MODEL_VEH IS NOT NULL THEN            
    (SELECT ISNULL(ID_MODEL,'') FROM TBL_MAS_MODEL_MAKE_MAP             
    WHERE ID_MODEL = TBL_MAS_VEHICLE.ID_MODEL_VEH)            
  ELSE ''            
  END AS MODEL,            
  ISNULL(VEH_REG_NO,'')+ '-' +ISNULL(VEH_INTERN_NO,'') + '-' + ISNULL(VEH_VIN,'')  VEH_DET            
  FROM           
  TBL_MAS_VEHICLE            
  WHERE           
  ID_CUSTOMER_VEH = @IVCUSTID         
        
  --Not required in Order head in both ss2 and ss3 -- Added LastInvDate for More Info on ORder head      
  SELECT TOP 1 CONVERT(CHAR(10),DT_INVOICE,101) AS LastInvDate FROM TBL_INV_HEADER WHERE ID_DEBITOR = @IVCUSTID      
  ORDER BY DT_INVOICE DESC        
  --Exec USP_WO_CUSTCREDIT_NEW_CI @IVCUSTID          
        
        
END            
            
            
/*          
--select * from tbl_mas_customer where Id_customer ='1041'            
--  select * from TBL_MAS_VEHICLE       
Exec usp_WO_Sel_UsrDet 100      
*/      
      
      

GO

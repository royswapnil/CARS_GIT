/****** Object:  StoredProcedure [dbo].[usp_WO_Sel_VehDet]    Script Date: 10/6/2016 11:07:54 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_Sel_VehDet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WO_Sel_VehDet]
GO
/****** Object:  StoredProcedure [dbo].[usp_WO_Sel_VehDet]    Script Date: 10/6/2016 11:07:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_Sel_VehDet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_WO_Sel_VehDet] AS' 
END
GO
/*************************************** Application: MSG *************************************************************        
* Module : Work Order       
* File name : usp_WO_Sel_VehDet .prc        
* Purpose :       
* Author : M.Thiyagarajan       
* Date  : 27.10.2006      
*********************************************************************************************************************/        
/*********************************************************************************************************************          
I/P : -- Input Parameters        
O/P : -- Output Parameters        
Error Code        
Description      INT.VerNO : NOV21.0    
        
********************************************************************************************************************/        
--'*********************************************************************************'*********************************        
--'* Modified History :           
--'* S.No  RFC No/Bug ID   Date        Author  Description         
--*#0001#       CR    20/06/07    M.Thiyagarajan As Per Client Request Form has modified Refer Approved SB   
--'*********************************************************************************'*********************************        
      
ALTER PROCEDURE [dbo].[usp_WO_Sel_VehDet]        
(              
 @IVVEHID  VARCHAR(10)  
)              
AS  
BEGIN   
declare @i as varchar(20)        
DECLARE @LAST_VA_ORDER VARCHAR(20)  
  
SELECT TOP 1 @LAST_VA_ORDER = ID_WO_PREFIX+ID_WO_NO FROM TBL_WO_HEADER WHERE WO_TYPE_WOH ='CRSL' AND ID_VEH_SEQ_WO = @IVVEHID order by DT_CREATED desc  
  
         
   SELECT                 
   ID_CUSTOMER   ,                
   CUST_NAME   ,                
   CUST_CONTACT_PERSON  ,                
   CUST_PHONE_OFF  ,                
   CUST_PHONE_HOME  ,                
   CUST_PHONE_MOBILE ,                
   CUST_FAX    ,                
   CUST_ID_EMAIL  ,                
   CUST_PERM_ADD1  ,                
   CUST_PERM_ADD2  ,                
   CUST_BILL_ADD1  ,                
   CUST_BILL_ADD2  ,                
   CUST_ACCOUNT_NO  ,   
   CUST_CREDIT_LIMIT,    -- Bug 4172     
   ID_VEH_SEQ   ,                
   VEHICLE.VEH_REG_NO ,                 
   VEHICLE.VEH_INTERN_NO,                
   VEHICLE.VEH_VIN  ,                
   VEHICLE.VEH_MILEAGE  ,                
   VEHICLE.VEH_HRS  ,                
   VEHICLE.VEH_TYPE  ,                
   VEHICLE.VEH_DRV_IDEMIAL ,                
   VEHICLE.VEH_PHONE1 ,                
   VEH_MDL_YEAR   ,                
   DT_VEH_ERGN   ,                
   ID_Cust_Pay_Term  ,                
   ID_CUST_PAY_TYPE  ,              
   ID_MAKE_VEH as 'VEH_MAKE_CODE',--VEH_MAKE_CODE   ,           
   ID_MODEL_VEH   ,       
   VEH_DRIVER   ,      
   VEH_MOBILE   ,      
   VEH_PHONE1   ,      
   VEH_DRV_IDEMIAL  ,      
   VEH_ANNOT   ,      
   DT_VEH_MIL_REGN  ,      
   DT_VEH_HRS_ERGN  ,      
--'================== Begin =======================================  
-- 'Modified Date  :   07-Aug-2008  
-- 'Fixed Bug Id   :  
   VEHICLE.VEH_FLG_SERVICE_PLAN,  
   VEHICLE.VEH_FLG_ADDON,  
 VEHICLE.ID_ADDON_LOCDEPT,  
 VEHICLE.ID_VAT_CD,  
 VEHICLE.CERATED_BY,  
 VEHICLE.DT_CREATED,  
  -- CASE WHEN ID_SER_TYP IS NOT NULL THEN               
   (SELECT  ISNULL(ID_SETTINGS + ' - ' + DESCRIPTION,'') DESCRIPTION                     
    FROM  TBL_MAS_SETTINGS A                    
    WHERE A.ID_SETTINGS = Vehicle.ID_SER_TYP  
 AND  Vehicle.ID_VEH_SEQ = @IVVEHID ) as ID_SER_TYP,                   
    --ELSE ''                    
    --END AS ID_SER_TYP,      
--    CASE WHEN ID_MODEL_RP IS NOT NULL THEN       
--    (select ISNULL(DESCRIPTION,'') DESCRIPTION       
--    from TBL_MAS_MODEL_MAKE_MAP A      
--    WHERE A.ID_MODEL = Vehicle.ID_MODEL_RP)      
--    ELSE ''                    
--    END AS ID_MODEL_RP,  
 --Vehicle.ID_SER_TYP AS ID_SER_TYP,  
 Vehicle.ID_MODEL_RP AS ID_MODEL_RP,   
  
 --CASE WHEN Vehicle.ID_CUSTOMER_VEH IS NOT NULL THEN              
  (SELECT               
   OW.ID_OWNER_VEH AS ID_OWNER_VEH                
  FROM                  TBL_MAS_VEH_OWNERHISTORY OW              
  WHERE               
   ID_VEH_OWNER = (SELECT MAX(ID_VEH_OWNER)              
  FROM TBL_MAS_VEH_OWNERHISTORY               
  WHERE  ID_VEH_SEQ_OWN= @IVVEHID))  AS ID_OWNER_VEH,             
 --ELSE               
 -- ''                  
 --END AS ID_OWNER_VEH,   
--'================== END =========================================     
    CASE WHEN ID_VEH_SEQ IS NOT NULL THEN      
    (select  CUST_NAME from TBL_MAS_CUSTOMER where ID_CUSTOMER in      
    (select top 1 ID_OWNER_VEH from TBL_MAS_VEH_OWNERHISTORY       
 where  ID_VEH_SEQ_OWN = Vehicle.ID_VEH_SEQ      
 order by DT_created desc))        
    ELSE ''      
    END VEH_OWNER,      
--    CASE WHEN ID_VEH_SEQ IS NOT NULL THEN      
--      (select top 1 VEH_ERGN_DT from TBL_MAS_VEH_OWNERHISTORY       
-- where  ID_VEH_OWNER = Vehicle.ID_VEH_SEQ      
-- order by DT_created desc)      
--    ELSE ''      
--    END LAST_REG_DATE,  
  
 CASE WHEN Vehicle.DT_VEH_ERGN IS NOT NULL THEN    
  (SELECT                 
   OW.VEH_ERGN_DT AS LAST_REG_DATE                  
  FROM                 
   TBL_MAS_VEH_OWNERHISTORY OW                
  WHERE                 
   ID_VEH_OWNER = (SELECT MAX(ID_VEH_OWNER)                
  FROM TBL_MAS_VEH_OWNERHISTORY                 
  WHERE  ID_VEH_SEQ_OWN= @IVVEHID    
  AND ID_VEH_OWNER NOT IN    
  (    
   (SELECT MAX(ID_VEH_OWNER)                
   FROM TBL_MAS_VEH_OWNERHISTORY                 
   WHERE  ID_VEH_SEQ_OWN= @IVVEHID))))  
  END AS LAST_REG_DATE,       
  
    CASE WHEN ID_GROUP_VEH IS NOT NULL THEN      
    (SELECT  ISNULL(DESCRIPTION,'') DESCRIPTION                     
    FROM  TBL_MAS_SETTINGS A                    
    WHERE A.ID_SETTINGS = Vehicle.ID_GROUP_VEH)      
    ELSE ''      
    END  ID_GROUP_VEH,      
   CASE WHEN ID_MAKE_VEH IS NOT NULL THEN                
    (SELECT ISNULL(ID_MAKE + '   -   ' + ID_MAKE_NAME,'') FROM TBL_MAS_MAKE                 
    WHERE ID_MAKE = Vehicle.ID_MAKE_VEH)                
   ELSE ''                
   END AS MAKE,                
   CASE WHEN  ID_MODEL_VEH IS NOT NULL THEN                
    (SELECT ISNULL(ID_MODEL,'') FROM TBL_MAS_MODEL_MAKE_MAP          
    WHERE ID_MODEL = Vehicle.ID_MODEL_VEH)                
   ELSE ''                
   END AS MODEL,     
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
   ELSE   ''                
   END AS PState,                
   CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN                
    (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_CONFIG_DETAILS A,                
  TBL_MAS_ZIPCODE B WHERE A.ID_PARAM = B.ZIP_ID_COUNTRY                 
  AND B.ZIP_ZIPCODE = Customer.ID_CUST_PERM_ZIPCODE )                
   ELSE  ''                
   END AS PCountry,    
    CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN        
    (SELECT ISNULL(ZIP_CITY,'') FROM  TBL_MAS_ZIPCODE B   
 WHERE B.ZIP_ZIPCODE = Customer.ID_CUST_PERM_ZIPCODE )        
   ELSE        
    ''        
   END AS PCITY,  
   ID_CUST_BILL_ZIPCODE,              
   CASE WHEN ID_CUST_BILL_ZIPCODE IS NOT NULL THEN                
    (SELECT ISNULL(ZIP_ZIPCODE,'') FROM TBL_MAS_ZIPCODE                 
    WHERE ZIP_ZIPCODE = Customer.ID_CUST_BILL_ZIPCODE)                
   ELSE ''                
   END AS BZipCode,                
                
   CASE WHEN ID_CUST_PERM_ZIPCODE IS NOT NULL THEN                
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
   --(SELECT  ISNULL(ID_SETTINGS + ' - ' + DESCRIPTION,'') DESCRIPTION   
 (SELECT  ISNULL(DESCRIPTION,'') DESCRIPTION                      
    FROM  TBL_MAS_SETTINGS A                    
    WHERE A.ID_SETTINGS = Customer.ID_CUST_DISC_CD)                    
  ELSE ''                    
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
   END AS PayTerm,                
   CASE WHEN ID_CUST_PAY_TYPE IS NOT NULL THEN                
  (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_SETTINGS A                
   WHERE A.ID_SETTINGS = Customer.ID_CUST_PAY_TYPE)                
   ELSE ''                
   END AS PayType,  
  -- Bug 4172   
   CASE WHEN ID_CUST_PC_CODE IS NOT NULL THEN                
  (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_SETTINGS A                
   WHERE A.ID_SETTINGS = Customer.ID_CUST_PC_CODE)                
   ELSE ''                
   END AS ID_CUST_PC_CODE    ,  
   @LAST_VA_ORDER as 'VA_ORDER',  
   Vehicle.COST_PRICE ,  
   Vehicle.SELL_PRICE   
--   FROM TBL_MAS_CUSTOMER Customer  Join TBL_MAS_VEHICLE Vehicle                
--   on Customer.Id_customer = Vehicle.ID_CUSTOMER_VEH                
--   and Vehicle.ID_VEH_SEQ = @IVVEHID     
  
 FROM TBL_MAS_VEHICLE Vehicle left outer join TBL_MAS_CUSTOMER Customer  
on  Vehicle.ID_CUSTOMER_VEH  = Customer.Id_customer      
WHERE  Vehicle.ID_VEH_SEQ = @IVVEHID   
END                
      
           
/*                
select * from tbl_mas_customer where Id_customer ='1041'                
 select * from TBL_MAS_VEHICLE      
 select * from tbl_mas_settings      
 select * from TBL_MAS_VEH_OWNERHISTORY       
 where ID_VEH_OWNER =1       
 order by DT_created desc      
select  CUST_NAME from TBL_MAS_CUSTOMER where ID_CUSTOMER in (      
select top 1 ID_OWNER_VEH from TBL_MAS_VEH_OWNERHISTORY       
 where  ID_VEH_SEQ_OWN = 1      
 order by DT_created desc)      
usp_WO_Sel_VehDet 567     
      
*/  
/*  
select * from tbl_mas_customer where id  
  
select * from tbl_mas_customer where Id_customer =501  
  
 select * from TBL_MAS_VEHICLE    
select * from  tbl_mas_customer right outer join TBL_MAS_VEHICLE   
on TBL_MAS_VEHICLE.ID_CUSTOMER_VEH=tbl_mas_customer.ID_CUSTOMER   
where  ID_VEH_SEQ=501  
  
*/  
GO

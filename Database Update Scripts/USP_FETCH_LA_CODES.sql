/****** Object:  StoredProcedure [dbo].[USP_FETCH_LA_CODES]    Script Date: 8/7/2017 1:23:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_LA_CODES]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_LA_CODES]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_LA_CODES]    Script Date: 8/7/2017 1:23:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_LA_CODES]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_LA_CODES] AS' 
END
GO
/*************************************** APPLICATION: MSG *************************************************************                  
* MODULE   : Link to Accounting- MATRIX Screen                
* FILE NAME   : USP_FETCH_LA_CODES                 
* PURPOSE   : TO FETCH ALL THE Department Account Codes and Customer group Account Codes                  
* AUTHOR   : Smita M              
* DATE    : 13.07.2017                  
*********************************************************************************************************************/                  
                
ALTER PROCEDURE [dbo].[USP_FETCH_LA_CODES]                
(                
   @IV_ID_LOGIN VARCHAR(20)               
)                
AS                
BEGIN                
          
 DECLARE @HDOC INT                      
 DECLARE @IV_XMLDOC AS VARCHAR(8000)                 
 SELECT @IV_XMLDOC = DBO.FN_DEPTS_FETCH(@IV_ID_LOGIN)                
 EXEC SP_XML_PREPAREDOCUMENT @HDOC OUTPUT, @IV_XMLDOC             
            
 --Fetching Labour Account code          
 SELECT distinct(HP_ACC_CODE)AS 'LABSC'  FROM TBL_MAS_HP_RATE WHERE len(ltrim(rtrim(HP_ACC_CODE))) > 0 --IS NOT NULL          
 and id_dept_hp    IN (          
 SELECT DISTINCT ID_DEPT                
 FROM TBL_MAS_DEPT                 
 WHERE  ID_DEPT IN (SELECT ID FROM OPENXML (@HDOC,'ROOT/D',0)                
        WITH (                
          ID INT                
          )                
   )            
and DPT_ACCCODE is not null           
          
   )           
                
 SELECT DISTINCT(ACCOUNT_CODE) AS 'SPARESSC' FROM TBL_MAS_ITEM_MASTER WHERE len(ltrim(rtrim(ACCOUNT_CODE)))> 0  -- IS NOT NULL                
 UNION  
 SELECT ACCOUNTCODE FROM TBL_MAS_ITEM_CATG WHERE len(ltrim(rtrim(ACCOUNTCODE)))> 0   

SELECT  DISTINCT         
GP_ACCCODE  AS 'GARMATSC'          
                 
FROM  TBL_MAS_CUST_GRP_GM_PRICE_MAP  S                       
INNER JOIN  TBL_MAS_DEPT D                     
  ON  S.ID_DEPT   = D.ID_DEPT                      
INNER JOIN  TBL_MAS_CUST_GROUP C                     
  ON  S.ID_CUST_GRP_SEQ = C.ID_CUST_GRP_SEQ                    
    AND D.ID_DEPT  IN (SELECT ID FROM OPENXML (@HDOC,'ROOT/D',0)                    
          WITH (                  
          ID INT                    
            )                    
         )               
AND   GP_ACCCODE IN    ( SELECT DISTINCT(WO_GM_ACCCODE)            
   FROM TBL_WO_DETAIL WHERE LEN(LTRIM(RTRIM(WO_GM_ACCCODE))) >  0 )          
         
                
 SELECT DISTINCT(vat_AccCode) AS 'VATSC' FROM TBL_VAT_DETAIL WHERE len(ltrim(rtrim(vat_AccCode))) > 0  
         
         
  
 SELECT AccountCode AS 'RoundingAcc'  
 FROM TBL_MAS_SUBSIDERY   
 WHERE ID_Subsidery IN (          
    SELECT DISTINCT ID_SUBSIDERY_DEPT                
    FROM TBL_MAS_DEPT                 
    WHERE  ID_DEPT IN (SELECT ID FROM OPENXML (@HDOC,'ROOT/D',0)                
        WITH (ID INT )                
         )            
     AND DPT_ACCCODE is not null           
       )  
 AND AccountCode IS NOT NULL   
 AND AccountCode <> ''  
 UNION  
 SELECT ACCOUNT_CODE AS 'RoundingAcc'   
 FROM TBL_MAS_INV_CONFIGURATION   
 WHERE ID_DEPT_INV IN (          
    SELECT DISTINCT ID_DEPT                
    FROM TBL_MAS_DEPT                 
    WHERE  ID_DEPT IN (SELECT ID FROM OPENXML (@HDOC,'ROOT/D',0)                
         WITH (ID INT )                
           )            
    AND DPT_ACCCODE is not null           
          
   )  
  
  AND ACCOUNT_CODE IS NOT NULL   
  
 EXEC SP_XML_REMOVEDOCUMENT @HDOC   
  
  SELECT DISTINCT OWNRISK_ACCTCODE   
 FROM TBL_MAS_DEPT   
 WHERE ID_Dept = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login = @IV_ID_LOGIN)   
  AND OWNRISK_ACCTCODE IS NOT NULL    
    
 SELECT DISTINCT VA_ACC_CODE AS VA_ACCTCODE FROM TBL_MAS_VEHICLE    
 WHERE VA_ACC_CODE IS NOT NULL and VA_ACC_CODE <>''  
   
 SELECT DISTINCT FIXED_PR_ACC_CODE AS FP_ACCTCODE FROM TBL_LA_CONFIG   
 WHERE FIXED_PR_ACC_CODE IS NOT NULL and FIXED_PR_ACC_CODE <>''  
   
 SELECT DISTINCT INV_FEES_ACC_CODE AS IF_ACCTCODE  
 FROM TBL_MAS_INV_FEES_SETTINGS where INV_FEES_ACC_CODE is not null and INV_FEES_ACC_CODE<>''  
   
------------------------------------          
  
END                

GO

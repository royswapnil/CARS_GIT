/****** Object:  StoredProcedure [dbo].[USP_WO_LOAD_VAT_GMHP]    Script Date: 4/13/2017 5:00:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_LOAD_VAT_GMHP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_LOAD_VAT_GMHP]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_LOAD_VAT_GMHP]    Script Date: 4/13/2017 5:00:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_LOAD_VAT_GMHP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_LOAD_VAT_GMHP] AS' 
END
GO
  
/*************************************** Application: MSG *************************************************************                        
* Module : Work Order                       
* File name : USP_WO_LOAD_VAT_GMHP .prc                        
* Purpose : To load VAT for Garage Material and Hourly Price                      
* Author : 2_4 92                       
* Date  : 30.07.2008                      
*********************************************************************************************************************/                        
    --[USP_WO_LOAD_VAT_GMHP] '1005','51','248','378','admin','',''          
ALTER procedure [dbo].[USP_WO_LOAD_VAT_GMHP]                        
(                        
 @IV_ID_CUST VARCHAR(10) = null,                        
 @IV_ID_VEH  VARCHAR(10),                    
 @IV_ID_HPVAT VARCHAR(10),                        
 @IV_ID_GMVAT VARCHAR(10),                        
 @IV_USERID VARCHAR(20),        
        
 ----Bug ID :- 2_4 83        
 ----Date   :- 07-Aug-2008        
 ----Desc   :- Each Customer Vat and Dis for debitor details        
 @IV_ID_ITEM VARCHAR(100) = null,                  
 @IV_ID_MAKE VARCHAR(10)        
 ----change end        
)                         
AS              
        
--Getting Subsidary and Department                 
 DECLARE @ID_SUBS AS INT                
 DECLARE @ID_DEPT AS INT                 
 SELECT  @ID_DEPT = ID_DEPT_USER,                 
   @ID_SUBS = ID_SUBSIDERY_USER                 
 FROM TBL_MAS_USERS                 
 WHERE ID_LOGIN = @IV_USERID           
        
DECLARE @WAREHOUSEID INT              
SELECT @WAREHOUSEID=ID_WAREHOUSE FROM TBL_MAS_USERS               
INNER JOIN TBL_SPR_DEPT_WH ON ID_DEPARTMENT =ID_DEPT_USER AND FLG_DEFAULT=1 WHERE ID_LOGIN = @IV_USERID    
  
DECLARE @EFD_SPAREID AS VARCHAR(20)  
SELECT @EFD_SPAREID = ISNULL(ENV_ID_ITEM,'') FROm TBL_MAS_ITEM_MASTER WHERE ID_ITEM = @IV_ID_ITEM  and ID_WH_ITEM=@WAREHOUSEID and SUPP_CURRENTNO=@IV_ID_MAKE  
  
DECLARE @ItemDisCode varchar(20)   
DECLARE @VATID INT    
DECLARE @MAKECODE AS VARCHAR(20)    
DECLARE @VATCODE AS VARCHAR(20)   
  
  
      
    
-- ****************************************    
-- Modified Date : 23rd December 2008    
-- Bug Id   : Warrenty List - Row No:126    
   
    
SELECT @VATID = ID_VAT_CD FROM TBL_MAS_VEHICLE WHERE  ID_VEH_SEQ = @IV_ID_VEH    
IF @VATID IS NULL    
BEGIN    
 SELECT @MAKECODE = ID_MAKE_VEH FROM TBL_MAS_VEHICLE WHERE  ID_VEH_SEQ = @IV_ID_VEH    
 --PRINT @MAKECODE    
 --SELECT @VATCODE = MAKE_VATCODE FROM TBL_MAS_MAKE WHERE ID_MAKE = @MAKECODE    
 SET @VATCODE = 'PLI'  
 --PRINT @VATCODE    
 SELECT @VATID = ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE DESCRIPTION  = @VATCODE AND ID_CONFIG = 'VAT'    
 --PRINT @VATID    
END    
-- ************** End OF Modification ****************           
    
--Hourly Price VAT        
SELECT                     
  ISNULL(VAT_PER,'0.00') AS HP_VAT                                               
 FROM                     
 TBL_VAT_DETAIL                    
 WHERE                    
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))                     
  AND                    
 VAT_VEH = @VATID --(SELECT ID_VAT_CD FROM TBL_MAS_VEHICLE WHERE  ID_VEH_SEQ = @IV_ID_VEH)                    
  AND                    
 VAT_ITEM = (SELECT DISTINCT HP_Vat FROM TBL_MAS_HP_RATE WHERE HP_Vat =@IV_ID_HPVAT)              
  AND                    
 GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                          
                          
        
--Garage Material VAT              
SELECT                     
  ISNULL(VAT_PER,'0.00')   AS GM_VAT                  
 FROM                     
 TBL_VAT_DETAIL                    
 WHERE                    
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))                     
  AND                    
 VAT_VEH = @VATID--(SELECT ID_VAT_CD FROM TBL_MAS_VEHICLE WHERE  ID_VEH_SEQ = @IV_ID_VEH)                    
  AND                    
 VAT_ITEM = (SELECT DISTINCT ID_Vat FROM TBL_MAS_CUST_GRP_GM_PRICE_MAP WHERE ID_Vat =@IV_ID_GMVAT)              
  AND                    
 GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO         
        
--Spare Part VAT              
SELECT               
  ISNULL(VAT_PER,'0.00') AS   SP_VAT         
 FROM               
 TBL_VAT_DETAIL              
 WHERE              
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))               
  AND              
 VAT_VEH = @VATID --(SELECT ID_VAT_CD FROM TBL_MAS_VEHICLE WHERE  ID_VEH_SEQ = @IV_ID_VEH)              
  AND              
 VAT_ITEM = (SELECT VATCODE FROM TBL_MAS_ITEM_CATG WHERE ID_ITEM_CATG = (SELECT ID_ITEM_CATG FROM TBL_MAS_ITEM_MASTER WHERE ID_ITEM = @IV_ID_ITEM AND ID_WH_ITEM = @WAREHOUSEID AND SUPP_CURRENTNO = @IV_ID_MAKE))              
  AND              
 GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO         
        
--Spare Part Discount              
         
SELECT @ItemDisCode = ISNULL(ITEM_DISC_CODE,          
      (SELECT ID_DISCOUNTCODESELL FROM  TBL_MAS_ITEM_CATG          
       WHERE ID_ITEM_CATG IN (SELECT ID_ITEM_CATG FROM TBL_MAS_ITEM_MASTER           
             WHERE ID_ITEM = @IV_ID_ITEM          
             AND SUPP_CURRENTNO = @IV_ID_MAKE          
             AND ID_WH_ITEM = @WAREHOUSEID)))          
      FROM TBL_MAS_ITEM_MASTER           
      WHERE ID_ITEM = @IV_ID_ITEM          
        AND SUPP_CURRENTNO = @IV_ID_MAKE          
        AND ID_WH_ITEM = @WAREHOUSEID          
          
--Getting Discount Code for customer          
DECLARE @CustDisCode varchar(20)           
SELECT  @CustDisCode = ISNULL(ID_CUST_DISC_CD,          
       (SELECT ID_DISC_CD FROM TBL_MAS_CUST_GROUP           
        WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP           
               FROM TBL_MAS_CUSTOMER           
               WHERE ID_CUSTOMER = @IV_ID_CUST)))          
        FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = @IV_ID_CUST          
--Getting DiscPer and DiscSeq          
        
SELECT ISNULL(DISCPER,'0.00')  AS DIS_PER        
FROM           
 TBL_SPR_DISCOUNTMATRIXSELL          
WHERE          
 ID_DISCOUNTCODE = @ItemDisCode               
 AND ID_DEPT = @ID_DEPT          
 AND ID_SETTINGS_CUST = @CustDisCode               
 AND ID_MAKE = @IV_ID_MAKE          
      
--MODIFIED DATE: 17 OCT 2008      
--COMMENTS: WORK ORDER - FIXED PRICE VAT              
      
SELECT               
  ISNULL(VAT_PER,'0.00') AS FIXED_VAT                  
 FROM               
 TBL_VAT_DETAIL              
 WHERE              
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))                 
  AND         
 VAT_VEH IS NULL      
  AND              
 VAT_ITEM IS NULL      
  AND            
 GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO       
      
--END OF MODIFICATION      
    
--MODIFIED DATE: 17 OCT 2008      
--COMMENTS: SPARE WORK ORDER - VAT PER             
      
SELECT               
  ISNULL(VAT_PER,'0.00') AS VAT_PER                  
 FROM               
 TBL_VAT_DETAIL              
 WHERE              
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))                 
  AND         
 VAT_VEH IS NULL      
  AND              
 VAT_ITEM = (SELECT VATCODE FROM TBL_MAS_ITEM_CATG WHERE ID_ITEM_CATG = (SELECT ID_ITEM_CATG FROM TBL_MAS_ITEM_MASTER WHERE ID_ITEM = @IV_ID_ITEM AND ID_WH_ITEM = @WAREHOUSEID AND SUPP_CURRENTNO = @IV_ID_MAKE))               
  AND            
 GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO    
   
  
   
   
     
      
--END OF MODIFICATION      
      
-- To Fetch own risk vat    
SELECT     
 CASE WHEN WO_VAT_CALCRISK = 1 THEN    
  (    
   SELECT ISNULL(VAT_PERCENTAGE, 0)      
   FROM TBL_MAS_SETTINGS     
   WHERE ID_SETTINGS =     
   (    
    SELECT VATCODE     
    FROM TBL_MAS_ITEM_CATG     
    WHERE ID_MAKE =     
     (    
      SELECT ID_MAKE     
      FROM TBL_MAS_DEPT    
      WHERE ID_DEPT = @ID_DEPT    
     )    
    AND CATG_DESC =     
     (    
      SELECT CATG_DESC     
      FROM TBL_MAS_ITEM_CATG     
      WHERE ID_ITEM_CATG =     
       (    
        SELECT ID_ITEM_CATEG     
        FROM TBL_MAS_DEPT    
        WHERE ID_DEPT = @ID_DEPT    
       )    
     )    
   )    
  )    
 ELSE    
  '0.00'    
 END    
 AS OWNRISKVAT    
    
FROM TBL_MAS_WO_CONFIGURATION     
WHERE ID_SUBSIDERY_WO = @ID_SUBS     
 AND ID_DEPT_WO = @ID_DEPT     
AND    
 GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO     
   
   
  IF @EFD_SPAREID <> ''  
 BEGIN  
   SELECT               
  ISNULL(VAT_PER,'0.00') AS VAT_PER_EFD                 
 FROM               
 TBL_VAT_DETAIL     
             
 WHERE              
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))                 
  AND         
 VAT_VEH IS NULL      
  AND              
 VAT_ITEM = (SELECT VAT_CODE FROM TBL_MAS_ENVFEESETTINGS WHERE  ID_ITEM = @EFD_SPAREID AND ID_WAREHOUSE = @WAREHOUSEID AND ID_MAKE = @IV_ID_MAKE)   
 END   
   
   IF @EFD_SPAREID <> ''  
 BEGIN  
   SELECT               
  ISNULL(VAT_PER,'0.00') AS VAT_PER_EFD                 
 FROM               
 TBL_VAT_DETAIL     
 WHERE              
 VAT_CUST =(SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@IV_ID_CUST))                 
  AND         
 VAT_VEH = @VATID  
  AND              
 VAT_ITEM = (SELECT VAT_CODE FROM TBL_MAS_ENVFEESETTINGS WHERE  ID_ITEM = @EFD_SPAREID AND ID_WAREHOUSE = @WAREHOUSEID AND ID_MAKE = @IV_ID_MAKE)   
 END   
  
  
  
  
                   
                          
        
       
        
       
        
      
          
    
        
            
      
  
  
              
   
   
   
    
  
-- End of To Fetch own risk vat  
GO

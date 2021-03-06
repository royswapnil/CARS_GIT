/****** Object:  StoredProcedure [dbo].[USP_WO_LOAD_CONFIG]    Script Date: 11/9/2016 5:30:24 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_LOAD_CONFIG]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_LOAD_CONFIG]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_LOAD_CONFIG]    Script Date: 11/9/2016 5:30:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_LOAD_CONFIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_LOAD_CONFIG] AS' 
END
GO
/*************************************** Application: MSG *************************************************************            
* Module : Work Order           
* File name : usp_WO_LOAD_CONFIG.prc            
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
--*#0001#   13/03/2007  M.Thiyagarajan    Patched due to Error Reported           
--         in Invoice ID_RPKG_SEQ  AS ID_RP_CODE,          
--         ID_RP_CODE  AS ID_RPKG_SEQ.          
--*#0002#     25/04/2007  M.Thiyagarajan Added Station Type.           
--*#0002#     29/09/2007  P. Dhanunjaya rao Fixed Bug# 3525 for Standard or Clocked time          
--'*********************************************************************************'*********************************            
            
ALTER PROC [dbo].[USP_WO_LOAD_CONFIG]                
(                    
 @IV_ID_WO_NO  AS VARCHAR(10) ,                    
 @IV_ID_WO_PREFIX AS VARCHAR(3),                    
 @IV_ID_USERID  AS VARCHAR(20) ,        
 --Start      
 @IV_ID_MAKE_RP  AS VARCHAR(50) ,      
 @IV_ID_MODEL_RP AS VARCHAR(50)                 
)                    
AS                      
BEGIN                       
 DECLARE @DEPID AS INT                    
 DECLARE @SUBID AS INT          
 DECLARE @ID_CUST_WO1 AS VARCHAR(20)      
 DECLARE @STRQRY AS NVARCHAR(MAX)         
 DECLARE @VEH_ID AS INT        
 DECLARE @CUSTOMER_ID VARCHAR(100)    
  -- USP_CONFIG_SETTINGS_FETCH                      
   ---Fetch All Repair Package Details                      
  --EXEC USP_CONFIG_REPAIR_PACKAGECODEFETCHALL           
      
  select @VEH_ID = ID_VEH_SEQ_WO,@CUSTOMER_ID = ID_CUST_WO from TBL_WO_HEADER where ID_WO_NO= @IV_ID_WO_NO and ID_WO_PREFIX = @IV_ID_WO_PREFIX          
               
  IF EXISTS (SELECT * FROM TBL_WO_HEADER where ID_WO_NO=@IV_ID_WO_NO and ID_WO_PREFIX =@IV_ID_WO_PREFIX)    
  BEGIN    
    SELECT top 1 @DEPID = ID_Dept,@SUBID = ID_Subsidery FROM TBL_WO_HEADER where ID_WO_NO=@IV_ID_WO_NO and ID_WO_PREFIX =@IV_ID_WO_PREFIX    
  END             
  ELSE    
  BEGIN       
  SELECT @DEPID = ID_DEPT_USER,          
    @SUBID = ID_SUBSIDERY_USER                     
  FROM TBL_MAS_USERS                    
  WHERE ID_LOGIN = @IV_ID_USERID       
   END      
--             
----Ref No:0001       ---Fetch All Repair Package Details                      
-- SELECT ID_RPKG_SEQ  AS ID_RP_CODE ,                  
--   ID_RP_CODE  AS ID_RPKG_SEQ,                  
--   ISNULL(RP_DESC,'')   AS RP_DESC,                  
--   ISNULL(FLG_FIX_PRICE,0)  AS FLG_FIX_PRICE ,        
----Start      
--   ISNULL(ID_MAKE_RP,'') AS ID_MAKE_RP,      
--   ISNULL(ID_MODEL_RP,'') AS ID_MODEL_RP,      
----End      
--   ISNULL(RP_FIXED_PRICE,0) AS RP_FIXED_PRICE ,                  
--   ISNULL(RP_GM_PRICE,0)  AS RP_GM_PRICE   ,                  
--   ISNULL(ID_WORK_CD_RP,'') AS ID_WORK_CD_RP  ,                  
--   ISNULL(ID_CATG_RP,'')    AS ID_CATG_RP    ,                  
--   ISNULL(RP_JOB_TEXT,'')   AS RP_JOB_TEXT   ,                  
--   ISNULL(FLG_USE_STD_TIME,'') AS FLG_USE_STD_TIME ,                  
--   RP_STD_TIME  ,                   
--   ISNULL(ID_RP_PRC_GRP,'') AS ID_RP_PRC_GRP  ,                  
--   ISNULL(ID_DEBITOR_RP,'') AS ID_DEBITOR_RP  ,                  
--   ID_REP_CODE          ,                  
--   CASE WHEN ID_REP_CODE IS NOT NULL THEN                  
--    (SELECT ISNULL(RP_REPCODE_DES,'') FROM TBL_MAS_REPAIRCODE                   
--     WHERE ID_REP_CODE = TBL_MAS_REP_PACKAGE.ID_REP_CODE)                  
--   ELSE ''                  
--   END AS  REPC_DESC                             
-- FROM TBL_MAS_REP_PACKAGE        
----Bug ID:-SS2_4_54      
----Date:-05-June-2008      
----Desc:- Should display Rep Pack Desc also even if Category not selected      
--where    RP_DESC <> ''       
----START      
-- AND (ID_MAKE_RP = @IV_ID_MAKE_RP OR ID_MAKE_RP IS NULL OR ID_MAKE_RP IS NOT NULL)       
-- AND (ID_MODEL_RP = @IV_ID_MODEL_RP OR ID_MODEL_RP IS NULL OR ID_MODEL_RP IS NULL)                 
----CHANGE END      
-- ORDER BY RP_DESC             
      
    
 IF @IV_ID_MAKE_RP IS NULL    
  SET @IV_ID_MAKE_RP=''    
    
 IF @IV_ID_MODEL_RP IS NULL    
  SET @IV_ID_MODEL_RP=''    
    
SET @STRQRY = 'SELECT ID_RPKG_SEQ  AS ID_RP_CODE,                  
      ID_RP_CODE  AS ID_RPKG_SEQ,                  
      ISNULL(RP_DESC,'''')   AS RP_DESC,                  
      ISNULL(FLG_FIX_PRICE,0)  AS FLG_FIX_PRICE ,        
      ISNULL(ID_MAKE_RP,'''') AS ID_MAKE_RP,      
      ISNULL(ID_MODEL_RP,'''') AS ID_MODEL_RP,      
      ISNULL(RP_FIXED_PRICE,0) AS RP_FIXED_PRICE ,                  
      ISNULL(RP_GM_PRICE,0)  AS RP_GM_PRICE   ,                  
      ISNULL(ID_WORK_CD_RP,'''') AS ID_WORK_CD_RP  ,                  
      ISNULL(ID_CATG_RP,'''')    AS ID_CATG_RP    ,                  
      ISNULL(RP_JOB_TEXT,'''')   AS RP_JOB_TEXT   ,                  
      ISNULL(FLG_USE_STD_TIME,'''') AS FLG_USE_STD_TIME ,                  
      RP_STD_TIME  ,                   
      ISNULL(ID_RP_PRC_GRP,'''') AS ID_RP_PRC_GRP  ,                  
      ISNULL(ID_DEBITOR_RP,'''') AS ID_DEBITOR_RP  ,                  
      ID_REP_CODE          ,                  
       CASE WHEN ID_REP_CODE IS NOT NULL THEN                  
        (SELECT ISNULL(RP_REPCODE_DES,'''') FROM TBL_MAS_REPAIRCODE                   
         WHERE ID_REP_CODE = TBL_MAS_REP_PACKAGE.ID_REP_CODE)                  
       ELSE ''''                
       END AS  REPC_DESC                             
      FROM TBL_MAS_REP_PACKAGE       
      WHERE ID_RPKG_SEQ IN (SELECT ID_RPKG_SEQ FROM GetID_RPKG_SEQ(''' +  @IV_ID_MAKE_RP + ''')) '      
            
     
    
     
      IF((@IV_ID_MAKE_RP IS NULL OR @IV_ID_MAKE_RP = '') AND (@IV_ID_MODEL_RP IS NULL OR @IV_ID_MODEL_RP = ''))      
      BEGIN      
       SET @STRQRY = @STRQRY + ' AND RP_DESC <> '''''      
      END      
      ELSE IF(@IV_ID_MAKE_RP IS NOT NULL AND @IV_ID_MODEL_RP IS NOT NULL)      
      BEGIN      
       SET @STRQRY = @STRQRY + 'AND RP_DESC <> '''' AND (ID_MAKE_RP IS NULL OR ID_MAKE_RP = '''+ @IV_ID_MAKE_RP +''') and (ID_MODEL_RP = '''+ @IV_ID_MODEL_RP +''' or ID_MODEL_RP IS NULL)'      
      END      
      ELSE IF(@IV_ID_MAKE_RP IS NOT NULL AND @IV_ID_MODEL_RP IS NULL)       
      BEGIN       
       SET @STRQRY = @STRQRY + ' AND RP_DESC <> '''' and (ID_MAKE_RP IS NULL OR ID_MAKE_RP = '''+@IV_ID_MAKE_RP+''')'      
      END      
      ELSE IF(@IV_ID_MAKE_RP IS NULL AND @IV_ID_MODEL_RP IS NOT NULL)       
      BEGIN       
       SET @STRQRY = @STRQRY + ' AND  RP_DESC <> '''' and (ID_MODEL_RP IS NULL OR ID_MODEL_RP = '''+@IV_ID_MODEL_RP+''')'      
      END      
            
      SET @STRQRY = @STRQRY + 'ORDER BY RP_DESC '      
      --PRINT @STRQRY      
      EXEC(@STRQRY)      
           
   --FETCH ALL REPAIR CODE DETAILS                      
 EXEC USP_CONFIG_REPAIR_CODEFETCHALL                      
             
 --EXEC USP_WO_LOAD_SPARES                      
 SELECT D.ID_WOITEM_SEQ ,                      
   D.ID_WODET_SEQ_JOB,                      
   '' AS ID_MAKE_JOB_ID,                      
      D.ID_MAKE_JOB  ,                      
      '' AS ID_ITEM_CATG_JOB_ID,                      
      D.ID_ITEM_CATG_JOB,                      
     D.ID_ITEM_JOB  ,                      
      '' AS ITEM_DESC ,                      
      ISNULL(D.JOBI_ORDER_QTY,0) JOBI_ORDER_QTY ,                      
      ISNULL(D.JOBI_DELIVER_QTY,0) JOBI_DELIVER_QTY,                      
      ISNULL(D.JOBI_BO_QTY,0) JOBI_BO_QTY  ,                      
      D.JOBI_SELL_PRICE ,       
--Change by Manoj K on 2-Apr-2008                    
--      CAST(ISNULL(JOBI_DIS_PER,0) AS NUMERIC(5,2)) JOBI_DIS_PER,                   
--      '0' JOBI_DIS_SEQ,                      
--      CAST(ISNULL(JOBI_VAT_PER,0) AS NUMERIC(5,2)) JOBI_VAT_PER,            
   CAST(ISNULL(D.JOBI_DIS_PER,0) AS varchar(10)) JOBI_DIS_PER,                   
      '0' JOBI_DIS_SEQ,                      
      CAST(ISNULL(D.JOBI_VAT_PER,0) AS varchar(10)) JOBI_VAT_PER,                 
--Change end by Manoj K        
      '0' JOBI_VAT_SEQ,                        
      D.ORDER_LINE_TEXT ,                      
      '' AS SLNO      ,                      
      '' AS MAKE  ,                      
      '' AS TOTAL_PRICE,                      
      '' AS ID_MAKE  ,        
 D.ID_WAREHOUSE                 
--MODIFIED DATE: 04 OCT 2008      
--COMMENTS: SS2 - WO CHANEGS      
 ,D.ID_CUST_WO      
 ,D.TD_CALC      
 ,D.[TEXT]      
 ,D.[JOBI_COST_PRICE]      
--END OF MODOFICATION          
--MODIFIED DATE: 08 OCT 2008      
--COMMENTS: SS2 - WO CHANEGS - Debitor online changes      
 ,ISNULL(D.ID_DBT_SEQ,'-1') AS ID_DBT_SEQ  ,    
-- Modified Date : 30th March 2010    
-- Bug ID   : previous printed status corrected    
 D.PICKINGLIST_PREV_PRINTED   ,    
 D.DELIVERYNOTE_PREV_PRINTED,    
 D.PICKINGLIST_PREV_PICKED AS PREV_PICKED,    
 (D.JOBI_ORDER_QTY - D.PICKINGLIST_PREV_PICKED) AS TOBE_PICKED,    
 ISNULL(D.SPARE_TYPE,'ORD') AS SPARE_TYPE,    
 ISNULL(D.FLG_FORCE_VAT,0) AS FLG_FORCE_VAT,    
 IM.LOCATION,    
  ISNULL(D.FLG_EDIT_SP,0) AS FLG_EDIT_SP,    
  EXPORT_TYPE    
 -- End OF Modification *************    
--END OF MODOFICATION          
   FROM TBL_WO_JOB_DETAIL D    
   left outer join TBL_MAS_ITEM_MASTER IM on IM.ID_ITEM=D.ID_ITEM_JOB and D.ID_WAREHOUSE=IM.ID_WH_ITEM and D.ID_MAKE_JOB=IM.ID_MAKE                        
   WHERE ID_WOITEM_SEQ=0                      
                       
 EXEC  USP_CONFIG_SETTINGS_FETCH 'RP-CATG'                      
 EXEC  USP_CONFIG_SETTINGS_FETCH 'HP-JOB-PC'                      
 EXEC  USP_WO_CONFIG_DET @IV_ID_USERID                     
 EXEC  USP_CONFIG_SETTINGS_FETCH 'HP-JOB-PC'                      
 EXEC  USP_CONFIG_SETTINGS_FETCH 'RP-WC'                      
                       
 SELECT ID_CUST_WO,                      
   WO_CUST_GROUPID,                      
   ID_VEH_SEQ_WO,                      
   CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                        
    (SELECT ID_GROUP_VEH FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = ID_VEH_SEQ_WO)                        
   END AS ID_GRP_VEH,                      
   CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                        
    (SELECT ID_MAKE_VEH  FROM  TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = ID_VEH_SEQ_WO)                        
   END AS ID_MAKE_VEH       
--Modified Date: 18 Sep 2008      
--Comments: Reg No and Mileage added         
  ,WO_VEH_REG_NO      
 ,WO_VEH_MILEAGE                    
--End of Modification      
 FROM TBL_WO_HEADER                      
 WHERE ID_WO_NO = @IV_ID_WO_NO                      
 AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                      
                    
 SELECT ID_COMPT, COMPT_DESCRIPTION FROM TBL_MAS_MEC_COMPT                    
                  
 -- ADDED FOR CHECKING CREDIT LIMIT AND CREDIT TYPE OF WO ORDER.                  
 SELECT ID_SETTINGS,          
   DESCRIPTION,           
   ID_CUST_WO                  
 FROM TBL_WO_HEADER HDR ,           
   TBL_MAS_SETTINGS STG                  
 WHERE   HDR.ID_WO_NO = @IV_ID_WO_NO                  
 AND  HDR.ID_WO_PREFIX =@IV_ID_WO_PREFIX                  
 AND  ID_SETTINGS =ID_PAY_TYPE_WO                   
          
--Station Type----                
 SELECT  ID_STYPE, TYPE_STATION FROM TBL_MAS_PLAN_STATION_TYPE_CFG                 
     
--Fetch mechanic details                   
 SELECT FIRST_NAME,LAST_NAME,ID_LOGIN               
 FROM TBL_MAS_USERS               
 WHERE   ID_SUBSIDERY_USER = @SUBID           
 AND  ID_DEPT_USER = @DEPID           
 AND     FLG_MECHANIC=1     
 AND  ISNULL(FLG_MECH_INACTIVE,0) <> 1  
 AND ISNULL(FLG_DUSER,0) <> 1              
          
 --Getting Garage material percentage            
 SELECT @ID_CUST_WO1 = ID_CUST_WO                  
 FROM    TBL_WO_HEADER HDR                  
 WHERE   HDR.ID_WO_NO = @IV_ID_WO_NO                  
 AND  HDR.ID_WO_PREFIX =@IV_ID_WO_PREFIX                  
          
 EXEC USP_RP_GMPRICE_FETCH @ID_CUST_WO1, @SUBID, @DEPID,''            
          
-- Getting the Charge based on Standard Time or Clocked Time    -- Bug# 3525          
 EXEC USP_CONFIG_WORK_ORDER_FETCH @SUBID, @DEPID          
     
 select top 5 ID_WO_NO,ID_WO_PREFIX from TBL_WO_HEADER     
 where ID_VEH_SEQ_WO = @VEH_ID and     
 WO_STATUS='STR' --and ID_WO_NO <> @IV_ID_WO_NO and ID_WO_PREFIX <> @IV_ID_WO_PREFIX     
 order by DT_CREATED desc    
     
 select ID_VEH_SEQ,VEH_REG_NO,ID_MAKE_VEH,ID_MODEL_VEH,VEH_TYPE,ID_CUSTOMER_VEH,COST_PRICE,SELL_PRICE,VA_ACC_CODE     
 from TBL_MAS_VEHICLE where ID_CUSTOMER_VEH = @CUSTOMER_ID    
          
SELECT TOP 1 * from TBL_MAS_ITEM_MASTER IM    
INNER JOIN TBL_MAS_ITEM_CATG IC ON IC.ID_ITEM_CATG = IM.ID_ITEM_CATG    
where VA_ORDER_COST = 1 ORDER BY IM.DT_CREATED DESC    
    
SELECT TOP 1 * from TBL_MAS_ITEM_MASTER IM    
INNER JOIN TBL_MAS_ITEM_CATG IC ON IC.ID_ITEM_CATG = IM.ID_ITEM_CATG    
where VA_EXCHANGE_VEH = 1 ORDER BY IM.DT_CREATED DESC    
    
--655    
EXEC USP_CONFIG_SETTINGS_FETCH 'USEMECGRID'    
--654    
EXEC USP_CONFIG_SETTINGS_FETCH 'VLDSTDTIME'    
EXEC USP_CONFIG_SETTINGS_FETCH 'VLDMILEAGE'    
EXEC USP_CONFIG_SETTINGS_FETCH 'SAVEUPDDP'    
EXEC USP_CONFIG_SETTINGS_FETCH 'EDTCHGTIME'    
--762    
EXEC USP_CONFIG_SETTINGS_FETCH 'INT-NOTE'    
  
SELECT TOP 1 FIRST_NAME,LAST_NAME,ID_LOGIN ,FLG_DUSER              
 FROM TBL_MAS_USERS               
 WHERE  ISNULL(FLG_MECH_INACTIVE,0) <> 1   
 AND ISNULL(FLG_DUSER,0) =1  
  
    
END             
              
          
/*            
EXEC USP_RP_GMPRICE_FETCH '1040', 1212, 500, ''          
                    
exec usp_WO_LOAD_CONFIG '103','TS','ADMIN'                      
             
*/ 
GO

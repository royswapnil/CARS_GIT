/****** Object:  StoredProcedure [dbo].[USP_WO_VIEW]    Script Date: 12/23/2016 11:56:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_VIEW]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_VIEW]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_VIEW]    Script Date: 12/23/2016 11:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_VIEW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_VIEW] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                    
* Module : Work Order                     
* File name : USP_WO_INSERT.PRC                    
* Purpose : To Insert WORK ORDER DETAILS IN WO DETAILS                  
* Author : THIYAGARAJAN /SUBRAMANIAN                    
* Date  : 28.08.2006                    
*********************************************************************************************************************/                    
/*********************************************************************************************************************                      
I/P : -- Input Parameters                    
 @iv_xmlDoc - Valid XML document contaning values to be inserted                    
                    
O/P : -- Output Parameters                    
 @ov_RetValue - 'INSFLG' if error, 'OK' otherwise                    
 @ov_CannotDelete - List of configuration items which cannot be inserted as they already exists.                    
                    
Error Code                    
Description       INT.VerNO : NOV21.0               
********************************************************************************************************************/                    
--'*********************************************************************************'*********************************                    
--'* Modified History :                       
--'* S.No  RFC No/Bug ID   Date        Author  Description                     
--* #0001#                 04/04/2007  M.Thiyagarajan   Added Repair Package Description                    
--'*********************************************************************************'*********************************                  
ALTER PROCEDURE [dbo].[USP_WO_VIEW]                
(                
   @ID_WODET_SEQ INT                
 )                
AS                  
BEGIN                        
      
 --762      
 DECLARE @INTERNAL_NOTE VARCHAR(10)      
 SELECT @INTERNAL_NOTE = ISNULL(DESCRIPTION,'FALSE') FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='INT-NOTE'       
      
      
SELECT                        
 ID_WODET_SEQ,                
 ID_WO_NO,                
 ID_WO_PREFIX,                        
 ID_JOB,            
 --DT_PLANNED,                
 CONVERT(CHAR(10),DT_PLANNED,103) AS 'PLANNED DATE',                        
 ISNULL(ID_RPG_CATG_WO,0) AS 'ID_RPG_CATG_WO',                        
 CASE WHEN ID_RPG_CATG_WO IS NOT NULL THEN                        
  (SELECT                         
  ISNULL(DESCRIPTION,'')                           
  FROM                         
  TBL_MAS_SETTINGS                         
  WHERE                         
  ID_SETTINGS = ID_RPG_CATG_WO)                        
 ELSE ''                        
 END AS 'CATEGORY DESCRIPTION',                        
 ISNULL(ID_RPG_CODE_WO,0) AS 'ID_RPG_CODE_WO',                        
 CASE WHEN ID_RPG_CODE_WO IS NOT NULL THEN                        
  (SELECT RP_DESC                 
  FROM                 
  tbl_mas_rep_package                 
  WHERE                 
  id_rpkg_seq = ID_RPG_CODE_WO)                      
 ELSE ''                        
 END AS 'Rp_Desc',                        
 ID_REP_CODE_WO,                      
 ID_WORK_CODE_WO,                
 WO_FIXED_PRICE,                        
 ID_JOBPCD_WO,                
 WO_STD_TIME,                
 WO_PLANNED_TIME,                        
 WO_HOURLEY_PRICE,      
      
 --Bug ID:-2_4 92      
 --Date  :-01-aug-2008      
 --desc  :-WO_GM_PER,WO_GM_VATPER and WO_LBR_VATPER                           
 --      storing resp % for WO History, if later stage      
 --   this % change then WO History % should not change      
 WO_GM_PER,      
 WO_GM_VATPER,      
 WO_LBR_VATPER,      
 --change end            
      
 WO_CLK_TIME,                
 WO_CHRG_TIME,                        
 FLG_CHRG_STD_TIME,                
 FLG_STAT_REQ,                
 WO_JOB_TXT,     
 WO_OWN_RISK_AMT,            
 WO_TOT_LAB_AMT,                
 WO_TOT_SPARE_AMT,                        
 WO_TOT_GM_AMT,                
 WO_TOT_VAT_AMT,                
 WO_TOT_DISC_AMT,                        
 JOB_STATUS,              
 FLG_STAT_REQ,          
    CASE when WO_OWN_RISK_CUST is not null then           
       (select CUST_NAME from tbl_mas_customer  where ID_CUSTOMER = TBL_WO_DETAIL.WO_OWN_RISK_CUST)          
 ELSE ''          
 END AS WO_OWN_RISK_CUSTNAME,          
    CASE when WO_OWN_CR_CUST is not null then           
       (select CUST_NAME from tbl_mas_customer  where ID_CUSTOMER = TBL_WO_DETAIL.WO_OWN_CR_CUST)          
 ELSE ''          
 END AS WO_OWN_CR_CUSTNAME,          
    WO_OWN_RISK_CUST,          
    WO_OWN_CR_CUST  ,        
    JOB_STATUS,            
  --PLANNED_DATE,            
  --CONVERT(CHAR(10),PLANNED_DATE,101) AS 'PLANNED DATE',                        
 CREATED_BY,                
 CONVERT(CHAR(10),DT_CREATED,101) AS 'DATE CREATED',                        
 MODIFIED_BY,                
 CONVERT(CHAR(10),DT_MODIFIED ,101) AS 'DATE MODIFIED'  ,                    
 CASE when WO_OWN_PAY_VAT  = 1 and WO_OWN_PAY_VAT is not null then 'true'                      
 ELSE 'false'                  
 END AS WO_OWN_PAY_VAT,ISNULL(ID_MECH_COMP,0) ID_MECH_COMP,        
 ID_STYPE_WO              
--MODIFIED DATE: 04 OCT 2008      
--COMMENTS: SS2 - WO CHANGES      
 ,ISNULL(WO_INCL_VAT,0) AS WO_INCL_VAT      
 ,ISNULL(WO_DISCOUNT,0) AS WO_DISCOUNT      
 ,ISNULL(ID_SUBREP_CODE_WO,'') AS ID_SUBREP_CODE_WO      
--END OF MODIFICATION        
 ,ISNULL(OwnRiskVATAmt, 0) AS OwnRiskVATAmt      
 ,SALESMAN      
 ,ISNULL(FLG_VAT_FREE,0) as FLG_VAT_FREE,      
 ISNULL(COST_PRICE,0) AS COST_PRICE      
 ,WO_TOT_DISC_AMT_FP      
 ,WO_TOT_GM_AMT_FP      
 ,WO_TOT_LAB_AMT_FP      
 ,WO_TOT_SPARE_AMT_FP      
 ,WO_TOT_VAT_AMT_FP      
 ,ISNULL(FLG_VAL_STDTIME,0) AS FLG_VAL_STDTIME      
 ,ISNULL(FLG_VAL_MILEAGE,0) AS FLG_VAL_MILEAGE      
 ,ISNULL(FLG_SAVEUPDDP,0) AS FLG_SAVEUPDDP      
 ,ISNULL(FLG_EDTCHGTIME,0) AS FLG_EDTCHGTIME        
 ,WO_INT_NOTE      
 ,@INTERNAL_NOTE AS FLG_DISP_INT_NOTE -- FLAG on General Settings page    
 ,ISNULL(ID_MECHANIC,'') AS ID_MECHANIC     
 , WO_OWN_RISK_DESC  
 , WO_OWN_RISK_SL_NO
 FROM                        
 TBL_WO_DETAIL                         
 WHERE                         
 ID_WODET_SEQ = @ID_WODET_SEQ                        
END                        
                        
                        
                        
/*                        
 EXEC USP_WO_VIEW 35                        
 SELECT * FROM TBL_WO_DETAIL  where id_wo_no = '122'                      
select * from tbl_mas_settings where id_config = 'RP-CATG'                      
select id_rp_code from tbl_mas_rep_package where id_rpkg_seq = 92                      
select * from tbl_mas_repaircode                      
select * from TBL_WO_DETAIL where ID_WO_PREFIX='WO2'                  
select getdate(), CONVERT(CHAR(10),getdate(),101),DT_PLANNED,CONVERT(CHAR(10),DT_PLANNED,101)                   
from TBL_WO_DETAIL where ID_WO_PREFIX='WO2'               
 select * from tbl_mas_rep_package         
EXEC USP_WO_VIEW 508            
ID_STYPE_WO            
*/ 
GO

/****** Object:  StoredProcedure [dbo].[USP_IN_INVORD_SEARCH]    Script Date: 10/11/2017 5:32:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_INVORD_SEARCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_IN_INVORD_SEARCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_IN_INVORD_SEARCH]    Script Date: 10/11/2017 5:32:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_INVORD_SEARCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_IN_INVORD_SEARCH] AS' 
END
GO
  
    
        
        
/*************************************** Application: MSG *************************************************************        
* Module : CONFIG        
* File name : USP_IN_INVORD_SEARCH.PRC        
* Purpose : Search already generated Invoices        
* Author : Rajput Yogendrasinh H        
* Date  : 30.08.2006        
*********************************************************************************************************************/        
/*********************************************************************************************************************          
I/P : -- Input Parameters        
 @iv_xmlDoc - Valid XML document contaning values to be inserted        
        
O/P : -- Output Parameters        
 @ov_RetValue - 'INSFLG' if error, 'OK' otherwise        
 @ov_CannotDelete - List of configuration items which cannot be inserted as they already exists.        
        
Error Code        
Description     
NT.VerNO : NOV21.0       
********************************************************************************************************************/        
--'*********************************************************************************'*********************************        
--'* Modified History :           
--'* S.No  RFC No/Bug ID   Date        Author  Description         
--* #0001#        
--'*********************************************************************************'*********************************        
        
ALTER PROC [dbo].[USP_IN_INVORD_SEARCH]        
 (        
   @iv_ID_INV_NO      varchar(10),        
   @FLG_CREDIT bit        
 )        
AS        
BEGIN        
        
 SELECT distinct woh.ID_WO_NO        
   , woh.DT_ORDER        
   , woh.ID_WO_PREFIX        
   ,dbo.fnInvCountOrderJob(wod.ID_WO_NO,wod.ID_WO_PREFIX,ind.ID_INV_NO) as NO_OF_JOBS --Write a function to calc number of jobs        
   , woh.ID_VEH_SEQ_WO        
   , dbo.fnInvOrderAmt(wod.ID_WO_NO,wod.ID_WO_PREFIX,ind.ID_INV_NO,wod.id_job) as TOT_ORD_AMT --Write a function to calc total amt for order  
  ---Bug ID:4280 Fixing START, Date: 07-NOV-2008  
   ,FLG_DPT_WAREHOUSE  
     ---Bug ID:4280 Fixing END  
    ,isnull(woh.FLG_KRE_ORD,0) As FLG_KRE_ORD
  FROM TBL_INV_HEADER inh INNER JOIN TBL_INV_DETAIL ind         
   ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod        
   ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh        
   ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX  
   ---Bug ID:4280 Fixing START, 07-NOV-2008  
   INNER JOIN TBL_MAS_DEPT DEPT ON inh.ID_DEPT_INV = DEPT.ID_DEPT  
   ---Bug ID:4280 Fixing END     
  WHERE  
    (inh.ID_INV_NO=@iv_ID_INV_NO and @FLG_CREDIT ='true')        
   OR (inh.ID_CN_NO=@iv_ID_INV_NO and @FLG_CREDIT ='false')        
        
        
--END        
--IF @FLG_CREDIT ='true'        
--BEGIN        
-- SELECT distinct woh.ID_WO_NO        
--   , woh.DT_ORDER        
--   , woh.ID_WO_PREFIX        
--   ,dbo.fnInvCountOrderJob(wod.ID_WO_NO,wod.ID_WO_PREFIX,ind.ID_INV_NO) as NO_OF_JOBS --Write a function to calc number of jobs        
--   , woh.ID_VEH_SEQ_WO        
--   , '0' as TOT_ORD_AMT --Write a function to calc total amt for order        
--  FROM TBL_INV_HEADER inh INNER JOIN TBL_INV_DETAIL ind         
--   ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod        
--   ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh        
--   ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX        
--  WHERE        
--   inh.ID_CN_NO=@iv_ID_INV_NO        
--          
--print 'CN'        
--        
--END        
END        
        
        
/**        
        
select * from TBL_INV_DETAIL        
        
EXEC USP_IN_INVORD_SEARCH 'INV001',0        
EXEC USP_IN_INVORD_SEARCH '1',1        
        
**/        
GO

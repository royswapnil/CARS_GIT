/****** Object:  StoredProcedure [dbo].[USP_IN_INV_SEARCH]    Script Date: 10/11/2017 5:44:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_INV_SEARCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_IN_INV_SEARCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_IN_INV_SEARCH]    Script Date: 10/11/2017 5:44:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_INV_SEARCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_IN_INV_SEARCH] AS' 
END
GO
--exec USP_IN_INV_SEARCH @iv_xmlDoc=N'<root><INV ID_INV_NO="21I 301963"/></root>',        
--@iv_DT_INVOICE_FROM=NULL,@iv_DT_INVOICE_TO=NULL,@iv_INV_AMT_FROM=NULL,@iv_INV_AMT_TO=NULL,        
--@iv_ID_CUSTOMER=NULL,@iv_ID_DEBITOR=NULL,@iv_ID_VEH_SEQ=0,@iv_ID_WO_NO=NULL,@iv_INV_STATUS=1,        
--@FLG_BATCH_INV=0,@iv_UserID='admin'        
        
        
/*        
            
exec USP_IN_INV_SEARCH         
@iv_xmlDoc=N'',@iv_DT_INVOICE_FROM='01/01/07',@iv_DT_INVOICE_TO='04/01/09',@iv_INV_AMT_FROM=NULL,        
@iv_INV_AMT_TO=NULL,@iv_ID_CUSTOMER=NULL,@iv_ID_DEBITOR=NULL,@iv_ID_VEH_SEQ=0,@iv_ID_WO_NO=NULL,        
@iv_INV_STATUS=1,@FLG_BATCH_INV=0,@iv_UserID='zenuser'        
        
exec USP_IN_INV_SEARCH         
@iv_xmlDoc=N'INV101',@iv_DT_INVOICE_FROM=NULL,@iv_DT_INVOICE_TO=NULL,@iv_INV_AMT_FROM=NULL,        
@iv_INV_AMT_TO=NULL,@iv_ID_CUSTOMER=NULL,@iv_ID_DEBITOR=NULL,@iv_ID_VEH_SEQ=0,@iv_ID_WO_NO=NULL,        
@iv_INV_STATUS=1,@FLG_BATCH_INV=0,@iv_UserID='LOGIN'        
        
exec USP_IN_INV_SEARCH         
@iv_xmlDoc=N'INV101',@iv_DT_INVOICE_FROM='01/01/09',@iv_DT_INVOICE_TO='04/01/09',@iv_INV_AMT_FROM=NULL,        
@iv_INV_AMT_TO=NULL,@iv_ID_CUSTOMER=NULL,@iv_ID_DEBITOR=NULL,@iv_ID_VEH_SEQ=0,@iv_ID_WO_NO=NULL,        
@iv_INV_STATUS=1,@FLG_BATCH_INV=0,@iv_UserID='LOGIN'        
            
*/              
                
                
/*************************************** Application: MSG *************************************************************                
* Module : CONFIG                
* File name : USP_IN_INV_SEARCH.PRC                
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
********************************************************************************************************************/                
--'*********************************************************************************'*********************************                
--'* Modified History :                   
--'* S.No  RFC No/Bug ID   Date        Author Description              
--*#0001# --     23-03-2007  Rajput Y H Changed Condition from 'OR' to 'AND' for search cirteria                                        
--* NT.VerNO : NOV21.0            
              
--'*********************************************************************************'*********************************                
                
ALTER PROCEDURE [dbo].[USP_IN_INV_SEARCH]                    
(                    
  @iv_xmlDoc varchar(7000), --Invoice List                    
  @iv_DT_INVOICE_FROM datetime,                    
  @iv_DT_INVOICE_TO datetime,                    
  @iv_INV_AMT_FROM decimal(15,2),                    
  @iv_INV_AMT_TO decimal(15,2),                    
  @iv_ID_CUSTOMER varchar(10),                    
  @iv_ID_DEBITOR varchar(10),                    
  @iv_ID_VEH_SEQ int,                    
  @iv_ID_WO_NO varchar(13),                    
  @iv_INV_STATUS int, -- 1=Active 2=Cancelled 3=Both                    
  @FLG_BATCH_INV bit,                
  @iv_UserID varchar(20),        
  @IV_Lang VARCHAR(30)='ENGLISH' ,      
  @Cr_Orders int                
)                    
AS        
BEGIN                    
--DECLARE @docHandle int                     
--EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_xmlDoc                    
                
SET NOCOUNT ON        
        
BEGIN TRY        
        
DECLARE @DEP INT     
DECLARE @SUB INT                
SELECT @DEP=ID_Dept_User ,@SUB=ID_Subsidery_User FROM TBL_MAS_USERS WHERE ID_Login=@iv_UserID ;               
              
  DECLARE @LANG INT          
  SELECT @LANG=ID_LANG FROM TBL_MAS_LANGUAGE WHERE LANG_NAME=@iv_Lang        
  DECLARE @TRUE AS VARCHAR(20)        
  SELECT @TRUE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_TRUE' AND ISDATA=1        
        
  DECLARE @FALSE AS VARCHAR(20)        
  SELECT @FALSE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_FALSE' AND ISDATA=1        
          
  DECLARE @ORDER AS VARCHAR(10)        
  SELECT @ORDER=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_ORDER' AND ISDATA=1      
      
  DECLARE @CREORDER AS VARCHAR(10)    
  SELECT @CREORDER=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_CREORDER' AND ISDATA=1       
          
  DECLARE @CRSL AS VARCHAR(10)        
  SELECT @CRSL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_CRSL' AND ISDATA=1        
        
IF @iv_xmlDoc=''        
 SET @iv_xmlDoc=NULL;        
        
--MODIFIED BY: ASHOK S        
--DATE: 07 APR 09        
--COMMENTS: INSTEAD OF CALLING VIEW TO GET THE RESULT, SQL STATEMENT IS WRITTEN AT THE PROCEDURE LEVEL TO         
--   OPTIMIZE THE PERFORMANCE        
        
IF @iv_DT_INVOICE_FROM IS NULL AND @iv_DT_INVOICE_TO IS NULL         
BEGIN        
 SELECT @iv_DT_INVOICE_FROM = MIN(DT_INVOICE) FROM TBL_INV_HEADER        
 SELECT @iv_DT_INVOICE_TO = MAX(DT_INVOICE) FROM TBL_INV_HEADER        
END        
        
--SELECT @iv_DT_INVOICE_FROM,@iv_DT_INVOICE_TO        
        
 SELECT        
  *        
 INTO        
  #INVOICEFINALTOTAL_CTE          
 FROM        
 (        
  SELECT         
   IH.ID_INV_NO        
   ,IH.DT_INVOICE        
   ,IH.ID_CN_NO        
   ,IH.INV_TOT        
   ,isnull(IH.ID_PARENT_INV_NO,IH.ID_INV_NO)as ID_PARENT_INV_NO        
  FROM                 
   DBO.TBL_INV_HEADER AS IH         
  WHERE         
   (IH.DT_INVOICE BETWEEN @iv_DT_INVOICE_FROM AND @iv_DT_INVOICE_TO        
   OR         
   (IH.ID_INV_NO = @iv_xmlDoc OR IH.ID_CN_NO = @iv_xmlDoc))        
 )MST        
        
--END OF MODIFICATION        
        
--select * from #INVOICEFINALTOTAL_CTE          
        
select id_inv_no,        
--cast(dbo.FnGetInvoiceAmount(id_inv_no) as decimal(15,2))         
 ISNULL(INV_TOT,0)        
 as FinalAmount,        
DT_INVOICE,        
isnull(ID_PARENT_INV_NO,id_inv_no)as ID_PARENT_INV_NO        
 into #temp from #INVOICEFINALTOTAL_CTE AS ViewTotal  where        
   (@iv_xmlDoc IS NULL OR ViewTotal.ID_INV_NO = @iv_xmlDoc OR ViewTotal.ID_CN_NO = @iv_xmlDoc)         
        
 AND                   
     (ViewTotal.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
      or ViewTotal.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
          or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))         
group by id_inv_no,ViewTotal.DT_INVOICE,INV_TOT,ID_PARENT_INV_NO        
        
--select ViewTotal.id_inv_no id_inv_no,        
--AMT.INV_AMT        
----cast(dbo.FnGetInvoiceAmount(id_inv_no) as decimal(15,2))         
-- as FinalAmount,        
--DT_INVOICE into #temp from #INVOICEFINALTOTAL_CTE AS ViewTotal          
--INNER JOIN TBL_INV_AMT AMT ON AMT.ID_INV_NO=ViewTotal.id_inv_no        
--where        
--   (@iv_xmlDoc IS NULL OR ViewTotal.ID_INV_NO = @iv_xmlDoc OR ViewTotal.ID_CN_NO = @iv_xmlDoc)         
        
-- AND                   
--     (ViewTotal.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
--      or ViewTotal.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
--          or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))         
--group by ViewTotal.id_inv_no,ViewTotal.DT_INVOICE,AMT.INV_AMT   
        
--select * from #temp         
        
        
/*------Removed----not necessary-------*/        
/*        
update #temp set #TEMP.FINALAMOUNT=                   
case when #TEMP.FINALAMOUNT > 0 then                   
(select                  
case when INV_PRICE_RND_FN= 'Flr' and INV_RND_DECIMAL > 0 then                   
floor(#TEMP.FINALAMOUNT/INV_RND_DECIMAL )*INV_RND_DECIMAL                  
when INV_PRICE_RND_FN= 'Rnd' and INV_RND_DECIMAL > 0 then                  
 floor(#TEMP.FINALAMOUNT/INV_RND_DECIMAL + (1 - (INV_PRICE_RND_VAL_PER/ 100 )) )*INV_RND_DECIMAL                  
when INV_PRICE_RND_FN= 'Clg' and INV_RND_DECIMAL > 0 then                  
 Ceiling(#TEMP.FINALAMOUNT/INV_RND_DECIMAL)*INV_RND_DECIMAL                  
else #TEMP.FINALAMOUNT                   
end                  
 from                   
TBL_MAS_INV_CONFIGURATION where DT_EFF_TO is null and ID_DEPT_INV = tbl_inv_header.ID_Dept_Inv                  
and ID_SUBSIDERY_INV = tbl_inv_header.ID_Subsidery_Inv )else 0                  
end             
FROM #INVOICEFINALTOTAL_CTE,tbl_inv_header             
where #TEMP.FINALAMOUNT > 0 and                   
tbl_inv_header.ID_INV_NO COLLATE DATABASE_DEFAULT IN (SELECT #TEMP.ID_INV_NO COLLATE DATABASE_DEFAULT FROM #TEMP)        
--MODIFIED TO HANDLE ROUNDING - 1ST September 2010        
--AND tbl_inv_header.CREATED_BY=@iv_UserID        
AND (select ID_Dept_User from tbl_mas_users where id_login = tbl_inv_header.CREATED_BY) = (select ID_Dept_User from tbl_mas_users where id_login = @iv_UserID)        
--END MODIFICATION        
        
--select * from #temp              
*/        
/*------Removed----not necessary-------*/        
--MODIFIED BY: ASHOK S        
--DATE: 07 APR 09        
--COMMENTS: INSTEAD OF CALLING VIEW TO GET THE RESULT, SQL STATEMENT IS WRITTEN AT THE PROCEDURE LEVEL TO         
--   OPTIMIZE THE PERFORMANCE        
DROP TABLE #INVOICEFINALTOTAL_CTE        
--END OF MODIFICATION        
         
DECLARE @ID_INV_NO_VAR VARCHAR(50)      
if @Cr_Orders = 1      
BEGIN      
                
 if @iv_INV_STATUS = 1              
 begin              
 SELECT distinct inh.ID_INV_NO                    
  , inh.DT_INVOICE                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO                    
 /*            
 '-----------------------------------------------            
 'Modified Date : 09-June-08            
 'Description    : To display name from TBL_INV_HEADER            
 'bug No         : 2458            
 '-------------------------------------------------            
 */            
  --, cus.CUST_NAME            
    ,            
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN                 
  CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
  ELSE        
   cus.CUST_NAME         
  END         
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME,               
 -- End if 2458            
   #TEMP.FinalAmount  as INV_AMT         
                    
   , CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV                    
  , inh.ID_CN_NO                    
  , cast('1' as bit) as FLG_INV         
  ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER    
   WHEN woh.WO_TYPE_WOH  = 'KRE' THEN @CREORDER    
   ELSE @CRSL     
   END AS WO_TYPE_WOH          
  , woh.WO_TYPE_WOH AS WO_TYPE        
  ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO ) as ID_PARENT_INV_NO  
  ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
 FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX             
  INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default        
 WHERE                    
   (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc  OR inh.ID_CN_NO = @iv_xmlDoc)                   
  AND                   
  (                 
    (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
    or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
     or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
    AND    -- See #0001#      
   (#TEMP.FINALAMOUNT between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
     or #TEMP.FINALAMOUNT between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
     or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))                    
    AND    -- See #0001#                
    (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
    AND    -- See #0001#                
    (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
    AND    -- See #0001#                
    (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
    AND    -- See #0001#                
    (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )              
    AND    -- See #0001#                
    (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                  
  )                     
  AND                    
  ( (inh.ID_CN_NO is null and @iv_INV_STATUS=1)                    
 --  OR                    
 --  (inh.ID_CN_NO is not null and @iv_INV_STATUS=2)                    
 --  OR                    
 --  (@iv_INV_STATUS=3)                    
 --  OR                    
 -- (@iv_INV_STATUS is null)                    
  )                
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB               
  /*8th July 2010 - Added to display latest records first*/        
 ORDER BY DT_INVOICE DESC , ID_INV_NO DESC        
 /*Change End*/             
 end         
             
 else if @iv_INV_STATUS = 2         
   begin              
   SELECT distinct inh.ID_INV_NO                    
  , inh.DT_INVOICE                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO         
                       
  /*            
 '-----------------------------------------------            
 'Modified Date : 09-June-08            
 'Description    : To display name from TBL_INV_HEADER            
 'bug No         : 2458            
 '-------------------------------------------------            
 */            
  --, cus.CUST_NAME                
    ,         
               
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN                 
    CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
           
  ELSE        
   cus.CUST_NAME         
  END        
          
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME             
 -- End if 2458            
  , #TEMP.FinalAmount    *(-1)          
    as INV_AMT                  
  , CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV                     
  , inh.ID_CN_NO                    
  , cast('0' as bit) as FLG_INV          
    ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER     
       WHEN woh.WO_TYPE_WOH  = 'KRE' THEN @CREORDER    
    ELSE @CRSL END AS WO_TYPE_WOH         
    , woh.WO_TYPE_WOH AS WO_TYPE            
   ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO )  as ID_PARENT_INV_NO    
     ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord                 
 FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX           
  INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default                
 WHERE                    
  (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc OR inh.ID_CN_NO = @iv_xmlDoc)                  
  AND                   
  (                 
    (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
     or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
     or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
    AND    -- See #0001#             
 --Bug ID:-3311          
 --Date  :-13-Aug-2008          
 --Desc  :-Depends on [-] and [+]          
 -- (INV_AMT between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
 --          or INV_AMT between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
 --          or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))               
    (#TEMP.FinalAmount  *(-1) between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
     or #TEMP.FinalAmount   *(-1) between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
     or (@iv_INV_AMT_FROM *(-1) is null and @iv_INV_AMT_TO *(-1) is null))                    
 --change end          
    AND    -- See #0001#                
    (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
    AND    -- See #0001#                
    (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
    AND    -- See #0001#                
    (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
    AND    -- See #0001#                
    (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
    AND    -- See #0001#                
    (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                  
  )                     
  AND                    
  ( (inh.ID_CN_NO is not null and @iv_INV_STATUS=2)                    
 --  OR                    
 --  (inh.ID_CN_NO is not null and @iv_INV_STATUS=2)                    
 --  OR                    
 --  (@iv_INV_STATUS=3)                    
 --  OR                    
 -- (@iv_INV_STATUS is null)                    
  )                
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB               
  /*8th July 2010 - Added to display latest records first*/        
 ORDER BY DT_INVOICE DESC ,ID_INV_NO DESC        
 /*Change End*/             
 end              
               
 else if @iv_INV_STATUS = 3              
 begin              
    SELECT distinct inh.ID_INV_NO                    
  , inh.DT_INVOICE                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO                    
 /*            
 '-----------------------------------------------            
 'Modified Date : 09-June-08            
 'Description    : To display name from TBL_INV_HEADER            
 'bug No         : 2458            
 '-------------------------------------------------            
 */          
  --, cus.CUST_NAME                
    ,            
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN                 
  CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
  ELSE        
   cus.CUST_NAME         
  END         
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME             
 -- End if 2458            
           
 --Bug ID:-3311          
 --Date  :-13-Aug-2008          
 --Desc  :-Depends on [-] and [+]          
  ,(CASE WHEN inh.ID_CN_NO IS NULL THEN #TEMP.FinalAmount                      
    WHEN inh.ID_CN_NO IS NOT NULL THEN #TEMP.FinalAmount   * (-1) END) as INV_AMT          
 --change end          
  , CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV                      
  , inh.ID_CN_NO                    
  , cast('1' as bit) as FLG_INV           
    ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER     
       WHEN woh.WO_TYPE_WOH  = 'KRE' THEN @CREORDER    
     ELSE @CRSL     
     END AS WO_TYPE_WOH           
    , woh.WO_TYPE_WOH AS WO_TYPE                  
     ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO ) as ID_PARENT_INV_NO   
       ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
    FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX           
  INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default          
    WHERE                    
  (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc  OR inh.ID_CN_NO = @iv_xmlDoc)              
  AND                   
  (                 
    (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
     or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
     or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
    AND    -- See #0001#              
 --Bug ID:-3311          
 --Date  :-13-Aug-2008          
 --Desc  :-Depends on [-] and [+]          
 -- (INV_AMT between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
 --          or INV_AMT between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
 --          or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))              
    ((CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
     or (CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
     or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))                    
 --change end          
    AND    -- See #0001#                
    (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
    AND    -- See #0001#                
    (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
    AND    -- See #0001#                
    (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
    AND    -- See #0001#                
    (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
    AND    -- See #0001#                
    (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                  
  )                     
  AND                    
  ( (inh.ID_CN_NO is null and @iv_INV_STATUS=3)                    
                   
  )                
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB                
 union  all                    
    SELECT distinct  inh.ID_INV_NO                       
  , inh.DT_MODIFIED                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO                    
               
    ,            
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN         
  CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
  ELSE        
   cus.CUST_NAME         
  END        
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME             
        
  , (CASE WHEN inh.ID_CN_NO IS NULL THEN #TEMP.FinalAmount                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN #TEMP.FinalAmount   * (-1) END )           
    as INV_AMT                
          
  ,CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV               
  , inh.ID_CN_NO as ID_CN_NO                    
  , cast('0' as bit) as FLG_INV         
   ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH          
   , woh.WO_TYPE_WOH AS WO_TYPE                  
    ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO ) as ID_PARENT_INV_NO  
      ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
    FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX          
    INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default                 
    WHERE                 
   (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc OR inh.ID_CN_NO = @iv_xmlDoc)                 
  AND                    
  (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
   or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
   or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
  AND                 
         
  ((CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
   or (CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
   or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))                    
           
  AND                    
  (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
  AND                    
  (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
  AND                    
  (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
  AND                    
  (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
  AND                    
  (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                    
  AND                    
  (                
   (inh.ID_CN_NO is not null and @iv_INV_STATUS=3)                    
              
  )                    
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB                   
      
  ORDER BY DT_INVOICE DESC , ID_INV_NO DESC        
      
 end           
      
END      
ELSE IF @Cr_Orders = 2      
 BEGIN      
   if @iv_INV_STATUS = 1              
 begin              
 SELECT distinct inh.ID_INV_NO                    
  , inh.DT_INVOICE                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO ,          
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN                 
  CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
  ELSE        
   cus.CUST_NAME         
  END         
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME,               
 -- End if 2458            
   #TEMP.FinalAmount  as INV_AMT         
                    
   , CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV                    
  , inh.ID_CN_NO                    
  , cast('1' as bit) as FLG_INV         
  ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH          
  , woh.WO_TYPE_WOH AS WO_TYPE        
  ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO ) as ID_PARENT_INV_NO  
    ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
 FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX             
  INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default        
 WHERE                    
   (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc  OR inh.ID_CN_NO = @iv_xmlDoc)                   
  AND                   
  (                 
    (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
    or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
     or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
    AND    -- See #0001#                
   (#TEMP.FINALAMOUNT between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
     or #TEMP.FINALAMOUNT between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
     or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))                    
    AND    -- See #0001#                
    (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
    AND    -- See #0001#                
    (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
    AND    -- See #0001#                
    (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
    AND    -- See #0001#                
    (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
    AND    -- See #0001#                
    (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                  
  )                     
  AND                    
  ( (inh.ID_CN_NO is null and @iv_INV_STATUS=1)                    
 --  OR                    
 --  (inh.ID_CN_NO is not null and @iv_INV_STATUS=2)                    
 --  OR                    
 --  (@iv_INV_STATUS=3)                    
 --  OR                    
 -- (@iv_INV_STATUS is null)                    
  )                
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB      
  AND WOH.WO_TYPE_WOH <> 'KRE'               
  /*8th July 2010 - Added to display latest records first*/        
 ORDER BY DT_INVOICE DESC , ID_INV_NO DESC        
 /*Change End*/             
 end         
             
 else if @iv_INV_STATUS = 2         
   begin              
   SELECT distinct inh.ID_INV_NO                    
  , inh.DT_INVOICE                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO         
                       
  /*            
 '-----------------------------------------------            
 'Modified Date : 09-June-08            
 'Description    : To display name from TBL_INV_HEADER            
 'bug No         : 2458            
 '-------------------------------------------------            
 */            
  --, cus.CUST_NAME                
    ,         
               
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN                 
    CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
           
  ELSE        
   cus.CUST_NAME         
  END        
          
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME             
 -- End if 2458            
  , #TEMP.FinalAmount    *(-1)          
    as INV_AMT                  
  , CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV                     
  , inh.ID_CN_NO                    
  , cast('0' as bit) as FLG_INV          
    ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH         
    , woh.WO_TYPE_WOH AS WO_TYPE            
   ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO )  as ID_PARENT_INV_NO  
     ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
 FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX           
  INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default                
 WHERE                    
  (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc OR inh.ID_CN_NO = @iv_xmlDoc)                  
  AND                   
  (                 
    (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
     or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
     or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
    AND    -- See #0001#             
 --Bug ID:-3311          
 --Date  :-13-Aug-2008          
 --Desc  :-Depends on [-] and [+]          
 -- (INV_AMT between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
 --          or INV_AMT between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
 --          or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))               
    (#TEMP.FinalAmount  *(-1) between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
     or #TEMP.FinalAmount   *(-1) between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
     or (@iv_INV_AMT_FROM *(-1) is null and @iv_INV_AMT_TO *(-1) is null))                    
 --change end          
    AND    -- See #0001#                
    (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
    AND    -- See #0001#                
    (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
    AND    -- See #0001#                
    (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
    AND    -- See #0001#                
    (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
    AND    -- See #0001#                
    (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                  
  )                     
  AND                    
  ( (inh.ID_CN_NO is not null and @iv_INV_STATUS=2)                    
 --  OR                    
 --  (inh.ID_CN_NO is not null and @iv_INV_STATUS=2)                    
 --  OR                    
 --  (@iv_INV_STATUS=3)                    
 --  OR                    
 -- (@iv_INV_STATUS is null)                    
  )                
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB      
  AND WOH.WO_TYPE_WOH <> 'KRE'               
               
  /*8th July 2010 - Added to display latest records first*/        
 ORDER BY DT_INVOICE DESC ,ID_INV_NO DESC        
 /*Change End*/             
 end              
               
 else if @iv_INV_STATUS = 3              
 begin              
    SELECT distinct inh.ID_INV_NO                    
  , inh.DT_INVOICE                    
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
   end as VEH_REG_NO                    
 /*            
 '-----------------------------------------------            
 'Modified Date : 09-June-08            
 'Description    : To display name from TBL_INV_HEADER            
 'bug No         : 2458            
 '-------------------------------------------------            
 */          
  --, cus.CUST_NAME                
    ,            
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN                 
  CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
  ELSE        
cus.CUST_NAME         
  END         
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME             
 -- End if 2458            
           
 --Bug ID:-3311          
 --Date  :-13-Aug-2008          
 --Desc  :-Depends on [-] and [+]          
  ,(CASE WHEN inh.ID_CN_NO IS NULL THEN #TEMP.FinalAmount                      
    WHEN inh.ID_CN_NO IS NOT NULL THEN #TEMP.FinalAmount   * (-1) END) as INV_AMT          
 --change end          
  , CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV                      
  , inh.ID_CN_NO                    
  , cast('1' as bit) as FLG_INV           
    ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH           
    , woh.WO_TYPE_WOH AS WO_TYPE                  
     ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO ) as ID_PARENT_INV_NO  
       ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
    FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX           
  INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default                
    WHERE                    
  (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc  OR inh.ID_CN_NO = @iv_xmlDoc)              
  AND                   
  (                 
    (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
     or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
     or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
    AND    -- See #0001#              
 --Bug ID:-3311          
 --Date  :-13-Aug-2008          
 --Desc  :-Depends on [-] and [+]          
 -- (INV_AMT between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
 --          or INV_AMT between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
 --          or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))              
    ((CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
     or (CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
     or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))                    
 --change end          
    AND    -- See #0001#                
    (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
    AND    -- See #0001#                
    (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
    AND    -- See #0001#                
    (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
    AND    -- See #0001#                
    (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
    AND    -- See #0001#                
    (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                  
  )                     
  AND                    
  ( (inh.ID_CN_NO is null and @iv_INV_STATUS=3)                    
                   
  )                
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB       
   AND WOH.WO_TYPE_WOH <> 'KRE'               
              
 union  all                    
    SELECT distinct  inh.ID_INV_NO                       
  , inh.DT_MODIFIED                 
  , case when inh.FLG_BATCH_INV='1' then                    
   ''                    
    else ind.VEH_REG_NO                    
    end as VEH_REG_NO                    
               
    ,            
    CASE WHEN inh.DEBITOR_TYPE = 'C' THEN         
  CASE WHEN inh.DEBITOR_TYPE = cus.CUST_NAME THEN        
   inh.CUST_NAME         
  ELSE        
   cus.CUST_NAME         
  END        
    ELSE            
   cus.CUST_NAME            
    END            
  as CUST_NAME             
        
  , (CASE WHEN inh.ID_CN_NO IS NULL THEN #TEMP.FinalAmount                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN #TEMP.FinalAmount   * (-1) END )           
    as INV_AMT                
          
  ,CASE WHEN  inh.FLG_BATCH_INV =1 THEN @TRUE ELSE @FALSE END AS FLG_BATCH_INV               
  , inh.ID_CN_NO as ID_CN_NO                    
  , cast('0' as bit) as FLG_INV         
   ,CASE WHEN woh.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH          
   , woh.WO_TYPE_WOH AS WO_TYPE                  
    ,isnull(inh.ID_PARENT_INV_NO,inh.ID_INV_NO ) as ID_PARENT_INV_NO   
      ,isnull(inh.Flg_Kre_Ord,0) As Flg_Kre_Ord          
    FROM TBL_INV_HEADER inh INNER JOIN TBL_MAS_CUSTOMER cus                    
  ON inh.ID_DEBITOR=cus.ID_CUSTOMER INNER JOIN TBL_INV_DETAIL ind                    
  ON inh.ID_INV_NO=ind.ID_INV_NO INNER JOIN TBL_WO_DETAIL wod                    
  ON ind.ID_WODET_INV=wod.ID_WODET_SEQ INNER JOIN TBL_WO_HEADER woh                    
  ON wod.ID_WO_NO=woh.ID_WO_NO and wod.ID_WO_PREFIX=woh.ID_WO_PREFIX          
    INNER JOIN #TEMP ON #TEMP.ID_INV_NO COLLATE database_default=inh.ID_INV_NO COLLATE database_default                 
    WHERE                 
   (@iv_xmlDoc IS NULL OR inh.ID_INV_NO = @iv_xmlDoc OR inh.ID_CN_NO = @iv_xmlDoc)                 
  AND                    
  (inh.DT_INVOICE between @iv_DT_INVOICE_FROM and @iv_DT_INVOICE_TO                     
   or inh.DT_INVOICE between @iv_DT_INVOICE_TO and @iv_DT_INVOICE_FROM                    
   or (@iv_DT_INVOICE_TO is null and @iv_DT_INVOICE_FROM is null))                    
  AND                 
         
  ((CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_FROM and @iv_INV_AMT_TO                     
   or (CASE WHEN inh.ID_CN_NO IS NULL THEN inh.INV_AMT                    
    WHEN inh.ID_CN_NO IS NOT NULL THEN inh.INV_AMT * (-1) END) between @iv_INV_AMT_TO and @iv_INV_AMT_FROM                    
   or (@iv_INV_AMT_FROM is null and @iv_INV_AMT_TO is null))                    
           
  AND                    
  (ID_DEBITOR=@iv_ID_DEBITOR or @iv_ID_DEBITOR is null)                    
  AND                    
  (woh.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                    
  AND                    
  (woh.ID_VEH_SEQ_WO=@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)                    
  AND                    
  (woh.ID_WO_PREFIX + woh.ID_WO_NO=@iv_ID_WO_NO or @iv_ID_WO_NO is null )                    
  AND                    
  (inh.FLG_BATCH_INV=@FLG_BATCH_INV or @FLG_BATCH_INV is null or @FLG_BATCH_INV=0)                    
  AND                    
  (                
   (inh.ID_CN_NO is not null and @iv_INV_STATUS=3)                    
              
  )                    
  AND inh.ID_Dept_Inv=@DEP                
  AND inh.ID_Subsidery_Inv=@SUB      
      AND WOH.WO_TYPE_WOH <> 'KRE'               
                   
      
  ORDER BY DT_INVOICE DESC , ID_INV_NO DESC        
      
 end           
 END        
DROP TABLE #TEMP        
        
       
END TRY        
 BEGIN CATCH        
  EXECUTE usp_GetErrorInfo;        
END CATCH;             
END 


GO

/****** Object:  StoredProcedure [dbo].[USP_WO_GET_SPARE]    Script Date: 8/7/2017 1:22:25 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_GET_SPARE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_GET_SPARE]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_GET_SPARE]    Script Date: 8/7/2017 1:22:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_GET_SPARE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_GET_SPARE] AS' 
END
GO
  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
ALTER PROCEDURE  [dbo].[USP_WO_GET_SPARE]           
 @iv_ItemDesc AS varchar(100),          
 @IV_ID_CUST  VARCHAR(10) ,              
 @IV_ID_VEH  VARCHAR(10) ,              
 @IV_USERID  VARCHAR(20)       
AS            
BEGIN           
  
-- '1624100','18013','8610','pv45'  
  
      
DECLARE @WAREHOUSEID INT   
DECLARE @DEPTID INT   
DECLARE @SUBID INT   
DECLARE @USE_ALL_SPARE_SRCH VARCHAR(10)      
   
       
       
SELECT @WAREHOUSEID=ID_WAREHOUSE , @DEPTID= ID_DEPARTMENT,@SUBID = ID_Subsidery_User  FROM TBL_MAS_USERS         
INNER JOIN TBL_SPR_DEPT_WH ON ID_DEPARTMENT =ID_DEPT_USER AND FLG_DEFAULT=1 WHERE ID_LOGIN = @IV_USERID    
  
  
SELECT @USE_ALL_SPARE_SRCH = USE_ALL_SPARE_SEARCH FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = @DEPTID AND ID_SUBSIDERY_WO = @SUBID      
--SELECT @USE_ALL_SPARE_SRCH  
--ADDED END   
  Declare @SQL  Nvarchar(MAX)    
  Declare @SQL1  varchar(7000)   
  Declare @SQL2  varchar(7000)   
  Declare @SQL3  varchar(7000)  
  Declare @SQL4  varchar(7000)  
  Declare @SQL5  varchar(7000)   
   set @SQL  = ''                
                  
 -- set @sql = 'select WO_NUMBER from Vw_WorkOrder_Header where  WO_NUMBER LIKE ''' + @IV_WOINFOTXT + '%'''                
                  
  set @sql = 'Select'                
  set @sql = @sql + ' ID_ITEM,'        
          
  set @sql = @sql + 'CASE WHEN ID_ITEM IS NOT NULL THEN      
(SELECT TOP 1 ID_REPLACEMENT FROM TBL_SPR_REPLACEMENT REP      
WHERE REP.ID_LOCALSPAREPART=ID_ITEM AND      
REP.ID_MAKE_LOCAL=ITEM.ID_MAKE      
) ELSE '''' END AS ID_REPLACE,'        
  --change end      
  set @sql = @sql + ' ITEM_DESC,'                
  set @sql = @sql + ' ID_UNIT_ITEM,'                
  set @sql = @sql + ' ID_ITEM_CATG,'                
  set @sql = @sql + ' ITEM.ID_MAKE,'                
  set @sql = @sql + ' CASE WHEN ID_ITEM_CATG IS NOT NULL THEN'                
  set @sql = @sql + '     (SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  '                
  set @sql = @sql + '   WHERE CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)'                
  set @sql = @sql + ' ELSE '''''                
  set @sql = @sql + '  END AS CAT_DESC,'                
  set @sql = @sql + ' CASE WHEN ITEM.ID_MAKE IS NOT NULL THEN'                
  set @sql = @sql + '  (SELECT ISNULL(ID_MAKE + ''   -   '' + ID_MAKE_NAME,'''') FROM TBL_MAS_MAKE MAKE'                
  set @sql = @sql + '   WHERE MAKE.ID_MAKE = ITEM.ID_MAKE)'                
  set @sql = @sql + ' ELSE '''''                
  set @sql = @sql + '  END AS MAKE,'                
  set @sql = @sql + ' ITEM_AVAIL_QTY   , '                
  set @sql = @sql + ' ITEM_REORDER_LEVEL, '     
    
        
  --Desc :- FLG_ALLOW_BCKORD is required, to check whether BACKORDER SHOULD CREATE OR NOT      
  set @sql = @sql + ' FLG_ALLOW_BCKORD, '   
   
      
--CHANGE END    
            
--------ZSL Changes related to TBl_MAS_ITEM_MASTER Composite Key 12-Dec-07---------        
/*     
  set @sql = @sql + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM),'';'') where idx=0),'             
  set @sql = @sql + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM),'';'') where idx=1),'                      
  set @sql = @sql + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=0),'      
 
  set @sql = @sql + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=1),'          
*/        
         
  set @sql = @sql + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=0),'           
  
  set @sql = @sql + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=1),'                      
  set @sql = @sql + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''
  
    
      
),'';'') where idx=0),'      
          
       
  set @sql = @sql + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=1),
  
        
'          
-------------------------------ZSL Changes End-------------------------------------        
        
  set @sql = @sql + ' ITEM_PRICE, 0 AS JOBI_DELIVER_QTY,0 AS JOBI_BO_QTY,COST_PRICE1 AS COST_PRICE,DIS.DISCOUNTCODE AS DISC_CODE_SELL,DIS2.DISCOUNTCODE AS DISC_CODE_BUY,LOCATION,'                
 -- ****************************************  
 -- Modified Date : 18th November 2008,15th February 2010  
 -- Bug No      : 4332, Item and make should be there to search  
  set @sql = @sql + ' ID_ITEM + ''-'' + ITEM_DESC AS IDESC,'    
  set @sql = @sql + ' ID_ITEM + ''#|'' + ITEM.ID_MAKE AS I_ITEM,'   
  set @sql = @sql + ' ID_WH_ITEM  AS ID_WH_ITEM,'     
  set @sql = @sql + ' ENV_ID_ITEM,'     
  set @sql = @sql + ' ENV_ID_MAKE,'     
  set @sql = @sql + ' ISNULL(ENV_ID_WAREHOUSE,0) AS ENV_ID_WAREHOUSE,'     
  set @sql = @sql + ' ISNULL(FLG_EFD,0) AS FLG_EFD, '     
  set @sql = @sql + ' ITEM.SUPP_CURRENTNO AS SUPP_CURRENTNO '     
 -- ********** End Of Modification **********  
  set @sql = @sql + '  FROM '                
  set @sql = @sql + ' TBL_MAS_ITEM_MASTER ITEM '    
  set @sql = @sql + ' left outer JOIN TBL_SPR_DISCOUNTCODE DIS ON DIS.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE left outer JOIN TBL_SPR_DISCOUNTCODE DIS2 ON DIS2.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE_BUY'   
  set @sql = @sql + ' WHERE (ID_ITEM = ''' + @iv_ItemDesc + ''' and not ITEM_DESC =''' + @iv_ItemDesc + ''')'              
  --set @sql = @sql + ' WHERE (ID_ITEM like ''' + @iv_ItemDesc + '%'')'         
--ADDED VMSSANTHOSH 09-APR-2008        
  SET @SQL = @SQL + ' AND ID_WH_ITEM = '+ convert(varchar(20),@WAREHOUSEID)   
  --SET @SQL = @SQL + 'ORDER BY ID_ITEM '   
    
    
    
  set @SQL1 = 'Select'                
  set @SQL1 = @SQL1 + ' ID_ITEM,'        
  set @SQL1 = @SQL1 + 'CASE WHEN ID_ITEM IS NOT NULL THEN      
(SELECT TOP 1 ID_REPLACEMENT FROM TBL_SPR_REPLACEMENT REP      
WHERE REP.ID_LOCALSPAREPART=ID_ITEM AND      
REP.ID_MAKE_LOCAL=ITEM.ID_MAKE      
) ELSE '''' END AS ID_REPLACE,'        
  --change end      
  set @SQL1 = @SQL1 + ' ITEM_DESC,'                
  set @SQL1 = @SQL1 + ' ID_UNIT_ITEM,'                
  set @SQL1 = @SQL1 + ' ID_ITEM_CATG,'                
  set @SQL1 = @SQL1 + ' ITEM.ID_MAKE,'                
  set @SQL1 = @SQL1 + ' CASE WHEN ID_ITEM_CATG IS NOT NULL THEN'                
  set @SQL1 = @SQL1 + '     (SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  '                
  set @SQL1 = @SQL1 + '   WHERE CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)'                
  set @SQL1 = @SQL1 + ' ELSE '''''                
  set @SQL1 = @SQL1 + '  END AS CAT_DESC,'                
  set @SQL1 = @SQL1 + ' CASE WHEN ITEM.ID_MAKE IS NOT NULL THEN'                
  set @SQL1 = @SQL1 + '  (SELECT ISNULL(ID_MAKE + ''   -   '' + ID_MAKE_NAME,'''') FROM TBL_MAS_MAKE MAKE'                
  set @SQL1 = @SQL1 + '   WHERE MAKE.ID_MAKE = ITEM.ID_MAKE)'                
  set @SQL1 = @SQL1 + ' ELSE '''''                
  set @SQL1 = @SQL1 + '  END AS MAKE,'                
  set @SQL1 = @SQL1 + ' ITEM_AVAIL_QTY   , '                
  set @SQL1 = @SQL1 + ' ITEM_REORDER_LEVEL, '     
  set @SQL1 = @SQL1 + ' FLG_ALLOW_BCKORD, '   
    
  set @SQL1 = @SQL1 + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=0),'         
    
  set @SQL1 = @SQL1 + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=1),'                      
  set @SQL1 = @SQL1 + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '
''  
      
),'';'') where idx=0),'      
          
  set @SQL1 = @SQL1 + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=1
),  
      
'          
  
        
  set @SQL1 = @SQL1 + ' ITEM_PRICE, 0 AS JOBI_DELIVER_QTY,0 AS JOBI_BO_QTY,COST_PRICE1 AS COST_PRICE,DIS.DISCOUNTCODE AS DISC_CODE_SELL,DIS2.DISCOUNTCODE AS DISC_CODE_BUY,LOCATION,'                
  set @SQL1 = @SQL1 + ' ID_ITEM + ''-'' + ITEM_DESC AS IDESC,'    
  set @SQL1 = @SQL1 + ' ID_ITEM + ''#|'' + ITEM.ID_MAKE AS I_ITEM,'    
  set @SQL1 = @SQL1 + ' ID_WH_ITEM  AS ID_WH_ITEM,'  
  set @sql1 = @sql1 + ' ENV_ID_ITEM,'     
  set @sql1 = @sql1 + ' ENV_ID_MAKE,'     
  set @sql1 = @sql1 + ' ISNULL(ENV_ID_WAREHOUSE,0) AS ENV_ID_WAREHOUSE,'     
  set @sql1 = @sql1 + ' ISNULL(FLG_EFD,0) as FLG_EFD, '    
  set @sql1 = @sql1 + ' ITEM.SUPP_CURRENTNO AS SUPP_CURRENTNO '
  set @SQL1 = @SQL1 + '  FROM'                
  set @SQL1 = @SQL1 + ' TBL_MAS_ITEM_MASTER ITEM '    
  set @SQL1 = @SQL1 + ' left outer JOIN TBL_SPR_DISCOUNTCODE DIS ON DIS.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE left outer JOIN TBL_SPR_DISCOUNTCODE DIS2 ON DIS2.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE_BUY'   
  set @SQL1 = @SQL1 + ' WHERE (ITEM_DESC = ''' + @iv_ItemDesc + ''' and not ID_ITEM =''' + @iv_ItemDesc + ''')'              
  SET @SQL1 = @SQL1 + ' AND ID_WH_ITEM = '+ convert(varchar(20),@WAREHOUSEID)   
  --SET @SQL1 = @SQL1 + 'ORDER BY ID_ITEM '      
    
    
  SET @SQL2 = 'Select'       
  set @SQL2 = @SQL2 + ' ID_ITEM,'        
  set @SQL2 = @SQL2 + 'CASE WHEN ID_ITEM IS NOT NULL THEN      
(SELECT TOP 1 ID_REPLACEMENT FROM TBL_SPR_REPLACEMENT REP      
WHERE REP.ID_LOCALSPAREPART=ID_ITEM AND      
REP.ID_MAKE_LOCAL=ITEM.ID_MAKE      
) ELSE '''' END AS ID_REPLACE,'        
      
  set @SQL2 = @SQL2 + ' ITEM_DESC,'                
  set @SQL2 = @SQL2 + ' ID_UNIT_ITEM,'                
  set @SQL2 = @SQL2 + ' ID_ITEM_CATG,'                
  set @SQL2 = @SQL2 + ' ITEM.ID_MAKE,'                
  set @SQL2 = @SQL2 + ' CASE WHEN ID_ITEM_CATG IS NOT NULL THEN'                
  set @SQL2 = @SQL2 + '     (SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  '                
  set @SQL2 = @SQL2 + '   WHERE CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)'                
  set @SQL2 = @SQL2 + ' ELSE '''''                
  set @SQL2 = @SQL2 + '  END AS CAT_DESC,'                
  set @SQL2 = @SQL2 + ' CASE WHEN ITEM.ID_MAKE IS NOT NULL THEN'                
  set @SQL2 = @SQL2 + '  (SELECT ISNULL(ID_MAKE + ''   -   '' + ID_MAKE_NAME,'''') FROM TBL_MAS_MAKE MAKE'                
  set @SQL2 = @SQL2 + '   WHERE MAKE.ID_MAKE = ITEM.ID_MAKE)'                
  set @SQL2 = @SQL2 + ' ELSE '''''                
  set @SQL2 = @SQL2 + '  END AS MAKE,'                
  set @SQL2 = @SQL2 + ' ITEM_AVAIL_QTY   , '                
  set @SQL2 = @SQL2 + ' ITEM_REORDER_LEVEL, '     
  set @SQL2 = @SQL2 + ' FLG_ALLOW_BCKORD, '   
    
  set @SQL2 = @SQL2 + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=0),'         
    
  set @SQL2 = @SQL2 + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=1),'                      
  set @SQL2 = @SQL2 + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '
''  
      
),'';'') where idx=0),'      
          
  set @SQL2 = @SQL2 + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=1
),  
      
'          
       
  set @SQL2 = @SQL2 + ' ITEM_PRICE, 0 AS JOBI_DELIVER_QTY,0 AS JOBI_BO_QTY,COST_PRICE1 AS COST_PRICE,DIS.DISCOUNTCODE AS DISC_CODE_SELL,DIS2.DISCOUNTCODE AS DISC_CODE_BUY,LOCATION,'                
  set @SQL2 = @SQL2 + ' ID_ITEM + ''-'' + ITEM_DESC AS IDESC,'    
  set @SQL2 = @SQL2 + ' ID_ITEM + ''#|'' + ITEM.ID_MAKE AS I_ITEM,'  
  set @SQL2 = @SQL2 + ' ID_WH_ITEM  AS ID_WH_ITEM,'  
  set @sql2 = @sql2 + ' ENV_ID_ITEM,'     
  set @sql2 = @sql2 + ' ENV_ID_MAKE,'     
  set @sql2 = @sql2 + ' ISNULL(ENV_ID_WAREHOUSE,0) AS ENV_ID_WAREHOUSE,'     
  set @sql2 = @sql2 + ' ISNULL(FLG_EFD,0) as FLG_EFD, '       
  set @sql2 = @sql2 + ' ITEM.SUPP_CURRENTNO as SUPP_CURRENTNO '       
  set @SQL2 = @SQL2 + '  FROM '                
  set @SQL2 = @SQL2 + ' TBL_MAS_ITEM_MASTER ITEM '    
  set @SQL2 = @SQL2 + ' left outer JOIN TBL_SPR_DISCOUNTCODE DIS ON DIS.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE left outer JOIN TBL_SPR_DISCOUNTCODE DIS2 ON DIS2.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE_BUY'   
  set @SQL2 = @SQL2 + ' WHERE ( ID_ITEM = ''' + @iv_ItemDesc + ''' and  ITEM_DESC =''' + @iv_ItemDesc + ''')'              
  SET @SQL2 = @SQL2 + ' AND ID_WH_ITEM = '+ convert(varchar(20),@WAREHOUSEID)   
  --SET @SQL2 = @SQL2 + 'ORDER BY ID_ITEM '     
     
 IF (ISNULL(@USE_ALL_SPARE_SRCH,0)  = '1')   
  BEGIN  
   
   set @SQL3 = 'Select'                
   set @SQL3 = @SQL3 + ' ID_ITEM,'        
   set @SQL3 = @SQL3 + 'CASE WHEN ID_ITEM IS NOT NULL THEN      
 (SELECT TOP 1 ID_REPLACEMENT FROM TBL_SPR_REPLACEMENT REP      
 WHERE REP.ID_LOCALSPAREPART=ID_ITEM AND      
 REP.ID_MAKE_LOCAL=ITEM.ID_MAKE      
 ) ELSE '''' END AS ID_REPLACE,'        
   --change end      
   set @SQL3 = @SQL3 + ' ITEM_DESC,'                
   set @SQL3 = @SQL3 + ' ID_UNIT_ITEM,'                
   set @SQL3 = @SQL3 + ' ID_ITEM_CATG,'                
   set @SQL3 = @SQL3 + ' ITEM.ID_MAKE,'                
   set @SQL3 = @SQL3 + ' CASE WHEN ID_ITEM_CATG IS NOT NULL THEN'                
   set @SQL3 = @SQL3 + '     (SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  '                
   set @SQL3 = @SQL3 + '   WHERE CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)'                
   set @SQL3 = @SQL3 + ' ELSE '''''                
   set @SQL3 = @SQL3 + '  END AS CAT_DESC,'                
   set @SQL3 = @SQL3 + ' CASE WHEN ITEM.ID_MAKE IS NOT NULL THEN'                
   set @SQL3 = @SQL3 + '  (SELECT ISNULL(ID_MAKE + ''   -   '' + ID_MAKE_NAME,'''') FROM TBL_MAS_MAKE MAKE'                
   set @SQL3 = @SQL3 + '   WHERE MAKE.ID_MAKE = ITEM.ID_MAKE)'                
   set @SQL3 = @SQL3 + ' ELSE '''''                
   set @SQL3 = @SQL3 + '  END AS MAKE,'                
   set @SQL3 = @SQL3 + ' ITEM_AVAIL_QTY   , '                
   set @SQL3 = @SQL3 + ' ITEM_REORDER_LEVEL, '     
   set @SQL3 = @SQL3 + ' FLG_ALLOW_BCKORD, '   
     
   set @SQL3 = @SQL3 + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=0),'        
     
   set @SQL3 = @SQL3 + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=1),'                      
   set @SQL3 = @SQL3 + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + 
'''  
       
 ),'';'') where idx=0),'      
           
   set @SQL3 = @SQL3 + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=
1),  
       
 '          
  
         
   set @SQL3 = @SQL3 + ' ITEM_PRICE, 0 AS JOBI_DELIVER_QTY,0 AS JOBI_BO_QTY,COST_PRICE1 AS COST_PRICE,DIS.DISCOUNTCODE AS DISC_CODE_SELL,DIS2.DISCOUNTCODE AS DISC_CODE_BUY,LOCATION,'                
   set @SQL3 = @SQL3 + ' ID_ITEM + ''-'' + ITEM_DESC AS IDESC,'    
   set @SQL3 = @SQL3 + ' ID_ITEM + ''#|'' + ITEM.ID_MAKE AS I_ITEM,'    
   set @sql3 = @sql3 + ' ID_WH_ITEM  AS ID_WH_ITEM,'  
   set @sql3 = @sql3 + ' ENV_ID_ITEM,'     
      set @sql3 = @sql3 + ' ENV_ID_MAKE,'     
      set @sql3 = @sql3 + ' ISNULL(ENV_ID_WAREHOUSE,0) AS ENV_ID_WAREHOUSE,'     
   set @sql3 = @sql3 + ' ISNULL(FLG_EFD,0) as FLG_EFD, '     
   set @sql3 = @sql3 + ' ITEM.SUPP_CURRENTNO as SUPP_CURRENTNO '     
   set @SQL3 = @SQL3 + '  FROM'                
   set @SQL3 = @SQL3 + ' TBL_MAS_ITEM_MASTER ITEM '    
   set @SQL3 = @SQL3 + ' left outer JOIN TBL_SPR_DISCOUNTCODE DIS ON DIS.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE left outer JOIN TBL_SPR_DISCOUNTCODE DIS2 ON DIS2.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE_BUY'   
   set @SQL3 = @SQL3 + ' WHERE (ID_ITEM = ''' +  @iv_ItemDesc + ''' and not ITEM_DESC =''' + @iv_ItemDesc + '''and not ID_ITEM =''' + @iv_ItemDesc + '''and not ITEM_DESC =''' + @iv_ItemDesc + ''')'              
   SET @SQL3 = @SQL3 + ' AND ID_WH_ITEM = '+ convert(varchar(20),@WAREHOUSEID)   
     
     
   set @SQL4 = 'Select'                
   set @SQL4 = @SQL4 + ' ID_ITEM,'        
   set @SQL4 = @SQL4 + 'CASE WHEN ID_ITEM IS NOT NULL THEN      
 (SELECT TOP 1 ID_REPLACEMENT FROM TBL_SPR_REPLACEMENT REP      
 WHERE REP.ID_LOCALSPAREPART=ID_ITEM AND      
 REP.ID_MAKE_LOCAL=ITEM.ID_MAKE      
 ) ELSE '''' END AS ID_REPLACE,'        
   --change end      
   set @SQL4 = @SQL4 + ' ITEM_DESC,'                
   set @SQL4 = @SQL4 + ' ID_UNIT_ITEM,'                
   set @SQL4 = @SQL4 + ' ID_ITEM_CATG,'                
   set @SQL4 = @SQL4 + ' ITEM.ID_MAKE,'                
   set @SQL4 = @SQL4 + ' CASE WHEN ID_ITEM_CATG IS NOT NULL THEN'                
   set @SQL4 = @SQL4 + '     (SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  '                
   set @SQL4 = @SQL4 + '   WHERE CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)'                
   set @SQL4 = @SQL4 + ' ELSE '''''                
   set @SQL4 = @SQL4 + '  END AS CAT_DESC,'                
   set @SQL4 = @SQL4 + ' CASE WHEN ITEM.ID_MAKE IS NOT NULL THEN'                
   set @SQL4 = @SQL4 + '  (SELECT ISNULL(ID_MAKE + ''   -   '' + ID_MAKE_NAME,'''') FROM TBL_MAS_MAKE MAKE'                
   set @SQL4 = @SQL4 + '   WHERE MAKE.ID_MAKE = ITEM.ID_MAKE)'                
   set @SQL4 = @SQL4 + ' ELSE '''''                
   set @SQL4 = @SQL4 + '  END AS MAKE,'                
   set @SQL4 = @SQL4 + ' ITEM_AVAIL_QTY   , '                
   set @SQL4 = @SQL4 + ' ITEM_REORDER_LEVEL, '     
   set @SQL4 = @SQL4 + ' FLG_ALLOW_BCKORD, '   
     
   set @SQL4 = @SQL4 + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=0),'        
     
   set @SQL4 = @SQL4 + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=1),'                      
   set @SQL4 = @SQL4 + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + 
'''  
       
 ),'';'') where idx=0),'      
           
   set @SQL4 = @SQL4 + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=
1),  
       
 '          
  
         
   set @SQL4 = @SQL4 + ' ITEM_PRICE, 0 AS JOBI_DELIVER_QTY,0 AS JOBI_BO_QTY,COST_PRICE1 AS COST_PRICE,DIS.DISCOUNTCODE AS DISC_CODE_SELL,DIS2.DISCOUNTCODE AS DISC_CODE_BUY,LOCATION,'                
   set @SQL4 = @SQL4 + ' ID_ITEM + ''-'' + ITEM_DESC AS IDESC,'    
   set @SQL4 = @SQL4 + ' ID_ITEM + ''#|'' + ITEM.ID_MAKE AS I_ITEM,'  
   set @sql4 = @sql4 + ' ID_WH_ITEM  AS ID_WH_ITEM,'  
   set @SQL4 = @SQL4 + ' ENV_ID_ITEM,'     
   set @SQL4 = @SQL4 + ' ENV_ID_MAKE,'     
   set @SQL4 = @SQL4 + ' ISNULL(ENV_ID_WAREHOUSE,0) AS ENV_ID_WAREHOUSE,'     
   set @SQL4 = @SQL4 + ' ISNULL(FLG_EFD,0) as FLG_EFD, '       
   set @SQL4 = @SQL4 + ' ITEM.SUPP_CURRENTNO as SUPP_CURRENTNO '     
   set @SQL4 = @SQL4 + '  FROM'                
   set @SQL4 = @SQL4 + ' TBL_MAS_ITEM_MASTER ITEM '    
   set @SQL4 = @SQL4 + ' left outer JOIN TBL_SPR_DISCOUNTCODE DIS ON DIS.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE left outer JOIN TBL_SPR_DISCOUNTCODE DIS2 ON DIS2.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE_BUY'   
   set @SQL4 = @SQL4 + ' WHERE (ITEM_DESC = ''' +  @iv_ItemDesc + ''' and not ID_ITEM =''' + @iv_ItemDesc + '''and not ID_ITEM =''' + @iv_ItemDesc + '''and not ITEM_DESC =''' + @iv_ItemDesc + ''')'              
   SET @SQL4 = @SQL4 + ' AND ID_WH_ITEM = '+ convert(varchar(20),@WAREHOUSEID)    
     
   SET @SQL5 = 'Select'       
   set @SQL5 = @SQL5 + ' ID_ITEM,'        
   set @SQL5 = @SQL5 + 'CASE WHEN ID_ITEM IS NOT NULL THEN      
 (SELECT TOP 1 ID_REPLACEMENT FROM TBL_SPR_REPLACEMENT REP      
 WHERE REP.ID_LOCALSPAREPART=ID_ITEM AND      
 REP.ID_MAKE_LOCAL=ITEM.ID_MAKE      
 ) ELSE '''' END AS ID_REPLACE,'        
       
   set @SQL5 = @SQL5 + ' ITEM_DESC,'                
   set @SQL5 = @SQL5 + ' ID_UNIT_ITEM,'                
   set @SQL5 = @SQL5 + ' ID_ITEM_CATG,'                
   set @SQL5 = @SQL5 + ' ITEM.ID_MAKE,'                
   set @SQL5 = @SQL5 + ' CASE WHEN ID_ITEM_CATG IS NOT NULL THEN'                
   set @SQL5 = @SQL5 + '     (SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  '                
   set @SQL5 = @SQL5 + '   WHERE CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)'                
   set @SQL5 = @SQL5 + ' ELSE '''''                
   set @SQL5 = @SQL5 + '  END AS CAT_DESC,'                
   set @SQL5 = @SQL5 + ' CASE WHEN ITEM.ID_MAKE IS NOT NULL THEN'                
   set @SQL5 = @SQL5 + '  (SELECT ISNULL(ID_MAKE + ''   -   '' + ID_MAKE_NAME,'''') FROM TBL_MAS_MAKE MAKE'                
   set @SQL5 = @SQL5 + '   WHERE MAKE.ID_MAKE = ITEM.ID_MAKE)'                
   set @SQL5 = @SQL5 + ' ELSE '''''                
   set @SQL5 = @SQL5 + '  END AS MAKE,'                
   set @SQL5 = @SQL5 + ' ITEM_AVAIL_QTY   , '                
   set @SQL5 = @SQL5 + ' ITEM_REORDER_LEVEL, '     
   set @SQL5 = @SQL5 + ' FLG_ALLOW_BCKORD, '   
     
   set @SQL5 = @SQL5 + ' JOBI_DIS_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=0),'        
     
   set @SQL5 = @SQL5 + ' JOBI_DIS_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETDISCPERC (''' + isnull(@IV_USERID,'') +''',''' + isnull(@IV_ID_CUST,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM),'';'') where idx=1),'                      
   set @SQL5 = @SQL5 + ' JOBI_VAT_PER = (select cast(value1 as numeric(5,2)) from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + 
'''  
       
 ),'';'') where idx=0),'      
           
   set @SQL5 = @SQL5 + ' JOBI_VAT_SEQ = (select value1 from dbo.fn_Split(DBO.FN_GETVATPERC (''' + isnull(@IV_ID_CUST,'') + ''',''' + isnull(@IV_ID_VEH,'') + ''',ITEM.ID_ITEM,ITEM.ID_MAKE,ITEM.ID_WH_ITEM,''' + isnull(@IV_USERID,'') + '''),'';'') where idx=
1),  
       
 '          
        
   set @SQL5 = @SQL5 + ' ITEM_PRICE, 0 AS JOBI_DELIVER_QTY,0 AS JOBI_BO_QTY,COST_PRICE1 AS COST_PRICE,DIS.DISCOUNTCODE AS DISC_CODE_SELL,DIS2.DISCOUNTCODE AS DISC_CODE_BUY,LOCATION,'                
   set @SQL5 = @SQL5 + ' ID_ITEM + ''-'' + ITEM_DESC AS IDESC,'    
   set @SQL5 = @SQL5 + ' ID_ITEM + ''#|'' + ITEM.ID_MAKE AS I_ITEM,'  
   set @sql5 = @sql5 + ' ID_WH_ITEM  AS ID_WH_ITEM,'      
   set @SQL5 = @SQL5 + ' ENV_ID_ITEM,'     
   set @SQL5 = @SQL5 + ' ENV_ID_MAKE,'     
   set @SQL5 = @SQL5 + ' ISNULL(ENV_ID_WAREHOUSE,0) AS ENV_ID_WAREHOUSE,'     
   set @SQL5 = @SQL5 + ' ISNULL(FLG_EFD,0) as FLG_EFD, '  
   set @SQL5 = @SQL5 + ' ITEM.SUPP_CURRENTNO as SUPP_CURRENTNO ' 
   set @SQL5 = @SQL5 + '  FROM '                
   set @SQL5 = @SQL5 + ' TBL_MAS_ITEM_MASTER ITEM '    
   set @SQL5 = @SQL5 + ' left outer JOIN TBL_SPR_DISCOUNTCODE DIS ON DIS.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE left outer JOIN TBL_SPR_DISCOUNTCODE DIS2 ON DIS2.ID_DISCOUNTCODE=ITEM.ITEM_DISC_CODE_BUY'   
   set @SQL5 = @SQL5 + ' WHERE ( ID_ITEM = ''' +  @iv_ItemDesc + ''' and  ITEM_DESC =''' + @iv_ItemDesc + '''and not ID_ITEM =''' + @iv_ItemDesc + '''and not ITEM_DESC =''' + @iv_ItemDesc + ''')'              
   SET @SQL5 = @SQL5 + ' AND ID_WH_ITEM = '+ convert(varchar(20),@WAREHOUSEID)   
      
      set @SQL= @SQL+' UNION ALL ' +@SQL1 +' UNION ALL ' +@SQL2 +' UNION ALL '+@SQL3  
      +' UNION ALL '+ @SQL4  
      +' UNION ALL '+ @SQL5  
    
  END   
ELSE  
  BEGIN   
   
    set @SQL= @SQL+' UNION ALL ' +@SQL1 +' UNION ALL ' +@SQL2   
  END  
       
  Execute(@SQL)   
    
  
              
END    
  
             
/*            
EXEC usp_WO_LOAD_SPARES '','78','1','admin'            
EXEC usp_WO_LOAD_SPARES '%','10005','3','admin'           
select * from TBL_MAS_ITEM_MASTER WHERE ITEM_DESC LIKE 'P'            
            
Select ID_ITEM,ITEM_DESC,ID_UNIT_ITEM,ID_ITEM_CATG,ID_MAKE,            
CASE WHEN ID_ITEM_CATG IS NOT NULL THEN             
(SELECT CATG_DESC  FROM  TBL_MAS_ITEM_CATG  CATG  where CATG.ID_ITEM_CATG = ITEM.ID_ITEM_CATG)            
ELSE '' END AS CAT_DESC,            
CASE WHEN ID_MAKE IS NOT NULL THEN            
(SELECT ISNULL(ID_MAKE + '   -   ' + ID_MAKE_NAME,'') FROM TBL_MAS_MAKE MAKE              
WHERE MAKE.ID_MAKE = ITEM.ID_MAKE) ELSE '' END AS MAKE,ITEM_AVAIL_QTY,ITEM_REORDER_LEVEL,ITEM_PRICE               
from TBL_MAS_ITEM_MASTER ITEM WHERE ITEM_DESC LIKE 'P%'            
          
*/            
            
GO

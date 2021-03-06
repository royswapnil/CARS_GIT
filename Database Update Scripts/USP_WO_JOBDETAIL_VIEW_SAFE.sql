/****** Object:  StoredProcedure [dbo].[USP_WO_JOBDETAIL_VIEW_SAFE]    Script Date: 4/7/2017 4:52:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_JOBDETAIL_VIEW_SAFE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_JOBDETAIL_VIEW_SAFE]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_JOBDETAIL_VIEW_SAFE]    Script Date: 4/7/2017 4:52:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_JOBDETAIL_VIEW_SAFE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_JOBDETAIL_VIEW_SAFE] AS' 
END
GO
                                                        
ALTER PROCEDURE [dbo].[USP_WO_JOBDETAIL_VIEW_SAFE]                                                      
(                                                      
 @ID_WODET_SEQ_JOB AS INT,                                            
 @ID_JOB_ID   AS INT                                                    
)                                                      
AS                                                      
BEGIN                                                 
 DECLARE @TEMPTABLE  TABLE                                              
 (                                              
  ID_WOITEM_SEQ   INT,                                              
  ID_WODET_SEQ_JOB  INT,                                              
  ID_MAKE_JOB_ID    VARCHAR(10),                                              
  SLNO     INT  ,                                             
  MAKE    VARCHAR(50),                                              
  ID_ITEM_CATG_JOB_ID VARCHAR(10),                                              
  ID_ITEM_CATG_JOB VARCHAR(100) ,                                             
  ID_ITEM_JOB   VARCHAR(30),                                              
  ITEM_DESC   VARCHAR(100),                            
                                          
--Bug ID :- 3159                        
--Date   :- 12-Aug-2008                           
--Desc   :- Back Order,Delivery Qty, Order Qty and selling price should accept after [.] value (eg .34)                          
--  JOBI_ORDER_QTY    DECIMAL,                        
--  JOBI_DELIVER_QTY   DECIMAL,                                              
--  JOBI_BO_QTY   DECIMAL,                                              
--  JOBI_SELL_PRICE  DECIMAL,                          
  JOBI_ORDER_QTY    DECIMAL(13,2),                                              
  JOBI_DELIVER_QTY    DECIMAL(13,2),                                              
  JOBI_BO_QTY    DECIMAL(13,2),                                     
  JOBI_SELL_PRICE   DECIMAL(13,2),                          
--change end                         
                       
  JOBI_DIS_SEQ    VARCHAR(100),                          
  JOBI_DIS_PER    DECIMAL(13,2),--DECIMAL(5,2) DEFAULT 0,--VARCHAR(100),  -- Bug #4464                                            
  DISCOUNT_CD     DECIMAL,                                            
  JOBI_VAT_SEQ    VARCHAR(100) ,                                         
  JOBI_VAT_PER    DECIMAL(13,2),--DECIMAL(5,2) DEFAULT 0, --VARCHAR(100), -- Bug #4464                                             
--MODIFIED DATE: 05 NOV 2008                  
--BUG ID: 4261                  
  TOTAL_PRICE   DECIMAL(13,2),                                  
--TOTAL_PRICE   DECIMAL                  
--END OF MODIFICATION                  
  ORDER_LINE_TEXT  VARCHAR(500),                                              
  CREATED_BY   VARCHAR(20),                                              
  CREATEDDATE   DATETIME,                                              
  MODIFIED_BY   VARCHAR(20),                                              
  MODIFIEDDATE  DATETIME,                                              
  ID_WO_NO   VARCHAR(10) ,                                              
  ID_WO_PREFIX  VARCHAR(3)  ,                                              
  ID_MAKE    VARCHAR(10),                                        
  ID_WAREHOUSE  INT     --Added VMSSanthosh 09-apr-2008                            
--MODIFIED DATE: 04 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS                        
  ,ID_CUST_WO VARCHAR(10)                        
  ,TD_CALC BIT                        
  ,[TEXT] VARCHAR(2000)                        
  ,[JOBI_COST_PRICE] DECIMAL(13,2)                        
--END OF MODOFICATION                              
--MODIFIED DATE: 04 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS - Debitor online changes                        
  ,[ID_DBT_SEQ] INT ,                
  FLG_ALLOW_BCKORD BIT                  
  -- Modified Date : 30th March 2010                
  -- Bug ID   : previous printed status corrected                
     ,PICKINGLIST_PREV_PRINTED BIT                         
     ,DELIVERYNOTE_PREV_PRINTED BIT                
     ,PREV_PICKED DECIMAL(13,2)                
     ,TOBE_PICKED DECIMAL(13,2),                
     SPARE_TYPE VARCHAR(20),                
     FLG_FORCE_VAT BIT,                
     LOCATION VARCHAR(50),                
     FLG_EDIT_SP BIT,                
     EXPORT_TYPE VARCHAR(10),              
     SL_NO INT,          
     ITEM_AVAIL_QTY DECIMAL(13,2),      
     SPARE_DISCOUNT DECIMAL(13,2)               
     -- End OF Modification *************                
--END OF MODOFICATION                                    
 )                                             
                                     
 INSERT INTO @TEMPTABLE                                                    
  SELECT D.ID_WOITEM_SEQ,                                       
    D.ID_WODET_SEQ_JOB,                                              
    D.ID_MAKE_JOB AS 'ID_MAKE_JOB_ID',                                                   
    ROW_NUMBER() OVER(ORDER BY   D.ID_WOITEM_SEQ ) AS SLNO ,                                                    
    CASE WHEN D.ID_MAKE_JOB IS NOT NULL THEN                                                      
     (SELECT ISNULL(ID_MAKE_NAME,'NO NAME') FROM TBL_MAS_MAKE WHERE ID_MAKE = ID_MAKE_JOB)                                                           
--MODIFIED DATE: 04 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS          
    ELSE ''                                 
--  ELSE 'NO MAKE'                           
--END OF MODOFICATION                             
    END AS 'MAKE'  ,                                                    
    D.ID_ITEM_CATG_JOB AS 'ID_ITEM_CATG_JOB_ID',                                                      
    CASE WHEN D.ID_ITEM_CATG_JOB IS NOT NULL THEN                                                      
     (SELECT ISNULL(CATG_DESC,'NO DESCRIPTION') FROM TBL_MAS_ITEM_CATG WHERE ID_ITEM_CATG = ID_ITEM_CATG_JOB)                                        
--MODIFIED DATE: 04 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS                        
    ELSE ''                                 
--   ELSE 'NO CATEGORY'                  
--END OF MODOFICATION                                             
    END AS 'ID_ITEM_CATG_JOB' ,                                                     
    D.ID_ITEM_JOB ,                        
--MODIFIED DATE: 04 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS                        
                               
--   CASE WHEN ID_ITEM_JOB IS NOT NULL THEN                                                      
--    (SELECT ISNULL(ITEM_DESC,'NO DESCRIPTION') FROM TBL_MAS_ITEM_MASTER WHERE ID_ITEM  = ID_ITEM_JOB                                          
--   --ADDED VMSSANTHOSH 02-MAY-2008                                         
--    AND ID_WH_ITEM=ID_WAREHOUSE AND ID_MAKE=ID_MAKE_JOB                                          
--   --ADDED END                                        
--    )                                                      
--   ELSE  'NO DESCRIPTION'                                                  
--      END AS 'ITEM_DESC' ,                              
    D.ITEM_DESC,                                                
--END OF MODOFICATION                         
    ISNULL(D.JOBI_ORDER_QTY,0) AS 'JOBI_ORDER_QTY',                                                      
    ISNULL(D.JOBI_DELIVER_QTY,0) AS 'JOBI_DELIVER_QTY',                                                      
    ISNULL(D.JOBI_BO_QTY,0) AS 'JOBI_BO_QTY',                                                      
    ISNULL(D.JOBI_SELL_PRICE,  0) AS 'JOBI_SELL_PRICE',                                              
    '0' JOBI_VAT_SEQ,                                              
--   CAST(ISNULL(JOBI_DIS_PER,0) AS VARCHAR(20)) AS 'JOBI_DIS_PER',                                   
    CAST(ISNULL(D.JOBI_DIS_PER,0) AS DECIMAL(5,2)) AS 'JOBI_DIS_PER',                                                      
    ISNULL(D.JOBI_DIS_CD,0) AS 'DISCOUNT_CD',                                            
    '0' JOBI_VAT_SEQ,                                                  
--   CAST(ISNULL(JOBI_VAT_PER, 0)AS VARCHAR(20)) AS 'JOBI_VAT_PER',                                                       
    CAST(ISNULL(D.JOBI_VAT_PER, 0)AS DECIMAL(5,2)) AS 'JOBI_VAT_PER',                                
--Bug ID:- 2_4 110,122                               
--Date  :- 06-Aug-2008                              
--Desc  :- while loading Total Price calculate wrongly                              
   --CAST((ISNULL(JOBI_SELL_PRICE,0) * ISNULL(JOBI_ORDER_QTY,0))AS DECIMAL) AS 'TOTAL_PRICE',                                
    CAST((ISNULL(D.JOBI_SELL_PRICE,0) * ISNULL(D.JOBI_DELIVER_QTY,0) -                              
      (ISNULL( isnull(D.JOBI_SELL_PRICE,0) * isnull(D.JOBI_DELIVER_QTY,0)                              
       *  (0.01 * isnull(D.JOBI_DIS_PER,0)),0)))AS DECIMAL(13,2)) AS 'TOTAL_PRICE',                                         
--change end                               
    ISNULL(D.ORDER_LINE_TEXT,'') AS 'ORDER_LINE_TEXT',                                                      
    D.CREATED_BY,                       
    D.DT_CREATED,                                         
    D.MODIFIED_BY,                                              
    D.DT_MODIFIED ,                                         
    D.ID_WO_NO,                                              
    D.ID_WO_PREFIX,                 
    D.ID_MAKE_JOB AS  ID_MAKE             ,                                        
    D.ID_WAREHOUSE --Added VMSSanthosh 09-apr-2008                                        
--MODIFIED DATE: 04 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS                        
    ,D.ID_CUST_WO         
    ,D.TD_CALC                        
    ,D.[TEXT]                        
    ,D.[JOBI_COST_PRICE]                        
--END OF MODOFICATION                         
--MODIFIED DATE: 08 OCT 2008                        
--COMMENTS: SS2 - WO CHANEGS - Debitor online changes                        
    ,ISNULL(D.ID_DBT_SEQ,'-1') AS ID_DBT_SEQ                  
    ,CASE                 
    WHEN D.ID_ITEM_JOB IS NOT NULL THEN                                                            
     (SELECT FLG_ALLOW_BCKORD FROM TBL_MAS_ITEM_MASTER WHERE ID_MAKE = ID_MAKE_JOB AND ID_ITEM_CATG = ID_ITEM_CATG_JOB AND ID_ITEM = ID_ITEM_JOB AND ID_WAREHOUSE = ID_WH_ITEM)                                                            
    ELSE 'TRUE'                         
    END AS 'FLG_ALLOW_BCKORD' ,                
    D.PICKINGLIST_PREV_PRINTED  ,                
    D.DELIVERYNOTE_PREV_PRINTED ,                
    D.PICKINGLIST_PREV_PICKED AS PREV_PICKED ,                
    CASE WHEN (D.JOBI_DELIVER_QTY = D.PICKINGLIST_PREV_PICKED) THEN 0 ELSE                
     (D.JOBI_ORDER_QTY - D.PICKINGLIST_PREV_PICKED) END AS TOBE_PICKED,                
     isnull(D.SPARE_TYPE,'ORD') as  SPARE_TYPE,                
     ISNULL(D.FLG_FORCE_VAT,0) as FLG_FORCE_VAT,                
     IM.LOCATION ,                
     ISNULL(D.FLG_EDIT_SP,0) as FLG_EDIT_SP,                
     ISNULL(EXPORT_TYPE,0) AS EXPORT_TYPE,              
     Sl_No,      
     IM.ITEM_AVAIL_QTY as 'ITEM_AVAIL_QTY',      
     ISNULL(D.SPARE_DISCOUNT,0) AS 'SPARE_DISCOUNT'      
                     
--END OF MODOFICATION                         
  FROM TBL_WO_JOB_DETAIL D                
  left outer join TBL_MAS_ITEM_MASTER IM on IM.ID_ITEM=D.ID_ITEM_JOB AND IM.ID_WH_ITEM=D.ID_WAREHOUSE and D.ID_MAKE_JOB=IM.SUPP_CURRENTNO                                                      
  WHERE D.ID_WODET_SEQ_JOB = @ID_WODET_SEQ_JOB                                     
                                    
 DECLARE @ROWCOUNT AS INT                                              
 SET   @ROWCOUNT = 0                                              
                
    DECLARE @ROWLOOP AS INT                                              
 SET   @ROWLOOP = 0                                      
                
                            
 SELECT @ROWCOUNT = COUNT(*) FROM @TEMPTABLE                                                
 IF @ROWCOUNT > 0                                               
 BEGIN                                         
  DECLARE @ID_WO_NO_TEMP AS VARCHAR(10)                                              
  DECLARE @ID_WO_PREFIX_TEMP AS VARCHAR(3)                                               
  DECLARE @ID_ITEM_JOB_TEMP  AS VARCHAR(30)                                              
  DECLARE @ID_MAKE_JOB_TEMP  AS VARCHAR(30)                                                
  DECLARE @ID_WAREHOUSE_TEMP  AS INT                                                
                
     SET @ID_WO_NO_TEMP  =''                                              
  SET @ID_WO_PREFIX_TEMP =''                                               
  SET @ID_ITEM_JOB_TEMP =''                                              
                                              
  DECLARE @DISTEMP AS VARCHAR(100)                                  
  DECLARE @VATTEMP AS VARCHAR(100)                                              
  DECLARE @RT_DISC_SEQ AS VARCHAR(14)                                            
  DECLARE @RT_VAT_SEQ  AS VARCHAR(14)                                              
                  
  --MODIFIED DATE: 30 OCT 2008                  
  --BUG ID: 4036 - MULTIPLE VALUES ARE DISPLAYED FOR VAT%                  
  DECLARE @ID_JOB_DEB AS VARCHAR(20)                  
  --END OF MODIFICATION                  
                                
                     
  WHILE @ROWLOOP < @ROWCOUNT                                               
  BEGIN                                  
   SELECT  @ID_WO_NO_TEMP  = ID_WO_NO ,                                              
     @ID_WO_PREFIX_TEMP = ID_WO_PREFIX ,                                              
     @ID_ITEM_JOB_TEMP = ID_ITEM_JOB,                                      
     @ID_MAKE_JOB_TEMP=ID_MAKE_JOB_ID,                                       @ID_WAREHOUSE_TEMP= ID_WAREHOUSE                                       
 --MODIFIED DATE: 30 OCT 2008                  
 --BUG ID: 4036 - MULTIPLE VALUES ARE DISPLAYED FOR VAT%                  
     ,@ID_JOB_DEB = ID_CUST_WO                  
 --END OF MODIFICATION                  
   FROM @TEMPTABLE                          
   WHERE SLNO = @ROWLOOP +1                                  
                        
                  
--MODIFIED DATE: 30 OCT 2008                  
--BUG ID: 4036 - MULTIPLE VALUES ARE DISPLAYED FOR VAT%                  
                
                
   EXEC USP_VATDIS_VIEW @ID_WO_NO_TEMP, @ID_WO_PREFIX_TEMP, @ID_JOB_ID, @ID_ITEM_JOB_TEMP,                    
     @ID_MAKE_JOB_TEMP,@ID_WAREHOUSE_TEMP, @ID_JOB_DEB,                  
        @DISTEMP OUTPUT , @VATTEMP OUTPUT, @RT_DISC_SEQ OUTPUT, @RT_VAT_SEQ  OUTPUT                                              
                
                
                
-- EXEC USP_VATDIS_VIEW @ID_WO_NO_TEMP, @ID_WO_PREFIX_TEMP, @ID_JOB_ID, @ID_ITEM_JOB_TEMP,                    
--@ID_MAKE_JOB_TEMP,@ID_WAREHOUSE_TEMP,                 
--     @DISTEMP OUTPUT , @VATTEMP OUTPUT, @RT_DISC_SEQ OUTPUT, @RT_VAT_SEQ  OUTPUT                                              
                  
--END OF MODIFICATION                    
                                  
   update    @TEMPTABLE                                          
   SET                         
  -- *************************************************                        
   -- Modified Date : 16th September 2008                        
   -- Bug Id   : Testjournal Re-opened Issue                        
  --JOBI_DIS_PER = ISNULL(@DISTEMP,0)  ,                                      
  -- ************ End Of Modification ****************                    
                               
    --JOBI_VAT_PER = ISNULL(@VATTEMP,0)  ,                              
    JOBI_VAT_SEQ = ISNULL(@RT_VAT_SEQ,0) ,                                        
    JOBI_DIS_SEQ = ISNULL(@RT_DISC_SEQ,0)                                   
   WHERE SLNO = @ROWLOOP + 1                                                    
   SET @ROWLOOP = @ROWLOOP + 1                                              
  END                                              
 END                                              
 SELECT * FROM @TEMPTABLE                        
END                   
                                                      
/*                                                    
 EXEC USP_WO_JOBDETAIL_VIEW_SAFE 95, 3                         
                         
EXEC USP_WO_JOBDETAIL_VIEW_SAFE 17577, 1                        
                  
3038 SRS 1 YSP YMAKE 2                  
                                    
*/ 

GO

/****** Object:  StoredProcedure [dbo].[USP_RPT_WORKORDERSPARES]    Script Date: 9/13/2017 12:23:10 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_RPT_WORKORDERSPARES]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_RPT_WORKORDERSPARES]
GO
/****** Object:  StoredProcedure [dbo].[USP_RPT_WORKORDERSPARES]    Script Date: 9/13/2017 12:23:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_RPT_WORKORDERSPARES]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_RPT_WORKORDERSPARES] AS' 
END
GO
                          
                                            
ALTER PROCEDURE [dbo].[USP_RPT_WORKORDERSPARES]                                          
(                                          
   @ID_WO_NO AS VARCHAR(10),                                
   @ID_WO_PREFIX AS VARCHAR(10)                                  
)                                          
AS                                          
BEGIN     
  
 --declare @ID_WODET_SEQ_JOB AS INT                             
 declare @ID_JOB_ID   AS INT      
   
 --select * from tbl_wo_detail wd where wd.id_wo_no = @ID_WO_NO and wd.id_wo_prefix=@ID_WO_PREFIX  
                                  
 DECLARE @TEMPTABLE  TABLE                                  
 (                                  
  ID_WOITEM_SEQ   INT,                                  
  ID_WODET_SEQ_JOB  INT,                                  
  ID_MAKE_JOB_ID    VARCHAR(10),                                  
  SLNO     INT  ,                                 
  MAKE    VARCHAR(10),                                  
  ID_ITEM_CATG_JOB_ID VARCHAR(10),                                  
  ID_ITEM_CATG_JOB VARCHAR(100) ,                                 
  ID_ITEM_JOB   VARCHAR(30),                                  
  ITEM_DESC   VARCHAR(100),  
  JOBI_ORDER_QTY    DECIMAL(13,2),                                  
  JOBI_DELIVER_QTY    DECIMAL(13,2),                                  
  JOBI_BO_QTY    DECIMAL(13,2),                                  
  JOBI_SELL_PRICE   DECIMAL(13,2),  
  JOBI_DIS_SEQ    VARCHAR(100),              
  JOBI_DIS_PER    DECIMAL(13,2),                            
  DISCOUNT_CD     DECIMAL,                                
  JOBI_VAT_SEQ    VARCHAR(100) ,                             
  JOBI_VAT_PER    DECIMAL(13,2),  
  TOTAL_PRICE   DECIMAL(13,2),  
  ORDER_LINE_TEXT  VARCHAR(500),                                  
  CREATED_BY   VARCHAR(20),                                  
  CREATEDDATE   DATETIME,                                  
  MODIFIED_BY   VARCHAR(20),                                  
  MODIFIEDDATE  DATETIME,                                  
  ID_WO_NO   VARCHAR(10) ,                                  
  ID_WO_PREFIX  VARCHAR(3)  ,                                  
  ID_MAKE    VARCHAR(10),                            
  ID_WAREHOUSE  INT            
  ,ID_CUST_WO VARCHAR(10)            
  ,TD_CALC BIT            
  ,[TEXT] VARCHAR(2000)            
  ,[JOBI_COST_PRICE] DECIMAL(13,2)        
  ,[ID_DBT_SEQ] INT ,    
  FLG_ALLOW_BCKORD BIT   
     ,PICKINGLIST_PREV_PRINTED BIT             
     ,DELIVERYNOTE_PREV_PRINTED BIT    
     ,PREV_PICKED DECIMAL(13,2)    
     ,TOBE_PICKED DECIMAL(13,2),    
     SPARE_TYPE VARCHAR(20),    
     FLG_FORCE_VAT BIT,    
     LOCATION VARCHAR(50),    
     FLG_EDIT_SP BIT,    
     EXPORT_TYPE VARCHAR(10)    
                     
 )                                 
                         
 INSERT INTO @TEMPTABLE                                        
  SELECT D.ID_WOITEM_SEQ,                           
    D.ID_WODET_SEQ_JOB,                                  
    D.ID_MAKE_JOB AS 'ID_MAKE_JOB_ID',                                       
    ROW_NUMBER() OVER(ORDER BY   D.ID_WOITEM_SEQ ) AS SLNO ,                                        
    CASE WHEN D.ID_MAKE_JOB IS NOT NULL THEN                                          
     (SELECT ISNULL(ID_MAKE_NAME,'NO NAME') FROM TBL_MAS_MAKE WHERE ID_MAKE = ID_MAKE_JOB)   
    ELSE ''               
    END AS 'MAKE'  ,                                        
    D.ID_ITEM_CATG_JOB AS 'ID_ITEM_CATG_JOB_ID',                                          
    CASE WHEN D.ID_ITEM_CATG_JOB IS NOT NULL THEN                                          
     (SELECT ISNULL(CATG_DESC,'NO DESCRIPTION') FROM TBL_MAS_ITEM_CATG WHERE ID_ITEM_CATG = ID_ITEM_CATG_JOB)  
    ELSE ''                               
    END AS 'ID_ITEM_CATG_JOB' ,                                         
    D.ID_ITEM_JOB ,                  
    D.ITEM_DESC,           
    ISNULL(D.JOBI_ORDER_QTY,0) AS 'JOBI_ORDER_QTY',                                          
    ISNULL(D.JOBI_DELIVER_QTY,0) AS 'JOBI_DELIVER_QTY',                                          
    ISNULL(D.JOBI_BO_QTY,0) AS 'JOBI_BO_QTY',                                          
    ISNULL(D.JOBI_SELL_PRICE,  0) AS 'JOBI_SELL_PRICE',                                  
    '0' JOBI_VAT_SEQ,  
    CAST(ISNULL(D.JOBI_DIS_PER,0) AS DECIMAL(5,2)) AS 'JOBI_DIS_PER',                                          
    ISNULL(D.JOBI_DIS_CD,0) AS 'DISCOUNT_CD',                                
    '0' JOBI_VAT_SEQ,                                           
    CAST(ISNULL(D.JOBI_VAT_PER, 0)AS DECIMAL(5,2)) AS 'JOBI_VAT_PER',                   
    CAST((ISNULL(D.JOBI_SELL_PRICE,0) * ISNULL(D.JOBI_DELIVER_QTY,0) -                  
      (ISNULL( isnull(D.JOBI_SELL_PRICE,0) * isnull(D.JOBI_DELIVER_QTY,0)                  
       *  (0.01 * isnull(D.JOBI_DIS_PER,0)),0)))AS DECIMAL(13,2)) AS 'TOTAL_PRICE',    
    ISNULL(D.ORDER_LINE_TEXT,'') AS 'ORDER_LINE_TEXT',                                          
    D.CREATED_BY,                                  
    D.DT_CREATED,                             
    D.MODIFIED_BY,                                  
    D.DT_MODIFIED ,                             
    D.ID_WO_NO,                                  
    D.ID_WO_PREFIX,                                  
    D.ID_MAKE_JOB AS  ID_MAKE             ,                            
    D.ID_WAREHOUSE          
    ,D.ID_CUST_WO            
    ,D.TD_CALC            
    ,D.[TEXT]            
    ,D.[JOBI_COST_PRICE]  
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
                 ISNULL(EXPORT_TYPE,0) AS EXPORT_TYPE    
            
  FROM TBL_WO_JOB_DETAIL D    
  left outer join TBL_MAS_ITEM_MASTER IM on IM.ID_ITEM=D.ID_ITEM_JOB AND IM.ID_WH_ITEM=D.ID_WAREHOUSE and D.ID_MAKE_JOB=IM.ID_MAKE                                          
  WHERE                         
  D.ID_WO_NO=@ID_WO_NO AND D.ID_WO_PREFIX=@ID_WO_PREFIX  
                        
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
  DECLARE @ID_JOB_DEB AS VARCHAR(20)   
                                  
  WHILE @ROWLOOP < @ROWCOUNT                                   
  BEGIN                      
   SELECT  @ID_WO_NO_TEMP  = ID_WO_NO ,                                  
     @ID_WO_PREFIX_TEMP = ID_WO_PREFIX ,                                  
     @ID_ITEM_JOB_TEMP = ID_ITEM_JOB,                          
     @ID_MAKE_JOB_TEMP=ID_MAKE_JOB_ID,                          
     @ID_WAREHOUSE_TEMP= ID_WAREHOUSE   
     ,@ID_JOB_DEB = ID_CUST_WO  
   FROM @TEMPTABLE              
   WHERE SLNO = @ROWLOOP +1    
      
   EXEC USP_VATDIS_VIEW @ID_WO_NO_TEMP, @ID_WO_PREFIX_TEMP, @ID_JOB_ID, @ID_ITEM_JOB_TEMP,        
     @ID_MAKE_JOB_TEMP,@ID_WAREHOUSE_TEMP, @ID_JOB_DEB,      
        @DISTEMP OUTPUT , @VATTEMP OUTPUT, @RT_DISC_SEQ OUTPUT, @RT_VAT_SEQ  OUTPUT                                  
    
                      
   update    @TEMPTABLE                              
   SET   
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

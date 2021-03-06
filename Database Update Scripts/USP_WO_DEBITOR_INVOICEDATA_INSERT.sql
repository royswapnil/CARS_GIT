/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT]    Script Date: 11/15/2017 11:41:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT]    Script Date: 11/15/2017 11:41:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT] AS' 
END
GO
-- =============================================            
-- AUTHOR:  Smita            
-- CREATE DATE: 09/10/2013            
-- DESCRIPTION: To insert data per debitor for per spares and labour            
-- =============================================            
ALTER PROCEDURE [dbo].[USP_WO_DEBITOR_INVOICEDATA_INSERT]             
    @IV_ID_WO_PREFIX    VARCHAR(3),                        
    @IV_ID_JOB_ID       INT,                        
    @IV_ID_WO_NO        VARCHAR(10),                         
    @IV_CREATED_BY      VARCHAR(20)            
AS            
BEGIN            
            
 SET NOCOUNT ON;            
            
            
DELETE FROM TBL_WO_DEBTOR_INVOICE_DATA WHERE            
ID_WO_NO=@IV_ID_WO_NO AND             
 ID_WO_PREFIX=@IV_ID_WO_PREFIX AND ID_JOB_ID=@IV_ID_JOB_ID            
            
IF @IV_ID_JOB_ID=0            
BEGIN            
            
--FOR SPARES            
 INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA            
 (            
 DEBTOR_ID            
 ,LINE_TYPE            
 ,LINE_ID            
 ,PRICE            
 ,LINE_AMOUNT_NET            
 ,LINE_DISCOUNT            
 ,LINE_AMOUNT            
 ,LINE_VAT_PERCENTAGE            
 ,LINE_VAT_AMOUNT            
 ,ID_WO_PREFIX            
 ,ID_WO_NO            
 ,ID_JOB_ID            
 ,CREATED_BY            
 ,DT_CREATED            
 ,ID_WOITEM_SEQ           
 ,DISC_PERCENT          
 ,DEL_QTY           
 )            
  SELECT            
      ISNULL(WOJOBDET.ID_CUST_WO ,0),            
      'SPARES',            
      WOJOBDET.ID_ITEM_JOB,            
      WOJOBDET.JOBI_SELL_PRICE ,             
        CAST(ISNULL(ISNULL(WOJOBDET.JOBI_DELIVER_QTY,0) * (WOJOBDET.JOBI_SELL_PRICE),0) AS NUMERIC(15,2)),                         
   CAST(ISNULL(WOJOBDET.JOBI_DELIVER_QTY,0) * (WOJOBDET.JOBI_SELL_PRICE) * ((   CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOBDET.JOBI_DIS_PER          
 Else          
   CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
  WODEB.DBT_DIS_PER         
ELSE          
  WODEB.CUST_DISC_SPARES         
 END         
End) / 100)  AS NUMERIC(15,2)),             
   CAST(CAST(ISNULL(ISNULL(WOJOBDET.JOBI_DELIVER_QTY,0) * (WOJOBDET.JOBI_SELL_PRICE),0) AS NUMERIC(15,2))            
   -CAST(ISNULL(WOJOBDET.JOBI_DELIVER_QTY,0) * (WOJOBDET.JOBI_SELL_PRICE) * ((   CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOBDET.JOBI_DIS_PER          
 Else          
   CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
  WODEB.DBT_DIS_PER         
ELSE          
  WODEB.CUST_DISC_SPARES         
 END         
End) / 100)  AS NUMERIC(15,2))AS NUMERIC(15,2)),            
   WOJOBDET.JOBI_VAT_PER AS LINE_VAT_PERCENTAGE,            
  (CAST(ISNULL(ISNULL(WOJOBDET.JOBI_DELIVER_QTY,0) * (WOJOBDET.JOBI_SELL_PRICE),0) AS NUMERIC(15,2)) - CAST(ISNULL(WOJOBDET.JOBI_DELIVER_QTY,0) * (WOJOBDET.JOBI_SELL_PRICE) * ((   CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOBDET.JOBI_DIS_PER          
 Else          
   CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
  WODEB.DBT_DIS_PER         
ELSE          
  WODEB.CUST_DISC_SPARES         
 END         
End) / 100)  AS NUMERIC(15,2))) * (JOBI_VAT_PER / 100),              
   WODET.ID_WO_PREFIX ,             
   WODET.ID_WO_NO ,             
   0,               
   @IV_CREATED_BY,            
   GETDATE(),            
   WOJOBDET.ID_WOITEM_SEQ AS ID_WOITEM_SEQ ,          
   CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOBDET.JOBI_DIS_PER          
 Else          
   CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
  WODEB.DBT_DIS_PER         
ELSE          
  WODEB.CUST_DISC_SPARES         
 END         
End,          
 WOJOBDET.JOBI_DELIVER_QTY          
              
  FROM TBL_WO_DETAIL WODET                                                            
    INNER JOIN            
    TBL_WO_JOB_DETAIL WOJOBDET                                                                   
    ON  WODET.ID_WO_PREFIX = WOJOBDET.ID_WO_PREFIX AND            
    WODET.ID_WO_NO  = WOJOBDET.ID_WO_NO           
    INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB          
    ON WODEB.ID_WO_NO=WODET.ID_WO_NO            
 AND WODEB.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
 AND WODEB.ID_JOB_ID=WODET.ID_JOB                    
    WHERE WODET.ID_WO_NO  = @IV_ID_WO_NO AND            
    WODET.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND WODET.ID_JOB = @IV_ID_JOB_ID                
                
 END            
ELSE            
BEGIN            
--FOR SPARES            
SELECT            
 WODEB.ID_DBT_SEQ AS ID_DBT_SEQ            
,WODEB.ID_JOB_DEB AS ID_JOB_DEB            
,'SPARES' AS 'TYPE'            
,WOJOB.ID_ITEM_JOB AS ID_ITEM_JOB            
            
,CASE WHEN CUST.COSTPRICE>0 AND WOJOB.SPARE_TYPE<>'EFD'AND ISNULL(WOJOB.FLG_EDIT_SP,0) = 0             
     THEN            
            
      ISNULL((ISNULL(WOJOB.JOBI_COST_PRICE,0)+ISNULL(ISNULL(WOJOB.JOBI_COST_PRICE,0)*ISNULL((CUST.COSTPRICE)/100,0),0))*(DBT_PER/100),0)            
     ELSE            
   ISNULL(WOJOB.JOBI_SELL_PRICE,0) * (DBT_PER / 100)              
 END AS 'PRICE'            
,CASE WHEN DBT_PER>0 THEN            
  CASE WHEN CUST.COSTPRICE >0 AND WOJOB.SPARE_TYPE<>'EFD' AND ISNULL(WOJOB.FLG_EDIT_SP,0) = 0            
   THEN            
    ISNULL(CAST(ROUND(ISNULL((ISNULL(WOJOB.JOBI_COST_PRICE,0)+ISNULL(ISNULL(WOJOB.JOBI_COST_PRICE,0)*ISNULL((CUST.COSTPRICE)/100,0),0))*ISNULL(WOJOB.JOBI_DELIVER_QTY,0) * (DBT_PER / 100),0),5) AS NUMERIC(15,2)),0)            
         ELSE            
           CAST(ISNULL(WOJOB.JOBI_SELL_PRICE,0)*ISNULL(WOJOB.JOBI_DELIVER_QTY,0) * (DBT_PER / 100) AS NUMERIC(15,2))            
         END            
ELSE            
   0            
 END AS 'SPAREAMOUNT'            
,             
                  
         CASE WHEN CUST.COSTPRICE >0 AND WOJOB.SPARE_TYPE<>'EFD' AND ISNULL(WOJOB.FLG_EDIT_SP,0) = 0            
             THEN            
           (ISNULL(WOJOB.JOBI_COST_PRICE,0)+ISNULL(ISNULL(WOJOB.JOBI_COST_PRICE,0)*ISNULL((CUST.COSTPRICE)/100,0),0))*(WOJOB.JOBI_DELIVER_QTY)*((        
     CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOB.JOBI_DIS_PER          
 Else         
 CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
  WODEB.DBT_DIS_PER         
ELSE          
  WODEB.CUST_DISC_SPARES         
 END         
 End)/100)* (DBT_PER / 100)            
          ELSE            
          CAST(((ISNULL(WOJOB.JOBI_SELL_PRICE,0)*ISNULL(WOJOB.JOBI_DELIVER_QTY,0) )*(   CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOB.JOBI_DIS_PER          
 Else         
 CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
  WODEB.DBT_DIS_PER         
ELSE          
  CASE WHEN WODEB.CUST_DISC_SPARES  > 0    
  THEN WODEB.CUST_DISC_SPARES    
  ELSE    
  WOJOB.JOBI_DIS_PER    
  END    
         
 END         
 End)/100)* (DBT_PER / 100) AS NUMERIC(13,2))            
          END            
              
                 
 AS 'DISCOUNT'            
, WODET.WO_VAT_PERCENTAGE  AS WO_VAT_PERCENTAGE            
,@IV_ID_WO_PREFIX  AS ID_WO_PREFIX            
,@IV_ID_JOB_ID  AS ID_JOB_ID                      
,@IV_ID_WO_NO AS ID_WO_NO            
,WOJOB.ID_WOITEM_SEQ AS ID_WOITEM_SEQ            
,          
   CASE WHEN WODEB.CUST_TYPE = 'OHC'          
 THEN          
  WOJOB.JOBI_DIS_PER          
 Else         
  CASE WHEN WODEB.DBT_DIS_PER > 0         
 THEN        
   WODEB.DBT_DIS_PER         
 ELSE     
  CASE WHEN WODEB.CUST_DISC_SPARES  > 0    
  THEN WODEB.CUST_DISC_SPARES    
  ELSE    
   WOJOB.JOBI_DIS_PER    
  END       
       
  END         
 End AS 'DISC_PERCENT'    
           
,WOJOB.JOBI_DELIVER_QTY AS 'DEL_QTY'          
INTO #TBL_WO_DEBTOR_INVOICE_DATA            
FROM TBL_WO_DEBITOR_DETAIL WODEB            
            
INNER JOIN TBL_WO_DETAIL WODET            
ON WODEB.ID_WO_NO=WODET.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=WODET.ID_JOB            
            
INNER JOIN TBL_WO_JOB_DETAIL WOJOB            
ON WODET.ID_WO_NO=WOJOB.ID_WO_NO            
AND WODET.ID_WO_PREFIX=WOJOB.ID_WO_PREFIX            
AND WODET.ID_WODET_SEQ=WOJOB.ID_WODET_SEQ_JOB            
            
LEFT OUTER JOIN TBL_MAS_CUSTOMER CUST ON            
CUST.ID_CUSTOMER =  WODEB.ID_JOB_DEB             
           
                  
               
             
WHERE WODEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND WODEB.ID_WO_NO=@IV_ID_WO_NO            
AND WODEB.ID_JOB_ID=@IV_ID_JOB_ID            
              
            
INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA            
(            
 DEBTOR_SEQ            
,DEBTOR_ID            
,LINE_TYPE            
,LINE_ID            
,PRICE            
,LINE_AMOUNT_NET            
,LINE_DISCOUNT            
,LINE_AMOUNT            
,LINE_VAT_PERCENTAGE            
,LINE_VAT_AMOUNT            
,ID_WO_PREFIX            
,ID_WO_NO            
,ID_JOB_ID            
,CREATED_BY            
,DT_CREATED            
,ID_WOITEM_SEQ           
,DISC_PERCENT           
,DEL_QTY       
,JOBSUM          
)            
SELECT             
ID_DBT_SEQ            
,ID_JOB_DEB            
,[TYPE]            
,ID_ITEM_JOB            
,PRICE            
,SPAREAMOUNT            
,DISCOUNT            
,(SPAREAMOUNT-DISCOUNT)            
,WO_VAT_PERCENTAGE            
,((SPAREAMOUNT-DISCOUNT)*0.01*WO_VAT_PERCENTAGE)            
,@IV_ID_WO_PREFIX           
,@IV_ID_WO_NO                        
,@IV_ID_JOB_ID                        
,@IV_CREATED_BY            
,GETDATE()            
,ID_WOITEM_SEQ           
 ,DISC_PERCENT          
 ,DEL_QTY       
 ,0         
FROM             
#TBL_WO_DEBTOR_INVOICE_DATA             
            
UPDATE TBL_WO_DEBTOR_INVOICE_DATA             
SET LINE_VAT_AMOUNT=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN WODEB.WO_VAT_PERCENTAGE=1.00 THEN            
      (SELECT ISNULL(SUM(INV.LINE_VAT_AMOUNT),0) FROM TBL_WO_DEBTOR_INVOICE_DATA INV            
      WHERE             
      INV.ID_WOITEM_SEQ=INVDATA.ID_WOITEM_SEQ)            
  ELSE            
  0            
  END            
  ELSE            
  LINE_VAT_AMOUNT            
            
END,            
LINE_VAT_PERCENTAGE=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN WODEB.WO_VAT_PERCENTAGE=1.00 THEN            
      LINE_VAT_PERCENTAGE            
  ELSE            
  0            
  END            
    ELSE            
  LINE_VAT_PERCENTAGE            
END            
FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA            
INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB            
ON WODEB.ID_WO_NO=INVDATA.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=INVDATA.ID_JOB_ID            
AND WODEB.ID_DBT_SEQ=INVDATA.DEBTOR_SEQ            
            
INNER JOIN TBL_WO_DETAIL WODET            
ON INVDATA.ID_WO_NO=WODET.ID_WO_NO            
AND INVDATA.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND INVDATA.ID_JOB_ID=WODET.ID_JOB            
WHERE INVDATA.LINE_TYPE='SPARES'            
AND INVDATA.LINE_TYPE=INVDATA.LINE_TYPE            
AND INVDATA.ID_WO_NO=@IV_ID_WO_NO            
AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND  INVDATA.ID_JOB_ID=@IV_ID_JOB_ID            
            
--FOR LABOUR            
INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA            
(            
 DEBTOR_SEQ            
,DEBTOR_ID            
,LINE_TYPE            
,LINE_ID            
,PRICE            
,LINE_AMOUNT_NET            
,LINE_DISCOUNT            
,LINE_AMOUNT            
,LINE_VAT_PERCENTAGE            
,LINE_VAT_AMOUNT            
,ID_WO_PREFIX            
,ID_WO_NO            
,ID_JOB_ID            
,CREATED_BY            
,DT_CREATED            
,FIXED_PRICE            
,FIXED_PRICE_VAT           
,DISC_PERCENT          
,DEL_QTY      
,JOBSUM  
,ID_WOLAB_SEQ          
)            
SELECT            
 WODEB.ID_DBT_SEQ            
,WODEB.ID_JOB_DEB            
,'LABOUR'            
--,''            
,WLD.ID_LOGIN          
--,WODET.WO_HOURLEY_PRICE            
,(WODEB.DBT_PER*0.01) * WLD.WO_HOURLEY_PRICE          
,(WODEB.DBT_PER*0.01) * WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE           
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
(WODEB.DBT_PER*0.01) * WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WLD.WO_LAB_DISCOUNT*0.01          
Else         
CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 (WODEB.DBT_PER*0.01) * WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WODEB.DBT_DIS_PER*0.01          
ELSE         
 (WODEB.DBT_PER*0.01) * WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WODEB.CUST_DISC_LABOUR*0.01          
End          
END         
--,WODEB.LABOUR_DISCOUNT           
          
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
(WODEB.DBT_PER*0.01) * ((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE ) - (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WLD.WO_LAB_DISCOUNT*0.01 ))          
Else          
CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 (WODEB.DBT_PER*0.01) * ((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE ) - (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WODEB.DBT_DIS_PER*0.01))          
ELSE         
 (WODEB.DBT_PER*0.01) * ((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE ) - (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WODEB.CUST_DISC_LABOUR*0.01))          
End          
End          
          
--,ISNULL(((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE )-WODEB.LABOUR_DISCOUNT),0)            
          
          
, WODET.WO_VAT_PERCENTAGE           
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
(WODEB.DBT_PER*0.01) * (((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE ) - (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WLD.WO_LAB_DISCOUNT*0.01 ))*(WODET.WO_VAT_PERCENTAGE *0.01))          
Else        
CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 (WODEB.DBT_PER*0.01) * (((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE ) - (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WODEB.DBT_DIS_PER*0.01))*(WODET.WO_VAT_PERCENTAGE *0.01))          
ELSE           
 (WODEB.DBT_PER*0.01) * (((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE ) - (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE * WODEB.CUST_DISC_LABOUR*0.01))*(WODET.WO_VAT_PERCENTAGE *0.01))          
End         
END           
           
--,(ISNULL(((WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE )-WODEB.LABOUR_DISCOUNT),0))*0.01*(WODET.WO_VAT_PERCENTAGE)          
,@IV_ID_WO_PREFIX             
,@IV_ID_WO_NO                        
,@IV_ID_JOB_ID                        
,@IV_CREATED_BY              
,GETDATE()            
,(WODET.WO_FIXED_PRICE)*0.01*WODEB.DBT_PER            
,CASE WHEN WODET.WO_FIXED_PRICE<>0 THEN            
(WODET.WO_TOT_VAT_AMT)*0.01*WODEB.DBT_PER            
ELSE            
0            
END           
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
 WLD.WO_LAB_DISCOUNT          
Else         
CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 WODEB.DBT_DIS_PER          
ELSE         
 WODEB.CUST_DISC_LABOUR          
End         
END         
,WLD.WO_LABOUR_HOURS        
,0  
,WLD.ID_WOLAB_SEQ          
FROM TBL_WO_DEBITOR_DETAIL WODEB            
INNER JOIN TBL_WO_DETAIL WODET            
ON WODEB.ID_WO_NO=WODET.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=WODET.ID_JOB           
INNER JOIN TBL_WO_LABOUR_DETAIL WLD          
ON WLD.ID_WODET_SEQ =  WODET.ID_WODET_SEQ           
WHERE WODEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND WODEB.ID_WO_NO=@IV_ID_WO_NO            
AND WODEB.ID_JOB_ID=@IV_ID_JOB_ID            
--GROUP BY WODEB.ID_DBT_SEQ,WODEB.ID_JOB_DEB,WODET.WO_HOURLEY_PRICE,WODET.WO_VAT_PERCENTAGE,WODEB.JOB_VAT_AMOUNT            
--,WODEB.LABOUR_AMOUNT,WODEB.LABOUR_DISCOUNT,WODET.WO_FIXED_PRICE,WODEB.DBT_PER,WODET.WO_TOT_VAT_AMT            
            
            
UPDATE TBL_WO_DEBTOR_INVOICE_DATA             
SET LINE_VAT_AMOUNT=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN (WODEB.WO_VAT_PERCENTAGE=1.00 AND WODEB.CUST_TYPE <> 'MISC')  THEN            
        (SELECT ISNULL(SUM(INV.LINE_VAT_AMOUNT),0) FROM TBL_WO_DEBTOR_INVOICE_DATA INV      
          
 WHERE             
      INV.ID_WO_NO=INVDATA.ID_WO_NO            
      AND INV.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX            
      AND  INV.ID_JOB_ID=INVDATA.ID_JOB_ID        
   AND INV.ID_WOLAB_SEQ=INVDATA.ID_WOLAB_SEQ    
      AND INV.LINE_TYPE='LABOUR')            
  ELSE            
  0            
  END            
ELSE            
  LINE_VAT_AMOUNT            
END            
,            
LINE_VAT_PERCENTAGE=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN WODEB.WO_VAT_PERCENTAGE=1.00 THEN            
      LINE_VAT_PERCENTAGE            
  ELSE            
  0            
  END            
ELSE            
  LINE_VAT_PERCENTAGE            
END,            
            
 FIXED_PRICE_VAT=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN (WODEB.WO_VAT_PERCENTAGE=1.00 AND WODEB.CUST_TYPE <> 'MISC') THEN            
        (SELECT ISNULL(SUM(INV.FIXED_PRICE_VAT),0) FROM TBL_WO_DEBTOR_INVOICE_DATA INV            
      WHERE             
      INV.ID_WO_NO=INVDATA.ID_WO_NO            
      AND INV.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX            
      AND  INV.ID_JOB_ID=INVDATA.ID_JOB_ID     
   AND INV.ID_WOLAB_SEQ=INVDATA.ID_WOLAB_SEQ         
      AND INV.LINE_TYPE='LABOUR')            
  ELSE            
  0            
  END            
ELSE            
  FIXED_PRICE_VAT            
END            
, FIXED_PRICE=            
CASE WHEN WODET.WO_OWN_RISK_AMT>0 and WODET.WO_FIXED_PRICE<>0  THEN            
  CASE WHEN WODEB.OWN_RISK_AMOUNT>0 THEN            
    FIXED_PRICE+ WODET.WO_OWN_RISK_AMT            
  ELSE            
  FIXED_PRICE-( WODET.WO_OWN_RISK_AMT)*0.01*WODEB.DBT_PER            
  END            
ELSE            
  FIXED_PRICE            
END            
FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA            
INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB            
ON WODEB.ID_WO_NO=INVDATA.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=INVDATA.ID_JOB_ID            
AND WODEB.ID_DBT_SEQ=INVDATA.DEBTOR_SEQ            
            
INNER JOIN TBL_WO_DETAIL WODET            
ON INVDATA.ID_WO_NO=WODET.ID_WO_NO            
AND INVDATA.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND INVDATA.ID_JOB_ID=WODET.ID_JOB            
WHERE INVDATA.LINE_TYPE='LABOUR'            
AND INVDATA.LINE_TYPE=INVDATA.LINE_TYPE            
AND INVDATA.ID_WO_NO=@IV_ID_WO_NO            
AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND  INVDATA.ID_JOB_ID=@IV_ID_JOB_ID            
            
--FOR GM            
INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA            
(            
 DEBTOR_SEQ            
,DEBTOR_ID            
,LINE_TYPE            
,LINE_ID            
,PRICE            
,LINE_AMOUNT_NET            
,LINE_DISCOUNT            
,LINE_AMOUNT            
,LINE_VAT_PERCENTAGE            
,LINE_VAT_AMOUNT            
,ID_WO_PREFIX            
,ID_WO_NO            
,ID_JOB_ID            
,CREATED_BY            
,DT_CREATED          
,DISC_PERCENT       
,JOBSUM  
,ID_WOLAB_SEQ           
)            
SELECT            
 WODEB.ID_DBT_SEQ            
,WODEB.ID_JOB_DEB            
,'GM'            
,''            
--,0            
,(WODEB.DBT_PER*0.01)*(WODET.WO_GM_PER * WODET.WO_HOURLEY_PRICE * 0.01)            
,(WODEB.DBT_PER*0.01) * WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01            
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
(WODEB.DBT_PER*0.01) *(WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WLD.WO_LAB_DISCOUNT*0.01)          
Else          
CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 (WODEB.DBT_PER*0.01) *(WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WODEB.DBT_DIS_PER*0.01)         
Else        
  (WODEB.DBT_PER*0.01) *(WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WODEB.CUST_DISC_LABOUR*0.01)         
 END        
End,        
CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
(WODEB.DBT_PER*0.01) *((WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 ) - (WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WLD.WO_LAB_DISCOUNT*0.01 ))          
Else         
 CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 (WODEB.DBT_PER*0.01) * ((WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 ) - (WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WODEB.DBT_DIS_PER*0.01))          
Else        
 (WODEB.DBT_PER*0.01) * ((WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 ) - (WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WODEB.CUST_DISC_LABOUR*0.01))          
END        
End         
, WODET.WO_VAT_PERCENTAGE            
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
(WODEB.DBT_PER*0.01) *(((WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 ) - (WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WLD.WO_LAB_DISCOUNT*0.01 ))*(WODET.WO_VAT_PERCENTAGE *0.01))          
Else         
 CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
(WODEB.DBT_PER*0.01) *( ((WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 ) - (WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WODEB.DBT_DIS_PER*0.01))*(WODET.WO_VAT_PERCENTAGE *0.01))          
Else        
(WODEB.DBT_PER*0.01) *( ((WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 ) - (WODET.WO_GM_PER * (WLD.WO_LABOUR_HOURS * WLD.WO_HOURLEY_PRICE) * 0.01 * WODEB.CUST_DISC_LABOUR*0.01))*(WODET.WO_VAT_PERCENTAGE *0.01))          
End        
END        
 ,@IV_ID_WO_PREFIX             
,@IV_ID_WO_NO                        
,@IV_ID_JOB_ID                        
,@IV_CREATED_BY            
,GETDATE()          
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
 WLD.WO_LAB_DISCOUNT          
Else         
CASE WHEN WODEB.DBT_DIS_PER > 0         
THEN        
 WODEB.DBT_DIS_PER          
 ELSE         
 WODEB.CUST_DISC_LABOUR          
End         
End       
,0  
,WLD.ID_WOLAB_SEQ         
FROM TBL_WO_DEBITOR_DETAIL WODEB            
INNER JOIN TBL_WO_DETAIL WODET            
ON WODEB.ID_WO_NO=WODET.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=WODET.ID_JOB           
INNER JOIN TBL_WO_LABOUR_DETAIL WLD          
ON WLD.ID_WODET_SEQ =  WODET.ID_WODET_SEQ            
WHERE WODEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND WODEB.ID_WO_NO=@IV_ID_WO_NO            
AND WODEB.ID_JOB_ID=@IV_ID_JOB_ID            
--GROUP BY WODEB.ID_DBT_SEQ,WODEB.ID_JOB_DEB,WODET.WO_HOURLEY_PRICE,WODET.WO_VAT_PERCENTAGE,WODEB.JOB_VAT_AMOUNT            
--,WODEB.GM_AMOUNT,WODEB.GM_DISCOUNT            
            
UPDATE TBL_WO_DEBTOR_INVOICE_DATA             
SET LINE_VAT_AMOUNT=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN (WODEB.WO_VAT_PERCENTAGE=1.00 AND WODEB.CUST_TYPE <> 'MISC') THEN            
        (SELECT ISNULL(SUM(INV.LINE_VAT_AMOUNT),0) FROM TBL_WO_DEBTOR_INVOICE_DATA INV            
      WHERE             
      INV.ID_WO_NO=INVDATA.ID_WO_NO            
      AND INV.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX      
   AND INV.ID_WOLAB_SEQ=INVDATA.ID_WOLAB_SEQ           
   AND INV.ID_JOB_ID=INVDATA.ID_JOB_ID            
      AND INV.LINE_TYPE='GM')            
  ELSE            
  0            
  END            
ELSE            
  LINE_VAT_AMOUNT            
END            
,            
LINE_VAT_PERCENTAGE=            
CASE WHEN WODET.WO_OWN_PAY_VAT=1 THEN            
  CASE WHEN (WODEB.WO_VAT_PERCENTAGE=1.00 AND WODEB.CUST_TYPE <> 'MISC') THEN            
      LINE_VAT_PERCENTAGE            
  ELSE            
  0            
  END            
ELSE            
  LINE_VAT_PERCENTAGE            
END            
FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA            
INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB            
ON WODEB.ID_WO_NO=INVDATA.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=INVDATA.ID_JOB_ID            
AND WODEB.ID_DBT_SEQ=INVDATA.DEBTOR_SEQ            
            
INNER JOIN TBL_WO_DETAIL WODET            
ON INVDATA.ID_WO_NO=WODET.ID_WO_NO            
AND INVDATA.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND INVDATA.ID_JOB_ID=WODET.ID_JOB            
WHERE INVDATA.LINE_TYPE='GM'            
AND INVDATA.LINE_TYPE=INVDATA.LINE_TYPE            AND INVDATA.ID_WO_NO=@IV_ID_WO_NO            
AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND  INVDATA.ID_JOB_ID=@IV_ID_JOB_ID       
      
      
--For OWNRISK      
      
            
INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA            
(            
 DEBTOR_SEQ            
,DEBTOR_ID            
,LINE_TYPE            
,LINE_ID            
,PRICE            
,LINE_AMOUNT_NET            
,LINE_DISCOUNT            
,LINE_AMOUNT            
,LINE_VAT_PERCENTAGE            
,LINE_VAT_AMOUNT            
,ID_WO_PREFIX            
,ID_WO_NO            
,ID_JOB_ID            
,CREATED_BY            
,DT_CREATED          
,DISC_PERCENT        
,JOBSUM          
)            
SELECT            
 WODEB.ID_DBT_SEQ            
,WODEB.ID_JOB_DEB            
,'OWNRISK'            
,''            
,0            
--,WODET.WO_GM_PER * WODET.WO_HOURLEY_PRICE * 0.01       
      
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
 WODET.WO_OWN_RISK_AMT          
Else         
 CASE WHEN WODEB.CUST_TYPE = 'INSC'          
 THEN        
  -1 * WODET.WO_OWN_RISK_AMT          
  ELSE       
    CASE WHEN WODEB.OWN_RISK_AMOUNT > 0 THEN       
  WODET.WO_OWN_RISK_AMT       
  ELSE      
  0      
  END      
 End         
End             
          
,0      
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
 WODET.WO_OWN_RISK_AMT          
Else         
 CASE WHEN WODEB.CUST_TYPE = 'INSC'          
 THEN        
  -1 * WODET.WO_OWN_RISK_AMT          
  ELSE       
    CASE WHEN WODEB.OWN_RISK_AMOUNT > 0 THEN       
  WODET.WO_OWN_RISK_AMT       
  ELSE      
  0      
  END      
 End         
End            
, 0            
,0       
,@IV_ID_WO_PREFIX             
,@IV_ID_WO_NO                        
,@IV_ID_JOB_ID                        
,@IV_CREATED_BY            
,GETDATE()          
,0       
,0         
FROM TBL_WO_DEBITOR_DETAIL WODEB            
INNER JOIN TBL_WO_DETAIL WODET            
ON WODEB.ID_WO_NO=WODET.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=WODET.ID_JOB           
WHERE WODEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND WODEB.ID_WO_NO=@IV_ID_WO_NO            
AND WODEB.ID_JOB_ID=@IV_ID_JOB_ID       
  
  
--FOR REDUCTION AMOUNT  
INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA            
(            
 DEBTOR_SEQ            
,DEBTOR_ID            
,LINE_TYPE            
,LINE_ID            
,PRICE            
,LINE_AMOUNT_NET            
,LINE_DISCOUNT            
,LINE_AMOUNT            
,LINE_VAT_PERCENTAGE            
,LINE_VAT_AMOUNT            
,ID_WO_PREFIX            
,ID_WO_NO            
,ID_JOB_ID            
,CREATED_BY            
,DT_CREATED          
,DISC_PERCENT        
,JOBSUM          
)            
SELECT            
 WODEB.ID_DBT_SEQ            
,WODEB.ID_JOB_DEB            
,'REDUCTION'            
,''            
,0            
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
 WODEB.REDUCTION_AMOUNT       
Else         
  -1 * WODEB.REDUCTION_AMOUNT   
End             
,0      
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
 WODEB.REDUCTION_AMOUNT       
Else         
  -1 * WODEB.REDUCTION_AMOUNT   
End             
,WODET.WO_VAT_PERCENTAGE              
,CASE WHEN WODEB.CUST_TYPE = 'OHC'          
THEN          
  0.01 * WODET.WO_VAT_PERCENTAGE * WODEB.REDUCTION_AMOUNT       
Else         
  -1 * (0.01 * WODET.WO_VAT_PERCENTAGE * WODEB.REDUCTION_AMOUNT)   
End       
,@IV_ID_WO_PREFIX             
,@IV_ID_WO_NO                        
,@IV_ID_JOB_ID                        
,@IV_CREATED_BY            
,GETDATE()          
,0       
,0         
FROM TBL_WO_DEBITOR_DETAIL WODEB            
INNER JOIN TBL_WO_DETAIL WODET            
ON WODEB.ID_WO_NO=WODET.ID_WO_NO            
AND WODEB.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
AND WODEB.ID_JOB_ID=WODET.ID_JOB           
WHERE WODEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
AND WODEB.ID_WO_NO=@IV_ID_WO_NO            
AND WODEB.ID_JOB_ID=@IV_ID_JOB_ID     
      
      
IF EXISTS(SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO =@IV_ID_WO_NO AND ID_WO_PREFIX= @IV_ID_WO_PREFIX AND ID_JOB_ID = @IV_ID_JOB_ID AND CUST_TYPE = 'MISC' AND OWN_RISK_AMOUNT > 0)      
BEGIN      
 UPDATE TBL_WO_DEBTOR_INVOICE_DATA             
 SET LINE_AMOUNT_NET=  0,      
 LINE_AMOUNT = 0      
         
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA            
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB            
 ON WODEB.ID_WO_NO=INVDATA.ID_WO_NO            
 AND WODEB.ID_WO_PREFIX=INVDATA.ID_WO_PREFIX            
 AND WODEB.ID_JOB_ID=INVDATA.ID_JOB_ID            
 AND WODEB.ID_DBT_SEQ=INVDATA.DEBTOR_SEQ            
             
 INNER JOIN TBL_WO_DETAIL WODET            
 ON INVDATA.ID_WO_NO=WODET.ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=WODET.ID_WO_PREFIX            
 AND INVDATA.ID_JOB_ID=WODET.ID_JOB            
 WHERE INVDATA.LINE_TYPE='OWNRISK'            
 AND INVDATA.LINE_TYPE=INVDATA.LINE_TYPE            
 AND INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
 AND  INVDATA.ID_JOB_ID=@IV_ID_JOB_ID       
 AND WODEB.CUST_TYPE = 'OHC'       
      
 END       
       
 DECLARE @RED_AMT DECIMAL(13,2)      
 SELECT @RED_AMT = 0--REDUCTION_AMOUNT FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX  AND ID_JOB_ID = @IV_ID_JOB_ID      
    
 --SELECT @RED_AMT      
  --JOBSUM       
 SELECT INVDATA.DEBTOR_ID ,INVDATA.ID_WO_NO, INVDATA.ID_WO_PREFIX,INVDATA.ID_JOB_ID ,SUM(INVDATA.LINE_AMOUNT) AS LINE_AMOUNT       
 INTO #TEMPDEBTORINVDATA        
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO          
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
 AND  INVDATA.ID_JOB_ID=@IV_ID_JOB_ID       
 Group by INVDATA.DEBTOR_ID,INVDATA.ID_WO_NO, INVDATA.ID_WO_PREFIX,INVDATA.ID_JOB_ID     
     
     
     
 --select '#TEMPDEBTORINVDATA', * from #TEMPDEBTORINVDATA    
     
     
 UPDATE TEMP        
 SET LINE_AMOUNT =  TEMP.LINE_AMOUNT + @RED_AMT     
 FROM #TEMPDEBTORINVDATA TEMP     
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = TEMP.ID_WO_NO AND WODEB.ID_WO_PREFIX = TEMP.ID_WO_PREFIX       
 AND WODEB.ID_JOB_ID = TEMP.ID_JOB_ID AND WODEB.ID_JOB_DEB = TEMP.DEBTOR_ID      
 WHERE TEMP.ID_WO_NO=@IV_ID_WO_NO            
 AND TEMP.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
 AND  TEMP.ID_JOB_ID=@IV_ID_JOB_ID    
 AND WODEB.CUST_TYPE = 'OHC'     
     
     
 UPDATE TEMP        
 SET LINE_AMOUNT =  TEMP.LINE_AMOUNT - @RED_AMT     
 FROM #TEMPDEBTORINVDATA TEMP     
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = TEMP.ID_WO_NO AND WODEB.ID_WO_PREFIX = TEMP.ID_WO_PREFIX       
 AND WODEB.ID_JOB_ID = TEMP.ID_JOB_ID    
 AND WODEB.ID_JOB_DEB = TEMP.DEBTOR_ID       
  WHERE TEMP.ID_WO_NO=@IV_ID_WO_NO            
 AND TEMP.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
 AND  TEMP.ID_JOB_ID=@IV_ID_JOB_ID    
 AND WODEB.CUST_TYPE = 'INSC'     
     
       
        
 UPDATE INVDATA        
 SET JOBSUM=  TEMP.LINE_AMOUNT      
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
  INNER JOIN  #TEMPDEBTORINVDATA TEMP      
 ON INVDATA.ID_WO_NO = TEMP.ID_WO_NO AND INVDATA.ID_WO_PREFIX = TEMP.ID_WO_PREFIX       
 AND INVDATA.ID_JOB_ID = TEMP.ID_JOB_ID AND INVDATA.DEBTOR_ID = TEMP.DEBTOR_ID       
  WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX            
 AND  INVDATA.ID_JOB_ID=@IV_ID_JOB_ID       
        
        
 --INVOICESUM    
 SELECT distinct jobsum,id_wo_no,id_wo_prefix,id_job_id,debtor_id       
 INTO #TEMPDEBTORINVSUMDATA        
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO          
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX  
 
 --select '#TEMPDEBTORINVSUMDATA', * from #TEMPDEBTORINVSUMDATA          
    
     
     
 SELECT SUM(JOBSUM)AS JOBSUM,debtor_id,id_wo_no,id_wo_prefix    
 into #InvoiceSum    
  from #TEMPDEBTORINVSUMDATA    
 WHERE ID_WO_NO=@IV_ID_WO_NO            
 AND ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by debtor_id,id_wo_no,id_wo_prefix    
     
   --select '#InvoiceSum  ',* from #InvoiceSum    
   
 -- SELECT InvSum.JOBSUM      
 --FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 --INNER JOIN  #InvoiceSum InvSum      
 --ON INVDATA.ID_WO_NO = InvSum.ID_WO_NO AND INVDATA.ID_WO_PREFIX = InvSum.ID_WO_PREFIX       
 --AND INVDATA.DEBTOR_ID = InvSum.DEBTOR_ID       
 --WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 --AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX 
     
     
 UPDATE INVDATA        
 SET INVOICESUM =  InvSum.JOBSUM      
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #InvoiceSum InvSum      
 ON INVDATA.ID_WO_NO = InvSum.ID_WO_NO AND INVDATA.ID_WO_PREFIX = InvSum.ID_WO_PREFIX       
 AND INVDATA.DEBTOR_ID = InvSum.DEBTOR_ID       
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX       
           
 --CALCUALTEDFROM    
     
 -- SELECT distinct invoicesum,id_wo_no,id_wo_prefix      
 --INTO #TEMPDEBTORCALCFROM        
 --FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 --WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO          
 --AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
    
--JOBVAT  
 SELECT DISTINCT LINE_VAT_AMOUNT,ID_WO_NO,ID_WO_PREFIX,ID_JOB_ID,DEBTOR_ID       
 INTO #TEMPDEBTORVATSUMDATA        
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO          
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX        
  
 SELECT SUM(LINE_VAT_AMOUNT)AS JOBVAT,DEBTOR_ID,ID_WO_NO,ID_WO_PREFIX,ID_JOB_ID    
 INTO #JOBVAT    
 FROM #TEMPDEBTORVATSUMDATA    
 WHERE ID_WO_NO=@IV_ID_WO_NO            
 AND ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 GROUP BY DEBTOR_ID,ID_WO_NO,ID_WO_PREFIX,ID_JOB_ID     
  
 UPDATE INVDATA        
 SET JOBVAT =  VATSUM.JOBVAT      
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #JOBVAT VATSUM      
 ON INVDATA.ID_WO_NO = VATSUM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = VATSUM.ID_WO_PREFIX       
 AND INVDATA.DEBTOR_ID = VATSUM.DEBTOR_ID AND INVDATA.ID_JOB_ID = VATSUM.ID_JOB_ID      
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX     
     
 SELECT (SUM(LINE_VAT_AMOUNT) * 4) + @RED_AMT AS CALCUALTEDFROM,Sum(LINE_VAT_AMOUNT)+ (@RED_AMT* 0.25)  AS VAT_AMT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #CALCUALTEDFROM    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'OHC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
 SELECT (SUM(LINE_VAT_AMOUNT) * 4) + @RED_AMT AS CALCUALTEDFROM,Sum(LINE_VAT_AMOUNT)+ (@RED_AMT* 0.25)  AS VAT_AMT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #CALCUALTEDFROMINTC    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'INTC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
 SELECT (SUM(LINE_VAT_AMOUNT) * 4) + @RED_AMT AS CALCUALTEDFROM,Sum(LINE_VAT_AMOUNT)+ (@RED_AMT* 0.25)  AS VAT_AMT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #CALCUALTEDFROMCLA    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'CLA' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
     
     
 SELECT DISTINCT (SUM(LINE_VAT_AMOUNT) * 4) - @RED_AMT AS CALCUALTEDFROM,Sum(LINE_VAT_AMOUNT)- (@RED_AMT* 0.25)  AS VAT_AMT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #CALCUALTEDFROMINSC    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'INSC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
 IF EXISTS(SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO =@IV_ID_WO_NO AND ID_WO_PREFIX= @IV_ID_WO_PREFIX  AND CUST_TYPE = 'MISC')      
BEGIN     
IF NOT EXISTS(SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO =@IV_ID_WO_NO AND ID_WO_PREFIX= @IV_ID_WO_PREFIX  AND CUST_TYPE = 'INSC')     
BEGIN    
 SELECT DISTINCT (SUM(LINE_VAT_AMOUNT) * 4) - @RED_AMT AS CALCUALTEDFROM,Sum(LINE_VAT_AMOUNT)- (@RED_AMT* 0.25)  AS VAT_AMT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #CALCUALTEDFROMMISC    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'MISC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
  UPDATE INVDATA        
 SET CALCULATEDFROM =  CFrom.CALCUALTEDFROM     
 ,FINDVAT =  CFrom.VAT_AMT    
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #CALCUALTEDFROMMISC CFrom      
 ON INVDATA.ID_WO_NO = CFrom.ID_WO_NO AND INVDATA.ID_WO_PREFIX = CFrom.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = Cfrom.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = CFrom.ID_WO_NO AND WODEB.ID_WO_PREFIX = CFrom.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = CFrom.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'MISC'    
     
     
END    
    
END    
     
      
     
 UPDATE INVDATA        
 SET CALCULATEDFROM =  CFrom.CALCUALTEDFROM     
 ,FINDVAT =  CFrom.VAT_AMT    
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #CALCUALTEDFROM CFrom      
 ON INVDATA.ID_WO_NO = CFrom.ID_WO_NO AND INVDATA.ID_WO_PREFIX = CFrom.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = Cfrom.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = CFrom.ID_WO_NO AND WODEB.ID_WO_PREFIX = CFrom.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = CFrom.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'OHC'    
     
 UPDATE INVDATA        
 SET CALCULATEDFROM =  CFrom.CALCUALTEDFROM     
 ,FINDVAT =  CFrom.VAT_AMT    
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #CALCUALTEDFROMINSC CFrom      
 ON INVDATA.ID_WO_NO = CFrom.ID_WO_NO AND INVDATA.ID_WO_PREFIX = CFrom.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = Cfrom.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = CFrom.ID_WO_NO AND WODEB.ID_WO_PREFIX = CFrom.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = CFrom.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'INSC'    
     
     
  UPDATE INVDATA        
 SET CALCULATEDFROM =  CFrom.CALCUALTEDFROM     
 ,FINDVAT =  CFrom.VAT_AMT    
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #CALCUALTEDFROMINTC CFrom      
 ON INVDATA.ID_WO_NO = CFrom.ID_WO_NO AND INVDATA.ID_WO_PREFIX = CFrom.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = Cfrom.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = CFrom.ID_WO_NO AND WODEB.ID_WO_PREFIX = CFrom.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = CFrom.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'INTC'    
     
     
   UPDATE INVDATA        
 SET CALCULATEDFROM =  CFrom.CALCUALTEDFROM     
 ,FINDVAT =  CFrom.VAT_AMT    
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #CALCUALTEDFROMCLA CFrom      
ON INVDATA.ID_WO_NO = CFrom.ID_WO_NO AND INVDATA.ID_WO_PREFIX = CFrom.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = Cfrom.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = CFrom.ID_WO_NO AND WODEB.ID_WO_PREFIX = CFrom.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = CFrom.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'CLA'    
     
     
     
     
     
 --VAT TRANSFER     
     
 SELECT DISTINCT WODEB.ID_JOB_DEB AS  CUSTOMERID ,WODET.WO_OWN_CR_CUST ,CAST(dbo.fnGetVATTransFromCustID(@IV_ID_WO_NO, @IV_ID_WO_PREFIX) AS VARCHAR(10)) AS 'TRANSFERREDFROMCUSTID',    
CASE WHEN WODEB.ID_JOB_DEB = WODET.WO_OWN_CR_CUST THEN    
CAST(dbo.fnGetVATTransFromCustID(@IV_ID_WO_NO, @IV_ID_WO_PREFIX) AS VARCHAR(10))     
ELSE    
WODET.WO_OWN_CR_CUST    
END    
AS 'RESULTCUSTID',    
WODEB.ID_WO_NO,WODEB.ID_WO_PREFIX,WODEB.ID_JOB_ID    
INTO #TRANDEBITOR    
 FROM TBL_WO_DEBITOR_DETAIL WODEB       
 INNER JOIN TBL_WO_DETAIL WODET ON WODEB.ID_WO_NO = WODET.ID_WO_NO       
 AND WODEB.ID_WO_PREFIX = WODET.ID_WO_PREFIX    
 INNER JOIN TBL_MAS_CUSTOMER CUST ON CUST.ID_CUSTOMER = WODEB.ID_JOB_DEB      
 WHERE WODEB.ID_WO_NO = @IV_ID_WO_NO AND WODEB.ID_WO_PREFIX = @IV_ID_WO_PREFIX    
        
        
 UPDATE INVDATA    
 SET VAT_TRANSFER = temp.RESULTCUSTID    
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
 INNER JOIN #TranDEBITOR temp     
 ON INVDATA.ID_WO_NO = temp.ID_WO_NO    
 AND INVDATA.ID_WO_PREFIX = temp.ID_WO_PREFIX    
 AND INVDATA.ID_JOB_ID = temp.ID_JOB_ID    
 AND INVDATA.DEBTOR_ID = temp.CUSTOMERID     
    
     
    
     
     
     
     
     
    --VATAMOUNT    
 SELECT DISTINCT SUM(LINE_VAT_AMOUNT)AS VATAMOUNT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #VATAMOUNTOHC    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
     
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'OHC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
     
 SELECT DISTINCT SUM(LINE_VAT_AMOUNT)AS VATAMOUNT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #VATAMOUNTINSC    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
     
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'INSC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
      
 SELECT DISTINCT SUM(LINE_VAT_AMOUNT)AS VATAMOUNT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #VATAMOUNTINTC    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
     
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'INTC' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
       
 SELECT DISTINCT SUM(LINE_VAT_AMOUNT)AS VATAMOUNT,    
 INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
 into #VATAMOUNTCLA    
 from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
     
 WHERE     
 INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
 WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'CLA' )    
 AND    
 INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
 group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
     
     
     
  IF EXISTS(SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO =@IV_ID_WO_NO AND ID_WO_PREFIX= @IV_ID_WO_PREFIX  AND CUST_TYPE = 'MISC')      
BEGIN     
IF NOT EXISTS(SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO =@IV_ID_WO_NO AND ID_WO_PREFIX= @IV_ID_WO_PREFIX  AND CUST_TYPE = 'INSC')     
BEGIN    
  SELECT DISTINCT SUM(LINE_VAT_AMOUNT)AS VATAMOUNT,    
  INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
  into #VATAMOUNTMISC    
  from TBL_WO_DEBTOR_INVOICE_DATA INVDATA    
      
  WHERE     
  INVDATA.DEBTOR_ID = ( SELECT DISTINCT ID_JOB_DEB FROM TBL_WO_DEBITOR_DETAIL WODEB     
  WHERE WODEB.ID_WO_NO = INVDATA.ID_WO_NO AND WODEB.ID_WO_PREFIX = INVDATA.ID_WO_PREFIX       
  AND WODEB.ID_JOB_DEB = INVDATA.DEBTOR_ID  and WODEB.CUST_TYPE = 'MISC' )    
  AND    
  INVDATA.ID_WO_NO=@IV_ID_WO_NO            
  AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX    
  group by INVDATA.id_wo_no,INVDATA.id_wo_prefix,INVDATA.debtor_id    
      
 UPDATE INVDATA        
 SET VATAMOUNT =  VATAM.VATAMOUNT     
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #VATAMOUNTMISC VATAM      
 ON INVDATA.ID_WO_NO = VATAM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = VATAM.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = VATAM.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = VATAM.ID_WO_NO AND WODEB.ID_WO_PREFIX = VATAM.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = VATAM.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'MISC'    
      
END    
    
END    
     
     
 UPDATE INVDATA        
 SET VATAMOUNT =  VATAM.VATAMOUNT     
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #VATAMOUNTOHC VATAM      
 ON INVDATA.ID_WO_NO = VATAM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = VATAM.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = VATAM.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = VATAM.ID_WO_NO AND WODEB.ID_WO_PREFIX = VATAM.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = VATAM.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'OHC'    
     
 UPDATE INVDATA        
 SET VATAMOUNT =  VATAM.VATAMOUNT     
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #VATAMOUNTINSC VATAM      
 ON INVDATA.ID_WO_NO = VATAM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = VATAM.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = VATAM.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = VATAM.ID_WO_NO AND WODEB.ID_WO_PREFIX = VATAM.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = VATAM.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'INSC'    
     
     
  UPDATE INVDATA        
 SET VATAMOUNT =  VATAM.VATAMOUNT     
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #VATAMOUNTINTC VATAM      
 ON INVDATA.ID_WO_NO = VATAM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = VATAM.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = VATAM.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = VATAM.ID_WO_NO AND WODEB.ID_WO_PREFIX = VATAM.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = VATAM.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'INTC'    
     
     
   UPDATE INVDATA        
 SET VATAMOUNT =  VATAM.VATAMOUNT     
 FROM TBL_WO_DEBTOR_INVOICE_DATA INVDATA       
 INNER JOIN  #VATAMOUNTCLA VATAM      
 ON INVDATA.ID_WO_NO = VATAM.ID_WO_NO AND INVDATA.ID_WO_PREFIX = VATAM.ID_WO_PREFIX     
 AND INVDATA.DEBTOR_ID = VATAM.DEBTOR_ID    
 INNER JOIN TBL_WO_DEBITOR_DETAIL WODEB     
 ON WODEB.ID_WO_NO = VATAM.ID_WO_NO AND WODEB.ID_WO_PREFIX = VATAM.ID_WO_PREFIX       
 AND WODEB.ID_JOB_DEB = VATAM.DEBTOR_ID         
 WHERE INVDATA.ID_WO_NO=@IV_ID_WO_NO            
 AND INVDATA.ID_WO_PREFIX=@IV_ID_WO_PREFIX      
 AND WODEB.CUST_TYPE = 'CLA'    
     
     
     
     
 --ROUNDED TOTAL    
     
-- SELECT SUM(INVOICESUM + VATAMOUNT)     
        
      
  DROP TABLE #TEMPDEBTORINVSUMDATA      
  DROP TABLE #TEMPDEBTORINVDATA    
  DROP TABLE #InvoiceSum       
  DROP TABLE #CALCUALTEDFROM      
  DROP TABLE #CALCUALTEDFROMINSC    
  --DROP TABLE #CALCUALTEDFROMMISC    
  DROP TABLE #CALCUALTEDFROMINTC    
  DROP TABLE #CALCUALTEDFROMCLA    
  DROP TABLE #VATAMOUNTINSC    
  DROP TABLE #VATAMOUNTOHC    
  --DROP TABLE #VATAMOUNTMISC    
  DROP TABLE #VATAMOUNTINTC    
  DROP TABLE #VATAMOUNTCLA    
  DROP TABLE #TRANDEBITOR    
  DROP TABLE #TEMPDEBTORVATSUMDATA  
  DROP TABLE #JOBVAT  
      
END            
            
END   
GO

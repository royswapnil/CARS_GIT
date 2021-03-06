/****** Object:  StoredProcedure [dbo].[USP_CREATE_DUP_WO]    Script Date: 10/11/2017 5:50:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CREATE_DUP_WO]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CREATE_DUP_WO]
GO
/****** Object:  StoredProcedure [dbo].[USP_CREATE_DUP_WO]    Script Date: 10/11/2017 5:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CREATE_DUP_WO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_CREATE_DUP_WO] AS' 
END
GO
/*************************************** Application: MSG *************************************************************              
* Module : Transactions              
* File name : USP_CREATE_DUP_WO.PRC              
* Purpose : To Load Create duplicate Work Order .               
* Author : Smita m              
* Date  : 11.09.2017              
*********************************************************************************************************************/                
              
ALTER PROCEDURE [dbo].[USP_CREATE_DUP_WO]               
(         
@ID_WO_NO VARCHAR(20),        
@ID_WO_PREFIX VARCHAR(10),        
@CREATED_BY VARCHAR(20),      
@OV_INV_LIST VARCHAR(7000) OUTPUT             
      
        
)        
AS        
BEGIN        
        
 DECLARE @CURR_WO_NO VARCHAR(20)        
 DECLARE @CURR_WO_PREFIX VARCHAR(10)        
 DECLARE @DEPID INT                            
 DECLARE @SUBID INT        
         
 SELECT  @DEPID = ID_DEPT_USER,                          
  @SUBID = ID_SUBSIDERY_USER                             
  FROM    TBL_MAS_USERS                            
  WHERE   ID_LOGIN = @CREATED_BY               
         
 SELECT  @CURR_WO_PREFIX = WO_PREFIX                           
  FROM    TBL_MAS_WO_CONFIGURATION                            
  WHERE   GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                           
  AND  ID_SUBSIDERY_WO = @SUBID                         
  AND  ID_DEPT_WO = @DEPID          
           
 SELECT  @CURR_WO_NO =               
  CASE WHEN WO_CUR_SERIES IS NOT NULL  AND  LEN(WO_CUR_SERIES) > 0         
  THEN                            
            
   (SELECT         
   CAST((MAX(WO_CUR_SERIES) + 1) AS VARCHAR)               
   FROM TBL_MAS_WO_CONFIGURATION               
   WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                           
   AND ID_SUBSIDERY_WO = @SUBID                           
   AND ID_DEPT_WO = @DEPID                            
   GROUP BY WO_CUR_SERIES)              
  ELSE                            
          
   (SELECT          
    CAST((MAX(WO_SERIES) + 1) AS VARCHAR)              
   FROM  TBL_MAS_WO_CONFIGURATION                             
   WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO )                           
   AND ID_SUBSIDERY_WO = @SUBID                           
   AND ID_DEPT_WO = @DEPID                            
   GROUP BY WO_SERIES)                            
  END        
   FROM  TBL_MAS_WO_CONFIGURATION                           
  WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                             
  AND ID_SUBSIDERY_WO = @SUBID               
  AND ID_DEPT_WO = @DEPID        
          
          
 DECLARE @TRANNAME VARCHAR(20);                   
 SELECT @TRANNAME = 'ORDER_INSERT'           
 BEGIN TRANSACTION @TRANNAME          
 SET @OV_INV_LIST = ''                      
                
 INSERT INTO TBL_WO_HEADER        
    SELECT  @CURR_WO_NO,        
   @CURR_WO_PREFIX,        
   ID_Subsidery,        
   ID_Dept,        
   DT_ORDER,        
   'KRE',        
   'JCD',        
   DT_DELIVERY,        
   WO_TM_DELIV,        
   DT_FINISH,        
   ID_PAY_TYPE_WO,        
   ID_PAY_TERMS_WO,        
   WO_ANNOT,        
   ID_CUST_WO,        
   WO_CUST_NAME,        
   WO_CUST_PERM_ADD1,        
   WO_CUST_PERM_ADD2,        
   ID_ZIPCODE_WO,          
   WO_CUST_PHONE_OFF,        
   WO_CUST_PHONE_HOME,        
   WO_CUST_PHONE_MOBILE,        
   WO_CUST_GROUPID,        
   ID_VEH_SEQ_WO,        
   WO_VEH_REG_NO,        
   WO_VEH_INTERN_NO,        
   WO_VEH_VIN,        
   WO_VEH_MAK_MOD_MAP,        
   WO_VEH_MILEAGE,        
   WO_VEH_HRS,        
   WO_PKKDATE,        
   @CREATED_BY,        
   getdate(),        
   NULL,        
   NULL,        
   WO_Planned,        
   BUS_PEK_PREVIOUS_NUM,        
   BUS_PEK_CONTROL_NUM,        
   DELIVERY_CODE,        
   DELIVERY_METHOD,        
   DELIVERY_ADDRESS_NAME,        
   DELIVERY_ADDRESS_LINE1,        
   DELIVERY_ADDRESS_LINE2,        
   DELIVERY_ADDRESS_ZIPCODE,        
   DELIVERY_ADDRESS,        
   DELIVERY_COUNTRY,        
   ORIGINAL_ID_WO_NO,        
   ORIGINAL_ID_WO_PREFIX,        
   DT_MILEAGE_UPDATE,        
   DT_HOURS_UPDATE,        
   LA_DEPT_ACCOUNT_NO,        
   DBS_FLNAME,        
   VA_COST_PRICE,        
   VA_SELL_PRICE,     
   VA_NUMBER,        
   FLG_UPD_MILEAGE,        
   INT_NOTE,        
   @ID_WO_PREFIX + @ID_WO_NO ,  
   FLG_KRE_ORD        
   FROM TBL_WO_HEADER         
   WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX         
           
           
          
            
   INSERT INTO TBL_WO_DETAIL        
    SELECT @CURR_WO_NO,        
     @CURR_WO_PREFIX,        
   ID_JOB,        
   DT_PLANNED,        
   ID_RPG_CATG_WO,        
   ID_RPG_CODE_WO,        
   ID_REP_CODE_WO,        
   ID_WORK_CODE_WO,        
   WO_FIXED_PRICE,        
   ID_JOBPCD_WO,        
   WO_STD_TIME,        
   WO_PLANNED_TIME,        
   WO_HOURLEY_PRICE,        
   WO_CLK_TIME,        
   WO_CHRG_TIME,        
   FLG_CHRG_STD_TIME,        
   FLG_STAT_REQ,        
   WO_JOB_TXT,        
   WO_OWN_CR_CUST,        
   WO_OWN_RISK_AMT,        
   WO_OWN_RISK_CUST,        
   WO_TOT_LAB_AMT,        
   WO_TOT_SPARE_AMT,        
   WO_TOT_GM_AMT,        
   WO_TOT_VAT_AMT,        
   WO_TOT_DISC_AMT,        
   WO_OWN_PAY_VAT,        
   'JCD',        
   PLANNED_DATE,        
   FLG_SPLIT_STATUS,        
   SPLIT_COUNT,        
   ID_MECH_COMP,        
   ID_STYPE_WO,        
   ID_SERV_CALL,        
   @CREATED_BY,        
   getdate(),        
   Null,        
   Null,        
   WO_Planned,        
   WO_GM_VAT,        
   WO_GM_ACCCODE,        
   WO_VAT_ACCCODE,        
   WO_VAT_PERCENTAGE,        
   wo_flg_planned,        
   WO_GM_PER,        
   WO_GM_VATPER,        
   WO_LBR_VATPER,        
   WO_INCL_VAT,        
   WO_DISCOUNT,        
   ID_SUBREP_CODE_WO,        
   ID_SUB_REP_CODE,        
   OwnRiskVATAmt,        
   LUNCH_WITHDRAW,        
   FROM_TIME,        
   TO_TIME,        
   USERNAME,        
   WO_FLG_EDIT,        
   FLG_SPRSTATUS,        
   SALESMAN,        
   FLG_VAT_FREE,        
   COST_PRICE,        
   WO_FINAL_TOTAL,        
   WO_FINAL_VAT,        
   WO_FINAL_DISCOUNT,        
   WO_CHRG_TIME_FP,        
   WO_TOT_LAB_AMT_FP,        
   WO_TOT_SPARE_AMT_FP,        
   WO_TOT_GM_AMT_FP,        
   WO_TOT_VAT_AMT_FP,        
   WO_TOT_DISC_AMT_FP,        
   FLG_VAL_STDTIME,        
   FLG_VAL_MILEAGE,        
   FLG_SAVEUPDDP,        
   FLG_EDTCHGTIME,        
   WO_INT_NOTE,        
   ID_MECHANIC,        
   WO_OWN_RISK_DESC,        
   WO_OWN_RISK_SL_NO FROM TBL_WO_DETAIL         
   WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX       
                                   
 --SET @OV_INV_LIST = '<ROOT><INV_GENERATE ID_WO_PREFIX="'+ID_WO_PREFIX+'" ID_WO_NO="'+ID_WO_NO+'" ID_WODET_SEQ="'+ID_WODET_SEQ+'" ID_JOB_DEB="'+ID_JOB_DEB+'" FLG_BATCH="'+FLG_BATCH+'" IV_DATE ="'+IV_DATE+'" /></ROOT>'              
           
           
   SELECT ID_WO_NO,ID_WO_PREFIX INTO #TEMPWO FROM TBL_WO_DETAIL WHERE ID_WO_NO =@CURR_WO_NO AND ID_WO_PREFIX = @CURR_WO_PREFIX        
           
   DECLARE @INDX INT        
   DECLARE @TOTCNT INT        
   SET @INDX = 1        
   SELECT @TOTCNT = COUNT(*) FROM #TEMPWO        
           
   WHILE @INDX <= @TOTCNT        
   BEGIN        
            
    DECLARE @PREV_WO_NO VARCHAR(30)        
    DECLARE @PREV_WO_PR VARCHAR(10)        
    DECLARE @PREV_ID_JOB VARCHAR(10)        
    DECLARE @PREV_ID_WODET_SEQ VARCHAR(30)        
            
    DECLARE @CURR_ID_JOB VARCHAR(10)        
    DECLARE @CURR_ID_WODET_SEQ VARCHAR(30)       
    DECLARE @CURR_ID_JOB_DEB VARCHAR(30)        
            
    SET @PREV_WO_NO = @ID_WO_NO        
    SET @PREV_WO_PR = @ID_WO_PREFIX        
    SELECT @PREV_ID_JOB = ID_JOB FROM TBL_WO_DETAIL WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX AND ID_JOB = @INDX        
    SELECT @PREV_ID_WODET_SEQ = ID_WODET_SEQ FROM TBL_WO_DETAIL WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX AND ID_JOB = @INDX         
    SELECT @CURR_ID_JOB = ID_JOB FROM TBL_WO_DETAIL WHERE ID_WO_NO = @CURR_WO_NO AND ID_WO_PREFIX = @CURR_WO_PREFIX AND ID_JOB = @INDX        
    SELECT @CURR_ID_WODET_SEQ = ID_WODET_SEQ, @CURR_ID_JOB_DEB = WO_OWN_RISK_CUST FROM TBL_WO_DETAIL WHERE ID_WO_NO = @CURR_WO_NO AND ID_WO_PREFIX = @CURR_WO_PREFIX AND ID_JOB = @INDX         
    SET @OV_INV_LIST = @OV_INV_LIST + '<INV_GENERATE ID_WO_PREFIX="'+@CURR_WO_PREFIX+'" ID_WO_NO="'+@CURR_WO_NO+'" ID_WODET_SEQ="'+@CURR_ID_WODET_SEQ+'" ID_JOB_DEB="'+@CURR_ID_JOB_DEB+'" FLG_BATCH="TRUE" IV_DATE ="" />'              
       
           
           
    --SELECT 1        
    INSERT INTO TBL_WO_JOB_DETAIL        
    SELECT @CURR_ID_WODET_SEQ,        
     @CURR_WO_NO,        
     @CURR_WO_PREFIX,        
     ID_MAKE_JOB,        
     ID_ITEM_CATG_JOB,        
     ID_ITEM_JOB,        
     JOBI_ORDER_QTY,        
     JOBI_DELIVER_QTY,        
     JOBI_BO_QTY,        
     JOBI_SELL_PRICE,        
     JOBI_DIS_PER,        
     JOBI_DIS_CD,        
     JOBI_VAT_PER,        
     ORDER_LINE_TEXT,        
     @CREATED_BY,        
  getdate(),        
     Null,        
     Null,        
     JOB_VAT_ACCCODE,        
     JOB_VAT,        
     job_spares_accountcode,        
     ID_MAKE,        
     ID_WAREHOUSE,        
     ID_CUST_WO,        
     TD_CALC,        
     TEXT,        
     ITEM_DESC,        
     STATUS,        
     PICKINGLIST_PREV_PRINTED,        
     DELIVERYNOTE_PREV_PRINTED,        
     ID_DBT_SEQ,        
     JOBI_COST_PRICE,        
     PICKINGLIST_PREV_PICKED,        
     SPARE_TYPE,        
     FLG_FORCE_VAT,        
     FLG_EDIT_SP,        
     EXPORT_TYPE,        
     SL_NO,        
     SPARE_DISCOUNT        
     FROM TBL_WO_JOB_DETAIL        
     WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX AND ID_WODET_SEQ_JOB = @PREV_ID_WODET_SEQ        
             
     INSERT INTO TBL_WO_LABOUR_DETAIL        
     SELECT @CURR_ID_WODET_SEQ,        
       ID_LOGIN,        
       WO_LABOUR_HOURS,        
       WO_HOURLEY_PRICE,        
       WO_VAT_Code,        
       WO_vat_ACCCODE,        
       wo_labour_accountcode,        
       wo_labourvat_percentage,        
       WO_LABOUR_DESC,        
       SL_NO,        
       WO_LAB_DISCOUNT        
       FROM TBL_WO_LABOUR_DETAIL        
       WHERE ID_WODET_SEQ = @PREV_ID_WODET_SEQ        
           
    SET @INDX = @INDX + 1       
    --SET @OV_INV_LIST = '<ROOT>'+ @OV_INV_LIST + '</ROOT>'      
    --PRINT '1'        
    --Print @OV_INV_LIST      
            
   END       
          
           
   INSERT INTO TBL_WO_DEBITOR_DETAIL        
   SELECT         
     @CURR_WO_PREFIX,        
     @CURR_WO_NO,        
     ID_JOB_ID,        
     ID_JOB_DEB,        
     DEBITOR_TYPE,        
     ID_DETAIL,        
     SPLIT_PER,        
     DBT_PER,        
     DBT_AMT,        
     @CREATED_BY,        
     getdate(),        
     Null,        
     Null,        
     DBT_DIS_PER,        
     WO_VAT_PERCENTAGE,        
     WO_GM_PER,        
     WO_GM_VATPER,        
     WO_LBR_VATPER,        
     WO_SPR_DISCPER,        
     WO_FIXED_VATPER,        
     ORG_PER,        
     JOB_TOTAL,        
     DEBTOR_VAT_PERCENTAGE,        
     LABOUR_AMOUNT,        
     LABOUR_DISCOUNT,        
     GM_AMOUNT,        
     GM_DISCOUNT,        
     OWN_RISK_AMOUNT,        
     TRANSFERREDVAT,        
     TRANSFERREDFROMCUSTID,        
     TRANSFERREDFROMCUSTName,        
     JOB_VAT_AMOUNT,        
     SP_VAT,        
     SP_AMT_DEB,        
     CUST_TYPE,        
     WO_OWN_RISK_DESC,        
     REDUCTION_PER,        
     REDUCTION_BEFORE_OR,        
     REDUCTION_AFTER_OR,        
     REDUCTION_AMOUNT,        
     CUST_DISC_GENERAL,        
     CUST_DISC_LABOUR,        
     CUST_DISC_SPARES,        
     DEB_STATUS        
   FROM TBL_WO_DEBITOR_DETAIL        
   WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX         
           
   --loop        
           
   SELECT ROW_NUMBER() OVER (ORDER BY ID_DEBDIS_SEQ) AS ID_SL_NO, ID_ITEM_JOB,ID_WO_NO,ID_WO_PREFIX,ID_JOB_ID INTO #TEMPWOJOBDISC FROM TBL_WO_JOB_DEBITOR_DISCOUNT         
   WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX         
           
   DECLARE @IDX INT        
   DECLARE @CNT INT        
   SET @IDX = 1        
   SELECT @CNT = COUNT(*) FROM #TEMPWOJOBDISC        
   WHILE @IDX <= @CNT        
   BEGIN        
    DECLARE @CURR_ID_DEB_SEQ VARCHAR(30)        
    DECLARE @PREV_ID_DEB_SEQ VARCHAR(30)        
            
    SELECT @CURR_ID_DEB_SEQ = ID_WODEB_SEQ FROM TBL_WO_JOB_DEBITOR_DISCOUNT WODISC        
    INNER JOIN #TEMPWOJOBDISC TEMP        
    ON WODISC.ID_WO_NO = TEMP.ID_WO_NO AND WODISC.ID_WO_PREFIX = TEMP.ID_WO_PREFIX        
    WHERE WODISC.ID_WO_NO = @ID_WO_NO AND WODISC.ID_WO_PREFIX = @ID_WO_PREFIX        
    AND  TEMP.ID_SL_NO =@IDX        
            
      
    INSERT INTO TBL_WO_JOB_DEBITOR_DISCOUNT        
    SELECT @CURR_ID_DEB_SEQ,        
     @CURR_WO_NO,        
     @CURR_WO_PREFIX,        
     ID_JOB_ID,        
     ID_DEB,        
     DBT_DIS_PER,        
     DBT_DIS_AMT,        
     DBT_VAT_PER,        
     DBT_VAT_AMOUNT,        
     ID_ITEM_JOB,        
     REF_DISC_NO,        
     REF_VAT_NO,        
     ID_CUST_DEBTOR,        
     ID_CUST_CREDITOR,        
     @CREATED_BY,        
     getdate(),        
     Null,        
     Null,        
     ID_MAKE,        
     ID_WAREHOUSE         
   FROM TBL_WO_JOB_DEBITOR_DISCOUNT        
   WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX         
           
   SET @IDX = @IDX + 1        
            
   END        
           
   --SELECT 2,ID_WO_NO,ID_WO_PREFIX,ID_JOB FROM TBL_WO_DETAIL WHERE ID_WO_NO = @CURR_WO_NO AND ID_WO_PREFIX =@CURR_WO_PREFIX        
           
   SELECT ID_WO_NO,ID_WO_PREFIX,ID_JOB INTO #TEMPJOB FROM TBL_WO_DETAIL WHERE ID_WO_NO = @CURR_WO_NO AND ID_WO_PREFIX =@CURR_WO_PREFIX        
           
   DECLARE @COUNTER INT        
   DECLARE @TOTALCNT INT        
           
   SET @COUNTER = 1        
   SELECT @TOTALCNT = COUNT(*) FROM #TEMPJOB        
           
   --select '@CURR_WO_NO',@CURR_WO_NO,@CURR_WO_PREFIX        
           
           
   WHILE @COUNTER <= @TOTALCNT        
   BEGIN        
    DECLARE @DEBTORSEQ VARCHAR(20)        
    DECLARE @ID_WO_LAB_SEQ VARCHAR(20)        
    DECLARE @CURR_WODET_SEQ VARCHAR(20)        
    DECLARE @ID_JOB INT        
        
    SELECT @DEBTORSEQ = ID_DBT_SEQ from tbl_wo_debitor_detail where id_wo_no = @CURR_WO_NO and id_wo_prefix = @CURR_WO_PREFIX        
           
    SELECT @CURR_WODET_SEQ = WD.ID_WODET_SEQ,@ID_JOB = WD.ID_JOB FROM TBL_WO_DETAIL WD        
    INNER JOIN #TEMPJOB TEMP        
    ON WD.ID_WO_NO = TEMP.ID_WO_NO AND WD.ID_WO_PREFIX = TEMP.ID_WO_PREFIX        
    AND WD.ID_JOB = TEMP.ID_JOB        
            
    SELECT @ID_WO_LAB_SEQ = ID_WOLAB_SEQ from TBL_WO_LABOUR_DETAIL where ID_WODET_SEQ=@CURR_WODET_SEQ        
            
    EXEC USP_WO_DEBITOR_INVOICEDATA_INSERT @CURR_WO_PREFIX , @ID_JOB ,@CURR_WO_NO , @CREATED_BY            
          
            
    --INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA        
    --SELECT @DEBTORSEQ,        
    --  DEBTOR_ID,        
    --  LINE_TYPE,        
    --  LINE_ID,        
    --  PRICE,        
    --  LINE_AMOUNT_NET,        
    --  LINE_DISCOUNT,        
    --  LINE_AMOUNT,        
    --  LINE_VAT_PERCENTAGE,        
    --  LINE_VAT_AMOUNT,        
    --  CREATED_BY,        
    --  DT_CREATED,        
    --  MODIFIED_BY,        
    --  DT_MODIFIED,        
    --  @CURR_WO_PREFIX,        
    --  @CURR_WO_NO,        
    --  ID_JOB_ID,        
    --  NULL ,        
    --  FIXED_PRICE,        
    --  FIXED_PRICE_VAT,        
    --  DISC_PERCENT,        
    --  DEL_QTY,        
    --  JOBSUM,        
    --  INVOICESUM,        
    --  CALCULATEDFROM,        
    --  FINDVAT,        
    --  VATAMOUNT,        
    --  ROUNDING_TOTAL,        
    --  VAT_TRANSFER,        
    --  CASE WHEN LINE_TYPE = 'LABOUR' THEN @CURR_WODET_SEQ        
    --  ELSE NULL END,        
    --  JOBVAT         
    --FROM TBL_WO_DEBTOR_INVOICE_DATA        
    --WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX         
            
            
            
            
            
           
   SET @COUNTER = @COUNTER + 1        
           
   END        
           
   drop table #TEMPJOB        
   drop table #TEMPWOJOBDISC        
   drop table #TEMPWO        
           
    UPDATE TBL_MAS_WO_CONFIGURATION                           
    SET    WO_CUR_SERIES = @CURR_WO_NO                            
    WHERE  (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                             
    AND ID_SUBSIDERY_WO = @SUBID                           
    AND ID_DEPT_WO = @DEPID  
    
    UPDATE TBL_WO_HEADER
    SET FLG_KRE_ORD = 1
    WHERE ID_WO_NO = @ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX
            
        
   IF (@@ERROR <> 0)                  
 BEGIN                  
 ROLLBACK TRANSACTION @TRANNAME          
 return         
 END         
  ELSE IF @@ERROR = 0                   
  BEGIN             
   COMMIT TRANSACTION @TRANNAME         
   return        
  End                          
        
        
END
GO

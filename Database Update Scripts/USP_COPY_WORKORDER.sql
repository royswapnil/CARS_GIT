/****** Object:  StoredProcedure [dbo].[USP_COPY_WORKORDER]    Script Date: 10/12/2017 4:43:22 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_COPY_WORKORDER]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_COPY_WORKORDER]
GO
/****** Object:  StoredProcedure [dbo].[USP_COPY_WORKORDER]    Script Date: 10/12/2017 4:43:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_COPY_WORKORDER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_COPY_WORKORDER] AS' 
END
GO
-- =============================================        
-- Author:  Praveen        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
ALTER PROCEDURE [dbo].[USP_COPY_WORKORDER]        
 @GET_ID_WO_NO  VARCHAR(20),        
 @GET_ID_WO_PREFIX VARCHAR(20),        
 @IV_CREATED_BY  VARCHAR(20)        
  --,@0V_RETVALUE        VARCHAR(10)   OUTPUT         
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;        
        
    DECLARE @DEPID INT                            
  DECLARE @SUBID INT                           
  DECLARE @CHKPR INT         
  DECLARE @IV_ID_WO_PREFIX VARCHAR(5)        
  DECLARE @IV_ID_WO_NO    VARCHAR(10)        
  DECLARE @TRANNAME VARCHAR(20)        
  DECLARE @0V_RETVALUE VARCHAR(10)        
  DECLARE @ID_NEW_WO_NO VARCHAR(10)        
  DECLARE @ID_NEW_WO_PREFIX VARCHAR(10)        
  DECLARE @CHKJOB INT         
  DECLARE @ID_JOB INT        
          
  SELECT @TRANNAME = 'WOInsTrans'        
  SET @0V_RETVALUE = 0        
          
  --Get Subsidery and Department ID        
  SELECT @DEPID = ID_DEPT_USER,                          
    @SUBID = ID_SUBSIDERY_USER                             
  FROM    TBL_MAS_USERS                            
  WHERE   ID_LOGIN = @IV_CREATED_BY        
          
  --Get Work Order Prefix        
  SELECT  @IV_ID_WO_PREFIX = WO_PREFIX                           
  FROM    TBL_MAS_WO_CONFIGURATION                            
  WHERE   GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                           
  AND  ID_SUBSIDERY_WO = @SUBID                         
  AND  ID_DEPT_WO = @DEPID          
        
  --Get Next Work Order Number        
  SELECT  @IV_ID_WO_NO =               
    CASE WHEN WO_CUR_SERIES IS NOT NULL  AND  LEN(WO_CUR_SERIES) > 0 THEN                            
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
        
  --Check work order prefix exist in the workorder        
  SELECT @CHKPR=ISNULL(COUNT(WO_PREFIX),0)                         
  FROM TBL_MAS_WO_CONFIGURATION                        
  WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                             
   AND ID_SUBSIDERY_WO = @SUBID             
   AND ID_DEPT_WO = @DEPID          
          
  BEGIN TRANSACTION @TRANNAME         
  IF @CHKPR < 1         
  BEGIN        
   SET @0V_RETVALUE = 'CRPR'     --Create work order prefix                        
   ROLLBACK TRANSACTION @TranName         
  END        
 ELSE        
  BEGIN        
    --Insert into Header Table        
     INSERT INTO TBL_WO_HEADER                            
     (                            
      ID_WO_NO   ,                            
      ID_WO_PREFIX  ,                            
      DT_ORDER   ,                            
      WO_CUST_GROUPID  ,                            
      WO_TYPE_WOH  ,                            
      WO_STATUS  ,                                  DT_DELIVERY  ,                             
      WO_TM_DELIV  ,                            
      DT_FINISH  ,                            
      ID_PAY_TYPE_WO   ,       
      ID_PAY_TERMS_WO  ,                            
      WO_ANNOT   ,                            
      ID_CUST_WO  ,                            
      WO_CUST_NAME  ,                            
      WO_CUST_PERM_ADD1,                            
      WO_CUST_PERM_ADD2,                            
      ID_ZIPCODE_WO ,                            
      WO_CUST_PHONE_OFF ,                            
      WO_CUST_PHONE_HOME,                          
      WO_CUST_PHONE_MOBILE,                            
      ID_VEH_SEQ_WO   ,                            
      WO_VEH_REG_NO   ,                            
      WO_VEH_INTERN_NO  ,                            
      WO_VEH_VIN    ,                            
      WO_VEH_MILEAGE   ,                            
      WO_VEH_HRS    ,                            
      WO_VEH_MAK_MOD_MAP  ,                            
      CREATED_BY    ,                            
      DT_CREATED    ,                            
      ID_DEPT     ,                            
      ID_SUBSIDERY ,        
      WO_PKKDATE,         
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
      WO_REF_NO,    
      FLG_KRE_ORD    
     )                            
     SELECT                           
                                 
      @IV_ID_WO_NO      ,                            
      @IV_ID_WO_PREFIX     ,                            
      GETDATE()      ,                            
      WO_CUST_GROUPID     ,                            
      WO_TYPE_WOH      ,                            
      CASE WHEN WO_STATUS='BAR' THEN 'BAR' ELSE 'CSA' END      ,                            
      NULL ,                            
      NULL      ,                            
      NULL    ,                            
      ID_PAY_TYPE_WO     ,                            
      ID_PAY_TERMS_WO     ,                            
      WO_ANNOT      ,                            
      ID_CUST_WO      ,                            
      WO_CUST_NAME     ,                            
      WO_CUST_PERM_ADD1    ,                            
      WO_CUST_PERM_ADD2    ,                            
      ID_ZIPCODE_WO     ,                            
      WO_CUST_PHONE_OFF    ,                   
      WO_CUST_PHONE_HOME    ,                            
      WO_CUST_PHONE_MOBILE   ,                            
      ID_VEH_SEQ_WO     ,                            
      WO_VEH_REG_NO     ,                            
      WO_VEH_INTERN_NO    ,                            
      WO_VEH_VIN      ,                 
      WO_VEH_MILEAGE     ,                            
      WO_VEH_HRS      ,                            
      WO_VEH_MAK_MOD_MAP     ,                            
      @IV_CREATED_BY      ,                            
      GETDATE()       ,                            
      ID_DEPT        ,                            
      ID_SUBSIDERY  ,        
      WO_PKKDATE,                 
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
      WO_REF_NO,    
      FLG_KRE_ORD         
     FROM TBL_WO_HEADER         
     WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX         
        
     /**** TBL_WO_DETAIL - START****/        
        
     INSERT INTO TBL_WO_DETAIL        
     (        
            ID_WO_NO, ID_WO_PREFIX, ID_JOB, DT_PLANNED, ID_RPG_CATG_WO, ID_RPG_CODE_WO, ID_REP_CODE_WO,         
            ID_WORK_CODE_WO, WO_FIXED_PRICE, ID_JOBPCD_WO, WO_STD_TIME, WO_PLANNED_TIME, WO_HOURLEY_PRICE, WO_CLK_TIME,         
            WO_CHRG_TIME, FLG_CHRG_STD_TIME, FLG_STAT_REQ, WO_JOB_TXT, WO_OWN_CR_CUST, WO_OWN_RISK_AMT, WO_OWN_RISK_CUST,         
            WO_TOT_LAB_AMT, WO_TOT_SPARE_AMT, WO_TOT_GM_AMT, WO_TOT_VAT_AMT, WO_TOT_DISC_AMT, WO_OWN_PAY_VAT, JOB_STATUS,         
            PLANNED_DATE, FLG_SPLIT_STATUS, SPLIT_COUNT, ID_MECH_COMP, ID_STYPE_WO, ID_SERV_CALL, CREATED_BY, DT_CREATED,         
            MODIFIED_BY, DT_MODIFIED, WO_Planned, WO_GM_VAT, WO_GM_ACCCODE, WO_VAT_ACCCODE, WO_VAT_PERCENTAGE, wo_flg_planned,         
            WO_GM_PER, WO_GM_VATPER, WO_LBR_VATPER, WO_INCL_VAT, WO_DISCOUNT, ID_SUBREP_CODE_WO, ID_SUB_REP_CODE, OwnRiskVATAmt,         
            LUNCH_WITHDRAW, FROM_TIME, TO_TIME, USERNAME, WO_FLG_EDIT, FLG_SPRSTATUS,WO_CHRG_TIME_FP,WO_TOT_LAB_AMT_FP,WO_TOT_SPARE_AMT_FP,        
            WO_TOT_GM_AMT_FP,WO_TOT_VAT_AMT_FP,WO_TOT_DISC_AMT_FP,FLG_VAL_STDTIME,FLG_VAL_MILEAGE,FLG_SAVEUPDDP,FLG_EDTCHGTIME,WO_INT_NOTE,    
            ID_MECHANIC,WO_OWN_RISK_DESC,WO_OWN_RISK_SL_NO    
      )        
     SELECT         
        
            @IV_ID_WO_NO, @IV_ID_WO_PREFIX, ID_JOB, NULL, ID_RPG_CATG_WO, ID_RPG_CODE_WO, ID_REP_CODE_WO,         
            ID_WORK_CODE_WO, WO_FIXED_PRICE, ID_JOBPCD_WO, WO_STD_TIME, WO_PLANNED_TIME, WO_HOURLEY_PRICE, '00:00',         
            0, FLG_CHRG_STD_TIME, FLG_STAT_REQ, WO_JOB_TXT, WO_OWN_CR_CUST, WO_OWN_RISK_AMT, WO_OWN_RISK_CUST,         
            0, 0, 0, case when WO_FIXED_PRICE=0.0 then 0 else WO_TOT_VAT_AMT end, 0, WO_OWN_PAY_VAT,         
            CASE WHEN JOB_STATUS='BAR' THEN 'BAR' ELSE 'CSA' END,              PLANNED_DATE, FLG_SPLIT_STATUS, SPLIT_COUNT, ID_MECH_COMP, ID_STYPE_WO, ID_SERV_CALL, @IV_CREATED_BY, GETDATE(),         
            NULL, NULL, WO_Planned, WO_GM_VAT, WO_GM_ACCCODE, WO_VAT_ACCCODE, WO_VAT_PERCENTAGE, wo_flg_planned,         
            WO_GM_PER, WO_GM_VATPER, WO_LBR_VATPER, WO_INCL_VAT, WO_DISCOUNT, ID_SUBREP_CODE_WO, ID_SUB_REP_CODE, OwnRiskVATAmt,         
            LUNCH_WITHDRAW, FROM_TIME, TO_TIME, USERNAME, WO_FLG_EDIT, FLG_SPRSTATUS,WO_CHRG_TIME_FP,WO_TOT_LAB_AMT_FP,WO_TOT_SPARE_AMT_FP,        
            WO_TOT_GM_AMT_FP,WO_TOT_VAT_AMT_FP,WO_TOT_DISC_AMT_FP,FLG_VAL_STDTIME,FLG_VAL_MILEAGE,FLG_SAVEUPDDP,FLG_EDTCHGTIME,WO_INT_NOTE,    
            ID_MECHANIC,WO_OWN_RISK_DESC,WO_OWN_RISK_SL_NO        
     FROM TBL_WO_DETAIL        
     WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX         
        
     --UPDATE LABOUR ON ORDER        
        --UPDATE TBL_WO_DETAIL        
        --SET WO_TOT_LAB_AMT= WO_HOURLEY_PRICE*WO_CHRG_TIME,WO_TOT_GM_AMT=WO_TOT_LAB_AMT*WO_GM_PER/100        
        --WHERE         
        --ID_WO_PREFIX =@IV_ID_WO_PREFIX AND  ID_WO_NO = @IV_ID_WO_NO and FLG_CHRG_STD_TIME = 1        
                
        --UPDATE TBL_WO_DETAIL        
        --SET WO_TOT_GM_AMT=WO_TOT_LAB_AMT*WO_GM_PER/100        
        --WHERE         
        --ID_WO_PREFIX =@IV_ID_WO_PREFIX AND  ID_WO_NO = @IV_ID_WO_NO and FLG_CHRG_STD_TIME = 1        
                
     /**** TBL_WO_DETAIL - END****/        
        
     /**** TBL_WO_DEBITOR_DETAIL - START****/        
     INSERT INTO TBL_WO_DEBITOR_DETAIL        
     (        
			ID_WO_PREFIX, ID_WO_NO, ID_JOB_ID, ID_JOB_DEB, DEBITOR_TYPE, ID_DETAIL, SPLIT_PER, DBT_PER, DBT_AMT,         
            CREATED_BY, DT_CREATED, MODIFIED_BY, DT_MODIFIED, DBT_DIS_PER, WO_VAT_PERCENTAGE, WO_GM_PER, WO_GM_VATPER,         
            WO_LBR_VATPER, WO_SPR_DISCPER, WO_FIXED_VATPER, ORG_PER,JOB_TOTAL,JOB_VAT_AMOUNT,LABOUR_AMOUNT,LABOUR_DISCOUNT,SP_AMT_DEB,SP_VAT        
            ,OWN_RISK_AMOUNT,TRANSFERREDFROMCUSTID,TRANSFERREDFROMCUSTName,TRANSFERREDVAT,DEBTOR_VAT_PERCENTAGE,GM_AMOUNT,GM_DISCOUNT,    
            CUST_TYPE,WO_OWN_RISK_DESC,REDUCTION_PER,REDUCTION_BEFORE_OR,REDUCTION_AFTER_OR,REDUCTION_AMOUNT,    
            CUST_DISC_GENERAL,CUST_DISC_LABOUR,CUST_DISC_SPARES,DEB_STATUS        
     )        
     SELECT @IV_ID_WO_PREFIX, @IV_ID_WO_NO, ID_JOB_ID, ID_JOB_DEB, DEBITOR_TYPE, ID_DETAIL, SPLIT_PER, DBT_PER, DBT_AMT,         
            @IV_CREATED_BY, GETDATE(), NULL, NULL, DBT_DIS_PER, WO_VAT_PERCENTAGE, WO_GM_PER, WO_GM_VATPER,         
            WO_LBR_VATPER, WO_SPR_DISCPER, WO_FIXED_VATPER, ORG_PER,JOB_TOTAL,JOB_VAT_AMOUNT,LABOUR_AMOUNT,LABOUR_DISCOUNT,SP_AMT_DEB,SP_VAT,    
            OWN_RISK_AMOUNT,TRANSFERREDFROMCUSTID,TRANSFERREDFROMCUSTName,TRANSFERREDVAT,DEBTOR_VAT_PERCENTAGE,GM_AMOUNT,GM_DISCOUNT,    
            CUST_TYPE,WO_OWN_RISK_DESC,REDUCTION_PER,REDUCTION_BEFORE_OR,REDUCTION_AFTER_OR,REDUCTION_AMOUNT,    
            CUST_DISC_GENERAL,CUST_DISC_LABOUR,CUST_DISC_SPARES,DEB_STATUS        
        
     FROM TBL_WO_DEBITOR_DETAIL        
     WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX         
        
     /**** TBL_WO_DEBITOR_DETAIL - END****/        
        
        
        
     /**** TBL_WO_JOB_DEBITOR_DISCOUNT - START****/        
        
     INSERT INTO TBL_WO_JOB_DEBITOR_DISCOUNT        
     (        
			ID_WODEB_SEQ, ID_WO_NO, ID_WO_PREFIX, ID_JOB_ID, ID_DEB, DBT_DIS_PER, DBT_DIS_AMT, DBT_VAT_PER,         
            DBT_VAT_AMOUNT, ID_ITEM_JOB, REF_DISC_NO, REF_VAT_NO, ID_CUST_DEBTOR, ID_CUST_CREDITOR, CREATED_BY, DT_CREATED,         
            MODIFIED_BY, DT_MODIFIED, ID_MAKE, ID_WAREHOUSE        
     )        
     SELECT  (SELECT TOP 1 DEB.ID_DBT_SEQ FROM TBL_WO_DEBITOR_DETAIL DEB WHERE DEB.ID_WO_NO=@IV_ID_WO_NO AND DEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX AND DEB.ID_JOB_ID=ID_JOB_ID AND DEB.ID_JOB_DEB=ID_DEB),        
        @IV_ID_WO_NO, @IV_ID_WO_PREFIX, ID_JOB_ID, ID_DEB, DBT_DIS_PER, DBT_DIS_AMT, DBT_VAT_PER,         
        DBT_VAT_AMOUNT, ID_ITEM_JOB, REF_DISC_NO, REF_VAT_NO, ID_CUST_DEBTOR, ID_CUST_CREDITOR, @IV_CREATED_BY, GETDATE(),         
        NULL, NULL, ID_MAKE, ID_WAREHOUSE        
     FROM TBL_WO_JOB_DEBITOR_DISCOUNT        
     WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX         
        
     /**** TBL_WO_JOB_DEBITOR_DISCOUNT - END****/        
        
     /**** TBL_WO_JOB_DETAIL - START****/        
        
     INSERT INTO TBL_WO_JOB_DETAIL        
     (        
		ID_WODET_SEQ_JOB, ID_WO_NO, ID_WO_PREFIX, ID_MAKE_JOB, ID_ITEM_CATG_JOB, ID_ITEM_JOB,         
        JOBI_ORDER_QTY, JOBI_DELIVER_QTY, JOBI_BO_QTY, JOBI_SELL_PRICE, JOBI_DIS_PER, JOBI_DIS_CD, JOBI_VAT_PER, ORDER_LINE_TEXT,         
        CREATED_BY, DT_CREATED, MODIFIED_BY, DT_MODIFIED, JOB_VAT_ACCCODE, JOB_VAT, job_spares_accountcode, ID_MAKE, ID_WAREHOUSE,         
        ID_CUST_WO, TD_CALC, TEXT, ITEM_DESC, STATUS, PICKINGLIST_PREV_PRINTED, DELIVERYNOTE_PREV_PRINTED, ID_DBT_SEQ,         
        JOBI_COST_PRICE, PICKINGLIST_PREV_PICKED,SPARE_TYPE,FLG_FORCE_VAT,FLG_EDIT_SP,EXPORT_TYPE,SL_NO,SPARE_DISCOUNT        
     )        
     SELECT (SELECT WOD.ID_WODET_SEQ FROM TBL_WO_DETAIL WOD         
        WHERE WOD.ID_WO_NO=@IV_ID_WO_NO AND WOD.ID_WO_PREFIX=@IV_ID_WO_PREFIX         
         AND WOD.ID_JOB IN (SELECT TOP 1 ID_JOB FROM TBL_WO_DETAIL WHERE ID_WODET_SEQ=ID_WODET_SEQ_JOB)),        
              @IV_ID_WO_NO, @IV_ID_WO_PREFIX, ID_MAKE_JOB, ID_ITEM_CATG_JOB, ID_ITEM_JOB,         
            JOBI_ORDER_QTY,         
            CASE WHEN JOBI_ORDER_QTY<0         
           THEN         
            JOBI_ORDER_QTY         
           ELSE        
            CASE WHEN         
             (SELECT TOP 1 ITEM_AVAIL_QTY FROM TBL_MAS_ITEM_MASTER ITEM         
              WHERE ITEM.ID_ITEM=ID_ITEM_JOB AND ITEM.ID_WH_ITEM=ID_WAREHOUSE AND ITEM.ID_MAKE=ID_MAKE) >=JOBI_ORDER_QTY         
              THEN JOBI_ORDER_QTY         
            ELSE         
             (SELECT TOP 1 ITEM_AVAIL_QTY FROM TBL_MAS_ITEM_MASTER ITEM         
                     WHERE ITEM.ID_ITEM=ID_ITEM_JOB AND ITEM.ID_WH_ITEM=ID_WAREHOUSE AND ITEM.ID_MAKE=ID_MAKE)         
            END        
           END,        
            0,JOBI_SELL_PRICE, JOBI_DIS_PER, JOBI_DIS_CD, JOBI_VAT_PER, ORDER_LINE_TEXT,         
            @IV_CREATED_BY, GETDATE(), NULL, NULL, JOB_VAT_ACCCODE, JOB_VAT, job_spares_accountcode, ID_MAKE, ID_WAREHOUSE,         
            ID_CUST_WO, TD_CALC, TEXT, ITEM_DESC, CASE WHEN STATUS IS NULL OR STATUS ='BAR 'THEN STATUS ELSE 'CSA' END, 0, 0, ID_DBT_SEQ,         
            JOBI_COST_PRICE, NULL,SPARE_TYPE,FLG_FORCE_VAT,FLG_EDIT_SP,EXPORT_TYPE,SL_NO,SPARE_DISCOUNT        
     FROM TBL_WO_JOB_DETAIL        
     WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX         
        
     UPDATE TBL_WO_JOB_DETAIL        
     SET JOBI_BO_QTY=JOBI_ORDER_QTY-JOBI_DELIVER_QTY        
     WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX    
     
     
     INSERT INTO TBL_WO_LABOUR_DETAIL          
     SELECT (SELECT WODT.ID_WODET_SEQ FROM TBL_WO_DETAIL WODT         
        WHERE WODT.ID_WO_NO=@IV_ID_WO_NO AND WODT.ID_WO_PREFIX=@IV_ID_WO_PREFIX
        AND WODT.ID_JOB IN (SELECT top 1 ID_JOB FROM TBL_WO_DETAIL WHERE  ID_WODET_SEQ=TBL_WO_LABOUR_DETAIL.ID_WODET_SEQ)),
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
       WHERE ID_WODET_SEQ IN 
       (
     		SELECT WOD.ID_WODET_SEQ FROM TBL_WO_DETAIL WOD         
		    WHERE WOD.ID_WO_NO =@GET_ID_WO_NO AND WOD.ID_WO_PREFIX=@GET_ID_WO_PREFIX         
			AND WOD.ID_JOB IN (SELECT DISTINCT ID_JOB FROM TBL_WO_DETAIL WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX)
       )
       
           
           
     --If KRE Order then Order qty = Del qty and Back Order qty =0 always      
     IF((SELECT ISNULL(WO_TYPE_WOH,'ORD') FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX)='KRE')      
     BEGIN      
		 UPDATE TBL_WO_JOB_DETAIL        
		 SET JOBI_BO_QTY=0,JOBI_DELIVER_QTY=JOBI_ORDER_QTY        
		 WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX        
     END      
           
           
           
           
        
     /**** TBL_WO_JOB_DETAIL - END****/        
      --new invoice data        
             
             
   --   INSERT INTO TBL_WO_DEBTOR_INVOICE_DATA        
   --   (DEBTOR_SEQ,DEBTOR_ID,LINE_TYPE,LINE_ID,PRICE,LINE_AMOUNT_NET,LINE_DISCOUNT,LINE_AMOUNT,LINE_VAT_PERCENTAGE,LINE_VAT_AMOUNT,        
   --   CREATED_BY,DT_CREATED,MODIFIED_BY,DT_MODIFIED,ID_WO_PREFIX,ID_WO_NO,ID_JOB_ID,ID_WOITEM_SEQ,FIXED_PRICE,FIXED_PRICE_VAT)        
   --   SELECT (SELECT DEB.ID_DBT_SEQ FROM TBL_WO_DEBITOR_DETAIL DEB WHERE DEB.ID_WO_NO=@IV_ID_WO_NO AND         
   --   DEB.ID_WO_PREFIX=@IV_ID_WO_PREFIX AND         
   --   DEB.ID_JOB_ID =invdata.ID_JOB_ID and        
   --   DEB.ID_JOB_DEB=invdata.DEBTOR_ID        
              
   --   --(SELECT top 1 ID_JOB  FROM TBL_WO_DETAIL WHERE ID_WO_NO=@GET_ID_WO_NO and ID_WO_PREFIX=@GET_ID_WO_PREFIX and ID_JOB=ID_JOB_ID)        
              
   --),        
              
   --    DEBTOR_ID,LINE_TYPE,LINE_ID,PRICE,LINE_AMOUNT_NET,LINE_DISCOUNT,LINE_AMOUNT,LINE_VAT_PERCENTAGE,LINE_VAT_AMOUNT,        
   --   CREATED_BY,DT_CREATED,MODIFIED_BY,DT_MODIFIED,@IV_ID_WO_PREFIX,@IV_ID_WO_NO,ID_JOB_ID,        
   --   case when LINE_TYPE='SPARES' then        
              
                    
   --   (SELECT top 1 WOD.ID_WOITEM_SEQ FROM TBL_WO_JOB_DETAIL WOD         
   --     WHERE WOD.ID_WO_NO=@IV_ID_WO_NO AND WOD.ID_WO_PREFIX=@IV_ID_WO_PREFIX        
   --     and ID_ITEM_JOB=LINE_ID        
   --      AND WOD.ID_WODET_SEQ_JOB IN (SELECT TOP 1 ID_WODET_SEQ_JOB FROM TBL_WO_DETAIL WHERE ID_WO_NO=@GET_ID_WO_NO and ID_WO_PREFIX=@GET_ID_WO_PREFIX and ID_JOB=ID_JOB_ID))        
              
              
              
              
   --   --(SELECT  WOD.ID_WOITEM_SEQ FROM TBL_WO_JOB_DETAIL WOD         
   --   --  WHERE WOD.ID_WO_NO=@IV_ID_WO_NO AND WOD.ID_WO_PREFIX=@IV_ID_WO_PREFIX         
   --   --   AND WOD.ID_WODET_SEQ_JOB IN (SELECT TOP 1 ID_WODET_SEQ_JOB FROM TBL_WO_JOB_DETAIL WHERE ID_WODET_SEQ_JOB=ID_WOITEM_SEQ)        
   --   --   )        
   --      else        
   --      ID_WOITEM_SEQ        
   --      end        
   --  ,            
   --      FIXED_PRICE,FIXED_PRICE_VAT FROM         
   --   TBL_WO_DEBTOR_INVOICE_DATA invdata        
   --   --invdata        
   --   --inner join TBL_WO_JOB_DETAIL wojob        
   --   --on invdata.ID_WO_NO=wojob.ID_WO_NO        
   --   --and invdata.ID_WO_PREFIX=wojob.ID_WO_PREFIX        
   --   WHERE ID_WO_NO=@GET_ID_WO_NO AND ID_WO_PREFIX=@GET_ID_WO_PREFIX        
        
     --UPDATE ORDER WITH CORRECT AMOUNTS        
     DECLARE @TOTJOBS INT        
     SELECT @TOTJOBS=COUNT(*) FROM TBL_WO_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX        
     SET @CHKJOB=0        
        
     WHILE (@CHKJOB<>@TOTJOBS)        
     BEGIN         
      SET @ID_JOB=@CHKJOB+1        
              
       Declare @FixedPrice decimal(20,2)        
       select @FixedPrice=WO_FIXED_PRICE from TBL_WO_DETAIL        
       WHERE         
       ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and ID_JOB = @ID_JOB        
               
       Declare @ISSpares int        
       select @ISSpares=count(*) from tbl_wo_job_detail where ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX        
       and ID_WODET_SEQ_JOB =(select ID_WODET_SEQ FROM TBL_WO_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and  ID_JOB = @ID_JOB)        
        
      IF (SELECT FLG_CHRG_STD_TIME FROM TBL_WO_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and ID_JOB = @ID_JOB ) = 1        
      BEGIN        
       DECLARE @WO_STD_TIME VARCHAR(20)        
       SELECT @WO_STD_TIME=CAST((SUM(CAST(CONVERT(INT,SUBSTRING(WO_STD_TIME,0,                                      
         CHARINDEX(':',WO_STD_TIME)))*60 +                                      
         CONVERT(INT,SUBSTRING(WO_STD_TIME,                                      
         CHARINDEX(':',WO_STD_TIME)+1,                                      
         LEN(WO_STD_TIME)))AS DECIMAL(10,2)))/60)        
         AS DECIMAL(10,2))         
       FROM TBL_WO_DETAIL        
       WHERE         
       ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and ID_JOB = @ID_JOB        
              
       UPDATE TBL_WO_DETAIL        
       SET WO_CHRG_TIME =  @WO_STD_TIME        
       WHERE         
       ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and ID_JOB = @ID_JOB        
               
              
       if @FixedPrice=0.0         
       BEGIN        
   UPDATE TBL_WO_DETAIL        
   SET WO_TOT_LAB_AMT= WO_HOURLEY_PRICE*WO_CHRG_TIME,WO_TOT_GM_AMT=WO_TOT_LAB_AMT*WO_GM_PER/100        
   WHERE         
   ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and ID_JOB = @ID_JOB        
                 
   UPDATE TBL_WO_DETAIL        
   SET WO_TOT_GM_AMT=WO_TOT_LAB_AMT*WO_GM_PER/100        
   WHERE         
   ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX and ID_JOB = @ID_JOB        
       END        
      END        
             
      if @FixedPrice=0.0         
      begin        
  EXEC USP_WO_RECALCULATEJOBTOT @IV_ID_WO_NO,@IV_ID_WO_PREFIX,@ID_JOB,@IV_CREATED_BY        
  If @ISSpares >0         
  BEGIN        
   exec USP_UPDATE_IR_WODETAIL @IV_ID_WO_PREFIX,@IV_ID_WO_NO,@ID_JOB,@IV_CREATED_BY        
  END        
      ELSE        
    BEGIN        
     EXEC USP_WO_DEBITOR_INVOICEDATA_INSERT @IV_ID_WO_PREFIX,@ID_JOB,@IV_ID_WO_NO,@IV_CREATED_BY        
    END        
      END        
      ELSE        
  BEGIN        
   EXEC USP_WO_DEBITOR_INVOICEDATA_INSERT @IV_ID_WO_PREFIX,@ID_JOB,@IV_ID_WO_NO,@IV_CREATED_BY        
            
       UPDATE TBL_WO_DETAIL         
       SET      
         WO_FINAL_TOTAL =(select WO_FINAL_AMOUNT from DBO.FN_FETCH_ORDERDETAMOUNT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,'ENGLISH')),        
   WO_FINAL_VAT = ( select WO_FINAL_VAT_AMOUNT from DBO.FN_FETCH_ORDERDETAMOUNT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,'ENGLISH')),        
          WO_FINAL_DISCOUNT = (select WO_FINAL_DISC_AMOUNT from DBO.FN_FETCH_ORDERDETAMOUNT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,'ENGLISH'))        
       WHERE        
        ID_WO_NO = @IV_ID_WO_NO        
        AND ID_WO_PREFIX = @IV_ID_WO_PREFIX        
        AND ID_JOB = @ID_JOB        
       
      END           
             
      SET @CHKJOB=@CHKJOB+1        
     END         
          
     --UPDATE SPARE PART QUANTITY IN ITEM MASTER        
     IF (((SELECT COUNT(*) FROM TBL_WO_JOB_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX)<>0) AND (SELECT WO_TYPE_WOH FROM TBL_WO_HEADER WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX)= 'ORD')        
     BEGIN        
      DECLARE @TOTITEMS INT        
      DECLARE @CHKITEMS INT        
      SET @CHKITEMS=1        
      SELECT @TOTITEMS = COUNT(*) FROM TBL_WO_JOB_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX        
        
      SELECT ROW_NUMBER() OVER(ORDER BY ID_WODET_SEQ_JOB) AS 'ROWNUM',* INTO #TMP_JOBITEMS        
      FROM TBL_WO_JOB_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO AND ID_WO_PREFIX=@IV_ID_WO_PREFIX        
              
      --SELECT * FROM #TMP_JOBITEMS        
              
      WHILE(@CHKITEMS<=@TOTITEMS)        
        BEGIN        
                
           --If KRE Order then Order qty = Del qty and Back Order qty =0 always      
     IF((SELECT ISNULL(WO_TYPE_WOH,'ORD') FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX) <> 'KRE')      
   BEGIN      
   UPDATE TBL_MAS_ITEM_MASTER              
    SET ITEM_AVAIL_QTY = CASE WHEN (#TMP_JOBITEMS.JOBI_DELIVER_QTY) > 0 THEN           
    (ITEM_AVAIL_QTY - #TMP_JOBITEMS.JOBI_DELIVER_QTY)        
    ELSE         
     ITEM_AVAIL_QTY        
    END          
    FROM           
    #TMP_JOBITEMS                     
    WHERE           
    TBL_MAS_ITEM_MASTER.ID_ITEM  = #TMP_JOBITEMS.ID_ITEM_JOB                   
    AND TBL_MAS_ITEM_MASTER.SUPP_CURRENTNO  = #TMP_JOBITEMS.ID_MAKE_JOB              
    AND TBL_MAS_ITEM_MASTER.ID_WH_ITEM  = #TMP_JOBITEMS.ID_WAREHOUSE        
    AND #TMP_JOBITEMS.ROWNUM= @CHKITEMS        
  END      
        
         SET @CHKITEMS=@CHKITEMS+1        
        END        
     END        
        --SET @ID_NEW_WO_NO = SCOPE_IDENTITY()         
        --SET @ID_NEW_WO_PREFIX = @IV_ID_WO_PREFIX            
  END        
          
  IF @@ERROR <> 0                                 
   BEGIN                              
      SET @0V_RETVALUE = @@ERROR                                
      ROLLBACK TRANSACTION @TRANNAME                              
   END           
  ELSE                              
   BEGIN          
      UPDATE TBL_MAS_WO_CONFIGURATION                           
      SET    WO_CUR_SERIES = @IV_ID_WO_NO                            
      WHERE  (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                             
      AND ID_SUBSIDERY_WO = @SUBID                           
      AND ID_DEPT_WO = @DEPID                 
      COMMIT TRANSACTION @TRANNAME                               
      SET @0V_RETVALUE = 'INSFLG'        
   END         
          
  SELECT @IV_ID_WO_NO AS ID_WO_NO,@IV_ID_WO_PREFIX AS ID_WO_PREFIX        
END 
GO

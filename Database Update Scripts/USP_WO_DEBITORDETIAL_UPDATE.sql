/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITORDETIAL_UPDATE]    Script Date: 3/30/2017 11:50:38 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITORDETIAL_UPDATE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DEBITORDETIAL_UPDATE]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITORDETIAL_UPDATE]    Script Date: 3/30/2017 11:50:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITORDETIAL_UPDATE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DEBITORDETIAL_UPDATE] AS' 
END
GO
                
/*************************************** Application: MSG *************************************************************                                
exec Usp_VariableDecleration 'TBL_WO_DEBITOR_DETAIL'                              
* Module : WORK ORDER                                
* File name : USP_WO_DEBITORDETIAL_UPDATE.PRC                                
* Purpose : To UPDATE DEBITOR DETAILS in  TBL_WO_DEBITOR_DETAIL                             
* Author : THIYAGARAJAN/SUBRAMANIAN                                
* Date  : 28.08.2006                                
*********************************************************************************************************************/                                
/*********************************************************************************************************************                                  
I/P : -- Input Parameters                                
 @iv_xmlDoc - VALID XML DOCUMENT CONTAINING VALUES TO BE UPDATED                               
                                
O/P : -- Output Parameters                                
 @ov_RetValue - 'UPDFLG' if error, 'OK' otherwise                                
                               
Error Code                                
Description                                
********************************************************************************************************************/                                
--'*********************************************************************************'*********************************                                
--'* Modified History :                                   
--'* S.No  RFC No/Bug ID   Date        Author  Description                                 
--* #0001#                                
--'*********************************************************************************'*********************************                                
                            
                    
ALTER PROC [dbo].[USP_WO_DEBITORDETIAL_UPDATE]                                
(                                
 @IV_XMLDOC    NTEXT,  --VARCHAR(7000),                                
 @IV_ID_WO_PREFIX  VARCHAR(3),                              
 @IV_ID_JOB_ID     INT,                              
 @IV_ID_WO_NO      VARCHAR(10),                               
 @IV_MODIFIED_BY   VARCHAR(20),                      
 @IV_OWNRISKAMT   DECIMAL(15,2),                    
 @IV_TOTALAMT    DECIMAL(15,2),                            
 @OV_RETVALUE   VARCHAR(10)   OUTPUT                               
)                                
AS                                  
BEGIN                                  
 DECLARE @docHandle int                                   
    DECLARE @CONFIGLISTCNI AS VARCHAR(2000)                                  
    DECLARE @CFGLSTINSERTED AS VARCHAR(2000)                                  
    DECLARE @TRANNAME AS VARCHAR(20)                
 SELECT @TRANNAME = 'WOJOBUPD'                 
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 DECLARE @ITEMCOUNT AS INT                
                            
 SELECT  @ITEMCOUNT=COUNT(*)                 
    FROM TBL_WO_JOB_DETAIL JOB                
    INNER JOIN TBL_WO_DETAIL WO                    
    ON JOB.ID_WODET_SEQ_JOB = WO.ID_WODET_SEQ                
 WHERE WO.ID_WO_NO=@IV_ID_WO_NO AND WO.ID_WO_PREFIX=@IV_ID_WO_PREFIX AND WO.ID_JOB =@IV_ID_JOB_ID                 
    /*CHANGE END - 21 JUNE 2010*/                
                
    EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_xmlDoc                        
    DECLARE @INSERT_LIST Table                                  
    (                              
  ID_DBT_SEQ  INT,                               
  ID_WO_PREFIX    VARCHAR(3),                                
  ID_JOB_ID       INT,                                
  ID_WO_NO        VARCHAR(10),                                 
  DEBITOR_TYPE    CHAR,                                
  ID_DETAIL       VARCHAR(10),                                
  DBT_PER         DECIMAL(10,2),                                
  DBT_AMT         DECIMAL (20,2),                              
  DBT_DIS_PER  DECIMAL,               
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 PWO_VAT_PERCENTAGE DECIMAL(5,2),                  
 PWO_GM_PER DECIMAL(5,2),                  
 PWO_GM_VATPER DECIMAL(5,2),                  
 PWO_LBR_VATPER DECIMAL(5,2),                  
 PWO_SPR_DISCPER DECIMAL(5,2)                  
 --change end                    
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,PWO_FIXED_VATPER DECIMAL(5,2)                  
 --END OF MODIFICATION                  
 --MODIFIED DATE: 17 NOV 2008                
 --COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
 ,ORG_PER DECIMAL(10,4)                
 --END OF MODIFICATION                  
  ,JOB_VAT_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_DISCOUNT         DECIMAL(20,2)                
 ,GM_AMOUNT         DECIMAL(20,2)                
 ,GM_DISCOUNT         DECIMAL(20,2)                
 ,OWNRISK_AMOUNT        DECIMAL(20,2)                  
 ,SP_VAT DECIMAL(20,2)                 
 ,SP_AMT_DEB DECIMAL(20,2)               
 ,CUST_TYPE VARCHAR(20)            
 ,WO_OWN_RISK_DESC VARCHAR(100)          
 ,REDUCTION_PER DECIMAL(10,2)          
 ,REDUCTION_BEFORE_OR BIT          
 ,REDUCTION_AFTER_OR BIT        
 ,REDUCTION_AMOUNT DECIMAL(13,2)    
 ,CUST_DISC_GENERAL INT                             
 ,CUST_DISC_LABOUR INT    
 ,CUST_DISC_SPARES INT   
 ,DEB_STATUS VARCHAR(10)   
    )                                  
    INSERT INTO @INSERT_LIST                                  
    SELECT                                
  ID_DBT_SEQ,                              
  ID_WO_PREFIX     ,                                
  ID_JOB_ID        ,                                
  ID_WO_NO    ,                            
  DEBITOR_TYPE,                                
  ID_DETAIL,                                
  DBT_PER,                                
  DBT_AMT ,                              
  DBT_DIS_PER ,                  
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 PWO_VAT_PERCENTAGE,                  
 PWO_GM_PER,                  
 PWO_GM_VATPER ,                  
 PWO_LBR_VATPER,                  
 PWO_SPR_DISCPER                   
 --change end                     
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,PWO_FIXED_VATPER                  
 --END OF MODIFICATION                
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER                
 ,JOB_VAT_AMOUNT                         
 ,LABOUR_AMOUNT                        
 ,LABOUR_DISCOUNT                         
 ,GM_AMOUNT                        
 ,GM_DISCOUNT                        
 ,OWNRISK_AMOUNT                
 ,SP_VAT                
 ,SP_AMT_DEB                
 ,CUST_TYPE             
 ,WO_OWN_RISK_DESC          
 ,REDUCTION_PER           
 ,REDUCTION_BEFORE_OR          
 ,REDUCTION_AFTER_OR        
 ,REDUCTION_AMOUNT    
 ,CUST_DISC_GENERAL    
 ,CUST_DISC_LABOUR     
 ,CUST_DISC_SPARES   
 ,DEB_STATUS          
--END OF MODIFICATION                               
    FROM OPENXML (@docHandle,'root/insert',1) with                                   
   (                                
  ID_DBT_SEQ  INT,                            
  ID_WO_PREFIX    VARCHAR(3),                                
  ID_JOB_ID       INT,                                
  ID_WO_NO        VARCHAR(10),                                
  DEBITOR_TYPE    CHAR,                                
  ID_DETAIL       VARCHAR(10),                                
  DBT_PER         DECIMAL(10,2),                                
  DBT_AMT         DECIMAL(20,2),                              
  DBT_DIS_PER  DECIMAL,                  
                  
 --Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details             
 PWO_VAT_PERCENTAGE DECIMAL(5,2),                  
 PWO_GM_PER DECIMAL(5,2),                  
 PWO_GM_VATPER DECIMAL(5,2),                  
 PWO_LBR_VATPER DECIMAL(5,2),                  
 PWO_SPR_DISCPER DECIMAL(5,2)                  
 --change end                    
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,PWO_FIXED_VATPER DECIMAL(5,2)                  
 --END OF MODIFICATION                  
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER DECIMAL(10,4)                
 ,JOB_VAT_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_DISCOUNT        DECIMAL(20,2)                
 ,GM_AMOUNT         DECIMAL(20,2)                
 ,GM_DISCOUNT DECIMAL(20,2)                
 ,OWNRISK_AMOUNT         DECIMAL(20,2)                
 ,SP_VAT DECIMAL(20,2)                
 ,SP_AMT_DEB DECIMAL(20,2)              
 ,CUST_TYPE VARCHAR(20)             
 ,WO_OWN_RISK_DESC VARCHAR(100)          
 ,REDUCTION_PER DECIMAL(10,2)          
 ,REDUCTION_BEFORE_OR BIT          
 ,REDUCTION_AFTER_OR BIT                
 ,REDUCTION_AMOUNT DECIMAL(13,2)    
 ,CUST_DISC_GENERAL INT                             
 ,CUST_DISC_LABOUR INT    
 ,CUST_DISC_SPARES INT  
 ,DEB_STATUS VARCHAR(10)         
                
--END OF MODIFICATION                               
   )                                  
                                      
    EXEC SP_XML_REMOVEDOCUMENT @docHandle                                  
                          
                 
--    BEGIN TRAN                     
 --UPDATE FOR CUSTOMER DEBITOR                   
                  
                
                  
-- **************************************************************                  
 -- Modified Date : 15th September 2008                  
     -- Bug Id   : Test Journal Re-opened Issue                    
  BEGIN TRANSACTION @TRANNAME                 
DELETE FROM TBL_WO_JOB_DEBITOR_DISCOUNT                  
WHERE ID_WODEB_SEQ NOT IN (SELECT ID_DBT_SEQ FROM @INSERT_LIST)                            
 AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
 AND  ID_WO_NO  =  @IV_ID_WO_NO                       
 AND  ID_JOB_ID  =  @IV_ID_JOB_ID                  
-- ************** End Of Modification **************************                  
   IF @@ERROR <> 0                                                                   
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                                          
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                              
  RETURN 1                                  
 END                
                
 DELETE FROM  TBL_WO_DEBTOR_INVOICE_DATA                 
 WHERE DEBTOR_SEQ NOT IN (SELECT ID_DBT_SEQ FROM @INSERT_LIST)                            
 AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
 AND  ID_WO_NO  =  @IV_ID_WO_NO                       
 AND  ID_JOB_ID  =  @IV_ID_JOB_ID                    
                  
 DELETE  FROM TBL_WO_DEBITOR_DETAIL                       
 WHERE ID_DBT_SEQ NOT IN (SELECT ID_DBT_SEQ FROM @INSERT_LIST)                            
 AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
 AND  ID_WO_NO  =  @IV_ID_WO_NO                       
 AND  ID_JOB_ID  =  @IV_ID_JOB_ID                    
                      
 IF @@ERROR <> 0                         
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                                          
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                              
  RETURN 1                                  
 END                
--  SELECT *  FROM TBL_WO_DEBITOR_DETAIL WHERE ID_DBT_SEQ = 57                    
--        AND  ID_DBT_SEQ > 0           
--  AND  DEBITOR_TYPE = 'C'                       
                    
 UPDATE  TBL_WO_DEBITOR_DETAIL                                  
 SET  ID_JOB_DEB = A.ID_DETAIL,                              
   DEBITOR_TYPE = A.DEBITOR_TYPE,                              
   ID_DETAIL = A.ID_DETAIL,                              
   DBT_PER = A.DBT_PER,                              
   DBT_AMT = A.DBT_AMT,                              
   DBT_DIS_PER = A.DBT_DIS_PER ,                              
   MODIFIED_BY = @iv_MODIFIED_BY ,                              
   DT_MODIFIED = GETDATE()   ,                      
   SPLIT_PER = 0,                  
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 WO_VAT_PERCENTAGE=(                 
 CASE WHEN  @ITEMCOUNT=0 THEN                          
 PWO_GM_VATPER                 
 ELSE                           
 PWO_VAT_PERCENTAGE                 
 END)                
 /*CHANGE END - 21 JUNE 2010*/                
 ,WO_GM_PER=PWO_GM_PER,                  
 WO_GM_VATPER=PWO_GM_VATPER,                  
 WO_LBR_VATPER=PWO_LBR_VATPER,                  
 WO_SPR_DISCPER=PWO_SPR_DISCPER         
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,WO_FIXED_VATPER=PWO_FIXED_VATPER                  
 --END OF MODIFICATION                  
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER = A.ORG_PER                
,JOB_TOTAL=A.DBT_AMT                
 ,DEBTOR_VAT_PERCENTAGE=ISNULL((SELECT VAT_PERCENTAGE FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS=CUSTGRP.ID_VAT_CD),0)                
 ,JOB_VAT_AMOUNT=A.JOB_VAT_AMOUNT                     
 ,LABOUR_AMOUNT=A.LABOUR_AMOUNT                 
 ,LABOUR_DISCOUNT=A.LABOUR_DISCOUNT                 
 ,GM_AMOUNT=A.GM_AMOUNT                 
 ,GM_DISCOUNT=A.GM_DISCOUNT                 
 ,OWN_RISK_AMOUNT=A.OWNRISK_AMOUNT                
 --,TRANSFERREDVAT=dbo.fnGetTransferredVAT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX)                
 ,TRANSFERREDVAT=dbo.fnGetTransferredVAT_Job(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                 
 ,TRANSFERREDFROMCUSTID=dbo.fnGetVATTransFromCustID_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,TRANSFERREDFROMCUSTName=dbo.fnGetVATTransFromCustName_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,SP_VAT=A.SP_VAT                
 ,SP_AMT_DEB=A.SP_AMT_DEB                
 ,CUST_TYPE = A.CUST_TYPE             
 ,WO_OWN_RISK_DESC = A.WO_OWN_RISK_DESC             
 ,REDUCTION_PER = A.REDUCTION_PER          
 ,REDUCTION_BEFORE_OR = A.REDUCTION_BEFORE_OR          
 ,REDUCTION_AFTER_OR = A.REDUCTION_AFTER_OR          
 ,REDUCTION_AMOUNT = A.REDUCTION_AMOUNT    
 ,CUST_DISC_GENERAL = A.CUST_DISC_GENERAL     
 ,CUST_DISC_LABOUR = A.CUST_DISC_LABOUR     
 ,CUST_DISC_SPARES = A.CUST_DISC_SPARES   
 ,DEB_STATUS = A.DEB_STATUS   
                
--END OF MODIFICATION                 
 --change end                              
 FROM @INSERT_LIST A                   
   inner join TBL_MAS_CUSTOMER CUST                 
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                            
 WHERE TBL_WO_DEBITOR_DETAIL.ID_DBT_SEQ = A.ID_DBT_SEQ                      
    AND  TBL_WO_DEBITOR_DETAIL.ID_DBT_SEQ > 0                             
 AND  A.DEBITOR_TYPE = 'C'                     
                  
--MODIFIED DATE: 16 OCT 2008                  
--COMMENTS: WORK ORDER - DEBITOR ONLINE CHANGE                  
 AND  TBL_WO_DEBITOR_DETAIL.ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
 AND  TBL_WO_DEBITOR_DETAIL.ID_WO_NO  =  @IV_ID_WO_NO                       
 AND  TBL_WO_DEBITOR_DETAIL.ID_JOB_ID  =  @IV_ID_JOB_ID                    
--END OF MODIFICATION                  
                
 IF @@ERROR <> 0                        
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                                          
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                              
  RETURN 1                                  
 END                
                     
--  SELECT *  FROM TBL_WO_DEBITOR_DETAIL WHERE ID_DBT_SEQ = 57                    
--        AND  ID_DBT_SEQ > 0                             
--  AND  DEBITOR_TYPE = 'C'                       
                    
        INSERT INTO TBL_WO_DEBITOR_DETAIL                            
  (                            
   ID_WO_PREFIX,                        
   ID_WO_NO,                        
   ID_JOB_ID,                        
   ID_JOB_DEB,                          
   DEBITOR_TYPE,                        
   ID_DETAIL,                          
   DBT_PER,                          
   DBT_AMT,       
   DBT_DIS_PER,                       
   CREATED_BY,                        
   DT_CREATED,                        
   SPLIT_PER,                  
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 WO_VAT_PERCENTAGE,                  
 WO_GM_PER,                  
 WO_GM_VATPER,                  
 WO_LBR_VATPER,                  
 WO_SPR_DISCPER                   
 --change end                    
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,WO_FIXED_VATPER                  
 --END OF MODIFICATION                 
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER                
 ,JOB_TOTAL                
 ,DEBTOR_VAT_PERCENTAGE                
 ,JOB_VAT_AMOUNT                
 ,LABOUR_AMOUNT                
 ,LABOUR_DISCOUNT                
 ,GM_AMOUNT                
 ,GM_DISCOUNT                
 ,OWN_RISK_AMOUNT                
 ,TRANSFERREDVAT                
 ,TRANSFERREDFROMCUSTID                
 ,TRANSFERREDFROMCUSTName                 
 ,SP_VAT                
 ,SP_AMT_DEB               
 ,CUST_TYPE             
 ,WO_OWN_RISK_DESC          
 ,REDUCTION_PER           
 ,REDUCTION_BEFORE_OR           
 ,REDUCTION_AFTER_OR        
 ,REDUCTION_AMOUNT    
 ,CUST_DISC_GENERAL            
 ,CUST_DISC_LABOUR    
 ,CUST_DISC_SPARES   
 ,DEB_STATUS   
--END OF MODIFICATION                          
  )                            
  SELECT                           
   @IV_ID_WO_PREFIX,                        
   @IV_ID_WO_NO,                        
   @IV_ID_JOB_ID,                        
   A.ID_DETAIL,                           
   A.DEBITOR_TYPE,                        
   A.ID_DETAIL,                          
   A.DBT_PER,                          
   A.DBT_AMT,      
   A.DBT_DIS_PER,                        
   @IV_MODIFIED_BY,                        
   GETDATE(),                        
   0  ,                  
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 CASE WHEN  @ITEMCOUNT=0 THEN                          
 PWO_GM_VATPER                 
 ELSE        
 PWO_VAT_PERCENTAGE                 
 END,                  
 /*CHANGE END - 21 JUNE 2010*/                
 PWO_GM_PER,                  
 PWO_GM_VATPER,                  
 PWO_LBR_VATPER,                  
 PWO_SPR_DISCPER                   
 --change end                    
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,PWO_FIXED_VATPER                  
 --END OF MODIFICATION                  
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER                
 ,A.DBT_AMT                
 ,ISNULL((SELECT VAT_PERCENTAGE FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS=CUSTGRP.ID_VAT_CD),0)                
 ,A.JOB_VAT_AMOUNT                         
 ,A.LABOUR_AMOUNT                        
 ,A.LABOUR_DISCOUNT                         
 ,A.GM_AMOUNT                        
 ,A.GM_DISCOUNT                        
 ,A.OWNRISK_AMOUNT                
 --,dbo.fnGetTransferredVAT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX)                
 ,dbo.fnGetTransferredVAT_Job(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                 
 ,dbo.fnGetVATTransFromCustID_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,dbo.fnGetVATTransFromCustName_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,A.SP_VAT                
 ,A.SP_AMT_DEB                
 ,A.CUST_TYPE              
 ,A.WO_OWN_RISK_DESC          
 ,A.REDUCTION_PER           
 ,A.REDUCTION_BEFORE_OR           
 ,A.REDUCTION_AFTER_OR        
 ,A.REDUCTION_AMOUNT    
 ,A.CUST_DISC_GENERAL            
 ,A.CUST_DISC_LABOUR    
 ,A.CUST_DISC_SPARES  
 ,DEB_STATUS    
--END OF MODIFICATION                   
  FROM  @INSERT_LIST A                   
    inner join TBL_MAS_CUSTOMER CUST                 
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                      
  WHERE A.DEBITOR_TYPE  = 'C'                     
  and A.ID_DBT_SEQ=0                   
                
                
                  
 IF @@ERROR <> 0                                                                   
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                             
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                              
  RETURN 1                                  
 END                 
 --NEXT INSERT INTO THE TBL_WO_DETAIL FOR DEBITOR                      
 --CONDITION FIRST TAKE THE TOTAL INV_AMT > 0 THEN INSERT THE SPLIT PERCENTAGE ELSE 0                      
 --SUM THE DBT AMOUNT FROM TEMP TABLE                      
  DECLARE @SUMAMT AS DECIMAL                       
  SET  @SUMAMT = 0                      
  SELECT @SUMAMT = SUM(ISNULL(DBT_AMT,0))                       
  FROM @INSERT_LIST  A                        
  WHERE A.DEBITOR_TYPE  <> 'C'                      
                    
  --FIND THE INDIVIDUAL AMOUNT                      
  DECLARE @CUSTAMT AS DECIMAL                      
  SET  @CUSTAMT = 0                      
  SELECT @CUSTAMT = ISNULL(DBT_AMT,0)                       
  FROM @INSERT_LIST  A                        
  WHERE A.DEBITOR_TYPE  = 'C'            
                    
  --REMAINING AMOUNT AFTER                       
  DECLARE @REMAINAMT AS DECIMAL(15,2)                    
  SET @REMAINAMT = 0                      
  SET @REMAINAMT = @iv_TOTALAMT - @CUSTAMT                      
                      
  IF @@ERROR <> 0                                   
   SET @OV_RETVALUE = @@ERROR                                  
  ELSE                                  
  SET @ov_RetValue = '0'                                  
 -- DELETE THE DEBITOR                             
   UPDATE  TBL_WO_DEBITOR_DETAIL                                  
   SET                             
    ID_JOB_DEB = A.ID_DETAIL,                              
    DEBITOR_TYPE = A.DEBITOR_TYPE,                              
    ID_DETAIL = A.ID_DETAIL,                              
    DBT_PER  = A.DBT_PER,                              
    DBT_AMT  = A.DBT_AMT,                              
    DBT_DIS_PER = A.DBT_DIS_PER ,                              
    MODIFIED_BY = @iv_MODIFIED_BY ,                              
    DT_MODIFIED = GETDATE()  ,                   
 --Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 WO_VAT_PERCENTAGE=(                
 CASE WHEN  @ITEMCOUNT=0 THEN                          
  PWO_GM_VATPER                 
 ELSE                           
  PWO_VAT_PERCENTAGE                 
 END),                 
 /*CHANGE END - 21 JUNE 2010*/                 
 WO_GM_PER=PWO_GM_PER,                  
 WO_GM_VATPER=PWO_GM_VATPER,                  
 WO_LBR_VATPER=PWO_LBR_VATPER,                  
 WO_SPR_DISCPER=PWO_SPR_DISCPER,                
 --change end                   
 SPLIT_PER = CASE WHEN @iv_OWNRISKAMT > 0 THEN                      
     (ISNULL(A.DBT_AMT,0) *100 ) / @REMAINAMT                      
    ELSE                       
     A.DBT_PER                      
    END                      
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,WO_FIXED_VATPER=PWO_FIXED_VATPER                  
 --END OF MODIFICATION                 
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER = A.ORG_PER                
,JOB_TOTAL=A.DBT_AMT                
 ,DEBTOR_VAT_PERCENTAGE=ISNULL((SELECT VAT_PERCENTAGE FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS=CUSTGRP.ID_VAT_CD),0)                
 ,JOB_VAT_AMOUNT=A.JOB_VAT_AMOUNT                     
 ,LABOUR_AMOUNT=A.LABOUR_AMOUNT                 
 ,LABOUR_DISCOUNT=A.LABOUR_DISCOUNT                 
 ,GM_AMOUNT=A.GM_AMOUNT                  
 ,GM_DISCOUNT=A.GM_DISCOUNT                 
 ,OWN_RISK_AMOUNT=A.OWNRISK_AMOUNT                
 ,TRANSFERREDVAT=dbo.fnGetTransferredVAT_Job(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)  --dbo.fnGetTransferredVAT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX)                
 ,TRANSFERREDFROMCUSTID=dbo.fnGetVATTransFromCustID_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,TRANSFERREDFROMCUSTName=dbo.fnGetVATTransFromCustName_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,SP_VAT=A.SP_VAT                
 ,SP_AMT_DEB=A.SP_AMT_DEB                
 ,CUST_TYPE = A.CUST_TYPE              
 ,WO_OWN_RISK_DESC = A.WO_OWN_RISK_DESC          
 ,REDUCTION_PER = A.REDUCTION_PER          
 ,REDUCTION_BEFORE_OR = A.REDUCTION_BEFORE_OR          
 ,REDUCTION_AFTER_OR = A.REDUCTION_AFTER_OR                 
 ,REDUCTION_AMOUNT = A.REDUCTION_AMOUNT    
 ,CUST_DISC_GENERAL = A.CUST_DISC_GENERAL            
 ,CUST_DISC_LABOUR = A.CUST_DISC_LABOUR    
 ,CUST_DISC_SPARES = A.CUST_DISC_SPARES    
 ,DEB_STATUS = A.DEB_STATUS   
--END OF MODIFICATION                     
   FROM @INSERT_LIST A                   
     inner join TBL_MAS_CUSTOMER CUST                 
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                             
   WHERE   TBL_WO_DEBITOR_DETAIL.ID_DBT_SEQ = A.ID_DBT_SEQ                      
   AND  TBL_WO_DEBITOR_DETAIL.ID_DBT_SEQ > 0                           
   AND  A.DEBITOR_TYPE <> 'C'                       
--MODIFIED DATE: 16 OCT 2008                  
--COMMENTS: WORK ORDER - DEBITOR ONLINE CHANGE                  
 AND  TBL_WO_DEBITOR_DETAIL.ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
 AND  TBL_WO_DEBITOR_DETAIL.ID_WO_NO  =  @IV_ID_WO_NO                       
 AND  TBL_WO_DEBITOR_DETAIL.ID_JOB_ID  =  @IV_ID_JOB_ID                    
--END OF MODIFICATION                  
                
                  
     IF @@ERROR <> 0                                   
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                                          
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                              
  RETURN 1                                  
 END                   
                     
                       
INSERT INTO TBL_WO_DEBITOR_DETAIL                            
   (                            
    ID_WO_PREFIX,                        
    ID_WO_NO,                        
    ID_JOB_ID,                        
    ID_JOB_DEB,                          
    DEBITOR_TYPE,                        
    ID_DETAIL,                          
    DBT_PER,                          
    DBT_AMT,      
    DBT_DIS_PER,                        
    CREATED_BY,                        
    DT_CREATED,    
 WO_VAT_PERCENTAGE,                  
 WO_GM_PER,                  
 WO_GM_VATPER,                  
 WO_LBR_VATPER,                  
 WO_SPR_DISCPER,                   
    SPLIT_PER,                   
 WO_FIXED_VATPER,    
 ORG_PER                
    ,JOB_TOTAL             
  ,DEBTOR_VAT_PERCENTAGE                
  ,JOB_VAT_AMOUNT                
  ,LABOUR_AMOUNT                
  ,LABOUR_DISCOUNT                
  ,GM_AMOUNT                
  ,GM_DISCOUNT                
  ,OWN_RISK_AMOUNT                
  ,TRANSFERREDVAT                
  ,TRANSFERREDFROMCUSTID                
  ,TRANSFERREDFROMCUSTName                
  ,SP_VAT                
  ,SP_AMT_DEB                
  ,CUST_TYPE             
  ,WO_OWN_RISK_DESC          
  ,REDUCTION_PER           
  ,REDUCTION_BEFORE_OR          
  ,REDUCTION_AFTER_OR        
  ,REDUCTION_AMOUNT    
  ,CUST_DISC_GENERAL          
  ,CUST_DISC_LABOUR    
  ,CUST_DISC_SPARES   
  ,DEB_STATUS   
   )                            
   SELECT                           
    @IV_ID_WO_PREFIX,                        
    @IV_ID_WO_NO,                      
    @IV_ID_JOB_ID,                        
    A.ID_DETAIL,                           
    A.DEBITOR_TYPE,                        
    A.ID_DETAIL,                      
   A.DBT_PER,                    
      A.DBT_AMT,      
      A.DBT_DIS_PER,                     
    @IV_MODIFIED_BY,                        
    GETDATE(),                   
    /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 CASE WHEN  @ITEMCOUNT=0 THEN                          
 PWO_GM_VATPER                 
 ELSE                           
 PWO_VAT_PERCENTAGE                 
 END,                  
 /*CHANGE END - 21 JUNE 2010*/                
 PWO_GM_PER,                  
 PWO_GM_VATPER,                  
 PWO_LBR_VATPER,                  
 PWO_SPR_DISCPER,                   
                 
 --change made same as save for split_per calc                
        0                
    --CASE WHEN @iv_OWNRISKAMT > 0 THEN                      
    -- (ISNULL(A.DBT_AMT,0) *100 ) / @REMAINAMT                      
    --ELSE                       
    --   A.DBT_PER                    
    --END                  
 ,PWO_FIXED_VATPER,ORG_PER           
  ,A.DBT_AMT                
 ,ISNULL((SELECT VAT_PERCENTAGE FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS=CUSTGRP.ID_VAT_CD),0)                
 ,A.JOB_VAT_AMOUNT                         
 ,A.LABOUR_AMOUNT                        
 ,A.LABOUR_DISCOUNT                         
 ,A.GM_AMOUNT                        
 ,A.GM_DISCOUNT                        
 ,A.OWNRISK_AMOUNT                
 --,dbo.fnGetTransferredVAT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX)                
 ,dbo.fnGetTransferredVAT_Job(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                 
 ,dbo.fnGetVATTransFromCustID_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,dbo.fnGetVATTransFromCustName_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)             
 ,A.SP_VAT                
 ,A.SP_AMT_DEB               
 ,A.CUST_TYPE             
 ,A.WO_OWN_RISK_DESC          
 ,A.REDUCTION_PER           
 ,A.REDUCTION_BEFORE_OR           
 ,A.REDUCTION_AFTER_OR        
 ,A.REDUCTION_AMOUNT    
 ,A.CUST_DISC_GENERAL     
 ,A.CUST_DISC_LABOUR    
 ,A.CUST_DISC_SPARES   
 ,A.DEB_STATUS   
 FROM  @INSERT_LIST A                  
   inner join TBL_MAS_CUSTOMER CUST                 
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                         
   WHERE A.DEBITOR_TYPE = 'C' and A.DBT_PER=0                   
 AND A.ID_DBT_SEQ IN                  
  (                  
   SELECT ID_DBT_SEQ FROM @INSERT_LIST                  
    WHERE ID_DBT_SEQ NOT IN (SELECT ID_DBT_SEQ FROM TBL_WO_DEBITOR_DETAIL                  
           WHERE  ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
           AND  ID_WO_NO  =  @IV_ID_WO_NO                       
           AND  ID_JOB_ID  =  @IV_ID_JOB_ID)                  
  )                
                
                
                
 IF @@ERROR <> 0                                                                   
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                                          
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                     
  RETURN 1                  
END                 
                
   INSERT INTO TBL_WO_DEBITOR_DETAIL                            
   (                            
    ID_WO_PREFIX,                        
    ID_WO_NO,                        
    ID_JOB_ID,                        
    ID_JOB_DEB,                          
    DEBITOR_TYPE,                        
    ID_DETAIL,                          
    DBT_PER,                          
    DBT_AMT,      
    DBT_DIS_PER,                        
    CREATED_BY,                        
    DT_CREATED,                   
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 WO_VAT_PERCENTAGE,                  
 WO_GM_PER,                  
 WO_GM_VATPER,                  
 WO_LBR_VATPER,                  
 WO_SPR_DISCPER,                   
 --change end                        
    SPLIT_PER                   
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,WO_FIXED_VATPER                  
 --END OF MODIFICATION                    
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER                
,JOB_TOTAL                
 ,DEBTOR_VAT_PERCENTAGE                
 ,JOB_VAT_AMOUNT                
 ,LABOUR_AMOUNT                
 ,LABOUR_DISCOUNT                
 ,GM_AMOUNT                
 ,GM_DISCOUNT                
 ,OWN_RISK_AMOUNT                
 ,TRANSFERREDVAT                
 ,TRANSFERREDFROMCUSTID                
 ,TRANSFERREDFROMCUSTName                
 ,SP_VAT                
 ,SP_AMT_DEB                
 ,CUST_TYPE        
 ,WO_OWN_RISK_DESC          
 ,REDUCTION_PER           
 ,REDUCTION_BEFORE_OR           
 ,REDUCTION_AFTER_OR        
 ,REDUCTION_AMOUNT    
 ,CUST_DISC_GENERAL    
 ,CUST_DISC_LABOUR    
 ,CUST_DISC_SPARES   
 ,DEB_STATUS                 
--END OF MODIFICATION                      
   )                            
   SELECT                           
    @IV_ID_WO_PREFIX,                        
    @IV_ID_WO_NO,                        
    @IV_ID_JOB_ID,                        
    A.ID_DETAIL,                           
    A.DEBITOR_TYPE,                        
    A.ID_DETAIL,                      
    --Modified Date: 17th May 2008                    
    -- Description :  Amout and Percentage Got Exchanged                    
    --A.DBT_AMT,                      
    --A.DBT_PER,                    
                  A.DBT_PER,                    
      A.DBT_AMT,      
      A.DBT_DIS_PER,                     
    @IV_MODIFIED_BY,                        
    GETDATE(),                   
--Bug ID :-3508                  
 --Date   :-15-Aug-2008                  
 --Desc   :- Adding Each Customer Vat details                  
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 CASE WHEN  @ITEMCOUNT=0 THEN                          
 PWO_GM_VATPER                 
 ELSE                           
 PWO_VAT_PERCENTAGE                 
 END,                  
 /*CHANGE END - 21 JUNE 2010*/                
 PWO_GM_PER,                  
 PWO_GM_VATPER,                  
 PWO_LBR_VATPER,                  
 PWO_SPR_DISCPER,                   
 --change end                        
    CASE WHEN @iv_OWNRISKAMT > 0 THEN                      
     (ISNULL(A.DBT_AMT,0) *100 ) / @REMAINAMT                      
    ELSE                       
       A.DBT_PER                    
    END                        
 --MODIFIED DATE: 23 OCT 2008                  
 --COMMENTS: WORK ORDER - INCL FIXED PRICE VAT                  
 ,PWO_FIXED_VATPER                  
 --END OF MODIFICATION                  
--MODIFIED DATE: 17 NOV 2008                
--COMMENTS: WORK ORDER - ORGINAL SPLIT PERCENTAGE                
,ORG_PER                
 ,A.DBT_AMT                
 ,ISNULL((SELECT VAT_PERCENTAGE FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS=CUSTGRP.ID_VAT_CD),0)                
 ,A.JOB_VAT_AMOUNT                         
 ,A.LABOUR_AMOUNT                        
 ,A.LABOUR_DISCOUNT                        
 ,A.GM_AMOUNT                        
 ,A.GM_DISCOUNT                        
 ,A.OWNRISK_AMOUNT                
 --,dbo.fnGetTransferredVAT(@IV_ID_WO_NO,@IV_ID_WO_PREFIX)                
 ,dbo.fnGetTransferredVAT_Job(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                 
 ,dbo.fnGetVATTransFromCustID_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,dbo.fnGetVATTransFromCustName_Deb(@IV_ID_WO_NO,@IV_ID_WO_PREFIX,@IV_ID_JOB_ID)                
 ,A.SP_VAT                
 ,A.SP_AMT_DEB                
 ,A.CUST_TYPE        
 ,A.WO_OWN_RISK_DESC          
 ,A.REDUCTION_PER           
 ,A.REDUCTION_BEFORE_OR           
 ,A.REDUCTION_AFTER_OR        
 ,A.REDUCTION_AMOUNT    
 ,A.CUST_DISC_GENERAL    
 ,A.CUST_DISC_LABOUR    
 ,A.CUST_DISC_SPARES   
 ,A.DEB_STATUS        
--END OF MODIFICATION                 
   FROM  @INSERT_LIST A                   
     inner join TBL_MAS_CUSTOMER CUST                 
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                        
   WHERE A.DEBITOR_TYPE <> 'C'                    
--MODIFIED DATE: 16 OCT 2008                  
--COMMENTS: WORK ORDER - DEBITOR ONLINE CHANGE                  
                  
--and A.ID_DBT_SEQ=0                    
 AND A.ID_DBT_SEQ IN                  
  (                  
   SELECT ID_DBT_SEQ FROM @INSERT_LIST                  
    WHERE ID_DBT_SEQ NOT IN (SELECT ID_DBT_SEQ FROM TBL_WO_DEBITOR_DETAIL                  
           WHERE  ID_WO_PREFIX = @IV_ID_WO_PREFIX                        
           AND  ID_WO_NO  =  @IV_ID_WO_NO                       
           AND  ID_JOB_ID  =  @IV_ID_JOB_ID)                  
  )                  
                  
                
                  
   exec USP_WO_DEBITOR_INVOICEDATA_INSERT @IV_ID_WO_PREFIX,@IV_ID_JOB_ID,@IV_ID_WO_NO,@IV_MODIFIED_BY      
   
    print  @IV_ID_WO_PREFIX              
   print @IV_ID_JOB_ID
   print @IV_ID_WO_NO
   print @IV_MODIFIED_BY          
                  
 IF @@ERROR <> 0                                                                   
 BEGIN                                                              
  SET @OV_RETVALUE = @@ERROR                                                   
  ROLLBACK TRANSACTION @TRANNAME                                                                          
  SELECT @@ERROR,  @OV_RETVALUE AS 'return1'                              
  RETURN 1                          
 END                
                        
 ELSE                
 BEGIN                
  COMMIT TRANSACTION @TRANNAME                                
 END                
                 
--END OF MODIFICATION                  
                  
--ROLLBACK TRAN                    
--select 'test'              
                    
                           
END                                
                                  
/*                                  
--- exec [USP_WO_DEBITORDETIAL_Insert]                         
                    
SELECT * FROM TBL_WO_DEBITOR_DETAIL                    
exec [USP_WO_DEBITORDETIAL_UPDATE]                                
'<root><insert ID_DETAIL="10005" ID_DBT_SEQ="57" DEBITOR_TYPE="C" DBT_AMT="2525" DBT_PER="100"/></root>',                        
'TS',                        
 3,                        
'103',                        
'ADMIN',                        
0,                      
2525,                      
null                                
                     
    delete from TBL_WO_DEBITOR_DETAIL WHERE id_dbt_seq = 20                    
SELECT * FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = '14'                      
                            
                         
*/ 

GO

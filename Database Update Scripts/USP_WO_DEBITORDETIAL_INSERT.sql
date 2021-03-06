/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITORDETIAL_INSERT]    Script Date: 3/30/2017 11:49:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITORDETIAL_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_DEBITORDETIAL_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_DEBITORDETIAL_INSERT]    Script Date: 3/30/2017 11:49:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_DEBITORDETIAL_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_DEBITORDETIAL_INSERT] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                            
* Module : Work Order                           
* File name : USP_WO_DEBITORDETIAL_INSERT .prc                            
* Purpose :                           
* Author : Subramani                          
* Date  : 27.10.2006                          
*********************************************************************************************************************/                            
/*********************************************************************************************************************                              
I/P : -- Input Parameters                            
O/P : -- Output Parameters                            
Error Code                            
Description      INT.VerNO : NOV21.0                        
                            
********************************************************************************************************************/                            
--'*********************************************************************************'*********************************                            
--'* Modified History :                               
--'* S.No  RFC No/Bug ID   Date        Author  Description                             
--*#0001#                             
--'*********************************************************************************'*********************************                            
                          
ALTER PROC [dbo].[USP_WO_DEBITORDETIAL_INSERT]                              
(                              
    @IV_XMLDOC   NTEXT, --VARCHAR(7000),                              
    @IV_ID_WO_PREFIX    VARCHAR(3),                            
    @IV_ID_JOB_ID       INT,                            
    @IV_ID_WO_NO        VARCHAR(10),                             
    @IV_CREATED_BY      VARCHAR(20),                            
 @IV_OWNRISKAMT  DECIMAL(15,2),                          
 @IV_TOTALAMT  DECIMAL(15,2),                          
    @OV_RETVALUE  VARCHAR(10)   OUTPUT                             
)                              
AS                              
BEGIN                              
  DECLARE @docHandle int                               
  DECLARE @CONFIGLISTCNI AS VARCHAR(2000)                              
  DECLARE @CFGLSTINSERTED AS VARCHAR(2000)                              
  /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
  DECLARE @ITEMCOUNT AS INT                
                            
 SELECT  @ITEMCOUNT=COUNT(*)                 
    FROM TBL_WO_JOB_DETAIL JOB                
    INNER JOIN TBL_WO_DETAIL WO                    
    ON JOB.ID_WODET_SEQ_JOB = WO.ID_WODET_SEQ                
 WHERE WO.ID_WO_NO=@IV_ID_WO_NO AND WO.ID_WO_PREFIX=@IV_ID_WO_PREFIX AND WO.ID_JOB =@IV_ID_JOB_ID                  
  /*CHANGE END - 21 JUNE 2010*/                
                  
                
                  
  EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_xmlDoc                              
  DECLARE @INSERT_LIST TABLE                              
  (                              
    DEBITOR_TYPE    CHAR,                            
    ID_DETAIL       VARCHAR(10),                            
    DBT_PER         DECIMAL(15,2),                            
    DBT_AMT         DECIMAL(15,2),      
    DBT_DIS_PER  DECIMAL(15,2),         
                 
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
 ,ORG_PER DECIMAL(10,2)                
 ,JOB_VAT_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_DISCOUNT         DECIMAL(20,2)                
 ,GM_AMOUNT         DECIMAL(20,2)                
 ,GM_DISCOUNT         DECIMAL(20,2)               
 ,OWNRISK_AMOUNT        DECIMAL(20,2)                
 ,SP_VAT DECIMAL(20,2)                
 ,SP_AMT_DEB DECIMAL(20,2)              
 ,CUST_TYPE  VARCHAR(20)            
 ,WO_OWN_RISK_DESC VARCHAR(100)          
 ,REDUCTION_PER DECIMAL(10,2)          
 ,REDUCTION_BEFORE_OR BIT          
 ,REDUCTION_AFTER_OR BIT        
 ,REDUCTION_AMOUNT DECIMAL(13,2)    
 ,CUST_DISC_GENERAL INT                             
 ,CUST_DISC_LABOUR INT    
 ,CUST_DISC_SPARES INT              
 --END OF MODIFICATION                 
                       
  )                              
  INSERT INTO @INSERT_LIST                              
  SELECT                        DEBITOR_TYPE,                            
    ID_DETAIL,                            
    DBT_PER,                            
    DBT_AMT,      
    DBT_DIS_PER,                
                  
    --Bug ID :-3508                
 --Date   :-15-Aug-2008                
 --Desc   :- Adding Each Customer Vat details                
 PWO_VAT_PERCENTAGE,                
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
 --END OF MODIFICATION                         
                           
  FROM OPENXML (@DOCHANDLE,'root/insert',1) WITH                               
  (                              
    DEBITOR_TYPE    CHAR,                            
    ID_DETAIL       VARCHAR(10),                            
    DBT_PER         DECIMAL(15,2),                            
    DBT_AMT         DECIMAL(15,2),      
    DBT_DIS_PER  DECIMAL(15,2),                
                
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
 ,ORG_PER DECIMAL(10,2)                
 ,JOB_VAT_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_AMOUNT         DECIMAL(20,2)                
 ,LABOUR_DISCOUNT        DECIMAL(20,2)                
 ,GM_AMOUNT         DECIMAL(20,2)                
 ,GM_DISCOUNT        DECIMAL(20,2)                
 ,OWNRISK_AMOUNT         DECIMAL(20,2)                
 ,SP_VAT DECIMAL(20,2)                
 ,SP_AMT_DEB DECIMAL(20,2)              
 ,CUST_TYPE VARCHAR(20)            
 ,WO_OWN_RISK_DESC VARCHAR(20)          
 ,REDUCTION_PER DECIMAL(10,2)          
 ,REDUCTION_BEFORE_OR BIT          
 ,REDUCTION_AFTER_OR BIT                 
 ,REDUCTION_AMOUNT DECIMAL(13,2)   ,CUST_DISC_GENERAL INT                             
 ,CUST_DISC_LABOUR INT    
 ,CUST_DISC_SPARES INT           
 --END OF MODIFICATION                              
  )                              
                                
  EXEC SP_XML_REMOVEDOCUMENT @docHandle                   
                          
                          
                 
   select * from @INSERT_LIST                    
                
  --FIRST INSERT INTO THE TBL_WO_DEBITOR_DETAIL WHERE CUSTOMER CONDITION IS 'C' THEN SPLIT AMT IS 0                          
  INSERT INTO TBL_WO_DEBITOR_DETAIL                              
  (                              
    --ID_DBT_SEQ,                  
    ID_WO_PREFIX,                          
   ID_WO_NO,                          
  ID_JOB_ID,                          
 ID_JOB_DEB,                            
    DEBITOR_TYPE,                          
 --ID_DETAIL,                            
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
         
 --END OF MODIFICATION                       
                             
  )                              
  SELECT                             
    --MAX(ISNULL(B.ID_DBT_SEQ,0)) +  ROW_NUMBER() OVER(ORDER BY A.ID_DETAIL DESC) ,                              
    @IV_ID_WO_PREFIX,                          
 @IV_ID_WO_NO,                          
 @IV_ID_JOB_ID,                          
 A.ID_DETAIL,                             
    A.DEBITOR_TYPE,                          
 --A.ID_DETAIL,                            
    A.DBT_PER,                            
    A.DBT_AMT,      
    A.DBT_DIS_PER,                          
 @IV_CREATED_BY,                          
 GETDATE(),                 
--Bug ID :-3508                
 --Date   :-15-Aug-2008                
 --Desc   :- Adding Each Customer Vat details                
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 CASE WHEN  @ITEMCOUNT=0 THEN                          
 PWO_GM_VATPER                 
 ELSE                           
 PWO_VAT_PERCENTAGE                 
 END                 
 /*CHANGE END - 21 JUNE 2010*/                
 ,PWO_GM_PER,                
 PWO_GM_VATPER,     
 PWO_LBR_VATPER,                
 PWO_SPR_DISCPER,                 
 --change end                          
 0                
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
 --END OF MODIFICATION                       
                    
  FROM  @INSERT_LIST  A                    
  inner join TBL_MAS_CUSTOMER CUST              
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                   
  WHERE A.DEBITOR_TYPE  = 'C'                   
                  
                   
                
 --NEXT INSERT INTO THE TBL_WO_DETAIL FOR DEBITOR                          
 --CONDITION FIRST TAKE THE TOTAL INV_AMT > 0 THEN INSERT THE SPLIT PERCENTAGE ELSE 0                          
                          
 --SUM THE DBT AMOUNT FROM TEMP TABLE                          
 DECLARE @SUMAMT AS DECIMAL(15,2)                           
 SET @SUMAMT = 0                        
 SELECT @SUMAMT = SUM(ISNULL(DBT_AMT,0))                           
 FROM   @INSERT_LIST  A                            
 WHERE  A.DEBITOR_TYPE  <> 'C'                          
                          
 --FIND THE INDIVIDUAL AMOUNT                          
 DECLARE @CUSTAMT AS DECIMAL(15,2)                          
 SET  @CUSTAMT = 0                          
 SELECT @CUSTAMT = ISNULL(DBT_AMT,0)                           
 FROM @INSERT_LIST  A                            
 WHERE A.DEBITOR_TYPE  = 'C'                          
                          
 --REMAINING AMOUNT AFTER                           
 DECLARE @REMAINAMT AS DECIMAL(15,2)                          
 SET  @REMAINAMT = 0                          
 SET  @REMAINAMT = @iv_TOTALAMT - @CUSTAMT                          
                           
  INSERT INTO TBL_WO_DEBITOR_DETAIL                              
  (                              
    --ID_DBT_SEQ,                            
    ID_WO_PREFIX,                          
 ID_WO_NO,                          
 ID_JOB_ID,                          
 ID_JOB_DEB,                            
    DEBITOR_TYPE,                          
 --ID_DETAIL,                            
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
 --END OF MODIFICATION                    
                            
  )                              
  SELECT                             
    --MAX(ISNULL(B.ID_DBT_SEQ,0)) +  ROW_NUMBER() OVER(ORDER BY A.ID_DETAIL DESC) ,                              
    @iv_ID_WO_PREFIX,                          
 @iv_ID_WO_NO,                          
 @iv_ID_JOB_ID,                          
 A.ID_DETAIL,                             
    A.DEBITOR_TYPE,                          
 --A.ID_DETAIL,                            
    A.DBT_PER,                            
    A.DBT_AMT,      
    A.DBT_DIS_PER,                          
 @iv_CREATED_BY,                          
 getdate(),                     
                
 --Bug ID :-3508                
 --Date   :-15-Aug-2008                
 --Desc   :- Adding Each Customer Vat details                
 /*CHANGE FOR FETCHING VAT PERCENTAGE WHEN NO SPARE PART IS ADDED - 21 JUNE 2010*/                
 CASE WHEN  @ITEMCOUNT=0 THEN                          
 PWO_GM_VATPER                 
 ELSE                           
 PWO_VAT_PERCENTAGE                 
 END                 
 /*CHANGE END - 21 JUNE 2010*/          
 ,PWO_GM_PER,                
 PWO_GM_VATPER,                
 PWO_LBR_VATPER,                
 PWO_SPR_DISCPER,                
 --change end                      
    CASE WHEN @iv_OWNRISKAMT > 0 THEN                          
  (ISNULL(A.DBT_AMT,0) *100 ) / @REMAINAMT                          
 ELSE                           
  DBT_PER                 
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
 --END OF MODIFICATION                              
  FROM @INSERT_LIST  A         
    inner join TBL_MAS_CUSTOMER CUST                 
  on A.ID_DETAIL=CUST.ID_CUSTOMER                
  inner join TBL_MAS_CUST_GROUP CUSTGRP                
  on  CUSTGRP.ID_CUST_GRP_SEQ= CUST.ID_CUST_GROUP                          
  WHERE A.DEBITOR_TYPE  <> 'C'                 
                
                  
     --exec USP_WO_DEBITOR_INVOICEDATA_INSERT @IV_ID_WO_PREFIX,@IV_ID_JOB_ID,@IV_ID_WO_NO,@IV_CREATED_BY                
              
                  
  /*---, TBL_WO_DEBITOR_DETAIL B                            
 GROUP BY                            
    A.DEBITOR_TYPE,A.ID_DETAIL,A.DBT_PER,                            
    A.DBT_AMT */                 
                            
  IF @@ERROR <> 0                               
 SET @OV_RETVALUE = @@ERROR                              
  ELSE                              
 SET @OV_RETVALUE = '0'                   
                 
                 
 --    IF @@ERROR <> 0           
 --SET @OV_RETVALUE = @@ERROR                              
 -- ELSE                              
 --SET @OV_RETVALUE = '0'                           
END                            
                              
/*                              
SELECT * FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = '0114'                          
AND SPLIT_PER IS NOT NULL                      
                          
Declare @OV_RETVALUE  VARCHAR(10)                        
exec [USP_WO_DEBITORDETIAL_INSERT]                      
'<root><insert ID_DETAIL="1000" DEBITOR_TYPE="C" DBT_AMT="1386" DBT_PER="100"/></root>',                       
'WO',                      
1,                      
'1003',                      
'ADMIN',                      
0,                      
10000,                      
@OV_RETVALUE OUTPUT                      
                      
exec [USP_WO_DEBITORDETIAL_INSERT]                            
'<root>                          
<insert ID_DETAIL="5656565656" DEBITOR_TYPE="C" DBT_AMT="2000" DBT_PER="100"/>                          
<insert ID_DETAIL="5656565656" DEBITOR_TYPE="D" DBT_AMT="3000" DBT_PER="100"/>                          
<insert ID_DETAIL="5656565656" DEBITOR_TYPE="D" DBT_AMT="4000" DBT_PER="100"/>                        
</root>',                            
'PR',                            
4,                            
'0114',                            
'ADMIN',                            
0,                          
10000,                          
null                            
*/ 

GO

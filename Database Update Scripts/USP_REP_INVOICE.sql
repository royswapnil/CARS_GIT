/****** Object:  StoredProcedure [dbo].[USP_REP_INVOICE]    Script Date: 8/7/2017 1:16:25 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_INVOICE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_REP_INVOICE]
GO
/****** Object:  StoredProcedure [dbo].[USP_REP_INVOICE]    Script Date: 8/7/2017 1:16:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_INVOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_REP_INVOICE] AS' 
END
GO
-- =============================================                
-- Author:        VMSSanthosh                
-- Create date: 10-Oct-2008                
-- Description:    To print Invoice Report                
-- =============================================   
-- =============================================                
-- Author:        Praveen K  
-- Modified date: 05-Jun-13                
-- Description:    Added No-Lock (WWW List Row 621 Batch invoice deadlock issue)   
-- =============================================      
-- Author:    Praveen K  
-- Modified Date: 27-Jun-2013  
-- Description:   ROW 625 Added condition to check for fixed for Labour Line   
 -- =============================================      
 -- =============================================      
-- Author:    Praveen K  
-- Modified Date: 17-Jul-2014  
-- Description:   ROW 761 Added condition to check for Veh Reg Num exists on Order Head   
 -- =============================================      
              
ALTER PROCEDURE [dbo].[USP_REP_INVOICE]                
    @INV_NOSXML XML = '<ROOT><ID_INV_NO ID_INV_NO="INV972"/></ROOT>',                
 @TYPE VARCHAR(50) ='INVOICE'    
                    
AS                
BEGIN     
  
--SECTION 1  
DECLARE @NEW_GUID AS VARCHAR(MAX)  
SET @NEW_GUID = NEWID()  
  
INSERT INTO TBL_INV_CREATE_TRACK values (@INV_NOSXML,'Start CreateREP',getdate(),22,@NEW_GUID)  
   DECLARE @IDOC AS INT                      
   DECLARE @isInvoice DECIMAL(15,2)  
                
          
   DECLARE @TEMPTAB TABLE                      
   (                      
     ID_INV_NO VARCHAR(20)             
    )              
                   
 EXEC SP_XML_PREPAREDOCUMENT @IDOC  OUTPUT,@INV_NOSXML                      
                      
 INSERT INTO @TEMPTAB                      
  SELECT * FROM                       
   OPENXML (@IDOC,'ROOT/ID_INV_NO',1)                      
  WITH                      
  (                       
   ID_INV_NO VARCHAR(20)                      
                       
  )   
    
  /* ROW 429 - Included Credit Notes in the history search page */  
    
  set @TYPE = case when (SELECT top 1 ID_INV_NO FROM @TEMPTAB) in (select ID_CN_NO from TBL_INV_HEADER)   
  and @TYPE = 'Invoice'  
  then   
  'CreditNote'   
  else   
  @TYPE   
  end  
    
  /* ROW 429 - Included Credit Notes in the history search page */  
    
 IF @TYPE = 'CreditNote'            
  SET @isInvoice = -1            
 ELSE IF @TYPE = 'VACreditNote'   
  SET @isInvoice = -1   
 ELSE          
  SET @isInvoice = 1    
    
    
  --select '@isInvoice',@isInvoice  
    
  DECLARE @LAB_INV TABLE  
  (  
 ID_INV_NO VARCHAR(20)  
 )  
   
 INSERT INTO @LAB_INV  
 SELECT ID_INV_NO FROM TBL_INV_HEADER WHERE ID_CN_NO IN (SELECT ID_INV_NO FROM @TEMPTAB)  
   
  
    
  DECLARE @FLAGSS3 AS BIT  
  SELECT  @FLAGSS3 = md.FLG_DPT_WareHouse   
  FROM TBL_INV_HEADER IH WITH(NOLOCK)  
  LEFT OUTER JOIN TBL_MAS_DEPT md WITH(NOLOCK)               
  ON md.ID_DEPT = ih.ID_DEPT_INV    
  WHERE                
  ((ih.ID_INV_NO IN                
                    (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = 1)            
  OR  ((ih.ID_CN_NO IN                
                    (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = -1)       
    
                   
                
 EXEC SP_XML_REMOVEDOCUMENT @IDOC                  
                    
    SET NOCOUNT ON;    
    IF (@FLAGSS3 =  0)     
    BEGIN      
 INSERT INTO TBL_INV_CREATE_TRACK values (@INV_NOSXML,'Start Process1- Report parameters fetched here',getdate(),23,@NEW_GUID)  
   
 --SELECT * INTO #Temp1 FROM (  
 SELECT                 
  'Spares' as [Type],                
                     
  --Subsidiary Information                
  ISNULL(INVSD.SUBSIDIARYNAME,'') AS 'SUBSIDIARYNAME',                         
  ISNULL(INVSD.SUBSIDIARYADDRESS1,'') AS 'SUBSIDIARYADDRESS1',                
  ISNULL(INVSD.SUBSIDIARYADDRESS2,'') AS 'SUBSIDIARYADDRESS2',                       
  ISNULL(INVSD.SUBSIDIARYCITY,'') AS 'SUBSIDIARYCITY',                
  ISNULL(INVSD.SUBSIDIARYZIPCODE,'') AS 'SUBSIDIARYZIPCODE',              
  ISNULL(INVSD.SUBSIDIARYSTATE,'') AS 'SUBSIDIARYSTATE',                
  ISNULL(INVSD.SUBSIDIARYCOUNTRY,'') AS 'SUBSIDIARYCOUNTRY',      
  ISNULL(INVSD.SUBSIDIARYPHONE1,'') AS 'SUBSIDIARYPHONE1',                
  ISNULL(INVSD.SUBSIDIARYPHONE2,'') AS 'SUBSIDIARYPHONE2',                           
  ISNULL(INVSD.SUBSIDIARYMOBILE,'') AS 'SUBSIDIARYMOBILE',                
  ISNULL(INVSD.SUBSIDIARYFAX,'') AS 'SUBSIDIARYFAX',                                 
  ISNULL(INVSD.SUBSIDIARYEMAIL,'') AS 'SUBSIDIARYEMAIL',                
  ISNULL(INVSD.SUBSIDIARYORGANIZATIONNO,'') AS 'SUBSIDIARYORGANIZATIONNO',           
  ISNULL(INVSD.SUBSIDIARYBANKACCOUNT,'') AS 'SUBSIDIARYBANKACCOUNT',                    
  ISNULL(INVSD.SUBSIDIARYIBAN,'') AS 'SUBSIDIARYIBAN',                               
  ISNULL(INVSD.SUBSIDIARYSWIFT,'') AS 'SUBSIDIARYSWIFT',                 
                     
  --Department Information                
  ISNULL(INVSD.DEPARTMENTNAME,'') AS 'DEPARTMENTNAME',                              
  ISNULL(INVSD.DEPARTMENTADDRESS1,'') AS 'DEPARTMENTADDRESS1',                
  ISNULL(INVSD.DEPARTMENTADDRESS2,'') AS 'DEPARTMENTADDRESS2',                      
  ISNULL(INVSD.DEPARTMENTCITY,'') AS 'DEPARTMENTCITY',                
  ISNULL(INVSD.DEPARTMENTZIPCODE,'') AS 'DEPARTMENTZIPCODE',              
  ISNULL(INVSD.DEPARTMENTSTATE,'') AS 'DEPARTMENTSTATE',                
  ISNULL(INVSD.DEPARTMENTCOUNTRY,'') AS 'DEPARTMENTCOUNTRY',      
  ISNULL(INVSD.DEPARTMENTPHONE,'') AS 'DEPARTMENTPHONE',                
  ISNULL(INVSD.DEPARTMENTMOBILE,'') AS 'DEPARTMENTMOBILE',                    
  ISNULL(INVSD.DEPARTMENTORGANIZATIONNO,'') AS 'DEPARTMENTORGANIZATIONNO',                
  ISNULL(INVSD.DEPARTMENTBANKACCOUNT,'') AS 'DEPARTMENTBANKACCOUNT',                 
  ISNULL(INVSD.DEPARTMENTIBAN,'')AS 'DEPARTMENTIBAN',                    
  ISNULL(INVSD.DEPARTMENTSWIFT,'') AS 'DEPARTMENTSWIFT',                                                           
                     
  --Header Information                
  CASE WHEN @TYPE='CreditNote' or @TYPE='VACreditNote'  THEN  
    ih.ID_CN_NO  
  ELSE  
    ih.ID_INV_NO  
  END AS 'INVOICENO',    
  ih.DUEDATE AS 'DUEDATE',  
  CASE WHEN @TYPE='CreditNote' or @TYPE='VACreditNote' THEN  
    ih.DT_CREDITNOTE  
  ELSE  
    ih.DT_INVOICE  
  END AS 'INVOICEDATE',              
  ih.INV_KID AS 'KIDNO',                
  wh.ID_WO_PREFIX AS 'WORKORDERPREFIX',                         
  wh.ID_WO_NO AS 'WORKORDERNO',                
  wh.DT_ORDER AS 'ORDERDATE',                                   
  ih.CREATED_BY AS 'USER',                
  ih.ID_DEBITOR AS 'CUSTOMERID',                            
  isnull((select top 1 WO_OWN_CR_CUST from TBL_WO_DETAIL WITH(NOLOCK) where ID_WO_PREFIX+ID_WO_NO+CONVERT(varchar(10),id_job) in   
    (select ID_WO_PREFIX+ID_WO_NO+CONVERT(varchar(10),id_job) from TBL_INV_DETAIL WITH(NOLOCK) where ID_INV_NO=ih.ID_INV_NO  
  and WO_OWN_CR_CUST is not null)),'')  
  AS 'VEHICLEOWNERID', --CREDIT CUSTOMER ON ORDER  
  wh.WO_ANNOT AS 'ANNOTATION',   
     --(SELECT T.CUST_NAME FROM TBL_MAS_CUSTOMER T WHERE T.ID_CUSTOMER = WD.WO_OWN_CR_CUST ) AS 'OWNERNAME',  
     id.OWNERNAME AS 'OWNERNAME',  
     0 AS 'ROUNDEDAMOUNT', -- ROW 616 CHANGE (NOT USED)                    
  INVA.CUSTOMERNAME AS 'CUSTOMERNAME',   
  INVA.CUSTOMERADDRESS1 AS 'CUSTOMERADDRESS1',   
  INVA.CUSTOMERADDRESS2 AS 'CUSTOMERADDRESS2',   
  INVA.CUSTOMERCITY AS 'CUSTOMERCITY',   
   INVA.CUSTOMERSTATE AS 'CUSTOMERSTATE',   
     INVA.CUSTOMERCOUNTRY AS 'CUSTOMERCOUNTRY',        
  INVA.CUSTOMERZIPCODE AS 'CUSTOMERZIPCODE',  
  INVA.DELIVERY_ADDRESS_NAME AS 'CUSTOMERDELIVERYADDRESSNAME',                
  INVA.DELIVERY_ADDRESS_LINE1 AS 'CUSTOMERDELIVERYADDRESS1',      
  INVA.DELIVERY_ADDRESS_LINE2 AS 'CUSTOMERDELIVERYADDRESS2',                
  INVA.DELIVERY_CITY AS 'CUSTOMERDELIVERYCITY',        
  INVA.DELIVERY_STATE AS 'CUSTOMERDELIVERYSTATE',                
  INVA.DELIVERY_COUNTRY AS 'CUSTOMERDELIVERYCOUNTRY',             
  INVA.DELIVERY_ZIPCODE AS 'CUSTOMERDELIVERYZIPCODE',                        
  INVA.CUSTOMERPHONE1 AS 'CUSTOMERPHONE1',   
  INVA.CUSTOMERPHONE2 AS 'CUSTOMERPHONE2',   
  INVA.CUSTOMERMOBILE AS 'CUSTOMERMOBILE',   
  INVVEH.VEH_REG_NO AS 'VEHICLEREGISTRATIONNO',                     
  INVVEH.VEH_INTERN_NO AS 'INTERNALNO',                
  INVVEH.VEH_VIN AS 'VIN',                                          
  INVVEH.DT_VEH_ERGN AS 'FIRSTREGISTRATIONDATE',                
  INVVEH.WO_VEH_MILEAGE AS 'VEHICLEMILEAGE',                        
  INVVEH.VEH_TYPE AS 'SHOWTYPE',   
  --CASE WHEN (select count(*) from TBL_INV_DETAIL indet where isnull(indet.OWNERPAYVATJOB,0)=1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN 1 else 0 end  
  isnull(id.OWNERPAYVATJOB,0) AS 'OWNERPAYVATJOB',  
  CASE WHEN (select count(*) from TBL_INV_DETAIL indet where isnull(indet.OWNERPAYVAT,0)=1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN 1 else 0 end  
  AS 'OWNERPAYVAT',   
  CASE WHEN (select count(*) from TBL_INV_DETAIL indet where isnull(indet.OWNPAYVAT1,0)=1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN 1 else 0 end  
  AS 'OWNPAYVAT1',  
  ih.TRANSFERREDVAT AS 'TRANSFERREDVAT',  
    
   wd.WO_VAT_PERCENTAGE AS 'VATPERCENTAGE',  
  
  ih.TRANSFERREDFROMCUSTID AS 'TRANSFERREDFROMCUSTID',  
  ih.TRANSFERREDFROMCUSTName AS 'TRANSFERREDFROMCUSTName',  
  INVVEH.WO_VEH_HRS AS 'VEHICLEHOURS',               
  --Spare Part / Labour Information                
  idl.ID_MAKE AS 'MAKEID',                                      
  idl.ID_WAREHOUSE AS 'WAREHOUSEID',                
  ISNULL(idl.ID_ITEM_INVL,'') AS 'SPAREPARTNO/LABOURID',     
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN wjd.[TEXT] ELSE idl.SPAREPARTNAME END AS 'SPAREPARTNAME/LABOUR',                
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN NULL ELSE (@isInvoice) * idl.INVL_DELIVER_QTY  END AS 'DELIVEREDQTY/TIME',                
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN NULL ELSE (@isInvoice) * idl.QTYNOTDELIVERED  END AS 'QTYNOTDELIVERED',                
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN NULL ELSE (@isInvoice) * idl.ORDEREDQTY END AS 'ORDEREDQTY',    
  mim.LOCATION AS 'LOCATION',                
     --CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN NULL ELSE  
       
     --CASE WHEN mc.costprice>0 AND wjd.SPARE_TYPE<>'EFD'and ISNULL(wjd.FLG_EDIT_SP,0) = 0 and ISNULL(wjd.FLG_EDIT_SP,0) = 0  
     --THEN  
     -- (ISNULL(wjd.JOBI_COST_PRICE,0)+ISNULL(Isnull(wjd.JOBI_COST_PRICE,0)*ISNULL((mc.costprice)/100,0),0))*(DBT_PER/100)  
     --ELSE  
     --(idl.INVL_PRICE)  
     --END  
     idl.PRICE AS 'PRICE',           
   -- CASE     
   -- WHEN (SELECT COUNT(*) FROM TBL_WO_JOB_DETAIL DEBT WHERE DEBT.ID_WO_NO = wh.ID_WO_NO AND DEBT.ID_WO_PREFIX = wh.ID_WO_PREFIX  AND DEBT.ID_WODET_SEQ_JOB = wd.ID_WODET_SEQ) > 1      
   -- THEN CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN NULL ELSE @isInvoice * WJD.JOBI_DIS_PER END   
   -- ELSE CASE WHEN ISNULL(wjd.ITEM_DESC,'') ='' And (wjd.[TEXT] IS NOT NULL AND wjd.[TEXT] <>'') THEN NULL ELSE @isInvoice * idl.INVL_DIS END  
   --END   
   @isInvoice * idl.INVL_DIS AS  'DISCOUNT',    
    (@isInvoice) * (idl.TOTALAMOUNT - idl.DISCOUNT)  AS 'TOTALAMOUNT',          
  --change end          
  CASE     
  WHEN (SELECT COUNT(*) FROM TBL_WO_DEBITOR_DETAIL DEBT WHERE DEBT.ID_WO_NO = wh.ID_WO_NO AND DEBT.ID_WO_PREFIX = wh.ID_WO_PREFIX  AND DEBT.ID_JOB_ID = wd.ID_JOB) > 1    
  THEN       
   (@isInvoice) * DEBDET.WO_VAT_PERCENTAGE    
  ELSE    
   (@isInvoice) * idl.INVL_VAT_PER     
  END AS 'VATPER',    
 0 AS 'GARAGEMATERIALAMT',                                            
                     
 --Job Information                
 id.ID_JOB AS 'JOBNUMBER',                                     
 NULL AS 'STDTIME',                
 workCodeDesc.DESCRIPTION AS 'WORKCODE',                       
 mrc.RP_REPCODE_DES AS 'REPAIRCODE',                
 wd.WO_JOB_TXT AS 'JOBTEXT',   
 CASE WHEN ISNULL(id.FLG_FIXED_PRICE,0)=1 THEN   
  CASE WHEN ISNULL((SELECT COUNT(*) FROM TBL_INV_DETAIL_LINES DETL WHERE DETL.ID_INV_NO=id.ID_INV_NO),0)>0 THEN  
   (@isInvoice) * (id.VAT_FIXED/(SELECT COUNT(*) FROM TBL_INV_DETAIL_LINES DETL WHERE DETL.ID_INV_NO=id.ID_INV_NO))  
  ELSE   
   (@isInvoice) * (id.VAT_FIXED)  
  END  
 ELSE   
  (@isInvoice) * idl.VATAMOUNT   
 END  
 AS 'VATAM0UNT',  
 ((@isInvoice) * id.INVD_FIXEDAMT) AS 'FIXEDAMOUNT',  
 (@isInvoice) * id.IN_DEB_JOB_AMT AS 'JOBAMOUNT',                
 case when id.FLG_FIXED_PRICE = 1 then 1 else 0 end AS 'FLAGFIXEDPRICE',  
 wd.FLG_CHRG_STD_TIME AS 'FLAGCHARGESTDTIME',                
 --Image Information                
 riHeader.IMAGE AS 'HEADERIMAGE',                              
 riFOOTER.IMAGE AS 'FOOTERIMAGE',                
                     
  --Rounding Information                
 CASE WHEN mic.INV_RND_DECIMAL=0 THEN 1 ELSE mic.INV_RND_DECIMAL END     AS 'ROUNDDECIMAL',                        
 mic.INV_PRICE_RND_FN AS 'ROUNDFUNCTION',                
 mic.INV_PRICE_RND_VAL_PER AS 'ROUNDPERCENTAGE',    
    (@isInvoice) * ISNULL(id.OWNRISKAMOUNT,0) AS 'OWNRISKAMOUNT',     
 (@isInvoice) * ISNULL(id.OWNRISKVAT,0) AS 'OWNRISKVAT',  
 FLG_BATCH_INV,  
 @TYPE AS INVTYPE,  
 dbo.fnGetHeaderINV(ih.ID_INV_NO,@TYPE) AS 'HEADERTITLE',      
 id.BARCODE  AS BARCODE,  
 '0' AS BARCODE_DISP, --Added barcode as it is used for job cards.         
 (SELECT rds.COMMERCIALTEXT FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID      
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'      
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT    
     AND REF LIKE 'chkCommercialText') as  'COMMERCIALTEXT',  
   ISNULL(wd.SALESMAN,null) AS 'SHOWSALESMAN', --SHOWSALESMAN,  
   wh.WO_TYPE_WOH AS 'ORDERTYPE',  
   (@isInvoice) * ISNULL(ih.INV_FEES_AMT,0) AS INV_FEES_AMT,  
   (@isInvoice) * isnull(ih.INV_FEES_VAT_AMT,0) as INV_FEES_VAT_AMT,  
   (@isInvoice) * INVDT.JOBSUM as JOBSUM, 
   --(@isInvoice) * (ih.INV_TOT - ih.VATAMOUNT - ih.INV_RD_AMT - ISNULL(ih.INV_FEES_AMT,0) )as INVOICESUM,   
      (@isInvoice) * (INVDT.INVOICESUM)as INVOICESUM, 
   (@isInvoice) * ih.TRANSFERREDVAT as  TRANSFERREDVATDATA ,     
   CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
    (@isInvoice) * ih.TRANSFERREDVAT  
   ELSE  
    (@isInvoice) * (ih.TRANSFERREDVAT/(ih.DEB_VAT_PER/100))   
   END as VATBASEDON, --616--VAT BASIS FOR THE TRANSFERRED VAT AMOUNT 
	(@isInvoice) * INVDT.CALCULATEDFROM as VATCALCULATEDFROM,  

	(@isInvoice) * INVDT.FINDVAT as TOFINDVAT, -- [total vat] 
   --CASE WHEN ISNULL(ih.TRANSFERREDVAT,0)=0 THEN   
   -- CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
   --  CASE WHEN ISNULL(ih.VATAMOUNT,0) <>0 THEN   
   --   (@isInvoice) * (ih.VATAMOUNT)*4 --WHEN ONE OR MORE LINES HAVE VAT ON A VAT FREE CUSTOMER THE VAT BASIS WILL BE FOUR TIMES THE VAT AMOUNT AS PER STD.  
   --  ELSE  
   --   0  
   --  END  
   -- ELSE  
   -- (@isInvoice) * (ih.VATAMOUNT/(ih.DEB_VAT_PER/100))  
   -- END   
   --ELSE  
   -- CASE WHEN ih.ID_DEBITOR=ih.TRANSFERREDFROMCUSTID THEN  
   --  CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
   --   CASE WHEN (ISNULL(ih.VATAMOUNT,0)+ABS(ih.TRANSFERREDVAT)) <>0 THEN   
   --   (@isInvoice) * (ih.VATAMOUNT+ABS(ih.TRANSFERREDVAT))*4 --WHEN ONE OR MORE LINES HAVE VAT ON A VAT FREE CUSTOMER THE VAT BASIS WILL BE FOUR TIMES THE VAT AMOUNT AS PER STD.  
   --   ELSE  
   --    0  
   --   END  
   --  ELSE  
   --   (@isInvoice) * (ih.VATAMOUNT+ABS(ih.TRANSFERREDVAT))/(ih.DEB_VAT_PER/100)  
   --  END  
   -- ELSE  
   --  CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
   --   CASE WHEN (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT)) <>0 THEN   
   --    (@isInvoice) * (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT))*4 --WHEN ONE OR MORE LINES HAVE VAT ON A VAT FREE CUSTOMER THE VAT BASIS WILL BE FOUR TIMES THE VAT AMOUNT AS PER STD.  
   --   ELSE  
   --    0  
   --   END  
   --  ELSE  
   --   (@isInvoice) * (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT))/(ih.DEB_VAT_PER/100)  
   --  END  
   -- END  
   --END
   --as VATCALCULATEDFROM ,  
     
   --CASE WHEN ISNULL(ih.TRANSFERREDVAT,0)=0 THEN   
   -- (@isInvoice) * ih.VATAMOUNT   
   --ELSE   
   -- CASE WHEN ih.ID_DEBITOR=ih.TRANSFERREDFROMCUSTID THEN  
   --  (@isInvoice) * (ih.VATAMOUNT+ABS(ih.TRANSFERREDVAT))    
   -- ELSE  
   --  (@isInvoice) * (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT))  
   -- END  
   --END as TOFINDVAT, -- [total vat]  
   CASE WHEN (select count(*) from TBL_INV_DETAIL indet where indet.OWNERPAYVAT = 1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN  
    CASE WHEN ih.ID_DEBITOR = isnull((SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB),'') THEN  
     ih.TRANSFERREDFROMCUSTID  
    else  
     (SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB)  
    END   
   ELSE   
    NULL   
   END as IDDATA,  
   CASE WHEN (select count(*) from TBL_INV_DETAIL indet where indet.OWNERPAYVAT = 1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN  
    CASE WHEN ih.ID_DEBITOR = isnull((SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB),'') THEN  
     ih.TRANSFERREDFROMCUSTName  
    ELSE  
     (SELECT TOP 1 INVD.OWNERNAME FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB)  
    END   
   ELSE   
    NULL   
   END as VATNAMEDATA,  
   (@isInvoice) * ih.INV_RD_AMT as ROUNDINGAMT,  
   (@isInvoice) * ih.INV_TOT as ROUNDEDTOTAL,      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
 ELSE      
   CASE WHEN DEBDET.CUST_TYPE = 'MISC' THEN      
    0      
   ELSE      
    -1 * (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
   END      
 END AS 'REDUCTION_AMOUNT'  
 FROM                 
  TBL_INV_HEADER ih WITH(NOLOCK)               
  LEFT OUTER JOIN TBL_INV_DETAIL id    WITH(NOLOCK)            
   ON id.ID_INV_NO = ih.ID_INV_NO              
  LEFT OUTER JOIN TBL_INV_DETAIL_LINES idl  WITH(NOLOCK)              
   ON id.ID_WODET_INV = idl.ID_WODET_INVL                 
    AND id.ID_INV_NO = idl.ID_INV_NO                
  LEFT OUTER JOIN TBL_WO_JOB_DETAIL wjd   WITH(NOLOCK)              
   ON wjd.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ                
  LEFT OUTER JOIN TBL_WO_DETAIL wd   WITH(NOLOCK)             
   ON wd.ID_WODET_SEQ = id.ID_WODET_INV    
    AND wd.id_job = id.id_job                
  LEFT OUTER JOIN TBL_WO_HEADER wh   WITH(NOLOCK)             
   ON id.ID_WO_NO = wh.ID_WO_NO                
    AND id.ID_WO_PREFIX = wh.ID_WO_PREFIX        
 --    
  LEFT OUTER join TBL_WO_DEBITOR_DETAIL DEBDET  WITH(NOLOCK)         
  ON DEBDET.ID_WO_NO= wd.ID_WO_NO AND           
   DEBDET.ID_WO_PREFIX= wd.ID_WO_PREFIX AND           
  ih.ID_DEBITOR=DEBDET.ID_JOB_DEB  
  and id.id_job=DEBDET.id_job_id  
 --  
 
  LEFT OUTER JOIN TBL_MAS_CUSTOMER mc    WITH(NOLOCK)            
   ON ih.ID_DEBITOR = mc.ID_CUSTOMER                
  LEFT OUTER JOIN TBL_MAS_VEHICLE mv  WITH(NOLOCK)              
   ON mv.ID_VEH_SEQ = wh.ID_VEH_SEQ_WO                
  LEFT OUTER JOIN TBL_MAS_ITEM_MASTER mim WITH(NOLOCK)                
   ON idl.ID_ITEM_INVL = mim.ID_ITEM                
    AND idl.ID_MAKE = mim.ID_MAKE                
    AND idl.ID_WAREHOUSE = mim.ID_WH_ITEM                
  LEFT OUTER JOIN TBL_MAS_SETTINGS workCodeDesc WITH(NOLOCK)               
   ON workCodeDesc.ID_SETTINGS = wd.ID_WORK_CODE_WO                
  LEFT OUTER JOIN TBL_MAS_REPAIRCODE mrc  WITH(NOLOCK)              
   ON wd.ID_REP_CODE_WO = mrc.ID_REP_CODE                
  LEFT OUTER JOIN TBL_MAS_CUST_GROUP mcg  WITH(NOLOCK)              
   ON ih.INV_CUST_GROUP = mcg.ID_CUST_GRP_SEQ                
  LEFT OUTER JOIN TBL_MAS_CUST_PAYTERMS mcp  WITH(NOLOCK)              
   ON mcp.ID_PT_SEQ = mcg.ID_PAY_TERM                      
  LEFT OUTER JOIN TBL_MAS_SUBSIDERY ms   WITH(NOLOCK)          
   ON ms.ID_SUBSIDERY=ih.ID_SUBSIDERY_INV                
  LEFT OUTER JOIN TBL_MAS_DEPT md  WITH(NOLOCK)              
   ON md.ID_DEPT = ih.ID_DEPT_INV                
  LEFT OUTER JOIN TBL_REP_IMAGES riHeader  WITH(NOLOCK)              
   ON riHeader.SUBSIDIARY = ih.ID_SUBSIDERY_INV                
    AND riHeader.DEPARTMENT = ih.ID_DEPT_INV                
    AND riHeader.REPORTID = 'INVOICEPRINT'                
    AND riHeader.DISPLAYAREA = 'LOGO'                
    AND riHeader.REPORTTYPE = @TYPE                
  LEFT OUTER JOIN TBL_REP_IMAGES riFooter WITH(NOLOCK)               
   ON riFooter.SUBSIDIARY = ih.ID_SUBSIDERY_INV                
    AND riFooter.DEPARTMENT = ih.ID_DEPT_INV                
    AND riFooter.REPORTID = 'INVOICEPRINT'                
    AND riFooter.DISPLAYAREA = 'FOOTER'                
    AND riFooter.REPORTTYPE = @TYPE                
  LEFT OUTER JOIN TBL_MAS_INV_CONFIGURATION mic  WITH(NOLOCK)              
   ON mic.ID_SUBSIDERY_INV = ih.ID_SUBSIDERY_INV                
    AND mic.ID_DEPT_INV = ih.ID_DEPT_INV                
    AND mic.DT_EFF_TO IS NULL  
  ------------------------------  
  LEFT OUTER JOIN TBL_INV_ADDRESS_HEADER INVA WITH(NOLOCK)  
   ON INVA.ID_INV_NO = ih.ID_INV_NO  
  LEFT OUTER JOIN TBL_INV_DETAIL_VEH INVVEH WITH(NOLOCK)  
   ON INVVEH.ID_INV_NO = ih.ID_INV_NO AND INVVEH.ID_WO_NO = wh.ID_WO_NO AND INVVEH.ID_WO_PREFIX = wh.ID_WO_PREFIX  
  LEFT OUTER JOIN TBL_INV_ADDRESS_SUB_DEP INVSD WITH(NOLOCK)  
   ON INVSD.ID_INV_NO = ih.ID_INV_NO    
  ------------------------------          
    INNER JOIN TBL_INVOICE_DATA INVDT 
	ON INVDT.ID_INV_NO = IH.ID_INV_NO AND idl.ID_WOITEM_SEQ = INVDT.ID_WOITEM_SEQ           
  WHERE                
   ((ih.ID_INV_NO IN                
      (SELECT A.ID_INV_NO FROM @TEMPTAB A )) AND @isInvoice = 1)            
   OR  ((ih.ID_CN_NO IN                
      (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = -1)                   
                     
 UNION ALL                
                     
  SELECT     
  'Labour' AS [Type],                
                 
  --Subsidiary Information                
  ISNULL(INVSD.SUBSIDIARYNAME,'') AS 'SUBSIDIARYNAME',                         
  ISNULL(INVSD.SUBSIDIARYADDRESS1,'') AS 'SUBSIDIARYADDRESS1',                
  ISNULL(INVSD.SUBSIDIARYADDRESS2,'') AS 'SUBSIDIARYADDRESS2',                       
  ISNULL(INVSD.SUBSIDIARYCITY,'') AS 'SUBSIDIARYCITY',                
  ISNULL(INVSD.SUBSIDIARYZIPCODE,'') AS 'SUBSIDIARYZIPCODE',              
  ISNULL(INVSD.SUBSIDIARYSTATE,'') AS 'SUBSIDIARYSTATE',                
  ISNULL(INVSD.SUBSIDIARYCOUNTRY,'') AS 'SUBSIDIARYCOUNTRY',      
  ISNULL(INVSD.SUBSIDIARYPHONE1,'') AS 'SUBSIDIARYPHONE1',                
  ISNULL(INVSD.SUBSIDIARYPHONE2,'') AS 'SUBSIDIARYPHONE2',                           
  ISNULL(INVSD.SUBSIDIARYMOBILE,'') AS 'SUBSIDIARYMOBILE',                
  ISNULL(INVSD.SUBSIDIARYFAX,'') AS 'SUBSIDIARYFAX',                                 
  ISNULL(INVSD.SUBSIDIARYEMAIL,'') AS 'SUBSIDIARYEMAIL',                
  ISNULL(INVSD.SUBSIDIARYORGANIZATIONNO,'') AS 'SUBSIDIARYORGANIZATIONNO',           
  ISNULL(INVSD.SUBSIDIARYBANKACCOUNT,'') AS 'SUBSIDIARYBANKACCOUNT',                    
  ISNULL(INVSD.SUBSIDIARYIBAN,'') AS 'SUBSIDIARYIBAN',                               
  ISNULL(INVSD.SUBSIDIARYSWIFT,'') AS 'SUBSIDIARYSWIFT',                 
                     
  --Department Information                
  ISNULL(INVSD.DEPARTMENTNAME,'') AS 'DEPARTMENTNAME',                              
  ISNULL(INVSD.DEPARTMENTADDRESS1,'') AS 'DEPARTMENTADDRESS1',                
  ISNULL(INVSD.DEPARTMENTADDRESS2,'') AS 'DEPARTMENTADDRESS2',                      
  ISNULL(INVSD.DEPARTMENTCITY,'') AS 'DEPARTMENTCITY',                
  ISNULL(INVSD.DEPARTMENTZIPCODE,'') AS 'DEPARTMENTZIPCODE',              
  ISNULL(INVSD.DEPARTMENTSTATE,'') AS 'DEPARTMENTSTATE',                
  ISNULL(INVSD.DEPARTMENTCOUNTRY,'') AS 'DEPARTMENTCOUNTRY',      
  ISNULL(INVSD.DEPARTMENTPHONE,'') AS 'DEPARTMENTPHONE',                
  ISNULL(INVSD.DEPARTMENTMOBILE,'') AS 'DEPARTMENTMOBILE',                    
  ISNULL(INVSD.DEPARTMENTORGANIZATIONNO,'') AS 'DEPARTMENTORGANIZATIONNO',                
  ISNULL(INVSD.DEPARTMENTBANKACCOUNT,'') AS 'DEPARTMENTBANKACCOUNT',                 
  ISNULL(INVSD.DEPARTMENTIBAN,'')AS 'DEPARTMENTIBAN',          
  ISNULL(INVSD.DEPARTMENTSWIFT,'') AS 'DEPARTMENTSWIFT',    
                     
  --Header   Information                
  CASE WHEN @TYPE='CreditNote' or @TYPE='VACreditNote' THEN  
    ih.ID_CN_NO  
  ELSE  
    ih.ID_INV_NO  
  END AS 'INVOICENO',                                       
  CAST(CAST(dbo.FnGetDueDate(ih.DT_INVOICE, ih.ID_DEBITOR) AS VARCHAR(20)) AS DATETIME) AS 'DUEDATE', --ih.DT_INVOICE   +   (SELECT TERMS FROM TBL_MAS_CUST_PAYTERMS WHERE ID_PT_SEQ=mc.ID_CUST_PAY_TERM) AS 'DUEDATE',                
  --ih.DT_INVOICE AS 'INVOICEDATE',   
  CASE WHEN @TYPE='CreditNote' or @TYPE='VACreditNote' THEN  
    ih.DT_CREDITNOTE  
  ELSE  
    ih.DT_INVOICE  
  END AS 'INVOICEDATE',   
  ih.INV_KID AS 'KIDNO',                
  wh.ID_WO_PREFIX AS 'WORKORDERPREFIX',                               
  wh.ID_WO_NO AS 'WORKORDERNO',                
  wh.DT_ORDER AS 'ORDERDATE',                                         
  ih.CREATED_BY AS 'USER',                
  ih.ID_DEBITOR AS 'CUSTOMERID',                                      
  isnull((select top 1 WO_OWN_CR_CUST from TBL_WO_DETAIL WITH(NOLOCK) where ID_WO_PREFIX+ID_WO_NO+CONVERT(varchar(10),id_job) in   
    (select ID_WO_PREFIX+ID_WO_NO+CONVERT(varchar(10),id_job) from TBL_INV_DETAIL WITH(NOLOCK) where ID_INV_NO=ih.ID_INV_NO  
  and WO_OWN_CR_CUST is not null)),'')  
  AS 'VEHICLEOWNERID', --CREDIT CUSTOMER ON ORDER  
  wh.WO_ANNOT AS 'ANNOTATION',   
     --(SELECT T.CUST_NAME FROM TBL_MAS_CUSTOMER T WHERE T.ID_CUSTOMER = WD.WO_OWN_CR_CUST ) AS 'OWNERNAME',  
     id.OWNERNAME AS 'OWNERNAME',  
  0 AS 'ROUNDEDAMOUNT', -- ROW 616 CHANGE (NOT USED)                    
  INVA.CUSTOMERNAME AS 'CUSTOMERNAME',   
  INVA.CUSTOMERADDRESS1 AS 'CUSTOMERADDRESS1',   
  INVA.CUSTOMERADDRESS2 AS 'CUSTOMERADDRESS2',   
  INVA.CUSTOMERCITY AS 'CUSTOMERCITY',   
   INVA.CUSTOMERSTATE AS 'CUSTOMERSTATE',   
     INVA.CUSTOMERCOUNTRY AS 'CUSTOMERCOUNTRY',        
  INVA.CUSTOMERZIPCODE AS 'CUSTOMERZIPCODE',  
  INVA.DELIVERY_ADDRESS_NAME AS 'CUSTOMERDELIVERYADDRESSNAME',                
  INVA.DELIVERY_ADDRESS_LINE1 AS 'CUSTOMERDELIVERYADDRESS1',      
  INVA.DELIVERY_ADDRESS_LINE2 AS 'CUSTOMERDELIVERYADDRESS2',                
  INVA.DELIVERY_CITY AS 'CUSTOMERDELIVERYCITY',        
  INVA.DELIVERY_STATE AS 'CUSTOMERDELIVERYSTATE',                
  INVA.DELIVERY_COUNTRY AS 'CUSTOMERDELIVERYCOUNTRY',             
  INVA.DELIVERY_ZIPCODE AS 'CUSTOMERDELIVERYZIPCODE',                        
  INVA.CUSTOMERPHONE1 AS 'CUSTOMERPHONE1',   
  INVA.CUSTOMERPHONE2 AS 'CUSTOMERPHONE2',   
  INVA.CUSTOMERMOBILE AS 'CUSTOMERMOBILE',   
  INVVEH.VEH_REG_NO AS 'VEHICLEREGISTRATIONNO',                     
  INVVEH.VEH_INTERN_NO AS 'INTERNALNO',                
  INVVEH.VEH_VIN AS 'VIN',                                          
  INVVEH.DT_VEH_ERGN AS 'FIRSTREGISTRATIONDATE',                
  INVVEH.WO_VEH_MILEAGE AS 'VEHICLEMILEAGE',                        
  INVVEH.VEH_TYPE AS 'SHOWTYPE',   
  --CASE WHEN (select count(*) from TBL_INV_DETAIL indet where isnull(indet.OWNERPAYVATJOB,0)=1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN 1 else 0 end  
  isnull(id.OWNERPAYVATJOB,0) AS 'OWNERPAYVATJOB',  
  CASE WHEN (select count(*) from TBL_INV_DETAIL indet where isnull(indet.OWNERPAYVAT,0)=1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN 1 else 0 end  
  AS 'OWNERPAYVAT',   
  CASE WHEN (select count(*) from TBL_INV_DETAIL indet where isnull(indet.OWNPAYVAT1,0)=1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN 1 else 0 end  
  AS 'OWNPAYVAT1',  
  ih.TRANSFERREDVAT AS 'TRANSFERREDVAT',  
  
   --wd.WO_TOT_VAT_AMT AS 'TRANSFERREDVAT',  
    wd.WO_VAT_PERCENTAGE AS 'VATPERCENTAGE',  
      
  ih.TRANSFERREDFROMCUSTID AS 'TRANSFERREDFROMCUSTID',  
  ih.TRANSFERREDFROMCUSTName AS 'TRANSFERREDFROMCUSTName',  
  INVVEH.WO_VEH_HRS AS 'VEHICLEHOURS',               
                 
  --Spare   Part   /   Labour   Information                
  NULL AS 'MAKEID',                
  NULL AS 'WAREHOUSEID',                
  '' AS 'SPAREPARTNO/LABOURID',                
  idll.INVL_DESCRIPTION   'SPAREPARTNAME/LABOUR',                
  (@isInvoice) * (INVDT.DEL_QTY) AS 'DELIVEREDQTY/TIME',        
  NULL AS 'QTYNOTDELIVERED',                
  NULL AS 'ORDEREDQTY',                                               
  NULL AS LOCATION,                
  INVDT.PRICE AS 'PRICE',                                        
  @isInvoice  * INVDT.DISC_PERCENT AS 'DISCOUNT',   
  CASE WHEN IDLL.TOTALAMOUNT IS NOT NULL THEN   
   (@isInvoice) * (IDLL.TOTALAMOUNT - IDLL.DISCOUNT)   
  ELSE  
   (@isInvoice) * (id.TOTALAMOUNT - id.LABOUR_DISCOUNT)   
  END  
  AS 'TOTALAMOUNT',           
  CASE     
  WHEN idll.INVL_VAT_PER is not null     
  THEN idll.INVL_VAT_PER     
  ELSE CASE WHEN (SELECT COUNT(*) FROM TBL_WO_DEBITOR_DETAIL DEBT WHERE     
   DEBT.ID_WO_NO = wh.ID_WO_NO AND DEBT.ID_WO_PREFIX = wh.ID_WO_PREFIX  AND DEBT.ID_JOB_ID = wd.ID_JOB) > 1    
   THEN DEBDET.WO_LBR_VATPER    
    ELSE WD.WO_LBR_VATPER    
    END    
  END AS 'VATPER',              
 (@isInvoice) * INVDG.LINE_AMOUNT AS 'GARAGEMATERIALAMT',                
  --Job   Information                      
 id.ID_JOB AS 'JOBNUMBER',            
 wd.WO_STD_TIME AS 'STDTIME',                      
 workCodeDesc.DESCRIPTION  AS 'WORKCODE',                             
 mrc.RP_REPCODE_DES AS 'REPAIRCODE',                
 wd.WO_JOB_TXT AS 'JOBTEXT',                                                      
 --Condition added for Fixed Price on 29-Jan-2009  
 --CASE WHEN idll.VATAMOUNT IS NOT NULL THEN   
 -- isnull((@isInvoice) * idll.VATAMOUNT + id.VAT_GM,0)   
 --ELSE  
 -- isnull((@isInvoice) * (ID.VAT_LABOUR + id.VAT_GM),0)   
 --END  
 isnull((@isInvoice) * ISNULL(INVDT.LINE_VAT_AMOUNT,0) + ISNULL(INVDG.LINE_VAT_AMOUNT,0),0)
 AS 'VATAM0UNT',   
 ((@isInvoice) * id.INVD_FIXEDAMT ) AS 'FIXEDAMOUNT',  
    (@isInvoice) * id.IN_DEB_JOB_AMT AS 'JOBAMOUNT',                
 case when id.FLG_FIXED_PRICE = 1 then 1 else 0 end  AS 'FLAGFIXEDPRICE',                              
 wd.FLG_CHRG_STD_TIME AS 'FLAGCHARGESTDTIME',                
                     
 --Image Information                
 riHeader.IMAGE AS 'HEADERIMAGE',                              
 riFOOTER.IMAGE AS 'FOOTERIMAGE',                
                             
 --Rounding Information                
 CASE WHEN mic.INV_RND_DECIMAL=0 THEN 1 ELSE mic.INV_RND_DECIMAL END     AS 'ROUNDDECIMAL',                        
 mic.INV_PRICE_RND_FN AS 'ROUNDFUNCTION',                
 mic.INV_PRICE_RND_VAL_PER AS 'ROUNDPERCENTAGE',    
    (@isInvoice) * ISNULL(id.OWNRISKAMOUNT,0) AS 'OWNRISKAMOUNT',     
 (@isInvoice) * ISNULL(id.OWNRISKVAT,0) AS 'OWNRISKVAT',  
 FLG_BATCH_INV,  
 @TYPE AS INVTYPE,  
 dbo.fnGetHeaderINV(ih.ID_INV_NO,@TYPE) AS 'HEADERTITLE',      
 id.BARCODE  AS BARCODE,  
 '0' AS BARCODE_DISP, --Added barcode as it is used for job cards.         
 (SELECT rds.COMMERCIALTEXT FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID      
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'      
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT    
     AND REF LIKE 'chkCommercialText') as  'COMMERCIALTEXT',  
   ISNULL(wd.SALESMAN,null) AS 'SHOWSALESMAN',  
   wh.WO_TYPE_WOH AS 'ORDERTYPE',  
   (@isInvoice) * ISNULL(ih.INV_FEES_AMT,0)  AS INV_FEES_AMT,  
   (@isInvoice) * isnull(ih.INV_FEES_VAT_AMT,0) as INV_FEES_VAT_AMT,  
   (@isInvoice) * INVDT.JOBSUM as JOBSUM,  
   -- (@isInvoice) * (ih.INV_TOT - ih.VATAMOUNT - ih.INV_RD_AMT - ISNULL(ih.INV_FEES_AMT,0))as INVOICESUM,  
   (@isInvoice) * (INVDT.INVOICESUM)as INVOICESUM,  
   
   (@isInvoice) * ih.TRANSFERREDVAT as  TRANSFERREDVATDATA ,     
   CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
    (@isInvoice) * ih.TRANSFERREDVAT  
   ELSE  
    (@isInvoice) * (ih.TRANSFERREDVAT/(ih.DEB_VAT_PER/100))   
   END as VATBASEDON,  
   	(@isInvoice) * INVDT.CALCULATEDFROM as VATCALCULATEDFROM,  

	(@isInvoice) * INVDT.FINDVAT as TOFINDVAT, -- [total vat] 
   --CASE WHEN ISNULL(ih.TRANSFERREDVAT,0)=0 THEN   
   -- CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
   --  CASE WHEN ISNULL(ih.VATAMOUNT,0) <>0 THEN   
   --   (@isInvoice) * (ih.VATAMOUNT)*4 --WHEN ONE OR MORE LINES HAVE VAT ON A VAT FREE CUSTOMER THE VAT BASIS WILL BE FOUR TIMES THE VAT AMOUNT AS PER STD.  
   --  ELSE  
   --   0  
   --  END  
   -- ELSE  
   --  (@isInvoice) * (ih.VATAMOUNT/(ih.DEB_VAT_PER/100))  
   -- END   
   --ELSE  
   -- CASE WHEN ih.ID_DEBITOR=ih.TRANSFERREDFROMCUSTID THEN  
   --  CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
   --   CASE WHEN (ISNULL(ih.VATAMOUNT,0)+ABS(ih.TRANSFERREDVAT))  <>0 THEN   
   --    (@isInvoice) * (ih.VATAMOUNT+ABS(ih.TRANSFERREDVAT))*4 --WHEN ONE OR MORE LINES HAVE VAT ON A VAT FREE CUSTOMER THE VAT BASIS WILL BE FOUR TIMES THE VAT AMOUNT AS PER STD.  
   --   ELSE  
   --    0  
   --   END  
   --  ELSE  
   --   (@isInvoice) * (ih.VATAMOUNT+ABS(ih.TRANSFERREDVAT))/(ih.DEB_VAT_PER/100)  
   --  END  
   -- ELSE  
   --  CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
   --   CASE WHEN (ISNULL(ih.VATAMOUNT,0)-ABS(ih.TRANSFERREDVAT)) <>0 THEN   
   --    (@isInvoice) * (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT))*4 --WHEN ONE OR MORE LINES HAVE VAT ON A VAT FREE CUSTOMER THE VAT BASIS WILL BE FOUR TIMES THE VAT AMOUNT AS PER STD.  
   --   ELSE  
   --    0  
   --   END  
   --  ELSE  
   --   (@isInvoice) * (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT))/(ih.DEB_VAT_PER/100)  
   --  END  
   -- END  
   --END as VATCALCULATEDFROM ,  
   --CASE WHEN ISNULL(ih.TRANSFERREDVAT,0)=0 THEN   
   -- (@isInvoice) * ih.VATAMOUNT   
   --ELSE   
   -- CASE WHEN ih.ID_DEBITOR=ih.TRANSFERREDFROMCUSTID THEN  
   --  (@isInvoice) * (ih.VATAMOUNT+ABS(ih.TRANSFERREDVAT))    
   -- ELSE  
   --  (@isInvoice) * (ih.VATAMOUNT-ABS(ih.TRANSFERREDVAT))  
   -- END  
   --END as TOFINDVAT, -- [total vat]  
   CASE WHEN (select count(*) from TBL_INV_DETAIL indet where indet.OWNERPAYVAT = 1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN  
    CASE WHEN ih.ID_DEBITOR = isnull((SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB),'') THEN  
     ih.TRANSFERREDFROMCUSTID  
    else  
     (SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB)  
    END   
   ELSE   
    NULL   
   END as IDDATA,  
   CASE WHEN (select count(*) from TBL_INV_DETAIL indet where indet.OWNERPAYVAT = 1 and indet.ID_INV_NO=ih.ID_INV_NO) > = 1 THEN  
    CASE WHEN ih.ID_DEBITOR = isnull((SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB),'') THEN  
     ih.TRANSFERREDFROMCUSTName  
    ELSE  
     (SELECT TOP 1 INVD.OWNERNAME FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO AND INVD.ID_WO_NO = ID.ID_WO_NO AND INVD.ID_WO_PREFIX = ID.ID_WO_PREFIX AND INVD.ID_JOB = ID.ID_JOB)  
    END   
   ELSE   
    NULL   
   END as VATNAMEDATA,  
   (@isInvoice) * ih.INV_RD_AMT as ROUNDINGAMT,  
   (@isInvoice) * ih.INV_TOT as ROUNDEDTOTAL,      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
 ELSE      
   CASE WHEN DEBDET.CUST_TYPE = 'MISC' THEN      
    0      
   ELSE      
    -1 * (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
   END      
 END AS 'REDUCTION_AMOUNT'   
 FROM                   
  TBL_INV_HEADER ih WITH(NOLOCK)               
  LEFT OUTER JOIN TBL_INV_DETAIL id  WITH(NOLOCK)              
   ON id.ID_INV_NO = ih.ID_INV_NO                
  LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idll  WITH(NOLOCK)              
   ON id.ID_WODET_INV = idll.ID_WODET_INVL                 
    AND id.ID_INV_NO = idll.ID_INV_NO                    
    LEFT OUTER JOIN TBL_WO_HEADER   wh   WITH(NOLOCK)                   
    ON id.ID_WO_NO = wh.ID_WO_NO                      
    AND id.ID_WO_PREFIX = wh.ID_WO_PREFIX                
    LEFT OUTER JOIN TBL_WO_DETAIL wd   WITH(NOLOCK)             
    ON wd.ID_WODET_SEQ = id.ID_WODET_INV           
 --          
  left outer join TBL_WO_DEBITOR_DETAIL DEBDET WITH(NOLOCK)          
  ON DEBDET.ID_WO_NO= wd.ID_WO_NO AND           
   DEBDET.ID_WO_PREFIX= wd.ID_WO_PREFIX AND           
  ih.ID_DEBITOR=DEBDET.ID_JOB_DEB  
  and id.id_job=DEBDET.id_job_id           
 --          
    
  
  ---               
    LEFT OUTER JOIN TBL_MAS_SETTINGS workCodeDesc   WITH(NOLOCK)             
   ON workCodeDesc.ID_SETTINGS = wd.ID_WORK_CODE_WO     
  LEFT OUTER JOIN TBL_MAS_REPAIRCODE mrc    WITH(NOLOCK)            
   ON wd.ID_REP_CODE_WO = mrc.ID_REP_CODE                    
    LEFT OUTER JOIN TBL_MAS_CUSTOMER   mc     WITH(NOLOCK)                 
    ON ih.ID_DEBITOR = mc.ID_CUSTOMER                      
    LEFT OUTER JOIN TBL_MAS_VEHICLE   mv   WITH(NOLOCK)                   
    ON mv.ID_VEH_SEQ = wh.ID_VEH_SEQ_WO                
    LEFT OUTER JOIN TBL_MAS_CUST_GROUP   mcg   WITH(NOLOCK)                   
    ON ih.INV_CUST_GROUP = mcg.ID_CUST_GRP_SEQ                      
    LEFT OUTER JOIN TBL_MAS_CUST_PAYTERMS   mcp   WITH(NOLOCK)                   
    ON mcp.ID_PT_SEQ = mcg.ID_PAY_TERM                               
    LEFT OUTER JOIN TBL_MAS_SUBSIDERY   ms    WITH(NOLOCK)                  
    ON ms.ID_SUBSIDERY=ih.ID_SUBSIDERY_INV                      
    LEFT OUTER JOIN TBL_MAS_DEPT   md  WITH(NOLOCK)                    
    ON md.ID_DEPT = ih.ID_DEPT_INV                      
    LEFT OUTER JOIN TBL_REP_IMAGES riHeader  WITH(NOLOCK)              
   ON riHeader.SUBSIDIARY = ih.ID_SUBSIDERY_INV                
    AND riHeader.DEPARTMENT = ih.ID_DEPT_INV                
    AND riHeader.REPORTID = 'INVOICEPRINT'                
    AND riHeader.DISPLAYAREA = 'LOGO'                
    AND riHeader.REPORTTYPE = @TYPE                
  LEFT OUTER JOIN TBL_REP_IMAGES riFooter  WITH(NOLOCK)              
   ON riFooter.SUBSIDIARY = ih.ID_SUBSIDERY_INV                
    AND riFooter.DEPARTMENT = ih.ID_DEPT_INV                
    AND riFooter.REPORTID = 'INVOICEPRINT'                
    AND riFooter.DISPLAYAREA = 'FOOTER'                
    AND riFooter.REPORTTYPE = @TYPE                  
  LEFT OUTER JOIN TBL_MAS_INV_CONFIGURATION mic  WITH(NOLOCK)              
   ON mic.ID_SUBSIDERY_INV = ih.ID_SUBSIDERY_INV                
    AND mic.ID_DEPT_INV = ih.ID_DEPT_INV                
    AND mic.DT_EFF_TO IS NULL                    
       
     ------------------------------  
  LEFT OUTER JOIN TBL_INV_ADDRESS_HEADER INVA WITH(NOLOCK)  
   ON INVA.ID_INV_NO = ih.ID_INV_NO  
  LEFT OUTER JOIN TBL_INV_DETAIL_VEH INVVEH WITH(NOLOCK)  
   ON INVVEH.ID_INV_NO = ih.ID_INV_NO AND INVVEH.ID_WO_NO = wh.ID_WO_NO AND INVVEH.ID_WO_PREFIX = wh.ID_WO_PREFIX  
  LEFT OUTER JOIN TBL_INV_ADDRESS_SUB_DEP INVSD WITH(NOLOCK)  
   ON INVSD.ID_INV_NO = ih.ID_INV_NO    
  ------------------------------  
    INNER JOIN TBL_INVOICE_DATA INVDT 
   ON INVDT.ID_INV_NO = idll.ID_INV_NO AND idll.ID_WOLAB_SEQ = INVDT.ID_WOLAB_SEQ    
      AND INVDT.LINE_TYPE = 'LABOUR'
  INNER JOIN TBL_INVOICE_DATA INVDG 
   ON INVDG.ID_INV_NO = idll.ID_INV_NO AND idll.ID_WOLAB_SEQ = INVDG.ID_WOLAB_SEQ    
      AND INVDG.LINE_TYPE = 'GM'
  WHERE                  
   ((ih.ID_INV_NO IN                
      (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = 1)            
  OR  ((ih.ID_CN_NO IN                
      (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = -1)   
      --) as #Temp2  
     
     
        
 INSERT INTO TBL_INV_CREATE_TRACK values (@INV_NOSXML,'End Process1- Report parameters',getdate(),23,@NEW_GUID)     
  
  
END  
ELSE  
BEGIN  
 INSERT INTO TBL_INV_CREATE_TRACK values (@INV_NOSXML,'Start Process2-- Report parameters fetched here',getdate(),24,@NEW_GUID)  
  
 SELECT                 
  'Spares' as [Type],                
                     
  --Subsidiary Information                
  ISNULL(INVSD.SUBSIDIARYNAME,'') AS 'SUBSIDIARYNAME',                         
  ISNULL(INVSD.SUBSIDIARYADDRESS1,'') AS 'SUBSIDIARYADDRESS1',                
  ISNULL(INVSD.SUBSIDIARYADDRESS2,'') AS 'SUBSIDIARYADDRESS2',                       
  ISNULL(INVSD.SUBSIDIARYCITY,'') AS 'SUBSIDIARYCITY',                
  ISNULL(INVSD.SUBSIDIARYZIPCODE,'') AS 'SUBSIDIARYZIPCODE',              
  ISNULL(INVSD.SUBSIDIARYSTATE,'') AS 'SUBSIDIARYSTATE',                
  ISNULL(INVSD.SUBSIDIARYCOUNTRY,'') AS 'SUBSIDIARYCOUNTRY',      
  ISNULL(INVSD.SUBSIDIARYPHONE1,'') AS 'SUBSIDIARYPHONE1',                
  ISNULL(INVSD.SUBSIDIARYPHONE2,'') AS 'SUBSIDIARYPHONE2',                           
  ISNULL(INVSD.SUBSIDIARYMOBILE,'') AS 'SUBSIDIARYMOBILE',                
  ISNULL(INVSD.SUBSIDIARYFAX,'') AS 'SUBSIDIARYFAX',                                 
  ISNULL(INVSD.SUBSIDIARYEMAIL,'') AS 'SUBSIDIARYEMAIL',                
  ISNULL(INVSD.SUBSIDIARYORGANIZATIONNO,'') AS 'SUBSIDIARYORGANIZATIONNO',           
  ISNULL(INVSD.SUBSIDIARYBANKACCOUNT,'') AS 'SUBSIDIARYBANKACCOUNT',                    
  ISNULL(INVSD.SUBSIDIARYIBAN,'') AS 'SUBSIDIARYIBAN',                               
  ISNULL(INVSD.SUBSIDIARYSWIFT,'') AS 'SUBSIDIARYSWIFT',                 
                     
  --Department Information                
  ISNULL(INVSD.DEPARTMENTNAME,'') AS 'DEPARTMENTNAME',                              
  ISNULL(INVSD.DEPARTMENTADDRESS1,'') AS 'DEPARTMENTADDRESS1',                
  ISNULL(INVSD.DEPARTMENTADDRESS2,'') AS 'DEPARTMENTADDRESS2',                      
  ISNULL(INVSD.DEPARTMENTCITY,'') AS 'DEPARTMENTCITY',                
  ISNULL(INVSD.DEPARTMENTZIPCODE,'') AS 'DEPARTMENTZIPCODE',              
  ISNULL(INVSD.DEPARTMENTSTATE,'') AS 'DEPARTMENTSTATE',                
  ISNULL(INVSD.DEPARTMENTCOUNTRY,'') AS 'DEPARTMENTCOUNTRY',      
  ISNULL(INVSD.DEPARTMENTPHONE,'') AS 'DEPARTMENTPHONE',                
  ISNULL(INVSD.DEPARTMENTMOBILE,'') AS 'DEPARTMENTMOBILE',                    
  ISNULL(INVSD.DEPARTMENTORGANIZATIONNO,'') AS 'DEPARTMENTORGANIZATIONNO',                
  ISNULL(INVSD.DEPARTMENTBANKACCOUNT,'') AS 'DEPARTMENTBANKACCOUNT',                 
  ISNULL(INVSD.DEPARTMENTIBAN,'')AS 'DEPARTMENTIBAN',                    
  ISNULL(INVSD.DEPARTMENTSWIFT,'') AS 'DEPARTMENTSWIFT',                                                           
                     
  --Header Information                
  CASE WHEN @TYPE='CreditNote' or @TYPE='VACreditNote' THEN  
    ih.ID_CN_NO  
  ELSE  
    ih.ID_INV_NO  
  END AS 'INVOICENO',                                  
  ih.DUEDATE AS 'DUEDATE',  
  CASE WHEN @TYPE='CreditNote' or @TYPE='VACreditNote' THEN  
    ih.DT_CREDITNOTE  
  ELSE  
    ih.DT_INVOICE  
  END AS 'INVOICEDATE',   
  ih.INV_KID AS 'KIDNO',                
  wh.ID_WO_PREFIX AS 'WORKORDERPREFIX',                         
  wh.ID_WO_NO AS 'WORKORDERNO',                
  wh.DT_ORDER AS 'ORDERDATE',                                   
  ih.CREATED_BY AS 'USER',                
  ih.ID_DEBITOR AS 'CUSTOMERID',                            
  isnull((select top 1 WO_OWN_CR_CUST from TBL_WO_DETAIL WITH(NOLOCK) where ID_WO_PREFIX+ID_WO_NO+CONVERT(varchar(10),id_job) in   
    (select ID_WO_PREFIX+ID_WO_NO+CONVERT(varchar(10),id_job) from TBL_INV_DETAIL WITH(NOLOCK) where ID_INV_NO=ih.ID_INV_NO  
  and WO_OWN_CR_CUST is not null)),'')  
  AS 'VEHICLEOWNERID',  --CREDIT CUSTOMER ON ORDER                
  wh.WO_ANNOT AS 'ANNOTATION',   
     --(SELECT T.CUST_NAME FROM TBL_MAS_CUSTOMER T WHERE T.ID_CUSTOMER = WD.WO_OWN_CR_CUST ) AS 'OWNERNAME',  
     id.OWNERNAME AS 'OWNERNAME',  
  0 AS 'ROUNDEDAMOUNT', -- ROW 616 CHANGE (NOT USED)                    
  --Customer Information                
  INVA.CUSTOMERNAME AS 'CUSTOMERNAME',   
  INVA.CUSTOMERADDRESS1 AS 'CUSTOMERADDRESS1',   
  INVA.CUSTOMERADDRESS2 AS 'CUSTOMERADDRESS2',   
  INVA.CUSTOMERCITY AS 'CUSTOMERCITY',   
   INVA.CUSTOMERSTATE AS 'CUSTOMERSTATE',   
     INVA.CUSTOMERCOUNTRY AS 'CUSTOMERCOUNTRY',        
  INVA.CUSTOMERZIPCODE AS 'CUSTOMERZIPCODE',  
  INVA.DELIVERY_ADDRESS_NAME AS 'CUSTOMERDELIVERYADDRESSNAME',                
  INVA.DELIVERY_ADDRESS_LINE1 AS 'CUSTOMERDELIVERYADDRESS1',      
  INVA.DELIVERY_ADDRESS_LINE2 AS 'CUSTOMERDELIVERYADDRESS2',                
  INVA.DELIVERY_CITY AS 'CUSTOMERDELIVERYCITY',        
  INVA.DELIVERY_STATE AS 'CUSTOMERDELIVERYSTATE',                
  INVA.DELIVERY_COUNTRY AS 'CUSTOMERDELIVERYCOUNTRY',             
  INVA.DELIVERY_ZIPCODE AS 'CUSTOMERDELIVERYZIPCODE',                        
  INVA.CUSTOMERPHONE1 AS 'CUSTOMERPHONE1',   
  INVA.CUSTOMERPHONE2 AS 'CUSTOMERPHONE2',   
  INVA.CUSTOMERMOBILE AS 'CUSTOMERMOBILE',   
  --ROW 761  
  CASE WHEN INVVEH.VEH_REG_NO IS NULL AND wh.WO_VEH_REG_NO IS NOT NULL THEN wh.WO_VEH_REG_NO ELSE INVVEH.VEH_REG_NO END  AS 'VEHICLEREGISTRATIONNO',     
                    
  INVVEH.VEH_INTERN_NO AS 'INTERNALNO',                
  INVVEH.VEH_VIN AS 'VIN',                                          
  INVVEH.DT_VEH_ERGN AS 'FIRSTREGISTRATIONDATE',                
  INVVEH.WO_VEH_MILEAGE AS 'VEHICLEMILEAGE',                        
  INVVEH.VEH_TYPE AS 'SHOWTYPE',   
  isnull(id.OWNERPAYVATJOB,0) AS 'OWNERPAYVATJOB',  
  isnull(id.OWNERPAYVAT,0) AS 'OWNERPAYVAT',   
  isnull(id.OWNPAYVAT1,0) AS 'OWNPAYVAT1',  
  isnull(ih.TRANSFERREDVAT,0) AS 'TRANSFERREDVAT',  
    wd.WO_VAT_PERCENTAGE AS 'VATPERCENTAGE',  
  ih.TRANSFERREDFROMCUSTID AS 'TRANSFERREDFROMCUSTID',  
  ih.TRANSFERREDFROMCUSTName AS 'TRANSFERREDFROMCUSTName',  
  INVVEH.WO_VEH_HRS AS 'VEHICLEHOURS',               
  --Spare Part / Labour Information                
  idl.ID_MAKE AS 'MAKEID',                                      
  idl.ID_WAREHOUSE AS 'WAREHOUSEID',                
  ISNULL(idl.ID_ITEM_INVL,'') AS 'SPAREPARTNO/LABOURID',     
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN wjd.[TEXT] ELSE idl.SPAREPARTNAME END AS 'SPAREPARTNAME/LABOUR',                
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN NULL ELSE (@isInvoice) * idl.INVL_DELIVER_QTY  END AS 'DELIVEREDQTY/TIME',                
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN NULL ELSE (@isInvoice) * idl.QTYNOTDELIVERED  END AS 'QTYNOTDELIVERED',                
  CASE WHEN ISNULL(idl.LINE_TYPE,'') ='TEXT' THEN NULL ELSE (@isInvoice) * idl.ORDEREDQTY END AS 'ORDEREDQTY',    
  
  mim.LOCATION,                
  --Bug ID:-Split Per Issue          
  --idl.INVL_PRICE AS 'PRICE',     
    
  (idl.INVL_PRICE) AS 'PRICE',           
  --change end          
  --idl.INVL_DIS AS 'DISCOUNT',                
  @isInvoice * idl.INVL_DIS AS  'DISCOUNT',    
  (@isInvoice) * (idl.TOTALAMOUNT - idl.DISCOUNT)  AS 'TOTALAMOUNT',          
  --change end          
  CASE WHEN (SELECT COUNT(*) FROM TBL_WO_DEBITOR_DETAIL DEBT WHERE DEBT.ID_WO_NO = wh.ID_WO_NO AND DEBT.ID_WO_PREFIX = wh.ID_WO_PREFIX  AND DEBT.ID_JOB_ID = wd.ID_JOB) > 1    
  THEN       
   (@isInvoice) * DEBDET.WO_VAT_PERCENTAGE    
  ELSE    
   (@isInvoice) * idl.INVL_VAT_PER     
  END AS 'VATPER',    
  0 AS 'GARAGEMATERIALAMT',                                            
                     
  --Job Information                
  id.ID_JOB AS 'JOBNUMBER',                                     
  NULL AS 'STDTIME',                
  workCodeDesc.DESCRIPTION AS 'WORKCODE',                       
  mrc.RP_REPCODE_DES AS 'REPAIRCODE',                
  wd.WO_JOB_TXT AS 'JOBTEXT',   
  (@isInvoice) * idl.VATAMOUNT AS 'VATAM0UNT',      
  -- (@isInvoice) * (DEBDET.WO_VAT_PERCENTAGE * TOTALAMOUNT) AS 'VATAM0UNT',    
     
  (@isInvoice) * id.INVD_FIXEDAMT AS 'FIXEDAMOUNT',  
  (@isInvoice) * id.IN_DEB_JOB_AMT AS 'JOBAMOUNT',   
  case when id.FLG_FIXED_PRICE = 1 then 1 else 0 end AS 'FLAGFIXEDPRICE',                       
  wd.FLG_CHRG_STD_TIME AS 'FLAGCHARGESTDTIME',                
                     
  --Image Information                
  riHeader.IMAGE AS 'HEADERIMAGE',                              
  riFOOTER.IMAGE AS 'FOOTERIMAGE',                
                     
  --Rounding Information                
  CASE WHEN mic.INV_RND_DECIMAL=0 THEN 1 ELSE mic.INV_RND_DECIMAL END     AS 'ROUNDDECIMAL',                        
  mic.INV_PRICE_RND_FN AS 'ROUNDFUNCTION',                
  mic.INV_PRICE_RND_VAL_PER AS 'ROUNDPERCENTAGE',    
  (@isInvoice) * ISNULL(id.OWNRISKAMOUNT,0) AS 'OWNRISKAMOUNT',     
  (@isInvoice) * ISNULL(id.OWNRISKVAT,0) AS 'OWNRISKVAT',  
  FLG_BATCH_INV,  
  @TYPE AS INVTYPE,  
  --dbo.fnGetHeader(id.ID_WO_NO, id.ID_WO_PREFIX,@TYPE)    
  dbo.fnGetHeaderINV(ih.ID_INV_NO,@TYPE) AS 'HEADERTITLE' ,      
  id.BARCODE  AS BARCODE,  
  '0' AS BARCODE_DISP,  
  (SELECT rds.COMMERCIALTEXT FROM TBL_REP_OBJECTS ro JOIN TBL_REP_REPORTS rr ON rr.REPORTID = ro.REPORTID      
     LEFT OUTER JOIN TBL_REP_DISPLAYSETTINGS rds ON ro.OBJECTID=rds.OBJECTID WHERE rr.REPORTID = 'INVOICEPRINT'      
     AND rds.REPORTTYPE = @TYPE AND rds.SUBSIDIARY = ms.ID_Subsidery AND rds.DEPARTMENT = md.ID_DEPT    
     AND REF LIKE 'chkCommercialText') as  'COMMERCIALTEXT',  
  ISNULL(wd.SALESMAN,null) AS 'SHOWSALESMAN',--SHOWSALESMAN       
  wh.WO_TYPE_WOH AS 'ORDERTYPE',  
  --CASE WHEN ( wh.ID_PAY_TERMS_WO IN( SELECT ID_PT_SEQ FROM TBL_MAS_CUST_PAYTERMS where TERMS=0 )  or ISNULL(mc.FLG_CUST_IGNOREINV,0) = 1) then 0 else (@isInvoice) * ISNULL(ih.INV_FEES_AMT,0)   
  --End   
  (@isInvoice) * ISNULL(ih.INV_FEES_AMT,0) AS INV_FEES_AMT,  
  (@isInvoice) * isnull(ih.INV_FEES_VAT_AMT,0) as INV_FEES_VAT_AMT,  
 (@isInvoice) * INVDT.JOBSUM  as JOBSUM,  
 -- (@isInvoice) * (ih.INV_TOT - ih.VATAMOUNT - isnull(ih.INV_RD_AMT,0) - ISNULL(ih.INV_FEES_AMT,0))as INVOICESUM,   
    (@isInvoice) * (INVDT.INVOICESUM)as INVOICESUM, 
  ih.TRANSFERREDVAT as  TRANSFERREDVATDATA ,  
  CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
    (@isInvoice) * ih.TRANSFERREDVAT  
   ELSE  
    (@isInvoice) * (ih.TRANSFERREDVAT/(ih.DEB_VAT_PER/100))   
   END as VATBASEDON,  
  -- CASE WHEN isnull(ih.DEB_VAT_PER,0) = 0 THEN  
  --  (@isInvoice) * ih.VATAMOUNT  
  -- ELSE  
  --  (@isInvoice) * (ih.VATAMOUNT/(ih.DEB_VAT_PER/100))  
  -- END as VATCALCULATEDFROM,  
  --(@isInvoice) * ih.VATAMOUNT as TOFINDVAT, -- [total vat]  
  	(@isInvoice) * INVDT.CALCULATEDFROM as VATCALCULATEDFROM,  

	(@isInvoice) * INVDT.FINDVAT as TOFINDVAT, -- [total vat] 
  CASE WHEN id.OWNERPAYVAT = 1 THEN  
   CASE WHEN ih.ID_DEBITOR = isnull((SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO),'') THEN  
    ih.TRANSFERREDFROMCUSTID  
   else  
    (SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO)  
   END   
  ELSE   
   NULL   
  END as IDDATA,  
  CASE WHEN id.OWNERPAYVAT = 1 THEN  
   CASE WHEN ih.ID_DEBITOR = isnull((SELECT TOP 1 INVD.VEHICLEOWNERID FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO),'') THEN  
    ih.TRANSFERREDFROMCUSTName  
   ELSE  
    (SELECT TOP 1 INVD.OWNERNAME FROM TBL_INV_DETAIL INVD WHERE INVD.ID_INV_NO = ih.ID_INV_NO)  
   END   
  ELSE   
   NULL   
  END as VATNAMEDATA,  
  (@isInvoice) * ih.INV_RD_AMT as ROUNDINGAMT,  
  (@isInvoice) * ih.INV_TOT as ROUNDEDTOTAL,      
 CASE WHEN DEBDET.CUST_TYPE = 'OHC' THEN      
  (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
 ELSE      
   CASE WHEN DEBDET.CUST_TYPE = 'MISC' THEN      
    0      
   ELSE      
    -1 * (ISNULL(DEBDET.REDUCTION_AMOUNT,0))      
   END      
 END AS 'REDUCTION_AMOUNT'   
 FROM                 
  TBL_INV_HEADER ih  WITH(NOLOCK)           
  LEFT OUTER JOIN TBL_INV_DETAIL id WITH(NOLOCK)               
   ON id.ID_INV_NO = ih.ID_INV_NO              
  LEFT OUTER JOIN TBL_INV_DETAIL_LINES_LABOUR idll WITH(NOLOCK)                   
   ON id.ID_WODET_INV = idll.ID_WODET_INVL                     
    AND id.ID_INV_NO = idll.ID_INV_NO               
  LEFT OUTER JOIN TBL_INV_DETAIL_LINES idl WITH(NOLOCK)               
   ON id.ID_WODET_INV = idl.ID_WODET_INVL                 
    AND id.ID_INV_NO = idl.ID_INV_NO                
  LEFT OUTER JOIN TBL_WO_JOB_DETAIL wjd  WITH(NOLOCK)               
   ON wjd.ID_WOITEM_SEQ = idl.ID_WOITEM_SEQ                
  LEFT OUTER JOIN TBL_WO_DETAIL wd  WITH(NOLOCK)              
   ON wd.ID_WODET_SEQ = id.ID_WODET_INV    
    AND wd.id_job = id.id_job                
  LEFT OUTER JOIN TBL_WO_HEADER wh  WITH(NOLOCK)              
   ON id.ID_WO_NO = wh.ID_WO_NO                
    AND id.ID_WO_PREFIX = wh.ID_WO_PREFIX        
 --    
  LEFT OUTER join TBL_WO_DEBITOR_DETAIL DEBDET  WITH(NOLOCK)         
  ON DEBDET.ID_WO_NO= wd.ID_WO_NO AND           
   DEBDET.ID_WO_PREFIX= wd.ID_WO_PREFIX AND           
  ih.ID_DEBITOR=DEBDET.ID_JOB_DEB  
  and id.id_job=DEBDET.id_job_id  
 --    

         
      
  --           
  LEFT OUTER JOIN TBL_MAS_CUSTOMER mc WITH(NOLOCK)               
   ON ih.ID_DEBITOR = mc.ID_CUSTOMER                
  LEFT OUTER JOIN TBL_MAS_VEHICLE mv  WITH(NOLOCK)              
   ON mv.ID_VEH_SEQ = wh.ID_VEH_SEQ_WO                
  LEFT OUTER JOIN TBL_MAS_ITEM_MASTER mim  WITH(NOLOCK)               
   ON idl.ID_ITEM_INVL = mim.ID_ITEM                
    AND idl.ID_MAKE = mim.ID_MAKE                
    AND idl.ID_WAREHOUSE = mim.ID_WH_ITEM                
  LEFT OUTER JOIN TBL_MAS_SETTINGS workCodeDesc  WITH(NOLOCK)              
   ON workCodeDesc.ID_SETTINGS = wd.ID_WORK_CODE_WO                
  LEFT OUTER JOIN TBL_MAS_REPAIRCODE mrc  WITH(NOLOCK)              
   ON wd.ID_REP_CODE_WO = mrc.ID_REP_CODE                
  LEFT OUTER JOIN TBL_MAS_CUST_GROUP mcg  WITH(NOLOCK)              
   ON ih.INV_CUST_GROUP = mcg.ID_CUST_GRP_SEQ                
  LEFT OUTER JOIN TBL_MAS_CUST_PAYTERMS mcp  WITH(NOLOCK)              
   ON mcp.ID_PT_SEQ = mcg.ID_PAY_TERM                      
  LEFT OUTER JOIN TBL_MAS_SUBSIDERY ms    WITH(NOLOCK)         
   ON ms.ID_SUBSIDERY=ih.ID_SUBSIDERY_INV                
  LEFT OUTER JOIN TBL_MAS_DEPT md  WITH(NOLOCK)              
   ON md.ID_DEPT = ih.ID_DEPT_INV                
  LEFT OUTER JOIN TBL_REP_IMAGES riHeader WITH(NOLOCK)               
   ON riHeader.SUBSIDIARY = ih.ID_SUBSIDERY_INV                
    AND riHeader.DEPARTMENT = ih.ID_DEPT_INV                
    AND riHeader.REPORTID = 'INVOICEPRINT'                
    AND riHeader.DISPLAYAREA = 'LOGO'                
    AND riHeader.REPORTTYPE = @TYPE                
  LEFT OUTER JOIN TBL_REP_IMAGES riFooter WITH(NOLOCK)               
   ON riFooter.SUBSIDIARY = ih.ID_SUBSIDERY_INV                
    AND riFooter.DEPARTMENT = ih.ID_DEPT_INV                
    AND riFooter.REPORTID = 'INVOICEPRINT'                
    AND riFooter.DISPLAYAREA = 'FOOTER'                
    AND riFooter.REPORTTYPE = @TYPE                
  LEFT OUTER JOIN TBL_MAS_INV_CONFIGURATION mic  WITH(NOLOCK)              
   ON mic.ID_SUBSIDERY_INV = ih.ID_SUBSIDERY_INV                
    AND mic.ID_DEPT_INV = ih.ID_DEPT_INV                
    AND mic.DT_EFF_TO IS NULL                
    
  ------------------------------  
  LEFT OUTER JOIN TBL_INV_ADDRESS_HEADER INVA WITH(NOLOCK)  
   ON INVA.ID_INV_NO = ih.ID_INV_NO  
  LEFT OUTER JOIN TBL_INV_DETAIL_VEH INVVEH WITH(NOLOCK)  
   ON INVVEH.ID_INV_NO = ih.ID_INV_NO AND INVVEH.ID_WO_NO = wh.ID_WO_NO AND INVVEH.ID_WO_PREFIX = wh.ID_WO_PREFIX    
  LEFT OUTER JOIN TBL_INV_ADDRESS_SUB_DEP INVSD WITH(NOLOCK)  
   ON INVSD.ID_INV_NO = ih.ID_INV_NO    
  ------------------------------    
     INNER JOIN TBL_INVOICE_DATA INVDT 
	ON INVDT.ID_INV_NO = IH.ID_INV_NO AND idl.ID_WOITEM_SEQ = INVDT.ID_WOITEM_SEQ   
  WHERE                
   ((ih.ID_INV_NO IN                
      (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = 1)            
   OR  ((ih.ID_CN_NO IN                
      (SELECT A.ID_INV_NO FROM @TEMPTAB A)) AND @isInvoice = -1)       
INSERT INTO TBL_INV_CREATE_TRACK values (@INV_NOSXML,'End Process2- Report parameters',getdate(),24,@NEW_GUID)     
END         
INSERT INTO TBL_INV_CREATE_TRACK values (@INV_NOSXML,'End CreateREP',getdate(),22,@NEW_GUID)  
  
END  

GO

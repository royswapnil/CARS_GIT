/****** Object:  StoredProcedure [dbo].[USP_REP_WO_DELIVERYNOTE]    Script Date: 9/13/2017 12:14:31 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_WO_DELIVERYNOTE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_REP_WO_DELIVERYNOTE]
GO
/****** Object:  StoredProcedure [dbo].[USP_REP_WO_DELIVERYNOTE]    Script Date: 9/13/2017 12:14:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_WO_DELIVERYNOTE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_REP_WO_DELIVERYNOTE] AS' 
END
GO
    
    
    
    
    
    
-- ===================================================================================================          
-- Author:  Vishalakshi          
-- Create date: 30-Sep-2008      
-- Description: This procedure is used to fetch Spare Part Details     
-- ===================================================================================================          
      
ALTER PROCEDURE [dbo].[USP_REP_WO_DELIVERYNOTE]           
 @ID_WO_NO VARCHAR(10) =269,      
 @ID_WO_PREFIX VARCHAR(3)='pre',    
 @IV_XMLDOC   NTEXT = '<root><insert ID_ITEM_JOB="Clutch Plate" ID_MAKE_JOB="HO" ID_WAREHOUSE="9"     
        ID_ITEM_CATG_JOB="" JOBI_ORDER_QTY="2" JOBI_DELIVER_QTY="0"/></root>',    
 @IV_Lang VARCHAR(30)='NORWEGIAN'    
     
AS          
BEGIN        
    
 --Bug Id:-226 warranty list 1.13v    
 --Date  :-24-Feb-2009    
 DECLARE @DOCHANDLE   INT                                       
 DECLARE @CONFIGLISTCNI AS VARCHAR(2000)                                      
 DECLARE @CFGLSTINSERTED AS VARCHAR(2000)                                      
 EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @IV_XMLDOC      
    
 -- ********************************    
 -- Modified Date : 20 May 2009    
 -- Bug ID      : ABS Report Issues    
    
 DECLARE @LANG INT      
 SELECT @LANG=ID_LANG FROM TBL_MAS_LANGUAGE WHERE LANG_NAME=@iv_Lang    
    
 DECLARE @Y AS VARCHAR(50)    
 SELECT @Y=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_YES' AND ISDATA=1    
    
 DECLARE @N AS VARCHAR(50)    
 SELECT @N=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_NO' AND ISDATA=1      
 -- *********** End Of Modification ******    
     
 -- COMMERCIAL TEXT CHANGES    
    DECLARE @COMMERCIALTEXT Varchar(500),@OBJECTID INT,@ID_DEPT INT,@ID_Subsidery INT,@WO_TYPE VARCHAR(10)    
      
 SET @COMMERCIALTEXT = NULL       
     
 SELECT @ID_DEPT= ID_Dept,@ID_Subsidery= ID_Subsidery,@WO_TYPE= WO_TYPE_WOH     
 FROM TBL_WO_HEADER WHERE ID_WO_NO =@ID_WO_NO AND ID_WO_PREFIX = @ID_WO_PREFIX    
     
    
 SELECT @OBJECTID = OBJECTID FROM TBL_REP_OBJECTS R WHERE R.REF = 'chkCommercialText' AND REPORTID = 'DELIVERYNOTE'    
 SELECT @COMMERCIALTEXT = COMMERCIALTEXT     
 FROM TBL_REP_DISPLAYSETTINGS     
 WHERE REPORTTYPE LIKE '%'+ @WO_TYPE + '%' AND DEPARTMENT = @Id_Dept AND OBJECTID = @OBJECTID    
 AND DISPLAY = 1 -- iF DISP = 0 -- DONOT DISPLAY THE COMM TEXT    
     
    
 DECLARE @INSERT_LIST TABLE                                      
 (                                      
  ID_WAREHOUSE    INT,                                    
  ID_MAKE_JOB    VARCHAR(10),                                    
  ID_ITEM_CATG_JOB   VARCHAR(10),                
  JOBI_ORDER_QTY   DECIMAL(13,2),                                    
  ID_ITEM_JOB    VARCHAR(30),       
  ITEM_DESC VARCHAR(100),                                 
  JOBI_DELIVER_QTY   DECIMAL(13,2),    
  JOB_SPARES_ACCOUNTCODE VARCHAR(20),                           
  JOB_VAT     VARCHAR(10),    
  ID_WO_NO VARCHAR(20),    
  ID_WO_PREFIX VARCHAR(20),    
  JOBI_BO_QTY DECIMAL(13,2),    
  JOBI_SELL_PRICE DECIMAL(13,2),    
  JOBI_DIS_PER INT,    
  DELIVERYNOTE_PREV_PRINTED BIT     
    
 )    
    
    
 INSERT INTO @INSERT_LIST     
  SELECT                       
   ID_WAREHOUSE,                      
   ID_MAKE_JOB,                                      
   ID_ITEM_CATG_JOB,                                    
   JOBI_ORDER_QTY ,                                    
   ID_ITEM_JOB ,       
    ITEM_DESC,                                  
   JOBI_DELIVER_QTY,    
   NULL,    
   NULL,    
   @ID_WO_NO,    
   @ID_WO_PREFIX,    
   JOBI_BO_QTY,    
   JOBI_SELL_PRICE,    
   JOBI_DIS_PER,    
   DELIVERYNOTE_PREV_PRINTED    
       
  FROM OPENXML (@docHandle,'root/insert',1) with                                       
  (                        
   ID_WAREHOUSE   INT,                                      
   ID_MAKE_JOB   VARCHAR(10),                                    
   ID_ITEM_CATG_JOB  VARCHAR(10),                   
   JOBI_ORDER_QTY  DECIMAL(13,2),                                    
   ID_ITEM_JOB   VARCHAR(30),     
    ITEM_DESC VARCHAR(100),                                      
   JOBI_DELIVER_QTY  DECIMAL(13,2),    
   JOB_VAT  VARCHAR(20) ,                    
   JOB_SPARES_ACCOUNTCODE VARCHAR(20),    
   ID_WO_NO VARCHAR(20),    
   ID_WO_PREFIX VARCHAR(20),    
   JOBI_BO_QTY DECIMAL(13,2),    
   JOBI_SELL_PRICE DECIMAL(13,2),    
   JOBI_DIS_PER DECIMAL(5,2),    
   DELIVERYNOTE_PREV_PRINTED BIT    
  )    
    
 EXEC SP_XML_REMOVEDOCUMENT @docHandle      
    
    
    
 UPDATE @INSERT_LIST                                    
 SET ID_ITEM_CATG_JOB = CATG.ID_ITEM_CATG ,                     
 JOB_SPARES_ACCOUNTCODE = CATG.ACCOUNTCODE,    
 JOB_VAT = VATCODE,    
 JOBI_DELIVER_QTY = JOBI_DELIVER_QTY + 0    
 FROM                       
 TBL_MAS_ITEM_MASTER MAS,                            
 @INSERT_LIST TEMP,TBL_MAS_ITEM_CATG CATG                                   
 WHERE                       
 MAS.ID_ITEM=TEMP.ID_ITEM_JOB                       
 --AND MAS.ID_MAKE=TEMP.ID_MAKE_JOB  
 AND isnull(MAS.SUPP_CURRENTNO,'')=isnull(TEMP.ID_MAKE_JOB,'')  
 AND MAS.ID_WH_ITEM= TEMP.ID_WAREHOUSE                      
 AND CATG.ID_ITEM_CATG=MAS.ID_ITEM_CATG     
     
      
-- Modified Date : 30th March 2010    
-- Bug ID   : previous printed status corrected    
--UPDATE @INSERT_LIST    
--SET DELIVERYNOTE_PREV_PRINTED=JD.DELIVERYNOTE_PREV_PRINTED    
--FROM TBL_WO_JOB_DETAIL JD INNER JOIN @INSERT_LIST     
-- ON JD.ID_WO_NO=@ID_WO_NO AND JD.ID_WO_PREFIX=@ID_WO_PREFIX AND JD.DELIVERYNOTE_PREV_PRINTED=1    
-- AND JD.ID_MAKE_JOB =[@INSERT_LIST].ID_MAKE_JOB AND JD.ID_ITEM_CATG_JOB =[@INSERT_LIST].ID_ITEM_CATG_JOB     
--    AND JD.ID_ITEM_JOB=[@INSERT_LIST].ID_ITEM_JOB AND  [@INSERT_LIST].ID_ITEM_JOB=JD.ID_ITEM_JOB      
-- AND [@INSERT_LIST].ID_MAKE_JOB=JD.ID_MAKE_JOB  AND JD.ID_WAREHOUSE=[@INSERT_LIST].ID_WAREHOUSE    
-- AND [@INSERT_LIST].ID_WO_SEQ = JD.ID_WOITEM_SEQ    
    
    
-- End Of Modification    
    
 SELECT     
      
  wh.ORIGINAL_ID_WO_PREFIX+wh.ORIGINAL_ID_WO_NO AS 'ORIGINALWORKORDERNO',    
  wh.DT_ORDER AS 'ORDERDATE',    
  ms.DESCRIPTION AS 'PAYMENTTYPE',    
  MAS.ID_ITEM AS 'SPAREPARTNO',    
  -- ***********************************    
  -- Modified Date : 6th February 2009    
  -- Bug Id   : Warrenty List -SS3 - 225    
  JD.ITEM_DESC AS 'SPAREPARTNAME',    
  --CATG.CATG_DESC AS 'SPAREPARTNAME',    
  -- ******* End OF Modification **********    
  JD.JOBI_ORDER_QTY AS 'ORDEREDQTY',    
  JD.JOBI_DELIVER_QTY AS 'DELIVEREDQTY',    
  JD.JOBI_BO_QTY AS 'BACKORDERQTY',    
  JD./*JOBI_DELIVER_QTY * */ JOBI_SELL_PRICE AS 'PRICEEXVAT',    
  JD.JOBI_DIS_PER AS 'DISCOUNT%',    
  sdc.DISCOUNTCODE AS 'DISCOUNTCODE',    
  MAS.LOCATION AS 'LOCATION',    
  CASE(JD.DELIVERYNOTE_PREV_PRINTED)     
   WHEN 1 THEN @Y     
   ELSE @N     
            END AS 'PREVIOUSPRINTED',    
  wh.WO_ANNOT AS 'ANNOTATION',    
  ISNULL(wh.MODIFIED_BY,wh.CREATED_BY) AS 'DISPATCHBY',    
  @COMMERCIALTEXT AS COMMERCIALTEXT    
      
 FROM     
  --Bug Id:-226 warranty list 1.13v    
  --Date  :-24-Feb-2009    
   --TBL_WO_JOB_DETAIL JD     
   @INSERT_LIST JD     
  --CHANGE END    
  LEFT JOIN TBL_MAS_MAKE MAKE ON MAKE.ID_MAKE = JD.ID_MAKE_JOB      
  LEFT JOIN TBL_MAS_ITEM_MASTER MAS ON MAS.ID_ITEM = JD.ID_ITEM_JOB    
   --Bug ID:-Ignore WareHouse    
   --date  :-06-Feb-2009     
   AND MAS.ID_WH_ITEM = JD.ID_WAREHOUSE    
   --chagne end    
   -- Modified Date : 10th March 2010    
  -- Bug ID   : Make has to Check    
  --AND MAS.ID_MAKE = JD.ID_MAKE_JOB     
  AND MAS.SUPP_CURRENTNO = JD.ID_MAKE_JOB     
  -- End Of Modification *************    
  LEFT JOIN TBL_MAS_ITEM_CATG CATG ON CATG.ID_ITEM_CATG = JD.ID_ITEM_CATG_JOB          
  JOIN TBL_WO_HEADER wh ON JD.ID_WO_NO = wh.ID_WO_NO AND JD.ID_WO_PREFIX = wh.ID_WO_PREFIX    
  LEFT OUTER JOIN  TBL_WO_HEADER Owh ON wh.ORIGINAL_ID_WO_NO = Owh.ID_WO_NO AND wh.ORIGINAL_ID_WO_PREFIX = Owh.ID_WO_PREFIX    
  JOIN TBL_MAS_ITEM_MASTER mim ON mim.ID_ITEM = jd.ID_ITEM_JOB   
  --AND mim.ID_MAKE = JD.ID_MAKE_JOB   
  AND isnull(mim.SUPP_CURRENTNO,'') = isnull(JD.ID_MAKE_JOB,'')   
  AND mim.ID_WH_ITEM = JD.ID_WAREHOUSE    
  LEFT JOIN TBL_SPR_DISCOUNTCODE sdc ON mim.ITEM_DISC_CODE = sdc.ID_DISCOUNTCODE    
  LEFT JOIN TBL_MAS_SETTINGS ms ON wh.ID_PAY_TYPE_WO = ms.ID_SETTINGS AND ms.ID_CONFIG = 'PAYTYPE'    
 WHERE JD.ID_WO_NO=@ID_WO_NO AND JD.ID_WO_PREFIX=@ID_WO_PREFIX    
    
END         
    
    
       
    
    
    
    
    
    
    
GO

/****** Object:  StoredProcedure [dbo].[USP_LA_CODELIST]    Script Date: 8/29/2017 5:00:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_LA_CODELIST]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_LA_CODELIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_LA_CODELIST]    Script Date: 8/29/2017 5:00:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_LA_CODELIST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_LA_CODELIST] AS' 
END
GO
    
    
    
    
/*************************************** APPLICATION: MSG *************************************************************                
* MODULE : Link to Accounting                
* FILE NAME : USP_LA_CODELIST.PRC                
* PURPOSE : To bind value in parent grid and child of LACodelist              
* AUTHOR : L.MAHENDRAN            
* DATE  : 21.11.2007                
*********************************************************************************************************************/                
/*********************************************************************************************************************                  
I/P : -- INPUT PARAMETERS                
O/P : -- OUTPUT PARAMETERS                
ERROR CODE                
DESCRIPTION                
INT.VerNO :               
********************************************************************************************************************/                
--'*********************************************************************************'*********************************                
--'* MODIFIED HISTORY :                   
--'* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION                 
--*#0001#                 
--'*********************************************************************************'*********************************                  
      --       
--SET @MAINQRY = 'select id_slno as ''ID_MATRIX'',        
--LA_DEPT_ACCCODE as ''Dept_AcCode'',        
--LA_CUST_ACCCODE as ''CustGrp_AcCode'',        
--LA_Flg_DutyFree as ''Free'',        
--LA_SaleDescription as ''SaleCode_Type'',       
--ISNULL(LA_SaleAccCode,'''') as ''AccCode'',      
--LA_Description as ''Description''        
--        
-- from TBL_LA_ACCOUNT_MATRIX        
--        
--WHERE         
--  LA_DEPT_ACCCODE LIKE ''%'+ ISNULL(@IV_LA_DEPTCODE,'') +'%'' AND LA_CUST_ACCCODE LIKE ''%' + ISNULL(@IV_LA_CUSGRPCODE,'') + '%''     
-- AND ID_DEPT IN (SELECT ID FROM OPENXML ('+CAST(@HDOC AS VARCHAR(10))+',''ROOT/D'',0)                  
--       WITH (                  
--        ID INT                  
--        )                  
--       )'        
--EXEC (@MAINQRY)        
    
--END OF MODIFICATION    
    
--print @mainqry        
--DECLARE @SUBQRY AS VARCHAR(2000)        
--SET @SUBQRY = '        
--select AMD.ID_SLNO,AMD.LA_SLNO,AMD.LA_DESCRIPTION,        
--case when AMD.LA_DESCRIPTION = ''SEGL'' then        
--( select ''Selling GL'')        
--  when AMD.LA_DESCRIPTION = ''DGL'' then        
--( select ''Discount GL'')        
--  when AMD.LA_DESCRIPTION = ''STGL'' then        
--( select ''Stock GL'')        
--  when AMD.LA_DESCRIPTION = ''CGL'' then        
--( select ''Cost GL'')        
--end as ''Acc_Type'',        
--''1'' as ''GenLedger'',        
--AMD.LA_FLG_CRE_DEB as ''GL_CrDb'',        
--AMD.LA_ACCOUNTNO as ''GL_AccNo'',        
--AMD.LA_DEPT_ACCOUNT_NO as ''GL_DeptAccNo'',        
--AMD.LA_DIMENSION as ''GL_Dimension''        
--        
--from TBL_LA_ACCOUNT_MATRIX_detail AMD        
--where LA_SLNO in (select ID_SLNO from TBL_LA_ACCOUNT_MATRIX        
--WHERE         
--  LA_DEPT_ACCCODE LIKE ''%'+ ISNULL(@IV_LA_DEPTCODE,'') +'%'' AND LA_CUST_ACCCODE LIKE ''%' + ISNULL(@IV_LA_CUSGRPCODE,'') + '%'') '        
--        
--        
--EXEC (@SUBQRY)        
        
--Fetching Child data        
--MODIFIED DATE: 19 AUG    
 --BUG ID: 3507    
--declare @IV_LA_DEPTCODE as varchar(50)        
 --declare @IV_LA_CUSGRPCODE as varchar(50)        
 --set @IV_LA_DEPTCODE = null        
 --set @IV_LA_CUSGRPCODE = null        
--MODIFIED DATE: 19 AUG    
 --BUG ID: 3507      
    
--Bug ID :- System text for Data, Date 13-May-2009, Original on 11-May-2009, Commented portion has been moved to up    
    
ALTER PROCEDURE [dbo].[USP_LA_CODELIST]        
(        
 @IV_LA_DEPTCODE VARCHAR(100),        
 @IV_LA_CUSGRPCODE VARCHAR(100),    
 @IV_ID_LOGIN VARCHAR(20)   ,    
 @IV_Lang VARCHAR(30)='ENGLISH'    
)        
AS        
BEGIN       
 BEGIN TRY    
  DECLARE @MAINQRY AS VARCHAR(2000)    
    
  DECLARE @LANG INT      
  SELECT @LANG=ID_LANG FROM TBL_MAS_LANGUAGE WHERE LANG_NAME=@iv_Lang    
      
  DECLARE @TRUE AS VARCHAR(50)    
  SELECT @TRUE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_TRUE' AND ISDATA=1    
    
  DECLARE @FALSE AS VARCHAR(50)    
  SELECT @FALSE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_FALSE' AND ISDATA=1    
    
  DECLARE @SP AS VARCHAR(50)    
  SELECT @SP=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_SP' AND ISDATA=1    
    
  DECLARE @LA AS VARCHAR(50)    
  SELECT @LA=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_LA' AND ISDATA=1    
    
  DECLARE @GM AS VARCHAR(50)    
  SELECT @GM=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_GM' AND ISDATA=1    
    
  DECLARE @VAT AS VARCHAR(50)    
  SELECT @VAT=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_VAT' AND ISDATA=1    
    
  DECLARE @RD AS VARCHAR(50)    
  SELECT @RD = ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG = @LANG AND ERR_ID='D_RD' AND ISDATA = 1    
    
  DECLARE @OR AS VARCHAR(50)    
  SELECT @OR = ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG = @LANG AND ERR_ID='D_OR' AND ISDATA = 1    
      
  DECLARE @VA AS VARCHAR(50)    
  SELECT @VA = ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG = @LANG AND ERR_ID='D_VA' AND ISDATA = 1    
      
  DECLARE @FP AS VARCHAR(50)    
  SELECT @FP = ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG = @LANG AND ERR_ID='D_FP' AND ISDATA = 1    
      
  DECLARE @IF AS VARCHAR(50)    
  SELECT @IF = ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG = @LANG AND ERR_ID='D_IF' AND ISDATA = 1    
    
  DECLARE @SellingGL AS VARCHAR(50)    
  SELECT @SellingGL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_Selling GL' AND ISDATA=1    
    
  DECLARE @DiscountGL AS VARCHAR(50)    
  SELECT @DiscountGL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_Discount GL' AND ISDATA=1    
    
  DECLARE @StockGL AS VARCHAR(50)    
  SELECT @StockGL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_Stock GL' AND ISDATA=1    
    
  DECLARE @CostGL AS VARCHAR(50)    
  SELECT @CostGL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_Cost GL' AND ISDATA=1    
      
  DECLARE @SellCostGL AS VARCHAR(50)    
  SELECT @SellCostGL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_SellCost GL' AND ISDATA=1    
    
  DECLARE @CustomerAccountNo AS VARCHAR(50)    
  SELECT @CustomerAccountNo=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_Customer Account No' AND ISDATA=1    
    
    
  DECLARE @HDOC INT                        
  DECLARE @IV_XMLDOC AS VARCHAR(8000)                   
  SELECT @IV_XMLDOC = DBO.FN_DEPTS_FETCH(@IV_ID_LOGIN)                  
  EXEC SP_XML_PREPAREDOCUMENT @HDOC OUTPUT, @IV_XMLDOC    
    
  SELECT LAM.id_slno AS ID_MATRIX,        
  LA_DEPT_ACCCODE AS Dept_AcCode,        
  LA_CUST_ACCCODE AS CustGrp_AcCode,        
  LA_VATCODE AS VATCODE,     
  CASE WHEN LA_SaleDescription='SP' THEN    
    @SP    
   WHEN LA_SaleDescription='LA' THEN    
    @LA    
   WHEN LA_SaleDescription='GM' THEN    
    @GM    
   WHEN LA_SaleDescription='VAT' THEN    
    @VAT    
   WHEN LA_SaleDescription='RD' THEN    
    @RD    
   WHEN LA_SaleDescription='OR' THEN    
    @OR    
   WHEN LA_SaleDescription='VA' THEN    
    @VA    
   WHEN LA_SaleDescription='FP' THEN    
    @FP     
   WHEN LA_SaleDescription='IF' THEN    
    @IF      
  END  AS SaleCode_Type,       
  ISNULL(LA_SaleAccCode,'') AS AccCode,       
  LAM.LA_Description AS Description,  
  ISNULL(LAMDS.LA_AccountNo,'') AS SELLINGGL,  
  ISNULL(LAMDC.LA_AccountNo,'') AS COSTGL     
  FROM TBL_LA_ACCOUNT_MATRIX   LAM  
  left outer join TBL_LA_ACCOUNT_MATRIX_detail LAMDS  
  on LAM.ID_SLNO = LAMDS.LA_SLNO AND LAMDS.LA_DESCRIPTION='SEGL'  
  left outer join TBL_LA_ACCOUNT_MATRIX_detail LAMDC  
  on LAM.ID_SLNO = LAMDC.LA_SLNO AND LAMDC.LA_DESCRIPTION='SCGL'  
  WHERE LA_DEPT_ACCCODE LIKE '%' + ISNULL(@IV_LA_DEPTCODE,'') + '%' AND     
     (@IV_LA_CUSGRPCODE IS NULL OR @IV_LA_CUSGRPCODE=LA_CUST_ACCCODE)  AND     
     ID_DEPT IN (SELECT ID FROM OPENXML (@HDOC,'ROOT/D',0)                  
        WITH (                  
         ID INT                  
         )                  
        )   
    
  DECLARE @temp TABLE         
  (        
   ID_SLNO INT,        
   LA_SLNO INT,        
   LA_DESCRIPTION VARCHAR(50),        
   Acc_Type VARCHAR(30),        
   GenLedger VARCHAR(10),        
   GL_CrDb VARCHAR(10),        
   GL_AccNo VARCHAR(50),        
   GL_DeptAccNo VARCHAR(50),        
   GL_Dimension   VARCHAR(50)    
  )        
      
  DECLARE @slno AS VARCHAR(4)        
  SET @slno = ''       
      
  DECLARE Testing CURSOR FOR        
  SELECT ID_SLNO FROM TBL_LA_ACCOUNT_MATRIX      
       
  OPEN Testing        
  FETCH next FROM Testing INTO @slno        
      
   WHILE @@FETCH_STATUS = 0        
   BEGIN        
    DECLARE @rcnt AS INT        
    SET @rcnt = 0        
    SELECT @rcnt = COUNT(*) FROM TBL_LA_ACCOUNT_MATRIX_detail         
    where LA_SLNO =         
    (SELECT id_slno FROM  TBL_LA_ACCOUNT_MATRIX  WHERE ID_SLNO = @slno )        
    
     IF (@rcnt >0)        
     BEGIN        
      INSERT INTO @temp        
      SELECT AMD.ID_SLNO,AMD.LA_SLNO,AMD.LA_DESCRIPTION,        
      CASE WHEN AMD.LA_DESCRIPTION = 'SEGL' THEN @SellingGL        
        WHEN AMD.LA_DESCRIPTION = 'DGL'  THEN @DiscountGL        
        WHEN AMD.LA_DESCRIPTION = 'STGL' THEN @StockGL        
        WHEN AMD.LA_DESCRIPTION = 'CGL' THEN  @CostGL     
        WHEN AMD.LA_DESCRIPTION = 'SCGL' THEN  @SellCostGL     
        END AS 'Acc_Type',        
        @TRUE AS 'GenLedger',        
        CASE WHEN AMD.LA_FLG_CRE_DEB =1  THEN @TRUE     
          ELSE     
          @FALSE     
        END  AS 'GL_CrDb',        
        AMD.LA_ACCOUNTNO AS 'GL_AccNo',        
        AMD.LA_DEPT_ACCOUNT_NO AS 'GL_DeptAccNo',        
        AMD.LA_DIMENSION AS 'GL_Dimension'        
      FROM TBL_LA_ACCOUNT_MATRIX_detail AMD         
      WHERE AMD.LA_SLNO = @slno AND     
         la_slno IN (SELECT ID_SLNO FROM TBL_LA_ACCOUNT_MATRIX WHERE LA_DEPT_ACCCODE LIKE '%'+ ISNULL(@IV_LA_DEPTCODE,'') +'%'   
         AND (@IV_LA_CUSGRPCODE IS NULL OR @IV_LA_CUSGRPCODE=LA_CUST_ACCCODE))       
    
                
      INSERT INTO @temp        
       SELECT  '',id_slno,'',@CustomerAccountNo,        
         CASE WHEN LA_Flg_LedGL IS NULL THEN @FALSE        
           WHEN LA_Flg_LedGL IS NOT NULL THEN @TRUE        
        END,    
        CASE WHEN LA_Flg_LedGL IS NULL THEN @FALSE     
          WHEN LA_Flg_LedGL =1 THEN @TRUE     
          WHEN LA_Flg_LedGL =0 THEN @FALSE    
        END,'','',''        
      FROM TBL_LA_ACCOUNT_MATRIX         
      WHERE id_slno = @slno and     
         LA_DEPT_ACCCODE LIKE '%'+ ISNULL(@IV_LA_DEPTCODE,'') +'%' AND     
         (@IV_LA_CUSGRPCODE IS NULL OR @IV_LA_CUSGRPCODE=LA_CUST_ACCCODE)        
                    
     END        
    ELSE        
     BEGIN        
      INSERT INTO @temp        
        SELECT '',id_slno,'',@CustomerAccountNo,        
         CASE WHEN LA_Flg_LedGL IS NULL THEN @FALSE        
           WHEN LA_Flg_LedGL IS NOT NULL THEN @TRUE        
         END,    
         CASE WHEN LA_Flg_LedGL IS NULL THEN @FALSE     
          WHEN LA_Flg_LedGL =1 THEN @TRUE     
          WHEN LA_Flg_LedGL =0 THEN @FALSE    
         END,'','',''        
        FROM TBL_LA_ACCOUNT_MATRIX         
        WHERE id_slno = @slno AND     
        LA_DEPT_ACCCODE LIKE '%'+ ISNULL(@IV_LA_DEPTCODE,'') +'%' AND     
        (@IV_LA_CUSGRPCODE IS NULL OR @IV_LA_CUSGRPCODE=LA_CUST_ACCCODE)          
     END        
   FETCH next FROM testing INTO @slno        
  END        
    
  CLOSE testing        
  DEALLOCATE testing        
    
  SELECT * FROM @temp        
    
       
  EXEC SP_XML_REMOVEDOCUMENT @HDOC         
      
    
    
 END TRY    
 BEGIN CATCH    
  -- Execute error retrieval routine.    
  EXECUTE usp_GetErrorInfo;    
 END CATCH;    
        
END                
        
/*        
SELECT * FROM TBL_LA_ACCOUNT_MATRIX        
exec USP_LA_CODELIST null,null        
        
exec USP_LA_CODELIST 'dc4','ca1'        
        
        
*/        
GO

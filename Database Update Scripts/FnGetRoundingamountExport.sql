/****** Object:  UserDefinedFunction [dbo].[FnGetRoundingamountExport]    Script Date: 1/8/2018 1:24:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FnGetRoundingamountExport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FnGetRoundingamountExport]
GO
/****** Object:  UserDefinedFunction [dbo].[FnGetRoundingamountExport]    Script Date: 1/8/2018 1:24:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FnGetRoundingamountExport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*************************************** Application: MSG *********************************************************
* Module	: FnGetVoucherText
* File name : FnGetVoucherText
* Purpose	: To get Voucher Text
* Author	: Fazal Azami
* Date		: 26-May-2009
* Modified History :
* S.No  RFC No/Bug ID                Date        Author      Description
******************************************************************************************************************/

CREATE FUNCTION [dbo].[FnGetRoundingamountExport]
(
	@IV_INV_NO VARCHAR(20)
)
RETURNS DECIMAL(15,5) --Row 722
AS
BEGIN
	-- Declare the return variable here
	DECLARE @AcualAmount DECIMAL(15,2), 
			@RoundedAmount DECIMAL(15,2), 
			@RoundingAmount DECIMAL(15,2),			
			@SpAmount DECIMAL(15,5),
			@JCount DECIMAL(15,5)
/*	
SELECT @SpAmount=
		CAST(SUM((ISNULL(VATAMOUNT,0)))  AS DECIMAL(15,5))--Row 722
	FROM TBL_INV_DETAIL_LINES WHERE ID_INV_NO=@IV_INV_NO and ID_WODET_INVL in
		(
			select ID_WODET_SEQ from TBL_WO_DETAIL where ID_WO_PREFIX+ID_WO_NO+CONVERT(VARCHAR(10),ID_JOB) in (select ID_WO_PREFIX+ID_WO_NO+CONVERT(VARCHAR(10),ID_JOB) from TBL_WO_DETAIL where ID_INV_NO=@IV_INV_NO) 
					and  isnull(WO_OWN_PAY_VAT,0)=1 
									and isnull(WO_OWN_CR_CUST,0)
											=(select ID_DEBITOR from TBL_INV_HEADER where ID_INV_NO=@IV_INV_NO) AND FLG_CHRG_STD_TIME=1)

select @JCount=COUNT(*) from TBL_INV_DETAIL where ID_INV_NO=@IV_INV_NO AND ID_WO_PREFIX+ID_WO_NO+CAST(ID_JOB AS VARCHAR(10)) IN 
								(SELECT ID_WO_PREFIX+ID_WO_NO+CAST(ID_JOB AS VARCHAR(10)) FROM TBL_WO_DETAIL WHERE 
									ID_WO_PREFIX+ID_WO_NO+CONVERT(VARCHAR(10),ID_JOB) IN 
										(SELECT ID_WO_PREFIX+ID_WO_NO+CONVERT(VARCHAR(10),ID_JOB) FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX+ID_WO_NO+CONVERT(VARCHAR(10),ID_JOB) IN (select ID_WO_PREFIX+ID_WO_NO+CONVERT(VARCHAR(10),ID_JOB) from TBL_INV_DETAIL where ID_INV_NO=@IV_INV_NO))
								and  isnull(WO_OWN_PAY_VAT,0)=1
								and isnull(WO_OWN_CR_CUST,0)=(select ID_DEBITOR from TBL_INV_HEADER where ID_INV_NO=@IV_INV_NO) AND FLG_CHRG_STD_TIME=1)


if isnull(@JCount,0) <>0
begin
set @SpAmount=@SpAmount/@JCount /*done to avoid repitition of spare amount for all jobs*/
end
else
begin
set @SpAmount=0
end



	DECLARE @INVOICETOTAL TABLE
	(
		TOTALAMOUNT DECIMAL(15,5), 
		GARAGEMATERIALAMT DECIMAL(15,5), 
		VATAM0UNT DECIMAL(15,5), 
		FIXEDAMOUNT DECIMAL(15,5), 
		OWNRISKAMOUNT DECIMAL(15,5), 
		FINALAMOUNT DECIMAL(15,5), 
		OWNRISKVAT DECIMAL(15,5),
		JOBID INT,
	 	ID_WO_NO INT,
		ID_WO_PREFIX VARCHAR(5),
		ID_Mech varchar(50)
	)
	INSERT @INVOICETOTAL 
	SELECT 
		INVD.LINE_AMOUNT AS ''TOTALAMOUNT''  
		,0 AS ''GARAGEMATERIALAMT'', 
		INVD.LINE_VAT_AMOUNT AS ''VATAM0UNT''   
		,0 AS ''FIXEDAMOUNT'' 
		,0 AS ''OWNRISKAMOUNT'' 
		,0 AS FINALAMOUNT 
		,0 AS OWNRISKVAT
		,ID.ID_JOB
		,WD.ID_WO_NO	
		,WD.ID_WO_PREFIX
		,''SPARES''
	FROM 
		DBO.TBL_INV_HEADER AS IH 
			LEFT OUTER JOIN 
		DBO.TBL_INV_DETAIL AS ID ON ID.ID_INV_NO = IH.ID_INV_NO 
			LEFT OUTER JOIN 
		DBO.TBL_WO_DETAIL AS WD ON WD.ID_WODET_SEQ = ID.ID_WODET_INV
			LEFT OUTER JOIN 
		DBO.TBL_INV_DETAIL_LINES AS IDL ON ID.ID_WODET_INV = IDL.ID_WODET_INVL AND ID.ID_INV_NO = IDL.ID_INV_NO 
			LEFT OUTER JOIN 
		DBO.TBL_WO_JOB_DETAIL AS WJD ON WJD.ID_WOITEM_SEQ = IDL.ID_WOITEM_SEQ 
			LEFT OUTER JOIN 
		DBO.TBL_WO_DEBITOR_DETAIL AS DEBDET ON DEBDET.ID_WO_NO = ID.ID_WO_NO AND DEBDET.ID_WO_PREFIX = ID.ID_WO_PREFIX AND 
		IH.ID_DEBITOR = DEBDET.ID_JOB_DEB AND ID.ID_JOB = DEBDET.ID_JOB_ID 
			LEFT OUTER JOIN 
		DBO.TBL_MAS_SUBSIDERY AS MS ON MS.ID_SUBSIDERY = IH.ID_SUBSIDERY_INV 
			LEFT OUTER JOIN 
		DBO.TBL_MAS_DEPT AS MD ON MD.ID_DEPT = IH.ID_DEPT_INV 
			LEFT OUTER JOIN 
		TBL_INVOICE_DATA INVD ON INVD.ID_WO_NO = WD.ID_WO_NO AND INVD.ID_WO_PREFIX = WD.ID_WO_PREFIX AND INVD.ID_JOB_ID = WD.ID_JOB AND INVD.ID_WOITEM_SEQ = IDL.ID_WOITEM_SEQ
		AND INVD.LINE_TYPE=''SPARES'' --AND DEBDET.ID_DBT_SEQ = INVD.DEBTOR_SEQ 
		AND INVD.ID_INV_NO=@IV_INV_NO 
	WHERE 
		IH.ID_INV_NO = @IV_INV_NO 

	UNION ALL 

	SELECT DISTINCT
  INVD.LINE_AMOUNT 
  AS ''TOTALAMOUNT''  
		,  0 AS ''GARAGEMATERIALAMT''   
  ,INVD.LINE_VAT_AMOUNT
  AS ''VATAM0UNT''  
		,CASE WHEN ISNULL(WD.WO_OWN_RISK_AMT, 0) > 0 THEN
			CASE WHEN DEBDET.DBT_PER = 0  THEN
				0
			ELSE 
				ID.INVD_FIXEDAMT 
			END
		ELSE
			CASE WHEN WD.WO_OWN_PAY_VAT=1 THEN
				CASE WHEN DEBDET.DBT_PER = 0  THEN
					0
				ELSE 
					ID.INVD_FIXEDAMT 
				END 
			ELSE
				ID.INVD_FIXEDAMT 
			END
		END AS ''FIXEDAMOUNT''  
		,0 AS ''OWNRISKAMOUNT'' 
		,0 AS FINALAMOUNT 
		,0 AS ''OWNRISKVAT'' 
		,ID.ID_JOB
		,WD.ID_WO_NO	
		,WD.ID_WO_PREFIX
		--,IDLL.INVL_IDLOGIN
		,CASE WHEN ISNULL(WO_FIXED_PRICE, 0) > 0 
				THEN 
					NULL
				ELSE 
					IDLL.INVL_IDLOGIN 
		END 
	FROM 
		DBO.TBL_INV_HEADER AS IH 
			LEFT OUTER JOIN 
		DBO.TBL_INV_DETAIL AS ID ON ID.ID_INV_NO = IH.ID_INV_NO 
		--	LEFT OUTER JOIN 
		--DBO.TBL_INV_DETAIL_LINES AS IDL ON ID.ID_WODET_INV = IDL.ID_WODET_INVL AND ID.ID_INV_NO = IDL.ID_INV_NO
			LEFT OUTER JOIN 
		DBO.TBL_INV_DETAIL_LINES_LABOUR AS IDLL ON ID.ID_WODET_INV = IDLL.ID_WODET_INVL AND ID.ID_INV_NO = IDLL.ID_INV_NO 
			LEFT OUTER JOIN	
		DBO.TBL_WO_HEADER AS WH ON ID.ID_WO_NO = WH.ID_WO_NO AND ID.ID_WO_PREFIX = WH.ID_WO_PREFIX 
			LEFT OUTER JOIN 
		DBO.TBL_WO_DETAIL AS WD ON WD.ID_WODET_SEQ = ID.ID_WODET_INV 
			LEFT OUTER JOIN	
		DBO.TBL_WO_DEBITOR_DETAIL AS DEBDET ON DEBDET.ID_WO_NO = ID.ID_WO_NO AND DEBDET.ID_WO_PREFIX = ID.ID_WO_PREFIX AND 
		IH.ID_DEBITOR = DEBDET.ID_JOB_DEB AND ID.ID_JOB = DEBDET.ID_JOB_ID 
			LEFT OUTER JOIN 
		TBL_WO_JOB_DETAIL AS WOJ ON WOJ.ID_WODET_SEQ_JOB =WD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WD.ID_WO_NO
		    LEFT OUTER JOIN TBL_INVOICE_DATA INVD 
		ON INVD.ID_WO_NO = WD.ID_WO_NO AND INVD.ID_WO_PREFIX = WD.ID_WO_PREFIX AND INVD.ID_JOB_ID = WD.ID_JOB AND INVD.ID_WOLAB_SEQ = IDLL.ID_WOLAB_SEQ
		AND INVD.LINE_TYPE=''LABOUR'' --AND DEBDET.ID_DBT_SEQ = INVD.DEBTOR_SEQ 
		AND INVD.ID_INV_NO=@IV_INV_NO
	WHERE 
		IH.ID_INV_NO = @IV_INV_NO AND WD.FLG_CHRG_STD_TIME = 0
	UNION ALL -- FOR STANDARD TIME =1
		SELECT 
					-- Modified on 04/05/2010 for Owner pay vat
					CASE WHEN WD.WO_OWN_PAY_VAT=1 AND DEBDET.DBT_PER=0 AND IH.ID_DEBITOR = DEBDET.ID_JOB_DEB THEN
						CASE WHEN WD.WO_FIXED_PRICE<>0 THEN
								0
						ELSE 
							( (CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 THEN 
										0 
								   ELSE 
										CONVERT(DECIMAL(5, 2), WD.WO_CHRG_TIME) 
									END ) 
								* WD.WO_HOURLEY_PRICE -
								((CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 THEN 0 
										ELSE CONVERT(DECIMAL(5, 2), WD.WO_CHRG_TIME) 
								END ) 
									* WD.WO_HOURLEY_PRICE * WD.WO_DISCOUNT / 100) )* WD.WO_LBR_VATPER / 100  
						END
					ELSE
						CASE WHEN WD.WO_FIXED_PRICE<>0 THEN
								0
						ELSE 					
								((CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 THEN 
												0 
										   ELSE 
												CONVERT(DECIMAL(5, 2), WD.WO_CHRG_TIME) 
											END ) 
										* WD.WO_HOURLEY_PRICE -
										((CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 THEN 0 
												ELSE CONVERT(DECIMAL(5, 2), WD.WO_CHRG_TIME) 
										END ) 
											* WD.WO_HOURLEY_PRICE * WD.WO_DISCOUNT / 100) )* DEBDET.DBT_PER / 100  
						END
					END
		AS ''TOTALAMOUNT'' 
		,0 
		AS ''GARAGEMATERIALAMT''
		,CASE WHEN ISNULL(WD.WO_FIXED_PRICE, 0.00) = 0.00 
			THEN 
						CASE WHEN 
								( SELECT COUNT(*) FROM TBL_WO_DEBITOR_DETAIL DEBT 
									WHERE DEBT.ID_WO_NO = ID.ID_WO_NO AND DEBT.ID_WO_PREFIX = ID.ID_WO_PREFIX AND DEBT.ID_JOB_ID = ID.ID_JOB 
								) 
							> 1 
							THEN 
								CASE WHEN WD.WO_OWN_PAY_VAT = 1 THEN 
									CASE WHEN WD.WO_OWN_CR_CUST = IH.ID_DEBITOR and DEBDET.SPLIT_PER=0.0   THEN
										@SpAmount
									ELSE
										0 
									END
								ELSE
									((((WD.WO_CHRG_TIME) * WD.WO_HOURLEY_PRICE - 
										((CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 
												THEN 
													0 
												ELSE 
													CONVERT(DECIMAL(5, 2),WD.WO_CHRG_TIME) 
												END 
											) * WD.WO_HOURLEY_PRICE * WD.WO_DISCOUNT / 100)) * (DEBDET.WO_LBR_VATPER / 100) * (DEBDET.DBT_PER/100)) 
											+ ((WD.WO_TOT_GM_AMT - (WD.WO_TOT_GM_AMT * (WD.WO_DISCOUNT / 100))) * (DEBDET.DBT_PER / 100) * (DEBDET.WO_GM_VATPER/100)))
											--Modified 31/03/2010 wd.WO_GM_VATPER replace with DEBDET.WO_GM_VATPER
								END 
							ELSE 
								(((((CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 
										THEN 
											0 
										ELSE 
											CONVERT(DECIMAL(5, 2), WD.WO_CHRG_TIME) 
										END 
									) * WD.WO_HOURLEY_PRICE) 
									- 
								(((CASE WHEN LEN(WD.WO_CHRG_TIME) = 0 
										THEN 
											0 
										ELSE 
											CONVERT(DECIMAL(5, 2), WD.WO_CHRG_TIME) 
										END 
									) * WD.WO_HOURLEY_PRICE) * (WD.WO_DISCOUNT / 100))) 
									* WD.WO_LBR_VATPER / 100) + ((WD.WO_TOT_GM_AMT - (WD.WO_TOT_GM_AMT * (WD.WO_DISCOUNT / 100))) * (WD.WO_GM_VATPER / 100))) 
						END 
			ELSE 
				--WD.WO_TOT_VAT_AMT * (DEBDET.DBT_PER / 100)
				CASE WHEN WD.WO_OWN_PAY_VAT = 1 THEN 
						CASE WHEN WD.WO_OWN_CR_CUST = IH.ID_DEBITOR THEN
								WD.WO_TOT_VAT_AMT 
						ELSE 
								0
						END
				ELSE
						CASE WHEN WD.WO_OWN_CR_CUST = IH.ID_DEBITOR AND ISNULL(WD.WO_OWN_RISK_AMT,0)>0 THEN  --(Fixed price and WO_OWN_RISK_AMT> 0)
								0
						ELSE 
							CASE WHEN WD.WO_OWN_CR_CUST IS NULL THEN --(Fixed price & split percentage is 0)
								ISNULL(WD.WO_FIXED_PRICE,0)*(isnull(DEBDET.DEBTOR_VAT_PERCENTAGE,0)/100) * ISNULL(DEBDET.DBT_PER,0)/100
							 ELSE   
								ISNULL(WD.WO_TOT_VAT_AMT,0)
							END
						END
			END		
		END 
		AS ''VATAM0UNT'' 
		,
		CASE WHEN ISNULL(WD.WO_OWN_RISK_AMT, 0) > 0 THEN
			CASE WHEN DEBDET.DBT_PER = 0  THEN
				0
			ELSE 
					CASE WHEN WD.WO_OWN_PAY_VAT = 1 THEN 
						CASE WHEN WD.WO_OWN_CR_CUST = IH.ID_DEBITOR THEN
							CASE WHEN DEBDET.DBT_PER = 0  THEN
								0
							ELSE 
								ID.INVD_FIXEDAMT 
							END
						ELSE
							ID.INVD_FIXEDAMT  
						END
					ELSE
						ID.INVD_FIXEDAMT
					END 
			END
		ELSE
					CASE WHEN WD.WO_OWN_PAY_VAT = 1 THEN 
						CASE WHEN WD.WO_OWN_CR_CUST = IH.ID_DEBITOR THEN
							CASE WHEN DEBDET.DBT_PER = 0  THEN
								0
							ELSE 
								ID.INVD_FIXEDAMT 
							END
						ELSE
							ID.INVD_FIXEDAMT  
						END
					ELSE
						CASE WHEN WD.WO_OWN_CR_CUST IS NULL THEN  --(Fixed price & split percentage is 0)
					      ISNULL(ID.INVD_FIXEDAMT,0) --* ISNULL(DEBDET.DBT_PER,0)/100 ROW 475 INVD_FIXEDAMT IS ALREADY SPLIT
					    ELSE
						  ID.INVD_FIXEDAMT 
						END
					END 
		END AS ''FIXEDAMOUNT'' 
		
		,0 AS ''OWNRISKAMOUNT'' 
		,0 AS FINALAMOUNT 
		,0 AS ''OWNRISKVAT'' 
		,ID.ID_JOB
		,WD.ID_WO_NO	
		,WD.ID_WO_PREFIX
		,''LABOUR''
	FROM 
		DBO.TBL_INV_HEADER AS IH 
			inner JOIN 
		DBO.TBL_INV_DETAIL AS ID ON ID.ID_INV_NO = IH.ID_INV_NO 
			LEFT OUTER JOIN	
		DBO.TBL_WO_HEADER AS WH ON ID.ID_WO_NO = WH.ID_WO_NO AND ID.ID_WO_PREFIX = WH.ID_WO_PREFIX 
			inner JOIN  
		DBO.TBL_WO_DETAIL AS WD ON WD.ID_WODET_SEQ = ID.ID_WODET_INV 
			LEFT OUTER JOIN	
		DBO.TBL_WO_DEBITOR_DETAIL AS DEBDET ON DEBDET.ID_WO_NO = ID.ID_WO_NO AND DEBDET.ID_WO_PREFIX = ID.ID_WO_PREFIX AND 
		IH.ID_DEBITOR = DEBDET.ID_JOB_DEB AND ID.ID_JOB = DEBDET.ID_JOB_ID 
	WHERE 
		IH.ID_INV_NO = @IV_INV_NO and WD.FLG_CHRG_STD_TIME = 1

	UNION ALL 

	SELECT DISTINCT
  INVD.LINE_AMOUNT 
  AS ''TOTALAMOUNT''  
		,  0 AS ''GARAGEMATERIALAMT''   
  ,INVD.LINE_VAT_AMOUNT
  AS ''VATAM0UNT''  
		,CASE WHEN ISNULL(WD.WO_OWN_RISK_AMT, 0) > 0 THEN
			CASE WHEN DEBDET.DBT_PER = 0  THEN
				0
			ELSE 
				ID.INVD_FIXEDAMT 
			END
		ELSE
			CASE WHEN WD.WO_OWN_PAY_VAT=1 THEN
				CASE WHEN DEBDET.DBT_PER = 0  THEN
					0
				ELSE 
					ID.INVD_FIXEDAMT 
				END 
			ELSE
				ID.INVD_FIXEDAMT 
			END
		END AS ''FIXEDAMOUNT''  
		,0 AS ''OWNRISKAMOUNT'' 
		,0 AS FINALAMOUNT 
		,0 AS ''OWNRISKVAT'' 
		,ID.ID_JOB
		,WD.ID_WO_NO	
		,WD.ID_WO_PREFIX
		--,IDLL.INVL_IDLOGIN
		,CASE WHEN ISNULL(WO_FIXED_PRICE, 0) > 0 
				THEN 
					NULL
				ELSE 
					IDLL.INVL_IDLOGIN 
		END 
	FROM 
		DBO.TBL_INV_HEADER AS IH 
			LEFT OUTER JOIN 
		DBO.TBL_INV_DETAIL AS ID ON ID.ID_INV_NO = IH.ID_INV_NO 
		--	LEFT OUTER JOIN 
		--DBO.TBL_INV_DETAIL_LINES AS IDL ON ID.ID_WODET_INV = IDL.ID_WODET_INVL AND ID.ID_INV_NO = IDL.ID_INV_NO
			LEFT OUTER JOIN 
		DBO.TBL_INV_DETAIL_LINES_LABOUR AS IDLL ON ID.ID_WODET_INV = IDLL.ID_WODET_INVL AND ID.ID_INV_NO = IDLL.ID_INV_NO 
			LEFT OUTER JOIN	
		DBO.TBL_WO_HEADER AS WH ON ID.ID_WO_NO = WH.ID_WO_NO AND ID.ID_WO_PREFIX = WH.ID_WO_PREFIX 
			LEFT OUTER JOIN 
		DBO.TBL_WO_DETAIL AS WD ON WD.ID_WODET_SEQ = ID.ID_WODET_INV 
			LEFT OUTER JOIN	
		DBO.TBL_WO_DEBITOR_DETAIL AS DEBDET ON DEBDET.ID_WO_NO = ID.ID_WO_NO AND DEBDET.ID_WO_PREFIX = ID.ID_WO_PREFIX AND 
		IH.ID_DEBITOR = DEBDET.ID_JOB_DEB AND ID.ID_JOB = DEBDET.ID_JOB_ID 
			LEFT OUTER JOIN 
		TBL_WO_JOB_DETAIL AS WOJ ON WOJ.ID_WODET_SEQ_JOB =WD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WD.ID_WO_NO
		    LEFT OUTER JOIN TBL_INVOICE_DATA INVD 
		ON INVD.ID_WO_NO = WD.ID_WO_NO AND INVD.ID_WO_PREFIX = WD.ID_WO_PREFIX AND INVD.ID_JOB_ID = WD.ID_JOB AND INVD.ID_WOLAB_SEQ = IDLL.ID_WOLAB_SEQ
		AND INVD.LINE_TYPE=''GM'' --AND DEBDET.ID_DBT_SEQ = INVD.DEBTOR_SEQ 
		AND INVD.ID_INV_NO=@IV_INV_NO
	WHERE 
		IH.ID_INV_NO = @IV_INV_NO AND WD.FLG_CHRG_STD_TIME = 0
	  
  UNION ALL   
  
 SELECT DISTINCT  
  0  AS ''TOTALAMOUNT''  
  ,0  AS ''GARAGEMATERIALAMT''   
  ,0
  AS ''VATAM0UNT''   
  ,0 AS ''FIXEDAMOUNT''    
  ,INVD.LINE_AMOUNT  AS ''OWNRISKAMOUNT''   
  ,0 AS FINALAMOUNT   
  ,INVD.LINE_VAT_AMOUNT  AS ''OWNRISKVAT''   
  ,ID.ID_JOB  
  ,WD.ID_WO_NO   
  ,WD.ID_WO_PREFIX  
  ,''OWNRISK''
 FROM   
  DBO.TBL_INV_HEADER AS IH   
   LEFT OUTER JOIN   
  DBO.TBL_INV_DETAIL AS ID ON ID.ID_INV_NO = IH.ID_INV_NO   
   LEFT OUTER JOIN   
  DBO.TBL_INV_DETAIL_LINES_LABOUR AS IDLL ON ID.ID_WODET_INV = IDLL.ID_WODET_INVL AND ID.ID_INV_NO = IDLL.ID_INV_NO   
   LEFT OUTER JOIN   
  DBO.TBL_WO_HEADER AS WH ON ID.ID_WO_NO = WH.ID_WO_NO AND ID.ID_WO_PREFIX = WH.ID_WO_PREFIX   
   LEFT OUTER JOIN   
  DBO.TBL_WO_DETAIL AS WD ON WD.ID_WODET_SEQ = ID.ID_WODET_INV   
   LEFT OUTER JOIN   
  DBO.TBL_WO_DEBITOR_DETAIL AS DEBDET ON DEBDET.ID_WO_NO = ID.ID_WO_NO AND DEBDET.ID_WO_PREFIX = ID.ID_WO_PREFIX AND   
  IH.ID_DEBITOR = DEBDET.ID_JOB_DEB AND ID.ID_JOB = DEBDET.ID_JOB_ID   
   LEFT OUTER JOIN   
  TBL_WO_JOB_DETAIL AS WOJ ON WOJ.ID_WODET_SEQ_JOB =WD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WD.ID_WO_NO  
   LEFT OUTER JOIN TBL_INVOICE_DATA INVD 
	ON INVD.ID_WO_NO = WD.ID_WO_NO AND INVD.ID_WO_PREFIX = WD.ID_WO_PREFIX AND INVD.ID_JOB_ID = WD.ID_JOB 
	AND INVD.LINE_TYPE=''OWNRISK'' --AND DEBDET.ID_DBT_SEQ = INVD.DEBTOR_SEQ 
	AND INVD.ID_INV_NO=@IV_INV_NO
 WHERE   
  IH.ID_INV_NO = @IV_INV_NO 
 
   UNION ALL   
  
 SELECT DISTINCT  
  INVD.LINE_AMOUNT AS ''TOTALAMOUNT''  
  ,0  AS ''GARAGEMATERIALAMT''   
  ,INVD.LINE_VAT_AMOUNT  AS ''VATAM0UNT''   
  ,0 AS ''FIXEDAMOUNT''    
  ,0 AS ''OWNRISKAMOUNT''   
  ,0 AS FINALAMOUNT   
  ,0 AS ''OWNRISKVAT''   
  ,ID.ID_JOB  
  ,WD.ID_WO_NO   
  ,WD.ID_WO_PREFIX  
  ,''OWNRISK''
 FROM   
  DBO.TBL_INV_HEADER AS IH   
   LEFT OUTER JOIN   
  DBO.TBL_INV_DETAIL AS ID ON ID.ID_INV_NO = IH.ID_INV_NO   
   LEFT OUTER JOIN   
  DBO.TBL_INV_DETAIL_LINES_LABOUR AS IDLL ON ID.ID_WODET_INV = IDLL.ID_WODET_INVL AND ID.ID_INV_NO = IDLL.ID_INV_NO   
   LEFT OUTER JOIN   
  DBO.TBL_WO_HEADER AS WH ON ID.ID_WO_NO = WH.ID_WO_NO AND ID.ID_WO_PREFIX = WH.ID_WO_PREFIX   
   LEFT OUTER JOIN   
  DBO.TBL_WO_DETAIL AS WD ON WD.ID_WODET_SEQ = ID.ID_WODET_INV   
   LEFT OUTER JOIN   
  DBO.TBL_WO_DEBITOR_DETAIL AS DEBDET ON DEBDET.ID_WO_NO = ID.ID_WO_NO AND DEBDET.ID_WO_PREFIX = ID.ID_WO_PREFIX AND   
  IH.ID_DEBITOR = DEBDET.ID_JOB_DEB AND ID.ID_JOB = DEBDET.ID_JOB_ID   
   LEFT OUTER JOIN   
  TBL_WO_JOB_DETAIL AS WOJ ON WOJ.ID_WODET_SEQ_JOB =WD.ID_WODET_SEQ AND WOJ.ID_WO_PREFIX=WD.ID_WO_PREFIX AND WOJ.ID_WO_NO = WD.ID_WO_NO  
   LEFT OUTER JOIN TBL_INVOICE_DATA INVD 
	ON INVD.ID_WO_NO = WD.ID_WO_NO AND INVD.ID_WO_PREFIX = WD.ID_WO_PREFIX AND INVD.ID_JOB_ID = WD.ID_JOB 
	AND INVD.LINE_TYPE=''REDUCTION'' --AND DEBDET.ID_DBT_SEQ = INVD.DEBTOR_SEQ 
	AND INVD.ID_INV_NO=@IV_INV_NO
 WHERE   
  IH.ID_INV_NO = @IV_INV_NO		
	
	IF EXISTS(SELECT * FROM @INVOICETOTAL WHERE FIXEDAMOUNT <> 0)
		--DELETE FROM @INVOICETOTAL WHERE FIXEDAMOUNT = 0 AND JOBID in (SELECT JOBID FROM @INVOICETOTAL WHERE FIXEDAMOUNT > 0)
		DELETE FROM @INVOICETOTAL WHERE FIXEDAMOUNT = 0 AND ID_WO_PREFIX+CAST(ID_WO_NO AS VARCHAR(15)) + CAST(JOBID AS VARCHAR(10)) in (SELECT ID_WO_PREFIX+CAST(ID_WO_NO AS VARCHAR(15))+CAST(JOBID AS VARCHAR(10)) FROM @INVOICETOTAL WHERE FIXEDAMOUNT <> 0)	

	IF EXISTS(SELECT * FROM @INVOICETOTAL WHERE VATAM0UNT IS NULL)
		BEGIN
			IF NOT EXISTS(SELECT * FROM @INVOICETOTAL WHERE OWNRISKAMOUNT IS NOT NULL)
				UPDATE @INVOICETOTAL SET VATAM0UNT = 0
		END

	UPDATE @INVOICETOTAL SET TOTALAMOUNT = 0, GARAGEMATERIALAMT = 0, FINALAMOUNT = 0 WHERE FIXEDAMOUNT <> 0 
	
	--UPDATE @INVOICETOTAL SET VATAM0UNT = 0 WHERE OWNRISKAMOUNT > 0 
	
	SELECT @AcualAmount = 
		CAST (SUM(ISNULL(TOTALAMOUNT,0) + ISNULL(GARAGEMATERIALAMT,0) + ISNULL(VATAM0UNT,0) + ISNULL(FIXEDAMOUNT,0) + ISNULL(OWNRISKAMOUNT,0) + ISNULL(FINALAMOUNT,0) + ISNULL(OWNRISKVAT,0) )AS NUMERIC (15,5)) --Row 722
	--ISNULL(GARAGEMATERIALAMT,0)
	FROM @INVOICETOTAL 
	
	--224
	SELECT @AcualAmount = @AcualAmount + isnull(INV_FEES_AMT,0) + isnull(INV_FEES_VAT_AMT,0)
	FROM TBL_INV_HEADER
	where ID_INV_NO = @IV_INV_NO
*/	

	DECLARE @NETTOTAL DECIMAL(15,5)
	DECLARE @VATTOTAL DECIMAL(15,5)
		SELECT @NETTOTAL = INVOICESUM FROM TBL_INVOICE_DATA WHERE ID_INV_NO=@IV_INV_NO
		SELECT @VATTOTAL = VATAMOUNT FROM TBL_INVOICE_DATA WHERE ID_INV_NO=@IV_INV_NO


	SELECT @AcualAmount = @NETTOTAL + @VATTOTAL + isnull(INV_FEES_AMT,0) + isnull(INV_FEES_VAT_AMT,0)  
	FROM TBL_INV_HEADER  
	where ID_INV_NO = @IV_INV_NO  

	SELECT @RoundedAmount =  
		CASE WHEN @AcualAmount <> 0 THEN 
		(SELECT 
			CASE WHEN INV_PRICE_RND_FN= ''Flr'' and INV_RND_DECIMAL > 0 THEN 
				FLOOR(abs(@AcualAmount)/INV_RND_DECIMAL )*INV_RND_DECIMAL 
			WHEN INV_PRICE_RND_FN= ''Rnd'' and INV_RND_DECIMAL > 0 THEN 
				FLOOR(abs(@AcualAmount)/INV_RND_DECIMAL + (1 - (INV_PRICE_RND_VAL_PER/ 100 )) )*INV_RND_DECIMAL 
			WHEN INV_PRICE_RND_FN= ''Clg'' and INV_RND_DECIMAL > 0 THEN 
				Ceiling(abs(@AcualAmount)/INV_RND_DECIMAL)*INV_RND_DECIMAL 
			ELSE abs(@AcualAmount) 
			END 
		FROM 
			TBL_MAS_INV_CONFIGURATION where DT_EFF_TO IS NULL AND ID_DEPT_INV = TBL_INV_HEADER.ID_Dept_Inv 
			AND ID_SUBSIDERY_INV = TBL_INV_HEADER.ID_Subsidery_Inv )ELSE 0 
		END 
	--FROM @INVOICETOTAL, TBL_INV_HEADER 
	FROM TBL_INV_HEADER 
	WHERE @AcualAmount <> 0 AND 
		TBL_INV_HEADER.ID_INV_NO = @IV_INV_NO  

if @AcualAmount<0 
	SET @RoundedAmount = -1*@RoundedAmount 

	SET @RoundingAmount = ISNULL(@RoundedAmount, 0) - ISNULL((@AcualAmount), 0) 
	--SET @RoundingAmount = ISNULL(@RoundedAmount, 0) - ISNULL(abs(@AcualAmount), 0) 
	/*FOR NEGATIVE INVOICE THE ROUNDING AMOUNT 
	MAY BE NEGATIVE OR POSITIVE BASED ON ROUNDING RULES*/
	
--if @AcualAmount<0 
--	SET @RoundingAmount = -1*@RoundingAmount 
--	RETURN (abs(@RoundingAmount)) 
RETURN (@RoundingAmount)
END

' 
END

GO

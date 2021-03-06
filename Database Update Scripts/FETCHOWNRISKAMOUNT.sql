/****** Object:  UserDefinedFunction [dbo].[FETCHOWNRISKAMOUNT]    Script Date: 4/13/2017 5:03:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FETCHOWNRISKAMOUNT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FETCHOWNRISKAMOUNT]
GO
/****** Object:  UserDefinedFunction [dbo].[FETCHOWNRISKAMOUNT]    Script Date: 4/13/2017 5:03:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FETCHOWNRISKAMOUNT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*************************************** Application: MSG *************************************************************          
* Module : Payment Summary 
* File name : FETCHOWNRISKAMOUNT
* Purpose : To get Own Risk amount          
* Author : Fazal Azami         
* Date  : 12-Nov-2008          
*********************************************************************************************************************/          
/*********************************************************************************************************************            
I/P : -- Input Parameters          
O/P :-- Output Parameters          
Error Code          
Description INT.VerNO : NOV21.0           
          
********************************************************************************************************************/          
      
          
CREATE function [dbo].[FETCHOWNRISKAMOUNT]
(
	@WONO AS VARCHAR(10),                                
	@WOPREFIX AS VARCHAR(3),
	@JobID AS INT,
	@CUSTID AS INT
)            
RETURNS DECIMAL(15,4) 
BEGIN            
	DECLARE @OwnRiskAmt AS DECIMAL(15,4) 
	DECLARE @DBT_PER AS DECIMAL(15,4)
	DECLARE @OwnRiskVATAmt AS DECIMAL(15,4)
	DECLARE @TotVat AS DECIMAL(15,4)
	SET @OwnRiskAmt = 0 
	SET @DBT_PER = 0

	-- To check whether own risk amount exist
	IF EXISTS	(SELECT DBT_AMT
				FROM TBL_WO_DEBITOR_DETAIL 
				WHERE ID_WO_PREFIX = @WOPREFIX 
					AND ID_WO_NO = @WONO 
					AND ID_JOB_ID = @JobID 
					AND DBT_PER = 0
				)
	BEGIN
		-- Fetching OwnRisk VAT if owner pays VAT
		SELECT @OwnRiskVATAmt = 
			CASE WHEN WO_OWN_PAY_VAT = 1 THEN
				OwnRiskVATAmt 
			ELSE
				0 
			END
		FROM TBL_WO_DETAIL
		WHERE ID_WO_NO = @WONO
			AND ID_WO_PREFIX = @WOPREFIX
			AND ID_JOB = @JobID

		-- To check whether owner is own risk customer
		IF EXISTS	(SELECT WOH.ID_CUST_WO 
					FROM TBL_WO_HEADER WOH 
						INNER JOIN TBL_WO_DEBITOR_DETAIL DEBT ON 
							WOH.ID_WO_PREFIX = DEBT.ID_WO_PREFIX 
							AND WOH.ID_WO_NO = DEBT.ID_WO_NO 
							AND WOH.ID_CUST_WO = DEBT.ID_JOB_DEB
					WHERE WOH.ID_WO_PREFIX = @WOPREFIX 
					AND WOH.ID_WO_NO = @WONO 
					AND DEBT.ID_JOB_ID = @JobID
					AND DEBT.DBT_PER = 0
					)
		BEGIN
			SELECT @TotVat = WO_TOT_VAT_AMT 
			FROM TBL_WO_DETAIL
			WHERE ID_WO_PREFIX = @WOPREFIX
				AND ID_WO_NO = @WONO
				AND ID_JOB = @JobID

			SET @OwnRiskVATAmt = 0
		END
		ELSE
		BEGIN
			SET @TotVat = 0
		END

		-- Fetching Total VAT only if owner pays VAT
		SELECT @TotVat = 
			CASE WHEN WO_OWN_PAY_VAT = 1 THEN
				@TotVat 
			ELSE
				0 
			END
		FROM TBL_WO_DETAIL
		WHERE ID_WO_NO = @WONO
			AND ID_WO_PREFIX = @WOPREFIX
			AND ID_JOB = @JobID

/*************/
		SELECT @OwnRiskAmt = ISNULL(wod.WO_OWN_RISK_AMT, 0) + @OwnRiskVATAmt /*- @TotVat (not necessary since credit customer is always the own risk customer)*/
		FROM TBL_WO_DEBITOR_DETAIL wodeb
		inner join TBL_WO_DETAIL wod on wodeb.ID_WO_PREFIX = wod.ID_WO_PREFIX 
			AND wodeb.ID_WO_NO = wod.ID_WO_NO 
			AND wodeb.ID_JOB_ID = wod.ID_JOB 

		WHERE wodeb.ID_WO_PREFIX = @WOPREFIX 
			AND wodeb.ID_WO_NO = @WONO 
			AND wodeb.ID_JOB_ID = @JobID 
			AND wodeb.DBT_PER = 0
/*************/			

		SELECT @DBT_PER = ISNULL(DBT_PER, 0)
		FROM TBL_WO_DEBITOR_DETAIL 
		WHERE ID_WO_PREFIX = @WOPREFIX 
			AND ID_WO_NO = @WONO 
			AND ID_JOB_ID = @JobID 
			AND ID_JOB_DEB = @CUSTID
		
		--Nov 22 2011 changed to implement Owner Pay vat to credit customer pay vat
		IF ISNULL((SELECT WO_OWN_RISK_AMT FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX = @WOPREFIX 
		AND ID_WO_NO = @WONO 
		AND ID_JOB = @JOBID),0)=0
		BEGIN
			SET @OWNRISKAMT = 0
		END			
		--Change End

		IF @DBT_PER = 0
		BEGIN
			SET @OwnRiskAmt = @OwnRiskAmt
		END
		ELSE
		BEGIN
			SET @OwnRiskAmt = (-1 * @OwnRiskAmt * (@DBT_PER / 100))
		END
	END
	ELSE
	BEGIN 
		SET @OwnRiskAmt = 0
	END

	--SET OWN RISK TO 0 IF MISC CUSTOMER EXISTS TO PAY OWNN RISK
	IF ISNULL((SELECT OWN_RISK_AMOUNT FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = @WONO AND ID_WO_PREFIX=@WOPREFIX AND ID_JOB_ID=@JobID AND CUST_TYPE = ''MISC''),0) >0
		AND (SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = @WONO AND ID_WO_PREFIX=@WOPREFIX AND ID_JOB_ID=@JobID AND ID_JOB_DEB = @CUSTID)=''OHC''
			SET @OwnRiskAmt = 0
	ELSE IF ISNULL((SELECT OWN_RISK_AMOUNT FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = @WONO AND ID_WO_PREFIX=@WOPREFIX AND ID_JOB_ID=@JobID AND CUST_TYPE = ''MISC''),0) =0
		AND (SELECT CUST_TYPE FROM TBL_WO_DEBITOR_DETAIL WHERE ID_WO_NO = @WONO AND ID_WO_PREFIX=@WOPREFIX AND ID_JOB_ID=@JobID AND ID_JOB_DEB = @CUSTID)=''MISC''
			SET @OwnRiskAmt = 0

	RETURN @OwnRiskAmt 
END

/*          
          
print dbo.FETCHOWNRISKAMOUNT(''139'', ''FA'', 1, 1006)          
          
select * from tbl_inv_detail          
*/ 



' 
END

GO

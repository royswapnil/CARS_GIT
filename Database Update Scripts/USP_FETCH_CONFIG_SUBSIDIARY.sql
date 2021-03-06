/****** Object:  StoredProcedure [dbo].[USP_FETCH_CONFIG_SUBSIDIARY]    Script Date: 06/19/2015 11:41:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_CONFIG_SUBSIDIARY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_CONFIG_SUBSIDIARY]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_CONFIG_SUBSIDIARY]    Script Date: 06/19/2015 11:41:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_CONFIG_SUBSIDIARY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Praveen
-- Create date: <Create Date,,>
-- Description:	To fetch subsidiary details
-- =============================================
CREATE PROCEDURE [dbo].[USP_FETCH_CONFIG_SUBSIDIARY]  
@IV_ID_SUBSIDIARY INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT   
    ID_Subsidery,  
    SS_Name,  
    SS_Mgr_Name,  
    SS_Address1,  
    SS_Address2,  
    SS_ID_ZIPCODE as ID_ZIPCODE,   
    SS_Phone1,  
    SS_Phone2,  
    SS_Phone_Mobile,  
    SS_Fax,  
    ID_EMAIL_SUBSID,  
    SS_ORGANIZATIONNO,  
	SUB.CREATED_BY,  
    SUB.DT_CREATED,  
    SUB.MODIFIED_BY,  
    SUB.DT_MODIFIED,
	SS_SWIFT,
	SS_IBAN,
	SS_BANKACCOUNT, 
	TransferMethod, 
	AccountCode,
	CNTRY.[DESCRIPTION] as ''COUNTRY'',
	[STATE].[DESCRIPTION] as ''STATE'',
	ZIP_CITY as CITY     
 FROM   
    TBL_MAS_SUBSIDERY SUB LEFT OUTER JOIN  TBL_MAS_ZIPCODE ZIP ON ZIP.ZIP_ZIPCODE = SUB.SS_ID_ZIPCODE
    LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS CNTRY ON ZIP.ZIP_ID_COUNTRY=CNTRY.ID_PARAM
    LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS [STATE] ON ZIP.ZIP_ID_STATE = [STATE].ID_PARAM 
 WHERE   
    ID_Subsidery = @IV_ID_SUBSIDIARY
    
END
' 
END
GO

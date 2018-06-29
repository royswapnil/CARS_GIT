USE [CARSDEV]
GO

/****** Object:  StoredProcedure [dbo].[USP_SPR_FETCH_SUPPLIER_DETAILS]    Script Date: 12.01.2017 09.03.25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*************************************** Application: MSG *************************************************************
* Module	: Supplier Import
* File name	: USP_SPR_FETCH_SUPPLIER_LIST.PRC
* Purpose	: To fetch List of suppliers
* Author	: Venkatesh Prasad
* Date		: 03.01.2008
*********************************************************************************************************************/
/*********************************************************************************************************************  
I/P : -- Input Parameters
O/P :-- Output Parameters
Error Code
Description
INT.VerNO :  
********************************************************************************************************************/
--'*********************************************************************************'*********************************
--'* Modified History	:   
--'* S.No 	RFC No/Bug ID			Date	     		Author		Description	
--*#0001#
--'*********************************************************************************'*********************************

ALTER PROCEDURE [dbo].[USP_SPR_FETCH_SUPPLIER_DETAILS] 

@ID_SUPPLIER varchar(100)	= NULL
AS

BEGIN
SELECT [ID_SUPPLIER]
      ,[SUP_Name]
      ,[SUP_Contact_Name]
      ,[SUP_Address1]
      ,[SUP_Address2]
      ,[SUP_Zipcode]
      ,[SUP_ID_Email]
      ,[SUP_Phone_Off]
      ,[SUP_Phone_Res]
      ,[SUP_FAX]
      ,[SUP_Phone_Mobile]
      ,[CREATED_BY]
      ,[DT_CREATED]
      ,[MODIFIED_BY]
      ,[DT_MODIFIED]
      ,[SUP_SSN]
      ,[SUP_REGION]
      ,[SUP_BILLAddress1]
      ,[SUP_BILLAddress2]
      ,[SUP_BILLZipcode]
      ,[LEADTIME]
      ,[ORDER_FREQ]
      ,[ID_ORDERTYPE]
      ,[CLIENT_NO]
      ,[WARRANTY]
      ,[DESCRIPTION]
      ,[ORDERDAY_MON]
      ,[ORDERDAY_TUE]
      ,[ORDERDAY_WED]
      ,[ORDERDAY_THU]
      ,[ORDERDAY_FRI]
      ,[SUPP_CURRENTNO]
      ,[SUP_CITY]
      ,[SUP_COUNTRY]
      ,[SUP_BILL_CITY]
      ,[SUP_BILL_COUNTRY]
	  ,[FLG_SAME_ADDRESS]
  FROM [dbo].[TBL_MAS_SUPPLIER]
WHERE ID_SUPPLIER = @ID_SUPPLIER
END




GO


USE [CARSDEV]
GO

/****** Object:  StoredProcedure [dbo].[USP_FETCH_VEHICLE_FUELCODE]    Script Date: 11.03.2016 10:29:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/*************************************** Application: MSG *************************************************************
* Module	: VEHICLE ACCOUNTS
* File name	: USP_FETCH_VEHICLE_GROUPS.PRC
* Purpose	: TO FETCH THE GROUP DETAILS 
* Date		: 27.05.2009
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_FETCH_VEHICLE_FUELCODE]
@id as varchar(50)
AS
BEGIN
	BEGIN TRY
		SELECT SettingsCode, SettingDescription
		FROM TBL_MAS_VEHICLE_SETTINGS
		WHERE SettingsType = 'FuelCode' and (SettingsCode like @id+'%' or SettingDescription like @id+'%')
	END TRY
	BEGIN CATCH
		EXECUTE usp_GetErrorInfo;
	END CATCH

END



GO


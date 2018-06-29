USE [CARSDEV]
GO

/****** Object:  StoredProcedure [dbo].[USP_FETCH_VEHICLE_STATUS]    Script Date: 11.03.2016 10:28:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



    
/*************************************** Application: MSG *************************************************************    
* Module : ZipCode    
* File name : USP_FetchAll_Subsidiary.PRC    
* Purpose : To Fetch the Subsudiary.     
* Author :  Krishnaveni   
* Date  : 26.07.2006    
*********************************************************************************************************************/    
/*********************************************************************************************************************      
I/P : -- Input Parameters    
O/P :-- Output Parameters    
Error Code    
Description    
INT.VerNO : NOV21.0    
********************************************************************************************************************/    
--'*********************************************************************************'*********************************    
--'* Modified History :       
--'* S.No  RFC No/Bug ID   Date        Author  Description     
 --   1                   09-09-2015 Martin Omnes  Fetching vehicle data into vehicledetail page    
--*#0001#    
--'*********************************************************************************'*********************************    
CREATE Procedure [dbo].[USP_FETCH_VEHICLE_STATUS]  

as  
BEGIN  
	
	SELECT   
				SettingsCode as SettingsCode,
				SettingDescription as SettingDescription
		FROM   
				TBL_MAS_VEHICLE_SETTINGS 
		WHERE	SettingsType='Status'
		ORDER BY 
				SettingsCode
	
	END 




GO


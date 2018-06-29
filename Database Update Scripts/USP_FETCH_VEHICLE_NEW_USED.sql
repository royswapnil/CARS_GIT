USE [CARSDEV]
GO

/****** Object:  StoredProcedure [dbo].[USP_FETCH_VEHICLE_NEW_USED]    Script Date: 11.03.2016 10:27:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



    
/*************************************** Application: MSG *************************************************************    
* Module : ZipCode    
* File name : USP_FETCH_VEHICLE_NEW_USED.PRC    
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
CREATE Procedure [dbo].[USP_FETCH_VEHICLE_NEW_USED]

as  
--update TBL_MAS_VEHICLE_REFNO set refno_count+=1 where refno_code = 2
BEGIN  
	
	select refno_code, refno_description, refno_prefix, refno_year+refno_count as refno_count 
	from tbl_mas_vehicle_refno
		ORDER BY 
				refno_code
	
	END 




GO


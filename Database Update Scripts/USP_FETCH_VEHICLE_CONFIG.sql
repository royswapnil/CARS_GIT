/****** Object:  StoredProcedure [dbo].[USP_FETCH_VEHICLE_CONFIG]    Script Date: 04/04/2016 12:54:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_VEHICLE_CONFIG]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_VEHICLE_CONFIG]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_VEHICLE_CONFIG]    Script Date: 04/04/2016 12:54:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_VEHICLE_CONFIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
  
  
  
  
  
  
/*************************************** Application: MSG *************************************************************  
* Module : Master  
* File name : USP_FETCH_VEHICLE_CONFIG.PRC  
* Purpose : TO FETCH SERVICE CODE  
* Author : Jayakrishnan  
* Date  : 21.08.2006  
*********************************************************************************************************************/  
/*********************************************************************************************************************    
I/P : -- Input Parameters  
O/P : -- Output Parameters  
Error Code  
Description  
  
INT.VerNO : NOV21.0   
********************************************************************************************************************/  
--''*********************************************************************************''*********************************  
--''* Modified History :     
--''* S.No  RFC No/Bug ID   Date        Author  Description   
--*#0001#   
--''*********************************************************************************''*********************************  
  
CREATE PROCEDURE [dbo].[USP_FETCH_VEHICLE_CONFIG]  
(  
    @iv_ID_CONFIG           VARCHAR(10),  
    @iv_ID_CONFIG2          VARCHAR(10) = '''',  
    @iv_ID_CONFIG3          VARCHAR(10) = '''',  
    @iv_ID_CONFIG4          VARCHAR(10) = '''',  
    @iv_ID_CONFIG5          VARCHAR(10) = ''''  
)   
  
AS  
BEGIN  
 EXEC dbo.USP_CONFIG_Mas_Make_View --MAKE CODE      
 EXEC dbo.USP_CONFIG_SET_VIEWALL @iv_ID_CONFIG,@iv_ID_CONFIG2,'''','''',@iv_ID_CONFIG5 --GROUP AND LOCATION      
 EXEC USP_CONFIG_Make_Model_Fetchall --MAKE MODEL GROUP      
 EXEC USP_CONFIG_MAS_SC_FETCH  --MAKE SERVICE CODE      
 EXEC USP_MAKE_MODEL_SERVICE_FETCH --MAKE MODEL SERVICE CODE      
 EXEC USP_MAKE_MODEL_RP_FETCH --MODEL RP DESC      
 --EXEC USP_MODEL_GP_FETCH --MODEL GROUP 
 SELECT ID_SETTINGS As ID_MODEL, DESCRIPTION AS MODEL_DESC FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = ''MODEL''
     
 EXEC dbo.USP_CONFIG_SET_VIEWALL '''','''',@iv_ID_CONFIG3,@iv_ID_CONFIG4,@iv_ID_CONFIG5 --GROUP AND LOCATION      
 EXEC DBO.USP_CONFIG_VEHGRPPRICE  @iv_ID_CONFIG  
--Bug ID:-PKK with Vehicle Code
--date  :-08-Sept-2008
  SELECT IntervalName, StartInterval, ControlInterval FROM TBL_MAS_VEHICLEGROUP_INTERVAL
--change end
END  
  
/*  
exec USP_FETCH_VEHICLE_CONFIG ''VEH-GROUP'',''LOC'',''HP-MAKE-PC'',''HP-VHG-PC'',''''  
*/  
  
  

  
  
  
  
  
  
  
  
' 
END
GO

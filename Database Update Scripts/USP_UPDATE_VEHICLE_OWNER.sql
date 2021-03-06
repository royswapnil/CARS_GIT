/****** Object:  StoredProcedure [dbo].[USP_UPDATE_VEHICLE_OWNER]    Script Date: 9/13/2017 12:21:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_UPDATE_VEHICLE_OWNER]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_UPDATE_VEHICLE_OWNER]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_VEHICLE_OWNER]    Script Date: 9/13/2017 12:21:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_UPDATE_VEHICLE_OWNER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_UPDATE_VEHICLE_OWNER] AS' 
END
GO
ALTER PROCEDURE [dbo].[USP_UPDATE_VEHICLE_OWNER]    
(  
@ID_VEH_SEQ  INT,            
@ID_CUSTOMER_VEH    VARCHAR(20),  
@OV_RETVAL AS VARCHAR(20) OUTPUT  
)               
AS  
BEGIN 
	UPDATE TBL_MAS_VEHICLE  
	SET ID_CUSTOMER_VEH = @ID_CUSTOMER_VEH    
	WHERE ID_VEH_SEQ = @ID_VEH_SEQ  
   
    SET @OV_RETVAL = 'UPD'  

END
GO

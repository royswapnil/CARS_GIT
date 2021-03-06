/****** Object:  StoredProcedure [dbo].[USP_CHECK_VEHICLE]    Script Date: 10/5/2017 3:32:10 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CHECK_VEHICLE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CHECK_VEHICLE]
GO
/****** Object:  StoredProcedure [dbo].[USP_CHECK_VEHICLE]    Script Date: 10/5/2017 3:32:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CHECK_VEHICLE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_CHECK_VEHICLE] AS' 
END
GO
                        
/*************************************** Application: MSG *************************************************************                          
* Module : VEHICLE                         
* File name : USP_CHECK_VEHICLE                   
* Purpose : TO CHECK THE VEHICLE EXISTS    
* Author : SMITA M       
* Date  : 24 FEB 16                      
*********************************************************************************************************************/                          
ALTER PROCEDURE [dbo].[USP_CHECK_VEHICLE]    
(    
 @VehNo VARCHAR(30)    
     
)    
    
AS    
BEGIN    
      
   SELECT     
    *    
   FROM     
    TBL_MAS_VEHICLE    
       
   WHERE    
    (VEH_REG_NO = @VehNo) or (VEH_INTERN_NO =@VehNo) or (VEH_VIN =@VehNo) or (cast(id_veh_seq as varchar(30)) = @VehNo)    
    
       
    
    
    
END    
GO

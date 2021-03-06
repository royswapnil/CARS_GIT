/****** Object:  StoredProcedure [dbo].[USP_SPR_DISCOUNTCODE_MODIFY]    Script Date: 5/24/2017 2:38:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_DISCOUNTCODE_MODIFY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_MODIFY]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_DISCOUNTCODE_MODIFY]    Script Date: 5/24/2017 2:38:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_DISCOUNTCODE_MODIFY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_MODIFY] AS' 
END
GO
  
  
  
  
/*************************************** APPLICATION: MSG *************************************************************          
* MODULE : CONFIG          
* FILE NAME : <DBO.USP_SPR_DISCOUNTCODE_MODIFY>        
* PURPOSE : TO Modify THE DISCOUNT CODE       
* AUTHOR :  Maheshwaran s   
* DATE  : 22/10/2007         
*********************************************************************************************************************/          
/*********************************************************************************************************************            
I/P : -- @ID_MAKE VARCHAR(10),@DISCOUNTCODE,@DESCRIPTION          
O/P : -- @ISSUCCESS,@Errmsg     
@OV_RETVALUE - '      
         
ERROR CODE          
DESCRIPTION    
INT.VerNO : NOV21.0         
********************************************************************************************************************/          
--'*********************************************************************************'*********************************          
--'* MODIFIED HISTORY :             
--'* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION           
--* #0001#          
--'*********************************************************************************'*********************************          
ALTER PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_MODIFY]  
(@ID_MAKE VARCHAR(10),  
 @DISCOUNTCODE VARCHAR(20),  
 @DESCRIPTION VARCHAR(100),  
 @MODIFIED_BY VARCHAR(20),  
 @ISSUCCESS BIT OUTPUT,  
 @ERRMSG VARCHAR(200) OUTPUT)  
AS  
BEGIN  
 IF EXISTS(SELECT * FROM TBL_SPR_DISCOUNTCODE WHERE SUPP_CURRENTNO = @ID_MAKE AND DISCOUNTCODE = @DISCOUNTCODE)  
 BEGIN     
   BEGIN TRY       
     UPDATE TBL_SPR_DISCOUNTCODE  
     SET   
       DESCRIPTION = @DESCRIPTION,  
       MODIFIED_BY = @MODIFIED_BY,  
       DT_MODIFIED = GETDATE()  
     WHERE SUPP_CURRENTNO = @ID_MAKE  
      AND DISCOUNTCODE = @DISCOUNTCODE     
     SET @ISSUCCESS = 1  
     SET @ERRMSG = ''  
   END TRY   
   BEGIN CATCH  
    SET @ISSUCCESS = 0  
    SELECT @ERRMSG = ERROR_MESSAGE()  
  END CATCH   
 END  
 ELSE  
 BEGIN  
   SET @ISSUCCESS = 0  
   SELECT @ERRMSG = 'Record  Not Modified Succesfully.'  
 END    
END  
  
  
  
  
  
  
  

GO

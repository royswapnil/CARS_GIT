/****** Object:  StoredProcedure [dbo].[USP_SPR_DISCOUNTCODE_INSERT]    Script Date: 5/24/2017 2:37:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_DISCOUNTCODE_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_DISCOUNTCODE_INSERT]    Script Date: 5/24/2017 2:37:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_DISCOUNTCODE_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_INSERT] AS' 
END
GO
  
  
/*************************************** APPLICATION: MSG *************************************************************          
* MODULE : CONFIG          
* FILE NAME : <DBO.USP_SPR_DISCOUNTCODE_INSERT>        
* PURPOSE : TO ADD THE DISCOUNT CODE       
* AUTHOR :  Maheshwaran s       
* DATE  : 22/07/2007      
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
ALTER PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_INSERT]  
(@ID_MAKE VARCHAR(10),  
 @DISCOUNTCODE VARCHAR(20),  
 @DESCRIPTION VARCHAR(100),  
 @CREATED_BY VARCHAR(20),  
 @ISSUCCESS BIT OUTPUT,  
 @ERRMSG VARCHAR(200) OUTPUT)  
AS  
BEGIN  
 IF EXISTS(SELECT * FROM TBL_SPR_DISCOUNTCODE WHERE SUPP_CURRENTNO = @ID_MAKE AND DISCOUNTCODE = @DISCOUNTCODE)  
 BEGIN  
   set @ISSUCCESS = 0  
   set @ERRMSG = 'Record already exists for the combination of Make and DiscountCode.'    
 END  
 else  
 begin  
   BEGIN TRY  
     INSERT INTO   
      TBL_SPR_DISCOUNTCODE(SUPP_CURRENTNO,DISCOUNTCODE,DESCRIPTION,CREATED_BY,DT_CREATED)       
     VALUES(@ID_MAKE,@DISCOUNTCODE,@DESCRIPTION,@CREATED_BY,GETDATE())  
     SET @ISSUCCESS = 1  
     SET @ERRMSG = ''  
   END TRY   
   BEGIN CATCH  
    SET @ISSUCCESS = 0  
    SELECT @ERRMSG = ERROR_MESSAGE()  
   END CATCH  
 end  
END  
  
  
  
  
  
  

GO

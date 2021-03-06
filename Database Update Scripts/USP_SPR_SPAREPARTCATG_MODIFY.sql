/****** Object:  StoredProcedure [dbo].[USP_SPR_SPAREPARTCATG_MODIFY]    Script Date: 5/24/2017 2:41:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_SPAREPARTCATG_MODIFY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPR_SPAREPARTCATG_MODIFY]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_SPAREPARTCATG_MODIFY]    Script Date: 5/24/2017 2:41:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_SPAREPARTCATG_MODIFY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPR_SPAREPARTCATG_MODIFY] AS' 
END
GO
  
  
  
  
/*************************************** APPLICATION: MSG *************************************************************          
* MODULE : CONFIG          
* FILE NAME : <DBO.USP_SPR_SPRPARTCATG_MODIFY>        
* PURPOSE : TO Modify THE SPARE PART CATEGORY       
* AUTHOR :  Maheshwaran s   
* DATE  : 22/10/2007         
*********************************************************************************************************************/          
/*********************************************************************************************************************            
I/P : -- @ID_DISCOUNTCODEBUY,@ID_DISCOUNTCODESELL,@ID_SUPPLIER,@ID_MAKE,@CATEGORY,@DESCRIPTION  
@INITIALCLASSCODE,@VATCODE,@ACCOUNTCODE,@FLG_ALLOWBO,@FLG_COUNTSTOCK,@FLG_ALLOWCLASS          
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
ALTER PROCEDURE [dbo].[USP_SPR_SPAREPARTCATG_MODIFY]  
(  
 @ID_DISCOUNTCODEBUY INT,  
 @ID_DISCOUNTCODESELL INT,  
 @ID_SUPPLIER INT,  
 @ID_MAKE VARCHAR(10),  
 @CATEGORY VARCHAR(50),  
 @DESCRIPTION VARCHAR(100),  
 @INITIALCLASSCODE VARCHAR(50),  
 @VATCODE VARCHAR(100),  
 @ACCOUNTCODE VARCHAR(50),  
 @FLG_ALLOWBO BIT,  
 @FLG_COUNTSTOCK BIT,  
 @FLG_ALLOWCLASS BIT,  
 @MODIFIEDBY VARCHAR(20),  
 @ISSUCCESS BIT OUTPUT,  
 @ERRMSG VARCHAR(100) OUTPUT)  
AS  
BEGIN  
 IF EXISTS(SELECT * FROM TBL_MAS_ITEM_CATG WHERE SUPP_CURRENTNO = @ID_MAKE AND CATG_DESC = @CATEGORY)  
 BEGIN     
   BEGIN TRY       
     UPDATE TBL_MAS_ITEM_CATG  
     SET   
      ID_DISCOUNTCODEBUY =@ID_DISCOUNTCODEBUY,  
      ID_DISCOUNTCODESELL = @ID_DISCOUNTCODESELL,  
      ID_SUPPLIER = @ID_SUPPLIER,     
      DESCRIPTION = @DESCRIPTION,  
      INITIALCLASSCODE = @INITIALCLASSCODE,  
      VATCODE = @VATCODE,  
      ACCOUNTCODE = @ACCOUNTCODE,  
      FLG_ALLOWBO = @FLG_ALLOWBO,  
      FLG_COUNTSTOCK = @FLG_COUNTSTOCK,  
      FLG_ALLOWCLASS = @FLG_ALLOWCLASS,   
      MODIFIED_BY = @MODIFIEDBY,  
      DT_MODIFIED = GETDATE()        
     WHERE SUPP_CURRENTNO = @ID_MAKE  
      AND CATG_DESC = @CATEGORY     
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

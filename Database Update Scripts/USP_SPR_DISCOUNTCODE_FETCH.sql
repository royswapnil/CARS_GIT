/****** Object:  StoredProcedure [dbo].[USP_SPR_DISCOUNTCODE_FETCH]    Script Date: 5/24/2017 2:36:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_DISCOUNTCODE_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_SPR_DISCOUNTCODE_FETCH]    Script Date: 5/24/2017 2:36:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_SPR_DISCOUNTCODE_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_FETCH] AS' 
END
GO
/*************************************** APPLICATION: MSG *************************************************************            
* MODULE : CONFIG            
* FILE NAME : <DBO.USP_SPR_DISCOUNTCODE_FETCH>          
* PURPOSE : TO FETCH THE DISCOUNT CODE         
* AUTHOR :  Maheshwaran s         
* DATE  : 22/07/2007        
*********************************************************************************************************************/            
/*********************************************************************************************************************              
I/P : -- @ID_MAKE VARCHAR(10)    
O/P : --        
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
ALTER PROCEDURE [dbo].[USP_SPR_DISCOUNTCODE_FETCH](@ID_MAKE VARCHAR(10)= NULL)    
AS    
BEGIN    
 IF(@ID_MAKE IS NOT NULL)      
 BEGIN    
  SELECT     
   DC.ID_DISCOUNTCODE,    
   DC.ID_MAKE,    
   MK.ID_MAKE_NAME,    
   DC.DISCOUNTCODE,    
   DC.DESCRIPTION,  
   DC.SUPP_CURRENTNO,  
   MS.SUP_Name    
  FROM TBL_SPR_DISCOUNTCODE DC    
  left outer join TBL_MAS_MAKE MK on DC.ID_MAKE = MK.ID_MAKE    
  left outer join tbl_mas_supplier MS on MS.SUPP_CURRENTNO = DC.SUPP_CURRENTNO    
     WHERE DC.SUPP_CURRENTNO = @ID_MAKE    
  ORDER BY DC.ID_DISCOUNTCODE    
    END    
 ELSE IF(@ID_MAKE IS NULL)    
 BEGIN    
  SELECT     
   DC.ID_DISCOUNTCODE,    
   DC.ID_MAKE,    
   MK.ID_MAKE_NAME,    
   DC.DISCOUNTCODE,    
   DC.DESCRIPTION,  
   DC.SUPP_CURRENTNO,  
   MS.SUP_Name  
  FROM TBL_SPR_DISCOUNTCODE DC    
  left outer join TBL_MAS_MAKE MK on DC.ID_MAKE = MK.ID_MAKE    
  left outer join tbl_mas_supplier MS on MS.SUPP_CURRENTNO = DC.SUPP_CURRENTNO    
  ORDER BY DC.ID_DISCOUNTCODE    
 END       
END

GO

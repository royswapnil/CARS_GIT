/****** Object:  StoredProcedure [dbo].[USP_REP_Upd_DeliveryNotePrevPrinted]    Script Date: 9/13/2017 12:07:57 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_Upd_DeliveryNotePrevPrinted]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_REP_Upd_DeliveryNotePrevPrinted]
GO
/****** Object:  StoredProcedure [dbo].[USP_REP_Upd_DeliveryNotePrevPrinted]    Script Date: 9/13/2017 12:07:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_REP_Upd_DeliveryNotePrevPrinted]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_REP_Upd_DeliveryNotePrevPrinted] AS' 
END
GO
  
-- ===================================================================================================          
-- Author:  Vishalakshi          
-- Create date: 30-Sep-2008      
-- Description: This procedure is used to Update Delivery Note Prev Printed Value     
-- ===================================================================================================          
      
ALTER PROCEDURE [dbo].[USP_REP_Upd_DeliveryNotePrevPrinted]           
 @ID_WO_NO VARCHAR(10) =1020,      
 @ID_WO_PREFIX VARCHAR(5)='WO',    
  @ID_WO_JOBNO varchar(5)    
AS          
BEGIN        
     
 UPDATE       
  TBL_WO_JOB_DETAIL     
 SET DELIVERYNOTE_PREV_PRINTED = 1      
 FROM TBL_WO_JOB_DETAIL JOBDET INNER JOIN TBL_WO_DETAIL DET  
 ON JOBDET.ID_WO_NO=DET.ID_WO_NO AND JOBDET.ID_WO_PREFIX=DET.ID_WO_PREFIX --AND DET.ID_JOB=@ID_WO_JOBNO  
 AND JOBDET.ID_WODET_SEQ_JOB=DET.ID_WODET_SEQ  
 WHERE JOBDET.ID_WO_NO=@ID_WO_NO AND JOBDET.ID_WO_PREFIX=@ID_WO_PREFIX   
 --AND JOBI_DELIVER_QTY >0     
 
 
 
END          
       
      
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
      
    
      
      
      
    
    
    
GO

/****** Object:  StoredProcedure [dbo].[USP_DEL_SPARE_TEXTLINE]    Script Date: 11/30/2016 11:49:13 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_DEL_SPARE_TEXTLINE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_DEL_SPARE_TEXTLINE]
GO
/****** Object:  StoredProcedure [dbo].[USP_DEL_SPARE_TEXTLINE]    Script Date: 11/30/2016 11:49:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_DEL_SPARE_TEXTLINE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_DEL_SPARE_TEXTLINE] AS' 
END
GO
ALTER  PROC [dbo].[USP_DEL_SPARE_TEXTLINE]                   
(         
      
 @Id_Wo_No varchar(20) ,   
 @Id_Wo_Pr varchar(20) ,  
 @Id_WoItem_Seq varchar(20) ,  
 @OV_RETVALUE VARCHAR(10)OUTPUT           
)                  
AS                    
BEGIN 

DELETE FROM TBL_WO_JOB_DETAIL WHERE ID_WO_NO = @Id_Wo_No and ID_WO_PREFIX = @Id_Wo_Pr and ID_WOITEM_SEQ = @Id_WoItem_Seq
IF @@ERROR = 0                
 BEGIN         
   SET @OV_RETVALUE = 'SUCCESS'        
 END       
ELSE      
 BEGIN      
   SET @OV_RETVALUE = 'ERROR'        
 END 

END
GO

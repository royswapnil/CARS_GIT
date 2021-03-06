/****** Object:  StoredProcedure [dbo].[USP_FETCH_JOBDET]    Script Date: 1/17/2018 4:21:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_JOBDET]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_JOBDET]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_JOBDET]    Script Date: 1/17/2018 4:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_JOBDET]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_JOBDET] AS' 
END
GO
ALTER PROCEDURE [dbo].[USP_FETCH_JOBDET]                      
(                          
 @WONO  VARCHAR(30)                            
)                      
AS                      
BEGIN      

DECLARE @DEFAULT_USER VARCHAR(50)
  SELECT TOP 1 @DEFAULT_USER = ID_Login From tbl_mas_users where FLG_DUSER =1
                
   SELECT CONVERT(VARCHAR(10),WD.ID_JOB) + '-' + CONVERT(VARCHAR(10),WLD.SL_NO)AS JOBLINENO , 
   --WLD.WO_LABOUR_DESC,
    CASE WHEN WLD.ID_LOGIN = @DEFAULT_USER THEN
     WLD.WO_LABOUR_DESC
     ELSE
     WLD.ID_LOGIN + ' - ' + WLD.WO_LABOUR_DESC
    END AS 'WO_LABOUR_DESC',
   WLD.ID_WOLAB_SEQ    
   FROM TBL_WO_DETAIL WD  
  INNER JOIN TBL_WO_LABOUR_DETAIL  WLD  
  ON WD.ID_WODET_SEQ = WLD.ID_WODET_SEQ  
  WHERE ID_WO_PREFIX+ ID_WO_NO = @WONO  
     
END   
GO

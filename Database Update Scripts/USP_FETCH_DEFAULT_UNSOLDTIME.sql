/****** Object:  StoredProcedure [dbo].[USP_FETCH_DEFAULT_UNSOLDTIME]    Script Date: 2/2/2018 2:37:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_DEFAULT_UNSOLDTIME]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_FETCH_DEFAULT_UNSOLDTIME]
GO
/****** Object:  StoredProcedure [dbo].[USP_FETCH_DEFAULT_UNSOLDTIME]    Script Date: 2/2/2018 2:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_FETCH_DEFAULT_UNSOLDTIME]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_FETCH_DEFAULT_UNSOLDTIME] AS' 
END
GO
ALTER PROCEDURE [dbo].[USP_FETCH_DEFAULT_UNSOLDTIME]        
(        
 @DESC VARCHAR(20)        
)        
AS        
BEGIN        
        
    
SELECT  CAST ([ID_SETTINGS] AS INT) AS ID_SETTINGS,id_config      
      ,[DESCRIPTION],TR_PER,CREATED_BY,DT_CREATED,MODIFIED_BY,DT_MODIFIED,FLAG               
  FROM [dbo].[TBL_MAS_SETTINGS]          
  WHERE  ID_CONFIG ='TR-REASCD' and FLAG=1  
  ORDER BY Description          
      
END 
GO

/****** Object:  StoredProcedure [dbo].[USP_MECHANIC_SEARCH]    Script Date: 1/24/2018 5:36:16 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_MECHANIC_SEARCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_MECHANIC_SEARCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_MECHANIC_SEARCH]    Script Date: 1/24/2018 5:36:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_MECHANIC_SEARCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_MECHANIC_SEARCH] AS' 
END
GO
ALTER PROCEDURE [dbo].[USP_MECHANIC_SEARCH]                      
(                          
 @ID_SEARCH   VARCHAR(10)                            
)                      
AS                      
BEGIN                      
                  
IF LEN(@ID_SEARCH)>=2                  
BEGIN                  
 SELECT     
  ID_LOGIN + '-'+ FIRST_NAME LOGIN_NAME,    
  ID_LOGIN,     
  FIRST_NAME,  
  ID_Subsidery_User,     
  ID_Dept_User          
   FROM     
  TBL_MAS_USERS             
 WHERE                      
    First_Name like '%'+@ID_SEARCH+'%' OR ID_LOGIN like '%'+@ID_SEARCH+'%'           
                  
                  
END                     
END 
GO

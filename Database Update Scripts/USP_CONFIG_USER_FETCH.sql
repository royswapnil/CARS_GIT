/****** Object:  StoredProcedure [dbo].[USP_CONFIG_USER_FETCH]    Script Date: 10/19/2016 6:58:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_USER_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_USER_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_USER_FETCH]    Script Date: 10/19/2016 6:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_USER_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_CONFIG_USER_FETCH] AS' 
END
GO
  
  
  
  
  
/*************************************** Application: GMS *************************************************************          
* Module :Configuration  
* File name : [USP_CONFIG_USER_FETCH].PRC          
* Purpose : To Fetch User details.  
* Author :  Krishnaveni         
* Date  :   
*********************************************************************************************************************/          
/*********************************************************************************************************************            
I/P : -- Input Parameters          
O/P :-- Output Parameters          
Error Code          
Description  INT.VerNO : NOV21.0        
          
********************************************************************************************************************/          
--'*********************************************************************************'*********************************          
--'* Modified History :             
--'* S.No  RFC No/Bug ID   Date        Author  Description           
--*#0001#          
--'*********************************************************************************'*********************************          
  
  
ALTER PROCEDURE [dbo].[USP_CONFIG_USER_FETCH]  
(  
 @IV_ID_Login varchar(20)  
)  
AS  
BEGIN  
Declare @IDR  VARCHAR(20)     
  
 SELECT ID_Login,  
   First_Name,  
   Last_Name,  
   ID_ROLE_User,  
   Password,  
   ID_Subsidery_User,  
   ID_Dept_User,  
   Address1,  
   Address2,  
   ID_Lang_User,  
   ID_ZIP_User,  
   ID_Email,  
   Phone,  
   MobileNo,  
   FaxNo,  
   Flg_Mechanic,   
   US_USERID,  
   USR.CREATED_BY,  
   USR.DT_CREATED,  
   USR.MODIFIED_BY,  
   USR.DT_MODIFIED,  
   ISNULL(FLG_MECH_INACTIVE,0) AS FLG_MECH_INACTIVE,  
   ISNULL(FLG_USE_IDLETIME,0) AS FLG_USE_IDLETIME,  
   COMMON_MECHANIC_ID,  
   SOCIAL_SECURITY_NUM,  
   WORKHOURS_FROM,  
   WORKHOURS_TO,   
   ISNULL(FLG_WORKHOURS,0) as FLG_WORKHOURS, 
   ISNULL(FLG_DUSER,0) as FLG_DUSER, 
   ISNULL(ID_EMAIL_ACCT,0) AS ID_EMAIL_ACCT,  
   CNTRY.[DESCRIPTION] AS 'COUNTRY',  
   [STATE].[DESCRIPTION] AS 'STATE',  
   ZIP_CITY as CITY     
     
 FROM TBL_MAS_USERS USR  
 LEFT OUTER JOIN  TBL_MAS_ZIPCODE ZIP ON ZIP.ZIP_ZIPCODE = USR.ID_ZIP_User   
    LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS CNTRY ON ZIP.ZIP_ID_COUNTRY=CNTRY.ID_PARAM  
    LEFT OUTER JOIN TBL_MAS_CONFIG_DETAILS [STATE] ON ZIP.ZIP_ID_STATE = [STATE].ID_PARAM   
 WHERE  
   ID_LOGIN =@IV_ID_Login  
  
SELECT  @IDR=ID_ROLE_User  FROM TBL_MAS_USERS where  ID_LOGIN=@IV_ID_Login     
select ID_ROLE,    
FLG_SYSADMIN,    
FLG_SUBSIDADMIN,    
FLG_DEPTADMIN    
from TBL_MAS_ROLE    
where ID_ROLE = @IDR    
END  
  
/*  
EXEC USP_CONFIG_USER_FETCH 'admin'  
sp_help tbl_mas_users  
*/  
  
  
  
  
  
  
GO

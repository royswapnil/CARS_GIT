/****** Object:  StoredProcedure [dbo].[USP_CONFIG_USERS_UPDATE]    Script Date: 10/19/2016 7:33:41 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_USERS_UPDATE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_USERS_UPDATE]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_USERS_UPDATE]    Script Date: 10/19/2016 7:33:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_USERS_UPDATE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_CONFIG_USERS_UPDATE] AS' 
END
GO
  
  
  
  
/*************************************** Application: MSG *************************************************************    
* Module : Vehicle  
* File name : USP_CONFIG_USERS_UPDATE .prc    
* Purpose :   
* Author : Krishnaveni   
* Date  : 27.10.2006  
NT.VerNO : NOV21.0  
*********************************************************************************************************************/    
/*********************************************************************************************************************      
I/P : -- Input Parameters    
O/P : -- Output Parameters    
Error Code    
Description    
NT.VerNO : NOV21.0  
********************************************************************************************************************/    
--'*********************************************************************************'*********************************    
--'* Modified History :       
--'* S.No  RFC No/Bug ID   Date        Author  Description     
--*#0001#     
--'*********************************************************************************'*********************************    
  
  
  
  
ALTER PROCEDURE [dbo].[USP_CONFIG_USERS_UPDATE]  
(  
 @IV_ID_Login   varchar(20),  
 @IV_First_Name   varchar(20),  
 @IV_Last_Name   varchar(20),  
 @II_ID_ROLE_User  int,  
 @IV_Password   varchar(100),  
 @II_ID_Subsidery_User int,  
 @II_ID_Dept_User  int,  
 @IV_Address1   varchar(50) ,  
 @IV_Address2   varchar(50),  
 @II_ID_Lang_User  int,  
 --@II_ID_ZIP_User   int,  
 @II_ID_ZIP_User   VARCHAR(50),  
 @IV_ID_Email   varchar(60),  
 @IV_Phone    varchar(20),  
 @IV_CREATED_BY   varchar(20),  
 @IV_Mobileno   Varchar(20),  
 @IV_FaxNo    varchar(20),  
 @IB_Flg_Mechanic  Bit,  
 @IV_USERID              varchar(20),  
 -- **************************************************************  
  -- Modified Date : 06th June 2008  
  -- Bug ID   : SS30  
 @IV_CUSTPCOUNTRY        VARCHAR(20),  
 @IV_CUSTPCITY           VARCHAR(20),  
 @IV_CUSTSTATE           VARCHAR(20),  
 @OV_RETVAL    varchar(20) output,  
 @FLG_MECH_INACTIVE  BIT,  
 @FLG_CONFIGZIPCODE  BIT,  
   
 --***************************************************************  
 --Modified Date : 05th Jan 2010  
 --Bug ID  : IDLE Time  
 @IV_FLG_USE_IDLETIME BIT,  
 @IV_COMMON_MECHANIC_ID VARCHAR(50),   
 @IV_ISCOMMON_MECHANIC BIT,   
   
 -- ************** End Of Modification *****************************  
  @IV_SOCIAL_SECURITY_NUM VARCHAR(15),  
  @IV_WORKHRS_FRM VARCHAR(6),  
  @IV_WORKHRS_TO VARCHAR(6),  
  @IV_FLG_WORKHRS BIT,
  @IV_FLG_DUSER BIT,  
  --778  
  @IV_ID_EMAIL_ACCT INT  
   
)  
AS  
BEGIN  
 DECLARE @COUNT int  
 DECLARE @COUNT1 int  
 DECLARE @COMMON_MECH_ID VARCHAR(50)  
  
 SET @COUNT =0  
 SELECT @COUNT = Count(*) from TBL_MAS_USERS where ID_Login = @IV_ID_Login  
 IF @II_ID_LANG_USER =0     
 BEGIN              
    SET @II_ID_LANG_USER=NULL              
 END    
   
 --IDLE TIME CHANGES .Duplication of Common Mechanic Id  
   
 SELECT @COMMON_MECH_ID = COMMON_MECHANIC_ID  FROM TBL_MAS_USERS where ID_Login = @IV_ID_Login  
 AND ID_Dept_User = @II_ID_Dept_User AND COMMON_MECHANIC_ID = @IV_COMMON_MECHANIC_ID  
   
  IF @COUNT >0    
  BEGIN  
   IF @IV_COMMON_MECHANIC_ID IS NOT NULL  
   BEGIN  
    SELECT @COUNT1 = Count(*) FROM TBL_MAS_USERS WHERE ID_Dept_User = @II_ID_DEPT_USER and COMMON_MECHANIC_ID = @IV_COMMON_MECHANIC_ID AND ID_Login <> @IV_ID_Login  
    IF @COUNT1 > 0   
    BEGIN      
     SET @OV_RETVAL = 'CMID' --Common Mechanic Id    
     RETURN      
    END  
   END  
  END  
  
  IF @COUNT >0  
  BEGIN  
  IF @IV_COMMON_MECHANIC_ID IS NOT NULL  
   BEGIN  
    IF @IV_ISCOMMON_MECHANIC = 0  
    BEGIN  
     SELECT @COUNT1 = Count(*) FROM TBL_MAS_USERS WHERE COMMON_MECHANIC_ID = @IV_COMMON_MECHANIC_ID AND ID_Login <> @IV_ID_Login  
     IF @COUNT1 > 0   
      BEGIN      
       SET @OV_RETVAL = 'CMID_Y_Dept' --Common Mechanic Id across other departments    
       RETURN      
      END  
     ELSE  
      BEGIN  
       IF @COMMON_MECH_ID IS NULL    
        BEGIN  
         SET @OV_RETVAL = 'CMID_N_Dept' --No Common Mechanic Id    
         RETURN           END  
      END  
    END  
   END  
  END    
    
    
    
  
   
 -- **************************************************************  
   -- Modified Date : 06th June 2008  
   -- Bug ID   : SS30  
 DECLARE @OV_ZIPID VARCHAR(10) /*Changed to handle varchar zip code*/  
 DECLARE @TranName VARCHAR(20);    
  
 BEGIN TRANSACTION @TranName             
  IF @II_ID_ZIP_User is not null AND @FLG_CONFIGZIPCODE = 1           
  BEGIN            
   EXEC [DBO].[USP_CONFIG_ZIPCODE_RETRIVE]                
   @II_ID_ZIP_User,@IV_CUSTPCOUNTRY,@IV_CUSTSTATE,@IV_CUSTPCITY,@IV_USERID,@OV_RETVAL  OUTPUT,@OV_ZIPID  OUTPUT          
   SET @OV_RETVAL=0                
   --IF @OV_ZIPID > 0   /*Changed to handle varchar zip code*/             
   --SET @II_ID_ZIP_User = @OV_ZIPID                
   IF @@ERROR <> 0    
   BEGIN              
    SET @OV_RETVAL = @@ERROR                
    ROLLBACK TRANSACTION @TranName              
   END                                                 
       END     
  -- ********** End Of Modification *************************************         
      
  --IF @II_ID_ZIP_USER = 0 *Changed to handle varchar zip code*  
  IF @II_ID_ZIP_USER ='' OR @II_ID_ZIP_USER ='0'      
  BEGIN              
   SET @II_ID_ZIP_USER=NULL              
  END    
  
  IF @II_ID_Dept_User =0       
  BEGIN                
   SET @II_ID_Dept_User=NULL                
  END        
  
  IF @COUNT >0   
  BEGIN  
  
   UPDATE TBL_MAS_USERS set    First_Name   =@IV_First_Name  
           ,Last_Name   =@IV_Last_Name  
           ,ID_ROLE_User  =@II_ID_ROLE_User  
           ,Password   =@IV_Password  
           ,ID_Subsidery_User =@II_ID_Subsidery_User  
           ,ID_Dept_User  =@II_ID_Dept_User  
           ,Address1   =@IV_Address1  
           ,Address2   =@IV_Address2  
           ,ID_Lang_User  =@II_ID_Lang_User  
           ,ID_ZIP_User   =@II_ID_ZIP_User  
           ,ID_Email   =@IV_ID_Email  
           ,Phone    =@IV_Phone  
           ,Mobileno   =@IV_Mobileno  
           ,FaxNo    =@IV_FaxNo  
           ,Flg_Mechanic  =@IB_Flg_Mechanic  
         ,US_USERID   =@IV_USERID   
           ,MODIFIED_BY   =@IV_CREATED_BY  
           ,DT_MODIFIED   =getdate()  
           ,FLG_MECH_INACTIVE =@FLG_MECH_INACTIVE  
           ,FLG_USE_IDLETIME    =@IV_FLG_USE_IDLETIME  
           ,COMMON_MECHANIC_ID  =@IV_COMMON_MECHANIC_ID  
           ,SOCIAL_SECURITY_NUM =@IV_SOCIAL_SECURITY_NUM  
           ,WORKHOURS_FROM  =@IV_WORKHRS_FRM  
           ,WORKHOURS_TO  =@IV_WORKHRS_TO  
           ,FLG_WORKHOURS  =ISNULL(@IV_FLG_WORKHRS,0) 
           ,FLG_DUSER =  ISNULL(@IV_FLG_DUSER,0)
           ,ID_EMAIL_ACCT       = ISNULL(@IV_ID_EMAIL_ACCT,0)  
   WHERE ID_Login = @IV_ID_Login  
  
       
      IF @@ERROR <> 0      
   BEGIN    
     SET @OV_RETVAL =  @@ERROR        
   END    
   ELSE    
   BEGIN       
    SET @OV_RETVAL = 'UPDFLG'   
    COMMIT TRANSACTION @TranName    
   END   
  END    
 ELSE  
 BEGIN  
     
      IF @@ERROR <> 0      
   BEGIN    
     SET @OV_RETVAL =  @@ERROR         
   END    
   ELSE    
   BEGIN         
    SET @OV_RETVAL = 'UPDERR'      
   END   
    
 END  
--print @OV_RETVAL  
END  
  
  
--+  
/*  
EXEC USP_CONFIG_USERS_UPDATE 'Login',  
'gg',  
'LNAME',  
1,  
'Pas',  
1,  
1,  
'Add1',  
'ddr2',  
1,  
11,  
'Email',  
'111',  
'User','435','34',1,''  
  
exec USP_ParameterCreation 'USP_CONFIG_USERS_INSERT'   
  
select * from TBL_MAS_USERS  
*/  
  
  
  
  
  
  
  
  
GO

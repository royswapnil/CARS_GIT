/****** Object:  StoredProcedure [dbo].[USP_CONFIG_USERS_INSERT]    Script Date: 10/19/2016 7:34:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_USERS_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_USERS_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_USERS_INSERT]    Script Date: 10/19/2016 7:34:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_USERS_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_CONFIG_USERS_INSERT] AS' 
END
GO
  
/*************************************** APPLICATION: MSG *************************************************************    
* MODULE : VEHICLE   
* FILE NAME : USP_CONFIG_USERS_INSERT .PRC    
* PURPOSE :   
* AUTHOR : KRISHNAVENI  
* DATE  : 27.10.2006  
*********************************************************************************************************************/    
/*********************************************************************************************************************      
I/P : -- INPUT PARAMETERS    
O/P : -- OUTPUT PARAMETERS    
ERROR CODE    
DESCRIPTION    
NT.VERNO : NOV21.0  
********************************************************************************************************************/    
--'*********************************************************************************'*********************************    
--'* MODIFIED HISTORY :       
--'* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION     
--*#0001#     
--'*********************************************************************************'*********************************    
  
ALTER PROCEDURE [dbo].[USP_CONFIG_USERS_INSERT]  
(  
 @IV_ID_LOGIN   VARCHAR(20),  
 @IV_FIRST_NAME   VARCHAR(20),  
 @IV_LAST_NAME   VARCHAR(20),  
 @II_ID_ROLE_USER  INT,  
 @IV_PASSWORD   VARCHAR(100),  
 @II_ID_SUBSIDERY_USER INT,  
 @II_ID_DEPT_USER  INT,  
 @IV_ADDRESS1   VARCHAR(50) ,  
 @IV_ADDRESS2   VARCHAR(50),  
 @II_ID_LANG_USER  INT,  
 --@II_ID_ZIP_USER   INT,  
 @II_ID_ZIP_USER   VARCHAR(50),  
 @IV_ID_EMAIL   VARCHAR(60),  
 @IV_PHONE    VARCHAR(20),  
 @IV_CREATED_BY   VARCHAR(20),  
 @IV_MOBILENO   VARCHAR(20),  
 @IV_FAXNO    VARCHAR(20),  
 @IB_FLG_MECHANIC  BIT,  
 @IV_USERID              VARCHAR(20),  
 -- **************************************************************  
  -- Modified Date : 06th June 2008  
  -- Bug ID   : SS30  
 @IV_CUSTPCOUNTRY        VARCHAR(20),  
 @IV_CUSTPCITY           VARCHAR(20),  
 @IV_CUSTSTATE           VARCHAR(20),  
 @OV_RETVAL    VARCHAR(20) OUTPUT,  
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
  DECLARE @COUNT INT      
  DECLARE @COUNT1 INT      
  SET @COUNT =0      
  SELECT   
   @COUNT = COUNT(*)   
  FROM   
   TBL_MAS_USERS WHERE ID_LOGIN = @IV_ID_LOGIN      
  SET @COUNT1 =0      
  SELECT  
   @COUNT1 = COUNT(*)   
  FROM   
   TBL_MAS_USERS   
  WHERE US_USERID = @IV_USERID      
  SET @OV_RETVAL = 'INSFLG'        
  
  IF @II_ID_LANG_USER =0     
  BEGIN              
   SET @II_ID_LANG_USER=NULL              
  END    
  
  IF @II_ID_SUBSIDERY_USER =0     
  BEGIN              
   SET @II_ID_SUBSIDERY_USER=NULL              
  END    
  IF @II_ID_DEPT_USER =0     
  BEGIN              
   SET @II_ID_DEPT_USER=NULL              
  END    
  
  -- **************************************************************  
    -- Modified Date : 06th June 2008  
    -- Bug ID   : SS30  
  DECLARE @OV_ZIPID VARCHAR(10) /*Changed to handle varchar zipcode*/  
  DECLARE @TranName VARCHAR(20);    
  
  IF @COUNT > 0       
  BEGIN      
   SET @OV_RETVAL = 'PUID'        
  END    
   
  IF @COUNT1 > 0       
  BEGIN      
   SET @OV_RETVAL = 'PLOGINIED'  
   RETURN        
  END      
    
  --IDLE TIME CHANGES .Duplication of Common Mechanic Id  
  IF @COUNT =0  AND  @COUNT1=0  
  BEGIN  
   IF @IV_COMMON_MECHANIC_ID IS NOT NULL  
   BEGIN  
    SELECT @COUNT = Count(*) FROM TBL_MAS_USERS WHERE ID_Dept_User = @II_ID_DEPT_USER and COMMON_MECHANIC_ID = @IV_COMMON_MECHANIC_ID  
    IF @COUNT > 0   
    BEGIN      
     SET @OV_RETVAL = 'CMID' --Common Mechanic Id    
     RETURN      
    END  
   END  
  END  
  
  IF @COUNT =0  AND  @COUNT1=0  
  BEGIN  
   IF @IV_COMMON_MECHANIC_ID IS NOT NULL  
   BEGIN  
    IF @IV_ISCOMMON_MECHANIC = 0  
    BEGIN  
     SELECT @COUNT = Count(*) FROM TBL_MAS_USERS WHERE COMMON_MECHANIC_ID = @IV_COMMON_MECHANIC_ID  
     IF @COUNT > 0   
      BEGIN      
       SET @OV_RETVAL = 'CMID_Y_Dept' --Common Mechanic Id across other departments    
       RETURN      
      END  
     ELSE  
      BEGIN  
       SET @OV_RETVAL = 'CMID_N_Dept' --No Common Mechanic Id    
       RETURN   
      END  
    END  
   END  
  END    
    
   
  BEGIN TRANSACTION @TranName             
   IF @II_ID_ZIP_USER is not null AND @FLG_CONFIGZIPCODE = 1             
   BEGIN            
    EXEC [DBO].[USP_CONFIG_ZIPCODE_RETRIVE]                
    @II_ID_ZIP_User,@IV_CUSTPCOUNTRY,@IV_CUSTSTATE,@IV_CUSTPCITY,@IV_USERID,@OV_RETVAL  OUTPUT,@OV_ZIPID  OUTPUT          
    SET @OV_RETVAL=0                
    --IF @OV_ZIPID > 0              /*Changed to handle varchar zipcode*/  
    --SET @II_ID_ZIP_User = @OV_ZIPID                
    IF @@ERROR <> 0    
    BEGIN              
     SET @OV_RETVAL = @@ERROR                
     ROLLBACK TRANSACTION @TranName              
    END                                    
     END     
   -- ********** End Of Modification *************************************         
  
  --IF @II_ID_ZIP_USER =0   /*Changed to handle varchar zipcode*/  
  IF @II_ID_ZIP_USER ='' OR @II_ID_ZIP_USER ='0'  
  BEGIN              
   SET @II_ID_ZIP_USER=NULL              
  END    
   PRINT @II_ID_LANG_USER    
  -- ***************************************************  
  -- Modified Date : 18th June 2008  
  -- Bug ID   : 2930  
  -- Description   : Commented these line and put it above  
--  IF @COUNT > 0       
--  BEGIN      
--   SET @OV_RETVAL = 'PUID'        
--  END    
--   
--  IF @COUNT1 > 0       
--  BEGIN      
--   SET @OV_RETVAL = 'PLOGINIED'  
--   RETURN        
--  END      
  -- *************** End Of Modification ***************  
  
    
  IF @COUNT =0  AND  @COUNT1=0      
  BEGIN      
  INSERT INTO TBL_MAS_USERS(      
   ID_LOGIN      
   ,FIRST_NAME      
   ,LAST_NAME      
   ,ID_ROLE_USER      
   ,PASSWORD      
   ,ID_SUBSIDERY_USER      
   ,ID_DEPT_USER      
   ,ADDRESS1      
   ,ADDRESS2      
   ,ID_LANG_USER      
   ,ID_ZIP_USER      
   ,ID_EMAIL      
   ,PHONE      
   ,MOBILENO      
   ,FAXNO      
   ,FLG_MECHANIC      
   ,US_USERID      
   ,CREATED_BY      
   ,DT_CREATED   
   ,FLG_MECH_INACTIVE  
   ,FLG_USE_IDLETIME  
   ,COMMON_MECHANIC_ID  
   ,SOCIAL_SECURITY_NUM  
   ,WORKHOURS_FROM  
   ,WORKHOURS_TO  
   ,FLG_WORKHOURS 
   ,FLG_DUSER 
   ,ID_EMAIL_ACCT    
  )      
  VALUES      
   (@IV_ID_LOGIN,      
   @IV_FIRST_NAME,      
   @IV_LAST_NAME,      
   @II_ID_ROLE_USER,      
   @IV_PASSWORD,      
   @II_ID_SUBSIDERY_USER,      
   @II_ID_DEPT_USER,      
   @IV_ADDRESS1,      
   @IV_ADDRESS2,      
   @II_ID_LANG_USER,      
   @II_ID_ZIP_USER ,      
   @IV_ID_EMAIL,      
   @IV_PHONE,      
   @IV_MOBILENO,      
   @IV_FAXNO,      
   @IB_FLG_MECHANIC,      
   @IV_USERID ,      
   @IV_CREATED_BY,      
   GETDATE(),  
   @FLG_MECH_INACTIVE,  
   @IV_FLG_USE_IDLETIME,  
   @IV_COMMON_MECHANIC_ID,  
   @IV_SOCIAL_SECURITY_NUM,  
   @IV_WORKHRS_FRM,  
   @IV_WORKHRS_TO,  
   ISNULL(@IV_FLG_WORKHRS,0), 
   ISNULL(@IV_FLG_DUSER,0), 
   ISNULL(@IV_ID_EMAIL_ACCT,0)  
   )      
  
  
  --   SET @OV_RETVAL=NULL         
  --SET @OV_RETVAL = 'INSFLG'        
  IF @@ERROR <> 0          
  BEGIN        
   SET @OV_RETVAL =  @@ERROR     
  END   
  ELSE  
  BEGIN  
   COMMIT TRANSACTION @TranName      
  END  
  --   ELSE        
  --   BEGIN       
  --      
  --    SET @OV_RETVAL = 'INSFLG'        
  --    IF @COUNT <>0      
  --    SET @OV_RETVAL = 'UPDERR'          
  --      
  --    IF @COUNT1 <>0      
  --     SET @OV_RETVAL = 'INSFLG1'         
  --   END   
end  
--Bug ID:-2930  
--date  :-20-aug-2008  
     else  
begin  
IF @@ERROR <> 0          
  BEGIN        
   SET @OV_RETVAL =  @@ERROR     
  END   
  ELSE  
  BEGIN  
   SET @OV_RETVAL = 'UPDERR'    
   COMMIT TRANSACTION @TranName      
  END  
end  
--change end        
  
  PRINT @OV_RETVAL      
  
         
  
  END      
  
--+  
/*  
DECLARE @OUT VARCHAR(20)  
EXEC USP_CONFIG_USERS_INSERT 'DH2',  
'DH',  
'DH',  
94,  
'DH',  
1,  
200,  
'ADD1',  
'DDR2',  
4,  
12,  
'EMAIL',  
'111',  
'DH','343','3453',0,'DH2','india','','',@OUT  
PRINT @OUT  
  
EXEC USP_PARAMETERCREATION 'USP_CONFIG_USERS_INSERT'   
  
SELECT ID_LOGIN,US_USERID  FROM TBL_MAS_USERS  
*/  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
GO

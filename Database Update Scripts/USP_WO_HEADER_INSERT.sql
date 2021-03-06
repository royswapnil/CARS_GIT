/****** Object:  StoredProcedure [dbo].[USP_WO_HEADER_INSERT]    Script Date: 03/18/2016 13:14:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_HEADER_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_HEADER_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_HEADER_INSERT]    Script Date: 03/18/2016 13:14:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_HEADER_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*************************************** Application: MSG *************************************************************      
* Module : Transactions      
* File name : usp_WO_HEADER_INSERT.PRC      
* Purpose : To Load Work Order Job Information.       
* Author : M.Thiyagarajan.      
* Date  : 31.07.2006      
*********************************************************************************************************************/        
--''*********************************************************************************''*********************************      
--''* Modified History :         
--''* S.No  RFC No/Bug ID   Date        Author  Description       
--*#0001#      
-- Bug ID:- MSG_Issues_Analysis_01Apr09_ZSL07Apr09 17 Desc:- Passing Parameter of Vehicle ID, after Inserting new Vehicle ID
-- Bug ID :- 53  Desc:- Vehicle Mileage,Hours should update only when changed
-- Date  :- 08-Apr-2009
 		--Bug ID:-3540  
		--Date  :-20-Aug-2008  
		--Desc  :- It should insert all time even if u not change Mileage.  
		--  IF @REG_MIL <> @ID_WO_VEH_MILEAGE    
		--  BEGIN    
		--change end       
  --Bug ID:-3479  
		--Date  :-18-Aug-2008  
		--Desc   :- Substring part commented, gives problem when digits part increase 

--Bug ID :- 4960, date :- 23-July-2009
--bUG id:-5061,date :- 25-July-2009
--''*********************************************************************************''*********************************      

      
CREATE PROCEDURE [dbo].[USP_WO_HEADER_INSERT]       
(            
 @IV_CREATED_BY    VARCHAR(20) ,            
 @ID_DT_DELIVERY    VARCHAR(30) ,            
 @ID_DT_FINISH    VARCHAR(30) ,            
 @ID_DT_ORDER    VARCHAR(30) ,            
 @IV_ID_CUST_WO    VARCHAR(10) ,            
 @IV_CUST_GROUP_ID     VARCHAR(10) ,            
 @IV_ID_PAY_TERMS_WO      VARCHAR(10) ,            
 @IV_ID_PAY_TYPE_WO       VARCHAR(10) ,            
 @IV_ID_VEH_SEQ_WO   INT   ,            
 @IV_ID_WO_NO    VARCHAR(10) ,            
 @II_ID_ZIPCODE_WO     VARCHAR(50)   ,            
 @IV_WO_ANNOT    VARCHAR(200),            
 @IV_WO_CUST_NAME   VARCHAR(100) ,            
 @IV_WO_CUST_PERM_ADD1    VARCHAR(50) ,            
 @IV_WO_CUST_PERM_ADD2    VARCHAR(50) ,            
 @IV_WO_CUST_PHONE_HOME      VARCHAR(20) ,            
 @IV_WO_CUST_PHONE_MOBILE    VARCHAR(20) ,            
 @IV_WO_CUST_PHONE_OFF       VARCHAR(20) ,            
 @IV_WO_STATUS    VARCHAR(20) ,            
 @IV_WO_TM_DELIV    VARCHAR(10) ,            
 @IV_WO_TYPE_WOH    VARCHAR(20) ,            
 @ID_WO_VEH_HRS    DECIMAL(9,2)  ,            
 @ID_WO_VEH_INTERN_NO        VARCHAR(15) ,            
 @ID_WO_VEH_MILEAGE          INT   ,            
 @IV_WO_VEH_REG_NO   VARCHAR(15) ,            
 @IV_WO_VEH_VIN    VARCHAR(20) ,            
 @II_WO_VEH_MODEL   VARCHAR(10) ,            
 @IV_WO_VEH_MAKE    VARCHAR(10) ,            
 @IV_CUSTPCOUNTRY   VARCHAR(50) ,            
 @IV_CUSTPSTATE    VARCHAR(50) , 
 @IV_PKKDate       VARCHAR(50),    
-- MODIFIED DATE: 11 SEP 2008
-- COMMENTS: BUSPEK - CONTROL NO
 @BUS_PEK_PREVIOUS_NUM VARCHAR(10) = NULL,
 @BUS_PEK_CONTROL_NUM VARCHAR(20),
-- END OF MODIFICATION

 @0V_RETVALUE       VARCHAR(10)   OUTPUT ,            
 @0V_RETWONO        VARCHAR(30)   OUTPUT ,
 @UPDATE_VEH_FLAG	BIT    ,
 @FLG_CONFIGZIPCODE	BIT,
 @IV_DEPT_ACCNT_NUM VARCHAR(50),
 @VA_COST_PRICE decimal(13,2),
 @VA_SELL_PRICE decimal(13,2),
 @VA_NUMBER VARCHAR(20),
 @REGN_DATE VARCHAR(30),
 @VEH_TYPE VARCHAR(30),
 @VEH_GRP_DESC VARCHAR(10),
 @FLG_UPD_MILEAGE BIT,
 @IV_INT_NOTE   VARCHAR(200)      
)         /* IF A NEW PARAMETER IS ADDED THEN PLEASE ADD IT FROM JOB DETAILS INSERT AND UPDATE STORED PROCEDURES*/    
AS            
	BEGIN          

		DECLARE @CNT INT                    
		DECLARE @IVDT_ORD VARCHAR(20)                    
		DECLARE @GEN_TYPE VARCHAR(2)                    
		DECLARE @IV_ID_PRICE_CD VARCHAR(10)                    
		DECLARE @IV_ID_WO_PREFIX VARCHAR(5)                    
		DECLARE @OV_ZIPID VARCHAR(10)   /*Changed to handle varchar zipcode*/                        
		DECLARE @TRANNAME VARCHAR(20)                    
		DECLARE @IV_CUSTPCITY VARCHAR(50)   
		SET @IV_CUSTPCITY = @IV_CUSTPSTATE         
		DECLARE @CUSTENDNO as BIGINT                    

		SET @0V_RETVALUE = 0                    
		DECLARE @ID_WO_VEH_INTERN_NO1     VARCHAR(15)             
		DECLARE @IV_WO_VEH_VIN1   VARCHAR(20)                  
		DECLARE @IV_WO_VEH_REG_NO1  VARCHAR(15)         
		DECLARE @IV_ID_VEH_SEQ_WO1  INT        
		DECLARE @II_WO_VEH_MODEL1   VARCHAR(10)        
		SET  @ID_WO_VEH_INTERN_NO1 = REPLACE(@ID_WO_VEH_INTERN_NO,''%'','''')        
		SET  @IV_WO_VEH_REG_NO1  = REPLACE(@IV_WO_VEH_REG_NO,''%'','''')          
		SET  @IV_WO_VEH_VIN1  = REPLACE(@IV_WO_VEH_VIN,''%'','''')        
		SET  @IV_ID_VEH_SEQ_WO1  = @IV_ID_VEH_SEQ_WO        
		SET  @II_WO_VEH_MODEL1  = @II_WO_VEH_MODEL 
       
		IF REPLACE(@ID_WO_VEH_INTERN_NO,''%'','''') = '''' AND REPLACE(@IV_WO_VEH_REG_NO,''%'','''') ='''' AND REPLACE(@IV_WO_VEH_VIN,''%'','''') =''''        
		BEGIN        
			SET @ID_WO_VEH_INTERN_NO1 = NULL        
			SET @IV_WO_VEH_REG_NO1  = NULL        
			SET @IV_WO_VEH_VIN1   = NULL        
			SET @IV_ID_VEH_SEQ_WO1  = NULL        
			SET @II_WO_VEH_MODEL1  = NULL        
		END

		-- MODIFIED DATE: 11 SEP 2008
		-- COMMENTS: BUSPEK - CONTROL NO
		IF @BUS_PEK_PREVIOUS_NUM = ''''
		BEGIN
			SET @BUS_PEK_PREVIOUS_NUM = NULL
		END  

		IF @BUS_PEK_CONTROL_NUM = ''''
		BEGIN
			SET @BUS_PEK_CONTROL_NUM = NULL
		END   
		-- END OF MODIFICATION

		BEGIN TRY  
		-- Begin Tran                       
		SELECT @TRANNAME = ''WOInsTrans''                      
		-- Check whether zip exist for the addresss and return the new zipcode                     
		BEGIN TRANSACTION @TRANNAME                      
		DECLARE @DEPID INT                    
		DECLARE @SUBID INT                   
		DECLARE @CHKPR INT  --Check work order prefix exist in the workorder                

		SELECT  @DEPID = ID_DEPT_USER,                  
		@SUBID = ID_SUBSIDERY_USER                     
		FROM    TBL_MAS_USERS                    
		WHERE   ID_LOGIN = @IV_CREATED_BY             
		   
		IF @II_ID_ZIPCODE_WO IS NOT NULL AND @FLG_CONFIGZIPCODE = 1                          
		BEGIN      
				EXEC DBO.USP_CONFIG_ZIPCODE_RETRIVE @II_ID_ZIPCODE_WO, @IV_CUSTPCOUNTRY, '''',     
				@IV_CUSTPCITY, @IV_CREATED_BY, @0V_RETVALUE OUTPUT, @OV_ZIPID  OUTPUT                       
				SET  @0V_RETVALUE=0                        
			--IF @OV_ZIPID > 0        /*Changed to handle varchar zipcode*/                  
				--SET @II_ID_ZIPCODE_WO = @OV_ZIPID                        
			IF @@ERROR <> 0                         
				BEGIN       
					SET @0V_RETVALUE = @@ERROR                       
					ROLLBACK TRANSACTION @TRANNAME                      
				END                        
		END       


		     
		SELECT @CNT=COUNT(ID_CUSTOMER) FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = @IV_ID_CUST_WO       
		BEGIN                     
		IF @IV_ID_CUST_WO = 0  AND   @CNT=0                
		BEGIN                    
			SET @GEN_TYPE =''A''                    
			SELECT @IV_ID_CUST_WO =ISNULL(MAX(CAST(ID_CUSTOMER AS INT))+ 1,(    
			SELECT CUST_START_NO FROM TBL_MAS_CUST_CONFIG       
			WHERE  GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO))       
			FROM  TBL_MAS_CUSTOMER       
			WHERE ISNULL(CUST_GEN_TYPE,''A'') =''A''   AND  CREATED_BY <> ''DataMigrationTool'' 
			---------------------------------------------------------            
			-- Modified By  : shilpa S Chandrashekhar    
			-- Modified Date : 09th April 2008            
			-- Bug No   : 890      
			---------------------------------------------------------    
			WHILE (select COUNT(ID_CUSTOMER) FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = @IV_ID_CUST_WO)>0
             BEGIN 
				SET @IV_ID_CUST_WO = @IV_ID_CUST_WO + 1;
            END   
			SELECT @CUSTENDNO =(SELECT TOP 1 CUST_END_NO                           
			FROM TBL_MAS_CUST_CONFIG WHERE GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                        
			ORDER BY ID_CUST_CONFIG DESC)   

			
			IF @IV_ID_CUST_WO > @CUSTENDNO    
			BEGIN        
				   
				SET @0V_RETVALUE = ''INSIDEXT''      
				ROLLBACK TRANSACTION @TRANNAME      
				return            
			END        
			-- ----------------End Of MOdification ---------------------------                   
			IF @@ERROR <> 0                         
			BEGIN                      
				SET @0V_RETVALUE = @@ERROR                        
				ROLLBACK TRANSACTION @TRANNAME                      
			END                        
		END                    
		ELSE                    
			SET @GEN_TYPE =''U''    
		                 
		END     
                
		IF @CNT = 0                     
		BEGIN                    
			-- Pay Details for Customer based on customer group                    
			SELECT @IV_ID_PAY_TYPE_WO = ID_PAY_TYPE ,       
			@IV_ID_PAY_TERMS_WO = ID_PAY_TERM  ,                    
			@IV_ID_PRICE_CD = ID_PRICE_CD                                
			FROM    TBL_MAS_CUST_GROUP                    
			WHERE   ID_CUST_GRP_SEQ = @IV_CUST_GROUP_ID    
			   
	
			----------Insert Customer If not Exist----------------                     
			INSERT INTO TBL_MAS_CUSTOMER                    
			(                    
				ID_CUSTOMER  ,                    
				CUST_NAME  ,                    
				CUST_GEN_TYPE ,                    
				ID_CUST_GROUP ,                    
				CUST_PHONE_OFF ,                    
				CUST_PHONE_HOME  ,                    
				CUST_PHONE_MOBILE,                    
				CUST_PERM_ADD1 ,                    
				CUST_PERM_ADD2 ,                    
				ID_CUST_PERM_ZIPCODE,                    
				CREATED_BY   ,                    
				DT_CREATED   ,                    
				ID_CUST_PAY_TYPE ,                     
				ID_CUST_PAY_TERM ,                    
				ID_CUST_PC_CODE  ,          
				CUST_CREDIT_LIMIT,    
				FLG_CUST_INACTIVE                  
			)       
			VALUES                    
			(                    
				@IV_ID_CUST_WO  ,                    
				@IV_WO_CUST_NAME  ,                    
				@GEN_TYPE   ,                    
				@IV_CUST_GROUP_ID ,                    
				@IV_WO_CUST_PHONE_OFF ,                         
				@IV_WO_CUST_PHONE_HOME  ,                        
				@IV_WO_CUST_PHONE_MOBILE ,                    
				@IV_WO_CUST_PERM_ADD1  ,                    
				@IV_WO_CUST_PERM_ADD2  ,                    
				@II_ID_ZIPCODE_WO   ,                    
				@IV_CREATED_BY    ,                    
				GETDATE()     ,                    
				@IV_ID_PAY_TYPE_WO   ,                    
				@IV_ID_PAY_TERMS_WO   ,                    
				@IV_ID_PRICE_CD    ,          
				0,    
				''FALSE''                
			)  
                  
			SET @0V_RETVALUE = 0                     
			IF @@ERROR <> 0                       
			BEGIN                      
				SET @0V_RETVALUE = @@ERROR                        
				ROLLBACK TRANSACTION @TRANNAME                      
			END                        
		END                    
		-- ELSE                    
		UPDATE TBL_MAS_CUSTOMER SET CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME                       
		WHERE CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME AND  ID_CUSTOMER = @IV_ID_CUST_WO              

		UPDATE TBL_MAS_CUSTOMER SET CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME                       
		WHERE CUST_PHONE_OFF = @IV_WO_CUST_PHONE_OFF AND  ID_CUSTOMER = @IV_ID_CUST_WO                    

		UPDATE TBL_MAS_CUSTOMER SET CUST_PHONE_HOME = @IV_WO_CUST_PHONE_HOME                       
		WHERE CUST_PHONE_MOBILE = @IV_WO_CUST_PHONE_MOBILE AND  ID_CUSTOMER = @IV_ID_CUST_WO      
		         
		---------Inserting Vehicle Information-----------------------                    
		BEGIN            
		DECLARE @COUNT INT,@II_ID_VEH_OWNER INT                
		DECLARE @IV_ID_MODEL_GRP VARCHAR(20)   
        DECLARE @COUNT1 INT    

		SET @COUNT =0         

		IF  REPLACE(@ID_WO_VEH_INTERN_NO,''%'','''') = '''' AND REPLACE(@IV_WO_VEH_REG_NO,''%'','''') = '''' AND REPLACE(@IV_WO_VEH_VIN,''%'','''')  = ''''                  
			SET @COUNT =  2     
		  

		SELECT @COUNT1 = COUNT(*) FROM TBL_MAS_VEHICLE
		WHERE	VEH_REG_NO= @IV_WO_VEH_REG_NO		OR
				VEH_INTERN_NO= @ID_WO_VEH_INTERN_NO	OR
				VEH_VIN=@IV_WO_VEH_VIN

		IF @COUNT1 <> 0  AND @IV_ID_VEH_SEQ_WO=0 
			BEGIN      
				SET @0V_RETVALUE = ''DUPVEH''      
				ROLLBACK TRANSACTION @TRANNAME      
				RETURN            
			END   
        
        select 444555
        
		IF @COUNT1 = 0  AND @COUNT <> 2      
		BEGIN  
			SELECT  @IV_ID_MODEL_GRP = @II_WO_VEH_MODEL
			--MG_ID_MODEL_GRP                  
			--FROM TBL_MAS_MODELGROUP_MAKE_MAP                  
			--WHERE   MG_ID_MAKE  =  @IV_WO_VEH_MAKE    
			
			DECLARE @VA_ACC_CODE VARCHAR(10)
			DECLARE @USE_VA_ACC_CODE VARCHAR(3)
			DECLARE @VEH_GRP AS INT
		   SELECT @VEH_GRP = ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = ''VEH-GROUP'' 
		   AND DESCRIPTION = @VEH_GRP_DESC			
		/*ADDED THE CHECK TO UPDATE VA ACC CODE VEHICLE FOR ANY ORDERS BASED ON CONFIG SETTINGS*/	
		  SELECT @USE_VA_ACC_CODE =ISNULL(USE_VA_ACC_CODE,0) ,@VA_ACC_CODE =  ISNULL(VA_ACC_CODE,'''') FROM TBL_MAS_WO_CONFIGURATION WHERE ID_DEPT_WO = @DEPID AND ID_SUBSIDERY_WO = @SUBID AND MODIFIED_BY =@IV_CREATED_BY            
		  IF @USE_VA_ACC_CODE = ''1''
		   BEGIN
			INSERT INTO TBL_MAS_VEHICLE                    
			(                     
				VEH_REG_NO   ,                    
				VEH_INTERN_NO  ,                        
				VEH_VIN    ,                    
				ID_MAKE_VEH   ,                    
				ID_MODEL_VEH  ,                    
				VEH_MILEAGE   ,                    
				VEH_HRS    ,                    
				ID_CUSTOMER_VEH  ,                   
				DT_VEH_ERGN,                              
				DT_VEH_MIL_REGN,                                      
				DT_VEH_HRS_ERGN,                  
				VEH_FLG_SERVICE_PLAN,                        
				VEH_FLG_ADDON,                     
				CERATED_BY   ,                    
				DT_CREATED,
				VA_ACC_CODE,
				VEH_TYPE,
				ID_GROUP_VEH                        
			)                    
			VALUES                    
			(                    
				REPLACE(@IV_WO_VEH_REG_NO,''%'','''') ,                    
				REPLACE(@ID_WO_VEH_INTERN_NO,''%'','''') ,                    
				REPLACE(@IV_WO_VEH_VIN,''%'','''')  ,                    
				@IV_WO_VEH_MAKE  ,                    
				--@IV_ID_MODEL_GRP  ,              
				@II_WO_VEH_MODEL   ,                    
				@ID_WO_VEH_MILEAGE   ,                    
				@ID_WO_VEH_HRS  ,              
				@IV_ID_CUST_WO  ,                   
				@REGN_DATE,  
				--MODIFIED BY: ASHOK S
				--DATE: 16 APR 09
				--COMMENTS: DATE HAS TO BE POPULATED, WHEN HOURS AND MILEAGE ARE GIVEN                
				CASE WHEN @ID_WO_VEH_MILEAGE = 0 OR LTRIM(RTRIM(@ID_WO_VEH_MILEAGE)) = ''''
					THEN ''''
				ELSE GETDATE() END,                  
				CASE WHEN @ID_WO_VEH_HRS = 0 OR LTRIM(RTRIM(@ID_WO_VEH_HRS)) = ''''
					THEN ''''
				ELSE GETDATE() END,                  
				--END OF MODIFICATION
				0,                  
				0,                  
				@IV_CREATED_BY  ,      
				GETDATE(),
				@VA_ACC_CODE,
				@VEH_TYPE,
				@VEH_GRP                                   
			) 
	    END 
	    ELSE
	     BEGIN
	      INSERT INTO TBL_MAS_VEHICLE                    
			(                     
				VEH_REG_NO   ,                    
				VEH_INTERN_NO  ,                        
				VEH_VIN    ,                    
				ID_MAKE_VEH   ,                    
				ID_MODEL_VEH  ,                    
				VEH_MILEAGE   ,                    
				VEH_HRS    ,                    
				ID_CUSTOMER_VEH  ,                   
				DT_VEH_ERGN,                              
				DT_VEH_MIL_REGN,                                      
				DT_VEH_HRS_ERGN,                  
				VEH_FLG_SERVICE_PLAN,                        
				VEH_FLG_ADDON,                     
				CERATED_BY   ,                    
				DT_CREATED ,
				VEH_TYPE ,
				ID_GROUP_VEH                      
			)                    
			VALUES                    
			(                    
				REPLACE(@IV_WO_VEH_REG_NO,''%'','''') ,                    
				REPLACE(@ID_WO_VEH_INTERN_NO,''%'','''') ,                    
				REPLACE(@IV_WO_VEH_VIN,''%'','''')  ,                    
				@IV_WO_VEH_MAKE  ,                    
				--@IV_ID_MODEL_GRP  ,              
				@II_WO_VEH_MODEL   ,                    
				@ID_WO_VEH_MILEAGE   ,                    
				@ID_WO_VEH_HRS  ,              
				@IV_ID_CUST_WO  ,                   
				@REGN_DATE, 
				--MODIFIED BY: ASHOK S
				--DATE: 16 APR 09
				--COMMENTS: DATE HAS TO BE POPULATED, WHEN HOURS AND MILEAGE ARE GIVEN                
				CASE WHEN @ID_WO_VEH_MILEAGE = 0 OR LTRIM(RTRIM(@ID_WO_VEH_MILEAGE)) = ''''
					THEN ''''
				ELSE GETDATE() END,                  
				CASE WHEN @ID_WO_VEH_HRS = 0 OR LTRIM(RTRIM(@ID_WO_VEH_HRS)) = ''''
					THEN ''''
				ELSE GETDATE() END,                  
				--END OF MODIFICATION
				0,                  
				0,                  
				@IV_CREATED_BY  ,      
				GETDATE(),
				@VEH_TYPE ,
				@VEH_GRP                                  
			) 
	     END  
			--  END  
			
			select ''tryyyyy''     
			SELECT  @IV_ID_VEH_SEQ_WO1 = ID_VEH_SEQ                                
			FROM    TBL_MAS_VEHICLE                                 
			WHERE   VEH_REG_NO = REPLACE(@IV_WO_VEH_REG_NO,''%'','''')      
			AND  VEH_INTERN_NO = REPLACE(@ID_WO_VEH_INTERN_NO,''%'','''')     
			AND    VEH_VIN = REPLACE(@IV_WO_VEH_VIN,''%'','''')                                            

			EXEC USP_MAS_VEHICLE_OWNERHISTORY_INSERT  @IV_ID_VEH_SEQ_WO1, @IV_WO_VEH_REG_NO1, '''',     
			@IV_ID_CUST_WO, NULL, @IV_CREATED_BY,NULL 
		END     

		DECLARE @REG_MIL_DATE1 AS VARCHAR(30)        
		DECLARE @REG_HRS_DATE1 AS VARCHAR(30)        
		DECLARE @OV_RETVALUE_HIST AS  VARCHAR(10)        

		SELECT @REG_MIL_DATE1 = DT_VEH_MIL_REGN,                                        
		@REG_HRS_DATE1 = DT_VEH_HRS_ERGN          
		FROM    TBL_MAS_VEHICLE        
		WHERE   ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1      

		DECLARE @REG_MIL AS INT        
		DECLARE @REG_HRS AS DECIMAL(13,2)  
		DECLARE @VEH_MAKE AS VARCHAR(10)
		DECLARE @VEH_MODEL AS VARCHAR(10)  
		SELECT @REG_MIL = VEH_MILEAGE, @REG_HRS =  VEH_HRS,
		   @VEH_MAKE = ID_MAKE_VEH, @VEH_MODEL = ID_MODEL_VEH     
		FROM    TBL_MAS_VEHICLE        
		WHERE   ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1         


		SET  @REG_HRS_DATE1 = GETDATE()    

		SET  @ID_WO_VEH_MILEAGE = @ID_WO_VEH_MILEAGE    
		SET  @REG_MIL_DATE1 = GETDATE()    

		IF @IV_ID_VEH_SEQ_WO1 IS NOT NULL
		BEGIN 
			EXEC USP_MAS_VEH_MILEG_HIST_INSERT @IV_ID_VEH_SEQ_WO1, @ID_WO_VEH_MILEAGE, @REG_MIL_DATE1,     
			@REG_HRS, @REG_HRS_DATE1, @IV_CREATED_BY,@OV_RETVALUE_HIST OUTPUT      
		END

		SET  @REG_HRS_DATE1 = GETDATE()    
		EXEC USP_MAS_VEH_MILEG_HIST_UPDATE @IV_ID_VEH_SEQ_WO1, @ID_WO_VEH_MILEAGE, @REG_HRS_DATE1,     
		@ID_WO_VEH_HRS, @REG_HRS_DATE1, @IV_CREATED_BY,@OV_RETVALUE_HIST OUTPUT      

		-- Updating the mileage in vehicle.     
		IF @UPDATE_VEH_FLAG = 1 
		BEGIN    
			IF @REG_MIL <> @ID_WO_VEH_MILEAGE
			BEGIN
				UPDATE TBL_MAS_VEHICLE     
					SET  VEH_MILEAGE = @ID_WO_VEH_MILEAGE,     
					VEH_HRS  = @ID_WO_VEH_HRS,    
					DT_VEH_MIL_REGN  = GETDATE()    
					WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1    
			END
			
			IF @REG_HRS <> @ID_WO_VEH_HRS
			BEGIN
				UPDATE TBL_MAS_VEHICLE     
					SET  VEH_MILEAGE = @ID_WO_VEH_MILEAGE,     
					VEH_HRS  = @ID_WO_VEH_HRS,    
					DT_VEH_HRS_ERGN  = GETDATE()    
					WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1 
			END
		END
		-- Modified Date : 23rd Feb 2010
		-- Description :  Vehicle Make and Model should save in
						-- vehicle details table if changed
		IF @VEH_MAKE <> @iv_WO_VEH_Make
		BEGIN
			UPDATE TBL_MAS_VEHICLE     
			SET  ID_MAKE_VEH = @iv_WO_VEH_Make
			WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1 
		END
		
		DECLARE @VEH_MAKEMODEL AS VARCHAR(10)
		SELECT @VEH_MAKEMODEL = @II_WO_VEH_MODEL
		--MG_ID_MODEL_GRP FROM TBL_MAS_MODELGROUP_MAKE_MAP 
		--WHERE ID_MG_SEQ = @ii_WO_VEH_Model
		
		IF @VEH_MAKEMODEL <> @VEH_MODEL
		BEGIN 
			UPDATE TBL_MAS_VEHICLE     
			SET  ID_MODEL_VEH = @VEH_MAKEMODEL
			WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1 
		END
	-- End OF Modification ***********************
		IF @UPDATE_VEH_FLAG = 1 
		BEGIN  
			UPDATE TBL_MAS_VEHICLE     
			SET  VEH_MILEAGE = @ID_WO_VEH_MILEAGE,     
			VEH_HRS  = @ID_WO_VEH_HRS  
			WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1
		END
		
		UPDATE TBL_MAS_VEHICLE     
		SET ID_MAKE_VEH =	@IV_WO_VEH_MAKE ,          
			ID_MODEL_VEH =   @II_WO_VEH_MODEL   		
		WHERE ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1       


		IF @@ERROR <> 0                                          
		BEGIN                     
			SET @0V_RETVALUE = @@ERROR                        
			ROLLBACK TRANSACTION @TRANNAME                      
			END                        
                         
		END            
		             
		----------Selecting the Prefix---------------------                    
		SELECT  @IV_ID_WO_PREFIX = WO_PREFIX                   
		FROM    TBL_MAS_WO_CONFIGURATION                    
		WHERE   GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO                   
		AND  ID_SUBSIDERY_WO = @SUBID                 
		AND  ID_DEPT_WO = @DEPID                    
		   
		SELECT  @IV_ID_WO_NO =       
		CASE WHEN WO_CUR_SERIES IS NOT NULL  AND  LEN(WO_CUR_SERIES) > 0 
		THEN                    
		  
			(SELECT 
			CAST((MAX(WO_CUR_SERIES) + 1) AS VARCHAR)       
			FROM TBL_MAS_WO_CONFIGURATION       
			WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                   
			AND ID_SUBSIDERY_WO = @SUBID                   
			AND ID_DEPT_WO = @DEPID                    
			GROUP BY WO_CUR_SERIES)      
		ELSE                    
		
			(SELECT  
				CAST((MAX(WO_SERIES) + 1) AS VARCHAR)      
			FROM  TBL_MAS_WO_CONFIGURATION                     
			WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO )                   
			AND ID_SUBSIDERY_WO = @SUBID                   
			AND ID_DEPT_WO = @DEPID                    
			GROUP BY WO_SERIES)                    
		END      
		FROM  TBL_MAS_WO_CONFIGURATION                   
		WHERE (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                     
		AND ID_SUBSIDERY_WO = @SUBID       
		AND ID_DEPT_WO = @DEPID                    
		
		----Check work order prefix exist in the workorder                
		SELECT @CHKPR=ISNULL(COUNT(WO_PREFIX),0)                 
		FROM   TBL_MAS_WO_CONFIGURATION                
		WHERE  (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                     
		AND    ID_SUBSIDERY_WO = @SUBID     
		AND ID_DEPT_WO = @DEPID     

select ''test''
		       
		IF @CHKPR < 1                         
		BEGIN                      
			SET @0V_RETVALUE = ''CRPR''     --Create work order prefix                
			ROLLBACK TRANSACTION @TranName                   
		END                
		ELSE                
			-----------Insert Into Work Order Header------------                 
		BEGIN      

			INSERT INTO TBL_WO_HEADER                    
			(                    
				ID_WO_NO   ,                    
				ID_WO_PREFIX  ,                    
				DT_ORDER   ,                    
				WO_CUST_GROUPID  ,                    
				WO_TYPE_WOH  ,                    
				WO_STATUS  ,                    
				DT_DELIVERY  ,                     
				WO_TM_DELIV  ,                    
				DT_FINISH  ,                    
				ID_PAY_TYPE_WO   ,                    
				ID_PAY_TERMS_WO  ,                    
				WO_ANNOT   ,                    
				ID_CUST_WO  ,                    
				WO_CUST_NAME  ,                    
				WO_CUST_PERM_ADD1,                    
				WO_CUST_PERM_ADD2,                    
				ID_ZIPCODE_WO ,                    
				WO_CUST_PHONE_OFF ,                    
				WO_CUST_PHONE_HOME,                    
				WO_CUST_PHONE_MOBILE,                    
				ID_VEH_SEQ_WO   ,                    
				WO_VEH_REG_NO   ,                    
				WO_VEH_INTERN_NO  ,                    
				WO_VEH_VIN    ,                    
				WO_VEH_MILEAGE   ,                    
				WO_VEH_HRS    ,                    
				WO_VEH_MAK_MOD_MAP  ,                    
				CREATED_BY    ,                    
				DT_CREATED    ,                    
				ID_DEPT     ,                    
				ID_SUBSIDERY ,
				WO_PKKDATE,   
				BUS_PEK_PREVIOUS_NUM,
				BUS_PEK_CONTROL_NUM,
				LA_DEPT_ACCOUNT_NO,
				VA_COST_PRICE,  
				VA_SELL_PRICE,
				VA_NUMBER,
				INT_NOTE 				
			)                    
			VALUES                  
			(                    
				@IV_ID_WO_NO      ,                    
				@IV_ID_WO_PREFIX     ,                    
				@ID_DT_ORDER      ,                    
				@IV_CUST_GROUP_ID     ,                    
				@IV_WO_TYPE_WOH      ,                    
				@IV_WO_STATUS      ,                    
				DBO.FN_DATEFORMAT(@ID_DT_DELIVERY)  ,                    
				@IV_WO_TM_DELIV      ,                    
				DBO.FN_DATEFORMAT(@ID_DT_FINISH)    ,                    
				@IV_ID_PAY_TYPE_WO     ,                    
				@IV_ID_PAY_TERMS_WO     ,                    
				@IV_WO_ANNOT      ,                    
				@IV_ID_CUST_WO      ,                    
				@IV_WO_CUST_NAME     ,                    
				@IV_WO_CUST_PERM_ADD1    ,                    
				@IV_WO_CUST_PERM_ADD2    ,                    
				@II_ID_ZIPCODE_WO     ,                    
				@IV_WO_CUST_PHONE_OFF    ,           
				@IV_WO_CUST_PHONE_HOME    ,                    
				@IV_WO_CUST_PHONE_MOBILE   ,                    
				@IV_ID_VEH_SEQ_WO1     ,                    
				@IV_WO_VEH_REG_NO1     ,                    
				@ID_WO_VEH_INTERN_NO1    ,                    
				@IV_WO_VEH_VIN1      ,         
				@ID_WO_VEH_MILEAGE     ,                    
				@ID_WO_VEH_HRS      ,                    
				@II_WO_VEH_MODEL1     ,                    
				@IV_CREATED_BY      ,                    
				GETDATE()       ,                    
				@DEPID        ,                    
				@SUBID  ,
				@IV_PKKDate,         
				@BUS_PEK_PREVIOUS_NUM,
				@BUS_PEK_CONTROL_NUM,
				@IV_DEPT_ACCNT_NUM,
				@VA_COST_PRICE, 
				@VA_SELL_PRICE,   
				@VA_NUMBER ,
				@IV_INT_NOTE          
			)                 
    

			---Update the Tbl_mas_Configuration----------         
			IF @@ERROR <> 0                         
			BEGIN                      
				SET @0V_RETVALUE = @@ERROR                        
				ROLLBACK TRANSACTION @TRANNAME                      
			END                        
			ELSE                      
			BEGIN                      
				UPDATE TBL_MAS_WO_CONFIGURATION                   
				SET    WO_CUR_SERIES = @IV_ID_WO_NO                    
				WHERE  (GETDATE() BETWEEN DT_EFF_FROM AND DT_EFF_TO)                     
				AND ID_SUBSIDERY_WO = @SUBID                   
				AND ID_DEPT_WO = @DEPID   
				
				
				/* 382-d Updating the vehicle cost price and selling price */
				
				DECLARE @WO_ORD_TYPE VARCHAR(10)
				SELECT @WO_ORD_TYPE = WO_TYPE_WOH FROM TBL_WO_HEADER WHERE ID_WO_NO = @IV_ID_WO_NO AND ID_WO_PREFIX = @IV_ID_WO_PREFIX   
				
				UPDATE TBL_MAS_VEHICLE
				SET COST_PRICE = @VA_COST_PRICE, SELL_PRICE = @VA_SELL_PRICE 
				WHERE VEH_REG_NO = @IV_WO_VEH_REG_NO1 and ID_VEH_SEQ = @IV_ID_VEH_SEQ_WO1  AND @WO_ORD_TYPE = ''CRSL''
				
				/* Updating the vehicle cost price and selling price */
				
				/* 654 - Set the FLG_UPD_MILEAGE if the mileage is updated */
				UPDATE TBL_WO_HEADER
				SET FLG_UPD_MILEAGE = @FLG_UPD_MILEAGE
				WHERE ID_WO_NO = @IV_ID_WO_NO and ID_WO_PREFIX=@IV_ID_WO_PREFIX
				AND ISNULL(FLG_UPD_MILEAGE,0) = 0
				
				/* 654 - Set the FLG_UPD_MILEAGE if the mileage is updated */
      
				COMMIT TRANSACTION @TRANNAME                       
				SET @0V_RETVALUE = ''INSFLG''                       
				
				IF @IV_ID_VEH_SEQ_WO1 IS NULL
				  SET @0V_RETWONO = @IV_ID_WO_NO + '';'' +  @IV_ID_WO_PREFIX + '';'' + @IV_ID_CUST_WO 
				ELSE
				  SET @0V_RETWONO = @IV_ID_WO_NO + '';'' +  @IV_ID_WO_PREFIX + '';'' + @IV_ID_CUST_WO + '';''+ CAST(@IV_ID_VEH_SEQ_WO1 AS VARCHAR(20))	
				
				 
			END                  
		END   
		END TRY                
		BEGIN CATCH       
			SET @0V_RETVALUE = @@ERROR --''ERRFLG''
			select error_message()
			EXEC usp_GetErrorInfo            
			ROLLBACK TRANSACTION @TRANNAME              
		END CATCH	
	END
' 
END
GO

/****** Object:  StoredProcedure [dbo].[USP_TR_MANUAL_CLOCKIN]    Script Date: 2/7/2018 2:49:17 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_TR_MANUAL_CLOCKIN]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_TR_MANUAL_CLOCKIN]
GO
/****** Object:  StoredProcedure [dbo].[USP_TR_MANUAL_CLOCKIN]    Script Date: 2/7/2018 2:49:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_TR_MANUAL_CLOCKIN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_TR_MANUAL_CLOCKIN] AS' 
END
GO
/*************************************** APPLICATION: MSG *************************************************************  
* MODULE : TIME REGISTRATION  
* FILE NAME : USP_TR_MANUAL_CLOCKIN.PRC  
* PURPOSE : ENTER THE CLOCKIN RECORDS MANUALLY FROM POPUP
* AUTHOR : SMITA M 
* DATE  : 30.01.2018  
*********************************************************************************************************************/  

ALTER PROC [dbo].[USP_TR_MANUAL_CLOCKIN]  
 (  
   @IV_ID_WO_NO   VARCHAR(10),  
   @IV_ID_JOB    INT,  
   @IV_ID_MEC_TR   VARCHAR(20),  
   @IV_DAY_CLOCK_IN  VARCHAR(20),  
   @IV_HR_CLOCK_IN  VARCHAR(20),  
   @IV_DAY_CLOCK_OUT  VARCHAR(20),  
   @IV_HR_CLOCK_OUT  VARCHAR(20),  
   @IV_STATUS    VARCHAR(20),  
   @IV_ID_UNSOLD_TIME  VARCHAR(20),  
   @IV_ID_SHIFT_NO  INT,  
   @IV_ID_DAY_SEQ   INT,  
   @IV_ID_LOG_SEQ   INT,  
   @IV_CREATED_BY   VARCHAR(20), 
   @ID_WOLAB_SEQ INT, 
   @OV_RETURN    VARCHAR(10) OUTPUT     
    
 )  
AS  
BEGIN  
  
 DECLARE @FRMDATE   VARCHAR(30)----DT_CLOCK_IN  
 DECLARE @TODATE    VARCHAR(30) ----DT_CLCOK_OUT  
 Declare @ID_TR_SEQ int  
  
 SELECT @FRMDATE = @IV_DAY_CLOCK_IN + ' ' + @IV_HR_CLOCK_IN   
 SELECT @TODATE = @IV_DAY_CLOCK_OUT + ' ' + @IV_HR_CLOCK_OUT  
 
 DECLARE @IV_ID_DEPT VARCHAR(10)
 DECLARE @START_MIN AS VARCHAR(10)        
 DECLARE @END_MIN AS VARCHAR(10)        
 DECLARE @FLG_LUNCHWITHDRAW AS BIT        
 
 SELECT @IV_ID_DEPT = ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login = @IV_CREATED_BY  
 
 SELECT @FLG_LUNCHWITHDRAW = LUNCH_WITHDRAW FROM TBL_MAS_DEPT WHERE ID_DEPT = @IV_ID_DEPT            
 SELECT @START_MIN = FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = @IV_ID_DEPT          
 SELECT @END_MIN = TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = @IV_ID_DEPT         
         
 IF @START_MIN IS NULL         
  SET @START_MIN = '0'        
         
 IF @END_MIN IS NULL         
  SET @END_MIN = '0'      

  
 DECLARE @UNSOLDTIME      VARCHAR(10)  
  
 IF  @IV_ID_UNSOLD_TIME <> NULL OR @IV_ID_UNSOLD_TIME <> ''   
  BEGIN  
   SELECT   
    @UNSOLDTIME = ID_SETTINGS   
   FROM   
    TBL_MAS_SETTINGS   
   WHERE   
    DESCRIPTION =  @IV_ID_UNSOLD_TIME AND   
    ID_CONFIG = 'TR-REASCD'  
  END  
 DECLARE @SHIFTNO AS INT  
 SELECT     
  @SHIFTNO = ID_SHIFT_NO     
 FROM     
  TBL_PLAN_SHIFT_MAP     
 WHERE     
  ID_USER = @IV_ID_MEC_TR AND     
  DATEDIFF(DAY,DT_WORK, @FRMDATE) = 0   
   
  
 IF @IV_ID_JOB = 0   
 BEGIN  
  SET @IV_ID_JOB = NULL  
 END  
  
 DECLARE @IV_ID_WO_PREFIX VARCHAR(3)    
 DECLARE @IV_ID_WO_NO_SUFFIX VARCHAR(10)   
     
 IF @IV_ID_WO_NO =''  
  BEGIN  
   SET @IV_ID_WO_PREFIX=NULL  
   SET @IV_ID_WO_NO_SUFFIX=NULL    
  END  
 ELSE  
  BEGIN  
   SELECT   
    @IV_ID_WO_PREFIX    =ID_WO_PREFIX,     
    @IV_ID_WO_NO_SUFFIX = ID_WO_NO    
   FROM   
    VW_WORKORDER_HEADER    
   WHERE LTRIM(RTRIM(WO_NUMBER)) = LTRIM(RTRIM(@IV_ID_WO_NO))    
  print @IV_ID_WO_NO_SUFFIX  
  END  
  
 INSERT INTO  TBL_TR_JOB_ACTUAL   
  (  
  ID_WO_NO,  
  ID_WO_PREFIX,  
  ID_JOB,  
  ID_MEC_TR,  
  DT_CLOCK_IN,  
  DT_CLOCK_OUT,  
  ID_UNSOLD_TIME,  
  STATUS,  
  CREATED_BY,  
  ID_SHIFT_NO,  
  ID_DAY_SEQ,  
  ID_LOG_SEQ,  
  DT_CREATED,
  ID_WO_LAB_SEQ   
  )   
 VALUES  
  (  
  @IV_ID_WO_NO_SUFFIX,  
  @IV_ID_WO_PREFIX,  
  @IV_ID_JOB ,  
  @IV_ID_MEC_TR,  
  @FRMDATE,  
  @TODATE,  
  @UNSOLDTIME,  
  @IV_STATUS,  
  @IV_CREATED_BY,  
  @SHIFTNO,  
  @IV_ID_DAY_SEQ,  
  @IV_ID_LOG_SEQ,  
  GETDATE(),
  @ID_WOLAB_SEQ  
  )
  
  DECLARE @TMP_ID_TR_SEQ INT
  SELECT TOP 1 @TMP_ID_TR_SEQ = ID_TR_SEQ  FROM TBL_TR_JOB_ACTUAL ORDER By DT_CREATED DESC
  
  --------------------CALCULATING TOTAL CLOCKED TIME  
     DECLARE @TOTAL_CLOCKED_TIME VARCHAR(20) = NULL  
  
					SELECT @TOTAL_CLOCKED_TIME = 
						(CASE WHEN (ID_JOB IS NOT NULL) AND (SELECT JOB_STATUS FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX + ID_WO_NO = TBL_TR_JOB_ACTUAL.ID_WO_PREFIX + TBL_TR_JOB_ACTUAL.ID_WO_NO AND ID_JOB = TBL_TR_JOB_ACTUAL.ID_JOB) = 'INV' AND '1'='0' THEN 
							dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)
						ELSE
							CASE WHEN CONVERT(VARCHAR(5),ISNULL(@FLG_LUNCHWITHDRAW,0)) = 1 THEN   
								CASE WHEN  ID_SHIFT_NO IS NOT NULL THEN     
									CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)) OR 
											((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)))) THEN
										dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)		
									ELSE
										CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)) 
											AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))
											AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) <= (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN
												dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' ' + (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)))		
										WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))
											AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN
												'00:00'
										WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))
											AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN
												dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' ' +  (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)),DT_CLOCK_OUT)			
										WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)) 
											AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN
												DBO.[FNADDMINS](dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' ' +  (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) ,  
												dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' ' +  (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)),DT_CLOCK_OUT))			
										ELSE
											dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)
										END 	
									END
								ELSE 
									CASE WHEN CONVERT(VARCHAR(5),@START_MIN) <> '0' AND  CONVERT(VARCHAR(5),@END_MIN) <> '0' THEN 
										CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < CONVERT(VARCHAR(5),@START_MIN)) OR 
											((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > CONVERT(VARCHAR(5),@END_MIN)))) THEN
												dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)
										ELSE
											CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < CONVERT(VARCHAR(5),@START_MIN)) AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8)) > CONVERT(VARCHAR(5),@START_MIN) AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8)) <= CONVERT(VARCHAR(5),@END_MIN)) THEN
												dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + CONVERT(VARCHAR(5),@START_MIN)))		
											WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > CONVERT(VARCHAR(5),@START_MIN)) AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < CONVERT(VARCHAR(5),@END_MIN))) THEN
												'00:00'
											WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > CONVERT(VARCHAR(5),@START_MIN)) AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > CONVERT(VARCHAR(5),@END_MIN))) THEN
												dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + CONVERT(VARCHAR(5),@END_MIN)),DT_CLOCK_OUT)			
											WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < CONVERT(VARCHAR(5),@START_MIN)) AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > CONVERT(VARCHAR(5),@END_MIN))) THEN
												DBO.[FNADDMINS](dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + CONVERT(VARCHAR(5),@START_MIN))) ,  
												dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + CONVERT(VARCHAR(5),@END_MIN)),DT_CLOCK_OUT))			
											ELSE
												dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)
											END 
										END
									ELSE
											dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT) 
						END				
								END
							ELSE
								dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)
							END
						END)
						FROM TBL_TR_JOB_ACTUAL
						WHERE  ID_TR_SEQ=@TMP_ID_TR_SEQ
  
      UPDATE TBL_TR_JOB_ACTUAL SET TOTAL_CLOCKED_TIME = @TOTAL_CLOCKED_TIME WHERE ID_TR_SEQ=@TMP_ID_TR_SEQ  
  
------------------------------------- 
  
    
  
   set @ID_TR_SEQ =@@IDENTITY  
  
  
  INSERT INTO TBL_TR_JOB_ACTUAL_HISTORY  
 ([ID_TR_SEQ]  
      ,[ID_WO_NO]  
      ,[ID_WO_PREFIX]  
      ,[ID_JOB]  
      ,[ID_SPLIT_SEQ]  
      ,[ID_MEC_TR]  
      ,[ID_DAY_SEQ]  
      ,[ID_LOG_SEQ]  
      ,[ID_SHIFT_NO]  
      ,[DT_LOGIN]  
      ,[DT_CLOCK_IN]  
      ,[DT_CLOCK_OUT]  
      ,[DT_LOGOUT]  
      ,[ID_UNSOLD_TIME]  
      ,[COMP_PER]  
      ,[CO_REAS_CODE]  
      ,[STATUS]  
      ,[CREATED_BY]  
      ,[DT_CREATED]  
    ,[MODIFIED_BY]  
      ,[DT_MODIFIED]  
      ,[DT_CREATED_HISTORY]  
      ,[UPDATED_FROM] 
      ,ID_WO_LAB_SEQ 
      ,TOTAL_CLOCKED_TIME)
 SELECT [ID_TR_SEQ]  
      ,[ID_WO_NO]  
      ,[ID_WO_PREFIX]  
      ,[ID_JOB]  
      ,[ID_SPLIT_SEQ]  
      ,[ID_MEC_TR]  
      ,[ID_DAY_SEQ]  
      ,[ID_LOG_SEQ]  
      ,[ID_SHIFT_NO]  
      ,[DT_LOGIN]  
      ,[DT_CLOCK_IN]  
      ,[DT_CLOCK_OUT]  
      ,[DT_LOGOUT]  
      ,[ID_UNSOLD_TIME]  
      ,[COMP_PER]  
      ,[CO_REAS_CODE]  
      ,[STATUS]  
      ,[CREATED_BY]  
      ,[DT_CREATED]  
      ,[MODIFIED_BY]  
      ,[DT_MODIFIED]  
      ,GETDATE()  
      ,'USP_TR_CTPMECH_SPLITSAVE' 
      ,ID_WO_LAB_SEQ
      ,TOTAL_CLOCKED_TIME  
 FROM TBL_TR_JOB_ACTUAL WHERE  
  ID_TR_SEQ = @ID_TR_SEQ  
  

 IF @IV_ID_WO_NO <> null or @IV_ID_JOB <> 0        
 BEGIN                   
  UPDATE                         
  TBL_WO_HEADER                          
  SET                          
   WO_STATUS  = 'JCD'                        
  WHERE                         
   ID_WO_NO     = @IV_ID_WO_NO_SUFFIX AND                          
   ID_WO_PREFIX = @IV_ID_WO_PREFIX                
 END   
  
  

 EXECUTE USP_TR_PLAN_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@IV_ID_JOB,NULL,'JCD',@OV_RETURN      
 EXECUTE USP_TR_WO_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@IV_ID_JOB,NULL, 'JCD',@OV_RETURN   
   

   
 DECLARE @ID_WODETSEQ AS INT  
 DECLARE @COUNT AS INT  
      
 SELECT @ID_WODETSEQ = ID_WODET_SEQ  FROM TBL_WO_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                 
   AND ID_JOB= @IV_ID_JOB  
     
 SELECT @COUNT = COUNT(*) FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @ID_WODETSEQ AND ID_LOGIN = @IV_ID_MEC_TR  
    
 IF @COUNT > 0  
 BEGIN   
  DECLARE @CLOCKEDTIME AS DECIMAL(9,2)  
  DECLARE @TIME1 AS VARCHAR(10)  
    
  SELECT @TIME1 = dbo.SumTimeMechDiffTEMP( (@IV_ID_WO_PREFIX + @IV_ID_WO_NO_SUFFIX ),@IV_ID_JOB,@IV_ID_MEC_TR)    
  SELECT @CLOCKEDTIME = CAST((SUM(CAST(CONVERT(INT,SUBSTRING(@TIME1,0,CHARINDEX(':',@TIME1)))*60 + CONVERT  
  (INT,SUBSTRING(@TIME1,CHARINDEX(':',@TIME1)+1,LEN(@TIME1)))AS DECIMAL(10,2)))/60)  
  AS DECIMAL(10,2))  
    
  
      
  UPDATE TBL_WO_LABOUR_DETAIL                                
   SET  WO_LABOUR_HOURS =  @CLOCKEDTIME       
   WHERE  ID_WODET_SEQ = @ID_WODETSEQ AND ID_LOGIN= @IV_ID_MEC_TR    
     
   EXEC USP_TR_UPDATE_WO_DETAILS @ID_TR_SEQ , ''     
 END   
 ELSE   
 BEGIN  
  --EXECUTE USP_WO_LABOUR_DETAILS_SAVE  @IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@IV_ID_JOB,@IV_ID_MEC_TR,@IV_CREATED_BY  
  DECLARE @MAKEPCD VARCHAR(30),@MECHPCD VARCHAR(10),@REPPKGPCD VARCHAR(10),@CUSTPCD VARCHAR(10),   
 @VEHGRPPCD VARCHAR(10), @JOBPCD VARCHAR(10),@VEHVATCODE VARCHAR(10),@CUSTVATCODE VARCHAR(10),   
 @VATPer DECIMAL(5,2)        
   
    SELECT @MECHPCD = MAX(ID_MECPCD) FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @IV_ID_MEC_TR                
      
    SELECT                 
  @MAKEPCD  = ID_MAKE,                        
  @CUSTPCD  = ID_CUSTOMER,                
  @VEHVATCODE = MV.ID_VAT_CD,                
  @CUSTVATCODE = MCG.ID_VAT_CD                
    FROM                 
  TBL_WO_HEADER wh                 
        JOIN TBL_MAS_VEHICLE MV ON WH.ID_VEH_SEQ_WO = MV.ID_VEH_SEQ                 
        JOIN TBL_MAS_MAKE MM ON MM.ID_MAKE = MV.ID_MAKE_VEH                        
        JOIN TBL_MAS_CUSTOMER MC ON MC.ID_CUSTOMER = WH.ID_CUST_WO                
        JOIN TBL_MAS_CUST_GROUP MCG ON MCG.ID_CUST_GRP_SEQ = MC.ID_CUST_GROUP                 
 WHERE                 
  WH.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                
  AND WH.ID_WO_PREFIX = @IV_ID_WO_PREFIX          
          
    
 SELECT                 
  @VEHGRPPCD = VH_GROUP_ID               
    FROM                 
  TBL_WO_HEADER wh                 
        JOIN TBL_MAS_VEHICLE MV ON WH.ID_VEH_SEQ_WO = MV.ID_VEH_SEQ                 
        JOIN TBL_MAS_VHGROUPPC MVGP ON MV.ID_GROUP_VEH = MVGP.VH_GROUP_ID                
    WHERE                 
  WH.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                
  AND WH.ID_WO_PREFIX = @IV_ID_WO_PREFIX          
               
              
    SELECT                 
  @RepPkgPCD = ID_RPKG_SEQ,                
  @JobPcd = ID_JOBPCD_WO                
 FROM                
  TBL_WO_DETAIL wd                 
        JOIN TBL_WO_HEADER wh ON wh.ID_WO_NO =  wd.ID_WO_NO AND wh.ID_WO_PREFIX = wd.ID_WO_PREFIX                
        LEFT JOIN TBL_MAS_REP_PACKAGE mrp ON mrp.ID_RPKG_SEQ = wd.ID_RPG_CODE_WO                
    WHERE               
  wh.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                
  AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                
  AND wd.ID_JOB = @IV_ID_JOB    
  
 DECLARE @HOURLYPRICE DECIMAL(11,2),@HPVAT VARCHAR(500)                
    EXEC [USP_WO_GetHPPrice] @IV_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE OUTPUT, @HPVAT OUTPUT              
    SELECT @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE , @HPVAT,'TEST'                 
    SELECT TOP 1 @VATPer = VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = @CustVATCode AND VAT_VEH = @VehVatCode AND VAT_ITEM = @HPVAT                
    AND DT_EFF_TO = '9999-12-31 23:59:59.000' Order by DT_EFF_FROM DESC    
        
       SELECT @TIME1 = dbo.SumTimeMechDiffTEMP( (@IV_ID_WO_PREFIX + @IV_ID_WO_NO_SUFFIX),@IV_ID_JOB,@IV_ID_MEC_TR)    
  SELECT @CLOCKEDTIME = CAST((SUM(CAST(CONVERT(INT,SUBSTRING(@TIME1,0,CHARINDEX(':',@TIME1)))*60 + CONVERT  
  (INT,SUBSTRING(@TIME1,CHARINDEX(':',@TIME1)+1,LEN(@TIME1)))AS DECIMAL(10,2)))/60)  
  AS DECIMAL(10,2))  
    
 --INSERT INTO TBL_WO_LABOUR_DETAIL                               
 -- SELECT       
 -- CASE WHEN (@IV_ID_WO_NO_SUFFIX IS NOT NULL AND @IV_ID_WO_PREFIX IS NOT NULL AND @IV_ID_JOB IS NOT NULL) THEN                                        
 --  (SELECT ID_WODET_SEQ  FROM TBL_WO_DETAIL WHERE ID_WO_NO= @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                 
 --  AND ID_JOB= @IV_ID_JOB)                                
 -- END AS 'WO_SEQ',             
 -- @IV_ID_MEC_TR,   
 --    CASE WHEN (@IV_ID_WO_NO_SUFFIX IS NOT NULL AND @IV_ID_WO_PREFIX IS NOT NULL AND @IV_ID_JOB IS NOT NULL) THEN                                        
 --  @CLOCKEDTIME           
 -- END AS 'TIME',      
 -- @HOURLYPRICE AS 'HP PRICE',   
 -- CASE WHEN @HPVAT='' THEN             
 --  NULL            
 -- ELSE            
 --  @HPVAT   
 -- END AS 'HP VATCODE',                  
 -- (SELECT VAT_ACCCODE FROM TBL_VAT_DETAIL WHERE VAT_CUST =                                       
 --  (SELECT                                    
 --   CASE WHEN ID_CUST_WO IS NOT NULL THEN                                          
 --    (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ =                                          
 --    (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER                                       
 --    WHERE ID_CUSTOMER = TBL_WO_HEADER.ID_CUST_WO ))                                          
 --   END                                          
 --  FROM TBL_WO_HEADER                                          
 --  WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX  AND ID_WO_PREFIX = @IV_ID_WO_PREFIX )                                          
 --  AND VAT_VEH  = (SELECT                                     
 --  CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                          
 --   (SELECT ID_VAT_CD FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                          
 --  END                                          
 --  FROM TBL_WO_HEADER                                          
 --  WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX  )                                          
 --  AND VAT_ITEM =(SELECT TOP 1 HP_Vat FROM  TBL_MAS_HP_RATE                            
 --  WHERE  DT_EFF_FROM = (SELECT   MAX(DT_EFF_FROM)                             
 -- FROM   TBL_MAS_HP_RATE where  ID_MECHPCD_HP = (SELECT Top 1 ID_MECPCD FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC =@IV_ID_MEC_TR)))            
 -- AND getdate() BETWEEN dt_eff_from AND dt_eff_to) ,           
 -- (SELECT TOP 1 HP_ACC_CODE FROM  TBL_MAS_HP_RATE                            
 --  WHERE  DT_EFF_FROM = (SELECT   MAX(DT_EFF_FROM)                             
 --  FROM   TBL_MAS_HP_RATE where  ID_MECHPCD_HP = (SELECT TOP 1 ID_MECPCD FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @IV_ID_MEC_TR)))  
 -- , @VATPer     
    
  EXEC USP_TR_UPDATE_WO_DETAILS @ID_TR_SEQ , ''   
    
        
 END    
   
   
    
  
 IF @@ERROR <> 0  
  SET @OV_RETURN = 'FALSE'  
 ELSE  
  SET @OV_RETURN = 'TRUE'   
END  
  
  
  
 
  
  
  
  
  
  
  
  
  
  
  
  
GO

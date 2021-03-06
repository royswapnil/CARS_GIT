/****** Object:  StoredProcedure [dbo].[USP_TIMEREG_DETAIL_INSERT]    Script Date: 1/17/2018 3:38:48 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_TIMEREG_DETAIL_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_TIMEREG_DETAIL_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_TIMEREG_DETAIL_INSERT]    Script Date: 1/17/2018 3:38:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_TIMEREG_DETAIL_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_TIMEREG_DETAIL_INSERT] AS' 
END
GO
/*************************************** APPLICATION: MSG *************************************************************        
* MODULE : TIME REGISTRATION- MAIN SCREEN        
* FILE NAME : USP_TIMEREG_DETAIL_INSERT.PRC (USED IN USP_INSERT_TR_JOB_DETAIL STORED PROCEDURE)         
* PURPOSE :NEW APPLICATION - TO INSERT THE RECORD IN TBL_TR_JOB_ACTUAL (CLOCK-IN & CLOCK-OUT)       
* AUTHOR : SMITA         
* DATE  : 03.01.2018        
*********************************************************************************************************************/        
      
        
ALTER PROCEDURE [dbo].[USP_TIMEREG_DETAIL_INSERT]     
(     
 @IV_ID_WO_NO VARCHAR(13),     
 @II_ID_JOB INT,     
 @IV_ID_MEC_TR VARCHAR(20),     
 @SHIFTNO INT,     
 @ID_DAY_SEQ INT,     
 @ID_LOG_SEQ INT,     
 @IV_UNSOLD_TIME VARCHAR(10),     
 @DT_LOGIN DATETIME,     
 @DT_CLOCK_IN DATETIME,     
 @II_SPLIT_SEQ INT,     
 @STATUS VARCHAR(5),     
 @IV_CREATED_BY VARCHAR(20),  
 @OV_STATUS VARCHAR(1) OUTPUT ,  
 @ID_WO_LAB_SEQ INT     
    
)     
AS     
BEGIN     
 DECLARE @IV_ID_WO_PREFIX VARCHAR(3)     
 DECLARE @IV_ID_WO_NO_SUFFIX VARCHAR(10)     
 DECLARE @IV_IDLE_TIME VARCHAR(10)     
     
    
 IF @IV_ID_WO_NO =''     
  BEGIN     
   SET @IV_ID_WO_PREFIX = NULL     
   SET @IV_ID_WO_NO_SUFFIX = 0     
  END     
 ELSE     
  BEGIN     
   SELECT @IV_ID_WO_PREFIX = ID_WO_PREFIX, @IV_ID_WO_NO_SUFFIX = ID_WO_NO     
   FROM VW_WORKORDER_HEADER     
   WHERE LTRIM(RTRIM(WO_NUMBER)) = LTRIM(RTRIM(@IV_ID_WO_NO))     
  END  
  
  IF @IV_UNSOLD_TIME IS NOT NULL
   BEGIN
	SET @ID_WO_LAB_SEQ = NULL
   END  
    
 IF @II_SPLIT_SEQ = 0 SET @II_SPLIT_SEQ = NULL     
    
 DECLARE @StartTime DATETIME    
 DECLARE @EndTime DATETIME    
 DECLARE @ClockInTime DATETIME    
 --IDLE TIME    
 DECLARE @DAY_START_TIME DATETIME    
 DECLARE @FLG_USE_IDLETIME BIT    
 DECLARE @COMMON_MECHANIC_ID VARCHAR(50)    
     
 SET @ClockInTime = @DT_CLOCK_IN    
    
 SELECT @StartTime = DATEADD(MINUTE, CAST(DET.START_TIME_MIN AS INT), DATEADD(HOUR, CAST(DET.START_TIME_HR AS INT), MAP.DT_WORK)),     
  --@EndTime = DATEADD(MINUTE, CAST(DET.CLOSE_TIME_MIN AS INT), DATEADD(HOUR, CAST(DET.CLOSE_TIME_MIN AS INT), MAP.DT_WORK))     
  @EndTime = DATEADD(MINUTE, CAST(DET.CLOSE_TIME_MIN AS INT), DATEADD(HOUR, CAST(DET.CLOSE_TIME_HR AS INT), MAP.DT_WORK))     
 FROM TBL_PLAN_SHIFT_MAP MAP    
  INNER JOIN TBL_MAS_SHIFT_DETAILS DET ON MAP.ID_SHIFT_NO = DET.ID_SHIFT_NO    
 WHERE MAP.ID_SHIFT_NO = @SHIFTNO AND MAP.ID_USER = @IV_ID_MEC_TR AND MAP.DT_WORK = CONVERT(VARCHAR(10), @ClockInTime, 101)    
     
 --Setting the actual Day start time    
 SET @DAY_START_TIME = @StartTime     
      
 --Select the IDLE time and Common Mechanic Id from TBL_MAS_USERS    
 SELECT @FLG_USE_IDLETIME = ISNULL(FLG_USE_IDLETIME,0),@COMMON_MECHANIC_ID = COMMON_MECHANIC_ID    
 FROM TBL_MAS_USERS WHERE ID_LOGIN = @IV_ID_MEC_TR        
    
    
 -- Logging Idle Time    
 -- Only If Shift Number Exist    
 -- Only If Clock-In Time before Shift End Time    
 IF (@FLG_USE_IDLETIME = 1)-- IF The flg_use_idletime is set to true then proceed    
 BEGIN    
  IF DATEDIFF(MINUTE, @StartTime, @ClockInTime) > 0 AND @ClockInTime <= @EndTime     
  BEGIN    
   SELECT @IV_IDLE_TIME = ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = 'TR-IDLECD'    
       
   IF (@COMMON_MECHANIC_ID IS NULL)    
    BEGIN    
     IF EXISTS(SELECT ID_TR_SEQ FROM TBL_TR_JOB_ACTUAL WHERE DT_CLOCK_OUT > CONVERT(VARCHAR(10), @ClockInTime, 101) AND DT_CLOCK_OUT < @ClockInTime AND ID_MEC_TR = @IV_ID_MEC_TR)    
     BEGIN    
      SELECT  TOP 1 @StartTime = DT_CLOCK_OUT    
      FROM TBL_TR_JOB_ACTUAL     
      WHERE (DT_CLOCK_OUT IS NULL OR (DT_CLOCK_OUT > CONVERT(VARCHAR(10), @ClockInTime, 101)     
       AND DT_CLOCK_OUT < @ClockInTime))     
       AND ID_MEC_TR = @IV_ID_MEC_TR     
      ORDER BY ID_TR_SEQ DESC    
     END    
    END     
   ELSE IF (@COMMON_MECHANIC_ID IS NOT NULL)    
    BEGIN    
     IF EXISTS(SELECT ID_TR_SEQ FROM TBL_TR_JOB_ACTUAL WHERE DT_CLOCK_OUT > CONVERT(VARCHAR(10), @ClockInTime, 101) AND DT_CLOCK_OUT < @ClockInTime     
     AND ID_MEC_TR IN (SELECT ID_LOGIN FROM TBL_MAS_USERS WHERE COMMON_MECHANIC_ID = @COMMON_MECHANIC_ID))    
     BEGIN    
      SELECT  TOP 1 @StartTime = DT_CLOCK_OUT    
      FROM TBL_TR_JOB_ACTUAL     
      WHERE (DT_CLOCK_OUT IS NULL OR (DT_CLOCK_OUT > CONVERT(VARCHAR(10), @ClockInTime, 101)     
       AND DT_CLOCK_OUT < @ClockInTime))     
       AND ID_MEC_TR IN (SELECT ID_LOGIN FROM TBL_MAS_USERS WHERE COMMON_MECHANIC_ID = @COMMON_MECHANIC_ID)     
      ORDER BY ID_TR_SEQ DESC    
     END    
    END    
       
   IF NOT EXISTS(SELECT ID_TR_SEQ FROM TBL_TR_JOB_ACTUAL WHERE DT_CLOCK_OUT = @ClockInTime AND ID_MEC_TR IN(SELECT ID_LOGIN FROM TBL_MAS_USERS WHERE COMMON_MECHANIC_ID = @COMMON_MECHANIC_ID))    
   BEGIN    
    --IF(@DAY_START_TIME != @StartTime) Changed since it was inserting idle records for logins before shift start    
    IF(@DAY_START_TIME < @StartTime)    
     BEGIN    
      INSERT INTO TBL_TR_JOB_ACTUAL     
     (    
      ID_MEC_TR,     
      ID_SHIFT_NO,     
      ID_DAY_SEQ,     
      ID_LOG_SEQ,     
      ID_UNSOLD_TIME,     
      DT_CLOCK_IN,     
      DT_CLOCK_OUT,     
      STATUS,     
      CREATED_BY,     
      DT_CREATED,  
      ID_WO_LAB_SEQ     
     )     
     VALUES     
     (     
      @IV_ID_MEC_TR,     
      @SHIFTNO,     
      @ID_DAY_SEQ,     
      @ID_LOG_SEQ,     
      @IV_IDLE_TIME,     
      @StartTime,     
      @ClockInTime,     
      'JST',     
      @IV_CREATED_BY,     
      GETDATE() ,  
      @ID_WO_LAB_SEQ    
     )    
     END    
   END    
  END    
 END    
    
    
    
 IF EXISTS (SELECT * FROM TBL_TR_JOB_ACTUAL WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB AND ID_MEC_TR = @IV_ID_MEC_TR AND DT_CLOCK_OUT IS NULL AND CONVERT(date, DT_CLOCK_IN) = CONVERT(date, @DT_CLOCK_IN  
))    
 BEGIN    
  DELETE TBL_TR_JOB_ACTUAL WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB AND ID_MEC_TR = @IV_ID_MEC_TR AND DT_CLOCK_OUT IS NULL AND CONVERT(date, DT_CLOCK_IN) = CONVERT(date, @DT_CLOCK_IN)    
 END    
     
 INSERT INTO TBL_TR_JOB_ACTUAL     
 (    
  ID_WO_NO,     
  ID_WO_PREFIX,     
  ID_JOB,     
  ID_MEC_TR,     
  ID_SHIFT_NO,     
  ID_DAY_SEQ,     
  ID_LOG_SEQ,     
  ID_UNSOLD_TIME,     
  DT_LOGIN,     
  DT_CLOCK_IN,     
  ID_SPLIT_SEQ,     
  STATUS,     
  CREATED_BY,     
  DT_CREATED,  
  ID_WO_LAB_SEQ       
 )     
 VALUES     
 (     
  @IV_ID_WO_NO_SUFFIX,     
  @IV_ID_WO_PREFIX,     
  @II_ID_JOB,     
  @IV_ID_MEC_TR,     
  @SHIFTNO,     
  @ID_DAY_SEQ,     
  @ID_LOG_SEQ,     
  @IV_UNSOLD_TIME,     
  @DT_LOGIN,     
  @DT_CLOCK_IN,     
  @II_SPLIT_SEQ,     
  'JST',     
  @IV_CREATED_BY,     
  GETDATE(),  
  @ID_WO_LAB_SEQ     
 )     
    
 SET @OV_STATUS = @@ERROR          
END 
GO

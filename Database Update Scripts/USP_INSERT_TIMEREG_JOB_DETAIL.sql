/****** Object:  StoredProcedure [dbo].[USP_INSERT_TIMEREG_JOB_DETAIL]    Script Date: 2/7/2018 2:50:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_INSERT_TIMEREG_JOB_DETAIL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_INSERT_TIMEREG_JOB_DETAIL]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_TIMEREG_JOB_DETAIL]    Script Date: 2/7/2018 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_INSERT_TIMEREG_JOB_DETAIL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_INSERT_TIMEREG_JOB_DETAIL] AS' 
END
GO
      
/*************************************** APPLICATION: MSG *************************************************************                                
* MODULE : TIME REGISTRATION- MAIN SCREEN                                
* FILE NAME : USP_INSERT_TR_JOB_DETAIL.PRC                                
* PURPOSE : NEW APPLICATION -TO SAVE THE CLOCK-IN & CLOCK-OUT DETAILS OF A MECHANIC                                
* AUTHOR : SMITA M                                
* DATE  : 01.01.2018                                
*********************************************************************************************************************/                                
    
ALTER PROCEDURE [dbo].[USP_INSERT_TIMEREG_JOB_DETAIL]                                
(                                        
  @TMP_ID_TR_SEQ      INT,       
  @IV_ID_WO_NO        VARCHAR(13),       
  @II_ID_JOB   INT,      
  @IV_CO_REAS_CODE VARCHAR(10),      
  @II_COMP_PER  INT,       
  @IV_UNSOLD_TIME  VARCHAR(10),      
  @IV_ID_MEC_TR  VARCHAR(20),      
  @IC_LOGOUT_FLG      CHAR(1),      
  @II_SPLIT_SEQ       INT,       
  @IV_CREATED_BY  VARCHAR(20),      
  @CONFIRM_CLOCK_OUT BIT,--IDLE  
  @ID_WO_LAB_SEQ INT,     
  @OV_STATUS   VARCHAR(10)  OUTPUT       
)                                                 
AS                                        
BEGIN                                  
                                      
 DECLARE @DT AS DATETIME      
 SET @DT = GETDATE()      
 DECLARE @SHIFTNO  AS INT      
 DECLARE @SHIFTSTART AS DATETIME       
 DECLARE @SHIFTEND  AS DATETIME       
 DECLARE @IV_ID_WO_PREFIX_CUR  VARCHAR(3)      
 DECLARE @IV_ID_WO_NO_SUFFIX_CUR VARCHAR(10)      
 DECLARE @CHECK_MECHANIC_ID VARCHAR(50)      
 --DECLARE @COMMON_MECHANIC_ID VARCHAR(50)      
 DECLARE @WO_CREATED_BY  VARCHAR(20) /*Added to handle scenarios where mechanic might login to an order from a different department*/      
 DECLARE @IV_ID_DEPT VARCHAR(10)

 DECLARE @DepID INT       
 DECLARE @iv_ID_MAKE_PC_HP varchar(10)       
 DECLARE @CUS_PC INT         
 DECLARE @iv_ID_VEHGRP_PC_HP varchar(10)       
 DECLARE @RP_CODE INT         

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
 
                               
 SET @OV_STATUS = '0'       
 IF @II_COMP_PER   = 0  SET @II_COMP_PER = NULL        
 IF @II_ID_JOB     = 0  SET @II_ID_JOB = NULL       
 IF @II_SPLIT_SEQ  = 0  SET @II_SPLIT_SEQ = NULL       
                               
 SELECT @SHIFTNO = ID_SHIFT_NO      
 FROM   TBL_PLAN_SHIFT_MAP       
 WHERE  ID_USER = @IV_ID_MEC_TR       
 AND    DATEDIFF(DAY,DT_WORK, GETDATE()) = 0       
                               
 SELECT @SHIFTSTART = (START_TIME_HR + ':' +  START_TIME_MIN)      
 FROM   TBL_MAS_SHIFT_DETAILS       
 WHERE  ID_SHIFT_NO = @SHIFTNO       
                               
 SELECT @SHIFTEND = (CLOSE_TIME_HR + ':' +  CLOSE_TIME_MIN)      
 FROM   TBL_MAS_SHIFT_DETAILS       
 WHERE  ID_SHIFT_NO = @SHIFTNO       
                             
 DECLARE @COUNT AS INT       
 SELECT  @COUNT = COUNT(ID_TR_SEQ)        
 FROM    TBL_TR_JOB_ACTUAL      
 WHERE   DATEDIFF(DAY,DT_LOGIN, GETDATE()) = 0       
           
 --------- LOG_SEQ                      
 DECLARE @LOGSEQ AS INT       
 SELECT  @LOGSEQ = ID_LOG_SEQ       
 FROM    TBL_TR_JOB_ACTUAL       
 WHERE   DATEDIFF(DAY,DT_LOGIN, GETDATE()) = 0       
 ------------                                        
 DECLARE @DAYSEQ AS INT      
 SELECT  @DAYSEQ = ID_DAY_SEQ      
 FROM    TBL_TR_JOB_ACTUAL       
 WHERE   DATEDIFF(DAY,DT_LOGIN, GETDATE()) = 0        
                     
 SELECT @IV_ID_WO_PREFIX_CUR = ID_WO_PREFIX,      
 @IV_ID_WO_NO_SUFFIX_CUR = ID_WO_NO       
 FROM VW_WORKORDER_HEADER       
 WHERE LTRIM(RTRIM(WO_NUMBER)) = LTRIM(RTRIM(@IV_ID_WO_NO))       
       
 SELECT @CHECK_MECHANIC_ID = ID_MEC_TR       
 FROM TBL_TR_JOB_ACTUAL       
 WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ       
       
       
 IF(@CONFIRM_CLOCK_OUT = 0)      
 BEGIN      
  IF @TMP_ID_TR_SEQ <> 0      
  BEGIN      
   IF @IC_LOGOUT_FLG <> 'L'       
    BEGIN      
    IF (@CHECK_MECHANIC_ID <> @IV_ID_MEC_TR)      
    BEGIN      
     
     SET @OV_STATUS = -1 -- If clocked out dynamically through script then Confirmation is required      
     RETURN      
    END      
    END      
  END      
 END      
                   
 IF @COUNT = 0      
 BEGIN       
  IF (@IV_CO_REAS_CODE <> null or @TMP_ID_TR_SEQ = 0) OR (@IV_CO_REAS_CODE IS NULL AND @TMP_ID_TR_SEQ <> 0) --Fix for Row 154, where order head status was not updated when mechanic clocked in to order from unsold time      
  BEGIN       
   UPDATE TBL_WO_HEADER       
   SET       
   WO_STATUS  = 'JST'      
   WHERE       
   ID_WO_NO     = @IV_ID_WO_NO_SUFFIX_CUR AND       
   ID_WO_PREFIX = @IV_ID_WO_PREFIX_CUR       
  END       
                
  DECLARE @TMP_DAY_SEQ INT       
  SET @TMP_DAY_SEQ = NULL       
  EXECUTE USP_TR_GETDAY_SEQ @TMP_DAY_SEQ OUTPUT       
        
  DECLARE @TMP_LOG_SEQ INT        
  SET  @TMP_LOG_SEQ = NULL      
  EXECUTE USP_TR_GETLOG_SEQ @TMP_LOG_SEQ OUTPUT        
        
  SELECT @TMP_DAY_SEQ, @TMP_LOG_SEQ       
                                    
  IF ((@IV_UNSOLD_TIME IS NOT NULL) AND (@IV_ID_WO_NO IS NULL) AND (@II_ID_JOB IS NULL) AND (@IC_LOGOUT_FLG = 'C'))                                          
  BEGIN      
   EXECUTE USP_TIMEREG_DETAIL_INSERT NULL,NULL,@IV_ID_MEC_TR,@SHIFTNO,@TMP_DAY_SEQ,@TMP_LOG_SEQ,@IV_UNSOLD_TIME,@DT,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ                                        
  END       
  ELSE      
  BEGIN      
   EXECUTE USP_TIMEREG_DETAIL_INSERT @IV_ID_WO_NO,@II_ID_JOB,@IV_ID_MEC_TR,@SHIFTNO,@TMP_DAY_SEQ,@TMP_LOG_SEQ,NULL,@DT,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ                                                               
  END      
      
  IF LEN(LTRIM(RTRIM(@IV_ID_WO_NO))) = 0                         
  BEGIN       
   SELECT @IV_ID_WO_PREFIX_CUR = ID_WO_PREFIX FROM TBL_TR_JOB_ACTUAL WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ                                    
   SELECT @IV_ID_WO_NO_SUFFIX_CUR = ID_WO_NO FROM TBL_TR_JOB_ACTUAL WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ                                    
  END       
  EXECUTE USP_TR_PLAN_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX_CUR,@IV_ID_WO_PREFIX_CUR,@II_ID_JOB,@II_SPLIT_SEQ,'JST',@OV_STATUS                                        
      
        -- UPDATE THE STATUS OF THE WORK ORDER                           
  EXECUTE USP_TR_WO_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX_CUR,@IV_ID_WO_PREFIX_CUR,@II_ID_JOB,@II_SPLIT_SEQ,'JST',@OV_STATUS                   
                                      
 END  --END OF INSERT THE DETAILS IN THE CASE OF LOGIN FOR THE FIRST TIME                                        
 ELSE       
 BEGIN      
  DECLARE @ST AS VARCHAR(10)       
  DECLARE @IV_ID_WO_PREFIX VARCHAR(3)      
  DECLARE @IV_ID_WO_NO_SUFFIX VARCHAR(10)      
  DECLARE @ID_WO_NO_PREV VARCHAR(15)       
  DECLARE @II_ID_JOB_PREV INT      
  DECLARE @ID_LOG_SEQ_PREV INT      
  DECLARE @ID_DAY_SEQ_PREV INT      
  DECLARE @II_SPLIT_SEQ_PREV INT       
        
  IF @TMP_ID_TR_SEQ >= 0               
  BEGIN      
   SELECT      
    @ID_WO_NO_PREV = ID_WO_NO + ID_WO_PREFIX,                                        
    @II_ID_JOB_PREV = ID_JOB,                                        
    @ID_DAY_SEQ_PREV = ID_DAY_SEQ,                                        
    @ID_LOG_SEQ_PREV = ID_LOG_SEQ,                                        
    @II_SPLIT_SEQ_PREV = ID_SPLIT_SEQ              
   FROM       
    TBL_TR_JOB_ACTUAL                                         
   WHERE      
    ID_TR_SEQ = @TMP_ID_TR_SEQ       
          
   IF (@IV_CO_REAS_CODE IS NOT NULL or @TMP_ID_TR_SEQ = 0) OR  (@IV_CO_REAS_CODE IS NULL AND @TMP_ID_TR_SEQ <> 0) ----Fix for Row 154, where order head status was not updated when mechanic clocked in to order from unsold time       
   BEGIN       
    UPDATE TBL_WO_HEADER       
    SET WO_STATUS  = 'JST'      
    WHERE ID_WO_NO     = @IV_ID_WO_NO_SUFFIX_CUR      
    AND ID_WO_PREFIX = @IV_ID_WO_PREFIX_CUR       
   END           
                                    
   IF @IV_ID_WO_NO IS NOT NULL       
   BEGIN      
    SELECT @IV_ID_WO_PREFIX =ID_WO_PREFIX, @IV_ID_WO_NO_SUFFIX = ID_WO_NO      
    FROM  VW_WORKORDER_HEADER       
    WHERE LTRIM(RTRIM(WO_NUMBER)) = LTRIM(RTRIM(@IV_ID_WO_NO))      
   END       
   ELSE       
   BEGIN      
    SELECT @IV_ID_WO_PREFIX    =ID_WO_PREFIX, @IV_ID_WO_NO_SUFFIX = ID_WO_NO      
    FROM TBL_TR_JOB_ACTUAL      
    WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ      
   END       
                                      
     -- UNSOLD TIME                                        
   DECLARE @UNSOLD AS VARCHAR(10)       
   IF @TMP_ID_TR_SEQ <> 0      
    SELECT  @UNSOLD = ID_UNSOLD_TIME FROM TBL_TR_JOB_ACTUAL WHERE ID_TR_SEQ=@TMP_ID_TR_SEQ                                        
   ELSE      
    SELECT  @UNSOLD = @IV_UNSOLD_TIME       
      DECLARE @JB_STATS AS VARCHAR(10)      
      SELECT   @JB_STATS = JOB_STATUS FROM TBL_WO_DETAIL WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                            
     -- STATUS OF JOB COMPLETION                                          
     IF (@II_COMP_PER = 100)      
    --SET @ST = 'JCD'       
    IF (@JB_STATS <> 'INV')       
      SET @ST = 'JCD'      
    ELSE      
      IF (@JB_STATS <> 'DEL')       
      SET @ST = 'JCD'      
          
    ELSE      
       BEGIN      
         IF (@JB_STATS =  'INV')      
      SET @ST = 'INV'      
      ELSE      
       IF (@JB_STATS =  'DEL')      
       SET @ST = 'DEL'      
       END      
     ELSE       
    IF (@JB_STATS <> 'INV')       
      SET @ST = 'JST'      
    ELSE      
      IF (@JB_STATS <> 'DEL')       
      SET @ST = 'JST'      
          
    ELSE      
       BEGIN      
         IF (@JB_STATS =  'INV')      
      SET @ST = 'INV'      
      ELSE      
       IF (@JB_STATS =  'DEL')      
       SET @ST = 'DEL'      
       END      
           
   -- UPDATING THE JOB ACTUAL TABLE PREVIOUS RECORD WITH STATUS AS JOB COMPLETED                
   --SET TRAN ISOLATION LEVEL READ UNCOMMITTED                   
   BEGIN TRAN       
    IF @TMP_ID_TR_SEQ <> 0      
    BEGIN      
     IF @IC_LOGOUT_FLG = 'L'       
     BEGIN       
       UPDATE TBL_TR_JOB_ACTUAL       
       SET DT_CLOCK_OUT = @DT,      
       COMP_PER     = @II_COMP_PER,       
       CO_REAS_CODE = @IV_CO_REAS_CODE,       
       STATUS       = @ST,      
       DT_LOGOUT    = @DT       
       WHERE ID_TR_SEQ    = @TMP_ID_TR_SEQ       
     END      
     ELSE      
     BEGIN       
      UPDATE TBL_TR_JOB_ACTUAL       
      SET DT_CLOCK_OUT = @DT ,--checking      
        COMP_PER     = @II_COMP_PER,      
        CO_REAS_CODE = @IV_CO_REAS_CODE,      
        STATUS       = @ST        
      WHERE ID_TR_SEQ    = @TMP_ID_TR_SEQ       
            
      IF (@CHECK_MECHANIC_ID <> @IV_ID_MEC_TR)      
      BEGIN      
       UPDATE TBL_TR_JOB_ACTUAL       
       SET DT_LOGOUT = DT_CLOCK_OUT --checking      
       WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ       
      END      
     END      
      
     SELECT @IV_ID_WO_PREFIX = ID_WO_PREFIX, @IV_ID_WO_NO_SUFFIX = ID_WO_NO       
     FROM TBL_TR_JOB_ACTUAL       
     WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ      
           
     DECLARE @SPLIT_SEQ AS INT      
        SELECT @SPLIT_SEQ = ISNULL(@II_SPLIT_SEQ_PREV,0)      
              
        IF @SPLIT_SEQ = 0      
        BEGIN      
        SET @SPLIT_SEQ = 0      
        END          ELSE      
        BEGIN      
        SET @SPLIT_SEQ = @II_SPLIT_SEQ_PREV      
        END      
             
        DECLARE @DESC AS VARCHAR(20)      
        DECLARE @DT_PLAN AS DATETIME       
        DECLARE @CURR_DT AS DATETIME      
           
        SELECT @DT_PLAN = DT_PLAN FROM TBL_PLAN_JOB_DETAIL WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
        SELECT @CURR_DT = GETDATE()      
        SELECT @DESC = DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = 'USEDAYPLAN'      
             
       IF DATEDIFF(DAY,@DT_PLAN, GETDATE()) = 0       
       BEGIN      
          IF ((@DESC = 'True'))      
         BEGIN      
              
      DECLARE @CLOCKTIME AS DECIMAL(9,2)      
      DECLARE @TOTTIME AS VARCHAR(10)      
      DECLARE @TOTTIMEDPLAN AS VARCHAR(10)      
      DECLARE @CLKTIMEDPLAN AS DECIMAL(9,2)      
                            
      SELECT @TOTTIME = dbo.SumTimeMechDiffTEMP((@IV_ID_WO_PREFIX + @IV_ID_WO_NO_SUFFIX),@II_ID_JOB_PREV,@IV_ID_MEC_TR)        
      SELECT @CLOCKTIME = CAST((SUM(CAST(CONVERT(INT,SUBSTRING(@TOTTIME,0,CHARINDEX(':',@TOTTIME)))*60 + CONVERT      
      (INT,SUBSTRING(@TOTTIME,CHARINDEX(':',@TOTTIME)+1,LEN(@TOTTIME)))AS DECIMAL(10,2)))/60)      
      AS DECIMAL(10,2))      
          
            
      SELECT @CLKTIMEDPLAN =  CAST(DATEDIFF(MI, PLAN_TIME_FROM, PLAN_TIME_TO)AS DECIMAL(9,2))/60  from TBL_PLAN_JOB_DETAIL where ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
      IF @CLKTIMEDPLAN > @CLOCKTIME      
      BEGIN      
       --**Added to handle a scenario when mechanic clocks out without clocking any time      
       IF @CLOCKTIME = 0.00 AND @TOTTIME='00:00'      
        BEGIN      
         SET @CLOCKTIME = 0.02       
         SET @TOTTIME='00:01'      
        END        
       --**Change End      
       DECLARE @HOURS INT      
       DECLARE @THR INT      
       DECLARE @MINUTES DECIMAL(9,2)      
       DECLARE @MINS DECIMAL(9,2)      
       DECLARE @VALUE  DECIMAL(9,2)      
       DECLARE @MINPART  DECIMAL(9,2)      
       DECLARE @FINALTIME VARCHAR(8)      
       DECLARE @SECHOURS VARCHAR      
       Declare @FITIME varchar(20)      
       SELECT @MINUTES = DATEPART(MI,PLAN_TIME_FROM) FROM TBL_PLAN_JOB_DETAIL WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
       SELECT @HOURS = DATEPART(HH,PLAN_TIME_FROM) FROM TBL_PLAN_JOB_DETAIL WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
       SELECT @MINS = DATEPART(MI,@TOTTIME)      
       SELECT @THR = DATEPART(HH,@TOTTIME)      
       --select '@MINUTES',@MINUTES,'@HOURS',@HOURS,'@MINS',@MINS,'@CLOCKTIME',@CLOCKTIME,'@TOTTIME',@TOTTIME,'@THR',@THR      
       --SELECT @MINS = CAST((@TOTTIME)AS INT)      
      
       IF @MINS > 59      
       BEGIN      
        DECLARE @HRS DECIMAL      
        DECLARE @MS DECIMAL      
        DECLARE @HR INT      
        SELECT @HR = DATEPART(HH,PLAN_TIME_FROM) FROM TBL_PLAN_JOB_DETAIL WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
        DECLARE @MI DECIMAL(9,2)      
        SELECT @MI = DATEPART(MI,PLAN_TIME_FROM) FROM TBL_PLAN_JOB_DETAIL WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
        SELECT @HRS = FLOOR(@MINS / 60 )      
        SELECT @MS = @MINS % 60      
              
        SELECT @VALUE = CONVERT(VARCHAR,(@HOURS + @HRS))+':'+CONVERT(VARCHAR,(@MINUTES+@MS))      
        PRINT @VALUE      
        SELECT @FINALTIME = REPLACE(@VALUE,'.',':')      
        SELECT @HOURS = (@HR + @HRS)       
        SELECT @MINUTES = (@MI+@MS)      
              
        IF (@MINUTES) >= 60      
         BEGIN      
         SELECT @HRS = FLOOR((@MINUTES) / 60 )      
         SELECT @MS = (@MINUTES) % 60      
         SELECT @VALUE = CONVERT(VARCHAR,(@HOURS + @HRS))+':'+CONVERT(VARCHAR,(@MS))      
         SELECT @FINALTIME = REPLACE(@VALUE,'.',':')      
               
        END      
       END      
      ELSE      
       BEGIN      
       IF @MINS %15 <> 0      
          BEGIN      
        SELECT @MINPART =  (15-(@MINS%15.00)+@MINS)%60      
        IF @MINPART = 0.00 AND @MINS>0.00      
         BEGIN      
          SET @THR =  @THR+1      
         END             
          END      
       ELSE      
       IF @MINS > 60       
         BEGIN      
        SELECT @MINPART= @MINS%60      
              
         END      
       ELSE      
       IF @MINS % 15 = 0      
         BEGIN      
              
           SELECT @MINPART= @MINS      
              
               
         END      
        --SELECT @VALUE=((@MINUTES+@MINPART)/60)+@HOURS        
        --**Changed to handle scenarios where present minutes + clocked minutes > 60 (eg. 30+42)      
        SELECT @VALUE=((@MINUTES+@MINPART)/60)        
        IF @VALUE > 1.00      
         BEGIN      
          SET @HOURS=CAST((@VALUE) AS INT)+@HOURS      
         END      
        SET @VALUE=@VALUE+@HOURS      
        --**CHANGE END      
        SELECT @VALUE = @VALUE - CAST((@VALUE) AS INT)      
        --PRINT @VALUE      
              
        IF @VALUE > 0.0      
        BEGIN      
              
        DECLARE @VAL  INT       
        SELECT @VAL = CAST((@VALUE * 60) AS DECIMAL(6,0))      
        --PRINT @VAL      
              
        SELECT @FINALTIME = CONVERT(VARCHAR,(@THR+@HOURS))+':'+CONVERT(VARCHAR,(@VAL))      
        END      
        ELSE      
        BEGIN      
        --select '@HOURS',@HOURS      
        select @VALUE=@THR+@HOURS+((@MINUTES +@MINPART)/60)      
        select @FINALTIME = CAST((@Value)AS VARCHAR(8))      
        SELECT @FINALTIME =  REPLACE(@FINALTIME,'.',':')      
        END      
            
        --SELECT @MINPART= (15-(@MINS%15.00)+@MINS)/60      
        --select @VALUE=(@MINUTES +@MINPART)/60+@HOURS      
        --select @FINALTIME = CAST((@Value)AS VARCHAR(8))      
        --SELECT @FINALTIME =  REPLACE(@FINALTIME,'.',':')      
        --PRINT @FINALTIME      
              
              
      
      END      
       --select '@FINALTIME',@FINALTIME,'@HOURS',@HOURS,'@MINUTES',@MINUTES,'@Value',@Value,'@HR',@HR,'@HRS',@HRS      
       DECLARE @DYNCLKTIME AS VARCHAR(10)      
       DECLARE @COMP_STATUS AS VARCHAR(5)      
       SELECT @DYNCLKTIME = DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = 'USEDYNCLKT'      
       SELECT @COMP_STATUS = @ST       
             
        IF @DYNCLKTIME = 'True'       
         BEGIN      
         IF @COMP_STATUS = 'JCD'      
          BEGIN      
             
          UPDATE TBL_PLAN_JOB_DETAIL      
          SET PLAN_TIME_TO = @FINALTIME      
          WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
            END      
           END      
           ELSE      
           BEGIN      
                UPDATE TBL_PLAN_JOB_DETAIL      
          SET PLAN_TIME_TO = @FINALTIME      
          WHERE  ID_WO_NO_JOB =@IV_ID_WO_NO_SUFFIX and ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV and ID_SPLIT_SEQ =@SPLIT_SEQ      
           END      
                 
      END      
            
            
        END      
      END      
              
     EXECUTE USP_TR_PLAN_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@II_ID_JOB_PREV,@II_SPLIT_SEQ_PREV,@ST,@OV_STATUS                                        
     EXECUTE USP_TR_WO_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@II_ID_JOB_PREV,@II_SPLIT_SEQ_PREV, @ST,@OV_STATUS                      
           
     IF (@IC_LOGOUT_FLG = 'C') AND  (@TMP_ID_TR_SEQ > 0)                                         
     BEGIN       
      IF ((@IV_UNSOLD_TIME IS NOT NULL) AND (@IV_ID_WO_NO IS NULL) AND (@II_ID_JOB IS NULL) AND (@IC_LOGOUT_FLG = 'C'))       
        BEGIN      
        IF (@CHECK_MECHANIC_ID <> @IV_ID_MEC_TR)      
       BEGIN                           
        EXECUTE USP_TIMEREG_DETAIL_INSERT NULL,NULL,@IV_ID_MEC_TR,@SHIFTNO,@DAYSEQ,@LOGSEQ,@IV_UNSOLD_TIME,@DT,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ ---Included DT_LOGIN(@DT) parameter      
       END      
        ELSE      
       BEGIN       
        EXECUTE USP_TIMEREG_DETAIL_INSERT NULL,NULL,@IV_ID_MEC_TR,@SHIFTNO,@DAYSEQ,@LOGSEQ,@IV_UNSOLD_TIME,NULL,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ ---Included DT_LOGIN(@DT) parameter      
       END       
       EXECUTE USP_TR_WO_STATUS_UPDATE NULL,NULL,NULL,@II_SPLIT_SEQ,'JST',@OV_STATUS      
       EXECUTE USP_TR_PLAN_STATUS_UPDATE NULL,NULL,NULL,@II_SPLIT_SEQ,'JST',@OV_STATUS       
       END                                                         
      ELSE       
       BEGIN       
       IF (@CHECK_MECHANIC_ID <> @IV_ID_MEC_TR)      
       BEGIN        
        EXECUTE USP_TIMEREG_DETAIL_INSERT @IV_ID_WO_NO,@II_ID_JOB,@IV_ID_MEC_TR,@SHIFTNO,@ID_DAY_SEQ_PREV,@ID_LOG_SEQ_PREV,NULL,@DT,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ ---Included DT_LOGIN(@DT) parameter      
       END      
       ELSE      
       BEGIN      
        EXECUTE USP_TIMEREG_DETAIL_INSERT @IV_ID_WO_NO,@II_ID_JOB,@IV_ID_MEC_TR,@SHIFTNO,@ID_DAY_SEQ_PREV,@ID_LOG_SEQ_PREV,NULL,NULL,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS ,@ID_WO_LAB_SEQ---Included DT_LOGIN(@DT) parameter      
       END      
       EXECUTE USP_TR_WO_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX_CUR,@IV_ID_WO_PREFIX_CUR,@II_ID_JOB,@II_SPLIT_SEQ,'JST',@OV_STATUS                                    
       EXECUTE USP_TR_PLAN_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX_CUR,@IV_ID_WO_PREFIX_CUR,@II_ID_JOB,@II_SPLIT_SEQ,'JST',@OV_STATUS                                                                  
      END      
            
              END      
                         
      DECLARE @JOBCNT AS INT       
      DECLARE @COMPJOBCNT AS INT       
                                      
      SELECT @JOBCNT=COUNT(*)      
      FROM TBL_WO_DETAIL       
      WHERE ID_WO_NO     = @IV_ID_WO_NO_SUFFIX       
      AND ID_WO_PREFIX = @IV_ID_WO_PREFIX       
      AND JOB_STATUS <> 'DEL'      
           
      print 'jobcount'      
      print @JOBCNT      
                                      
      SELECT @COMPJOBCNT=COUNT(*)                                         
      FROM TBL_WO_DETAIL                                         
      WHERE ID_WO_NO     = @IV_ID_WO_NO_SUFFIX       
      AND ID_WO_PREFIX = @IV_ID_WO_PREFIX       
      AND JOB_STATUS   = 'JCD'                                        
      
      print 'completed'      
      print @COMPJOBCNT      
          
      IF (@JOBCNT > 0)  AND (@COMPJOBCNT > 0)  AND (@JOBCNT = @COMPJOBCNT)                                       
       UPDATE TBL_WO_HEADER                                        
       SET WO_STATUS  = 'JCD'                                      
       WHERE   ID_WO_NO     = @IV_ID_WO_NO_SUFFIX       
       AND ID_WO_PREFIX = @IV_ID_WO_PREFIX                                    
                                  
     END                                        
     ELSE                                        
     BEGIN                          
      IF  (@IC_LOGOUT_FLG = 'C')  AND (@TMP_ID_TR_SEQ = 0)           
      BEGIN                                              
       IF ((@IV_UNSOLD_TIME IS NOT NULL) AND (@IV_ID_WO_NO IS NULL) AND (@II_ID_JOB IS NULL) AND (@IC_LOGOUT_FLG = 'C'))                                        
       BEGIN  --CHECK FOR UNSOLD                                                
        SET     @TMP_DAY_SEQ = NULL                                        
        EXECUTE USP_TR_GETDAY_SEQ @TMP_DAY_SEQ OUTPUT                      
                                         
        SET     @TMP_LOG_SEQ = NULL                                        
        EXECUTE USP_TR_GETLOG_SEQ @TMP_LOG_SEQ OUTPUT                        
        EXECUTE USP_TIMEREG_DETAIL_INSERT NULL,NULL,@IV_ID_MEC_TR,@SHIFTNO,@DAYSEQ,@TMP_LOG_SEQ,@IV_UNSOLD_TIME,@DT,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ                                        
       END                                     
       ELSE                                        
       BEGIN       
        SET     @TMP_LOG_SEQ = NULL                                        
        EXECUTE USP_TR_GETLOG_SEQ @TMP_LOG_SEQ OUTPUT                        
        EXECUTE USP_TIMEREG_DETAIL_INSERT @IV_ID_WO_NO,@II_ID_JOB,@IV_ID_MEC_TR,@SHIFTNO,@DAYSEQ,@TMP_LOG_SEQ,NULL,@DT,@DT,@II_SPLIT_SEQ,'JST',@IV_CREATED_BY,@OV_STATUS,@ID_WO_LAB_SEQ                                             
              
        SELECT @IV_ID_WO_PREFIX_CUR    =ID_WO_PREFIX,@IV_ID_WO_NO_SUFFIX_CUR = ID_WO_NO                                        
        FROM VW_WORKORDER_HEADER                                        
        WHERE LTRIM(RTRIM(WO_NUMBER)) = LTRIM(RTRIM(@IV_ID_WO_NO))                                        
              
        IF @II_SPLIT_SEQ IS NULL                       
        BEGIN                      
         SET @II_SPLIT_SEQ = 0        
        END                      
        EXECUTE USP_TR_PLAN_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX_CUR,@IV_ID_WO_PREFIX_CUR,@II_ID_JOB,@II_SPLIT_SEQ,'JST',@OV_STATUS                                        
        EXECUTE USP_TR_WO_STATUS_UPDATE @IV_ID_WO_NO_SUFFIX_CUR,@IV_ID_WO_PREFIX_CUR,@II_ID_JOB,@II_SPLIT_SEQ,'JST',@OV_STATUS                                        
       END                                        
      END                         
     END                                      
                  
    SELECT @@ERROR                                    
    /*checking*/      
    BEGIN          
    IF (@CHECK_MECHANIC_ID <> @IV_ID_MEC_TR)      
    begin      
     SELECT @IV_ID_MEC_TR = id_mec_tr FROM TBL_TR_JOB_ACTUAL WHERE ID_TR_SEQ=@TMP_ID_TR_SEQ      
    IF  (@IV_CO_REAS_CODE IS NULL and (@TMP_ID_TR_SEQ is not null or @TMP_ID_TR_SEQ<>0))        
     SELECT @IV_CO_REAS_CODE = (SELECT TOP 1 ID_SETTINGS FROM TBL_MAS_SETTINGS WHERE ID_CONFIG='TR-COUT' and FLAG=1)      
    end      
    END      
    /*checking*/      
    IF @@ERROR = 0                                     
    BEGIN                               
     DECLARE @ID_WO_DETSEQ AS INT       
     DECLARE @FLAG_STD AS BIT          
     DECLARE @DEC_FIX_PRI AS DECIMAL 
      IF (@II_ID_JOB_PREV IS NULL )    
       BEGIN
           SET @II_ID_JOB_PREV = @II_ID_JOB
       END
     
                                 
     SELECT @ID_WO_DETSEQ = ID_WODET_SEQ,      
       @FLAG_STD  = FLG_CHRG_STD_TIME,      
       @DEC_FIX_PRI = WO_FIXED_PRICE        
     FROM TBL_WO_DETAIL       
     WHERE ID_WO_NO  = @IV_ID_WO_NO_SUFFIX                                     
       AND  ID_WO_PREFIX = @IV_ID_WO_PREFIX                              
       AND  ID_JOB   = @II_ID_JOB_PREV                                    
                                 
     IF @FLAG_STD = 'FALSE' OR @DEC_FIX_PRI = 0.00                       
     BEGIN         
      DECLARE @CLOCKEDTIME AS DECIMAL(9,2)      
      DECLARE @TIME1 AS VARCHAR(10)      
                            
      SELECT @TIME1 = dbo.SumTimeMechDiffTEMP((@IV_ID_WO_PREFIX + @IV_ID_WO_NO_SUFFIX),@II_ID_JOB_PREV,@IV_ID_MEC_TR)        
      SELECT @CLOCKEDTIME = CAST((SUM(CAST(CONVERT(INT,SUBSTRING(@TIME1,0,CHARINDEX(':',@TIME1)))*60 + CONVERT      
      (INT,SUBSTRING(@TIME1,CHARINDEX(':',@TIME1)+1,LEN(@TIME1)))AS DECIMAL(10,2)))/60)      
      AS DECIMAL(10,2))      
        
     
                                  
      UPDATE TBL_WO_LABOUR_DETAIL                                    
      SET  --WO_LABOUR_HOURS = @CLOCKEDTIME,
      ID_LOGIN = @IV_ID_MEC_TR          
         WHERE  ID_WODET_SEQ = @ID_WO_DETSEQ 
         --AND ID_LOGIN= @IV_ID_MEC_TR 
         AND ID_WOLAB_SEQ = @ID_WO_LAB_SEQ                              
     END      
             
       --select 'before cnt seq',@IV_UNSOLD_TIME,@TMP_ID_TR_SEQ,@IV_CO_REAS_CODE,@IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX      
                                         
     IF (len(ltrim(rtrim(@IV_UNSOLD_TIME))) = 0 or @IV_UNSOLD_TIME is null OR @TMP_ID_TR_SEQ <> 0) AND len(ltrim(rtrim(@IV_CO_REAS_CODE))) > 0 /*AND @ST = 'JCD'*/                                    
      AND isnull(@IV_ID_WO_NO_SUFFIX,'') <> '' AND isnull(@IV_ID_WO_PREFIX,'') <> ''                      
     BEGIN                                      
      DECLARE @CNT_SEQ AS INT                                    
      SELECT @CNT_SEQ = COUNT(ID_WODET_SEQ) FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ = @ID_WO_DETSEQ                                    
        --and ID_LOGIN = @IV_ID_MEC_TR
         AND ID_WOLAB_SEQ = @ID_WO_LAB_SEQ     
              
      DECLARE @VAT_MCODE AS INT      
      SELECT @VAT_MCODE = ID_SETTINGS       
      FROM TBL_MAS_SETTINGS MAS       
      INNER JOIN TBL_MAS_MAKE MAK       
      ON  MAS.[DESCRIPTION] = MAKE_VATCODE AND ID_CONFIG = 'VAT'       
      INNER JOIN TBL_MAS_VEHICLE VH ON VH.ID_MAKE_VEH = MAK.ID_MAKE       
      INNER JOIN TBL_WO_HEADER ON ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO      
      WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX          
           
      DECLARE @MakePcd varchar(30),@MechPcd varchar(10),@RepPkgPCD varchar(10),@CustPcd varchar(10), @VehGrpPcd varchar(10), @JobPcd varchar(10),@VehVatCode VARCHAR(10),@CustVATCode VARCHAR(10), @VATPer DECIMAL(5,2)              
      SELECT @MechPcd = MAX(ID_MECPCD) FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @IV_ID_MEC_TR                    
      
      --Query for Fetching other then Vehicle Group ID                
      SELECT                     
       @MakePcd=ID_MAKE,                            
       @CustPcd = ID_CUSTOMER,                    
       @VehVatCode = ISNULL(mv.ID_VAT_CD,@VAT_MCODE),                    
       @CustVATCode = mcg.ID_VAT_CD       
       ,@WO_CREATED_BY=wh.CREATED_BY                   
      FROM                     
       TBL_WO_HEADER wh                     
       JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                     
       JOIN TBL_MAS_MAKE mm ON mm.ID_MAKE = mv.ID_MAKE_VEH                          
       JOIN TBL_MAS_CUSTOMER mc ON mc.ID_CUSTOMER = wh.ID_CUST_WO                    
       JOIN TBL_MAS_CUST_GROUP mcg ON mcg.ID_CUST_GRP_SEQ = mc.ID_CUST_GROUP                     
      WHERE                     
       wh.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                    
       AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX              
      
      --Query for Fetching  Vehicle Group ID              
      SELECT @VehGrpPcd = VH_GROUP_ID                   
      FROM TBL_WO_HEADER wh                     
      JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                     
      JOIN TBL_MAS_VHGROUPPC mvgp ON mv.ID_GROUP_VEH = mvgp.VH_GROUP_ID                    
      WHERE  wh.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                    
      AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX              
           
      
      SELECT @RepPkgPCD = ID_RPKG_SEQ,@JobPcd = ID_JOBPCD_WO       
      FROM TBL_WO_DETAIL wd      
      JOIN TBL_WO_HEADER wh ON wh.ID_WO_NO =  wd.ID_WO_NO       
      AND wh.ID_WO_PREFIX = wd.ID_WO_PREFIX                    
      LEFT JOIN TBL_MAS_REP_PACKAGE mrp ON mrp.ID_RPKG_SEQ = wd.ID_RPG_CODE_WO                    
      WHERE wh.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                    
      AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                    
      AND wd.ID_JOB = @II_ID_JOB_PREV                    
      
      
      DECLARE @HOURLYPRICE DECIMAL(11,2),@HPVAT VARCHAR(500)                    
      EXEC [USP_WO_GetHPPrice] @WO_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE OUTPUT, @HPVAT OUTPUT                  
      SELECT @MakePcd, @CustPcd,@RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE , @HPVAT,'TEST'                     
      SELECT TOP 1 @VATPer = VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = @CustVATCode AND VAT_VEH = @VehVatCode AND VAT_ITEM = @HPVAT                    
      AND DT_EFF_TO = '9999-12-31 23:59:59.000' Order by DT_EFF_FROM DESC                                    
                          
                  --select '@CNT_SEQ',@CNT_SEQ        
                    --Added to fetch correct vat percentage,vatcode and vatacccode      
        SELECT @DepID=ID_Dept_User FROM TBL_MAS_USERS               
        WHERE ID_Login=@WO_CREATED_BY        
        SELECT  @iv_ID_MAKE_PC_HP=ID_MAKE_PRICECODE  FROM  TBL_MAS_MAKE  WHERE  ID_MAKE=@MakePcd          
        select @CUS_PC  = ID_CUST_PC_CODE FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@CustPcd       
        SELECT  @iv_ID_VEHGRP_PC_HP=VH_GROUP_PRICECODE FROM  TBL_MAS_VHGROUPPC  WHERE VH_GROUP_ID=@VehGrpPcd             
        SELECT  @RP_CODE = ID_RP_PRC_GRP FROM TBL_MAS_REP_PACKAGE  WHERE ID_RPKG_SEQ = @RepPkgPCD 
               
            
      IF @CNT_SEQ > 0                      
      BEGIN             
       UPDATE TBL_WO_LABOUR_DETAIL                          
       SET        
       --WO_HOURLEY_PRICE = @HOURLYPRICE,          
       WO_VAT_CODE = (Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE  ID_DEPT_HP = @DepID                 
             AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                  
             AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                  
             AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                  
             AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                  
             AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                
             AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')                
             AND DT_EFF_TO is null )     ,                          
       WO_VAT_ACCCODE = (SELECT VAT_ACCCODE FROM TBL_VAT_DETAIL WHERE VAT_CUST = (SELECT       
           CASE WHEN ID_CUST_WO IS NOT NULL THEN                                              
            (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ =                                              
            (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = TBL_WO_HEADER.ID_CUST_WO ))                                              
           END                                              
           FROM TBL_WO_HEADER                                              
           WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX  AND ID_WO_PREFIX = @IV_ID_WO_PREFIX )      
           AND VAT_VEH  = (SELECT                                            
               CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                              
                (SELECT ISNULL(ID_VAT_CD,@VAT_MCODE) FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                              
               END                                              
              FROM TBL_WO_HEADER                
              WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX  )                                              
              AND VAT_ITEM = (Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE               
                    ID_DEPT_HP = @DepID                 
                    AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                  
                    AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                  
                    AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                  
                    AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                  
                    AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                
                    AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')                
                    AND DT_EFF_TO is null     )           
              and getdate() between dt_eff_from and dt_eff_to ),      
       WO_LABOUR_ACCOUNTCODE =  (SELECT TOP 1 HP_ACC_CODE FROM  TBL_MAS_HP_RATE WHERE  DT_EFF_FROM = (SELECT   MAX(DT_EFF_FROM)                                                           
               FROM   TBL_MAS_HP_RATE where  ID_MECHPCD_HP = (SELECT TOP 1 ID_MECPCD FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC =  @IV_ID_MEC_TR))ORDER BY ID_HP_SEQ DESC),                          
       WO_LABOURVAT_PERCENTAGE = (SELECT TOP 1 VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST =               
               (SELECT                   
                CASE WHEN TBL_WO_HEADER.ID_CUST_WO IS NOT NULL THEN                                           
                 (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ =                                              
                 (SELECT ID_CUST_GROUP FROM TBL_MAS_CUSTOMER                                           
                 WHERE ID_CUSTOMER = WODEBDET.ID_JOB_DEB ))                                              
                END                                              
               FROM TBL_WO_HEADER INNER JOIN TBL_WO_DETAIL WODET       
               ON TBL_WO_HEADER.ID_WO_NO= WODET.ID_WO_NO       
               AND TBL_WO_HEADER.ID_WO_PREFIX = WODET.ID_WO_PREFIX                         
               INNER JOIN TBL_WO_DEBITOR_DETAIL WODEBDET                
               ON WODET.ID_WO_NO = WODEBDET.ID_WO_NO       
               AND WODET.ID_WO_PREFIX = WODEBDET.ID_WO_PREFIX       
               AND WODET.ID_JOB= WODEBDET.ID_JOB_ID        
               AND WODEBDET.DEBITOR_TYPE = 'C' AND DBT_PER > 0.00                                                       
               WHERE TBL_WO_HEADER.ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND       
               TBL_WO_HEADER.ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_JOB = @II_ID_JOB_PREV)                                              
               AND ISNULL(CONVERT(VARCHAR,VAT_VEH),'-')  = (SELECT                                            
               CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                              
                (SELECT ISNULL(ID_VAT_CD,@VAT_MCODE) FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                              
               END                                              
              FROM TBL_WO_HEADER                                           
              WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX  )                                                     
              AND ISNULL(CONVERT(VARCHAR,VAT_ITEM),'-') = (Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE               
                            ID_DEPT_HP = @DepID                 
                            AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                  
                            AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                  
                            AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                  
                            AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                  
                          AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                
                            AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')                
                            AND DT_EFF_TO is null     ))                                              
       WHERE  ID_WODET_SEQ = @ID_WO_DETSEQ AND ID_WOLAB_SEQ = @ID_WO_LAB_SEQ                                    
      END                                    
      
      ELSE                                    
      BEGIN       
       --SELECT 'Inside else'      
       SELECT                                       
        @IV_ID_WO_PREFIX    =ID_WO_PREFIX,                                         
        @IV_ID_WO_NO_SUFFIX = ID_WO_NO   ,                    
        @II_ID_JOB_PREV=ID_JOB                             
       FROM                                       
        TBL_TR_JOB_ACTUAL                                      
       WHERE                                       
        ID_TR_SEQ = @TMP_ID_TR_SEQ                       
                     
             
       SELECT @MechPcd = MAX(ID_MECPCD) FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC = @IV_ID_MEC_TR                    
             
       SELECT                     
        @MakePcd=ID_MAKE,                     
        @CustPcd = ID_CUSTOMER,                    
        @VehVatCode = ISNULL(mv.ID_VAT_CD,@VAT_MCODE),                    
        @CustVATCode = mcg.ID_VAT_CD                    
       FROM                     
        TBL_WO_HEADER wh              
        JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                     
        JOIN TBL_MAS_MAKE mm ON mm.ID_MAKE = mv.ID_MAKE_VEH                            
        JOIN TBL_MAS_CUSTOMER mc ON mc.ID_CUSTOMER = wh.ID_CUST_WO                    
        JOIN TBL_MAS_CUST_GROUP mcg ON mcg.ID_CUST_GRP_SEQ = mc.ID_CUST_GROUP                     
       WHERE                     
        wh.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                    
        AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX              
      
       --Query for Fetching  Vehicle Group ID              
       SELECT        
        @VehGrpPcd = VH_GROUP_ID,@WO_CREATED_BY=wh.CREATED_BY                   
       FROM                     
        TBL_WO_HEADER wh                     
        JOIN TBL_MAS_VEHICLE mv ON wh.ID_VEH_SEQ_WO = mv.ID_VEH_SEQ                     
        JOIN TBL_MAS_VHGROUPPC mvgp ON mv.ID_GROUP_VEH = mvgp.VH_GROUP_ID                    
       WHERE                     
        wh.ID_WO_NO = @IV_ID_WO_NO_SUFFIX                    
        AND wh.ID_WO_PREFIX = @IV_ID_WO_PREFIX                     
      
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
        AND wd.ID_JOB = @II_ID_JOB_PREV                    
      
       EXEC [USP_WO_GetHPPrice] @WO_CREATED_BY, @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE OUTPUT, @HPVAT OUTPUT        
       SELECT @MakePcd, @CustPcd, @RepPkgPCD, @JobPcd, @VehGrpPcd, @MechPcd ,@HOURLYPRICE , @HPVAT,'TEST'                     
       SELECT TOP 1 @VATPer = VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = @CustVATCode AND VAT_VEH = @VehVatCode AND VAT_ITEM = @HPVAT                    
       AND DT_EFF_TO = '9999-12-31 23:59:59.000' Order by DT_EFF_FROM DESC                   
      
       --Select 'TBL_WO_LABOUR_DETAIL',@IV_ID_WO_NO_SUFFIX,@IV_ID_WO_PREFIX,@II_ID_JOB_PREV      
       --Added to fetch correct vat percentage,vatcode and vatacccode      
       SELECT @DepID=ID_Dept_User FROM TBL_MAS_USERS               
          WHERE ID_Login=@WO_CREATED_BY        
       SELECT  @iv_ID_MAKE_PC_HP=ID_MAKE_PRICECODE  FROM  TBL_MAS_MAKE  WHERE  ID_MAKE=@MakePcd          
       SELECT @CUS_PC  = ID_CUST_PC_CODE FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER=@CustPcd       
       SELECT  @iv_ID_VEHGRP_PC_HP=VH_GROUP_PRICECODE FROM  TBL_MAS_VHGROUPPC  WHERE VH_GROUP_ID=@VehGrpPcd             
       SELECT  @RP_CODE = ID_RP_PRC_GRP FROM TBL_MAS_REP_PACKAGE  WHERE ID_RPKG_SEQ = @RepPkgPCD       
       ---------Hourly Price and labour vat -------------                    
       DECLARE @CLOCKEDTIME1 AS DECIMAL(9,2)      
       DECLARE @TIME2 AS VARCHAR(10)      
       IF (@IV_ID_WO_NO_SUFFIX IS NOT NULL AND @IV_ID_WO_PREFIX IS NOT NULL AND @II_ID_JOB_PREV IS NOT NULL)       
       BEGIN      
        SELECT @TIME2 = dbo.SumTimeMechDiffTEMP((@IV_ID_WO_PREFIX + @IV_ID_WO_NO_SUFFIX),@II_ID_JOB_PREV,@IV_ID_MEC_TR)        
        SELECT @CLOCKEDTIME1 = CAST((SUM(CAST(CONVERT(INT,SUBSTRING(@TIME2,0,CHARINDEX(':',@TIME2)))*60 + CONVERT      
        (INT,SUBSTRING(@TIME2,CHARINDEX(':',@TIME2)+1,LEN(@TIME2)))AS DECIMAL(10,2)))/60)      
        AS DECIMAL(10,2))      
       END      

       update TBL_WO_LABOUR_DETAIL                               
       set        
       WO_LABOURVAT_PERCENTAGE = (SELECT TOP 1 VAT_PER FROM TBL_VAT_DETAIL WHERE VAT_CUST = (SELECT                   
              CASE WHEN TBL_WO_HEADER.ID_CUST_WO IS NOT NULL THEN                                           
               (SELECT ID_VAT_CD FROM TBL_MAS_CUST_GROUP WHERE ID_CUST_GRP_SEQ = (SELECT ID_CUST_GROUP       
               FROM TBL_MAS_CUSTOMER WHERE ID_CUSTOMER = WODEBDET.ID_JOB_DEB ))                                              
              END                                              
              FROM TBL_WO_HEADER INNER JOIN TBL_WO_DETAIL WODET       
              ON TBL_WO_HEADER.ID_WO_NO= WODET.ID_WO_NO       
              AND TBL_WO_HEADER.ID_WO_PREFIX = WODET.ID_WO_PREFIX                         
              INNER JOIN TBL_WO_DEBITOR_DETAIL WODEBDET                
              ON WODET.ID_WO_NO = WODEBDET.ID_WO_NO       
              AND WODET.ID_WO_PREFIX = WODEBDET.ID_WO_PREFIX       
              AND WODET.ID_JOB= WODEBDET.ID_JOB_ID         
              AND WODEBDET.DEBITOR_TYPE = 'C' AND DBT_PER > 0.00                                                         
              WHERE TBL_WO_HEADER.ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND TBL_WO_HEADER.ID_WO_PREFIX = @IV_ID_WO_PREFIX       
              AND ID_JOB = @II_ID_JOB_PREV) AND ISNULL(CONVERT(VARCHAR,VAT_VEH),'-')  = (SELECT                                            
               CASE WHEN ID_VEH_SEQ_WO IS NOT NULL THEN                                              
                (SELECT ISNULL(ID_VAT_CD,@VAT_MCODE) FROM TBL_MAS_VEHICLE WHERE ID_VEH_SEQ = TBL_WO_HEADER.ID_VEH_SEQ_WO)                                              
               END                                              
              FROM TBL_WO_HEADER                                           
              WHERE ID_WO_NO = @IV_ID_WO_NO_SUFFIX AND ID_WO_PREFIX =  @IV_ID_WO_PREFIX  )                          
              AND ISNULL(CONVERT(VARCHAR,VAT_ITEM),'-') = (Select Top 1 HP_Vat FROM TBL_MAS_HP_RATE WHERE               
                           ID_DEPT_HP = @DepID                 
                           AND  isnull(ID_MAKE_HP,'0') =isnull(@iv_ID_MAKE_PC_HP,'0')                  
                           AND  isnull(ID_MECHPCD_HP,'0') = isnull(@MechPcd,'0')                  
                           AND  isnull(ID_RPPCD_HP,'0') =isnull(@RP_CODE,'0')                  
                           AND  isnull(ID_CUSTPCD_HP,'0') =isnull(@CUS_PC,'0')                  
                           AND  isnull(ID_VEHGRP_HP,'0') =isnull(@iv_ID_VEHGRP_PC_HP,'0')                
                           AND  isnull(ID_JOBPCD_HP,'0') =isnull(@JobPcd,'0')                
                           AND DT_EFF_TO is null     )      
              AND DT_EFF_TO >= GETDATE())                                
       WHERE  ID_WODET_SEQ = @ID_WO_DETSEQ AND ID_WOLAB_SEQ = @ID_WO_LAB_SEQ                       
      END                        
     END                                    
     PRINT @ID_WO_DETSEQ                     
     SELECT WO_HOURLEY_PRICE,WO_VAT_CODE,WO_VAT_ACCCODE,WO_LABOUR_ACCOUNTCODE,WO_LABOURVAT_PERCENTAGE                                     
     FROM TBL_WO_LABOUR_DETAIL   WHERE  ID_WODET_SEQ = @ID_WO_DETSEQ AND ID_WOLAB_SEQ = @ID_WO_LAB_SEQ                                    
      
     IF @IC_LOGOUT_FLG = 'C'      
     BEGIN      
      UPDATE TBL_PLAN_JOB_DETAIL       
      SET PLAN_TIME_FROM = CAST(CONVERT(VARCHAR(8), GETDATE(), 108) AS CHAR(5))      
      WHERE ID_WO_PREFIX = @IV_ID_WO_PREFIX_CUR AND ID_WO_NO_JOB = @IV_ID_WO_NO_SUFFIX_CUR       
      AND ID_JOB = @II_ID_JOB AND ID_MEC_PLAN = @IV_ID_MEC_TR AND SRC_INITIATION = 'W'      
     END      
     IF @IC_LOGOUT_FLG = 'L'      
     BEGIN        
      UPDATE TBL_PLAN_JOB_DETAIL SET PLAN_TIME_TO = CAST(CONVERT(VARCHAR(8), GETDATE(), 108) AS CHAR(5))      
      WHERE ID_WO_PREFIX = @IV_ID_WO_PREFIX AND ID_WO_NO_JOB = @IV_ID_WO_NO_SUFFIX       
      AND ID_JOB = @II_ID_JOB_PREV AND ID_MEC_PLAN = @IV_ID_MEC_TR AND SRC_INITIATION = 'W'      
     END      

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
           
     IF @TMP_ID_TR_SEQ <> 0      
     BEGIN      
      DECLARE @WO_NO AS VARCHAR(10)      
      SELECT @WO_NO = ID_WO_NO FROM TBL_TR_JOB_ACTUAL WHERE ID_TR_SEQ = @TMP_ID_TR_SEQ      
      IF @WO_NO IS NOT NULL      
      BEGIN      
       EXEC USP_TR_UPDATE_WO_DETAILS @TMP_ID_TR_SEQ , @IV_CREATED_BY       
      END      
     END      
        
     if @@Error>0                                  
      ROLLBACK TRAN                                      
     else                                  
      COMMIT TRAN                                
     SET @OV_STATUS=0                                      
   END                                       
  END                                        
 END                              
  SET @OV_STATUS = @@ERROR          
                                    
END                       
                                      
             

GO

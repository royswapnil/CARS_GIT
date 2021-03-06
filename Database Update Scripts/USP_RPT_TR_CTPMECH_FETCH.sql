/****** Object:  StoredProcedure [dbo].[USP_RPT_TR_CTPMECH_FETCH]    Script Date: 2/7/2018 2:51:31 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_RPT_TR_CTPMECH_FETCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_RPT_TR_CTPMECH_FETCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_RPT_TR_CTPMECH_FETCH]    Script Date: 2/7/2018 2:51:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_RPT_TR_CTPMECH_FETCH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_RPT_TR_CTPMECH_FETCH] AS' 
END
GO
-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
ALTER PROCEDURE [dbo].[USP_RPT_TR_CTPMECH_FETCH]            
(            
 @IV_FROM_DATE  varchar(30) = NULL,            
 @IV_TO_DATE   varchar(30)= NULL,            
 @IV_MECH_CODE  VARCHAR(20)= Null,            
 @IV_MECH_NAME  VARCHAR(20)= NULL,         
 @IV_ID_MR INT = 0,        
 @IV_ID_DEPT INT = NULL,         
 @IV_ID_WO_NO  VARCHAR(10)=NULL,            
 @IV_ID_JOB   INT =NULL,
 @IV_FLG_ORDERS BIT = 0,           
 @IV_FLG_UNSOLD BIT = 0           
)            
            
AS             
BEGIN            
 --set @IV_ID_WO_NO =substring(@IV_ID_WO_NO,3,len(@IV_ID_WO_NO))                
 DECLARE @EXECQUERY1 AS NVARCHAR(MAX)         
 DECLARE @EXECQUERY2 AS NVARCHAR(MAX)         
 DECLARE @EXECQUERY3 AS NVARCHAR(MAX)        
 DECLARE @SUBQUERY AS NVARCHAR(MAX)                
 DECLARE @WHRQRY1 AS NVARCHAR(MAX)                
 DECLARE @WHRQRY2 AS NVARCHAR(MAX)               
 DECLARE @WHRQRY3 AS NVARCHAR(MAX)               
 DECLARE @MAINSQL AS NVARCHAR(MAX)               
 DECLARE @IV_FROM_DATE_NEW AS VARCHAR(10)              
 DECLARE @IV_TO_DATE_NEW AS VARCHAR(10)           
         
 DECLARE @FLG_LUNCHWITHDRAW AS BIT        
         
 SELECT @FLG_LUNCHWITHDRAW = LUNCH_WITHDRAW FROM TBL_MAS_DEPT WHERE ID_DEPT = @IV_ID_DEPT        
 PRINT @FLG_LUNCHWITHDRAW        
         
 DECLARE @START_MIN AS VARCHAR(10)        
 DECLARE @END_MIN AS VARCHAR(10)        
         
 SELECT @START_MIN = FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = @IV_ID_DEPT          
 SELECT @END_MIN = TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = @IV_ID_DEPT         
         
 IF @START_MIN IS NULL         
  SET @START_MIN = '0'        
         
 IF @END_MIN IS NULL         
  SET @END_MIN = '0'        
        
 IF @IV_ID_JOB=0      
   SET @IV_ID_JOB = NULL    
     
           
 IF @IV_MECH_CODE=NULL      
   SET @IV_MECH_NAME = NULL        
          
  --dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT) AS ''CLOCKED TIME'',                
         
 SET @EXECQUERY1 = 'SELECT DISTINCT ID_TR_SEQ AS ''ID_TR'',        
 ID_MEC_TR as ''ID_MEC'',        
 CASE WHEN ID_MEC_TR IS NOT NULL THEN        
  (SELECT FIRST_NAME FROM TBL_MAS_USERS WHERE ID_LOGIN =TBL_TR_JOB_ACTUAL.ID_MEC_TR)         
 ELSE         
  '' ''        
 END AS ''Mech_Name'',        
 ID_WO_PREFIX + ID_WO_NO AS ''ORDER ID'',        
 ID_JOB AS ''JOB ID'',          
 CASE WHEN ID_UNSOLD_TIME IS NOT NULL THEN          
  (SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = TBL_TR_JOB_ACTUAL.ID_UNSOLD_TIME)                
 ELSE            
  '' ''          
 END AS ''UNSOLD TIME'',        
 CASE WHEN ID_JOB IS NOT NULL THEN        
  (SELECT DESCRIPTION FROM TBL_MAS_SETTINGS INNER JOIN TBL_WO_DETAIL ON ID_SETTINGS = ID_WORK_CODE_WO AND ID_CONFIG = ''RP-WC''        
  WHERE ID_WO_PREFIX + ID_WO_NO = TBL_TR_JOB_ACTUAL.ID_WO_PREFIX + TBL_TR_JOB_ACTUAL.ID_WO_NO         
  AND ID_JOB = TBL_TR_JOB_ACTUAL.ID_JOB)         
 ELSE            
  '' ''          
 END AS ''WORK CODE'',          
 CONVERT (VARCHAR (12), DT_CLOCK_IN , 8) AS ''CLOCK IN TIME'',                
 DT_CLOCK_IN ''CLOCK IN DATE'',                
 CONVERT (VARCHAR(12), DT_CLOCK_OUT, 8) AS ''CLOCK OUT TIME'',                
 DT_CLOCK_OUT AS ''CLOCK OUT DATE'',                
 CASE WHEN ID_JOB IS NOT NULL THEN                 
  (SELECT WO_STD_TIME FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX + ID_WO_NO = TBL_TR_JOB_ACTUAL.ID_WO_PREFIX + TBL_TR_JOB_ACTUAL.ID_WO_NO AND ID_JOB = TBL_TR_JOB_ACTUAL.ID_JOB)                
 ELSE                
  '' ''                
 END AS ''STANDARD TIME'',        
 CASE WHEN (ID_JOB IS NOT NULL) AND (SELECT JOB_STATUS FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX + ID_WO_NO = TBL_TR_JOB_ACTUAL.ID_WO_PREFIX + TBL_TR_JOB_ACTUAL.ID_WO_NO AND ID_JOB = TBL_TR_JOB_ACTUAL.ID_JOB) = ''INV'' AND ''1''=''0'' THEN         
  dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)        
 ELSE        
  CASE WHEN '+ CONVERT(VARCHAR(5),ISNULL(@FLG_LUNCHWITHDRAW,0))+' = 1 THEN           
   CASE WHEN  ID_SHIFT_NO IS NOT NULL THEN             
    CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)) OR         
      ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)))) THEN        
     dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)          
    ELSE        
     CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))         
      AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))        
      AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) <= (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN        
       dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' '' + (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)))          
     WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))        
      AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN        
       ''00:00'''        
             
  SET @EXECQUERY2 =         
    ' WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))        
      AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN        
       dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' '' +  (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)),DT_CLOCK_OUT)           
     WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))         
      AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) THEN        
       DBO.[FNADDMINS](dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' '' +  (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO))) ,   
       
       dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' '' +  (SELECT  CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)),DT_CLOCK_OUT))           
     ELSE        
      dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)        
     END          
    END        
   ELSE         
    CASE WHEN '''+ CONVERT(VARCHAR(5),@START_MIN)+'''' + ' <> ''0'' AND  '''+ CONVERT(VARCHAR(5),@END_MIN)+''''+' <> ''0'' THEN         
     CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < ''' + CONVERT(VARCHAR(5),@START_MIN) + ''') OR         
      ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > ''' + CONVERT(VARCHAR(5),@END_MIN) + '''))) THEN        
       dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)        
     ELSE        
      CASE WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < ''' + CONVERT(VARCHAR(5),@START_MIN) + ''') AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8)) > ''' + CONVERT(VARCHAR(5),@START_MIN) + ''' AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8)) <= ''' + CONVERT(VARCHAR(5),@END_MIN) + ''') THEN        
       dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' ' + CONVERT(VARCHAR(5),@START_MIN) + '''))          
      WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > ''' + CONVERT(VARCHAR(5),@START_MIN) + ''') AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) < ''' + CONVERT(VARCHAR(5),@END_MIN) + ''')) THEN        
       ''00:00''        
      WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > ''' + CONVERT(VARCHAR(5),@START_MIN) + ''') AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > ''' + CONVERT(VARCHAR(5),@END_MIN) + ''')) THEN        
       dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' ' + CONVERT(VARCHAR(5),@END_MIN) + '''),DT_CLOCK_OUT)           
      WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) < ''' + CONVERT(VARCHAR(5),@START_MIN) + ''') AND (CONVERT(VARCHAR(5),DT_CLOCK_OUT,8) > ''' + CONVERT(VARCHAR(5),@END_MIN) + ''')) THEN        
       DBO.[FNADDMINS](dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' ' + CONVERT(VARCHAR(5),@START_MIN) + ''')) ,          
       dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + '' ' + CONVERT(VARCHAR(5),@END_MIN) + '''),DT_CLOCK_OUT))           
      ELSE        
       dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)        
      END         
     END        
    ELSE        
      dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT) '        
SET @EXECQUERY3=        
    ' END            
   END        
  ELSE        
   dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)        
  END        
 END AS ''CLOCKED TIME'',        
 ID_SHIFT_NO as ShiftNo,        
 CASE WHEN ID_SHIFT_NO IS NOT NULL THEN        
  (SELECT  START_LUNCH_HR + '':'' + START_LUNCH_MIN + ''-'' + CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN        
  FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)        
 WHEN '''+ CONVERT(VARCHAR(5),@START_MIN)+'''' + ' <> ''0'' AND  '''+ CONVERT(VARCHAR(5),@END_MIN)+''''+' <> ''0'' THEN         
   '''+ CONVERT(VARCHAR(5),@START_MIN) + '-' + CONVERT(VARCHAR(5),@END_MIN) + '''        
 ELSE  '' ''        
 END AS ''LUNCH BREAK'',        
 CASE WHEN ID_SHIFT_NO IS NOT NULL THEN        
    (SELECT cast(datediff(mi,(START_LUNCH_HR + '':'' + START_LUNCH_MIN),        
   (CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN)) /60 as char(2))  +  '':'' +         
   cast(datediff(mi,(START_LUNCH_HR + '':'' + START_LUNCH_MIN),        
   (CLOSE_LUNCH_HR + '':'' + CLOSE_LUNCH_MIN))  % 60 as char(2))        
  FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = TBL_TR_JOB_ACTUAL.ID_SHIFT_NO)        
 WHEN '''+ CONVERT(VARCHAR(5),@START_MIN)+'''' + ' <> ''0'' AND  '''+ CONVERT(VARCHAR(5),@END_MIN)+''''+' <> ''0'' THEN         
  (SELECT cast(datediff(mi,(''' + CONVERT(VARCHAR(5),@START_MIN)+ '''),        
  ('''+ CONVERT(VARCHAR(5),@END_MIN) + ''' ))/60 as char(2))  +  '':'' +        
  cast(datediff(mi,(''' + CONVERT(VARCHAR(5),@START_MIN)+ '''),        
  ('''+ CONVERT(VARCHAR(5),@END_MIN) + '''))  % 60 as char(2)))        
 ELSE         
   '' ''        
 END AS ''LUNCH TIME'',        
 STATUS as Status,        
 ID_DAY_SEQ as ID_DAY_SEQ,        
 ID_LOG_SEQ as ID_LOG_SEQ ,        
 CASE WHEN ID_JOB IS NOT NULL THEN         
  (SELECT JOB_STATUS FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX + ID_WO_NO = TBL_TR_JOB_ACTUAL.ID_WO_PREFIX + TBL_TR_JOB_ACTUAL.ID_WO_NO AND ID_JOB = TBL_TR_JOB_ACTUAL.ID_JOB)        
 ELSE        
  '' ''        
 END AS ''JOB_STATUS'',    
 TOTAL_CLOCKED_TIME,              
 ID_WO_LAB_SEQ,              
 WO_LABOUR_DESC,              
 SL_NO AS LINE_NO        
 FROM TBL_TR_JOB_ACTUAL    
 LEFT OUTER JOIN TBL_WO_LABOUR_DETAIL ON TBL_WO_LABOUR_DETAIL.ID_WOLAB_SEQ = TBL_TR_JOB_ACTUAL.ID_WO_LAB_SEQ                
 INNER JOIN  TBL_MAS_USERS        
 ON TBL_TR_JOB_ACTUAL.ID_MEC_TR IN (SELECT ID_LOGIN FROM TBL_MAS_USERS WHERE ID_DEPT_USER = '+ CONVERT(VARCHAR(20),@IV_ID_DEPT)+ ')'--+' AND FLG_MECHANIC = 1)'        
         
        
 SET @WHRQRY1  = ''                
 SET @WHRQRY2 = ''                
 set @SUBQUERY = ''               
 SET @IV_FROM_DATE_NEW = dbo.FN_DateFormat(@IV_FROM_DATE)              
 SET @IV_TO_DATE_NEW = dbo.FN_DateFormat(@IV_TO_DATE)              
 IF (@IV_MECH_CODE IS NOT NULL)                
 SET @WHRQRY1 = ' ID_MEC_TR = ''' +  ltrim(rtrim(@IV_MECH_CODE)) + ''''                
         
 IF (@IV_MECH_NAME IS NOT NULL and @IV_MECH_CODE is null)                
 BEGIN        
  SET @WHRQRY2 = ' ID_MEC_TR IN (select ID_LOGIN  from TBL_MAS_USERS where FIRST_NAME LIKE''' + @IV_MECH_NAME + '%'' AND ID_DEPT_USER = '+ CONVERT(VARCHAR(20),@IV_ID_DEPT)+ ')'--+' AND FLG_MECHANIC = 1)'         
 END                
 ELSE IF (@IV_MECH_NAME IS NOT NULL and @IV_MECH_CODE is not null)                
 BEGIN        
  SET @WHRQRY2 = '  ID_MEC_TR IN (select ID_LOGIN  from TBL_MAS_USERS where FIRST_NAME =''' + @IV_MECH_NAME + '''AND ID_DEPT_USER = '+ CONVERT(VARCHAR(20),@IV_ID_DEPT)+ ')'        
 END          
           
 IF (@IV_ID_WO_NO IS NOT NULL AND @IV_ID_JOB IS NOT NULL )       
 BEGIN                 
  SET @WHRQRY3 = 'ID_WO_PREFIX + ID_WO_NO  = ''' + LTRIM(RTRIM(@IV_ID_WO_NO))   + ''' AND ID_JOB = ''' + CONVERT(VARCHAR,@IV_ID_JOB)+''''                  
 END      
  ELSE IF (@IV_ID_WO_NO IS NOT NULL AND @IV_ID_JOB IS NULL)      
    BEGIN      
  SET @WHRQRY3 = 'ID_WO_PREFIX + ID_WO_NO  = ''' + LTRIM(RTRIM(@IV_ID_WO_NO)) +''''                
    END 
    
 IF (@IV_FLG_ORDERS = 1 AND @IV_FLG_UNSOLD = 0)
	BEGIN           
		SET @WHRQRY3 = 'ID_WO_NO IS NOT NULL AND ID_UNSOLD_TIME IS NULL '            
	END
  ELSE IF (@IV_FLG_ORDERS =0 AND @IV_FLG_UNSOLD = 1)
    BEGIN
		SET @WHRQRY3 = 'ID_WO_NO IS NULL AND ID_UNSOLD_TIME IS NOT NULL'
    END          
           
 IF (@IV_FROM_DATE_NEW is NULL AND @IV_TO_DATE_NEW IS NULL)                
  SET @SUBQUERY = ''                
           
 IF (@IV_FROM_DATE_NEW is NOT NULL AND @IV_TO_DATE_NEW IS NOT NULL)                
  SET @SUBQUERY = ' CONVERT(DATETIME,convert(char(10),dt_clock_in,101),101)  between ''' + CONVERT(CHAR(10),CAST(@IV_FROM_DATE_NEW AS DATETIME),101) + ''' AND ''' + CONVERT(CHAR(10),CAST(@IV_TO_DATE_NEW AS DATETIME),101) + ''''                  
           
 IF (@IV_FROM_DATE_NEW is NOT NULL AND @IV_TO_DATE_NEW IS NULL)                
 BEGIN                
  SET @SUBQUERY  = ' CONVERT(DATETIME,convert(char(10),dt_clock_in,101),101) = ''' +  CONVERT(CHAR(10),CAST(@IV_FROM_DATE_NEW AS DATETIME),101) + ''''                
 END                   
 ELSE IF (@IV_TO_DATE_NEW IS NOT NULL AND @IV_FROM_DATE_NEW is NULL)                
 BEGIN                
  SET @SUBQUERY  = ' CONVERT(DATETIME,convert(varchar(10),DT_CLOCK_OUT,101),101) = ''' +  CONVERT(CHAR(10),CAST(@IV_TO_DATE_NEW AS DATETIME),101) + ''''                
 END             
 IF (@IV_ID_MR <> 0)          
 BEGIN            
  SET @SUBQUERY  = 'ID_TR_SEQ =' + CONVERT(VARCHAR(20),@IV_ID_MR) + ''           
 END           
        
 SET @MAINSQL = ''                
 IF @WHRQRY1 <> ''                
  SET @MAINSQL =  @EXECQUERY3 + ' WHERE ' + @WHRQRY1                 
 ELSE                
  SET @MAINSQL =  @EXECQUERY3                 
 IF @SUBQUERY <> ''                
  IF @WHRQRY1 <> ''                
   SET @MAINSQL = @MAINSQL + 'AND ' + @SUBQUERY                      
  ELSE                
   SET @MAINSQL = @MAINSQL + ' WHERE ' + @SUBQUERY                 
         
 IF @WHRQRY2 <> ''                
  IF @WHRQRY1 <> ''  OR @SUBQUERY <>''                
   SET @MAINSQL = @MAINSQL + ' AND ' + @WHRQRY2   --Change OR to AND              
  ELSE                
   SET @MAINSQL = @MAINSQL  + @WHRQRY2               
  IF @WHRQRY3 <>''                 
   SET @MAINSQL = @MAINSQL + ' AND ' + @WHRQRY3         
        
 IF @WHRQRY1 = '' AND @SUBQUERY = '' AND @WHRQRY2 = ''           
  SET @MAINSQL = @MAINSQL  + 'WHERE ID_DEPT_USER = '+ CONVERT(VARCHAR(20),@IV_ID_DEPT) --+' AND FLG_MECHANIC = 1'            
 SET @MAINSQL = @MAINSQL  + ' ORDER BY  DT_CLOCK_IN DESC '        
 print @EXECQUERY1        
 print @EXECQUERY2        
 print @MAINSQL        
 EXEC (@EXECQUERY1+@EXECQUERY2+@MAINSQL)                
           
END 
GO

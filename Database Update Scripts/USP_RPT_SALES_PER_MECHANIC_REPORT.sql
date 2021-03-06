/****** Object:  StoredProcedure [dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT]    Script Date: 11/28/2017 5:24:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT]    Script Date: 11/28/2017 5:24:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT] AS' 
END
GO
  
-- ***********************************  
-- Modified Date : 10th February 2009  
-- Bug Id      : Report_9_feb Issues  
-- Description  : Difference Formula corrected  
  
ALTER PROCEDURE [dbo].[USP_RPT_SALES_PER_MECHANIC_REPORT]      
(      
 @IV_DEP_FROM  AS VARCHAR(50),      
 @IV_DEP_TO   AS VARCHAR(50),      
 @IV_YEAR   AS VARCHAR(4),      
 @IV_MONTH_FROM  AS VARCHAR(2),      
 @IV_MONTH_TO  AS VARCHAR(2),      
 @IV_MECH_CODE_FROM AS VARCHAR(20),      
 @IV_MECH_CODE_TO AS VARCHAR(20),      
 @IV_LANGUAGE  AS VARCHAR(50)          
       
)      
AS      
BEGIN        
 DECLARE @QRY1  AS VARCHAR(MAX)      
 DECLARE @QRY2  AS VARCHAR(MAX)      
 DECLARE @MAINQRY AS VARCHAR(MAX)      
 DECLARE @EXECSTRING AS VARCHAR(MAX)   
 DECLARE @FromDate DATETIME  
 DECLARE @ToDate DATETIME  
   
  
-- Added for displaying the period ( from date  and to date ) in the report  
DECLARE @FROMYEAR VARCHAR(4)  
DECLARE @TOYEAR VARCHAR(4)  
DECLARE @FROMMONTH VARCHAR(2)  
DECLARE @TOMONTH VARCHAR(2)  

IF (@IV_MONTH_FROM IS NULL ) 
  SET @IV_MONTH_FROM = ''  
  
 IF (@IV_MONTH_TO IS NULL )
  SET @IV_MONTH_TO = ''  
  
IF (@IV_MECH_CODE_FROM IS NULL ) 
  SET @IV_MECH_CODE_FROM = ''  
  
 IF (@IV_MECH_CODE_TO IS NULL )
  SET @IV_MECH_CODE_TO = ''  
  
SET @FROMYEAR = @IV_YEAR  
SET @TOYEAR = @IV_YEAR  
SET @FROMMONTH = @IV_MONTH_FROM  
SET @TOMONTH = @IV_MONTH_TO  
  
IF @IV_YEAR <>'' AND @IV_MONTH_FROM  <>'' AND  @IV_MONTH_TO  <>''  
BEGIN  
 SET @fromDate = @frommonth +'/'+'01'+'/'+ @fromyear  
 SET @toDate = @tomonth +'/'+'01'+'/'+ @toyear  
 SELECT @toDate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@toDate)+1,0))  
END  
  
IF @IV_YEAR  <>'' AND  @IV_MONTH_FROM ='' AND  @IV_MONTH_TO =''  
BEGIN  
--Start of the year to end of the year  
SET @frommonth = '1'  
SET @tomonth = DATEPART(mm,GETDATE())  
 SET @fromDate = @frommonth +'/'+'01'+'/'+ @fromyear  
 SET @toDate = @tomonth +'/'+'01'+'/'+ @toyear  
 SELECT @toDate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@toDate)+1,0))  
END  
  
IF @IV_YEAR ='' AND  @IV_MONTH_FROM <>'' AND  @IV_MONTH_TO <>''  
BEGIN  
--Start of the year to end of the year  
--select 1  
SELECT TOP 1 @fromyear =DATEPART(yyyy,DT_ORDER)  FROM TBL_WO_HEADER ORDER BY DT_ORDER asc  
SET @toyear = DATEPART(yyyy,GETDATE())  
  
 SET @FROMDATE = @FROMMONTH +'/'+'01'+'/'+ @FROMYEAR  
 SET @TODATE = @TOMONTH +'/'+'01'+'/'+ @TOYEAR  
 SELECT @TODATE = DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,@TODATE)+1,0))  
END  
  
IF @IV_YEAR ='' AND  @IV_MONTH_FROM ='' AND  @IV_MONTH_TO =''  
BEGIN  
--Start of the year to end of the year  
SELECT TOP 1 @FROMYEAR =DATEPART(YYYY,DT_ORDER) FROM TBL_WO_HEADER ORDER BY DT_ORDER ASC  
SET @TOYEAR = DATEPART(YYYY,GETDATE())  
SET @FROMMONTH = '1'  
SET @TOMONTH = DATEPART(MM,GETDATE())  
  
 SET @FROMDATE = @FROMMONTH +'/'+'01'+'/'+ @FROMYEAR  
 SET @TODATE = @TOMONTH +'/'+'01'+'/'+ @TOYEAR  
 SELECT @TODATE = DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,@TODATE)+1,0))  
END  
  
  
  
/**********START NEW SCRIPT *****************/  
  
---- CONDITION FOR DEPARTMENT    
 IF @IV_DEP_FROM = ''   
 SET @IV_DEP_FROM = (SELECT MIN(DPT_Name) FROM TBL_MAS_DEPT)  
   
 IF @IV_DEP_TO = ''   
 SET @IV_DEP_TO = (SELECT MAX(DPT_Name) FROM TBL_MAS_DEPT)  
   
-- CONDITION FOR MONTH   
 IF @IV_MONTH_FROM = ''   
 SET @IV_DEP_FROM = '1'  
   
 IF @IV_MONTH_TO = ''   
 SET @IV_MONTH_TO = '12'  
  
  
-- CONDITION FOR YEAR    
IF @IV_YEAR = ''   
SET @IV_YEAR = (SELECT MIN(YEAR(DT_CLOCK_IN)) FROM TBL_TR_JOB_ACTUAL)  
  
---- CONDITION FOR MECH_CODE    
 IF @IV_MECH_CODE_FROM = ''   
 SET @IV_MECH_CODE_FROM = (SELECT MIN(ID_LOGIN) FROM TBL_MAS_USERS WHERE Flg_Mechanic=1)  
   
 IF @IV_MECH_CODE_TO = ''   
 SET @IV_MECH_CODE_TO = (SELECT MAX(ID_LOGIN) FROM TBL_MAS_USERS WHERE Flg_Mechanic=1)  
   
  
SELECT  T1.ID_WO_NO,T1.ID_WO_PREFIX,T1.ID_JOB,T1.ID_UNSOLD_TIME,T1.ID_MEC_TR,  
CASE WHEN (t2.ID_JOB IS NOT NULL) AND (SELECT JOB_STATUS FROM TBL_WO_DETAIL WHERE ID_WO_PREFIX + ID_WO_NO = t1.ID_WO_PREFIX + t1.ID_WO_NO AND ID_JOB = t1.ID_JOB) = 'INV' THEN   
   (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0 )/60  
  ELSE  
   CASE WHEN CONVERT(VARCHAR(5),ISNULL((SELECT LUNCH_WITHDRAW FROM TBL_MAS_DEPT WHERE ID_DEPT IN (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),0)) = 1 THEN     
    CASE WHEN  ID_SHIFT_NO IS NOT NULL THEN       
     CASE WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) < (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)) OR   
       ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) > (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))))   
      THEN  
       (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0 )/60  
     ELSE  
      CASE WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) < (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))   
       AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) > (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))  
       AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) <= (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)))   
      THEN  
        
       (cast(replace(dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' '   
       + (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS   
          WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))) ,':','.')  
        as decimal(20,2)))   
      WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) > (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))  
       AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) < (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)))   
      THEN  
        --'00:00'  
       cast(replace('00:00',':','.')as decimal(20,2))   
          
      WHEN ((CONVERT(VARCHAR(5),DT_CLOCK_IN,8) > (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))  
       AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) > (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)))   
      THEN  
        (cast(replace(dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),t1.DT_CLOCK_IN,101) + ' ' +  (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)),t1.DT_CLOCK_OUT),':','.')as decimal(20,2))*60.0)/60  
        
      WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) < (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))   
       AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) > (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)))   
      THEN  
        (cast(replace(DBO.[FNADDMINS](dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' ' +  (SELECT  START_LUNCH_HR + ':' + START_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO))) ,    
        dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),DT_CLOCK_IN,101) + ' ' +  (SELECT  CLOSE_LUNCH_HR + ':' + CLOSE_LUNCH_MIN FROM TBL_MAS_SHIFT_DETAILS WHERE ID_SHIFT_NO = t1.ID_SHIFT_NO)),t1.DT_CLOCK_OUT)),':','.')as decimal(20,2)) *60.0)/
60  
      ELSE  
       --dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)  
       (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0)/60  
      END    
     END  
    ELSE   
     CASE WHEN (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0')) <> '0' AND  ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0') <> '0' THEN   
      CASE WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) < (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))) OR   
       ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) > (ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0')))))   
      THEN  
        --dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)  
        (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0)/60  
      ELSE  
       CASE WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) < (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))) AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8)) > (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0')) AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8)) <= (ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0')))   
       THEN  
        (cast(replace(dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),t1.DT_CLOCK_IN,101) + ' '+(ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0')
))) ,':','.')as decimal(20,2))*60.0 )/60   
         
       WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) > (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))) AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) < (ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))))   
       THEN  
        --'00:00'  
        cast(replace('00:00',':','.')as decimal(20,2))   
         
       WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) > (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))) AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) > (ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))))   
       THEN  
        (cast(replace(dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),t1.DT_CLOCK_IN,101) + ' '+(ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))),t1.DT_CLOCK_OUT),':','.')as decimal(20,2))*60.0)/60     
         
       WHEN ((CONVERT(VARCHAR(5),t1.DT_CLOCK_IN,8) < (ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))) AND (CONVERT(VARCHAR(5),t1.DT_CLOCK_OUT,8) > (ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))))   
       THEN  
        (cast(replace(DBO.[FNADDMINS](dbo.[fnTimeDiff-New](DT_CLOCK_IN,CONVERT(DATETIME,CONVERT(VARCHAR(10),t1.DT_CLOCK_IN,101) + ' '+(ISNULL((SELECT FROM_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0')))) ,    
        dbo.[fnTimeDiff-New](CONVERT(DATETIME,CONVERT(VARCHAR(10),t1.DT_CLOCK_IN,101) + ' '+(ISNULL((SELECT TO_TIME FROM TBL_MAS_DEPT WHERE ID_DEPT = (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login=T1.ID_MEC_TR)),'0'))),t1.DT_CLOCK_OUT)),':','.')as
 decimal(20,2))*60.0)/60      
       ELSE  
        --dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)  
        (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0)/60  
       END   
      END  
     ELSE  
       --dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)   
       (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0)/60   
  END      
    END  
   ELSE  
    --dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)  
    (cast(replace((dbo.[fnTimeDiff-New](t1.DT_CLOCK_IN,t1.DT_CLOCK_OUT)),':','.')as decimal(20,2))*60.0 )/60  
   END  
 END AS 'CLOCKED TIME'  
,T2.WO_TOT_LAB_AMT,T2.WO_CHRG_TIME,T2.WO_STD_TIME,  
 T2.WO_LBR_VATPER,    
 CASE WHEN T1.ID_WO_NO IS NOT NULL THEN        
 CAST(T2.WO_TOT_LAB_AMT + T2.WO_TOT_SPARE_AMT + T2.WO_TOT_GM_AMT + T2.WO_TOT_VAT_AMT - T2.WO_TOT_DISC_AMT + T2.WO_FIXED_PRICE AS DECIMAL(20,2))    
  END AS 'Total Sales',  
 CASE WHEN T1.ID_WO_NO IS NOT NULL THEN        
 CAST(T2.WO_TOT_LAB_AMT + ((T2.WO_TOT_LAB_AMT - (T2.WO_TOT_LAB_AMT * 0.01 *  ISNULL(T2.WO_DISCOUNT,0)))   * T2.WO_LBR_VATPER/100) - (T2.WO_TOT_LAB_AMT * 0.01 *  ISNULL(T2.WO_DISCOUNT,0))  AS DECIMAL(20,2))    
  END AS 'LabAmt'   
  ,CASE WHEN T1.ID_WO_NO IS NOT NULL THEN (SELECT SUM(WO_LABOUR_HOURS) FROM TBL_WO_LABOUR_DETAIL WHERE ID_WODET_SEQ in   
 (SELECT ID_WODET_SEQ FROM TBL_WO_DETAIL WHERE ID_WO_NO = T1.ID_WO_NO and ID_WO_PREFIX=T1.ID_WO_PREFIX and ID_JOB =T1.ID_JOB)) ELSE 0 END as 'Total Clocked Time'     
 INTO #TMP_TABLE       
  FROM    
 (SELECT ID_WO_NO,ID_WO_PREFIX,      
   ID_JOB,ID_MEC_TR,      
   ID_UNSOLD_TIME, DT_CLOCK_IN,DT_CLOCK_OUT,ID_SHIFT_NO,     
   --CAST(sum((CONVERT(INT,SUBSTRING(dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT),0,      
   --                   CHARINDEX(':',dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT))))*60 +      
   --                   CONVERT(INT,SUBSTRING(dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT),      
   --                   CHARINDEX(':',dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT))+1,      
   --                   LEN(dbo.[fnTimeDiff-New](DT_CLOCK_IN,DT_CLOCK_OUT)))))) as decimal(20,2))/60.0   
                      0.00 as 'Clocked Time'      
    FROM TBL_TR_JOB_ACTUAL   
      
    WHERE ((@IV_MECH_CODE_FROM = '' OR @IV_MECH_CODE_TO = '') OR (ID_MEC_TR BETWEEN @IV_MECH_CODE_FROM AND @IV_MECH_CODE_TO ))  
    AND   
    (@IV_YEAR = '' OR YEAR(DT_CREATED) = @IV_YEAR)  
    AND ((@IV_MONTH_FROM = '' OR @IV_MONTH_TO = '') OR (MONTH(DT_CREATED) BETWEEN @IV_MONTH_FROM AND @IV_MONTH_TO))  
      
    GROUP BY ID_MEC_TR,ID_WO_NO,ID_WO_PREFIX,ID_JOB,ID_UNSOLD_TIME,DT_CLOCK_IN,DT_CLOCK_OUT,ID_SHIFT_NO ) AS T1      
 LEFT OUTER JOIN    TBL_WO_DETAIL AS T2    
 ON T1.ID_WO_NO   =T2.ID_WO_NO          
 AND   T1.ID_WO_PREFIX   =T2.ID_WO_PREFIX              
 AND   T1.ID_JOB         =T2.ID_JOB    
   
   
--select '#TMP_TABLE',* from #TMP_TABLE   
  
/*UPDATE CLOCKED TIME TO DECIMAL EQUIVALENT eg. 3:30 (or 3.30) = 3.5*/  
UPDATE #TMP_TABLE  
SET [CLOCKED TIME]= CAST(CAST(SUBSTRING(CONVERT(VARCHAR(20),[CLOCKED TIME]),0,CHARINDEX('.',CONVERT(VARCHAR(20),[CLOCKED TIME]))) AS DECIMAL(20,2))  
  + CAST(SUBSTRING(CONVERT(VARCHAR(20),[CLOCKED TIME]),CHARINDEX('.',CONVERT(VARCHAR(20),[CLOCKED TIME]))+1,LEN(CONVERT(VARCHAR(20),CAST([CLOCKED TIME] AS INT)))+1)AS DECIMAL(20,2))/60.00  AS DECIMAL(20,2))  
  
--select '##TMP_TABLE',* from #TMP_TABLE   
  
 SELECT *,      
  CASE WHEN [Clocked Time] <> '0' THEN      
   CONVERT(DECIMAL(13,6),LabAmt/CONVERT(DECIMAL(13,6),[Clocked Time]))  
  ELSE    
   CAST(0 AS DECIMAL(20,2))    
  END AS 'AVG_HLY_PRC',      
  CASE WHEN ID_MEC_TR IS NOT NULL THEN      
 CASE WHEN (SELECT TOP 1 COST_HOUR  FROM TBL_MAS_MEC_COST WHERE ID_MEC COLLATE database_default = #TMP_TABLE.ID_MEC_TR COLLATE database_default) IS NOT NULL THEN      
  (SELECT  TOP 1 COST_HOUR  FROM TBL_MAS_MEC_COST WHERE ID_MEC COLLATE database_default = #TMP_TABLE.ID_MEC_TR COLLATE database_default)      
 ELSE      
  (SELECT TOP 1 HP_COST FROM TBL_MAS_HP_RATE        
    WHERE ID_MECHPCD_HP = (SELECT top 1   ID_MECPCD FROM TBL_MAS_MEC_COMPT_MAP WHERE ID_MEC COLLATE database_default = #TMP_TABLE.ID_MEC_TR COLLATE database_default)      
  ORDER BY DT_EFF_FROM )      
    END      
  ELSE   
 NULL      
  END AS 'COSTPRICE'      
 INTO #TMP_TABLE2      
 FROM #TMP_TABLE       
  
--select '#TMP_TABLE2',* from #TMP_TABLE2    
  
SELECT * INTO  #TMP_TABLE3       
 FROM       
 (SELECT *,       
 CASE WHEN ID_MEC_TR IS NOT NULL THEN      
  (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login =  ID_MEC_TR)      
 ELSE       
  NULL      
 END AS 'DEPARTMENT ID',         
 CASE WHEN ID_MEC_TR IS NOT NULL THEN      
  (SELECT DPT_NAME FROM TBL_MAS_DEPT WHERE ID_Dept =       
   (SELECT ID_Dept_User FROM TBL_MAS_USERS WHERE ID_Login =  ID_MEC_TR))      
    ELSE       
  NULL      
    END AS 'DEPARTMENT',      
 CASE WHEN ID_MEC_TR IS NOT NULL THEN         
  (SELECT First_Name + ' ' + Last_Name FROM TBL_MAS_USERS WHERE ID_Login =  ID_MEC_TR)      
    ELSE       
  NULL      
    END AS 'MechanicName',      
 CASE WHEN ID_UNSOLD_TIME IS NULL THEN   
  CASE WHEN ISNULL([Total Clocked Time],0)<>0 THEN  
   Cast(ISNULL(([Total Sales]*([Clocked Time] / [Total Clocked Time]))-(dbo.FN_GET_TOT_SPARE_AMT(ID_WO_PREFIX,ID_WO_NO,ID_JOB)*([Clocked Time] / [Total Clocked Time]))-([Clocked Time] * COSTPRICE),0) AS DECIMAL(20,2))  
  ELSE  
   0  
  END    
 ELSE       
  NULL  
 END  
 AS 'Gross Margin',      
 CASE WHEN ID_UNSOLD_TIME IS NOT NULL THEN      
  [Clocked Time] * COSTPRICE      
 ELSE       
  NULL      
 END AS 'Value of Unsld Time',      
 CASE WHEN ID_WO_NO IS NOT NULL THEN    
  CONVERT(DECIMAL(5,2),[Clocked Time])-  CONVERT(DECIMAL(5,2),WO_CHRG_TIME)  
 ELSE     
  0    
   END AS 'Difference'      
  FROM #TMP_TABLE2 ) AS g      
  LEFT JOIN (SELECT DT_CREATED,ID_WO_NO as WONO,ID_WO_PREFIX as PRFX,ID_JOB AS JOB FROM TBL_WO_DETAIL) as h       
  ON  h.WONO = g.ID_WO_NO  AND       
   h.PRFX = g.ID_WO_PREFIX AND       
   h.JOB = g.ID_JOB       
  
--select '#TMP_TABLE3',* from #TMP_TABLE3  
  
 SELECT [DEPARTMENT ID],DEPARTMENT,ID_MEC_TR,MechanicName,      
   ID_WO_NO,ID_WO_PREFIX,ID_JOB,ID_UNSOLD_TIME,      
   CASE WHEN ID_UNSOLD_TIME IS NOT NULL THEN      
  (SELECT DESCRIPTION FROM TBL_MAS_SETTINGS WHERE ID_SETTINGS = ID_UNSOLD_TIME)      
   ELSE       
  NULL      
   END AS 'UNSOLD DESC',      
   CASE WHEN ID_UNSOLD_TIME IS NOT NULL THEN   
  (SELECT TOP 1 TR.DT_CREATED FROM TBL_TR_JOB_ACTUAL TR  
   WHERE TR.ID_UNSOLD_TIME = ID_UNSOLD_TIME AND TR.ID_MEC_TR = ID_MEC_TR AND   
   (@IV_YEAR = '' OR YEAR(DT_CREATED) = @IV_YEAR)  
   AND ((@IV_MONTH_FROM = '' OR @IV_MONTH_TO = '') OR (MONTH(DT_CREATED) BETWEEN @IV_MONTH_FROM AND @IV_MONTH_TO))  
   ORDER BY TR.DT_CREATED)  
   ELSE     
  DT_CREATED  
   END AS DT_CREATED,      
   DBO.FN_MULTILINGUAL_NUMERIC([Total Sales],@IV_LANGUAGE) [Total Sales], --[Total Sales],      
   DBO.FN_MULTILINGUAL_NUMERIC([AVG_HLY_PRC],@IV_LANGUAGE) [AVG_HLY_PRC], --AVG_HLY_PRC,      
   DBO.FN_MULTILINGUAL_NUMERIC([Gross MArgin],@IV_LANGUAGE) [Gross MArgin], -- [Gross MArgin],      
   DBO.FN_MULTILINGUAL_NUMERIC([Value of Unsld Time],@IV_LANGUAGE) [Value of Unsld Time], -- [Value of Unsld Time],      
   [Difference],[Total Sales] [Total Sales1],[Gross MArgin] [Gross MArgin1],[Value of Unsld Time] [Value of Unsld Time1],  
   convert(varchar(10),@FromDate,103) AS FROMDATE,convert(varchar(10),@ToDate,103)  AS TODATE   
   INTO  #TMP_TABLE4  
   FROM #TMP_TABLE3   
     
   SELECT [DEPARTMENT ID],DEPARTMENT,ID_MEC_TR,MechanicName,ID_WO_NO,ID_WO_PREFIX,ID_JOB,ID_UNSOLD_TIME,[UNSOLD DESC],[DT_CREATED],  
   [Total Sales], --[Total Sales],      
   [AVG_HLY_PRC], --AVG_HLY_PRC,      
   [Gross MArgin], -- [Gross MArgin],      
   [Value of Unsld Time], -- [Value of Unsld Time],      
   [Difference],[Total Sales1],[Gross MArgin1],[Value of Unsld Time1],  
   convert(datetime,FROMDATE,103)FROMDATE,convert(datetime,TODATE,103)TODATE  
   FROM #TMP_TABLE4    
   WHERE   
  [DEPARTMENT ID] IN (SELECT ID_DEPT FROM TBL_MAS_DEPT WHERE DPT_NAME >= @IV_DEP_FROM AND DPT_NAME <= @IV_DEP_TO)   
  AND YEAR(DT_CREATED) = @IV_YEAR AND MONTH(DT_CREATED) >=@IV_MONTH_FROM   
  AND MONTH(DT_CREATED) <= @IV_MONTH_TO AND [ID_MEC_TR]  >= @IV_MECH_CODE_FROM AND [ID_MEC_TR] <= @IV_MECH_CODE_TO       
   ORDER BY DEPARTMENT,ID_MEC_TR,[UNSOLD DESC]        
      
  DROP TABLE #TMP_TABLE3      
  DROP TABLE #TMP_TABLE2       
  DROP TABLE #TMP_TABLE  
  DROP TABLE #TMP_TABLE4  
  
/**********END NEW SCRIPT *****************/  
  
     
END      
/*      
---------------------------------------------------------------------------------------------------------------------      
      
--Total sales = Clocked time per work order job * hourly price the work order job.      
--Average hourly price = Total sales / Clocked time      
--Gross margin = Total sales û (Clocked time * cost price)      
--Value of unsold time = Clocked time at codes for unsold time * cost price set at mechanic.      
--      
-- Cost price at work order job can be set two places. Directly at mechanic, and if this not is filled out then       
--  it should use the cost price from the hourly price table      
      
EXEC USP_RPT_SALES_PER_MECHANIC_REPORT '', '', '', '', '', '','','English'      
EXEC USP_RPT_SALES_PER_MECHANIC_REPORT '', '', '', '', '', '','','NORWEGIAN'      
EXEC USP_RPT_SALES_PER_MECHANIC_REPORT '', '', '', '', '', 'schuchardt','schuchardt','NORWEGIAN'      
SELECT * fROM tbl_WO_DETAIL WHERE ID_WO_NO = 158      
select * from #TMP_TABLE3       
-----------------------------------------------------------------------------------------------------------------      
*/  
  
  
GO

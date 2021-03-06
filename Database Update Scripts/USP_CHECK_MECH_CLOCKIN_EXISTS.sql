/****** Object:  StoredProcedure [dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS]    Script Date: 1/24/2018 5:39:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS]    Script Date: 1/24/2018 5:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS] AS' 
END
GO
          
ALTER PROCEDURE [dbo].[USP_CHECK_MECH_CLOCKIN_EXISTS]          
@ID_WO_NO VARCHAR(30),           
@ID_JOB INT,          
@MECH_CODE VARCHAR(30),          
@ID_LAB_SEQ INT          
           
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 DECLARE @TMP_ID_TR_SEQ AS INT          
           
 -- FOR FETCHING THE LAST RECORD DETAILS          
 --IF (@ID_WO_NO IS NOT NULL)        
  BEGIN                
   SELECT @TMP_ID_TR_SEQ = ID_TR_SEQ                
   FROM TBL_TR_JOB_ACTUAL                
   WHERE DT_CLOCK_IN =           
   (          
    SELECT MAX(DT_CLOCK_IN) FROM TBL_TR_JOB_ACTUAL               
    WHERE DATEDIFF(Day,DT_CLOCK_IN, GETDATE()) = 0                
    AND DT_CLOCK_OUT IS NULL                
    --AND ID_WO_PREFIX + ID_WO_NO = @ID_WO_NO           
    --AND ID_WO_PREFIX = @ID_WO_PREFIX          
    --AND ID_JOB = @ID_JOB          
    AND ID_MEC_TR = @MECH_CODE          
   -- AND ID_WO_LAB_SEQ = @ID_LAB_SEQ          
   )        
    SELECT TR.*,WLD.*,CONVERT(varchar(10),TR.DT_CLOCK_IN,101)AS CLOCKIN_DATE,CONVERT(varchar(10),TR.DT_CLOCK_IN,108) AS CLOCKIN_TIME,        
     CONVERT(varchar(10),TR.DT_CLOCK_OUT,101)AS CLOCKOUT_DATE,CONVERT(varchar(10),TR.DT_CLOCK_OUT,108) AS CLOCKOUT_TIME        
  FROM TBL_TR_JOB_ACTUAL TR           
  LEFT OUTER JOIN  TBL_WO_DETAIL WD ON TR.ID_WO_NO = WD.ID_WO_NO AND TR.ID_WO_PREFIX = WD.ID_WO_PREFIX AND TR.ID_JOB = WD.ID_JOB            
  LEFT OUTER JOIN  TBL_WO_LABOUR_DETAIL WLD ON WLD.ID_WODET_SEQ = WD.ID_WODET_SEQ AND WLD.ID_WOLAB_SEQ = TR.ID_WO_LAB_SEQ           
  --(WLD.ID_LOGIN = TR.ID_MEC_TR OR WLD.ID_LOGIN ='DUser')          
  WHERE           
  TR.ID_TR_SEQ = @TMP_ID_TR_SEQ          
             
  END        
  --ELSE        
  -- BEGIN        
  --   SELECT @TMP_ID_TR_SEQ = ID_TR_SEQ                
  -- FROM TBL_TR_JOB_ACTUAL                
  -- WHERE DT_CLOCK_IN =           
  -- (          
  --  SELECT MAX(DT_CLOCK_IN) FROM TBL_TR_JOB_ACTUAL               
  --  WHERE DATEDIFF(Day,DT_CLOCK_IN, GETDATE()) = 0                
  --  AND DT_CLOCK_OUT IS NULL                
  --  AND ID_MEC_TR = @MECH_CODE          
        
  -- )         
  --   SELECT TR.*,CONVERT(varchar(10),TR.DT_CLOCK_IN,101)AS CLOCKIN_DATE,CONVERT(varchar(10),TR.DT_CLOCK_IN,108) AS CLOCKIN_TIME,        
  --   CONVERT(varchar(10),TR.DT_CLOCK_OUT,101)AS CLOCKOUT_DATE,CONVERT(varchar(10),TR.DT_CLOCK_OUT,108) AS CLOCKOUT_TIME         
  --FROM TBL_TR_JOB_ACTUAL TR           
  --WHERE           
  --TR.ID_TR_SEQ = @TMP_ID_TR_SEQ          
  -- END      
          
        
  --TR.ID_WO_NO = @ID_WO_NO AND           
  --TR.ID_WO_PREFIX = @ID_WO_PREFIX AND           
  --TR.ID_JOB = @ID_JOB AND           
  ----TR.ID_MEC_TR = @MECH_CODE AND          
  --WLD.ID_WOLAB_SEQ=@ID_LAB_SEQ           
  --AND TR.ID_TR_SEQ = @TMP_ID_TR_SEQ          
             
           
END 
GO

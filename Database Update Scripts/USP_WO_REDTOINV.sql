/****** Object:  StoredProcedure [dbo].[USP_WO_REDTOINV]    Script Date: 9/28/2017 4:00:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_REDTOINV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_WO_REDTOINV]
GO
/****** Object:  StoredProcedure [dbo].[USP_WO_REDTOINV]    Script Date: 9/28/2017 4:00:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_WO_REDTOINV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_WO_REDTOINV] AS' 
END
GO
/*************************************** Application: MSG *************************************************************      
* Module : Work Order     
* File name : USP_WO_REDTOINV .prc      
* Purpose :     
* Author : Subramani     
* Date  : 27.10.2006    
*********************************************************************************************************************/      
/*********************************************************************************************************************        
I/P : -- Input Parameters      
O/P : -- Output Parameters      
Error Code      
Description      
INT.VerNO : NOV21.0        
********************************************************************************************************************/      
--'*********************************************************************************'*********************************      
--'* Modified History :         
--'* S.No  RFC No/Bug ID   Date        Author  Description       
--*#0001#       
--'*********************************************************************************'*********************************      
      
ALTER PROCEDURE [dbo].[USP_WO_REDTOINV]        
(         
 @XMLDOC AS  NTEXT,      --VARCHAR(4000),            
 @OV_RETVALUE    varchar(10) output ,    
 @iv_UserId        VARCHAR(20)     
)            
AS            
BEGIN                  
 DECLARE @IDOC AS INT                  
 DECLARE @WOJOBTEMP TABLE                  
 (                  
 WOORDNO  VARCHAR(10),                  
 WOJOBNO  VARCHAR(10) ,                  
 WOPREFIX VARCHAR(3)                   
 )                  
                  
  EXEC SP_XML_PREPAREDOCUMENT  @IDOC OUTPUT,@XMLDOC                  
                   
  INSERT INTO @WOJOBTEMP                  
  SELECT WOORDNO,WOJOBNO,WOPREFIX FROM                  
  OPENXML(@IDOC,'ROOT/JOBNO',1)                  
  WITH                  
   (                  
    WOORDNO  VARCHAR(10),                  
    WOJOBNO  VARCHAR(10),                  
    WOPREFIX  VARCHAR(3)                  
   )                  
                   
  EXEC SP_XML_REMOVEDOCUMENT @IDOC                  
  DECLARE @DepID AS INT            
  DECLARE @SubID AS INT                   
      
  SELECT @DepID=ID_Dept_User,@SubID = ID_Subsidery_User             
  FROM TBL_MAS_USERS            
  WHERE ID_Login=@iv_UserId        
  --UPDATE TABLE WORK ORDER DETAIL                  
  --CONDITION JOB STATUS SHOULD BE JCD                  
  -- IN THE TABLE WORK ORDER JOB DETAIL THE ORDER QUANTITY MUST BE EQUAL TO DELIVERED QUANTITY                  
  UPDATE  TBL_WO_DETAIL   
  -- Modified Date : 15th April 2010  
  -- Bug Id   : Row no 63  
  set JOB_STATUS = (CASE WHEN JOB_STATUS = 'RINV'   
      AND ((SELECT ISNULL(COUNT(*),0) FROM TBL_INV_DETAIL INVD   
       JOIN TBL_INV_HEADER INVH  ON INVH.ID_INV_NO =   INVD.ID_INV_NO   
       JOIN TBL_WO_DEBITOR_DETAIL WODEB ON WODEB. ID_JOB_DEB =  INVH.ID_DEBITOR   
      WHERE WODEB.ID_WO_NO=JOBTEMP.WOORDNO   
       AND WODEB.ID_WO_PREFIX=JOBTEMP.WOPREFIX   
       AND WODEB.ID_JOB_ID=JOBTEMP.WOJOBNO  
       AND INVH.ID_CN_NO IS NULL  
       AND INVD.ID_WO_NO=JOBTEMP.WOORDNO AND INVD.ID_WO_PREFIX=JOBTEMP.WOPREFIX AND INVD.ID_JOB=JOBTEMP.WOJOBNO  
      )>0)  
    
  THEN  
   'PINV'  
  ELSE  
   CASE WHEN JOBHEAD.WO_TYPE_WOH = 'CRSL' THEN  
    CASE WHEN JOB_STATUS = 'RINV' THEN  
      'CON'  
    ELSE  
     'RINV'  
    END  
   ELSE   
    CASE WHEN JOBHEAD.WO_TYPE_WOH  = 'ORD'  THEN  
     CASE WHEN JOB_STATUS = 'RINV' THEN  
      'JCD'  
     ELSE  
      'RINV'  
     END
    ELSE
	CASE WHEN JOBHEAD.WO_TYPE_WOH  = 'KRE'  THEN  
		CASE WHEN JOB_STATUS = 'RINV' THEN  
			'JCD'  
		ELSE  
			'RINV'  
		END
	END  
   END  
     END  
  END)          
 -- End Of Modification    
   
 -- select *      
  from                   
    @WOJOBTEMP JOBTEMP,               
    TBL_WO_Header JOBHEAD                  
  WHERE      
        TBL_WO_DETAIL.ID_WO_NO      = JOBHEAD.ID_WO_NO    
    AND TBL_WO_DETAIL.ID_WO_PREFIX  = JOBHEAD.ID_WO_PREFIX    
    AND JOBHEAD.ID_Subsidery  = @SubID    
    AND JOBHEAD.ID_Dept    = @DepID    
    AND JOBHEAD.WO_TYPE_WOH         <> 'BAR'    
    AND TBL_WO_DETAIL.JOB_STATUS    <> 'INV'     
    AND TBL_WO_DETAIL.JOB_STATUS    <> 'BAR'       
    --AND TBL_WO_DETAIL.JOB_STATUS    <> 'JST'        
    AND TBL_WO_DETAIL.JOB_STATUS    <> 'DEL'            
    AND TBL_WO_DETAIL.ID_WO_NO  = JOBTEMP.WOORDNO                   
    AND TBL_WO_DETAIL.ID_JOB = JOBTEMP.WOJOBNO                  
    AND TBL_WO_DETAIL.ID_WO_PREFIX = JOBTEMP.WOPREFIX                  
--    AND TBL_WO_DETAIL.ID_WODET_SEQ = JOBDET.ID_WODET_SEQ_JOB                   
--    AND TBL_WO_DETAIL.ID_WO_NO  = JOBDET.ID_WO_NO                    
--    AND TBL_WO_DETAIL.ID_WO_PREFIX = JOBDET.ID_WO_PREFIX                  
                 
    --AND JOBDET.JOBI_ORDER_QTY= JOBDET.JOBI_DELIVER_QTY       
  
--Bug ID :- 3377  
--Date   :- 11-Aug-2008  
--Desc   :- Has to change status to TBL_WO_Header table also  
DECLARE @RSTATUSCOUNT INT, @WOCOUNT INT  
 SELECT @RSTATUSCOUNT = COUNT(*) FROM TBL_WO_DETAIL WD, @WOJOBTEMP JOBTEMP   
 WHERE WD.ID_WO_NO = JOBTEMP.WOORDNO AND WD.ID_WO_PREFIX = JOBTEMP.WOPREFIX AND WD.JOB_STATUS = 'RINV'   
   
 SELECT @WOCOUNT = COUNT(*) FROM TBL_WO_DETAIL WD, @WOJOBTEMP JOBTEMP   
 WHERE WD.ID_WO_NO = JOBTEMP.WOORDNO AND WD.ID_WO_PREFIX = JOBTEMP.WOPREFIX   
   
 UPDATE  TBL_WO_Header   
  set WO_STATUS =  CASE WHEN JOBHEAD.WO_TYPE_WOH  = 'ORD'  THEN  
       (CASE WHEN (@RSTATUSCOUNT > 0)THEN  
         'RINV'  
        ELSE  
         'JCD'  
       END)  
      ELSE   
		   CASE WHEN JOBHEAD.WO_TYPE_WOH  = 'CRSL'  THEN   
			   (CASE WHEN (@RSTATUSCOUNT > 0)THEN  
				 'RINV'  
				ELSE  
				 'CON'  
			   END)
		   ELSE 
				CASE WHEN JOBHEAD.WO_TYPE_WOH  = 'KRE'  THEN   
				(
					CASE WHEN (@RSTATUSCOUNT > 0)THEN  
					 'RINV'		
					ELSE  
					 'JCD'  
					END
				) 
			END	  
      END  
     END   
    from                   
   @WOJOBTEMP JOBTEMP,              
   TBL_WO_Header JOBHEAD,  
    TBL_WO_DETAIL              
    WHERE      
    TBL_WO_DETAIL.ID_WO_NO      = JOBHEAD.ID_WO_NO    
   AND TBL_WO_DETAIL.ID_WO_PREFIX  = JOBHEAD.ID_WO_PREFIX    
   AND JOBHEAD.ID_Subsidery  = @SubID    
   AND JOBHEAD.ID_Dept    = @DepID    
   AND JOBHEAD.WO_TYPE_WOH         <> 'BAR'    
   AND TBL_WO_DETAIL.JOB_STATUS    <> 'INV'     
   AND TBL_WO_DETAIL.JOB_STATUS    <> 'BAR'       
   --AND TBL_WO_DETAIL.JOB_STATUS    <> 'JST'        
   AND TBL_WO_DETAIL.JOB_STATUS    <> 'DEL'            
   AND TBL_WO_DETAIL.ID_WO_NO  = JOBTEMP.WOORDNO                   
   AND TBL_WO_DETAIL.ID_JOB = JOBTEMP.WOJOBNO                  
   AND TBL_WO_DETAIL.ID_WO_PREFIX = JOBTEMP.WOPREFIX   
  --change end  
   
             
 IF @@ROWCOUNT = 0          
  SET @OV_RETVALUE = 'NO_UPD'            
 ELSE                              
  SET @OV_RETVALUE = 'UPD'        
                
--  IF @@ERROR <> 0                               
--   SET @OV_RETVALUE = @@ERROR                              
                     
                  
END                  
                  
/*                  
 SELECT * FROM TBL_WO_DETAIL                  
 DECLARE @OUTPUT AS VARCHAR(10)     
 DECLARE @DOC AS VARCHAR(4000)                  
 SET @DOC = '                  
 <ROOT>                  
  <JOBNO WOORDNO = "122" WOJOBNO = "2" WOPREFIX = "WO" >                  
  </JOBNO>                  
 </ROOT> '                  
 EXEC USP_WO_REDTOINV @DOC,@OUTPUT OUTPUT                  
 PRINT @OUTPUT                  
                
select * from TBL_WO_DETAIL where JOB_STATUS = 'JCD'                 
                
*/  
GO

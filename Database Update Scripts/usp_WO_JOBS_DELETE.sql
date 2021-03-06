/****** Object:  StoredProcedure [dbo].[usp_WO_JOBS_DELETE]    Script Date: 2/24/2017 11:39:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_JOBS_DELETE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WO_JOBS_DELETE]
GO
/****** Object:  StoredProcedure [dbo].[usp_WO_JOBS_DELETE]    Script Date: 2/24/2017 11:39:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WO_JOBS_DELETE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_WO_JOBS_DELETE] AS' 
END
GO
      
/*************************************** Application: MSG *************************************************************          
* Module : Master          
* File name : usp_WO_JOBS_DELETE.PRC          
* Purpose : To Delete Jobs information.           
* Author : M.Thiyagarajan.          
* Date  : 20.07.2006          
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
--*#0001#  Bug 'Bug ID :3866       27/10/2007      Dhanunjaya rao           
--'*********************************************************************************'*********************************          
ALTER PROCEDURE [dbo].[usp_WO_JOBS_DELETE]          
(          
  @IV_XMLDOC     NTEXT,   --VARCHAR(7000),          
  @OV_RETVALUE VARCHAR(10) OUTPUT,          
  @OV_CNTDELETE  VARCHAR(2000) OUTPUT,          
  @OV_DELETEDCFG VARCHAR(2000) OUTPUT          
)          
AS          
BEGIN          
        
--BUG ID:- DELETE SPARE PART          
--DATE :- 26-JULY-2008          
--DESC :- Should pop-up message, when records deleting with Spare Part          
 DECLARE @DelSPCount INT            
 DECLARE @DelSPCountSTR AS VARCHAR(8)       
 DECLARE @JOBCOUNT  INT      
 DECLARE @WOJOBCOUNT  INT                  
--CHANGE END         
        
        
 DECLARE @HDOC INT          
 DECLARE @CONFIGLISTCND AS VARCHAR(2000)          
 DECLARE @CFGLSTDELETED AS VARCHAR(2000)          
 EXEC SP_XML_PREPAREDOCUMENT @HDOC OUTPUT, @IV_XMLDOC          
          
 DECLARE @TABLE_JOB_TEMP TABLE          
 (          
  ID_JOBS VARCHAR(10),          
  ID_PR VARCHAR(3),          
  ID_WO   VARCHAR(10),          
  DELETEFLAG Bit ,    
  DEBT_TYPE  VARCHAR(10) ,    
  ID_DEB_SEQ INT          
 )            
 INSERT INTO @TABLE_JOB_TEMP           
 SELECT ID_JOBS,ID_PR,ID_WO,'',DEBT_TYPE,ID_DEB_SEQ FROM OPENXML (@HDOC,'/ROOT/JOB',2)          
 WITH   (ID_JOBS VARCHAR(10),          
   ID_PR VARCHAR(3),          
   ID_WO VARCHAR(10),    
   DEBT_TYPE VARCHAR(10),    
   ID_DEB_SEQ INT)          
          
 --select * from @TABLE_JOB_TEMP          
          
 UPDATE @TABLE_JOB_TEMP          
 SET DELETEFLAG = 1          
 WHERE ID_JOBS IN (SELECT ID_JOB FROM TBL_WO_DETAIL DET, @TABLE_JOB_TEMP TEMP           
       WHERE  JOB_STATUS IN ('JCD','DEL','RINV','JST','INV')          
       AND DET.ID_WO_NO = TEMP.ID_WO           
       AND  DET.ID_WO_PREFIX = TEMP.ID_PR)    
       AND DEBT_TYPE = 'OHC'          
 SET @OV_RETVALUE=0          
-- SELECT * FROM @TABLE_JOB_TEMP          
 IF @@ERROR <> 0           
 SET @OV_RETVALUE = @@ERROR          
          
        
--Bug ID :- DEL Spare Part        
--Date   :- 26-july-2008        
--Desc   :- Availabel quantity has to back to stock once job is  deleted         
DECLARE @TEMPTABLE AS TABLE                          
 (                          
  ID_ITEM VARCHAR(30),                          
  ID_MAKE VARCHAR(10),                          
  ITEM_AVAIL_QTY DECIMAL                          
 )         
        
        
INSERT INTO @TEMPTABLE                          
 SELECT DISTINCT(ID_ITEM_JOB),ID_MAKE_JOB,                         
   SUM(JOBI_DELIVER_QTY)                         
 FROM    TBL_WO_JOB_DETAIL JOBDET,                     
   TBL_WO_HEADER WOHEAD, TBL_WO_DETAIL DET          
 WHERE   WOHEAD.WO_STATUS IN('INV','PINV','RINV','DEL','CSA','JST','RWRK')                           
 AND  WOHEAD.ID_WO_NO IN(SELECT ID_WO FROM @TABLE_JOB_TEMP WHERE DELETEFLAG = 0 AND DEBT_TYPE ='OHC')                           
 AND  WOHEAD.ID_WO_PREFIX IN(SELECT ID_PR FROM @TABLE_JOB_TEMP WHERE DELETEFLAG = 0 AND DEBT_TYPE ='OHC')                            
 AND  JOBDET.ID_WO_NO = WOHEAD.ID_WO_NO                          
 AND  JOBDET.ID_WO_PREFIX = WOHEAD.ID_WO_PREFIX           
 AND  DET.ID_WODET_SEQ=JOBDET.ID_WODET_SEQ_JOB           
 AND  DET.ID_JOB  IN (SELECT ID_JOBS FROM @TABLE_JOB_TEMP WHERE DELETEFLAG<>1 AND DEBT_TYPE ='OHC' )    
 GROUP BY ID_ITEM_JOB,ID_MAKE_JOB          
        
 UPDATE TBL_MAS_ITEM_MASTER                           
 SET    ITEM_AVAIL_QTY = TBL_MAS_ITEM_MASTER.ITEM_AVAIL_QTY + A.ITEM_AVAIL_QTY                           
 FROM   @TEMPTABLE A,@TABLE_JOB_TEMP T                          
 WHERE  TBL_MAS_ITEM_MASTER.ID_ITEM = A.ID_ITEM AND       
        TBL_MAS_ITEM_MASTER.ID_MAKE = A.ID_MAKE       
        
UPDATE TBL_WO_JOB_DETAIL          
SET JOBI_ORDER_QTY=0,          
 JOBI_DELIVER_QTY=0,          
 JOBI_BO_QTY=0    FROM TBL_WO_JOB_DETAIL JOBDET,                     
   TBL_WO_HEADER WOHEAD,TBL_WO_DETAIL DET          
 WHERE   WOHEAD.WO_STATUS IN('INV','PINV','RINV','DEL','CSA','JST','BAR','RWRK')                           
 AND  WOHEAD.ID_WO_NO IN(SELECT ID_WO FROM @TABLE_JOB_TEMP WHERE DELETEFLAG = 0 AND DEBT_TYPE ='OHC')                           
 AND  WOHEAD.ID_WO_PREFIX IN(SELECT ID_PR FROM @TABLE_JOB_TEMP WHERE DELETEFLAG = 0 AND DEBT_TYPE ='OHC')                            
 AND  JOBDET.ID_WO_NO = WOHEAD.ID_WO_NO                          
 AND  JOBDET.ID_WO_PREFIX = WOHEAD.ID_WO_PREFIX      
 AND  DET.ID_WODET_SEQ=JOBDET.ID_WODET_SEQ_JOB       
 AND DET.ID_JOB  IN (SELECT ID_JOBS FROM @TABLE_JOB_TEMP       
 WHERE DELETEFLAG<>1 AND DEBT_TYPE ='OHC')          
        
SELECT @DelSPCount=COUNT(*) FROM @TEMPTABLE  WHERE ITEM_AVAIL_QTY <> 0.0        
--change end        
      
      
        
-- UPDATE TBL_WO_DETAIL SET JOB_STATUS='DEL'           
-- WHERE ID_JOB IN(SELECT ID_JOBS FROM @TABLE_JOB_TEMP WHERE DELETEFLAG<>1)           
-- Bug ID :3866           
 UPDATE TBL_WO_DETAIL SET JOB_STATUS='DEL'           
 WHERE ID_JOB  IN (SELECT ID_JOBS FROM @TABLE_JOB_TEMP WHERE DELETEFLAG<>1)          
 AND  ID_WO_PREFIX = (SELECT DISTINCT ID_PR FROM @TABLE_JOB_TEMP WHERE DEBT_TYPE='OHC')          
 AND  ID_WO_NO  = (SELECT DISTINCT ID_WO FROM @TABLE_JOB_TEMP WHERE DEBT_TYPE='OHC')       
        
       
       
 SELECT @JOBCOUNT = COUNT(JOB_STATUS) FROM TBL_WO_DETAIL WHERE ID_WO_NO IN(SELECT ID_WO FROM @TABLE_JOB_TEMP)      
AND ID_JOB NOT IN (SELECT ID_JOB FROM TBL_WO_DETAIL WHERE JOB_STATUS ='DEL' AND ID_WO_NO IN(SELECT ID_WO FROM @TABLE_JOB_TEMP) AND ID_WO_PREFIX IN(SELECT ID_PR FROM @TABLE_JOB_TEMP))      
      
SELECT @WOJOBCOUNT = COUNT(*) FROM TBL_WO_DETAIL WHERE JOB_STATUS = 'RWRK' AND  ID_WO_NO IN(SELECT ID_WO FROM @TABLE_JOB_TEMP) AND ID_WO_PREFIX IN(SELECT ID_PR FROM @TABLE_JOB_TEMP)       
       
IF @JOBCOUNT = @WOJOBCOUNT       
BEGIN      
UPDATE TBL_WO_HEADER SET WO_STATUS='RWRK'      
WHERE   ID_WO_PREFIX = (SELECT DISTINCT ID_PR FROM @TABLE_JOB_TEMP)          
 AND  ID_WO_NO  = (SELECT DISTINCT ID_WO FROM @TABLE_JOB_TEMP)      
END      
      
    
DECLARE @DebitorType as varchar(10)    
SELECT @DebitorType = DEBT_TYPE FROM @TABLE_JOB_TEMP    
IF @DebitorType <> 'OHC'    
BEGIN   
----SELECT  ID_DEB_SEQ as 'ID_DEB_SEQ' FROM @TABLE_JOB_TEMP  
--DELETE FROM TBL_WO_DEBTOR_INVOICE_DATA WHERE  DEBTOR_SEQ = (SELECT  ID_DEB_SEQ FROM @TABLE_JOB_TEMP)  
--DELETE FROM TBL_WO_DEBITOR_DETAIL WHERE  ID_DBT_SEQ = (SELECT  ID_DEB_SEQ FROM @TABLE_JOB_TEMP)  
  
  
   
UPDATE TBL_WO_DEBITOR_DETAIL SET DEB_STATUS='DEL'           
 WHERE ID_JOB_ID  IN (SELECT ID_JOBS FROM @TABLE_JOB_TEMP WHERE DELETEFLAG<>1)          
 AND  ID_WO_PREFIX = (SELECT DISTINCT ID_PR FROM @TABLE_JOB_TEMP)          
 AND  ID_WO_NO  = (SELECT DISTINCT ID_WO FROM @TABLE_JOB_TEMP)      
 AND ID_DBT_SEQ = (SELECT  ID_DEB_SEQ FROM @TABLE_JOB_TEMP)      
        
END    
    
          
        
        
 IF @@ERROR = 0           
Begin         
   SET @OV_RETVALUE = 'DEL'        
--BUG ID:- DELETE SPARE PART          
--DATE :- 25-JULY-2008          
--DESC :- Should pop-up message, when records deleting with Spare Part           
    set @DelSPCountSTR=  @DelSPCount                     
 SET @OV_RETVALUE=@OV_RETVALUE + ';' + @DelSPCountSTR          
--CHANGE END           
end        
 ELSE          
   SET @OV_RETVALUE = @@ERROR           
          
 -- TO FETCH THE RECORDS WHICH CANT BE DELETED           
 SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + '; ' + ID_JOBS,ID_JOBS)                 
 FROM    @TABLE_JOB_TEMP WHERE DELETEFLAG = 1          
          
 -- TO FETCH THE RECORDS WHICH CAN BE DELETED           
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + '; ' + ID_JOBS,ID_JOBS)          
 FROM    @TABLE_JOB_TEMP WHERE DELETEFLAG = 0          
          
 SET @OV_CNTDELETE   =  @CONFIGLISTCND          
 SET @OV_DELETEDCFG  =  @CFGLSTDELETED          
 SELECT @OV_RETVALUE AS BB          
 SELECT @OV_CNTDELETE           
 SELECT @OV_DELETEDCFG          
 EXEC SP_XML_REMOVEDOCUMENT @HDOC          
END          
          
/*          
EXEC usp_WO_JOBS_DELETE '<ROOT><JOB><ID_JOBS>1</ID_JOBS><ID_PR>WOT</ID_PR> <ID_WO>101</ID_WO></JOB><JOB><ID_JOBS>2</ID_JOBS><ID_PR>WOT</ID_PR> <ID_WO>101</ID_WO></JOB><JOB><ID_JOBS>3</ID_JOBS><ID_PR>WOT</ID_PR> <ID_WO>101</ID_WO></JOB><JOB><ID_JOBS>4</ID
   
   
_      
        
JOBS><ID_PR>WOT</ID_PR> <ID_WO>101</ID_WO></JOB></ROOT>','','',''          
SELECT JOB_STATUS,* FROM TBL_WO_DETAIL WHERE ID_WO_NO = '101' AND ID_WO_PREFIX = 'WOT'           
-- JOB_STATUS='DEL' DDELUSE          
*/          
          
          
          
          
          
          
          
          
GO

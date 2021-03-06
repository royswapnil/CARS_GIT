/****** Object:  StoredProcedure [dbo].[USP_IN_INVLST_VIEW]    Script Date: 8/7/2017 1:19:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_INVLST_VIEW]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_IN_INVLST_VIEW]
GO
/****** Object:  StoredProcedure [dbo].[USP_IN_INVLST_VIEW]    Script Date: 8/7/2017 1:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_IN_INVLST_VIEW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[USP_IN_INVLST_VIEW] AS' 
END
GO
/*************************************** Application: MSG *************************************************************                
* Module : Transaction                
* File name : USP_IN_READYINVLST_VIEW.PRC                
* Purpose : Get List of Possible invoices for given serach parameters                
* Author : Rajput Yogendrasinh H                
* Date  : 23.08.2006                
*********************************************************************************************************************/                
/*********************************************************************************************************************                  
I/P : -- Input Parameters                
O/P : -- Output Parameters                
Error Code                
Description                
   NT.VerNO : NOV21.0             
********************************************************************************************************************/                
--'*********************************************************************************'*********************************                
--'* Modified History :                   
--'* S.No  RFC No/Bug ID   Date        Author       Description                 
--*#0001#  --              23-03-2007  Rajput Y H   Customer Name lenght is made varchar(50) from varchar(20)               
--*#0001#  --              26-03-2007  Rajput Y H   Conditions changed from 'or' logic to 'and' for search criteria               
--'*********************************************************************************'*********************************                
                
--select * from sysobjects where xtype = 'u' order by name              
ALTER PROCEDURE [dbo].[USP_IN_INVLST_VIEW]                        
(                        
 @iv_ID_Login varchar(20),                        
 @iv_ID_CUSTOMER varchar(10),                        
 @iv_ID_VEH_SEQ int,                        
 @iv_ID_WO_NO varchar(10)  ,      
 @IV_LANGUAGE VARCHAR(50) ,
 @IV_CHK_EMAIL BIT                                                 
)                        
AS                        
BEGIN            
SET NOCOUNT ON

BEGIN TRY            
                        
--DECLARE @JOB_DEB_LIST TABLE                         
--(                        
-- ID_WO_PREFIX  VARCHAR(3),                        
-- ID_WO_NO  VARCHAR(13),                        
-- DT_ORDER  DATETIME,                        
-- NO_OF_JOBS  INT, --May be use function                        
-- WO_VEH_REG_NO  VARCHAR(10),                        
-- WO_AMOUNT  DECIMAL(11,2),                        
--                         
-- ID_WODET_SEQ  INT,                        
-- ID_JOB  INT,                        
-- WO_JOB_TXT  TEXT,                        
-- ID_REP_CODE_WO  INT,                        
-- JOB_AMOUNT DECIMAL(11,2),                        
--                         
-- ID_JOB_DEB  VARCHAR(10),                        
-- DEB_NAME  VARCHAR(10),                        
-- FLG_CUST_BATCHINV  BIT,                        
--                        
-- IS_SELECTED  BIT                        
--)                        
              

		DECLARE @LANG INT  
		SELECT @LANG=ID_LANG FROM TBL_MAS_LANGUAGE WHERE LANG_NAME=@IV_LANGUAGE

		DECLARE @TRUE AS VARCHAR(20)
		SELECT @TRUE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_TRUE' AND ISDATA=1

		DECLARE @FALSE AS VARCHAR(20)
		SELECT @FALSE=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_FALSE' AND ISDATA=1  
		
		DECLARE @ORDER AS VARCHAR(10)
		SELECT @ORDER=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_ORDER' AND ISDATA=1
		
		DECLARE @CRSL AS VARCHAR(10)
		SELECT @CRSL=ERR_DESC FROM TBL_MAS_ERR_MESSAGE WHERE ID_LANG=@LANG AND ERR_ID='D_CRSL' AND ISDATA=1        

DECLARE @DEP INT                      
DECLARE @SUB INT                      
SELECT @DEP=ID_Dept_User ,@SUB=ID_Subsidery_User                     
 FROM TBL_MAS_USERS                     
 WHERE ID_Login=@iv_ID_Login         
 
 DECLARE @FLG_WH INT  
 SELECT @FLG_WH = FLG_DPT_WareHouse FROM TBL_MAS_DEPT WHERE ID_Dept = @DEP and ID_SUBSIDERY_DEPT =  @SUB    
 
 DECLARE @DISP_RINV_PINV BIT
 SELECT @DISP_RINV_PINV = ISNULL(DISP_RINV_PINV,0) FROM TBL_MAS_WO_CONFIGURATION c where c.ID_DEPT_WO= @DEP and ID_SUBSIDERY_WO=@SUB
                 
DECLARE @JOB_DEB_LIST TABLE                         
(                        
 ID_WO_PREFIX  VARCHAR(10),                        
 ID_WO_NO  VARCHAR(23),                        
 DT_ORDER  DATETIME,                        
 NO_OF_JOBS  INT, --May be use function                        
 WO_VEH_REG_NO  VARCHAR(20),                        
 WO_AMOUNT  DECIMAL(21,2),            
                         
 ID_WODET_SEQ  INT,                        
 ID_JOB  INT,                        
 WO_JOB_TXT  VARCHAR(7000),      
 ID_REP_CODE_WO  INT,                        
 JOB_AMOUNT DECIMAL(21,2),            
 ID_RPG_CODE_WO  INT,            
         
                         
 ID_JOB_DEB  VARCHAR(20), --See #0001#                       
 DEB_NAME  VARCHAR(100),     
 DEB_ID  VARCHAR(50),     
 MAXINVOICE VARCHAR(50),                        
 FLG_CUST_BATCHINV  BIT,                        
                        
 IS_SELECTED  BIT,
--Bug ID:- SS3 Invoice
--date :- 15-Jan-2008
 PayType  VARCHAR(20),
 WO_TYPE_WOH VARCHAR(10),
 WO_TYPE VARCHAR(10) 
--change end                      
)                   
IF (@FLG_WH = 1) 
BEGIN                         
INSERT INTO @JOB_DEB_LIST  
                    
	 select    distinct           
	   a.ID_WO_PREFIX AS ID_WO_PREFIX                        
	  ,a.ID_WO_NO AS ID_WO_NO                    
	  ,a.DT_ORDER                     
	  --,convert(varchar(20),DT_ORDER,103) as DT_ORDER       
	  ,0 AS NO_OF_JOBS --TO BE COMPUTED LATER                        
	  ,A.WO_VEH_REG_NO AS WO_VEH_REG_NO                       
	  ,0 AS WO_AMOUNT --TO BE COMPUTED LATER                        
	  ,c.ID_WODET_SEQ AS ID_WODET_SEQ                        
	  ,c.ID_JOB  AS ID_JOB                        
	  ,cast(c.WO_JOB_TXT as varchar(7000)) AS WO_JOB_TXT                        
	  ,c.ID_REP_CODE_WO as ID_REP_CODE_WO   
		-- Modified Date : 3rd February 2010
		-- Description   : Added Extra parameter called ID_JOB
		--					If we add 2 jobs for a workorder, its showing same amount                 
	  ,
	0--  dbo.InvoiceJobAmt(c.ID_WODET_SEQ,b.ID_JOB_DEB,ID_JOB )
	 as JOB_AMOUNT            
		-- End Of Modification *******************
	  ,c.ID_RPG_CODE_WO as ID_RPG_CODE_WO                   
	  ,b.ID_JOB_DEB as ID_JOB_DEB                        
	  /*      
	  '-----------------------------------------------      
	  'Modified Date  : 09-Jun-08      
	  'Description    : To display customer name from TBL_INV_HEADER     
	  'bug No         : 2458      
	  '-------------------------------------------------      
	  */       
	  ,    
	  CASE WHEN A.ID_CUST_WO = jd.ID_CUST_WO THEN    
		a.CUST_NAME    
	  ELSE    
		d.CUST_NAME    
	  END                      
	  as DEB_NAME                        
	  -- End of fix for 2458    
	    
	  ,CASE WHEN A.ID_CUST_WO = jd.ID_CUST_WO THEN    
		A.ID_CUST_WO    
	  ELSE    
		jd.ID_CUST_WO    
	  END                      
	 -- CASE WHEN b.DEBITOR_TYPE = 'C' THEN    
	 --a.ID_CUST_WO   
	 -- ELSE    
		--	case when C.ID_JOB=0 then
		--		jd.ID_CUST_WO
		--	else
		--		d.ID_CUSTOMER    
		--	end 
	 -- END                      
	  as DEB_ID    
	  ,    
	  CASE WHEN b.DEBITOR_TYPE = 'C' THEN    
	 dbo.FETCHROWMAXIMUM(@SUB, @DEP, a.ID_CUST_WO, a.WO_CUST_GROUPID)      
	  ELSE    
	 dbo.FETCHROWMAXIMUM(@SUB, @DEP, d.ID_CUSTOMER, d.ID_CUST_GROUP)      
	  END                      
	  as MAXINVOICE                        
	  -- End of fix    
	    
	  ,d.FLG_CUST_BATCHINV as FLG_CUST_BATCHINV                        
	  ,1 as IS_SELECTED,
	--Bug ID:- SS3 Invoice
	--date :- 15-Jan-2008
	CASE WHEN D.ID_CUST_PAY_TYPE IS NOT NULL THEN              
	  (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_SETTINGS A            
		   WHERE A.ID_SETTINGS = WOHEAD.ID_PAY_TYPE_WO) 

	   ELSE ''              
	   END AS PayType,
		CASE WHEN WOHEAD.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH ,
		WOHEAD.WO_TYPE_WOH AS WO_TYPE                          
	 --change end                       
	 from Vw_WorkOrder_Header a                        
	 /* Modifcation Start */
			INNER JOIN
				TBL_WO_DETAIL  C
			ON
				A.ID_WO_NO = C.ID_WO_NO AND                        
				A.ID_WO_PREFIX = C.ID_WO_PREFIX 
	--Bug ID:- SS3 Invoice
	--date :- 15-Jan-2008
			INNER JOIN TBL_WO_HEADER WOHEAD
			ON 
				A.ID_WO_NO = WOHEAD.ID_WO_NO AND                        
				A.ID_WO_PREFIX = WOHEAD.ID_WO_PREFIX
	--change end
			LEFT JOIN
				TBL_WO_DEBITOR_DETAIL B 
			ON B.ID_WO_NO =C.ID_WO_NO 
				AND B.ID_WO_PREFIX = C.ID_WO_PREFIX                          
				AND  B.ID_JOB_ID = C.ID_JOB 

				--A.ID_CUST_WO=D.ID_CUSTOMER
				
			left outer join TBL_WO_JOB_DETAIL jd on jd.ID_WODET_SEQ_JOB=C.ID_WODET_SEQ
			LEFT JOIN
				TBL_MAS_CUSTOMER D
			ON                        
				jd.ID_CUST_WO=D.ID_CUSTOMER
			/* Modifcation End */                       
	                   
	where 
	c.ID_WODET_SEQ not in                         
	   (select invD.ID_WODET_INV                         
		from TBL_INV_DETAIL invD inner join TBL_INV_HEADER invH on invD.ID_INV_NO=invH.ID_INV_NO       
	   ----------------------------------------------------            
		-- Modified By  : shilpa S Chandrashekhar    
		-- Modified Date : 09th April 2008            
		-- Bug No   : 1544      
	   ---------------------------------------------------------      
	 inner join TBL_WO_DETAIL  c on c.ID_WODET_SEQ = invD.ID_WODET_INV     
		where invH.ID_CN_NO is null  and c.JOB_STATUS in ('INV') and c.ID_JOB = invD.id_job)    
	   -- --------------------- End Of Modification --------------------                     
	   --and c.JOB_STATUS IN ('RINV','PINV') --724
	  and 
	   (
		( @DISP_RINV_PINV = 1 and c.JOB_STATUS IN ('RINV','PINV'))
		or
		( @DISP_RINV_PINV = 0 and c.JOB_STATUS IN ('RINV'))
	   )  	  
	  
	  and             
		(            
	 ( a.WO_NUMBER=@iv_ID_WO_NO or @iv_ID_WO_NO is null)                        
		AND ( a.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                        
		AND ( a.ID_VEH_SEQ_WO =@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)            
		)                        
	  and ( a.ID_Dept=@DEP )      
	  and ( a.ID_Subsidery=@SUB)    
	  ---------------------------------------------------------            
	 -- Modified By  : shilpa S Chandrashekhar    
	 -- Modified Date : 09th April 2008            
	 -- Bug No   : 1544    
		-- Description  : Inserted These lines      
	  ---------------------------------------------------------                    
	 /* Modifcation Start */
		AND ( B.ID_JOB_DEB + B.ID_WO_PREFIX + B.ID_WO_NO + CAST(B.ID_JOB_ID AS VARCHAR(10)) NOT IN 
				(
					SELECT (INVH.ID_DEBITOR + INVD.ID_WO_PREFIX + INVD.ID_WO_NO + CAST(INVD.ID_JOB AS VARCHAR(10)))
					FROM TBL_INV_DETAIL INVD 
						 INNER JOIN
							TBL_INV_HEADER INVH
						 ON INVD.ID_INV_NO = INVH.ID_INV_NO     
							AND B.ID_JOB_DEB =  INVH.ID_DEBITOR
							AND INVH.ID_CN_NO IS NULL
						where
						B.ID_WO_NO = INVD.ID_WO_NO 
							AND B.ID_WO_PREFIX = INVD.ID_WO_PREFIX   
							AND INVD.id_job = B.ID_JOB_ID 
						 
				) OR  B.ID_JOB_DEB IS NULL)
		 /* Modifcation Start */     
	   ---------------- End Of Modification ----------------------    
	  AND
	 
	  -- (SELECT COUNT (*) AS ID_CN_NO from TBL_INV_HEADER INH INNER JOIN TBL_INV_DETAIL IND
			--ON INH.ID_INV_NO = IND.ID_INV_NO
			--INNER JOIN TBL_WO_DETAIL WOD
			--ON WOD.ID_WO_NO = IND.ID_WO_NO AND WOD.ID_WO_PREFIX = WOD.ID_WO_PREFIX AND WOD.ID_JOB = isnull(IND.id_job,0)
			--INNER JOIN TBL_WO_DEBITOR_DETAIL WDD
			--ON WDD.ID_JOB_DEB =INH.ID_DEBITOR AND WOD.ID_WO_NO = WDD.ID_WO_NO AND WOD.ID_WO_PREFIX = WDD.ID_WO_PREFIX AND WOD.ID_JOB = WDD.ID_JOB_ID
			--WHERE WDD.ID_WO_NO = B.ID_WO_NO AND WDD.ID_WO_PREFIX =B.ID_WO_PREFIX AND WDD.ID_JOB_ID=B.ID_JOB_ID AND WDD.ID_JOB_DEB = B.ID_JOB_DEB AND ID_CN_NO IS NULL) = 0    
	      
	 
	 (SELECT COUNT (*) AS ID_CN_NO from TBL_INV_HEADER INH 
			INNER JOIN TBL_INV_DETAIL IND
			ON INH.ID_INV_NO = IND.ID_INV_NO
			INNER JOIN TBL_WO_DETAIL WOD
			ON WOD.ID_WO_NO = IND.ID_WO_NO AND WOD.ID_WO_PREFIX = IND.ID_WO_PREFIX AND WOD.ID_JOB = isnull(IND.id_job,0)
			INNER JOIN TBL_WO_JOB_DETAIL WOJ
			ON WOD.ID_WO_NO = WOJ.ID_WO_NO AND WOD.ID_WO_PREFIX = WOJ.ID_WO_PREFIX AND WOJ.ID_CUST_WO = INH.ID_DEBITOR
			WHERE
     		 WOJ.ID_WO_NO= jd.ID_WO_NO AND WOJ.ID_WO_PREFIX =jd.ID_WO_PREFIX AND WOJ.ID_CUST_WO =jd.ID_CUST_WO AND ID_CN_NO IS NULL) = 0 
       AND -- If uncheck orders with customer email invoice checked should nt be displayed 
	   (( @IV_CHK_EMAIL = 0 AND ISNULL(D.FLG_INV_EMAIL,0) = 0 ) OR (  @IV_CHK_EMAIL = 1 AND (1=1 ))) 

END
 ELSE
 BEGIN
   INSERT INTO @JOB_DEB_LIST  
                    
	 select    distinct           
	   a.ID_WO_PREFIX AS ID_WO_PREFIX                        
	  ,a.ID_WO_NO AS ID_WO_NO                    
	  ,a.DT_ORDER                     
	  --,convert(varchar(20),DT_ORDER,103) as DT_ORDER       
	  ,0 AS NO_OF_JOBS --TO BE COMPUTED LATER                        
	  ,A.WO_VEH_REG_NO AS WO_VEH_REG_NO                       
	  ,0 AS WO_AMOUNT --TO BE COMPUTED LATER                        
	  ,c.ID_WODET_SEQ AS ID_WODET_SEQ                        
	  ,c.ID_JOB  AS ID_JOB                        
	  ,cast(c.WO_JOB_TXT as varchar(7000)) AS WO_JOB_TXT                        
	  ,c.ID_REP_CODE_WO as ID_REP_CODE_WO   
		-- Modified Date : 3rd February 2010
		-- Description   : Added Extra parameter called ID_JOB
		--					If we add 2 jobs for a workorder, its showing same amount                 
	  ,
	  -- dbo.InvoiceJobAmt(c.ID_WODET_SEQ,b.ID_JOB_DEB,ID_JOB )
	 0 as JOB_AMOUNT            
		-- End Of Modification *******************
	  ,c.ID_RPG_CODE_WO as ID_RPG_CODE_WO                   
	  ,b.ID_JOB_DEB as ID_JOB_DEB                        
	  /*      
	  '-----------------------------------------------      
	  'Modified Date  : 09-Jun-08      
	  'Description    : To display customer name from TBL_INV_HEADER     
	  'bug No         : 2458      
	  '-------------------------------------------------      
	  */       
	  ,    
	  CASE WHEN A.ID_CUST_WO = B.ID_JOB_DEB THEN    
			a.CUST_NAME    
	  ELSE    
			d.CUST_NAME    
	  END                      
	  as DEB_NAME                        
	  -- End of fix for 2458    
	    
	  /*      
	  '-----------------------------------------------      
	  'Modified Date  : 25-July-08      
	  'Description    : To pick Customer id and Invoice number      
	  '-------------------------------------------------      
	  */       
	 --,d.CUST_NAME as DEB_NAME    
	  , B.ID_JOB_DEB
	 -- CASE WHEN b.DEBITOR_TYPE = 'C' THEN    
	 --a.ID_CUST_WO   
	 -- ELSE    
		--	case when C.ID_JOB=0 then
		--		jd.ID_CUST_WO
		--	else
		--		d.ID_CUSTOMER    
		--	end 
	 -- END                      
	  as DEB_ID    
	  ,    
	  CASE WHEN b.DEBITOR_TYPE = 'C' THEN    
	 dbo.FETCHROWMAXIMUM(@SUB, @DEP, a.ID_CUST_WO, a.WO_CUST_GROUPID)      
	  ELSE    
	 dbo.FETCHROWMAXIMUM(@SUB, @DEP, d.ID_CUSTOMER, d.ID_CUST_GROUP)      
	  END                      
	  as MAXINVOICE                        
	  -- End of fix    
	    
	  ,d.FLG_CUST_BATCHINV as FLG_CUST_BATCHINV                        
	  ,1 as IS_SELECTED,
	--Bug ID:- SS3 Invoice
	--date :- 15-Jan-2008
	CASE WHEN D.ID_CUST_PAY_TYPE IS NOT NULL THEN              
	  (SELECT ISNULL(DESCRIPTION,'') FROM  TBL_MAS_SETTINGS A            
		   WHERE A.ID_SETTINGS = WOHEAD.ID_PAY_TYPE_WO) 

	   ELSE ''              
	   END AS PayType,
		CASE WHEN WOHEAD.WO_TYPE_WOH  = 'ORD' THEN @ORDER ELSE @CRSL END AS WO_TYPE_WOH ,
		WOHEAD.WO_TYPE_WOH AS WO_TYPE                          
	 --change end                       
	 from Vw_WorkOrder_Header a                        
	 /* Modifcation Start */
			INNER JOIN
				TBL_WO_DETAIL  C
			ON
				A.ID_WO_NO = C.ID_WO_NO AND                        
				A.ID_WO_PREFIX = C.ID_WO_PREFIX 
	--Bug ID:- SS3 Invoice
	--date :- 15-Jan-2008
			INNER JOIN TBL_WO_HEADER WOHEAD
			ON 
				A.ID_WO_NO = WOHEAD.ID_WO_NO AND                        
				A.ID_WO_PREFIX = WOHEAD.ID_WO_PREFIX
	--change end
			LEFT JOIN
				TBL_WO_DEBITOR_DETAIL B 
			ON B.ID_WO_NO =C.ID_WO_NO 
				AND B.ID_WO_PREFIX = C.ID_WO_PREFIX                          
				AND  B.ID_JOB_ID = C.ID_JOB 
			LEFT JOIN
				TBL_MAS_CUSTOMER D
			ON                        
				B.ID_JOB_DEB=D.ID_CUSTOMER
				--A.ID_CUST_WO=D.ID_CUSTOMER
				
			left outer join TBL_WO_JOB_DETAIL jd on jd.ID_WODET_SEQ_JOB=C.ID_WODET_SEQ

			/* Modifcation End */                       
	                   
	where 
	c.ID_WODET_SEQ not in                         
	   (select invD.ID_WODET_INV                         
		from TBL_INV_DETAIL invD inner join TBL_INV_HEADER invH on invD.ID_INV_NO=invH.ID_INV_NO       
	   ----------------------------------------------------            
		-- Modified By  : shilpa S Chandrashekhar    
		-- Modified Date : 09th April 2008            
		-- Bug No   : 1544      
	   ---------------------------------------------------------      
	 inner join TBL_WO_DETAIL  c on c.ID_WODET_SEQ = invD.ID_WODET_INV     
		where invH.ID_CN_NO is null  and c.JOB_STATUS in ('INV') and c.ID_JOB = invD.id_job)    
	   -- --------------------- End Of Modification --------------------                     
	 --and c.JOB_STATUS IN ('RINV','PINV') --724
	  and 
	   (
		( @DISP_RINV_PINV = 1 and c.JOB_STATUS IN ('RINV','PINV'))
		or
		( @DISP_RINV_PINV = 0 and c.JOB_STATUS IN ('RINV'))
	   )  
	                       
	  and             
		(            
	 ( a.WO_NUMBER=@iv_ID_WO_NO or @iv_ID_WO_NO is null)                        
		AND ( a.ID_CUST_WO=@iv_ID_CUSTOMER or @iv_ID_CUSTOMER is null)                        
		AND ( a.ID_VEH_SEQ_WO =@iv_ID_VEH_SEQ or @iv_ID_VEH_SEQ is null or @iv_ID_VEH_SEQ=0)            
		)                        
	  and ( a.ID_Dept=@DEP )      
	  and ( a.ID_Subsidery=@SUB)    
	  ---------------------------------------------------------            
	 -- Modified By  : shilpa S Chandrashekhar    
	 -- Modified Date : 09th April 2008            
	 -- Bug No   : 1544    
		-- Description  : Inserted These lines      
	  ---------------------------------------------------------                    
	 /* Modifcation Start */
		AND ( B.ID_JOB_DEB + B.ID_WO_PREFIX + B.ID_WO_NO + CAST(B.ID_JOB_ID AS VARCHAR(10)) NOT IN 
				(
					SELECT (INVH.ID_DEBITOR + INVD.ID_WO_PREFIX + INVD.ID_WO_NO + CAST(INVD.ID_JOB AS VARCHAR(10)))
					FROM TBL_INV_DETAIL INVD 
						 INNER JOIN
							TBL_INV_HEADER INVH
						 ON INVD.ID_INV_NO = INVH.ID_INV_NO     
							AND B.ID_JOB_DEB =  INVH.ID_DEBITOR
							AND INVH.ID_CN_NO IS NULL
						where
						B.ID_WO_NO = INVD.ID_WO_NO 
							AND B.ID_WO_PREFIX = INVD.ID_WO_PREFIX   
							AND INVD.id_job = B.ID_JOB_ID 
						 
				) OR  B.ID_JOB_DEB IS NULL)
		 /* Modifcation Start */     
	   ---------------- End Of Modification ----------------------    
	  AND
	 
	   (SELECT COUNT (*) AS ID_CN_NO from TBL_INV_HEADER INH INNER JOIN TBL_INV_DETAIL IND
			ON INH.ID_INV_NO = IND.ID_INV_NO
			INNER JOIN TBL_WO_DETAIL WOD
			ON WOD.ID_WO_NO = IND.ID_WO_NO AND WOD.ID_WO_PREFIX = IND.ID_WO_PREFIX AND WOD.ID_JOB = isnull(IND.id_job,0)
			INNER JOIN TBL_WO_DEBITOR_DETAIL WDD
			ON WDD.ID_JOB_DEB =INH.ID_DEBITOR AND WOD.ID_WO_NO = WDD.ID_WO_NO AND WOD.ID_WO_PREFIX = WDD.ID_WO_PREFIX AND WOD.ID_JOB = WDD.ID_JOB_ID
			WHERE WDD.ID_WO_NO = B.ID_WO_NO AND WDD.ID_WO_PREFIX =B.ID_WO_PREFIX AND WDD.ID_JOB_ID=B.ID_JOB_ID AND WDD.ID_JOB_DEB = B.ID_JOB_DEB AND ID_CN_NO IS NULL) = 0    
       AND
		(( @IV_CHK_EMAIL = 0 AND ISNULL(D.FLG_INV_EMAIL,0) = 0 ) OR (  @IV_CHK_EMAIL = 1 AND (1=1 )))	      
	 
 END
---dbg                        
--print 'Hi'    

--select '@JOB_DEB_LIST', * from @JOB_DEB_LIST

UPDATE JOBLIST SET JOB_AMOUNT=ISNULL(JOBSUM,0)+ISNULL(JOBVAT,0)
FROM @JOB_DEB_LIST JOBLIST
INNER JOIN TBL_WO_DEBTOR_INVOICE_DATA INVD ON JOBLIST.ID_WO_NO = INVD.ID_WO_NO AND JOBLIST.ID_WO_PREFIX=INVD.ID_WO_PREFIX AND JOBLIST.ID_JOB=INVD.ID_JOB_ID
AND JOBLIST.ID_JOB_DEB=INVD.DEBTOR_ID
WHERE INVD.LINE_TYPE='OWNRISK'                 
                        
select                           
 distinct ID_WO_NO,                        
 ID_WO_PREFIX,                        
--Modified Date: 04 Aug  
--Bug Id: 3181  
--  DT_ORDER  ,     
CONVERT(VARCHAR(10), DT_ORDER, 101) AS DT_ORDER,  
--End of Modification  
 --J_Main.NO_OF_JOBS                           
    (SELECT COUNT(*)                       
    FROM @JOB_DEB_LIST j                         
    WHERE j.ID_WO_NO=J_Main.ID_WO_NO                 
  and j.ID_WO_PREFIX=J_Main.ID_WO_PREFIX                
  and j.ID_JOB_DEB=J_Main.ID_JOB_DEB) as NO_OF_JOBS                 
 ,                        
 DEB_NAME,                        
 DEB_ID,     
 MAXINVOICE,     
 ID_JOB_DEB,                        
 WO_VEH_REG_NO ,  
 (case when J_Main.ID_JOB_DEB is null then  
  (SELECT  SUM(j.JOB_AMOUNT )              
    FROM @JOB_DEB_LIST j                         
    WHERE j.ID_WO_NO=J_Main.ID_WO_NO                 
  and j.ID_WO_PREFIX=J_Main.ID_WO_PREFIX 
  and ISNULL(j.DEB_ID,0)=ISNULL(J_Main.DEB_ID,0)               
 ) 
 else
                
    (SELECT sum(j.JOB_AMOUNT)                
    FROM @JOB_DEB_LIST j                         
    WHERE j.ID_WO_NO=J_Main.ID_WO_NO                 
  and j.ID_WO_PREFIX=J_Main.ID_WO_PREFIX                
  and ISNULL(j.ID_JOB_DEB,0)=ISNULL(J_Main.ID_JOB_DEB,0)) 
  end )as WO_AMOUNT ,                        
CASE WHEN FLG_CUST_BATCHINV=1 THEN @TRUE ELSE @FALSE END AS FLG_CUST_BATCHINV,
--Bug ID:- SS3 Invoice
--date :- 15-Jan-2008
 CASE PayType      
 WHEN 'Cash' THEN 1      
 ELSE 0      
 END 'PayType'
 ,J_Main.dt_order  -- 8th July 2010 - Added to get order date for sorting   
,J_Main.WO_TYPE_WOH,
J_Main.WO_TYPE
--change end                    
from @JOB_DEB_LIST J_Main  
/*8th July 2010 - Added to display latest records first*/   
ORDER BY J_Main.dt_order DESC, J_Main.ID_WO_NO DESC  
/*Change End*/                    

SELECT                        
 ROW_NUMBER() over(order by ID_WO_PREFIX) AS JOB_ROW_NUMBER,                        
 ID_WO_NO,                        
 ID_WO_PREFIX,                        
 ID_WODET_SEQ  ,                        
 ID_JOB  ,                        
 WO_JOB_TXT  ,                        
 ID_REP_CODE_WO  as ID_REP_CODE_WO1,           
 case when  ID_REP_CODE_WO is not null then          
 (select isnull(RP_REPCODE_DES,'') from TBL_MAS_REPAIRCODE          
where ID_REP_CODE = ID_REP_CODE_WO)          
else ''          
end as 'ID_REP_CODE_WO',          
 ID_RPG_CODE_WO as ID_RPG_CODE_WO1,            
case when ID_RPG_CODE_WO is not null then           
(select isnull(RP_DESC,'') from TBL_MAS_REP_PACKAGE where ID_RPKG_SEQ  = ID_RPG_CODE_WO)             
else ''                
end as  'ID_RPG_CODE_WO',          
 JOB_AMOUNT as JOB_AMOUNT1,      
DBO.FN_MULTILINGUAL_NUMERIC(JOB_AMOUNT, @IV_LANGUAGE) as JOB_AMOUNT ,                       
 ID_JOB_DEB,                        
 IS_SELECTED,
--Bug ID:- SS3 Invoice
--date :- 15-Jan-2008
DEB_ID
--change end
	                        
FROM @JOB_DEB_LIST                        
              
                         
END TRY
BEGIN CATCH
		-- Execute error retrieval routine.
		EXECUTE usp_GetErrorInfo;
END CATCH;                  
                     
END                                  
                
                
/*                
use msg_dev                
                
declare @abc as varchar(1)                
declare @in as int                
EXEC USP_IN_INVLST_VIEW 'Admin',null,0,null ,'English'               
select * from TBL_MAS_SETTINGS WHERE 1=1                
select * from tbl_wo_header            
select * from Vw_WorkOrder_Header                
select * from tbl_wo_job_detail                
select * from tbl_wo_detail                
select * from tbl_wo_debitor_detail                
select * from TBL_MAS_CUSTOMER                
                
  select * from TBL_WO_DEBITOR_DETAIL                 
  where ID_WO_NO IN                
  (select ID_WO_NO from TBL_WO_HEADER                 
    )                 
                
*/

GO

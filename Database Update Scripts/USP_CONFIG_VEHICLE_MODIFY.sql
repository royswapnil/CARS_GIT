/****** Object:  StoredProcedure [dbo].[USP_CONFIG_VEHICLE_MODIFY]    Script Date: 04/04/2016 12:44:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_VEHICLE_MODIFY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_VEHICLE_MODIFY]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_VEHICLE_MODIFY]    Script Date: 04/04/2016 12:44:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_VEHICLE_MODIFY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*************************************** APPLICATION: MSG *************************************************************                  
* MODULE    : CONFIG                  
* FILE NAME : USP_CONFIG_VEHICLE_MODIFY.PRC                  
* PURPOSE   : TO MODIFY SETTINGS IN  VEHICLE CONFIGURATION                 
* AUTHOR    : KRISHNAVENI                  
* DATE      : 05.DEC.2006                  
*********************************************************************************************************************/                  
/*********************************************************************************************************************                    
I/P : -- INPUT PARAMETERS                  
 @IV_XMLDOC - VALID XML DOCUMENT CONTANING VALUES TO BE MODIFYED                  
                  
O/P : -- OUTPUT PARAMETERS                  
 @OV_RETVALUE - ''INSFLG'' IF ERROR, ''OK'' OTHERWISE                  
 @OV_CANNOTDELETE - LIST OF CONFIGURATION ITEMS WHICH CANNOT BE MODIFYED AS THEY ALREADY EXISTS.                  
                  
ERROR CODE                  
DESCRIPTION                  
********************************************************************************************************************/                  
/*********************************************************************************''*********************************                  
* MODIFIED HISTORY :                     
* S.NO  RFC NO/BUG ID   DATE        AUTHOR  DESCRIPTION                   
* #0001#                  
*********************************************************************************''**********************************/                  
-- ****************************************
-- Modified Date : 23rd December 2008
-- Bug Id		 : Warrenty List - Row No:126
-- Description	 : Added Vat Code for Make Code

                  
CREATE PROC [dbo].[USP_CONFIG_VEHICLE_MODIFY]                  
 (                  
   @IV_XMLMAKE       ntext,                 
   @IV_XMLMODELGROUP  ntext,                 
   @IV_CREATEDBY    VARCHAR(20),                  
   @OV_RETVALUE     VARCHAR(10)  OUTPUT,                  
   @OV_CANNOTMODIFY VARCHAR(500) OUTPUT,  --ALREADY EXISTS                  
   @OV_MODIFYEDCFG  VARCHAR(500) OUTPUT  --MODIFYED SUCCESSFULLY                  
 )                  
AS                  
BEGIN                  
 DECLARE @DOCHANDLE INT                   
 DECLARE @DOCHANDLE1 INT                 
 DECLARE @MODIFIED AS VARCHAR(2000)                  
 DECLARE @NOTMOD AS VARCHAR(2000)                  
 DECLARE @MODIFIED1 AS VARCHAR(2000)                  
 DECLARE @NOTMOD1 AS VARCHAR(2000)                  
          
                 
 EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @IV_XMLMAKE                  
 DECLARE @MODIFY_MAKE_LIST TABLE                  
 (                  
	ID_MAKE        VARCHAR(10),                  
	ID_MAKE_NAME   VARCHAR(10),           
	ID_MAKE_PRICECODE   VARCHAR(10),      
	MAKEDISCODE        VARCHAR(10),
	MAKE_VATCODE VARCHAR(50),             
	IS_USED        BIT                  
 )                  
 INSERT INTO @MODIFY_MAKE_LIST                  
 SELECT ID_MAKE,                  
        ID_MAKE_NAME ,           
		ID_MAKE_PRICECODE ,         
		MAKEDISCODE,
		MAKE_VATCODE,        
         0                   
 FROM OPENXML (@DOCHANDLE,''ROOT/MODIFY'',1) WITH                   
 (                  
	ID_MAKE      VARCHAR(10),                   
	ID_MAKE_NAME VARCHAR(10) ,          
	ID_MAKE_PRICECODE   VARCHAR(10),      
	MAKEDISCODE        VARCHAR(10) ,
	MAKE_VATCODE VARCHAR(50)                   
 )                  
                  
 EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE                  
          
          
          
          
          
-- START OF TBL_MAS_HP_RATE CHECKING FOR ID_MAKE                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( 
	SELECT ID_MAKE                   
	FROM @MODIFY_MAKE_LIST MASSET,                  
	TBL_MAS_HP_RATE   HPRATE                  
	WHERE HPRATE.ID_MAKE_HP  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_HP_RATE CHECKING FOR ID_MAKE                  
                  
-- START OF TBL_MAS_ITEM_MASTER CHECKING FOR ID_MAKE                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1              
WHERE ID_MAKE IN                  
( 
	SELECT MASSET.ID_MAKE                   
	FROM @MODIFY_MAKE_LIST MASSET,                  
	TBL_MAS_ITEM_MASTER   ITEMMASTER                  
	WHERE ITEMMASTER.ID_MAKE  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_ITEM_MASTER CHECKING FOR ID_MAKE                  
                  
-- START OF TBL_MAS_MAKE_SERVICECD_MAP CHECKING FOR MSCD_ID_MAKE                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( 
	SELECT ID_MAKE                   
	FROM @MODIFY_MAKE_LIST MASSET,                  
	TBL_MAS_MAKE_SERVICECD_MAP   MAKE_SERVICECD                  
	WHERE MAKE_SERVICECD.MSCD_ID_MAKE  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_MAKE_SERVICECD_MAP CHECKING FOR MSCD_ID_MAKE                  
                  
-- START OF TBL_MAS_MODEL_MAKE_MAP CHECKING FOR MODEL_ID_MAKE                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( 
	SELECT ID_MAKE                   
	FROM @MODIFY_MAKE_LIST MASSET,                  
	TBL_MAS_MODEL_MAKE_MAP   MODEL_MAKE_MAP                  
	WHERE MODEL_MAKE_MAP.MODEL_ID_MAKE  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_MODEL_MAKE_MAP CHECKING FOR MODEL_ID_MAKE                  
                  
-- START OF TBL_MAS_MODELGROUP_MAKE_MAP CHECKING FOR MG_ID_MAKE                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( 
	SELECT ID_MAKE                   
	FROM @MODIFY_MAKE_LIST MASSET,                  
	TBL_MAS_MODELGROUP_MAKE_MAP   MODELGROUP_MAKE_MAP                  
	WHERE MODELGROUP_MAKE_MAP.MG_ID_MAKE  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_MODELGROUP_MAKE_MAP CHECKING FOR MG_ID_MAKE                  
                  
-- START OF TBL_MAS_MODGRP_SERVICECD_MAP CHECKING FOR MGSCD_ID_MAKE                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( SELECT ID_MAKE                   
  FROM @MODIFY_MAKE_LIST MASSET,                  
       TBL_MAS_MODGRP_SERVICECD_MAP   SERVICECD_MAP                  
  WHERE SERVICECD_MAP.MGSCD_ID_MAKE  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_MODGRP_SERVICECD_MAP CHECKING FOR MGSCD_ID_MAKE                  
                  
-- START OF TBL_MAS_REP_PACKAGE CHECKING FOR ID_MAKE_RP                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( SELECT ID_MAKE                   
  FROM @MODIFY_MAKE_LIST MASSET,                  
       TBL_MAS_REP_PACKAGE   REP_PACKAGE                  
  WHERE REP_PACKAGE.ID_MAKE_RP  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_MAS_REP_PACKAGE CHECKING FOR ID_MAKE_RP                  
                  
-- START OF TBL_WO_JOB_DETAIL CHECKING FOR ID_MAKE_JOB                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( SELECT MASSET.ID_MAKE                   
  FROM @MODIFY_MAKE_LIST MASSET,                  
       TBL_WO_JOB_DETAIL   WO_JOB_DETAIL                  
  WHERE WO_JOB_DETAIL.ID_MAKE_JOB  = MASSET.ID_MAKE                   
)                  
-- END OF TBL_WO_JOB_DETAIL CHECKING FOR ID_MAKE_JOB                  
           
           
---- START OF TBL_MAS_VEHICLE CHECKING FOR ID_MAKE_VEH                  
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED=1                  
WHERE ID_MAKE IN                  
( SELECT ID_MAKE                
  FROM @MODIFY_MAKE_LIST MASSET,                  
       TBL_MAS_VEHICLE   VEH                  
  WHERE VEH.ID_MAKE_VEH  = MASSET.ID_MAKE                   
)                  
---- END OF TBL_MAS_VEHICLE CHECKING FOR ID_MAKE_VEH       
SELECT * fROM   @MODIFY_MAKE_LIST MODXML               
      SELECT * fROM   @MODIFY_MAKE_LIST MODXML   where MODXML.IS_USED = 0            
  AND   LEN(MODXML.ID_MAKE_PRICECODE) >= 0             
          
    UPDATE @MODIFY_MAKE_LIST set ID_MAKE_PRICECODE = NULL where LEN(ID_MAKE_PRICECODE) = 0             

/*
To update description irrespective of whether it is in used or not
*/
UPDATE @MODIFY_MAKE_LIST                  
SET IS_USED = 0 
/*
End
*/

-- FINAL UPDATE INTO TBL_MAS_MAKE                  
                  
UPDATE TBL_MAS_MAKE                   
SET TBL_MAS_MAKE.ID_MAKE = MODXML.ID_MAKE,                  
    TBL_MAS_MAKE.ID_MAKE_NAME = MODXML.ID_MAKE_NAME  ,            
	TBL_MAS_MAKE.ID_MAKE_PRICECODE   = MODXML.ID_MAKE_PRICECODE,      
	TBL_MAS_MAKE.MAKEDISCODE   = MODXML.MAKEDISCODE,
	TBL_MAS_MAKE.MAKE_VATCODE   = MODXML.MAKE_VATCODE,
/**********************************************************  
Modified Date :-  06-MAY-2008  
Description   :-  Added Below Line  
bug No        :-   2185  
*********************************************************/  
TBL_MAS_MAKE.MODIFIED_BY = @IV_CREATEDBY,   
TBL_MAS_MAKE.DT_MODIFIED = GetDate()   
 --Chang end              
FROM @MODIFY_MAKE_LIST MODXML                  
WHERE TBL_MAS_MAKE.ID_MAKE = MODXML.ID_MAKE                  
AND MODXML.IS_USED = 0            
          
          
               
-- END OF UPDATE INTO TBL_MAS_MAKE                  
--SELECT * FROM @MODIFY_MAKE_LIST                  
                  
SELECT  @MODIFIED = ISNULL(@MODIFIED + ''; '' + ID_MAKE,ID_MAKE)                  
FROM    @MODIFY_MAKE_LIST WHERE IS_USED = 0                  
                  
SELECT @MODIFIED                  
 set @OV_MODIFYEDCFG  = @MODIFIED              
SELECT  @NOTMOD = ISNULL(@NOTMOD + ''; '' + ID_MAKE,ID_MAKE)                  
FROM    @MODIFY_MAKE_LIST WHERE IS_USED=1                  
                  
SELECT @NOTMOD                   
  set  @OV_CANNOTMODIFY = @NOTMOD              
IF @NOTMOD <> ''''   -- SOME CONFIG IS THERE WHICH CAN NOT BE MODIFYED DUE TO DUPLICATE EXISTX                    
    SET @OV_RETVALUE=''SOMENOTMOD''                    
ELSE                    
    SET @OV_RETVALUE=@@ERROR                    
                  
                
        ---TBL_MAS_MODELGROUP CHECKING                
 EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE1 OUTPUT, @IV_XMLMODELGROUP                  
 DECLARE @MODIFY_MODELGROUP TABLE                  
 (                  
   ID_MODELGRP        VARCHAR(10),                  
   ID_MODELGRP_NAME   VARCHAR(10),                   
   IS_USED            BIT                  
 )                  
 INSERT INTO @MODIFY_MODELGROUP                  
 SELECT ID_MODELGRP,                  
        ID_MODELGRP_NAME ,                  
         0                   
 FROM OPENXML (@DOCHANDLE1,''ROOT/MODIFY'',1) WITH                   
 (                  
        ID_MODELGRP      VARCHAR(10),                   
        ID_MODELGRP_NAME VARCHAR(10)                  
 )              
            
select * from    @MODIFY_MODELGROUP             
                  
 EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE1                  
                
-- START OF TBL_MAS_MODELGROUP_MAKE_MAP CHECKING FOR mg_id_model_grp                
UPDATE @MODIFY_MODELGROUP                
SET IS_USED=1                
WHERE ID_MODELGRP IN                
( SELECT ID_MODELGRP                 
  FROM @MODIFY_MODELGROUP MASSET,                
       TBL_MAS_MODELGROUP_MAKE_MAP   MODELGROUP_MAKE_MAP                
  WHERE MODELGROUP_MAKE_MAP.mg_id_model_grp  = MASSET.ID_MODELGRP                 
)                
-- END OF TBL_MAS_MODELGROUP_MAKE_MAP CHECKING FOR mg_id_model_grp                
                
---- START OF TBL_MAS_VEHICLE CHECKING FOR ID_MODELGRP                
UPDATE @MODIFY_MODELGROUP                
SET IS_USED=1                
WHERE ID_MODELGRP IN                
( SELECT ID_MODELGRP                 
  FROM @MODIFY_MODELGROUP MASSET,                
       TBL_MAS_VEHICLE   VEH                
  WHERE VEH.ID_MODEL_VEH  = MASSET.ID_MODELGRP                 
)                
---- END OF TBL_MAS_VEHICLE CHECKING FOR ID_MODELGRP   
             
/*
To update description irrespective of whether it is in used or not
*/
UPDATE @MODIFY_MODELGROUP                  
SET IS_USED = 0 
/*
End
*/

-- FINAL UPDATE INTO TBL_MAS_MODELGROUP                
UPDATE TBL_MAS_MODELGROUP                 
SET TBL_MAS_MODELGROUP.ID_MODELGRP = MODXML.ID_MODELGRP,                
    TBL_MAS_MODELGROUP.ID_MODELGRP_NAME = MODXML.ID_MODELGRP_NAME,   
/**********************************************************  
Modified Date :-  06-MAY-2008  
Description   :-  Added Below Line  
bug No        :-   2183  
*********************************************************/  
TBL_MAS_MODELGROUP.MODIFIED_BY = @IV_CREATEDBY,   
TBL_MAS_MODELGROUP.DT_MODIFIED = GetDate()   
 --Chang end              
FROM @MODIFY_MODELGROUP MODXML                
WHERE TBL_MAS_MODELGROUP.ID_MODELGRP = MODXML.ID_MODELGRP                
AND MODXML.IS_USED = 0                
-- END OF UPDATE INTO TBL_MAS_MODELGROUP                
SELECT  @MODIFIED1 = ISNULL(@MODIFIED1 + ''; '' + ID_MODELGRP,ID_MODELGRP)             
          
FROM    @MODIFY_MODELGROUP WHERE IS_USED = 0              
              
SELECT @MODIFIED1             
 if ISNULL(@MODIFIED,'''') <> ''''          
 BEGIN          
  set @OV_MODIFYEDCFG  = ISNULL(@MODIFIED,'''') + ''; '' + isnull(@MODIFIED1,'''')             
 END          
 ELSE if ISNULL(@MODIFIED,'''') <> '''' and ISNULL(@MODIFIED1,'''') = ''''         --10          
   BEGIN          
    set @OV_MODIFYEDCFG  = ISNULL(@MODIFIED,'''')           
   END            
 ELSE          
 BEGIN          
  set @OV_MODIFYEDCFG  = ISNULL(@MODIFIED,'''') +  isnull(@MODIFIED1,'''')    --00          
 END           
          
          
           
SELECT  @NOTMOD1 = ISNULL(@NOTMOD1 + ''; '' + ID_MODELGRP,ID_MODELGRP)              
FROM    @MODIFY_MODELGROUP WHERE IS_USED=1              
      set  @OV_CANNOTMODIFY = ISNULL(@NOTMOD,'''') +isnull(@NOTMOD1,'''')          
SELECT @NOTMOD1          
 if  ISNULL(@NOTMOD,'''') <> '''' and ISNULL(@NOTMOD1,'''') <> ''''                 -- 11          
 BEGIN          
  set @OV_CANNOTMODIFY  = ISNULL(@NOTMOD,'''') + ''; '' + isnull(@NOTMOD1,'''')             
 END          
 ELSE if ISNULL(@NOTMOD,'''') <> '''' and ISNULL(@NOTMOD1,'''') = ''''         --10          
   BEGIN          
    set @OV_CANNOTMODIFY  = ISNULL(@NOTMOD,'''')           
   END            
 ELSE          
 BEGIN          
  set @OV_CANNOTMODIFY  = ISNULL(@NOTMOD,'''') +  isnull(@NOTMOD1,'''')  --00          
 END                
-- END OF CHECKING TBL_MAS_MODELGROUP                  
END                  
                  
/**                  
DECLARE @OUT VARCHAR(200)                  
EXEC USP_CONFIG_VEHICLE_MODIFY                  
''<ROOT><MODIFY ID_MAKE="newmake" ID_MAKE_NAME="hi787"/>               
</ROOT>'',                
''''                
,''RAJA'',@OUT, @OUT   ,@OUT            
PRINT @OUT                  
    select * from tbl_mas_make              
SELECT * FROM TBL_INV_PAYMENTDETAILS                   
SELECT * FROM TBL_MAS_SETTINGS WHERE ID_CONFIG=''PAYTYPE''                
                
ID_SETTINGS IN (10,28)                
                  
*/                  
      
      
--DECLARE @OUT VARCHAR(200)                  
--EXEC USP_CONFIG_VEHICLE_MODIFY      
--''<ROOT><MODIFY ID_MAKE="testw"       
--ID_MAKE_NAME="testw1234" ID_MAKE_PRICECODE="343"      
-- MAKEDISCODE="dr"/></ROOT>'',      
--''<ROOT></ROOT>'',''admin'',@OUT, @OUT   ,@OUT      
--PRINT @OUT 
    

' 
END
GO

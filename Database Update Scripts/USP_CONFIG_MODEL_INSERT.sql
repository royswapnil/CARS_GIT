/****** Object:  StoredProcedure [dbo].[USP_CONFIG_MODEL_INSERT]    Script Date: 04/04/2016 12:47:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_MODEL_INSERT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_MODEL_INSERT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_MODEL_INSERT]    Script Date: 04/04/2016 12:47:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_MODEL_INSERT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*************************************** Application: MSG *************************************************************
* Module	: CONFIG
* File name	: USP_CONFIG_Model_INSERT.PRC
* Purpose	: To Insert Settings in  TBL_MAS_MODEL_MAKE_MAP
* Author	: Jayakrishnan
* Date		: 29.07.2006
*********************************************************************************************************************/
/*********************************************************************************************************************  
I/P : -- Input Parameters
	@iv_xmlDoc - Valid XML document contaning values to be inserted

O/P : -- Output Parameters
	@ov_RetValue - ''INSFLG'' if error, ''OK'' otherwise
	@ov_CannotDelete - List of configuration items which cannot be inserted as they already exists.

Error Code
Description
INT.VerNO : NOV21.0 
********************************************************************************************************************/
--''*********************************************************************************''*********************************
--''* Modified History	:   
--''* S.No 	RFC No/Bug ID			Date	     		Author		Description	
--* #0001#
--''*********************************************************************************''*********************************


CREATE PROC [dbo].[USP_CONFIG_MODEL_INSERT]
	(
	  @iv_xmlDoc		 ntext,
      @iv_CreatedBy		 VARCHAR(20),
	  @ov_RetValue		 VARCHAR(10)  OUTPUT,
	  @ov_CannotInsert	 VARCHAR(500) OUTPUT,
      @ov_Insertedcfg	 VARCHAR(500) OUTPUT
	)
AS
BEGIN
	DECLARE @docHandle int 
	DECLARE @CONFIGLISTCNI AS VARCHAR(2000)
	DECLARE @CFGLSTINSERTED AS VARCHAR(2000)

	EXEC SP_XML_PREPAREDOCUMENT @docHandle OUTPUT, @iv_xmlDoc
	DECLARE @INSERT_LIST Table
		(
 			ID_MODELGRP		 VARCHAR(10), 
			ID_MODELGRP_NAME	 VARCHAR(10),
			IS_INSERTED		 BIT
		)
	INSERT INTO @INSERT_LIST
	SELECT 
		   ID_MODELGRP ,
		   ID_MODELGRP_NAME,
		   '''' 
	FROM OPENXML (@docHandle,''root/insert'',1) with 
		(
			ID_MODELGRP			VARCHAR(10), 
			ID_MODELGRP_NAME		VARCHAR(10)
		)

	EXEC SP_XML_REMOVEDOCUMENT @docHandle


	UPDATE 
			@INSERT_LIST  
	SET    
			IS_INSERTED=1 
	FROM   
			TBL_MAS_SETTINGS MAS,
			@INSERT_LIST LTB
	WHERE  
			LTB.ID_MODELGRP   = MAS.ID_SETTINGS
	AND    
			LTB.ID_MODELGRP_NAME = MAS.DESCRIPTION


	INSERT INTO TBL_MAS_SETTINGS
		(
			ID_SETTINGS,
			DESCRIPTION,
			ID_CONFIG,
			Created_By,
			DT_CREATED
		)
	SELECT ID_MODELGRP,
		   ID_MODELGRP_NAME,
		   ''MODEL'',
		   @iv_CreatedBy,
		   getdate()
	FROM  
		   @INSERT_LIST
	WHERE 
		   IS_INSERTED=0

	SELECT * FROM @INSERT_LIST
	SELECT * FROM TBL_MAS_SETTINGS WHERE ID_CONFIG = ''MODEL''

	-- To fetch the reocrds which can not be inserted

	SELECT  
			@CONFIGLISTCNI = ISNULL(@CONFIGLISTCNI + ''; '' + ID_MODELGRP,ID_MODELGRP)
	FROM    
			@INSERT_LIST 
	WHERE
			IS_INSERTED=1

	SET @ov_CannotInsert =   @CONFIGLISTCNI
	SELECT @ov_CannotInsert

	-- To fetch the reocrds which were inserted

	SELECT  
			@CFGLSTINSERTED = ISNULL(@CFGLSTINSERTED + ''; '' + ID_MODELGRP,ID_MODELGRP)
	FROM    
			@INSERT_LIST 
	WHERE
			IS_INSERTED=0

	SET  @ov_Insertedcfg =   @CFGLSTINSERTED
	SELECT @ov_Insertedcfg

	IF @ov_CannotInsert <> ''''   -- some config is there which can not be inserted due to duplicate existx
		SET @ov_RetValue=''MULINSFLG''
	ELSE
		SET @ov_RetValue=@@ERROR
END





/*
exec USP_CONFIG_Model_INSERT
''<root>
	<insert ID_MODEL="102" MODEL_ID_MAKE="MR"/>
	<insert ID_MODEL="101" MODEL_ID_MAKE="HO"/>
</root>'','''','''','''',''''


select * from TBL_MAS_MODEL_MAKE_MAP
*/





' 
END
GO

/****** Object:  StoredProcedure [dbo].[USP_CONFIG_SETTINGS_DELETE]    Script Date: 04/04/2016 12:45:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_SETTINGS_DELETE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[USP_CONFIG_SETTINGS_DELETE]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIG_SETTINGS_DELETE]    Script Date: 04/04/2016 12:45:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USP_CONFIG_SETTINGS_DELETE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*************************************** Application: MSG *************************************************************
* Module	: Master
* File name	: USP_CONFIG_SETTINGS_DELETE.PRC
* Purpose	: TO DELETE MAS SETTINGS
* Author	: Jayakrishnan, Rajput Yogendrasinh H, Dhanunjaya Rao
* Date		: 25.07.2006
*********************************************************************************************************************/
/*********************************************************************************************************************  
I/P : -- Input Parameters
O/P : -- Output Parameters
Error Code
Description
INT.VerNO : FEB20.0 
********************************************************************************************************************/
/*********************************************************************************''*********************************
* Modified History	:   
* S.No 	RFC No/Bug ID			Date	     		Author		Description	
*#0001#	 1632					27/12/2006			Krishnaveni	Added Foreign key check with ID_VEHGRP_HP
*#0002#	 2471, 2464				20/02/2007			Rajput Y H	Added Foreign key check with TBL_WO_DETAIL for RP-CATG and RP-WC
													Rajput Y H	Added Foreign key check with TBL_PLAN_EMP_HOLIDAY for LEAVE REASON
 Bug # 3896						13/11/2007			Dhanunjaya rao 
*********************************************************************************''*********************************/
-- Modified Date : 13th July 2009
-- Description   : Reason for clockout has flag and we need to check if flag is null
CREATE PROCEDURE [dbo].[USP_CONFIG_SETTINGS_DELETE]
(
 @iv_xmlDoc    ntext,
 @ov_RetValue	varchar(10) output,
 @ov_CntDelete  varchar(500) output,
 @ov_DeletedCfg varchar(500) output
)
AS
BEGIN
DECLARE @HDOC INT
DECLARE @CONFIGLISTCND AS VARCHAR(2000)
DECLARE @CFGLSTDELETED AS VARCHAR(2000)
EXEC SP_XML_PREPAREDOCUMENT @HDOC OUTPUT, @iv_xmlDoc

declare @Table_Settings_Temp table
	(
	ID_SETTINGS varchar(10),
	ID_CONFIG varchar(10), 
    DESCRIPTION varchar(50),
	DELETEFLAG bit
	)

insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION,'''' from OPENXML (@HDOC,''root/delete/TR-REASCD'',1)
with (ID_SETTINGS varchar(10),
	  ID_CONFIG varchar(10),
	  DESCRIPTION varchar(50)
		 )  

update @Table_Settings_Temp 
  set DELETEFLAG = 1
  where ID_SETTINGS in (select id_unsold_time from tbl_tr_job_actual)

delete from TBL_MAS_SETTINGS where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 


-- To fetch the records which cannot be deleted 
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1


--To fetch the records that can be deleted
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0


/* Delete Reason for Clock Out (TR-COUT) Author: Jayakrishnan*/
-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/TR-COUT'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )

select * from @Table_Settings_Temp
 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select CO_REAS_CODE from tbl_tr_job_actual)


 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select ID_REASON from TBL_PLAN_EMP_HOLIDAY) -- see #0002#	


select * from @Table_Settings_Temp

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 
		AND FLAG IS NULL

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Reason for Clock Out (TR-COUT) **/


/* Delete Vehicle Group (VEH-GROUP) Author: Jayakrishnan*/  
-- Clear @Table_Settings_Temp  
delete from @Table_Settings_Temp where 1=1  
insert into @Table_Settings_Temp   
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/VEH-GROUP'',1)  
with (  
  ID_SETTINGS varchar(10),  
  ID_CONFIG varchar(10),  
  DESCRIPTION varchar(50)  
   )  
  
select * from @Table_Settings_Temp  
  
 update @Table_Settings_Temp   
 set DELETEFLAG = 1  
 where ID_SETTINGS in (select ID_GROUP_VEH from TBL_MAS_VEHICLE)  
       OR ID_SETTINGS in (select ID_VEHGRP_HP from TBL_MAS_HP_RATE) 
 DELETE FROM   
   TBL_MAS_VHGROUPPC   
 WHERE   
   VH_GROUP_ID   
 IN  
   (SELECT ID_SETTINGS FROM @Table_Settings_Temp WHERE DELETEFLAG<>1)   


select * from @Table_Settings_Temp  
  
delete from TBL_MAS_SETTINGS   
  where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1)   
  
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)  
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1  
  
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)  
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0  
  
/** END of Delete Vehicle Group (VEH-GROUP) **/  
/* Delete VAT Code (VAT) Author: Jayakrishnan*/  
-- Clear @Table_Settings_Temp  
delete from @Table_Settings_Temp where 1=1  
insert into @Table_Settings_Temp   
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/CALLSTATUS'',1)  
with (  
  ID_SETTINGS varchar(10),  
  ID_CONFIG varchar(10),  
  DESCRIPTION varchar(50)  
   )  
select * from @Table_Settings_Temp  
 update @Table_Settings_Temp   
 set DELETEFLAG = 1  
 where ID_SETTINGS in (select SP_CALLINSTATUS from TBL_MAS_SP_GENERATECALL)  
    
select * from @Table_Settings_Temp  
  
delete from TBL_MAS_SETTINGS   
  where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1)   
  
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)  
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1  
  
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)  
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0  
  
/** END of Delete CALL IN STATUS**/ 

/**Delete LOcation (LOC) Author: Jayakrishnan*/

delete from @Table_Settings_Temp where 1=1

insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/LOC'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )  
--DBG 1
select * from @Table_Settings_Temp

  update @Table_Settings_Temp 
  set DELETEFLAG = 1
  where ID_SETTINGS in (select ID_ADDON_LOCDEPT from TBL_MAS_VEHICLE)

select * from @Table_Settings_Temp

delete from TBL_MAS_SETTINGS 
	where ID_SETTINGS IN (select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 


-- To fetch the records which cannot be deleted 
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

--EXP--set @ov_CntDelete=@CONFIGLISTCND

--DBG 2
--select @ov_CntDelete

--To fetch the records that can be deleted
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Location (LOC) **/

/* Delete Discount Code (DISCD) Author: Jayakrishnan*/
-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/DISCD'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )
 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select DISCOUNT_CD from TBL_MAS_ITEM_CATG_MAPPING)
    or ID_SETTINGS in (select ID_DISC_CUST from TBL_MAS_WO_DISCOUNT)
    or ID_SETTINGS in (select ID_DISC_CD from TBL_MAS_CUST_GROUP)  
    or ID_SETTINGS in (select ID_CUST_DISC_CD from TBL_MAS_CUSTOMER)    
delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Code (DISCD)**/


/* Delete VAT Code (VAT) Author: Jayakrishnan*/
-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/VAT'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )
select * from @Table_Settings_Temp
 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select VAT_CD from TBL_MAS_ITEM_CATG_MAPPING)
    or ID_SETTINGS in (select ID_VAT_CD from TBL_MAS_VEHICLE)
    or ID_SETTINGS in (select ID_VAT_CD from TBL_MAS_CUST_GROUP)
    or ID_SETTINGS in (select ID_VAT_CODE from TBL_MAS_ITEM_MASTER)
    or ID_SETTINGS in (select VAT_CUST from TBL_VAT_DETAIL)
	or ID_SETTINGS in (select HP_Vat from TBL_MAS_HP_RATE)   -- Added by Dhanu for Bug # 3896
	or ID_SETTINGS in (select WO_GM_VAT from TBL_WO_DETAIL)  -- Added by Dhanu for Bug # 3896 
select * from @Table_Settings_Temp

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete VAT Code (VAT)**/

/** Delete Work Code (RP-WC); Author: Rajput Yogendrasinh H **/

-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1

insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/RP-WC'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )  
--DBG 1
--select * from @Table_Settings_Temp

  update @Table_Settings_Temp 
  set DELETEFLAG = 1
  where ID_SETTINGS in (select ID_WORK_CD_RP from TBL_MAS_REP_PACKAGE)

  update @Table_Settings_Temp 
  set DELETEFLAG = 1
  where ID_SETTINGS in (select ID_WORK_CODE_WO from TBL_WO_DETAIL) -- See #0002#

delete from TBL_MAS_SETTINGS 
	where ID_SETTINGS IN (select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 


-- To fetch the records which cannot be deleted 
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

--EXP--set @ov_CntDelete=@CONFIGLISTCND

--DBG 2
--select @ov_CntDelete

--To fetch the records that can be deleted
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Work Code (RP-WC) **/


/** Delete Repair Package Category (RP-CATG); Author: Rajput Yogendrasinh H **/

-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1

insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/RP-CATG'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )  
--DBG 1
select * from @Table_Settings_Temp
 
  update @Table_Settings_Temp 
  set DELETEFLAG = 1
  where ID_SETTINGS in (select ID_CATG_RP from TBL_MAS_REP_PACKAGE) -- See #0002#

  update @Table_Settings_Temp 
  set DELETEFLAG = 1
  where ID_SETTINGS in (select ID_RPG_CATG_WO from TBL_WO_DETAIL)

delete from TBL_MAS_SETTINGS 
	where ID_SETTINGS IN (select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 


-- To fetch the records which cannot be deleted 
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1


--DBG 2
select @ov_CntDelete

--To fetch the records that can be deleted
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0



--DBG 3
select @ov_DeletedCfg

/** END of Delete Work Code (RP-WC) **/

/* Delete Region of Customer (REG) Author: Dhanunjaya rao*/
-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/REG'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )
 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select ID_CUST_REG_CD from TBL_MAS_CUSTOMER)

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Region of Customer (REG) **/

/* Delete Warning Text of Customer (CU-WARN) Author: Dhanunjaya rao*/
-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/CU-WARN'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )
 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select ID_CUST_WARN from TBL_MAS_CUSTOMER)

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Warning Text of Customer (CU-WARN) **/


/* Delete Work Order Desc (WO_DESC)*/
-- Clear @Table_Settings_Temp
delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/WO_DESC'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )

select * from @Table_Settings_Temp

 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select ID_GROUP_VEH from TBL_MAS_VEHICLE)
select * from @Table_Settings_Temp

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/** END of Delete Work Order Desc (WO_DESC) **/


/**Delete Discount Code (WO-DISCD) Author: G.Narayana Rao **/

delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/WO-DISCD'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )

select * from @Table_Settings_Temp

 update @Table_Settings_Temp 
 set DELETEFLAG = 1
 where ID_SETTINGS in (select ID_DISC_CUST from TBL_MAS_WO_DISCOUNT)
select * from @Table_Settings_Temp

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/**End of Delete discount code(WO-DISCD)   **/

/**Delete Discount Code (PAYTYPE) Author: G.Narayana Rao **/

delete from @Table_Settings_Temp where 1=1
insert into @Table_Settings_Temp 
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/PAYTYPE'',1)
with (
		ID_SETTINGS varchar(10),
		ID_CONFIG varchar(10),
		DESCRIPTION varchar(50)
	  )

select * from @Table_Settings_Temp
-- update -----------

delete from TBL_MAS_SETTINGS 
		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 

SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1

SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0

/**End of Delete discount code(PAYTYPE)   **/



------/**Delete Station Type (ST-TYPE) Author: P.Dhanunjaya Rao **/
------
------delete from @Table_Settings_Temp where 1=1
------insert into @Table_Settings_Temp 
------select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/ST-TYPE'',1)
------with (
------		ID_SETTINGS varchar(10),
------		ID_CONFIG varchar(10),
------		DESCRIPTION varchar(50)
------	  )
------
------------select * from @Table_Settings_Temp
------------
------------ update @Table_Settings_Temp 
------------ set DELETEFLAG = 1
------------ where ID_SETTINGS in (select ID_DISC_CUST from TBL_MAS_WO_DISCOUNT)
------select * from @Table_Settings_Temp
------
------delete from TBL_MAS_SETTINGS 
------		where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1) 
------
------SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)
------FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1
------
------SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)
------FROM    @Table_Settings_Temp WHERE DELETEFLAG=0
------
------/**End of Delete Station Type (ST-TYPE)   **/






/* Delete Model */  
-- Clear @Table_Settings_Temp  
delete from @Table_Settings_Temp where 1=1  
insert into @Table_Settings_Temp   
select ID_SETTINGS,ID_CONFIG,DESCRIPTION, '''' from OPENXML (@HDOC,''root/delete/ID-GROUP'',1)  
with (  
  ID_SETTINGS varchar(10),  
  ID_CONFIG varchar(10),  
  DESCRIPTION varchar(50)  
   )  
  
select * from @Table_Settings_Temp  
  
 update @Table_Settings_Temp   
 set DELETEFLAG = 1  
 where ID_SETTINGS in (select ID_MODEL_VEH from TBL_MAS_VEHICLE)  
       OR ID_SETTINGS in (select ID_VEHGRP_HP from TBL_MAS_HP_RATE) 
      

select * from @Table_Settings_Temp  
  
delete from TBL_MAS_SETTINGS   
  where ID_SETTINGS IN(select ID_SETTINGS from @Table_Settings_Temp where deleteflag<>1)   
  
SELECT  @CONFIGLISTCND = ISNULL(@CONFIGLISTCND + ''; '' + DESCRIPTION,DESCRIPTION)  
FROM    @Table_Settings_Temp WHERE DELETEFLAG = 1  
  
SELECT  @CFGLSTDELETED = ISNULL(@CFGLSTDELETED + ''; '' + DESCRIPTION,DESCRIPTION)  
FROM    @Table_Settings_Temp WHERE DELETEFLAG=0  
  
/** END of Delete Vehicle Group (VEH-GROUP) **/ 




SET @ov_CntDelete=@CONFIGLISTCND
SET  @ov_DeletedCfg =   @CFGLSTDELETED
EXEC SP_XML_REMOVEDOCUMENT @HDOC
IF @@ERROR <> 0 
				SET @ov_RetValue = @@ERROR
			ELSE
				SET @ov_RetValue = 0
select @ov_RetValue
select @ov_CntDelete
select @ov_DeletedCfg
end






/*

declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)

EXEC USP_CONFIG_SETTINGS_DELETE 
''<root><delete><REG ID_SETTINGS="550" ID_CONFIG="REG" DESCRIPTION="hf"/></delete></root>'' , @ov1,@ov2,@ov3
print @ov1
print @ov2
print @ov3

--select ID_SETTINGS from TBL_MAS_SETTINGS where ID_SETTINGS between ''550'' and ''570''
select * from tbl_mas_settings

declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE
''<root>
	<delete>
		<RP-WC ID_SETTINGS="178" ID_CONFIG="VEH-GROUP" DESCRIPTION="Luxury Car"/>
	</delete>
</root>'' , @ov1,@ov2,@ov3

<root>
	<delete>
		<TR-REASCD ID_SETTINGS="580" ID_CONFIG="TR-REASCD" DESCRIPTION="Test data 3"/>
		<TR-REASCD ID_SETTINGS="581" ID_CONFIG="TR-REASCD" DESCRIPTION="Test data 4"/>
	</delete>
</root>


declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE
''<root>
	<delete>
		<LOC ID_SETTINGS="99" ID_CONFIG="LOC" DESCRIPTION="Chennai"/>
	</delete>
</root>'' , @ov1,@ov2,@ov3

select * from tbl_mas_settings


declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE
''<root>
	<delete>
		<TR-COUT ID_SETTINGS="1" ID_CONFIG="TR-COUT" DESCRIPTION="Finished"/>	
	</delete>
</root>'', @ov1,@ov2,@ov3


declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE
''<root>
	<delete>
		<LOC ID_SETTINGS="575" ID_CONFIG="LOC" DESCRIPTION="Delhi"/>
	</delete>
</root>'', @ov1,@ov2,@ov3

declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE
''<root>
	<delete>
		<VEH-GROUP ID_SETTINGS="218" ID_CONFIG="VEH-GROUP" DESCRIPTION="Heavy vehicle"/>
		<VEH-GROUP ID_SETTINGS="3" ID_CONFIG="VEH-GROUP" DESCRIPTION="CAR"/>
	</delete>
</root>'', @ov1,@ov2,@ov3

declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE
''<root>
	<delete>
		<VEH-GROUP ID_SETTINGS="570" ID_CONFIG="VEH-GROUP" DESCRIPTION="test data 2"/>
		<VEH-GROUP ID_SETTINGS="571" ID_CONFIG="VEH-GROUP" DESCRIPTION="test data 3"/>
	</delete>
</root>'', @ov1,@ov2,@ov3


declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)
exec USP_CONFIG_SETTINGS_DELETE

''<root><delete><DISCD ID_SETTINGS="734" ID_CONFIG="DISCD" DESCRIPTION="newdiscount"/><DISCD ID_SETTINGS="831" ID_CONFIG="DISCD" DESCRIPTION="x"/><DISCD ID_SETTINGS="841" ID_CONFIG="DISCD" DESCRIPTION="sun"/><DISCD ID_SETTINGS="864" ID_CONFIG="DISCD" DESCRIPTION="DIC"/><DISCD ID_SETTINGS="866" ID_CONFIG="DISCD" DESCRIPTION="extest2"/></delete></root>''
,@ov1,@ov2,@ov3

declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)

declare @ov1 varchar(1000)
declare @ov2 varchar(1000)
declare @ov3 varchar(1000)

EXEC
USP_CONFIG_SETTINGS_DELETE ''<root><delete><CALLSTATUS ID_SETTINGS="26" ID_CONFIG="SERV-CALL" DESCRIPTION="hhh"/><CALLSTATUS ID_SETTINGS="74" ID_CONFIG="SERV-CALL" DESCRIPTION="jjj"/><CALLSTATUS ID_SETTINGS="215" ID_CONFIG="SERV-CALL" DESCRIPTION="yyy"/><CALLSTATUS ID_SETTINGS="450" ID_CONFIG="SERV-CALL" DESCRIPTION="fgdfgdgg"/><CALLSTATUS ID_SETTINGS="1412" ID_CONFIG="SERV-CALL" DESCRIPTION="ignored"/></delete></root>'',
@ov1,@ov2,@ov3

*/
' 
END
GO

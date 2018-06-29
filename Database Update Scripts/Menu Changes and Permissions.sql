
/*Link to Accounting Screens*/
DECLARE @PARENTID AS INT,@CHILDID AS INT

SELECT @PARENTID = ID_SCR  FROM TBL_UTIL_MOD_DETAILS WHERE NAME_SCR='ORDER' AND NAME_MODULE='WORK ORDER'
SELECT @CHILDID = ID_SCR  FROM TBL_UTIL_MOD_DETAILS WHERE NAME_SCR='ACCOUNTING' AND NAME_MODULE='WORK ORDER' AND MODULE_LEVEL=@PARENTID

UPDATE TBL_UTIL_MOD_DETAILS SET FLG=1 WHERE MODULE_LEVEL=@CHILDID AND FLG=0

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Batch Invoice Screen*/
declare @loginId as varchar(10) ='22admin' --Add the default user for permission. Other users can be given access from roles after this is run.
declare @roleId as int
select @roleId = ID_ROLE_User from TBL_MAS_USERS where ID_Login=@loginId

IF NOT EXISTS( SELECT * FROM TBL_UTIL_MOD_DETAILS WHERE NAME_SCR = 'Batch Invoice' and name_module='WORK ORDER')
BEGIN
                Declare @menuID int
                Declare @moduleID int

                SELECT @moduleID=ID_SCR FROM TBL_UTIL_MOD_DETAILS WHERE NAME_SCR='Invoice' and name_module='WORK ORDER'
                INSERT INTO TBL_UTIL_MOD_DETAILS VALUES('Batch Invoice','/Transactions/frmInvoice.aspx','WORK ORDER',@moduleID,1)

                SET @menuID =@@IDENTITY

                INSERT INTO TBL_UTIL_LANG_DETAILS VALUES(1,@menuID,'Batch Invoice')
                INSERT INTO TBL_UTIL_LANG_DETAILS VALUES(3,@menuID,'Batch Invoice_N')
                INSERT INTO TBL_UTIL_LANG_DETAILS VALUES(2,@menuID,'Batch Invoice_G')
                
   				INSERT INTO TBL_MAS_ROLE_ACCESS(ID_SCR_UTIL,ACC_READ,ACC_WRITE,ACC_CREATE,ACC_PRINT,ACC_DELETE,ACC_SEQ, ID_ROLE_ACCESS,CREATED_BY,DT_CREATED)
				VALUES(@MENUID,1,1,1,1,1,@MENUID,@ROLEID,@LOGINID,GETDATE())   
   
END
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/*Credit Note Screen*/
declare @loginId as varchar(10) ='22admin' --Add the default user for permission. Other users can be given access from roles after this is run
declare @roleId as int
select @roleId = ID_ROLE_User from TBL_MAS_USERS where ID_Login=@loginId

IF NOT EXISTS( SELECT * FROM TBL_UTIL_MOD_DETAILS WHERE NAME_SCR = 'Credit Note' and name_module='WORK ORDER')
BEGIN
                Declare @menuID int
                Declare @moduleID int

                SELECT @moduleID=ID_SCR FROM TBL_UTIL_MOD_DETAILS WHERE NAME_SCR='Invoice' and name_module='WORK ORDER'
                INSERT INTO TBL_UTIL_MOD_DETAILS VALUES('Credit Note','/Transactions/frmInvPrint.aspx','WORK ORDER',@moduleID,1)

                SET @menuID =@@IDENTITY

                INSERT INTO TBL_UTIL_LANG_DETAILS VALUES(1,@menuID,'Credit Note')
                INSERT INTO TBL_UTIL_LANG_DETAILS VALUES(3,@menuID,'Credit Note_N')
                INSERT INTO TBL_UTIL_LANG_DETAILS VALUES(2,@menuID,'Credit Note_G')
                
   				INSERT INTO TBL_MAS_ROLE_ACCESS(ID_SCR_UTIL,ACC_READ,ACC_WRITE,ACC_CREATE,ACC_PRINT,ACC_DELETE,ACC_SEQ, ID_ROLE_ACCESS,CREATED_BY,DT_CREATED)
				VALUES(@MENUID,1,1,1,1,1,@MENUID,@ROLEID,@LOGINID,GETDATE())   
   
END

GO

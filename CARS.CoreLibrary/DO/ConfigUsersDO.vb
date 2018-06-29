Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Namespace CARS.ConfigUsers
    Public Class ConfigUsersDO
        Dim objDB As Database
        Dim ConnectionString As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
#Region "Method"
        Public Function Fetch_Config() As DataSet
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_GET_USERCONFIG_FETCH")
                    Try
                        Return objDB.ExecuteDataSet(objCMD)
                    Catch generatedExceptionName As Exception
                        Throw
                    End Try
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Users(ByVal objConfigUser As ConfigUsersBO) As DataSet
            Try
                Dim ds As New DataSet
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_USER_FETCHALL")
                    objDB.AddInParameter(objCMD, "@ID_USER", DbType.String, objConfigUser.Id_Login)
                    Try
                        ds = objDB.ExecuteDataSet(objCMD)
                    Catch generatedExceptionName As Exception
                        Throw
                    End Try
                End Using
                Return ds
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_User(ByVal objConfigUser As ConfigUsersBO) As DataSet
            Try
                Dim ds As New DataSet
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_USER_FETCH")
                    objDB.AddInParameter(objCMD, "@IV_ID_Login", DbType.String, objConfigUser.Id_Login)
                    Try
                        ds = objDB.ExecuteDataSet(objCMD)
                    Catch generatedExceptionName As Exception
                        Throw
                    End Try
                End Using
                Return ds
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_User(ByVal objConfigUser As ConfigUsersBO) As String
            Dim strErrcode As String
            Dim ds As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_USERS_INSERT")
                objDB.AddInParameter(objCMD, "@IV_ID_Login", DbType.String, objConfigUser.Id_Login)
                objDB.AddInParameter(objCMD, "@IV_First_Name", DbType.String, objConfigUser.First_Name)
                objDB.AddInParameter(objCMD, "@IV_Last_Name", DbType.String, objConfigUser.Last_Name)
                objDB.AddInParameter(objCMD, "@II_ID_ROLE_User", DbType.Int16, objConfigUser.Id_Role_User)
                objDB.AddInParameter(objCMD, "@IV_Password", DbType.String, objConfigUser.Password)
                objDB.AddInParameter(objCMD, "@II_ID_Subsidery_User", DbType.Int16, objConfigUser.Id_Subsidery_User)
                objDB.AddInParameter(objCMD, "@II_ID_Dept_User", DbType.Int16, objConfigUser.Id_Dept)
                objDB.AddInParameter(objCMD, "@IV_Address1", DbType.String, objConfigUser.Address1)
                objDB.AddInParameter(objCMD, "@IV_Address2", DbType.String, objConfigUser.Address2)
                objDB.AddInParameter(objCMD, "@II_ID_Lang_User", DbType.Int16, objConfigUser.Id_Lang)
                objDB.AddInParameter(objCMD, "@II_ID_ZIP_User", DbType.String, objConfigUser.Id_Zip_Users)
                objDB.AddInParameter(objCMD, "@IV_ID_Email", DbType.String, objConfigUser.Id_Email)
                objDB.AddInParameter(objCMD, "@IV_Phone", DbType.String, objConfigUser.Phone)
                objDB.AddInParameter(objCMD, "@IV_Mobileno", DbType.String, objConfigUser.Mobileno)
                objDB.AddInParameter(objCMD, "@IV_FaxNo", DbType.String, objConfigUser.FaxNo)
                objDB.AddInParameter(objCMD, "@IB_Flg_Mechanic", DbType.Boolean, objConfigUser.Flg_Mechanic)
                objDB.AddInParameter(objCMD, "@IV_USERID", DbType.String, objConfigUser.Userid)
                objDB.AddInParameter(objCMD, "@IV_CREATED_BY", DbType.String, objConfigUser.Created_By)
                objDB.AddInParameter(objCMD, "@IV_CUSTPCOUNTRY", DbType.String, objConfigUser.Id_Country)
                objDB.AddInParameter(objCMD, "@IV_CUSTPCITY", DbType.String, objConfigUser.Id_City)
                objDB.AddInParameter(objCMD, "@IV_CUSTSTATE", DbType.String, objConfigUser.Id_State)
                objDB.AddOutParameter(objCMD, "@OV_RETVAL", DbType.String, 20)
                objDB.AddInParameter(objCMD, "@FLG_MECH_INACTIVE", DbType.Boolean, objConfigUser.Flg_Mech_Isactive)
                objDB.AddInParameter(objCMD, "@FLG_CONFIGZIPCODE", DbType.Boolean, objConfigUser.Flg_ConfigZipCode)
                objDB.AddInParameter(objCMD, "@IV_FLG_USE_IDLETIME", DbType.Boolean, objConfigUser.Flg_Use_Idletime)
                objDB.AddInParameter(objCMD, "@IV_COMMON_MECHANIC_ID", DbType.String, objConfigUser.Common_Mechanic_Id)
                objDB.AddInParameter(objCMD, "@IV_ISCOMMON_MECHANIC", DbType.Boolean, objConfigUser.Iscommon_Mechanic)
                objDB.AddInParameter(objCMD, "@IV_SOCIAL_SECURITY_NUM", DbType.String, objConfigUser.Social_Security_Num)
                objDB.AddInParameter(objCMD, "@IV_WORKHRS_FRM", DbType.String, objConfigUser.Workhrs_Frm)
                objDB.AddInParameter(objCMD, "@IV_WORKHRS_TO", DbType.String, objConfigUser.Workhrs_To)
                objDB.AddInParameter(objCMD, "@IV_FLG_WORKHRS", DbType.Boolean, objConfigUser.Flg_Workhrs)
                objDB.AddInParameter(objCMD, "@IV_FLG_DUSER", DbType.Boolean, objConfigUser.Flg_Duser)
                objDB.AddInParameter(objCMD, "@IV_ID_EMAIL_ACCT", DbType.Int16, objConfigUser.Id_Email_Acct)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strErrcode = CStr(objDB.GetParameterValue(objCMD, "@OV_RETVAL"))
                Catch generatedExceptionName As Exception
                    Throw
                End Try
                Return strErrcode
            End Using
        End Function
        Public Function Update_User(ByVal objConfigUser As ConfigUsersBO) As String
            Dim strErrcode As String
            Dim ds As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_USERS_UPDATE")
                objDB.AddInParameter(objCMD, "@IV_ID_Login", DbType.String, objConfigUser.Id_Login)
                objDB.AddInParameter(objCMD, "@IV_First_Name", DbType.String, objConfigUser.First_Name)
                objDB.AddInParameter(objCMD, "@IV_Last_Name", DbType.String, objConfigUser.Last_Name)
                objDB.AddInParameter(objCMD, "@II_ID_ROLE_User", DbType.Int16, objConfigUser.Id_Role_User)
                objDB.AddInParameter(objCMD, "@IV_Password", DbType.String, objConfigUser.Password)
                objDB.AddInParameter(objCMD, "@II_ID_Subsidery_User", DbType.Int16, objConfigUser.Id_Subsidery_User)
                objDB.AddInParameter(objCMD, "@II_ID_Dept_User", DbType.Int16, objConfigUser.Id_Dept)
                objDB.AddInParameter(objCMD, "@IV_Address1", DbType.String, objConfigUser.Address1)
                objDB.AddInParameter(objCMD, "@IV_Address2", DbType.String, objConfigUser.Address2)
                objDB.AddInParameter(objCMD, "@II_ID_Lang_User", DbType.Int16, objConfigUser.Id_Lang)
                objDB.AddInParameter(objCMD, "@II_ID_ZIP_User", DbType.String, objConfigUser.Id_Zip_Users)
                objDB.AddInParameter(objCMD, "@IV_ID_Email", DbType.String, objConfigUser.Id_Email)
                objDB.AddInParameter(objCMD, "@IV_Phone", DbType.String, objConfigUser.Phone)
                objDB.AddInParameter(objCMD, "@IV_Mobileno", DbType.String, objConfigUser.Mobileno)
                objDB.AddInParameter(objCMD, "@IV_FaxNo", DbType.String, objConfigUser.FaxNo)
                objDB.AddInParameter(objCMD, "@IB_Flg_Mechanic", DbType.Boolean, objConfigUser.Flg_Mechanic)
                objDB.AddInParameter(objCMD, "@IV_USERID", DbType.String, objConfigUser.Userid)
                objDB.AddInParameter(objCMD, "@IV_CREATED_BY", DbType.String, objConfigUser.Created_By)
                objDB.AddInParameter(objCMD, "@IV_CUSTPCOUNTRY", DbType.String, objConfigUser.Id_Country)
                objDB.AddInParameter(objCMD, "@IV_CUSTPCITY", DbType.String, objConfigUser.Id_City)
                objDB.AddInParameter(objCMD, "@IV_CUSTSTATE", DbType.String, objConfigUser.Id_State)
                objDB.AddOutParameter(objCMD, "@OV_RETVAL", DbType.String, 20)
                objDB.AddInParameter(objCMD, "@FLG_MECH_INACTIVE", DbType.Boolean, objConfigUser.Flg_Mech_Isactive)
                objDB.AddInParameter(objCMD, "@FLG_CONFIGZIPCODE", DbType.Boolean, objConfigUser.Flg_ConfigZipCode)
                objDB.AddInParameter(objCMD, "@IV_FLG_USE_IDLETIME", DbType.Boolean, objConfigUser.Flg_Use_Idletime)
                objDB.AddInParameter(objCMD, "@IV_COMMON_MECHANIC_ID", DbType.String, objConfigUser.Common_Mechanic_Id)
                objDB.AddInParameter(objCMD, "@IV_ISCOMMON_MECHANIC", DbType.Boolean, objConfigUser.Iscommon_Mechanic)
                objDB.AddInParameter(objCMD, "@IV_SOCIAL_SECURITY_NUM", DbType.String, objConfigUser.Social_Security_Num)
                objDB.AddInParameter(objCMD, "@IV_WORKHRS_FRM", DbType.String, objConfigUser.Workhrs_Frm)
                objDB.AddInParameter(objCMD, "@IV_WORKHRS_TO", DbType.String, objConfigUser.Workhrs_To)
                objDB.AddInParameter(objCMD, "@IV_FLG_WORKHRS", DbType.Boolean, objConfigUser.Flg_Workhrs)
                objDB.AddInParameter(objCMD, "@IV_FLG_DUSER", DbType.Boolean, objConfigUser.Flg_Duser)
                objDB.AddInParameter(objCMD, "@IV_ID_EMAIL_ACCT", DbType.Int16, objConfigUser.Id_Email_Acct)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strErrcode = CStr(objDB.GetParameterValue(objCMD, "@OV_RETVAL"))
                Catch generatedExceptionName As Exception
                    Throw
                End Try
                Return strErrcode

            End Using
        End Function
        Public Function Delete_User(ByVal objConfigUser As ConfigUsersBO) As String
            Dim strStatus As String
            strStatus = ""
            Dim ds As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MAS_USER_DELETE")
                objDB.AddInParameter(objCMD, "@IV_UserId", DbType.String, objConfigUser.Userid)
                objDB.AddOutParameter(objCMD, "@OV_RetValue", DbType.String, 10)
                objDB.AddOutParameter(objCMD, "@OV_CntDelete", DbType.String, 2000)
                objDB.AddOutParameter(objCMD, "@OV_DeletedCfg", DbType.String, 2000)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strStatus = CStr(objDB.GetParameterValue(objCMD, "@OV_RetValue") + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objCMD, "@OV_DeletedCfg")), "", objDB.GetParameterValue(objCMD, "@OV_DeletedCfg"))) + "," + CStr(IIf(IsDBNull(objDB.GetParameterValue(objCMD, "@OV_CntDelete")), "", objDB.GetParameterValue(objCMD, "@OV_CntDelete"))))
                Catch generatedExceptionName As Exception
                    Throw
                End Try
                Return strStatus

            End Using
        End Function
        Public Function Update_User_PWD(ByVal objConfigUser As ConfigUsersBO) As String
            Dim strStatus As String
            strStatus = ""
            Dim ds As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_USERS_PWD_UPDATE")
                objDB.AddInParameter(objCMD, "@IV_ID_Login", DbType.String, objConfigUser.Id_Login)
                objDB.AddInParameter(objCMD, "@IV_Password", DbType.String, objConfigUser.Password)
                objDB.AddInParameter(objCMD, "@IV_CREATED_BY", DbType.String, objConfigUser.Created_By)
                objDB.AddOutParameter(objCMD, "@OV_RETVAL", DbType.String, 20)
                Try
                    objDB.ExecuteNonQuery(objCMD)
                    strStatus = CStr(objDB.GetParameterValue(objCMD, "@OV_RETVAL"))
                Catch generatedExceptionName As Exception
                    Throw
                End Try
                Return strStatus

            End Using
        End Function
        Public Function GetSubsidiares(ByVal objConfigUser As ConfigUsersBO) As DataSet
            Dim dsSubs As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_GET_SUBSIDERY_FETCH")
                objDB.AddInParameter(objCMD, "@ID_USER", DbType.String, objConfigUser.Id_Login)
                Try
                    dsSubs = objDB.ExecuteDataSet(objCMD)
                Catch generatedExceptionName As Exception
                    Throw
                End Try
            End Using
            Return dsSubs
        End Function
        Public Function Fetch_EmailAcct(ByVal objConfigUser As ConfigUsersBO) As DataSet
            Dim dsSubs As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_EMAIL_ACCT_SUB")
                objDB.AddInParameter(objCMD, "@ID_SUBSIDERY_ROLE", DbType.String, objConfigUser.Id_Subsidery_User)
                Try
                    dsSubs = objDB.ExecuteDataSet(objCMD)
                Catch generatedExceptionName As Exception
                    Throw
                End Try
            End Using
            Return dsSubs
        End Function


        Public Function Switch_Pin(ByVal objPinSwitch As pinSwitch, ByVal login As String) As String
            Try
                Dim strStatus As String
                strStatus = "test"
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_PIN_MENU")
                    objDB.AddInParameter(objcmd, "@flg", DbType.Boolean, objPinSwitch.flg_pin_menu)
                    objDB.AddInParameter(objcmd, "@user", DbType.String, login)
                    objDB.AddInParameter(objcmd, "@fetch", DbType.Boolean, objPinSwitch.fetch)
                    objDB.AddOutParameter(objcmd, "@PINSTATE", DbType.String, 15)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@PINSTATE").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus

            Catch ex As Exception
                Throw ex
            End Try
        End Function
#End Region
    End Class
End Namespace

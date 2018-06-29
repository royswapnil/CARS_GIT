Imports Microsoft.VisualBasic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Security.Cryptography
Imports System.IO
Imports CARS.CoreLibrary
Namespace CARS.Role
    Public Class ConfigRoleDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Add_Role(ByVal objConfigRoleBO As ConfigRoleBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ROLE_INSERTR")
                    objDB.AddInParameter(objcmd, "@iv_NM_ROLE", DbType.String, objConfigRoleBO.Nm_Role)
                    objDB.AddInParameter(objcmd, "@iv_ID_SUBSIDERY_ROLE", DbType.Int32, objConfigRoleBO.Id_Subsidery_Role)
                    objDB.AddInParameter(objcmd, "@iv_ID_DEPT_ROLE", DbType.Int32, objConfigRoleBO.Id_Dept_Role)
                    objDB.AddInParameter(objcmd, "@iv_ID_SCR_START_ROLE", DbType.Int32, objConfigRoleBO.Id_Scr_Start_Role)
                    objDB.AddInParameter(objcmd, "@iv_FLG_SYSADMIN", DbType.Boolean, objConfigRoleBO.Flg_Sysadmin)
                    objDB.AddInParameter(objcmd, "@iv_FLG_SUBSIDADMIN", DbType.Boolean, objConfigRoleBO.Flg_Subsidadmin)
                    objDB.AddInParameter(objcmd, "@iv_FLG_DEPTADMIN", DbType.Boolean, objConfigRoleBO.Flg_Deptadmin)
                    objDB.AddInParameter(objcmd, "@iv_UserId", DbType.String, objConfigRoleBO.Created_By)
                    objDB.AddOutParameter(objcmd, "@iv_Status", DbType.String, 50)
                    Try
                        objDB.ExecuteNonQuery(objcmd)
                        strStatus = objDB.GetParameterValue(objcmd, "@iv_Status").ToString
                    Catch ex As Exception
                        Throw
                    End Try
                End Using
                Return strStatus

            Catch ex As Exception
                Throw ex
            End Try

        End Function
        Public Function Scr_Name_Fetch(ByVal objConfigRoleBO As ConfigRoleBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_NAME_SCR_FECH")
                    objDB.AddInParameter(objcmd, "@LANG_NAME", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_Role(ByVal objConfigRoleBO As ConfigRoleBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_Role_FetchAllR")
                    objDB.AddInParameter(objcmd, "@ID_SUBSIDERY_ROLE", DbType.Int32, objConfigRoleBO.Id_Subsidery_Role)
                    objDB.AddInParameter(objcmd, "@ID_DEPT_ROLE", DbType.Int32, objConfigRoleBO.Id_Dept_Role)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function RoleAccess(ByVal objConfigRoleBO As ConfigRoleBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ROLE_DET_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_ROLE", DbType.Int32, objConfigRoleBO.Id_Role)
                    objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objConfigRoleBO.User)
                    objDB.AddInParameter(objcmd, "@LANG_NAME", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function RoleStartScreen() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_STARTSCREEN")
                    objDB.AddOutParameter(objcmd, "@ov_Error_Code", DbType.String, 50)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveSerRole(ByVal objConfigRoleBO As ConfigRoleBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ROLE_SCR_INSERT1")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, objConfigRoleBO.Scrlroleupdate)
                    objDB.AddInParameter(objcmd, "@IN_ID_ROLE", DbType.Int32, objConfigRoleBO.Id_Role)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, objConfigRoleBO.Created_By)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 50)
                    objcmd.CommandTimeout = 0
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Remove_Role(ByVal objConfigRoleBO As ConfigRoleBO) As String

            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ROLE_DELETE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, objConfigRoleBO.StrDelRole)
                    objDB.AddOutParameter(objcmd, "@ov_CntDelete", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_DeletedCfg", DbType.String, 2000)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 20)
                    objDB.ExecuteNonQuery(objcmd)
                    'notdel = objDB.GetParameterValue(objcmd, "@ov_CntDelete").ToString
                    'del = objDB.GetParameterValue(objcmd, "@ov_DeletedCfg").ToString
                    'strStatus = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                    strStatus = CStr(objDB.GetParameterValue(objcmd, "@OV_RetValue") + "," + Replace(CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_DeletedCfg")), "", objDB.GetParameterValue(objcmd, "@OV_DeletedCfg"))), ",", "") + "," + Replace(CStr(IIf(IsDBNull(objDB.GetParameterValue(objcmd, "@OV_CntDelete")), "", objDB.GetParameterValue(objcmd, "@OV_CntDelete"))), ",", ""))
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetUserScreenAccess(ByVal UserID As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("Usp_User_access")
                    objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, UserID)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetUserStartScreen(ByVal UserID As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ROLE_SCR_START")
                    objDB.AddInParameter(objcmd, "@iv_USER", DbType.String, UserID)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetTimeFormat() As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_GETTIMEFORMAT")
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function UpdateRole(ByVal objConfigRoleBO As ConfigRoleBO) As String
            Dim strStatus As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_ROLE_UPDATE")
                    objDB.AddInParameter(objcmd, "@IV_ROLEID", DbType.String, objConfigRoleBO.Id_Role)
                    objDB.AddInParameter(objcmd, "@iv_NM_ROLE", DbType.String, objConfigRoleBO.Nm_Role)
                    objDB.AddInParameter(objcmd, "@iv_ID_SUBSIDERY_ROLE", DbType.Int32, objConfigRoleBO.Id_Subsidery_Role)
                    objDB.AddInParameter(objcmd, "@iv_ID_DEPT_ROLE", DbType.Int32, objConfigRoleBO.Id_Dept_Role)
                    objDB.AddInParameter(objcmd, "@iv_ID_SCR_START_ROLE", DbType.Int32, objConfigRoleBO.Id_Scr_Start_Role)
                    objDB.AddInParameter(objcmd, "@iv_FLG_SYSADMIN", DbType.Boolean, objConfigRoleBO.Flg_Sysadmin)
                    objDB.AddInParameter(objcmd, "@iv_FLG_SUBSIDADMIN", DbType.Boolean, objConfigRoleBO.Flg_Subsidadmin)
                    objDB.AddInParameter(objcmd, "@iv_FLG_DEPTADMIN", DbType.Boolean, objConfigRoleBO.Flg_Deptadmin)
                    objDB.AddInParameter(objcmd, "@iv_UserId", DbType.String, objConfigRoleBO.Created_By)
                    objDB.AddOutParameter(objcmd, "@iv_Status", DbType.String, 20)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@iv_Status").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function GetMenuData(ByVal objConfigRoleBO As ConfigRoleBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_USERMENU_NEW")
                    objDB.AddInParameter(objcmd, "@iv_ID_Login", DbType.String, objConfigRoleBO.User)
                    objDB.AddInParameter(objcmd, "@IV_LANGUAGENAME", DbType.String, objConfigRoleBO.LanguageId)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function


    End Class
End Namespace

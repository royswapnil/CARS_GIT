Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data.Common
Namespace CARS.UserAccessPermissions
    Public Class UserAccessPermissionsDO
        Dim objDB As Database
        Dim ConnectionString As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        '**********************************************************************
        '  Name of Method               : GetUserScrPer
        '  Description                  :   This method is Get all Strart screen for role
        '  Output Params                :   -
        '  I/O Params                   :   -   
        '  Globals Used                 :   -
        '  Routines Called              :   -
        '***********************************************************************
        Public Function GetUserScrPer(ByVal DT As DataTable, ByVal ID_SCR As String) As UserAccessPermissionsBO

            Dim objuserper As New UserAccessPermissionsBO

            Dim dr() As DataRow
            Dim dr1 As DataRow
            Try
                dr = DT.Select("ID_SCR_UTIL=" & ID_SCR)
                dr1 = dr(0)
                objuserper.PF_ACC_SCR = Convert.ToInt16(dr1(0).ToString())

                objuserper.PF_ACC_VIEW = Convert.ToBoolean(dr1(1).ToString())
                objuserper.PF_ACC_ADD = Convert.ToBoolean(dr1(2).ToString())
                objuserper.PF_ACC_EDIT = Convert.ToBoolean(dr1(3).ToString())
                objuserper.PF_ACC_PRINT = Convert.ToBoolean(dr1(4).ToString())
                objuserper.PF_ACC_DELETE = Convert.ToBoolean(dr1(4).ToString())
            Catch ex As Exception
            End Try
            Return objuserper
        End Function
        Public Function GetUserScrPerByName(ByVal DT As DataTable, ByVal ID_SCR As String) As UserAccessPermissionsBO
            Dim objuserper As New UserAccessPermissionsBO
            Dim dr() As DataRow
            Dim dr1 As DataRow
            Try
                dr = DT.Select("ID_SCR_UTIL=" & ID_SCR)
                dr1 = dr(0)
                objuserper.PF_ACC_SCR = Convert.ToInt16(dr1(0).ToString())
                objuserper.PF_ACC_VIEW = Convert.ToBoolean(dr1(1).ToString())
                objuserper.PF_ACC_ADD = Convert.ToBoolean(dr1(2).ToString())
                objuserper.PF_ACC_EDIT = Convert.ToBoolean(dr1(3).ToString())
                objuserper.PF_ACC_PRINT = Convert.ToBoolean(dr1(4).ToString())
                objuserper.PF_ACC_DELETE = Convert.ToBoolean(dr1(4).ToString())
            Catch ex As Exception

            End Try
            Return objuserper
        End Function
        Public Function GetTopMenuDetails(ByVal objConfigUserPermBO As UserAccessPermissionsBO) As DataSet
            Dim dsTopMenu As DataSet = Nothing
            Try
                Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_MENU_TOP_FETCH")
                    objDB.AddInParameter(objCMD, "@IV_MOD_NAME", DbType.String, objConfigUserPermBO.Module_Name)
                    objDB.AddInParameter(objCMD, "@IV_LANG", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    dsTopMenu = objDB.ExecuteDataSet(objCMD)
                End Using
                Return dsTopMenu
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace

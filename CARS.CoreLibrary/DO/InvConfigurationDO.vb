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
Imports System.Web

Namespace CARS.InvConfigurationDO
    Public Class InvConfigurationDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub

        Public Function FetchConfig(ByVal idsubinv As Integer, ByVal iddeptinv As Integer) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_INV_CONFIG_FETCH")
                    objDB.AddInParameter(objcmd, "@IV_ID_SUBSIDERY_INV", DbType.String, idsubinv)
                    objDB.AddInParameter(objcmd, "@IV_ID_DEPT_INV", DbType.String, iddeptinv)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function


    End Class
End Namespace


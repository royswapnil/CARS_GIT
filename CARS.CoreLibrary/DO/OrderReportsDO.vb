Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System
Imports System.Configuration
Imports System.Data.Common
Public Class OrderReportsDO
    Dim objDB As Database
    Dim ConnectionString As String

    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub
    Public Function Check_Sales_Per_Mechanic_Report(ByVal deptFrom As String, ByVal deptTo As String, ByVal year As String, ByVal fromMnth As String, ByVal toMnth As String, ByVal fromMecCode As String, ByVal toMecCode As String) As DataSet
        Try
            Dim dsSalesMech As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_CHECK_SALES_PER_MECHANIC_REPORT")
                objDB.AddInParameter(objCMD, "@IV_DEP_FROM", DbType.String, deptFrom)
                objDB.AddInParameter(objCMD, "@IV_DEP_TO", DbType.String, deptTo)
                objDB.AddInParameter(objCMD, "@IV_YEAR", DbType.String, year)
                objDB.AddInParameter(objCMD, "@IV_MONTH_FROM", DbType.String, fromMnth)
                objDB.AddInParameter(objCMD, "@IV_MONTH_TO", DbType.String, toMnth)
                objDB.AddInParameter(objCMD, "@IV_MECH_CODE_FROM", DbType.String, fromMecCode)
                objDB.AddInParameter(objCMD, "@IV_MECH_CODE_TO", DbType.String, toMecCode)
                objDB.AddInParameter(objCMD, "@IV_LANGUAGE", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())

                dsSalesMech = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsSalesMech
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function Fetch_SaleAnalyse_Report(ByVal idLogin As String) As DataSet
        Try
            Dim dsSalesAna As New DataSet
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_RPT_SALE_ANAYLSE")
                objDB.AddInParameter(objCMD, "@IV_ID_USER", DbType.String, idLogin)
                dsSalesAna = objDB.ExecuteDataSet(objCMD)
            End Using
            Return dsSalesAna
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class

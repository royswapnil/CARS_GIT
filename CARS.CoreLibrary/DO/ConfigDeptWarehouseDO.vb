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
Namespace CARS.ConfigDeptWarehouseDO
    Public Class ConfigDeptWarehouseDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function GetDeptWarehouse(ByVal loginName As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_DEPTWAREHOUSE_FETCH")
                    objDB.AddInParameter(objcmd, "@ID_lOGIN", DbType.String, loginName)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function SaveDeptWarehouse(ByVal objDeptConfigWHBO As ConfigDeptWarehouseBO) As String
            Dim dsmodifyDeptWh As DataSet
            Dim strStatus As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_DEPTWAREHOUSE_MODIFY")
                    objDB.AddInParameter(objcmd, "@DEPTID", DbType.String, objDeptConfigWHBO.DepartmentId)
                    objDB.AddInParameter(objcmd, "@WH_STRING", DbType.String, objDeptConfigWHBO.WareHouseValue)
                    objDB.AddInParameter(objcmd, "@CREATEDBY", DbType.String, objDeptConfigWHBO.ModifiedBy)
                    objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 20)
                    objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + ";" + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                End Using
                Return strStatus
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace
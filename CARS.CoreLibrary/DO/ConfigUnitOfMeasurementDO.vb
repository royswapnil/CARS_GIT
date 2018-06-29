Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data.Sql
Imports System.Data.Common
Imports Newtonsoft.Json
Imports CARS.CoreLibrary.CARS
Public Class ConfigUnitOfMeasurementDO
    Shared commonUtil As New Utilities.CommonUtility
    Dim ConnectionString As String
    Dim objDB As Database
    Public Sub New()
        ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
        objDB = New SqlDatabase(ConnectionString)
    End Sub
    Public Function Fetch_UOM() As DataSet
        Try
            Using objCMD As DbCommand = objDB.GetStoredProcCommand("USP_SPR_FETCH_UOM")
                Return objDB.ExecuteDataSet(objCMD)
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function AddUOMDetails(ByVal objItem As ConfigUnitOfMeasurementBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_UOM_INSERT")
                objDB.AddInParameter(objcmd, "@UOM", DbType.String, objItem.Unit_Desc)
                objDB.AddInParameter(objcmd, "@DESC", DbType.String, objItem.Description)
                objDB.AddInParameter(objcmd, "@CREATED_BY", DbType.String, objItem.CreatedBy)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function UpdUOMDetails(ByVal objItem As ConfigUnitOfMeasurementBO) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_UOM_MODIFY")
                objDB.AddInParameter(objcmd, "@UOM", DbType.String, objItem.Unit_Desc)
                objDB.AddInParameter(objcmd, "@DESC", DbType.String, objItem.Description)
                objDB.AddInParameter(objcmd, "@MODIFIED_BY", DbType.String, objItem.CreatedBy)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                Try
                    objDB.ExecuteNonQuery(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
                Catch ex As Exception
                    Throw
                End Try
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Function DeleteUOMDetails(ByVal idUOM As String) As String
        Dim strStatus As String
        Try
            Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_SPR_UOM_DELETE")
                objDB.AddInParameter(objcmd, "@ID_UOM", DbType.String, idUOM)
                objDB.AddOutParameter(objcmd, "@ISSUCCESS", DbType.Boolean, 10)
                objDB.AddOutParameter(objcmd, "@ERRMSG", DbType.String, 200)
                objDB.ExecuteNonQuery(objcmd)
                strStatus = objDB.GetParameterValue(objcmd, "@ISSUCCESS").ToString + "," + objDB.GetParameterValue(objcmd, "@ERRMSG").ToString
            End Using
            Return strStatus
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class

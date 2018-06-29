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
Namespace CARS.ConfigInvPayment
    Public Class ConfigInvPaymentDO
        Dim ConnectionString As String
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Fetch_InvoiceSeries_Default(ByVal strInvPrefix As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVSERIESCONFIGURATION_Default")
                    objDB.AddInParameter(objcmd, "@INVPREFIX", DbType.String, strInvPrefix)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_InvoiceSeries(ByVal idInvSeries As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVSERIESCONFIGURATION")
                    objDB.AddInParameter(objcmd, "@ID_PAYSERIES", DbType.Int32, Convert.ToInt16(idInvSeries))
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Fetch_InvoiceSeries_prefix(ByVal strInvPrefix As String) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_FETCH_INVSER_PREFIX")
                    objDB.AddInParameter(objcmd, "@INV_PREFIX", DbType.String, strInvPrefix)
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Add_InvPaymentSeries(ByVal configPaymentBO As ConfigInvPaymentBO) As String
            Dim strResult As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_INV_PAYMENT_SERIES_INSERT")
                    objDB.AddInParameter(objcmd, "@IV_INV_PREFIX", DbType.String, configPaymentBO.InvPrefix)
                    objDB.AddInParameter(objcmd, "@IV_INV_DESCRIPTON", DbType.String, configPaymentBO.InvDesc)
                    objDB.AddInParameter(objcmd, "@IV_INV_STARTNO", DbType.Int32, configPaymentBO.InvStartNo)
                    objDB.AddInParameter(objcmd, "@IV_INV_ENDNO", DbType.Int32, configPaymentBO.InvEndNo)
                    objDB.AddInParameter(objcmd, "@IV_INV_WARNINGBEFORE", DbType.Int32, configPaymentBO.InvWarningBefore)
                    objDB.AddInParameter(objcmd, "@IV_CREATED_BY", DbType.String, configPaymentBO.CreatedBy)
                    objDB.AddInParameter(objcmd, "@IV_TEXTCODE", DbType.String, configPaymentBO.TextCode)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function
        Public Function Update_InvPaymentSeries(ByVal configPaymentBO As ConfigInvPaymentBO) As String
            Dim strResult As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_MAS_INV_PAYMENT_SERIES_UPDATE")
                    objDB.AddInParameter(objcmd, "@IV_ID_PAYSERIES", DbType.Int32, Convert.ToInt32(configPaymentBO.InvSeries))
                    objDB.AddInParameter(objcmd, "@IV_INV_PREFIX", DbType.String, configPaymentBO.InvPrefix)
                    objDB.AddInParameter(objcmd, "@IV_INV_DESCRIPTON", DbType.String, configPaymentBO.InvDesc)
                    objDB.AddInParameter(objcmd, "@IV_INV_STARTNO", DbType.Int32, configPaymentBO.InvStartNo)
                    objDB.AddInParameter(objcmd, "@IV_INV_ENDNO", DbType.Int32, configPaymentBO.InvEndNo)
                    objDB.AddInParameter(objcmd, "@IV_INV_WARNINGBEFORE", DbType.Int32, configPaymentBO.InvWarningBefore)
                    objDB.AddInParameter(objcmd, "@IV_MODIFIED_BY", DbType.String, configPaymentBO.CreatedBy)
                    objDB.AddInParameter(objcmd, "@IV_TEXTCODE", DbType.String, configPaymentBO.TextCode)
                    objDB.AddOutParameter(objcmd, "@ov_RetValue", DbType.String, 10)
                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function
        Public Function Delete_InvSeries(ByVal strPrefix As String) As String
            Dim strResult As String = ""
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_CONFIG_INV_SERIES_DELETE")
                    objDB.AddInParameter(objcmd, "@IV_INVPREFIX", DbType.String, strPrefix)
                    objDB.AddOutParameter(objcmd, "@OV_RetValue", DbType.String, "100")
                    objDB.AddOutParameter(objcmd, "@OV_CntDelete", DbType.String, "100")
                    objDB.AddOutParameter(objcmd, "@OV_DeletedCfg", DbType.String, "100")

                    objDB.ExecuteNonQuery(objcmd)
                    strResult = objDB.GetParameterValue(objcmd, "@ov_RetValue").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_DeletedCfg").ToString + "," + objDB.GetParameterValue(objcmd, "@OV_CntDelete").ToString
                End Using
            Catch ex As Exception
                Throw ex
            End Try
            Return strResult
        End Function

    End Class
End Namespace



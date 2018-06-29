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
Namespace CARS.WOPaymentDetailDO
    Public Class WOPaymentDetailDO
        Dim ConnectionString As String
        Dim objDB As Database
        Dim strStatus As String
        Public Sub New()
            ConnectionString = System.Configuration.ConfigurationManager.AppSettings("MSGConstr")
            objDB = New SqlDatabase(ConnectionString)
        End Sub
        Public Function Load_PaymentDetails(ByVal objWOPayDetailsBO As WOPaymentDetailBO) As DataSet
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_PAYMENTSUMMARY")
                    objDB.AddInParameter(objcmd, "@WONO", DbType.String, objWOPayDetailsBO.Id_WO_NO)
                    objDB.AddInParameter(objcmd, "@WOPREFIX", DbType.String, objWOPayDetailsBO.Id_WO_Prefix)
                    objDB.AddInParameter(objcmd, "@IV_Lang", DbType.String, System.Configuration.ConfigurationManager.AppSettings("Language").ToString())
                    Return objDB.ExecuteDataSet(objcmd)
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_Pay_Terms(ByVal objWOPayDetailsBO As WOPaymentDetailBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_REDTOINV")
                    objDB.AddInParameter(objcmd, "@XMLDOC", DbType.String, objWOPayDetailsBO.IdXml)
                    objDB.AddInParameter(objcmd, "@iv_UserId", DbType.String, objWOPayDetailsBO.LoginId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                    objDB.ExecuteDataSet(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Update_ReadyForWork(ByVal objWOPayDetailsBO As WOPaymentDetailBO) As String
            Try
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_WO_REDTOWRK")
                    objDB.AddInParameter(objcmd, "@XMLDOC", DbType.String, objWOPayDetailsBO.IdXml)
                    objDB.AddInParameter(objcmd, "@iv_UserId", DbType.String, objWOPayDetailsBO.LoginId)
                    objDB.AddOutParameter(objcmd, "@OV_RETVALUE", DbType.String, 50)
                    objDB.ExecuteDataSet(objcmd)
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_RETVALUE").ToString
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
        Public Function Generate_Invoices(ByVal InvXml As String, ByVal LoginId As String, ByVal StrInv As String) As String
            Try
                Dim strinvListXml As String
                Using objcmd As DbCommand = objDB.GetStoredProcCommand("USP_IN_CREATEINV_INSERT_INTERMEDIATE")
                    objDB.AddInParameter(objcmd, "@iv_xmlDoc", DbType.String, InvXml)
                    objDB.AddInParameter(objcmd, "@iv_CreatedBy", DbType.String, LoginId)
                    objDB.AddOutParameter(objcmd, "@OV_INV_RETVAL", DbType.String, 50)
                    objDB.AddOutParameter(objcmd, "@OV_INV_LIST", DbType.String, 7000)
                    objDB.ExecuteDataSet(objcmd)
                    strinvListXml = objDB.GetParameterValue(objcmd, "@OV_INV_LIST").ToString
                    System.Web.HttpContext.Current.Session("strinvListXml") = strinvListXml
                    strStatus = objDB.GetParameterValue(objcmd, "@OV_INV_RETVAL").ToString
                    Return strStatus
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class
End Namespace

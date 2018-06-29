Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports System
Imports MSGCOMMON
Imports System.Web.Security
Namespace CARS.Services.ConfigInvPayment
    Public Class InvoicePaymentSeries
        Shared objConfigInvPaymentBO As New ConfigInvPaymentBO
        Shared objConfigInvPaymentDO As New CARS.ConfigInvPayment.ConfigInvPaymentDO
        Shared objCommonUtil As New CARS.Utilities.CommonUtility
        Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Public Function FetchAllInvSeries(ByVal strInvPrefix As String) As List(Of ConfigInvPaymentBO)
            Dim details As New List(Of ConfigInvPaymentBO)()
            Dim dsConfigInvPay As New DataSet
            Dim dtConfigInvPay As New DataTable
            Try
                dsConfigInvPay = objConfigInvPaymentDO.Fetch_InvoiceSeries_Default(strInvPrefix)
                If dsConfigInvPay.Tables.Count > 0 Then
                    dtConfigInvPay = dsConfigInvPay.Tables(0)
                    For Each dtrow As DataRow In dtConfigInvPay.Rows
                        Dim configInvPayDet As New ConfigInvPaymentBO()
                        configInvPayDet.InvSeries = dtrow("ID_PAYSERIES").ToString()
                        configInvPayDet.InvPrefix = dtrow("INV_PREFIX").ToString()
                        configInvPayDet.InvDesc = dtrow("INV_DESCRIPTON").ToString()
                        configInvPayDet.InvStartNo = dtrow("INV_STARTNO").ToString()
                        configInvPayDet.InvEndNo = dtrow("INV_ENDNO").ToString()
                        configInvPayDet.InvWarningBefore = dtrow("INV_WARNINGBEFORE").ToString()
                        configInvPayDet.TextCode = dtrow("TextCode").ToString()
                        configInvPayDet.CreatedBy = dtrow("CREATED_BY").ToString()

                        If (IsDBNull(dtrow("DT_CREATED").ToString())) Then
                            configInvPayDet.CreatedDate = ""
                        Else
                            configInvPayDet.CreatedDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        End If
                        configInvPayDet.ModifiedBy = dtrow("MODIFIED_BY").ToString()
                        If (IsDBNull(dtrow("DT_MODIFIED").ToString())) Then
                            configInvPayDet.ModifiedDate = ""
                        Else
                            configInvPayDet.ModifiedDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                        End If
                        details.Add(configInvPayDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigInvPayment", "FetchAllInvSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function GetInvSeries(ByVal idInvSeries As String) As List(Of ConfigInvPaymentBO)
            Dim details As New List(Of ConfigInvPaymentBO)()
            Dim dsConfigInvPay As New DataSet
            Dim dtConfigInvPay As New DataTable
            Try
                dsConfigInvPay = objConfigInvPaymentDO.Fetch_InvoiceSeries(idInvSeries)
                If dsConfigInvPay.Tables.Count > 0 Then
                    dtConfigInvPay = dsConfigInvPay.Tables(0)
                    For Each dtrow As DataRow In dtConfigInvPay.Rows
                        Dim configInvPayDet As New ConfigInvPaymentBO()
                        configInvPayDet.InvSeries = dtrow("ID_PAYSERIES").ToString()
                        configInvPayDet.InvPrefix = dtrow("INV_PREFIX").ToString()
                        configInvPayDet.InvDesc = dtrow("INV_DESCRIPTON").ToString()
                        configInvPayDet.InvStartNo = dtrow("INV_STARTNO").ToString()
                        configInvPayDet.InvEndNo = dtrow("INV_ENDNO").ToString()
                        configInvPayDet.InvWarningBefore = dtrow("INV_WARNINGBEFORE").ToString()
                        configInvPayDet.TextCode = dtrow("TextCode").ToString()
                        If (IsDBNull(dtrow("CREATED_BY").ToString())) Then
                            configInvPayDet.CreatedBy = ""
                        Else
                            configInvPayDet.CreatedBy = objCommonUtil.GetCurrentLanguageDate(dtrow("CREATED_BY").ToString())
                        End If
                        If (IsDBNull(dtrow("DT_CREATED").ToString())) Then
                            configInvPayDet.CreatedDate = ""
                        Else
                            configInvPayDet.CreatedDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_CREATED").ToString())
                        End If
                        configInvPayDet.ModifiedBy = dtrow("MODIFIED_BY").ToString()
                        If (IsDBNull(dtrow("DT_MODIFIED").ToString())) Then
                            configInvPayDet.ModifiedDate = ""
                        Else
                            configInvPayDet.ModifiedDate = objCommonUtil.GetCurrentLanguageDate(dtrow("DT_MODIFIED").ToString())
                        End If
                        details.Add(configInvPayDet)
                    Next
                End If
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigInvPayment", "FetchAllInvSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return details.ToList
        End Function
        Public Function Save_InvPaymentSeries(ByVal objConfigInvPayBO As ConfigInvPaymentBO, ByVal mode As String) As String
            Dim strResult As String = ""
            Try
                If (mode = "Edit") Then
                    strResult = objConfigInvPaymentDO.Update_InvPaymentSeries(objConfigInvPayBO)
                Else
                    strResult = objConfigInvPaymentDO.Add_InvPaymentSeries(objConfigInvPayBO)
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigInvPayment", "Save_InvPaymentSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return strResult
        End Function
        Public Function DeleteInvPaymentSeries(ByVal strPrefix As String) As String()
            Dim strResult As String = ""
            Dim strArray As Array
            Dim strError As String
            Dim strRecordsDeleted As String = ""
            Dim strRecordsNotDeleted As String = ""
            Try
                strResult = objConfigInvPaymentDO.Delete_InvSeries(strPrefix)
                strArray = strResult.Split(",")
                strError = strArray(0)
                strRecordsDeleted = CStr(strArray(1))
                strRecordsNotDeleted = CStr(strArray(2))

                If strRecordsDeleted <> "" Then
                    strArray(0) = "DEL"
                    strArray(1) = objErrHandle.GetErrorDescParameter("DDEL", strRecordsDeleted)
                End If

                If strRecordsNotDeleted <> "" Then
                    strArray(0) = "NDEL"
                    strArray(1) = objErrHandle.GetErrorDesc("UNDEL")
                End If

            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "Services.ConfigInvPayment", "DeleteInvPaymentSeries", ex.Message, HttpContext.Current.Session("UserID"))
            End Try
            Return strArray
        End Function

    End Class
End Namespace




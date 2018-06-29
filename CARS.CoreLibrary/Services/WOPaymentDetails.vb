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
Imports System.Data.Common
Imports System.Math
Imports System.Globalization
Public Class WOPaymentDetails
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objWOPayBO As New WOPaymentDetailBO
    Shared objWOPayDO As New CARS.WOPaymentDetailDO.WOPaymentDetailDO
    Shared objCommonUtil As New CARS.Utilities.CommonUtility
    Public Function Load_PaymentDetails(objWOPayBO) As List(Of WOPaymentDetailBO)
        Dim details As New List(Of WOPaymentDetailBO)()
        Dim dsWOPayDetails As New DataSet
        Dim dtWOPayDetails As New DataTable
        HttpContext.Current.Session("STATUS") = Nothing
        Try
            dsWOPayDetails = objWOPayDO.Load_PaymentDetails(objWOPayBO)
            If dsWOPayDetails.Tables.Count > 0 Then
                If dsWOPayDetails.Tables(0).Rows.Count > 0 Then
                    dtWOPayDetails = dsWOPayDetails.Tables(0)
                    For Each dtrow As DataRow In dtWOPayDetails.Rows
                        Dim woPayDet As New WOPaymentDetailBO()
                        woPayDet.Job_No = dtrow("JOB NO")
                        woPayDet.Id_Debitor = dtrow("DEBITOR ID")
                        woPayDet.Debitor_Name = dtrow("DEBITOR NAME")
                        woPayDet.Tot_GM_Amt = dtrow("GARAGE AMOUNT")
                        woPayDet.Tot_Lab_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("LABOUR AMOUNT")) = True, "", dtrow("LABOUR AMOUNT")))
                        woPayDet.Tot_Spare_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("SPARE AMOUNT")) = True, "", dtrow("SPARE AMOUNT")))
                        woPayDet.ToT_Disc_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("DISCOUNT AMT")) = True, "", dtrow("DISCOUNT AMT")))
                        woPayDet.Tot_Amount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("TOTAL AMOUNT")) = True, "", dtrow("TOTAL AMOUNT")))
                        woPayDet.Own_Risk_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("OWN RISK AMT")) = True, "", dtrow("OWN RISK AMT")))
                        woPayDet.Tot_Vat_Amt = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("VAT AMOUNT")) = True, "", dtrow("VAT AMOUNT")))
                        woPayDet.Tot_Net_Amount = objCommonUtil.GetCurrentLanguageNoFormat(CType(HttpContext.Current.Session("Current_Language"), String), IIf(IsDBNull(dtrow("NET AMOUNT")) = True, "", dtrow("NET AMOUNT")))
                        woPayDet.Job_Status = dtrow("STATUS_JOB")
                        woPayDet.IdWODetSeq = dtrow("ID_WODET_SEQ")
                        woPayDet.FlgBatch = dtrow("FLG_CUST_BATCHINV")
                        woPayDet.Status = dtrow("STATUS")
                        details.Add(woPayDet)
                    Next
                End If
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Services.WOPaymentDetails", "Load_PaymentDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return details.ToList
    End Function
    Public Function ReadyToInv(objWOPayBO) As String
        Dim strStatus As String
        Try
            strStatus = objWOPayDO.Update_Pay_Terms(objWOPayBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "ReadyToInv", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return strStatus
    End Function
    Public Function ReadyToWrk(objWOPayBO) As String
        Dim strStatus As String
        Try
            strStatus = objWOPayDO.Update_ReadyForWork(objWOPayBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "ReadyToWrk", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return strStatus
    End Function
    Public Function Generate_Invoices_Intermediate(ByVal InvXml As String, ByVal LoginId As String, ByVal StrInv As String) As String
        Dim strRet As String
        Try
            strRet = objWOPayDO.Generate_Invoices(InvXml, LoginId, StrInv)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Services.WOJobDetails", "Generate_Invoices_Intermediate", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
        Return strRet
    End Function
End Class

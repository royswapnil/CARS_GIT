Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Public Class frmInvEmailRpt
    Inherits System.Web.UI.Page
    Shared loginName As String
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim strscreenName As String
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmInvEmailRpt", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub

    <WebMethod()> _
    Public Shared Function LoadReport(ByVal fromDate As String, ByVal toDate As String) As String
        Dim reportRequest As String = ""
        Dim rnd As New Random()
        Dim InvEmailXML As String = String.Empty
        Try
            If toDate <> "" Then
                toDate = objCommonUtil.GetDefaultDate_MMDDYYYY(toDate)
            Else
                toDate = ""
            End If
            If fromDate <> "" Then
                fromDate = objCommonUtil.GetDefaultDate_MMDDYYYY(fromDate)
            Else
                fromDate = ""
            End If

            InvEmailXML += "<ROOT> <Parameters " _
                            + " IV_INVOICEDATE_FROM=""" + fromDate + """ " _
                            + " IV_INVOICEDATE_TO=""" + toDate + """ " _
                            + " IV_LANGUAGE=""" + ConfigurationManager.AppSettings("Language").ToString + """ " _
                            + " ID_USER=""" + HttpContext.Current.Session("UserID") + """ " _
                            + "/> </ROOT>"

            HttpContext.Current.Session("InvEmailXML") = InvEmailXML
            reportRequest = "../Reports/frmShowReports.aspx?ReportHeader=" + objCommonUtil.fnEncryptQString("InvoiceEmail") + "&Rpt=" + objCommonUtil.fnEncryptQString("InvoiceEmail") + "&scrid=" + rnd.Next().ToString()

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Reports_frmInvEmailRpt", "LoadReport", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return reportRequest
    End Function


End Class
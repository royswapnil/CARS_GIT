Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmWOPaydetails
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objWOPayServ As New WOPaymentDetails
    Shared objWOPayDetailsBO As New CARS.CoreLibrary.WOPaymentDetailBO
    Shared details As New List(Of WOPaymentDetailBO)()
    Shared objCommonUtil As New Utilities.CommonUtility
    Dim objuserper As New UserAccessPermissionsBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        If Not IsPostBack Then
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        End If
        fnRolebasedAuth()
    End Sub
    <WebMethod()> _
    Public Shared Function Fetch_PaymentDetails(ByVal idWONO As String, ByVal idWOPrefix As String) As WOPaymentDetailBO()
        Try
            objWOPayDetailsBO.Id_WO_NO = idWONO
            objWOPayDetailsBO.Id_WO_Prefix = idWOPrefix
            details = objWOPayServ.Load_PaymentDetails(objWOPayDetailsBO)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "Fetch_PaymentDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SetReadyToInv(ByVal debitorIdxmls As String, ByVal userId As String) As String
        Dim strstatus As String
        Try
            objWOPayDetailsBO.IdXml = debitorIdxmls
            objWOPayDetailsBO.LoginId = userId
            strstatus = objWOPayServ.ReadyToInv(objWOPayDetailsBO)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "SetReadyToInv", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strstatus
    End Function
    <WebMethod()> _
    Public Shared Function SetReadyToWrk(ByVal debitorIdxmls As String, ByVal userId As String) As String
        Dim strstatus As String
        Try
            objWOPayDetailsBO.IdXml = debitorIdxmls
            objWOPayDetailsBO.LoginId = userId
            strstatus = objWOPayServ.ReadyToWrk(objWOPayDetailsBO)

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "SetReadyToWrk", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strstatus
    End Function
    <WebMethod()> _
    Public Shared Function InvBasis(ByVal invoiceListXMLs As String) As String
        Dim strstatus As String
        Try
            HttpContext.Current.Session("InvListXML") = invoiceListXMLs

        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "Fetch_PaymentDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strstatus
    End Function
    Private Sub btnPickingList_ServerClick(sender As Object, e As EventArgs) Handles btnPickingList.ServerClick
        Try
            Dim rnd As New Random
            Dim orderType As String = "ORDER"
            HttpContext.Current.Session("WOHeadPickingList") = Nothing

            Dim strScript As String = "var windowPickingRpt =window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("WOHEADPICKINGLIST") + "&Rpt=" + fnEncryptQString("WOHEADPICKINGLIST") + "&OrderType=" + fnEncryptQString(orderType) + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');windowPickingRpt.focus();"
            ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "btnPickingList_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub btnInvBasis_ServerClick(sender As Object, e As EventArgs) Handles btnInvBasis.ServerClick
        Try
            Dim rnd As New Random
            HttpContext.Current.Session("RptType") = "INVOICEBASIS"
            HttpContext.Current.Session("InvListXML") = "<ROOT>" + HttpContext.Current.Session("InvListXML") + "</ROOT>"
            HttpContext.Current.Session("xmlInvNos") = HttpContext.Current.Session("InvListXML")

            Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("Invoice Basis") + "&InvoiceType=" + fnEncryptQString("INVOICEBASIS") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
            ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "btnInvBasis_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Sub btnINVMain_ServerClick(sender As Object, e As EventArgs) Handles btnINVMain.ServerClick
        Try
            Dim rnd As New Random
            Dim strXml As String = HttpContext.Current.Session("InvListXML")
            strXml = strXml.Replace("/>", " IV_DATE =""""/>")
            HttpContext.Current.Session("RptType") = "INVOICE"
            HttpContext.Current.Session("InvListXML") = "<ROOT>" + strXml + "</ROOT>"
            'HttpContext.Current.Session("xmlInvNos") = HttpContext.Current.Session("InvListXML")
            Dim strRetValue As String
            Dim strInvLstXml As String = ""
            strRetValue = objWOPayServ.Generate_Invoices_Intermediate(HttpContext.Current.Session("InvListXML"), loginName, strInvLstXml)
            If strRetValue = "OFL" Then
            ElseIf strRetValue = "NOCONFIG" Then
            ElseIf strRetValue = "INVWRNPAY" Then
            ElseIf strRetValue <> "0" And strRetValue <> "WARN" And strRetValue <> "INVOICED" Then
            Else
               
                strInvLstXml = System.Web.HttpContext.Current.Session("strinvListXml").ToString
                strInvLstXml = strInvLstXml.Replace("INVNO", "ID_INV_NO")
                HttpContext.Current.Session("xmlInvNos") = strInvLstXml
                Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("Invoice") + "&InvoiceType=" + fnEncryptQString("INVOICE") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
                ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
            End If
            
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "btnINVMain_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Function fnEncryptQString(ByVal strEncrypted As String) As String
        'Encryption
        Dim objEncryption As New Encryption64
        If strEncrypted Is Nothing Then Return ""
        Return objEncryption.Encrypt(strEncrypted, ConfigurationManager.AppSettings.Get("encKey"))
    End Function
    Private Sub btnJobCard_ServerClick(sender As Object, e As EventArgs) Handles btnJobCard.ServerClick
        Try
            Dim rnd As New Random
            If Not HttpContext.Current.Session("WONO") Is Nothing Then
                Dim strJobCardSettings As String = "1"
                Dim sWOXML As String = String.Empty
                If Not IsDBNull(Session("WONO")) And Not IsDBNull(Session("WOPR")) Then
                    sWOXML = "<ROOT><WONOPREFIX  ID_WO_PREFIX='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + "'  ID_WO_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "'/><ID_INV_NO ID_INV_NO='" + objCommonUtil.ConvertStr(HttpContext.Current.Session("WOPR").ToString()) + objCommonUtil.ConvertStr(HttpContext.Current.Session("WONO").ToString()) + "' FLG_INVORCN='FALSE' /></ROOT>"
                End If
                If Not String.IsNullOrEmpty(sWOXML) Then
                    Session("xmlInvNos") = sWOXML
                    Session("RptType") = "WOJobCard"
                    Dim strScript As String = "var win=window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("WOJobCard") + "&InvoiceType=" + fnEncryptQString("WOJobCard") + "&Rpt=" + fnEncryptQString("INVOICEPRINT") + "&scrid=" + objCommonUtil.ConvertStr(Session("WOPR").ToString()) + objCommonUtil.ConvertStr(Session("WONO").ToString()) + "&JobCardSett=" + strJobCardSettings.ToString.Trim + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');win.focus();"
                    ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
                End If
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "btnReport_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Public Sub fnRolebasedAuth()
        Try
            Dim ds As New DataTable
            Dim str As String
            Dim objLoginBo As New LoginBO
            ds = Session("UserPageperDT")
            If Not ds Is Nothing Then
                str = "/Transactions/frmWOPaydetails.aspx" 'Request.Url.AbsolutePath
                'str = str.Substring((Application("AppPath")).ToString().Length)
                objuserper = commonUtil.GetUserScrPer(ds, str)
                If Not objuserper Is Nothing Then
                    If objuserper.PF_ACC_VIEW = True Then
                        btnINVMain.Disabled = IIf(objuserper.PF_ACC_PRINT = True, False, True)
                        btnRINV.Disabled = IIf(objuserper.PF_ACC_ADD = True, False, True)
                        btnAddJob.Disabled = IIf(objuserper.PF_ACC_ADD = True, False, True)
                        btnJobCard.Disabled = IIf(objuserper.PF_ACC_PRINT = True, False, True)
                        btnInvBasis.Disabled = IIf(objuserper.PF_ACC_PRINT = True, False, True)
                        btnPickingList.Disabled = IIf(objuserper.PF_ACC_PRINT = True, False, True)
                        btnRwrk.Disabled = IIf(objuserper.PF_ACC_ADD = True, False, True)
                    End If
                End If
            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Transactions_frmWOPaydetails", "fnRolebasedAuth", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("UserId"))
        End Try
    End Sub
End Class
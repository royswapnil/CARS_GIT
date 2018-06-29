Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption

Public Class frmCfInvPayment
    Inherits System.Web.UI.Page
    Shared objConfigInvPayBO As New ConfigInvPaymentBO
    Shared objConfigInvPayDO As New ConfigInvPayment.ConfigInvPaymentDO
    Shared objConfigInvPayServ As New Services.ConfigInvPayment.InvoicePaymentSeries
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigInvPaymentBO)()
    Dim objuserper As New UserAccessPermissionsBO

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvPayment", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try

    End Sub
    <WebMethod()> _
    Public Shared Function LoadInvPaymentSeries(ByVal strInvPrefix As String) As ConfigInvPaymentBO()
        Try
            details = objConfigInvPayServ.FetchAllInvSeries(strInvPrefix)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvPayment", "LoadInvPaymentSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetInvPaymentSeries(ByVal idInvSeries As String) As ConfigInvPaymentBO()
        Try
            details = objConfigInvPayServ.GetInvSeries(idInvSeries)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvPayment", "GetInvPaymentSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function DeleteInvPaymentSeries(ByVal invSeriesxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objConfigInvPayServ.DeleteInvPaymentSeries(invSeriesxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvPayment", "DeleteInvPaymentSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveInvPaymentSeries(ByVal invSeries As String, ByVal invPrefix As String, ByVal invDesc As String, ByVal invStartNo As String, ByVal invEndNo As String, ByVal invWarningBefore As String, ByVal textCode As String, ByVal mode As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objConfigInvPayBO.InvSeries = IIf(invSeries = "", "0", invSeries)
            objConfigInvPayBO.InvPrefix = invPrefix
            objConfigInvPayBO.InvDesc = invDesc
            objConfigInvPayBO.InvStartNo = Convert.ToInt32(invStartNo)
            objConfigInvPayBO.InvEndNo = Convert.ToInt32(invEndNo)
            objConfigInvPayBO.InvWarningBefore = Convert.ToInt32(invWarningBefore)
            objConfigInvPayBO.TextCode = textCode
            objConfigInvPayBO.CreatedBy = loginName

            strResult = objConfigInvPayServ.Save_InvPaymentSeries(objConfigInvPayBO, mode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvPayment", "SaveInvPaymentSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/master/frmCfInvPayment.aspx" 'Request.Url.AbsolutePath
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddT.Disabled = Convert.ToBoolean(IIf(btnAddT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddB.Disabled = Convert.ToBoolean(IIf(btnAddB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDeleteB.Disabled = Convert.ToBoolean(IIf(btnDeleteB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDeleteT.Disabled = Convert.ToBoolean(IIf(btnDeleteT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSave.Disabled = Convert.ToBoolean(IIf(btnSave.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                End If

            End If
        Else
        End If
    End Sub

End Class
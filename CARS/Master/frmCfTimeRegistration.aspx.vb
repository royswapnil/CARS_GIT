Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfTimeRegistration
    Inherits System.Web.UI.Page
    Shared objConfigSettingsBO As New ConfigSettingsBO
    Shared objConfigTimeRegServ As New Services.ConfigTimeRegistration.ConfigTimeRegistration
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigSettingsBO)()
    Dim objuserper As New UserAccessPermissionsBO
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)

            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            fillPercentage()
            SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadTimeRegConfig() As Collection
        Dim configDetails As New Collection
        Try
            configDetails = objConfigTimeRegServ.FetchAllTimeRegConfig()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "LoadTimeRegConfig", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return configDetails
    End Function
    <WebMethod()> _
    Public Shared Function SaveUSTime(ByVal idconfig As String, ByVal idsettings As String, ByVal desc As String, ByVal mode As String) As ConfigSettingsBO()
        Try
            Dim strXMLDoc As String = ""

            If (mode = "Add") Then
                strXMLDoc = ""
                strXMLDoc = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDoc = "<root>" + strXMLDoc + "</root>"
                details = commonUtil.AddConfigDetails(strXMLDoc)
            Else
                strXMLDoc = ""
                strXMLDoc = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idsettings + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """/>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                details = commonUtil.UpdateConfigDetails(strXMLDoc)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "SaveUSTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function Delete(ByVal xmlDoc As String) As String()
        Dim strResult As String()
        Try
            strResult = commonUtil.DeleteConfig(xmlDoc)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "DeleteUSTime", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    Private Sub fillPercentage()
        Dim i As Integer
        Try
            ddlPerComp.Items.Clear()
            For i = 0 To 100 Step 10
                ddlPerComp.Items.Add(i)
            Next
            ddlPerComp.Items.Insert(0, New ListItem(hdnSelect.Value, ""))
            ddlPerComp.SelectedIndex = 0
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "fillPercentage", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
            Throw ex
        End Try
    End Sub

    <WebMethod()> _
    Public Shared Function GetTimeRegDet(ByVal idConfig As String, ByVal idSettings As String) As ConfigSettingsBO()
        Try

            details = objConfigTimeRegServ.GetTimeRegDet(idConfig, idSettings)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "GetClkOutDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveClockOut(ByVal idconfig As String, ByVal idsettings As String, ByVal desc As String, ByVal trperc As String, ByVal mode As String) As ConfigSettingsBO()
        Try
            Dim strXMLDoc As String = ""

            If (mode = "Add") Then
                strXMLDoc = ""
                strXMLDoc = "<insert ID_CONFIG=""" + idconfig + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """ TR_PER=""" + trperc + """/>"
                strXMLDoc = "<root>" + strXMLDoc + "</root>"
                details = commonUtil.AddConfigDetails(strXMLDoc)
            Else
                strXMLDoc = ""
                strXMLDoc = "<MODIFY ID_CONFIG=""" + idconfig + """ ID_SETTINGS=""" + idsettings + """ DESCRIPTION=""" + desc.Trim.Replace("<", "&lt;").Replace(">", "&gt;") + """ TR_PER=""" + trperc + """/>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                details = commonUtil.UpdateConfigDetails(strXMLDoc)
            End If


        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfTimeRegistration", "SaveClockOut", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/master/frmCfTimeRegistration.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddUSTimeT.Disabled = Convert.ToBoolean(IIf(btnAddUSTimeT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddUSTimeB.Disabled = Convert.ToBoolean(IIf(btnAddUSTimeB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelUSTimeT.Disabled = Convert.ToBoolean(IIf(btnDelUSTimeT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelUSTimeB.Disabled = Convert.ToBoolean(IIf(btnDelUSTimeB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnAddClkOutT.Disabled = Convert.ToBoolean(IIf(btnAddClkOutT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddClkOutB.Disabled = Convert.ToBoolean(IIf(btnAddClkOutB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelClkOutT.Disabled = Convert.ToBoolean(IIf(btnDelClkOutT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelClkOutB.Disabled = Convert.ToBoolean(IIf(btnDelClkOutB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveClkOut.Disabled = Convert.ToBoolean(IIf(btnSaveClkOut.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveUSTime.Disabled = Convert.ToBoolean(IIf(btnSaveUSTime.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                End If
            End If
        End If
    End Sub


End Class
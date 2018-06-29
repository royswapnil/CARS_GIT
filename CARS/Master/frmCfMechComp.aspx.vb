Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfMechComp
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objMechCompBO As New MechCompetencyBO
    Shared objMechCompServ As New Services.MechCompetency.MechCompetency
    Shared details As New List(Of MechCompetencyBO)()
    Shared configdetails As New List(Of MechCompetencyBO)()
    Shared loginName As String
    Dim objuserper As New UserAccessPermissionsBO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared strscreenName As String = ""
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
            strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)

            SetPermission()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadCompLevel() As MechCompetencyBO()
        Dim details As New List(Of MechCompetencyBO)()
        Try
            details = objMechCompServ.FetchCompetencyLevel()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "LoadCompLevel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveCompLevel(ByVal idComp As String, ByVal idCompModify As String, ByVal compDesc As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            Dim strXMLDoc As String = ""
            If (mode = "Add") Then
                strXMLDoc = ""
                strXMLDoc = "<INSERT ID_COMPT=""" + idCompModify.ToString() + """ COMPT_DESCRIPTION=""" + compDesc.ToString() + """/>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                strRes = objMechCompServ.SaveCompetencyLevel(strXMLDoc)
            Else
                strXMLDoc = ""
                strXMLDoc = "<UPDATE ID_COMPT=""" + idComp.ToString() + """ ID_COMPT_Modify=""" + idCompModify.ToString() + """ COMPT_DESCRIPTION=""" + compDesc.ToString() + """/>"
                strXMLDoc = "<ROOT>" + strXMLDoc + "</ROOT>"
                strRes = objMechCompServ.UpdateCompetencyLevel(strXMLDoc)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "SaveCompLevel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function
    <WebMethod()> _
    Public Shared Function DeleteCompLevel(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objMechCompServ.DeleteCompetencyLevel(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "DeleteCompLevel", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function LoadMechComp() As MechCompetencyBO()
        Dim details As New List(Of MechCompetencyBO)()
        Try
            details = objMechCompServ.FetchMechCompetency()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "LoadMechComp", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadPCCompCode() As Collection
        Dim details As New Collection
        Try
            details = objMechCompServ.FetchPCCompCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "LoadPCCompCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function GetPCCompCostDetails(ByVal mechId As String) As Collection
        Dim details As New Collection
        Try
            details = objMechCompServ.GetPCCompCostDetails(mechId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "GetPCCompCostDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function
    <WebMethod()> _
    Public Shared Function SaveMechCompMapping(ByVal xmlDoc As String) As String()
        Dim strResult As String()
        Try
            strResult = objMechCompServ.Add_MechCompMapping(xmlDoc)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "SaveMechCompMapping", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function SaveMechCostDetails(ByVal idSeq As String, ByVal mechId As String, ByVal costTime As String, ByVal costHour As String, ByVal costGarage As String) As String()
        Dim strResult As String()
        Dim xmlDoc As String
        Try
            costTime = commonUtil.ConvertStr(commonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), commonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), costTime)))
            costHour = commonUtil.ConvertStr(commonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), commonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), costHour)))
            costGarage = commonUtil.ConvertStr(commonUtil.GetDefaultNoFormat(HttpContext.Current.Session("Current_Language"), commonUtil.GetCurrentLanguageNoFormat(HttpContext.Current.Session("Current_Language"), costGarage)))

            xmlDoc = "<INSERT ID_SEQ=""" + idSeq.ToString() + """ ID_MEC=""" + mechId.ToString() + """ COST_TIME=""" + costTime.ToString() + """ COST_HOUR=""" + costHour.ToString() + """ COST_GARAGE=""" + costGarage.ToString() + """/>"
            xmlDoc = "<ROOT>" + xmlDoc + "</ROOT>"

            strResult = objMechCompServ.Add_MechCost(xmlDoc)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "SaveMechCost", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    <WebMethod()> _
    Public Shared Function DeleteMechCostDetails(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objMechCompServ.Delete_MechCost(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "DeleteMechCostDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/master/frmCfMechComp.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddCompLevelT.Disabled = Convert.ToBoolean(IIf(btnAddCompLevelT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddCompLevelB.Disabled = Convert.ToBoolean(IIf(btnAddCompLevelB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddMechCost.Disabled = Convert.ToBoolean(IIf(btnAddMechCost.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveCompLevel.Disabled = Convert.ToBoolean(IIf(btnSaveCompLevel.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveMechComp.Disabled = Convert.ToBoolean(IIf(btnSaveMechComp.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnSaveMechCost.Disabled = Convert.ToBoolean(IIf(btnSaveMechCost.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))

                    btnDelCompLevelT.Disabled = Convert.ToBoolean(IIf(btnDelCompLevelT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelCompLevelB.Disabled = Convert.ToBoolean(IIf(btnDelCompLevelB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelMechCost.Disabled = Convert.ToBoolean(IIf(btnDelMechCost.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))

                End If
            End If
        End If
    End Sub

    <WebMethod()> _
    Public Shared Function GetMechCompLevelDetails(ByVal mechComptLevelId As String) As Collection
        Dim details As New Collection
        Try
            details = objMechCompServ.GetMechCompetencyLevelDetails(mechComptLevelId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfMechComp", "GetMechCompLevelDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function

End Class
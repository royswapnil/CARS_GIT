Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfNewStation
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared dtCaption As DataTable
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared objConfigPlanningBO As New ConfigPlanningBO
    Shared objConfigPlannServ As New Services.ConfigPlanning.ConfigPlanning
    Shared details As New List(Of ConfigPlanningBO)()
    Shared configdetails As New List(Of ConfigPlanningBO)()
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
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadDepartment() As ConfigPlanningBO()
        Dim details As New List(Of ConfigPlanningBO)()
        Try
            details = objConfigPlannServ.FetchAllDepartment()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "FetchAllDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadStationTypes() As ConfigPlanningBO()
        Dim details As New List(Of ConfigPlanningBO)()
        Try
            details = objConfigPlannServ.FetchAllStationTypes()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "FetchAllDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadStations(ByVal deptId As String) As ConfigPlanningBO()
        Dim details As New List(Of ConfigPlanningBO)()
        Try
            details = objConfigPlannServ.FetchAllStations(deptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "LoadStations", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetStationDetails(ByVal idStation As String) As Collection
        Dim details As New Collection
        Try
            details = objConfigPlannServ.GetStationDetails(idStation)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "GetStationDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details
    End Function

    <WebMethod()> _
    Public Shared Function SaveStationDetails(ByVal idStation As String, ByVal stationName As String, ByVal idstationType As String, ByVal idDept As String, ByVal stationType As String, ByVal mode As String) As String()
        Dim strRes As String()
        Try
            If (mode = "Add") Then
                objConfigPlanningBO.Station_Name = stationName
                objConfigPlanningBO.Id_StationType = idstationType
                objConfigPlanningBO.Id_Dept = idDept

                strRes = objConfigPlannServ.AddNewStation(objConfigPlanningBO)
            Else
                objConfigPlanningBO.Station_Name = stationName
                objConfigPlanningBO.Id_StationType = idstationType
                objConfigPlanningBO.StationType = stationType
                objConfigPlanningBO.Id_Dept = idDept
                objConfigPlanningBO.Id_Station = idStation
                strRes = objConfigPlannServ.UpdateNewStation(objConfigPlanningBO)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "SaveStationDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

    <WebMethod()> _
    Public Shared Function DeleteStation(ByVal delxml As String) As String()
        Dim strResult As String()
        Try
            strResult = objConfigPlannServ.DeleteStationDetails(delxml)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfNewStation", "DeleteStation", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

    Private Sub SetPermission()
        Dim dt As New DataTable
        Dim str As String
        Dim objLoginBo As New LoginBO
        dt = Session("UserPageperDT")
        If Not dt Is Nothing Then
            str = "/master/frmCfNewStation.aspx" 'Request.Url.AbsolutePath frmCfRepairPackage
            objuserper = commonUtil.GetUserScrPer(dt, str)
            If Not objuserper Is Nothing Then
                If objuserper.PF_ACC_VIEW = True Then
                    btnAddStationT.Disabled = Convert.ToBoolean(IIf(btnAddStationT.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnAddStationB.Disabled = Convert.ToBoolean(IIf(btnAddStationB.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))
                    btnDelStationT.Disabled = Convert.ToBoolean(IIf(btnDelStationT.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnDelStationB.Disabled = Convert.ToBoolean(IIf(btnDelStationB.Disabled = False, IIf(objuserper.PF_ACC_DELETE = True, False, True), True))
                    btnSaveStation.Disabled = Convert.ToBoolean(IIf(btnSaveStation.Disabled = False, IIf(objuserper.PF_ACC_ADD = True, False, True), True))

                End If
            End If
        End If
    End Sub

End Class
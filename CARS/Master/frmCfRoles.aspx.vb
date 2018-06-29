Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Imports System.Xml

Public Class frmCfRoles
    Inherits System.Web.UI.Page
    Shared objConfigRoleBO As New CARS.CoreLibrary.ConfigRoleBO
    Shared objConfigSubBO As New ConfigSubsidiaryBO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared commonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigRoleBO)()
    Shared objConfigRoleServ As New Services.ConfigRole.Role
    Shared objUserService As New CARS.CoreLibrary.CARS.Services.ConfigUsers.Users
    Shared loginName As String
    Shared id_role_acc As Integer
    Shared dtCaption As DataTable
    Dim objUserPer As New UserAccessPermissionsBO
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                btnAddT.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnDeleteT.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                btnRolesAdd.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                btnRolesAddCancel.Value = dtCaption.Select("TAG='btnCancel'")(0)(1)
                btnAddScRole.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnCanscrRole.Value = dtCaption.Select("TAG='btnCancel'")(0)(1)
                btnSave.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                btnReset.Value = dtCaption.Select("TAG='btnReset'")(0)(1)
                hdnEditCap.Value = dtCaption.Select("TAG='editCap'")(0)(1)
                hdnPrint.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                hdnFlgAdmin.Value = dtCaption.Select("TAG='lblAdmin'")(0)(1)
                hdnFlgSubAdmin.Value = dtCaption.Select("TAG='lblSubAdmin'")(0)(1)
                hdnFlgDeptAdmin.Value = dtCaption.Select("TAG='lblDeptAdmin'")(0)(1)
                hdnView.Value = dtCaption.Select("TAG='lblView'")(0)(1)
                hdnCtrlName.Value = dtCaption.Select("TAG='lblCtrlName'")(0)(1)
                hdnHasAcc.Value = dtCaption.Select("TAG='lblAccess'")(0)(1)
                lblRole.Text = dtCaption.Select("TAG='lblRole'")(0)(1)
                lblSubsId.Text = dtCaption.Select("TAG='lblSub'")(0)(1)
                lblDeptId.Text = dtCaption.Select("TAG='lblDepartment'")(0)(1)
                lblStartScreen.Text = dtCaption.Select("TAG='lblStartScreen'")(0)(1)
                lblRoles.Text = dtCaption.Select("TAG='lblRoles'")(0)(1)
                aAccessRt.InnerText = dtCaption.Select("TAG='aAccessRt'")(0)(1)
                aCtrlRt.InnerText = dtCaption.Select("TAG='aCtrlRt'")(0)(1)
                header.InnerText = dtCaption.Select("TAG='lblRoles'")(0)(1)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
                Page.Title = dtCaption.Select("TAG='lblRoleDetails'")(0)(1)
                lblRoleHeader.Text = dtCaption.Select("TAG='lblRoleDetails'")(0)(1)
                ChkallList.Text = dtCaption.Select("TAG='lblchklist'")(0)(1)
                rbaddadmin.Text = dtCaption.Select("TAG='lblAdmin'")(0)(1)
                rbaddsubadmin.Text = dtCaption.Select("TAG='lblSubAdmin'")(0)(1)
                rbadddepadmin.Text = dtCaption.Select("TAG='lblDeptAdmin'")(0)(1)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function Fetch_Role(ByVal subId As String, ByVal deptId As String) As ConfigRoleBO()
        Try
            objConfigRoleBO.Id_Subsidery_Role = subId
            objConfigRoleBO.Id_Dept_Role = deptID
            details = objConfigRoleServ.Fetch_Role(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "Fetch_Role", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigSubsidiaryBO()
        Dim detailSub As New List(Of ConfigSubsidiaryBO)()
        Try
            objConfigSubBO.UserID = loginName.ToString()
            detailSub = commonUtil.FetchSubsidiary(objConfigSubBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return detailSub.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadDepartment(ByVal subId As String) As ConfigDepartmentBO()
        Dim deptDetails As New List(Of ConfigDepartmentBO)()
        Try
            objConfigDeptBO.LoginId = loginName.ToString()
            objConfigDeptBO.SubsideryId = subId
            deptDetails = objUserService.GetDepartment(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function RoleChange(ByVal roleId As String) As ConfigRoleBO()
        Dim deptDetails As New List(Of ConfigRoleBO)()
        Try
            objConfigRoleBO.Id_Role = roleId
            objConfigRoleBO.User = loginName
            deptDetails = objConfigRoleServ.RoleAccess(objConfigRoleBO)
            id_role_acc = 111111
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "RoleChange", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function ControlDet(ByVal roleId As String) As ConfigRoleBO()
        Dim deptDetails As New List(Of ConfigRoleBO)()
        Try
            objConfigRoleBO.Id_Role = roleId
            objConfigRoleBO.User = loginName
            deptDetails = objConfigRoleServ.ControlAccess(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "ControlDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetCheckBoxDetails(ByVal roleId As String) As ConfigRoleBO()
        Dim deptDetails As New List(Of ConfigRoleBO)()
        Try
            objConfigRoleBO.Id_Role = roleId
            objConfigRoleBO.User = loginName
            deptDetails = objConfigRoleServ.CheckBoxDetails(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "ControlDet", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadScreens() As ConfigRoleBO()
        Dim deptDetails As New List(Of ConfigRoleBO)()
        Try
            deptDetails = objConfigRoleServ.FetchAllScreens(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveRoleDetails(ByVal roleId As String, ByVal roleNm As String, ByVal subId As String, ByVal deptId As String, ByVal startScrRoleId As String, ByVal flgSysAdmin As String, ByVal flgSubAdmin As String, ByVal flgDeptAdmin As String, ByVal mode As String) As String
        Dim strResult As String = ""
        Try
            objConfigRoleBO.Id_Role = roleId
            objConfigRoleBO.Nm_Role = roleNm
            objConfigRoleBO.Id_Subsidery_Role = subId
            objConfigRoleBO.Id_Dept_Role = deptId
            objConfigRoleBO.Id_Scr_Start_Role = startScrRoleId
            objConfigRoleBO.Flg_Sysadmin = flgSysAdmin
            objConfigRoleBO.Flg_Subsidadmin = flgSubAdmin
            objConfigRoleBO.Flg_Deptadmin = flgDeptAdmin
            objConfigRoleBO.Created_By = loginName
            strResult = objConfigRoleServ.SaveRoleDetails(objConfigRoleBO, mode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "SaveRoleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function AddScRoleDetails(ByVal scrXml As String, ByVal roleId As String) As ConfigRoleBO()
        Dim roleDetails As New List(Of ConfigRoleBO)()
        Try
            Dim dsRoles As DataSet
            Dim dtRoles As DataTable
            Dim dr As DataRow
            dsRoles = HttpContext.Current.Session("dvRoleDet")
            dtRoles = dsRoles.Tables(0)
            Dim xmldoc As New XmlDocument()
            xmldoc.LoadXml(scrXml)
            Dim nodes As XmlNodeList = xmldoc.DocumentElement.SelectNodes("/Root/Master")
            'Dim id_role_acc As Integer = 111111 'check

            For Each node As XmlNode In nodes
                dr = dtRoles.NewRow()
                dr("ID_ACCESS_NO") = id_role_acc
                dr("ID_SCR_UTIL") = node.Item("ScrId").InnerText
                dr("NAME_SCR") = node.Item("ScrName").InnerText
                dr("ACC_READ") = 1
                dr("ACC_WRITE") = 1
                dr("ACC_CREATE") = 1
                dr("ACC_PRINT") = 1
                dr("ACC_DELETE") = 1
                dr("ID_ROLE_ACCESS") = roleId
                dtRoles.Rows.Add(dr)
                id_role_acc = id_role_acc + 1
            Next
            dtRoles.AcceptChanges()

            For Each dtrow As DataRow In dtRoles.Rows
                Dim roleAcc As New ConfigRoleBO()
                roleAcc.IdScreen = dtrow("ID_SCR_UTIL").ToString()
                roleAcc.ScrnName = dtrow("NAME_SCR").ToString()
                roleAcc.Flg_Acc_Read = dtrow("ACC_READ").ToString()
                roleAcc.Flg_Acc_Write = dtrow("ACC_WRITE").ToString()
                roleAcc.Flg_Acc_Create = dtrow("ACC_CREATE").ToString()
                roleAcc.Flg_Acc_Print = dtrow("ACC_PRINT").ToString()
                roleAcc.Flg_Acc_Delete = dtrow("ACC_DELETE").ToString()
                roleDetails.Add(roleAcc)
            Next
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "AddScRoleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return roleDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FinalSaveRole(ByVal roleXml As String, ByVal roleId As String) As String
        Dim strResult As String = ""
        Try
            objConfigRoleBO.Scrlroleupdate = roleXml
            objConfigRoleBO.Id_Role = roleId
            objConfigRoleBO.Created_By = loginName
            strResult = objConfigRoleServ.FinalSaveRole(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "SaveRoleDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteRole(ByVal roleIdxmls As String) As String()
        Dim strResult As String()
        Try
            objConfigRoleBO.StrDelRole = roleIdxmls.ToString
            strResult = objConfigRoleServ.RemoveRole(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfRoles", "DeleteRoles", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
End Class
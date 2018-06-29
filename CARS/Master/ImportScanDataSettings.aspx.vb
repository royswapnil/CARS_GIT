Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Public Class ImportScanDataSettings
    Inherits System.Web.UI.Page
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptServ As New Services.ConfigDepartment.Department
    Shared loginName As String
    Shared commonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigDepartmentBO)()
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_ImportScanDataSettings", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function FetchAllDepartments() As ConfigDepartmentBO()
        Try
            objConfigDeptBO.LoginId = loginName.ToString
            details = commonUtil.FetchAllDepartment(objConfigDeptBO) 'objConfigDeptServ.FetchAllDepartments(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "FetchAllDepartments", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadScanDataSettings(ByVal deptId As String) As ConfigDepartmentBO()
        Try
            objConfigDeptBO.DeptId = deptId
            details = objConfigDeptServ.Fetch_DepartmentScanDataSettings(objConfigDeptBO) 'objConfigDeptServ.FetchAllDepartments(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "LoadScanDataSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveScanDataSettings(ByVal deptId As String, ByVal dptScanFlag As String, ByVal dptSchImportFlag As String) As String()
        Dim strRes As String()
        Try
            objConfigDeptBO.DeptId = deptId
            objConfigDeptBO.Dpt_ScanFlg = dptScanFlag
            objConfigDeptBO.Dpt_Sch_ImportFlag = dptSchImportFlag
            objConfigDeptBO.CreatedBy = loginName
            strRes = objConfigDeptServ.Save_ImportScanDataSettings(objConfigDeptBO)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "SaveScanDataSettings", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strRes
    End Function

End Class
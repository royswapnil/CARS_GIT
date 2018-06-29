Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI

Public Class Config_DeptWarehouseConn
    Inherits System.Web.UI.Page
    Shared objConfigDeptWhBO As New ConfigDeptWarehouseBO
    Shared objConfigDeptWhDO As New ConfigDeptWarehouseDO.ConfigDeptWarehouseDO
    Shared objConfigDeptWhServ As New Services.ConfigDeptWarehouse.ConfigDeptWarehouse
    Shared objZipCodeBO As New ZipCodesBO
    Shared objZipCodeDO As New ZipCodes.ZipCodesDO
    Shared loginName As String
    Shared commonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigDeptWarehouseBO)()
    Shared objConfigDeptServ As New Services.ConfigDepartment.Department
    Shared dtCaption As DataTable
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
        dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
        hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
    End Sub
    <WebMethod()> _
    Public Shared Function LoadChkboxList() As ConfigDeptWarehouseBO()
        Try
            details = objConfigDeptWhServ.GetDeptWarehouse(loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_DeptWarehouse", "LoadChkboxList", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadDepartment() As ConfigDeptWarehouseBO()
        Try
            details = objConfigDeptWhServ.LoadDepartment()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_DeptWarehouse", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadGridDetails() As ConfigDeptWarehouseBO()
        Try
            details = objConfigDeptWhServ.LoadDeptWarehouseDet(loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_DeptWarehouse", "LoadGridDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function EditConnDeptWarehouse(ByVal deptId As String) As Collection
        Dim dtConfig As New Collection
        Try
            dtConfig = objConfigDeptWhServ.GetEditConnDeptWh(deptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_DeptWarehouse", "EditLoadWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return dtConfig
    End Function
    <WebMethod()> _
    Public Shared Function SaveDeptWarehouse(ByVal DepartmentId As String, ByVal WarehouseValue As String, ByVal mode As String) As String

        Dim strResult As String = ""
        Try

            objConfigDeptWhBO.DepartmentId = DepartmentId
            objConfigDeptWhBO.WareHouseValue = WarehouseValue
            objConfigDeptWhBO.ModifiedBy = loginName
            strResult = objConfigDeptWhServ.SaveDeptWarehouse(objConfigDeptWhBO, mode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "SaveDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
End Class
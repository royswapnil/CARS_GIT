Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI
Public Class Config_Warehouse
    Inherits System.Web.UI.Page
    Shared objConfigWHBO As New ConfigWarehouseBO
    Shared objConfigWHDO As New ConfigWarehouse.ConfigWarehouseDO
    Shared objConfigWHServ As New Services.ConfigWarehouse.ConfigWarehouse
    Shared objZipCodeBO As New ZipCodesBO
    Shared objZipCodeDO As New ZipCodes.ZipCodesDO
    Shared loginName As String
    Shared commonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigWarehouseBO)()
    Shared objConfigDeptServ As New Services.ConfigDepartment.Department
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared detailsub As New List(Of ConfigDepartmentBO)()
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
        'ddlSubsidiaryName.Items.Clear()
        'ddlSubsidiaryName.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
        'ddlSubsidiaryName.AppendDataBoundItems = True
        hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
    End Sub
    <WebMethod()> _
    Public Shared Function LoadWarehouseDetails() As ConfigWarehouseBO()
        Try
            details = objConfigWHServ.GetWarehouseDetails(loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_Warehouse", "LoadWarehouseDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function EditLoadWarehouse(ByVal whId As String) As ConfigWarehouseBO()
        Try
            details = objConfigWHServ.GetEditWarehouse(whId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_Warehouse", "EditLoadWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigWarehouseBO()
        Try
            objConfigWHBO.WarehouseCreatedBy = loginName.ToString
            details = objConfigWHServ.LoadSubsidiaries(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_Config_Warehouse", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveWarehouse(ByVal WarehouseID As String, ByVal WarehouseName As String, ByVal WarehouseManagerName As String, ByVal WarehouseLocation As String, ByVal WarehousePhone As String, ByVal WarehousePhoneMobile As String, ByVal WarehouseZipcode As String, _
                                          ByVal WarehouseCountry As String, ByVal WarehouseCity As String, ByVal WarehouseState As String, ByVal WarehouseAddress1 As String, ByVal WarehouseAddress2 As String, ByVal WarehouseIDSubsidery As String, ByVal mode As String) As String

        Dim strResult As String = ""
        Try
            If mode = "Edit" Then
                objConfigWHBO.WarehouseID = WarehouseID
            End If
            objConfigWHBO.WarehouseName = IIf(WarehouseName = Nothing, Nothing, WarehouseName)
            objConfigWHBO.WarehouseManagerName = IIf(WarehouseManagerName = Nothing, Nothing, WarehouseManagerName)
            objConfigWHBO.WarehouseLocation = IIf(WarehouseLocation = Nothing, Nothing, WarehouseLocation)
            objConfigWHBO.WarehousePhone = IIf(WarehousePhone = Nothing, Nothing, WarehousePhone)
            objConfigWHBO.WarehousePhoneMobile = IIf(WarehousePhoneMobile = Nothing, Nothing, WarehousePhoneMobile)
            objConfigWHBO.WarehouseZipcode = WarehouseZipcode
            objConfigWHBO.WarehouseCountry = WarehouseCountry
            objConfigWHBO.WarehouseCity = WarehouseCity
            objConfigWHBO.WarehouseState = WarehouseState
            objConfigWHBO.WarehouseAddress1 = WarehouseAddress1
            objConfigWHBO.WarehouseAddress2 = WarehouseAddress2
            objConfigWHBO.WarehouseIDSubsidery = WarehouseIDSubsidery
            objConfigWHBO.WarehouseCreatedBy = loginName
            'objConfigDeptBO.IdItemCatg = IIf(deptItemCat = "null", "", deptItemCat)
            'objConfigDeptBO.RPIdMake = IIf(deptRPIdMake = "null", "", deptRPIdMake)
            'objConfigDeptBO.RPIdItemCatg = IIf(deptRPItemCat = "null", "", deptRPItemCat)
            'objConfigDeptBO.FlgAccValReq = deptFlgAccVal
            'objConfigDeptBO.FlgExportSupplier = deptFlgExpSupp
            'If (deptZipCode = "") Then
            '    objConfigDeptBO.ZipCode = Nothing
            'Else
            '    objZipCodeBO.ZipCode = deptZipCode
            '    objZipCodeBO.Country = deptZipCOuntry
            '    objZipCodeBO.State = deptZipState
            '    objZipCodeBO.City = deptZipCity
            '    objZipCodeBO.CreatedBy = loginName
            '    dsReturnValStr = objZipCodeDO.Add_ZipCode(objZipCodeBO)
            '    objConfigDeptBO.ZipCode = deptZipCode
            'End If

            'objConfigDeptBO.OwnRiskAcctCode = deptOwnRiskAcctCode
            'objConfigDeptBO.FlgLunchWithdraw = deptFlgLnWithdraw
            'objConfigDeptBO.FromTime = deptFromTime
            'objConfigDeptBO.ToTime = deptTotime
            'objConfigDeptBO.TempCode = IIf(deptTempCode = "null", "", deptTempCode)
            'objConfigDeptBO.CreatedBy = loginName
            strResult = objConfigWHServ.SaveWarehouse(objConfigWHBO, mode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "SaveDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteWarehouse(ByVal whId As String) As String
        Dim strVal As String = ""
        Try

            objConfigWHBO.WarehouseID = whId
            strVal = objConfigWHServ.DeleteWarehouse(whId)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "DeleteWarehouse", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strVal
    End Function
End Class
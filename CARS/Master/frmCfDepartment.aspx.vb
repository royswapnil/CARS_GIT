Imports System.Data
Imports Encryption
Imports MSGCOMMON
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS
Imports CARS.CoreLibrary
Imports System.Web.UI

Public Class frmCfDepartment
    Inherits System.Web.UI.Page
    Shared dtSubDetails As New DataTable()
    Shared dsSubDetails As New DataSet
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptServ As New Services.ConfigDepartment.Department
    Shared objZipCodeBO As New ZipCodesBO
    Shared objZipCodeDO As New ZipCodes.ZipCodesDO
    Shared loginName As String
    Shared commonUtil As New Utilities.CommonUtility
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigDepartmentBO)()
    Shared detMake As New List(Of ConfigDepartmentBO)()
    Shared dtCaption As DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            Dim strscreenName As String
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                header.InnerText = dtCaption.Select("TAG='lblDeptHeader'")(0)(1)
                btnAddT.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnAddB.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnDeleteB.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                btnDeleteT.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                lblAddrLine1.Text = dtCaption.Select("TAG='lblAddrLine1'")(0)(1)
                lblAddrLine2.Text = dtCaption.Select("TAG='lblAddrLine2'")(0)(1)
                lblCity.Text = dtCaption.Select("TAG='lblCity'")(0)(1)
                lblCountry.Text = dtCaption.Select("TAG='lblCountry'")(0)(1)
                lblMobileNo.Text = dtCaption.Select("TAG='lblMobileNo'")(0)(1)
                lblState.Text = dtCaption.Select("TAG='lblState'")(0)(1)
                lblSubsidiaryID.Text = dtCaption.Select("TAG='lblSubsidiaryID'")(0)(1)
                lblZipCode.Text = dtCaption.Select("TAG='lblZipCode'")(0)(1)
                lblTele.Text = dtCaption.Select("TAG='lblTele'")(0)(1)
                lblDeptHeader.Text = dtCaption.Select("TAG='lblDeptHeader'")(0)(1)
                lblDepartmentID.Text = dtCaption.Select("TAG='lblDepartmentID'")(0)(1)
                lblDepartmentName.Text = dtCaption.Select("TAG='lblDepartmentName'")(0)(1)
                lblDepartmentManager.Text = dtCaption.Select("TAG='lblDepartmentManager'")(0)(1)
                lblIsWareHouse.Text = dtCaption.Select("TAG='lblIsWareHouse'")(0)(1)
                lblValAccount.Text = dtCaption.Select("TAG='lblValAccount'")(0)(1)
                lblLocation.Text = dtCaption.Select("TAG='lblLocation'")(0)(1)
                lblExportSupplier.Text = dtCaption.Select("TAG='lblExportSupplier'")(0)(1)
                lblUseIntCustRuleExprt.Text = dtCaption.Select("TAG='lblUseIntCustRuleExprt'")(0)(1)
                lblLunchWithdraw.Text = dtCaption.Select("TAG='lblLunchWithdraw'")(0)(1)
                lblFromTime.Text = dtCaption.Select("TAG='lblFromTime'")(0)(1)
                lblTotime.Text = dtCaption.Select("TAG='lblTotime'")(0)(1)
                lblTempCode.Text = dtCaption.Select("TAG='lblTempCode'")(0)(1)
                lblDeptAccCode.Text = dtCaption.Select("TAG='lblDeptAccCode'")(0)(1)
                lblDiscountCode.Text = dtCaption.Select("TAG='lblDiscountCode'")(0)(1)
                lblOwnRiskAcCode.Text = dtCaption.Select("TAG='lblOwnRiskAcCode'")(0)(1)
                lblMake.Text = dtCaption.Select("TAG='lblMake'")(0)(1)
                lblItemCatg.Text = dtCaption.Select("TAG='lblItemCatg'")(0)(1)
                btnReset.Value = dtCaption.Select("TAG='btnReset'")(0)(1)
                btnSave.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                hdnEditCap.Value = dtCaption.Select("TAG='editCap'")(0)(1)
                aAddrComm.InnerText = dtCaption.Select("TAG='addrComm'")(0)(1)
                aOwnRisk.InnerText = dtCaption.Select("TAG='aOwnRisk'")(0)(1)
                drpMakeCode.Items.Clear()
                drpMakeCode.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpMakeCode.AppendDataBoundItems = True

                drpCategory.Items.Clear()
                drpCategory.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpCategory.AppendDataBoundItems = True

                drpDiscCode.Items.Clear()
                drpDiscCode.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpDiscCode.AppendDataBoundItems = True

                drpSubsidiary.Items.Clear()
                drpSubsidiary.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpSubsidiary.AppendDataBoundItems = True

                drpTempCode.Items.Clear()
                drpTempCode.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpTempCode.AppendDataBoundItems = True

                drpRPCategory.Items.Clear()
                drpRPCategory.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpRPCategory.AppendDataBoundItems = True

                drpRPMake.Items.Clear()
                drpRPMake.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                drpRPMake.AppendDataBoundItems = True

                hdnIsWH.Value = dtCaption.Select("TAG='hdnIsWH'")(0)(1)
                hdnSub.Value = dtCaption.Select("TAG='hdnSub'")(0)(1)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
                Page.Title = dtCaption.Select("TAG='lblDeptHeader'")(0)(1)
                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)

                rdbLstAccount.Items(0).Text = dtCaption.Select("TAG='rdbYes'")(0)(1)
                rdbLstAccount.Items(1).Text = dtCaption.Select("TAG='rdbNo'")(0)(1)
                rdbLstAccount.Items(0).Selected = True

                rdbLstExportSupplier.Items(0).Text = dtCaption.Select("TAG='rdbYes'")(0)(1)
                rdbLstExportSupplier.Items(1).Text = dtCaption.Select("TAG='rdbNo'")(0)(1)
                rdbLstExportSupplier.Items(0).Selected = True
                btnPrintT.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                btnPrintB.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                lblRPMake.Text = dtCaption.Select("TAG='lblMake'")(0)(1)
                lblRPCategory.Text = dtCaption.Select("TAG='lblItemCatg'")(0)(1)
                aRpGm.InnerText = dtCaption.Select("TAG='aRpGm'")(0)(1)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
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
    Public Shared Function FetchDepartment(ByVal deptID As String) As ConfigDepartmentBO()
        Try
            details = objConfigDeptServ.FetchDepartment(deptID)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "FetchDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchCategory(ByVal makeF As String, ByVal makeT As String, ByVal filter As String) As ConfigDepartmentBO()
        Try
            objConfigDeptBO.Filter = "N"
            details = objConfigDeptServ.GetSPRCategory(makeF, makeT, filter)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "FetchCategory", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function MakeDropdown() As ConfigDepartmentBO()
        Try
            detMake = objConfigDeptServ.FetchVehicleConfig()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "MakeDropdown", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return detMake.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchRPCategory(ByVal makeF As String, ByVal makeT As String, ByVal filter As String) As ConfigDepartmentBO()
        Try
            objConfigDeptBO.Filter = "N"
            details = objConfigDeptServ.GetSPRCategory(makeF, makeT, filter)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "FetchRPCategory", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchTemplateCode() As ConfigDepartmentBO()
        Try
            details = objConfigDeptServ.LoadTemplateCode()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "FetchTemplateCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchDiscCode() As ConfigDepartmentBO()
        Try
            details = objConfigDeptServ.GetDisListData()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "FetchDiscCode", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigDepartmentBO()
        Try
            objConfigDeptBO.LoginId = loginName.ToString
            details = objConfigDeptServ.LoadSubsidiaries(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveDepartment(ByVal deptId As String, ByVal deptName As String, ByVal deptMgr As String, ByVal subId As String, ByVal deptAddrL1 As String, ByVal deptAddrL2 As String, _
                                          ByVal deptTele As String, ByVal deptMobile As String, ByVal deptLoc As String, ByVal deptAcctCode As String, ByVal deptDsicCode As String, ByVal deptFlgWh As String, ByVal deptIdMake As String, ByVal deptItemCat As String, _
                                          ByVal deptRPIdMake As String, ByVal deptRPItemCat As String, ByVal deptFlgAccVal As String, ByVal deptFlgExpSupp As String, ByVal deptZipCode As String, ByVal deptZipCOuntry As String, ByVal deptZipState As String, ByVal deptZipCity As String, ByVal deptOwnRiskAcctCode As String, ByVal deptFlgLnWithdraw As String, ByVal deptFromTime As String, ByVal deptTotime As String, ByVal deptTempCode As String, ByVal mode As String) As String

        Dim strResult As String = ""
        Try

            Dim dsReturnValStr As String
            objConfigDeptBO.DeptId = IIf(IsDBNull(deptId) = True, "", deptId)
            objConfigDeptBO.SubsideryId = subId
            objConfigDeptBO.DeptName = deptName
            objConfigDeptBO.DeptManager = deptMgr
            objConfigDeptBO.Address1 = deptAddrL1
            objConfigDeptBO.Address2 = deptAddrL2
            objConfigDeptBO.Mobile = deptMobile
            objConfigDeptBO.Phone = deptTele
            objConfigDeptBO.Location = deptLoc
            objConfigDeptBO.DeptAccountCode = deptAcctCode
            objConfigDeptBO.DiscountCode = IIf(deptDsicCode = "null", "", deptDsicCode)
            objConfigDeptBO.FlgWareHouse = deptFlgWh
            objConfigDeptBO.IdMake = IIf(deptIdMake = "null", "", deptIdMake)
            objConfigDeptBO.IdItemCatg = IIf(deptItemCat = "null", "", deptItemCat)
            objConfigDeptBO.RPIdMake = IIf(deptRPIdMake = "null", "", deptRPIdMake)
            objConfigDeptBO.RPIdItemCatg = IIf(deptRPItemCat = "null", "", deptRPItemCat)
            objConfigDeptBO.FlgAccValReq = deptFlgAccVal
            objConfigDeptBO.FlgExportSupplier = deptFlgExpSupp
            If (deptZipCode = "") Then
                objConfigDeptBO.ZipCode = Nothing
            Else
                objZipCodeBO.ZipCode = deptZipCode
                objZipCodeBO.Country = deptZipCOuntry
                objZipCodeBO.State = deptZipState
                objZipCodeBO.City = deptZipCity
                objZipCodeBO.CreatedBy = loginName
                dsReturnValStr = objZipCodeDO.Add_Zipcode(objZipCodeBO)
                objConfigDeptBO.ZipCode = deptZipCode
            End If

            objConfigDeptBO.OwnRiskAcctCode = deptOwnRiskAcctCode
            objConfigDeptBO.FlgLunchWithdraw = deptFlgLnWithdraw
            objConfigDeptBO.FromTime = deptFromTime
            objConfigDeptBO.ToTime = deptTotime
            objConfigDeptBO.TempCode = IIf(deptTempCode = "null", "", deptTempCode)
            objConfigDeptBO.CreatedBy = loginName
            strResult = objConfigDeptServ.SaveDepartment(objConfigDeptBO, mode)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "SaveDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteDepartment(ByVal deptIdxmls As String) As String()
        Dim strResult As String()
        Try
            objConfigDeptBO.DeptId = deptIdxmls.ToString()
            strResult = objConfigDeptServ.DeleteDepartment(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "DeleteDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    Private Sub btnPrintT_ServerClick(sender As Object, e As EventArgs) Handles btnPrintT.ServerClick, btnPrintB.ServerClick
        Try
            Dim rnd As New Random
            Dim strScript As String = "var windowDepartmentRpt = window.open('../Reports/frmShowReports.aspx?ReportHeader=" + fnEncryptQString("DepartmentList") + "&Rpt=" + fnEncryptQString("DepartmentList") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');windowDepartmentRpt.focus();"
            ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfDepartment", "btnPrintT_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    Private Function fnEncryptQString(ByVal strEncrypted As String) As String
        'Encryption
        Dim objEncryption As New Encryption64
        If strEncrypted Is Nothing Then Return ""
        Return objEncryption.Encrypt(strEncrypted, ConfigurationManager.AppSettings.Get("encKey"))
    End Function
End Class
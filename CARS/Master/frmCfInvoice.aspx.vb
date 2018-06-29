Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Imports System.Math
Imports Newtonsoft.Json
Imports System.Reflection
Public Class frmCfInvoice
    Inherits System.Web.UI.Page
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared dtCaption As DataTable
    Shared objcfInvSvc As New Services.ConfigInvoice.ConfigInvoice
    Shared details As New List(Of ConfigInvoiceBO)()
    Shared objCommonUtil As New Utilities.CommonUtility
    Shared objInvConfigBO As New CARS.CoreLibrary.ConfigInvoiceBO
    Shared objConfigInvDO As New ConfigInvoice.ConfigInvoiceDO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared objConfigDeptDO As New Department.ConfigDepartmentDO
    Shared objConfigDeptServ As New Services.ConfigDepartment.Department
    Shared objUserService As New CARS.CoreLibrary.CARS.Services.ConfigUsers.Users

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim strscreenName As String
        If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
            Response.Redirect("~/frmLogin.aspx")
        Else
            loginName = CType(Session("UserID"), String)
        End If
        hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
        LoadPayType()
        If Not IsPostBack Then
            dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
            hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
            Dim KIDSet As New DataSet
            KIDSet = objConfigInvDO.FetchKId()
            KIDSequenceComboFill(drpKIDCustNumOrd, KIDSet)
            KIDSequenceComboFill(drpKIDCustNumOrd, KIDSet)
            KIDSequenceComboFill(drpKIDInvNumOrd, KIDSet)
            KIDSequenceComboFill(drpKIDWONumOrd, KIDSet)
            KIDSequenceComboFill(drpKIDFixNumOrd, KIDSet)
        End If
        strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
    End Sub
    Public Sub LoadPayType()
        Dim dsPType As DataSet
        Dim cnt As Integer
        dsPType = objConfigInvDO.Fetch_New_PayType()
        cnt = dsPType.Tables(0).Rows.Count
        hdnCntPT.Value = cnt
        If dsPType.Tables(0).Rows.Count > 0 Then
            drpPayType.Visible = True
            drpPayType.DataSource = dsPType
            drpPayType.DataTextField = "DESCRIPTION"
            drpPayType.DataValueField = "ID_SETTINGS"
            drpPayType.DataBind()
        Else
            drpPayType.Visible = False
        End If
    End Sub
    <WebMethod()> _
    Public Shared Function FetchPayTypeGrid() As ConfigInvoiceBO()
        Try
            details = objcfInvSvc.FetchPayTypeForGrid()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "FetchPayTypeGrid", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchPayTypeDrpDwn() As ConfigInvoiceBO()
        Try
            Dim detailsInvPay As New List(Of ConfigInvoiceBO)()
            details = objcfInvSvc.FetchPayType()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "FetchPayTypeDrpDwn", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadInvSett(ByVal subId As String, ByVal deptId As String) As ConfigInvoiceBO()
        Try
            Dim detailsInvPay As New List(Of ConfigInvoiceBO)()
            details = objcfInvSvc.LoadInvoiceSett(subId, deptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "LoadInvSett", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigDepartmentBO()
        Dim detailsDept As New List(Of ConfigDepartmentBO)()
        Try
            objConfigDeptBO.LoginId = loginName.ToString
            detailsDept = objConfigDeptServ.LoadSubsidiaries(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return detailsDept.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadDepartment(ByVal subId As String) As ConfigDepartmentBO()
        Dim deptDetails As New List(Of ConfigDepartmentBO)()
        Try
            objConfigDeptBO.LoginId = loginName.ToString()
            objConfigDeptBO.SubsideryId = subId
            deptDetails = objUserService.GetDepartment(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function Update_Config(ByVal subId As String, ByVal deptId As String, ByVal invTimeRndUnit As String, ByVal invTimRnd As String, ByVal invTimeRndFn As String, ByVal invTimeRndPer As String, _
                                          ByVal invPrRndFn As String, ByVal invPrRndVal As String, ByVal invRndDec As String, ByVal kidFxdNum As String, ByVal kidCustNod As String, ByVal kidInvNod As String, ByVal kidWoNod As String, ByVal kidFxdNod As String, _
                                          ByVal kidCustOrd As String, ByVal kidInvOrd As String, ByVal kidWoOrd As String, ByVal kidFxdOrd As String, ByVal flgKidMod10 As String, ByVal xmlVal As String, ByVal extVatCode As String, ByVal accCode As String, ByVal flgInvFees As String, ByVal invFeesAmt As String, ByVal invFeesAccCode As String, ByVal mode As String) As String
        Dim strResult As String
        Try
            objInvConfigBO.IdSubsidery = subId
            objInvConfigBO.IdDept = deptId
            objInvConfigBO.InvTimeRndUnit = invTimeRndUnit
            objInvConfigBO.InvRndDec = invRndDec
            objInvConfigBO.InvTimeRnd = invTimRnd
            objInvConfigBO.InvTimeRndFn = invTimeRndFn
            objInvConfigBO.InvTimeRndPer = invTimeRndPer
            objInvConfigBO.InvPriceRndFn = invPrRndFn
            objInvConfigBO.InvPrRndValPer = invPrRndVal
            objInvConfigBO.KidFixedNumber = kidFxdNum
            objInvConfigBO.KidCustNod = kidCustNod
            objInvConfigBO.KidInvNod = kidInvNod
            objInvConfigBO.KidWoNod = kidWoNod
            objInvConfigBO.KidCustOrd = kidCustOrd
            objInvConfigBO.KidInvOrd = kidInvOrd
            objInvConfigBO.KidWoOrd = kidWoOrd
            objInvConfigBO.KidFixedOrd = kidFxdOrd
            objInvConfigBO.KidFixedNod = kidFxdNod
            objInvConfigBO.FlgKidMod10 = flgKidMod10
            objInvConfigBO.FlgInvFees = flgInvFees
            If (flgInvFees = "false") Then
                invFeesAmt = 0
                invFeesAccCode = ""
            End If
            objInvConfigBO.ExtVatCode = extVatCode
            objInvConfigBO.AccountCode = accCode
            objInvConfigBO.InvFeesAmt = invFeesAmt
            objInvConfigBO.InvFeesAccCode = invFeesAccCode
            objInvConfigBO.XmlVal = xmlVal
            objInvConfigBO.UserId = loginName
            If mode = "Edit" Then
                strResult = objcfInvSvc.UpdateConfig(objInvConfigBO)

            Else
                strResult = objcfInvSvc.InsertConfig(objInvConfigBO)

            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    Public Sub KIDSequenceComboFill(ByRef cmbInp As DropDownList, ByRef KID As DataSet)
        Try
            cmbInp.DataSource = KID
            cmbInp.DataTextField = "KID_Series"
            cmbInp.DataValueField = "KID_Desc"
            cmbInp.DataBind()
            cmbInp.SelectedIndex = 0
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "KIDSequenceComboFill", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadInvNumSeriesGrd(ByVal subId As String, ByVal deptId As String) As ConfigInvoiceBO()
        Try
            objInvConfigBO.IdSubsidery = subId
            objInvConfigBO.IdDept = deptId
            details = objcfInvSvc.LoadInvNumGrid(subId, deptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "LoadInvNumSeriesGrd", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadInvNoSeries(ByVal subId As String, ByVal deptId As String) As ConfigInvoiceBO()
        Try
            objInvConfigBO.IdSubsidery = subId
            objInvConfigBO.IdDept = deptId
            details = objcfInvSvc.LoadInvNumSeries(subId, deptId)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "LoadInvNoSeries", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SavePayType(ByVal subId As String, ByVal deptId As String, ByVal xml As String) As String
        Dim strResult As String
        Try
            objInvConfigBO.IdSubsidery = subId
            objInvConfigBO.IdDept = deptId
            objInvConfigBO.XmlVal = xml
            objInvConfigBO.UserId = loginName
            strResult = objcfInvSvc.Save_PType(objInvConfigBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "SavePayType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function UpdatePayType(ByVal subId As String, ByVal deptId As String, ByVal xml As String) As String
        Dim strResult As String
        Try
            objInvConfigBO.IdSubsidery = subId
            objInvConfigBO.IdDept = deptId
            objInvConfigBO.XmlVal = xml
            objInvConfigBO.UserId = loginName
            strResult = objcfInvSvc.Update_PType(objInvConfigBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfInvoice", "SavePayType", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

End Class
Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption

Public Class frmCfSubsidiary
    Inherits System.Web.UI.Page
    Shared dtSubDetails As New DataTable()
    Shared dsSubDetails As New DataSet
    Shared objConfigSubBO As New ConfigSubsidiaryBO
    Shared objConfigSubDO As New Subsidiary.ConfigSubsidiaryDO
    Shared objConfigSubServ As New Services.ConfigSubsidiary.Subsidiary
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigSubsidiaryBO)()
    Shared objZipCodeBO As New ZipCodesBO
    Shared objZipCodeDO As New ZipCodes.ZipCodesDO

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Session("UserID") Is Nothing Or Session("UserPageperDT") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If

            Dim strscreenName As String
            Dim dtCaption As DataTable
            loginName = CType(Session("UserID"), String)
            hdnPageSize.Value = System.Configuration.ConfigurationManager.AppSettings("PageSize")
            If Not IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                btnAddT.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnAddB.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnDeleteB.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                btnDeleteT.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                aheader.InnerText = dtCaption.Select("TAG='lblHead'")(0)(1)
                lblHead.Text = dtCaption.Select("TAG='lblHead'")(0)(1)
                lblAccntCode.Text = dtCaption.Select("TAG='lblAccntCode'")(0)(1)
                lblAddrLine1.Text = dtCaption.Select("TAG='lblAddrLine1'")(0)(1)
                lblAddrLine2.Text = dtCaption.Select("TAG='lblAddrLine2'")(0)(1)
                lblBankAccnt.Text = dtCaption.Select("TAG='lblBankAccnt'")(0)(1)
                lblCity.Text = dtCaption.Select("TAG='lblCity'")(0)(1)
                lblCountry.Text = dtCaption.Select("TAG='lblCountry'")(0)(1)
                lblEmail.Text = dtCaption.Select("TAG='lblEmail'")(0)(1)
                lblFaxNo.Text = dtCaption.Select("TAG='lblFaxNo'")(0)(1)
                lblIBAN.Text = dtCaption.Select("TAG='lblIBAN'")(0)(1)
                lblMobileNo.Text = dtCaption.Select("TAG='lblMobileNo'")(0)(1)
                lblOrganization.Text = dtCaption.Select("TAG='lblOrganization'")(0)(1)
                lblState.Text = dtCaption.Select("TAG='lblState'")(0)(1)
                lblSubsidiaryID.Text = dtCaption.Select("TAG='lblSubsidiaryID'")(0)(1)
                lblSubsidiaryName.Text = dtCaption.Select("TAG='lblSubsidiaryName'")(0)(1)
                lblSubsidiaryManager.Text = dtCaption.Select("TAG='lblSubsidiaryManager'")(0)(1)
                lblSwift.Text = dtCaption.Select("TAG='lblSwift'")(0)(1)
                lblZipCode.Text = dtCaption.Select("TAG='lblZipCode'")(0)(1)
                lblTele.Text = dtCaption.Select("TAG='lblTele'")(0)(1)
                lblTrasnferMethod.Text = dtCaption.Select("TAG='lblTrasnferMethod'")(0)(1)
                btnReset.Value = dtCaption.Select("TAG='btnReset'")(0)(1)
                btnSave.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                aDetails.InnerText = dtCaption.Select("TAG='Details'")(0)(1)
                aAddrComm.InnerText = dtCaption.Select("TAG='addrComm'")(0)(1)
                hdnEditCap.Value = dtCaption.Select("TAG='editCap'")(0)(1)
                btnPrintT.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                btnPrintB.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                DrpTransMethod.Items.Clear()
                DrpTransMethod.Items.Add(dtCaption.Select("TAG='select'")(0)(1))
                DrpTransMethod.AppendDataBoundItems = True
                strscreenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
                commonUtil.ddlGetValue(strscreenName, DrpTransMethod)
                lblCrtdBy.Text = dtCaption.Select("TAG='lblCrtdBy'")(0)(1)
                lblOn.Text = dtCaption.Select("TAG='lblOn'")(0)(1)
                lblLastChngBy.Text = dtCaption.Select("TAG='lblLastChngBy'")(0)(1)
                lblOn1.Text = dtCaption.Select("TAG='lblOn'")(0)(1)
                Page.Title = dtCaption.Select("TAG='lblHead'")(0)(1)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigSubsidiaryBO()
        Try
            objConfigSubBO.UserID = loginName.ToString()
            details = commonUtil.FetchSubsidiary(objConfigSubBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchSubsidiary(ByVal subID As String) As ConfigSubsidiaryBO()
        Try
            details = objConfigSubServ.GetSubsidiary(subID)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "FetchSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveSubsidiary(ByVal subId As String, ByVal subname As String, ByVal subMgr As String, ByVal subAddrL1 As String, ByVal subAddrL2 As String, ByVal subTele As String, ByVal subMobile As String, ByVal subEmail As String, ByVal subOrg As String, ByVal subFaxno As String, ByVal subIBAN As String, ByVal subSwift As String, ByVal subBankAccnt As String, ByVal subCountry As String, ByVal subState As String, ByVal subCity As String, ByVal subTransferMethod As String, ByVal subAccntCode As String, ByVal subZipCode As String, ByVal mode As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Try
            objConfigSubBO.SubsidiaryID = IIf(subId = "", "0", subId.ToString())
            objConfigSubBO.SubsidiaryName = subname.ToString()
            objConfigSubBO.SubsidiaryManager = subMgr
            objConfigSubBO.AddressLine1 = subAddrL1
            objConfigSubBO.AddressLine2 = subAddrL2
            objConfigSubBO.Telephone = subTele
            objConfigSubBO.Mobile = subMobile
            objConfigSubBO.Email = subEmail
            objConfigSubBO.Organization = subOrg
            objConfigSubBO.FaxNo = subFaxno
            objConfigSubBO.IBAN = subIBAN
            objConfigSubBO.Swift = subSwift
            objConfigSubBO.BankAccnt = subBankAccnt
            objConfigSubBO.ZipCode = subZipCode
            objConfigSubBO.TransferMethod = subTransferMethod
            objConfigSubBO.AccntCode = subAccntCode
            strResult = objConfigSubServ.SaveSubsidiary(objConfigSubBO, mode)
            If (subZipCode = "") Then
                objConfigSubBO.ZipCode = Nothing
            Else
                objZipCodeBO.ZipCode = subZipCode
                objZipCodeBO.Country = subCountry
                objZipCodeBO.State = subState
                objZipCodeBO.City = subCity
                objZipCodeBO.CreatedBy = loginName
                dsReturnValStr = objZipCodeDO.Add_Zipcode(objZipCodeBO)
                objConfigSubBO.ZipCode = subZipCode
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "SaveSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteSubsidiary(ByVal subIdxmls As String) As String()
        Dim strResult As String()
        Try
            objConfigSubBO.SubsidiaryID = subIdxmls.ToString()
            strResult = objConfigSubServ.DeleteSubsidiary(objConfigSubBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "DeleteSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function
    Private Sub btnPrintT_ServerClick(sender As Object, e As EventArgs) Handles btnPrintT.ServerClick, btnPrintB.ServerClick
        Try
            Dim rnd As New Random
            Dim strScript As String = "var windowSubsidiaryRpt = window.open('../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("SubsidiaryList") + "&Rpt=" + commonUtil.fnEncryptQString("SubsidiaryList") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');windowSubsidiaryRpt.focus();"
            ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfSubsidiary", "btnPrintT_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
   
End Class
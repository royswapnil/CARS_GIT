Imports System.Web.Services
Imports CARS.CoreLibrary
Imports CARS.CoreLibrary.CARS
Imports System.Web.Security
Imports System.Web.UI
Imports Encryption
Public Class frmCfUserdetail
    Inherits System.Web.UI.Page
    Shared dtUserDetails As New DataTable()
    Shared dsUserDetails As New DataSet
    Shared objConfigUserBO As New CARS.CoreLibrary.ConfigUsersBO
    Shared objConfigUserDO As New ConfigUsers.ConfigUsersDO
    Shared objConfigSubBO As New ConfigSubsidiaryBO
    Shared objConfigSubDO As New Subsidiary.ConfigSubsidiaryDO
    Shared objConfigDeptBO As New ConfigDepartmentBO
    Shared commonUtil As New Utilities.CommonUtility
    Shared loginName As String
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Shared details As New List(Of ConfigUsersBO)()
    Shared objUserService As New CARS.CoreLibrary.CARS.Services.ConfigUsers.Users
    Shared objRoleService As New CARS.CoreLibrary.CARS.Services.ConfigRole.Role
    Shared objConfigRoleBO As New CARS.CoreLibrary.ConfigRoleBO
    Shared objZipCodeBO As New ZipCodesBO
    Shared objZipCodeDO As New ZipCodes.ZipCodesDO
    Shared objEncryption As New Encryption64
    Shared dtCaption As DataTable

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
                btnAddB.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnAddT.Value = dtCaption.Select("TAG='btnAdd'")(0)(1)
                btnDeleteB.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                btnDeleteT.Value = dtCaption.Select("TAG='btnDelete'")(0)(1)
                aheader.InnerText = dtCaption.Select("TAG='lblHead'")(0)(1)
                lblHead.Text = dtCaption.Select("TAG='lblUserDetails'")(0)(1)
                lblDepartment.Text = dtCaption.Select("TAG='lblDepartment'")(0)(1)
                lblAddrLine1.Text = dtCaption.Select("TAG='lblAddrLine1'")(0)(1)
                lblAddrLine2.Text = dtCaption.Select("TAG='lblAddrLine2'")(0)(1)
                lblRole.Text = dtCaption.Select("TAG='lblRole'")(0)(1)
                lblCity.Text = dtCaption.Select("TAG='lblCity'")(0)(1)
                lblCountry.Text = dtCaption.Select("TAG='lblCountry'")(0)(1)
                lblEmail.Text = dtCaption.Select("TAG='lblEmail'")(0)(1)
                lblFax.Text = dtCaption.Select("TAG='lblFaxNo'")(0)(1)
                lblMobileNo.Text = dtCaption.Select("TAG='lblMobileNo'")(0)(1)
                lblState.Text = dtCaption.Select("TAG='lblState'")(0)(1)
                lblSubsidiary.Text = dtCaption.Select("TAG='lblSub'")(0)(1)
                lblZipCode.Text = dtCaption.Select("TAG='lblZipCode'")(0)(1)
                lblTelNoPerson.Text = dtCaption.Select("TAG='lblTele'")(0)(1)
                btnReset.Value = dtCaption.Select("TAG='btnReset'")(0)(1)
                btnSave.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                adetails.InnerText = dtCaption.Select("TAG='Details'")(0)(1)
                aAddrCom.InnerText = dtCaption.Select("TAG='addrComm'")(0)(1)
                hdnEditCap.Value = dtCaption.Select("TAG='editCap'")(0)(1)
                btnPrintT.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                btnPrintB.Value = dtCaption.Select("TAG='btnPrint'")(0)(1)
                lblLogin.Text = dtCaption.Select("TAG='lblLoginName'")(0)(1)
                lblUserId.Text = dtCaption.Select("TAG='lblUserId'")(0)(1)
                lblFName.Text = dtCaption.Select("TAG='lblFName'")(0)(1)
                lblLName.Text = dtCaption.Select("TAG='lblLName'")(0)(1)
                lblPassword.Text = dtCaption.Select("TAG='lblPassword'")(0)(1)
                lblMobileNo.Text = dtCaption.Select("TAG='lblMobileNo'")(0)(1)
                lblConfirm.Text = dtCaption.Select("TAG='lblConfirm'")(0)(1)
                lblLang.Text = dtCaption.Select("TAG='lblLang'")(0)(1)
                lblAutoCorrectionTime.Text = dtCaption.Select("TAG='lblAutoCorrectionTime'")(0)(1)
                lblSSN.Text = dtCaption.Select("TAG='lblSSN'")(0)(1)
                lblWorkHrsFrm.Text = dtCaption.Select("TAG='lblWorkHrsFrm'")(0)(1)
                lblWorkHrsTo.Text = dtCaption.Select("TAG='lblWorkHrsTo'")(0)(1)
                lblEAccnt.Text = dtCaption.Select("TAG='lblEAccnt'")(0)(1)
                lblWrkHrs.Text = dtCaption.Select("TAG='lblWrkHrs'")(0)(1)
                lblCommonMechId.Text = dtCaption.Select("TAG='lblCommonMechId'")(0)(1)
                cbMech.Text = dtCaption.Select("TAG='lblIsMechanic'")(0)(1)
                cbMechActive.Text = dtCaption.Select("TAG='lblInActive'")(0)(1)
                hdnSelect.Value = dtCaption.Select("TAG='select'")(0)(1)
                Page.Title = dtCaption.Select("TAG='lblUserDetails'")(0)(1)
                rdbAutoCorr.Items(0).Text = dtCaption.Select("TAG='rdbYes'")(0)(1)
                rdbAutoCorr.Items(1).Text = dtCaption.Select("TAG='rdbNo'")(0)(1)
                rdbAutoCorr.Items(0).Selected = True
            End If
            FillDefaultValues()
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function GetZipCodes(ByVal zipCode As String) As List(Of String)
        Dim retZipCodes As New List(Of String)()
        Try
            retZipCodes = commonUtil.getZipCodes(zipCode, loginName)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "GetZipCodes", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return retZipCodes
    End Function
    <WebMethod()> _
    Public Shared Function LoadUsers() As ConfigUsersBO()
        Try
            objConfigUserBO.Id_Login = loginName
            details = objUserService.FetchAllUsers(objConfigUserBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "LoadUsers", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function FetchUser(ByVal loginId As String) As ConfigUsersBO()
        Try
            objConfigUserBO.Id_Login = loginId
            details = objUserService.FetchUser(objConfigUserBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "FetchUser", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return details.ToList.ToArray()
    End Function
    Public Sub FillDefaultValues()
        Try
            Dim dsLang As New DataSet
            dsLang = commonUtil.Fetch_Config()
            If dsLang.Tables.Count > 0 Then
                'Lang dd
                If dsLang.Tables(3).Rows.Count > 0 Then
                    ddlLang.Items.Clear()
                    Dim dvLanguage As DataView
                    dvLanguage = dsLang.Tables(3).DefaultView
                    dvLanguage.Sort = "LANG_NAME"
                    ddlLang.DataSource = dvLanguage
                    ddlLang.DataTextField = "LANG_NAME"
                    ddlLang.DataValueField = "ID_LANG"
                    ddlLang.DataBind()
                    ddlLang.Items.Insert(0, New ListItem(hdnSelect.Value, ""))
                    ddlLang.SelectedIndex = 0
                Else
                    ddlLang.Items.Insert(0, New ListItem(hdnSelect.Value, ""))
                End If
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "FillDefaultValues", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function LoadSubsidiary() As ConfigSubsidiaryBO()
        Dim subDetails As New List(Of ConfigSubsidiaryBO)()
        Try
            objConfigSubBO.UserID = loginName.ToString()
            subDetails = commonUtil.FetchSubsidiary(objConfigSubBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "LoadSubsidiary", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return subDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadDepartment(ByVal subId As String) As ConfigDepartmentBO()
        Dim deptDetails As New List(Of ConfigDepartmentBO)()
        Try
            objConfigDeptBO.LoginId = loginName.ToString()
            objConfigDeptBO.SubsideryId = subId
            deptDetails = objUserService.GetDepartment(objConfigDeptBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "LoadDepartment", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadEmailAccnt(ByVal subId As String) As ConfigUsersBO()
        Dim deptDetails As New List(Of ConfigUsersBO)()
        Try
            objConfigUserBO.Id_Subsidery_User = subId
            deptDetails = objUserService.FetchEmailAcct(objConfigUserBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "LoadEmailAccnt", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return deptDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function LoadRole(ByVal subId As String, ByVal deptId As String) As ConfigRoleBO()
        Dim roleDetails As New List(Of ConfigRoleBO)()
        Try
            objConfigRoleBO.Id_Subsidery_Role = Convert.ToInt32(subId)
            objConfigRoleBO.Id_Dept_Role = Convert.ToInt32(deptId)
            roleDetails = objRoleService.Fetch_Role(objConfigRoleBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "LoadEmailAccnt", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return roleDetails.ToList.ToArray()
    End Function
    <WebMethod()> _
    Public Shared Function SaveUserDetails(ByVal subId As String, ByVal deptId As String, ByVal roleId As String, ByVal flgMech As String, ByVal flgMechInactive As String, ByVal loginName As String, _
                                          ByVal userId As String, ByVal fName As String, ByVal lName As String, ByVal pwd As String, ByVal confPwd As String, ByVal lang As String, ByVal teleNo As String, ByVal mobile As String, _
                                          ByVal fax As String, ByVal email As String, ByVal cmmid As String, ByVal autocorrection As String, ByVal ssn As String, ByVal worksfrom As String, ByVal worksto As String, ByVal emailaccnt As String, ByVal flgworkhrs As String, ByVal flgDuser As String, ByVal addrline1 As String, ByVal addrline2 As String, ByVal zipcode As String, ByVal country As String, ByVal city As String, ByVal state As String, ByVal mode As String, ByVal hdnCmid As String) As String
        Dim strResult As String = ""
        Dim dsReturnValStr As String = ""
        Dim password As String = ""
        Dim confPasswd As String = ""

        password = objEncryption.Encrypt(pwd, ConfigurationManager.AppSettings.Get("encKey"))
        confPasswd = objEncryption.Encrypt(confPwd, ConfigurationManager.AppSettings.Get("encKey"))
        Try
            objConfigUserBO.Id_Subsidery_User = IIf(subId = "", "", subId)
            objConfigUserBO.Id_Dept = IIf(deptId = "", "", deptId)
            objConfigUserBO.Id_Role_User = roleId
            objConfigUserBO.Flg_Mechanic = flgMech
            objConfigUserBO.Flg_Mech_Isactive = flgMechInactive
            objConfigUserBO.Id_Login = loginName
            objConfigUserBO.Userid = userId
            objConfigUserBO.First_Name = fName
            objConfigUserBO.Last_Name = lName
            objConfigUserBO.Password = password
            objConfigUserBO.Confirm_Password = confPasswd
            objConfigUserBO.Id_Lang = IIf(lang = "", Nothing, lang)
            objConfigUserBO.Phone = teleNo
            objConfigUserBO.Mobileno = mobile
            objConfigUserBO.Address1 = addrline1
            objConfigUserBO.Address2 = addrline2
            objConfigUserBO.Id_Zip_Users = zipcode
            objConfigUserBO.Workhrs_Frm = worksfrom
            objConfigUserBO.Workhrs_To = worksto
            objConfigUserBO.Social_Security_Num = ssn
            objConfigUserBO.Flg_Workhrs = flgworkhrs
            objConfigUserBO.Flg_Duser = flgDuser
            If (hdnCmid = "True") Then
                objConfigUserBO.Iscommon_Mechanic = True
            Else
                objConfigUserBO.Iscommon_Mechanic = False
            End If

            If (flgMech = "true") Then
                objConfigUserBO.Flg_Use_Idletime = autocorrection
                If cmmid <> "" Then
                    objConfigUserBO.Common_Mechanic_Id = cmmid
                Else
                    objConfigUserBO.Common_Mechanic_Id = Nothing
                End If
            Else
                objConfigUserBO.Flg_Use_Idletime = Nothing
                objConfigUserBO.Common_Mechanic_Id = Nothing
            End If

            objConfigUserBO.Id_Email_Acct = IIf(emailaccnt = "", Nothing, emailaccnt)
            objConfigUserBO.Id_Email = email
            objConfigUserBO.FaxNo = fax
            objConfigUserBO.Id_Country = IIf(country = "", "", country)
            objConfigUserBO.Id_State = IIf(state = "", "", state)
            objConfigUserBO.Id_City = IIf(city = "", "", city)
            objConfigUserBO.Created_By = loginName
            strResult = objUserService.SaveUserDetails(objConfigUserBO, mode)
            If (zipcode = "") Then
                objConfigUserBO.Id_Zip_Users = Nothing
            Else
                objZipCodeBO.ZipCode = zipcode
                objZipCodeBO.Country = country
                objZipCodeBO.State = state
                objZipCodeBO.City = city
                objZipCodeBO.CreatedBy = loginName
                dsReturnValStr = objZipCodeDO.Add_ZipCode(objZipCodeBO)
                objConfigUserBO.Id_Zip_Users = zipcode
            End If

        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "SaveUserDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    <WebMethod()> _
    Public Shared Function DeleteUserDetails(ByVal userid As String) As String()
        Dim strResult As String()
        Try
            objConfigUserBO.Userid = userid.ToString()
            strResult = objUserService.DeleteUserDetails(objConfigUserBO)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "DeleteUserDetails", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function
    Private Sub btnPrintT_ServerClick(sender As Object, e As EventArgs) Handles btnPrintT.ServerClick, btnPrintB.ServerClick
        Try
            Dim rnd As New Random
            Dim strScript As String = "var windowUserDetailsRpt = window.open('../Reports/frmShowReports.aspx?ReportHeader=" + commonUtil.fnEncryptQString("user details") + "&Rpt=" + commonUtil.fnEncryptQString("UserDetails") + "&scrid=" + rnd.Next().ToString() + "','Reports','menubar=no,location=no,status=no,scrollbars=yes,resizable=yes');windowUserDetailsRpt.focus();"
            ClientScript.RegisterStartupScript(Me.GetType(), "Open", strScript, True)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfUserdetail", "btnPrintT_ServerClick", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    <WebMethod()>
    Public Shared Function Pin_Switch_Check(ByVal pinFlg As Boolean, ByVal pinFetch As Boolean) As String
        Dim strResult As String
        Dim dsReturnValStr As String = ""
        Dim objPinVal As New CARS.CoreLibrary.pinSwitch
        Try
            objPinVal.flg_pin_menu = pinFlg
            objPinVal.fetch = pinFetch
        Catch ex As Exception

        End Try
        ''Dim cust As CustomerBO = JsonConvert.DeserializeObject(Of CustomerBO)(Customer)
        Try
            'cust.CUST_NAME = cust.CUST_FIRST_NAME + " " + cust.CUST_MIDDLE_NAME + " " + cust.CUST_LAST_NAME
            'Console.WriteLine(cust.CUST_FIRST_NAME)
            strResult = objUserService.SwitchPin(objPinVal)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_CfUserDetail", "pinSwitch", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return strResult
    End Function

End Class
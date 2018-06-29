Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Resources
Imports System.Reflection
Imports CARS.CoreLibrary.CARS
Imports System.Web
Imports Encryption
Imports System.Configuration
Imports System
Imports MSGCOMMON
Imports System.Web.Security

Namespace CARS.Services.Login
    Public Class Login
        Dim objUserPer As New UserAccessPermissionsBO
        Dim objUserPerDO As New UserAccessPermissions.UserAccessPermissionsDO
        Dim ObjUser As New ConfigRoleBO
        Dim ObjConfigRoleDO As New Role.ConfigRoleDO
        Dim objLoginBo As New LoginBO
        Dim objLoginDo As New CARS.Login.LoginDO
        Dim objEncryption As New Encryption64
        Dim objErrHandle As New MSGCOMMON.MsgErrorHndlr
        Dim DrUser As DataRow
        Dim dsUserDetails As DataSet
        Dim redirectUrl As String
        Shared commonUtil As New Utilities.CommonUtility

#Region "Get UserDetails"
        Public Function GetUserDetails(objLoginBo) As DataSet
            Dim dsUserDetails As DataSet
            dsUserDetails = objLoginDo.GetUserDetails(objLoginBo)
            Return dsUserDetails
        End Function
#End Region
#Region "Get string Value"
        Public Function GetStringValue(ByVal obj As Object) As String
            If obj Is Nothing Then Return Nothing
            If IsDBNull(obj) Then Return Nothing
            Return obj.ToString
        End Function
        Public Function ValidateUser(objLoginBo) As String
            Dim strReturnVal As String
            Dim strPassword As String
            Dim DecPassword As String = objLoginBo.Password
            Dim strReturnURL As String
            strReturnVal = objLoginDo.ValidateUser(objLoginBo)
            strPassword = objEncryption.Encrypt(DecPassword, ConfigurationManager.AppSettings.Get("encKey"))
            If strReturnVal = "1" Then
                Return "1"
            Else
                strPassword = objEncryption.Decrypt(strReturnVal.Replace(" ", "+"), ConfigurationManager.AppSettings.Get("encKey"))
                If DecPassword = strPassword Then
                    HttpContext.Current.Session.RemoveAll()
                    HttpContext.Current.Session("Current_Language") = UCase(ConfigurationManager.AppSettings.Get("language")).ToString.Trim
                    HttpContext.Current.Session("Decimal_Seperator") = ConfigurationManager.AppSettings.Get("ReportDecimalSeperator").ToString.Trim
                    HttpContext.Current.Session("Thousand_Seperator") = ConfigurationManager.AppSettings.Get("ReportThousandSeperator").ToString

                    Try
                        If MsgErrorHndlr.AppPath Is Nothing Then
                            Dim Apath, ResPath As String
                            Apath = HttpContext.Current.Server.MapPath(System.Web.HttpRuntime.AppDomainAppVirtualPath.ToString())
                            ResPath = System.Configuration.ConfigurationManager.AppSettings("Resources")
                            MsgErrorHndlr.AppPath = Apath + ResPath
                        End If
                    Catch ex As Exception
                        objErrHandle.WriteErrorLog(1, "frmLogin", "Process - Reset AppPath", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                    End Try

                    HttpContext.Current.Session("UserId") = objLoginBo.UserId
                    HttpContext.Current.Session("AppPath") = Path.Combine(HttpContext.Current.Request.ApplicationPath, "frmLogin.aspx")
                    System.Web.HttpContext.Current.Application("AppPath") = "~"
                    System.Web.HttpContext.Current.Application("AppPhyPath") = Path.Combine(System.Web.HttpRuntime.AppDomainAppPath, "frmLogin.aspx")

                    HttpContext.Current.Session.Item("LogonTime") = "Welcome " & objLoginBo.UserId & ", " & MonthName(Month(Date.Today)) & " " & Day(Date.Today) & "," & Year(Date.Today) & " " & Now.ToShortTimeString()
                    '
                    ' Call the Authentication Function
                    strReturnURL = frmAuthenticationFun()
                    ' Setting the forms authentications
                    Dim DsUserPer As DataSet
                    Dim DsUserScr As DataSet
                    Dim DrUserScr As DataRow
                    Dim DrUser As DataRow

                    dsUserDetails = objLoginDo.GetUserDetails(objLoginBo)
                    If Not dsUserDetails Is Nothing Then
                        If dsUserDetails.Tables(0).Rows.Count > 0 Then
                            DrUser = dsUserDetails.Tables(0).Rows(0)
                            HttpContext.Current.Session("UserSubsidiary") = GetStringValue(DrUser("ID_SUBSIDERY_USER"))
                            HttpContext.Current.Session("UserSubsidiaryName") = GetStringValue(DrUser("SUB_NAME"))
                            If GetStringValue(DrUser("ID_DEPT_USER")) Is Nothing Then
                                HttpContext.Current.Session("UserDept") = ""
                            Else
                                HttpContext.Current.Session("UserDept") = GetStringValue(DrUser("ID_DEPT_USER"))
                                HttpContext.Current.Session("DeptName") = GetStringValue(DrUser("DeptName"))
                            End If
                            HttpContext.Current.Session("UserAdmin") = DrUser("ADMIN")
                            HttpContext.Current.Session("UserSubAdmin") = DrUser("SUBADMIN")
                            HttpContext.Current.Session("UserDeptAdmin") = DrUser("DEPTADMIN")
                        End If
                    End If
                    DsUserPer = ObjConfigRoleDO.GetUserScreenAccess(HttpContext.Current.Session("UserId"))
                    DsUserScr = ObjConfigRoleDO.GetUserStartScreen(HttpContext.Current.Session("UserId"))
                    DrUserScr = DsUserScr.Tables(0).Rows(0)
                    Dim i As Integer
                    Dim StartScr As String = "~"
                    i = Convert.ToInt16(DrUserScr(1).ToString())
                    StartScr += DrUserScr(0).ToString()
                    objUserPer = objUserPerDO.GetUserScrPer(DsUserPer.Tables(0), i)
                    HttpContext.Current.Session("UserPageperDT") = DsUserPer.Tables(0)
                    StartScr = StartScr
                    redirectUrl = StartScr

                    DsUserPer = objLoginDo.GetPageAcess(objLoginBo)
                    HttpContext.Current.Session("UserPageperDT") = DsUserPer.Tables(2)

                    If DsUserPer.Tables.Count > 3 Then
                        HttpContext.Current.Session("UserControlperDT") = DsUserPer.Tables(3)
                    Else
                        HttpContext.Current.Session("UserControlperDT") = Nothing
                    End If
                    If DsUserPer.Tables.Count > 4 And DsUserPer.Tables(4).Rows.Count > 0 Then
                        HttpContext.Current.Session("USESUBRPCODE") = DsUserPer.Tables(4).Rows(0)("DESCRIPTION")
                    Else
                        HttpContext.Current.Session("USESUBRPCODE") = Nothing
                    End If
                    'End of Modification

                    If DsUserPer.Tables.Count > 5 And DsUserPer.Tables(5).Rows.Count > 0 Then
                        HttpContext.Current.Session("USEJOBCARD") = DsUserPer.Tables(5).Rows(0)("DESCRIPTION")
                    Else
                        HttpContext.Current.Session("USEJOBCARD") = Nothing
                    End If

                    objUserPer = commonUtil.GetUserScrPer(DsUserPer.Tables(2), StartScr)
                    HttpContext.Current.Session("UserPerDetails") = objUserPer
                Else
                    Try
                        If MsgErrorHndlr.AppPath Is String.Empty Then
                            Dim Apath, ResPath As String
                            Apath = HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath.ToString())
                            ResPath = System.Configuration.ConfigurationManager.AppSettings("Resources")
                            MsgErrorHndlr.AppPath = Apath + ResPath
                        End If
                    Catch ex As Exception
                        objErrHandle.WriteErrorLog(1, "frmLogin", "Page_load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
                    End Try

                    'RTLblErr.Text = objErrHandle.GetErrorDesc("PWDID")
                    redirectUrl = "1" 'objErrHandle.GetErrorDesc("PWDID")

                End If
                Return redirectUrl
            End If
        End Function

#Region "frmAuthenticationFun()"
        Public Function frmAuthenticationFun() As String
            Dim strRole As String = ""
            Dim RedirURl As String = ""
            Dim SessionInfo As System.Web.Configuration.SessionStateSection = ConfigurationManager.GetSection("system.web/sessionState")
            Dim sTimeOut As Integer = SessionInfo.Timeout.TotalMinutes
            sTimeOut = sTimeOut + 5
            If sTimeOut.ToString() = "" Or sTimeOut = 0 Then
                sTimeOut = 65
            End If
            Try
                FormsAuthentication.Initialize()
                'The AddMinutes determines how long the user will be logged in after leaving
                'the site if he doesn't log off.

                Dim fat As FormsAuthenticationTicket = New FormsAuthenticationTicket(1, _
                HttpContext.Current.Session("userId"), DateTime.Now, _
                DateTime.Now.AddMinutes(sTimeOut), False, strRole, _
                FormsAuthentication.FormsCookiePath)

                HttpContext.Current.Response.Cookies.Add(New HttpCookie(FormsAuthentication.FormsCookieName, _
                FormsAuthentication.Encrypt(fat)))

                RedirURl = FormsAuthentication.GetRedirectUrl(HttpContext.Current.Session("userId"), False)
            Catch exth As System.Threading.ThreadAbortException
                Throw exth
            Catch ex As Exception
                objErrHandle.WriteErrorLog(1, "frmLogin", "frmAuthenticationFun", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, HttpContext.Current.Session("UserID"))
            End Try
            Return RedirURl
        End Function
#End Region
#End Region
    End Class
    Public Class PasswordDetails
        Dim oConfigUserBO As New ConfigUsersBO
        Dim oConfigUserDO As New CARS.ConfigUsers.ConfigUsersDO
        Public Function SavePassword(oConfigUserBO) As String
            Dim strStatus As String
            strStatus = oConfigUserDO.Update_User_PWD(oConfigUserBO)
            Return strStatus
        End Function
        Public Function FetchUser(oConfigUserBO) As DataSet
            Dim dsFetchUser As DataSet
            dsFetchUser = oConfigUserDO.Fetch_User(oConfigUserBO)
            Return dsFetchUser
        End Function
    End Class
    Public Class MenuDetails
        Dim oConfigUserPermBO As New UserAccessPermissionsBO
        Dim oConfigUserPermDO As New CARS.UserAccessPermissions.UserAccessPermissionsDO
        Public Function GetTopMenuDetails(oConfigUserPermBO) As DataSet
            Dim dsMenu As DataSet
            dsMenu = oConfigUserPermDO.GetTopMenuDetails(oConfigUserPermBO)
            Return dsMenu
        End Function
    End Class
End Namespace

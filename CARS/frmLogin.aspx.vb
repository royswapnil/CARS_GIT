Imports System.Web.Security
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports Encryption
Imports System.Resources
Imports System.Reflection
Imports Msgcommon
Imports CARS.CoreLibrary.CARS

Partial Class frmLogin
    Inherits System.Web.UI.Page
#Region " Members Variable "
    Dim objUserPer As New CARS.CoreLibrary.UserAccessPermissionsBO
    Dim objErrHandle As New MsgErrorHndlr
    Dim objLoginBo As New CARS.CoreLibrary.LoginBO
    Dim screenName As String
    Dim _isRefresh As Boolean
    Dim strReturnVal As String
    Shared commonUtil As New Utilities.CommonUtility
#End Region
#Region "Process"
    Private Sub Process()
        RTLblErr.Text = " "
        RTLblErr.Visible = True
        Dim strReturnURL As String = ""
        Dim strErrorMess As String = ""
        Try
            If MsgErrorHndlr.AppPath Is String.Empty Then
                Dim Apath, ResPath As String
                Apath = HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath.ToString())
                ResPath = System.Configuration.ConfigurationManager.AppSettings("Resources")
                MsgErrorHndlr.AppPath = Apath + ResPath
            End If
            'called for retrieving the Error mesagses from DataBase
            objLoginBo.UserId = txtUserName.Text.Trim
            objLoginBo.Password = txtPassword.Text
            Dim objService As New CARS.CoreLibrary.CARS.Services.Login.Login
            strReturnVal = objService.ValidateUser(objLoginBo)
            If strReturnVal = "1" Then
                RTLblErr.Text = objErrHandle.GetErrorDesc("PWDID")
            Else
                If RbhireView.Checked = True Then
                    Response.Redirect(Request.ApplicationPath + "/master/frmSiteMapHire.aspx")
                ElseIf RbroleView.Checked = True Then
                    Response.Redirect(Request.ApplicationPath + "/master/frmSiteMapRole.aspx")
                Else
                    Response.Redirect(strReturnVal)
                End If
            End If
        Catch exth As System.Threading.ThreadAbortException
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmLogin", "Process", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("userId"))
        End Try
    End Sub
#End Region

#Region "Password Change"
    Protected Sub txtPassword_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPassword.TextChanged
        If _isRefresh.ToString = "True" Then
            Exit Sub
        End If
        Process()
    End Sub
#End Region

#Region "page load"
    '*********************************************************************************
    '  Name of Event         		:  Page_Load
    '  Description            		:  Page Load Events
    '  Input Params           		:  
    '  Output Params          		:  -
    '  I/O Params             		:  - 
    '  Globals Used           		:  -
    '  Routines Called        		:  - objects,System.EventArgs
    '*********************************************************************************
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dsLang As New DataSet
        Dim screenName As String
        Dim dtCaption As DataTable
        Try
            screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            If _isRefresh.ToString = "True" Then
                txtUserName.Text = ""
                RTLblErr.Visible = False
                Exit Sub
            End If
            If Not Page.IsPostBack Then
                screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
                dsLang = commonUtil.RetrieveErrMsgs(screenName)
                Session.RemoveAll()
                Session("Current_Language") = ConfigurationManager.AppSettings.Get("language").ToString.Trim
                Session("Decimal_Seperator") = ConfigurationManager.AppSettings.Get("ReportDecimalSeperator").ToString.Trim
                Session("Thousand_Seperator") = ConfigurationManager.AppSettings.Get("ReportThousandSeperator").ToString

                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                lblLogintosys.Text = dtCaption.Select("TAG='lblLogintosys'")(0)(1)
                lblLanguage.Text = dtCaption.Select("TAG='lblLanguage'")(0)(1)
                lbluser.Text = dtCaption.Select("TAG='lbluser'")(0)(1)
                lblpass.Text = dtCaption.Select("TAG='lblPassword'")(0)(1)
                LnkLogin.Text = dtCaption.Select("TAG='lblLogintosys'")(0)(1)
                Page.Title = dtCaption.Select("TAG='lblLoginTitle'")(0)(1)
            End If
            If MsgErrorHndlr.AppPath Is String.Empty Then
                Dim Apath, ResPath As String
                Apath = HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath.ToString())
                ResPath = System.Configuration.ConfigurationManager.AppSettings("Resources")
                MsgErrorHndlr.AppPath = Apath + ResPath
            End If
            Page.Title = LnkLogin.Text
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "frmLogin", "Page_load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, Session("userId"))
        End Try
    End Sub

#End Region
End Class

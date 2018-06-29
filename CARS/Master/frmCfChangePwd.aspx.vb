Imports System.Data
Imports Encryption
Imports System.Web.Services
Imports CARS.CoreLibrary.CARS

Public Class frmCfChangePwd
    Inherits System.Web.UI.Page
    Shared objConfigUserBO As New CARS.CoreLibrary.ConfigUsersBO
    Shared objConfigUserDO As New ConfigUsers.ConfigUsersDO
    Shared objErrHandle As New MSGCOMMON.MsgErrorHndlr
    Dim dsReturnval As New DataSet
    Dim strErr As String
    Shared objEncryption As New Encryption64
    Shared objService As New CARS.CoreLibrary.CARS.Services.Login.PasswordDetails
    Dim screenName As String
    Shared loginName As String
    Shared password As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim dtCaption As DataTable
            Session.Item("id") = Nothing
            loginName = CType(Session("UserID"), String)
            If Session("UserID") Is Nothing Then
                Response.Redirect("~/frmLogin.aspx")
            Else
                loginName = CType(Session("UserID"), String)
            End If
            screenName = IO.Path.GetFileName(Me.Request.PhysicalPath)
            If Not Page.IsPostBack Then
                dtCaption = DirectCast(Cache("Caption"), System.Data.DataTable)
                btnSave.Value = dtCaption.Select("TAG='btnSave'")(0)(1)
                btnReset.Value = dtCaption.Select("TAG='btnReset'")(0)(1)
                lblChngPwd.Text = dtCaption.Select("TAG='lblChngPwd'")(0)(1)
                lblConfirmPassword.Text = dtCaption.Select("TAG='lblConfirmPassword'")(0)(1)
                lblLoginName.Text = dtCaption.Select("TAG='lblLoginName'")(0)(1)
                lblNewPassword.Text = dtCaption.Select("TAG='lblNewPassword'")(0)(1)
                lblOldPassword.Text = dtCaption.Select("TAG='lblOldPassword'")(0)(1)
                aheader.InnerText = dtCaption.Select("TAG='lblChngPwd'")(0)(1)
                Page.Title = dtCaption.Select("TAG='lblChngPwd'")(0)(1)
                FetchUser(loginName)
            End If
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfChangePwd", "Page_Load", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
    End Sub
    '**********************************************************************
    '  Name of Method         		:	FetchUser()
    '  Description            		:	This method is used to fetch the user
    '									login details
    '  Input Params           		:	-
    '  Output Params          		:	-
    '  I/O Params             		:   -   
    '  Globals Used           		:	-
    '  Routines Called        		:	-
    '***********************************************************************
    Private Sub FetchUser(ByVal idlogin As String)
        Dim dsretval As New DataSet
        Try
            objConfigUserBO.Id_Login = idlogin
            dsReturnval = objService.FetchUser(objConfigUserBO)
            If dsReturnval.Tables(0).Rows.Count > 0 Then
                txtLoginName.Text = IIf(IsDBNull(dsReturnval.Tables(0).Rows(0)("ID_Login".ToString)) = True, "", dsReturnval.Tables(0).Rows(0)("ID_Login".ToString))
                txtLoginName.ReadOnly = True
                txtNewPassword.Text = ""
                txtOldPassword.Text = ""
                txtConfirm.Text = ""
                password = objEncryption.Decrypt(IIf(IsDBNull(dsReturnval.Tables(0).Rows(0)("Password".ToString)) = True, "", dsReturnval.Tables(0).Rows(0)("Password".ToString)), ConfigurationManager.AppSettings.Get("encKey"))

            End If
        Catch exth As System.Threading.ThreadAbortException
            Throw exth
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfChangePwd", "FetchUser", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
            Throw ex
        End Try
    End Sub
    <WebMethod()> _
    Public Shared Function SavePassword(ByVal Login As String, ByVal NewPassword As String, ByVal OldPassword As String) As CARS.CoreLibrary.LoginDetails()
        Dim dt As New DataTable()
        Dim strSucStatus As String = ""
        Dim strFlStatus As String = ""
        Dim detailsclsPwdcode As New List(Of CARS.CoreLibrary.LoginDetails)()
        Dim objUtility As New CARS.CoreLibrary.CARS.Utilities.CommonUtility
        Try
            If password = OldPassword Then
                objConfigUserBO.Id_Login = Login
                objConfigUserBO.Created_By = loginName
                objConfigUserBO.Password = objEncryption.Encrypt(objUtility.fnReplaceSQL(NewPassword), ConfigurationManager.AppSettings.Get("encKey"))
                strSucStatus = objService.SavePassword(objConfigUserBO)
                If strSucStatus = "UPDFLG" Then
                    strSucStatus = objErrHandle.GetErrorDesc("MSG043")
                    HttpContext.Current.Session.RemoveAll()
                ElseIf strSucStatus = "UPDERR" Then
                    strSucStatus = objErrHandle.GetErrorDesc("MSG042")
                End If
            Else
                strFlStatus = objErrHandle.GetErrorDesc("MSG041")
            End If
            Dim PwdDet As New CARS.CoreLibrary.LoginDetails()
            If strFlStatus = "" Then
                PwdDet.Updated = strSucStatus
                PwdDet.NotUpdated = ""
            Else
                PwdDet.Updated = ""
                PwdDet.NotUpdated = strFlStatus
            End If
            detailsclsPwdcode.Add(PwdDet)
        Catch ex As Exception
            objErrHandle.WriteErrorLog(1, "Master_frmCfChangePwd", "FetchUser", ex.Message, ex.GetBaseException.StackTrace.ToString.Trim, loginName)
        End Try
        Return detailsclsPwdcode.ToList.ToArray()
    End Function
End Class